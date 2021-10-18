
PROGRAM _CYCLIC
	//Task that handles the configuration of the cyclic channels
	
	//Idle
	//Config
	//Error
	
	
	CASE state OF
		CFG_IDLE:  //********************************************************************************Idle state - wait for command
			IF gCyclicChlCfgIf.Cmds.Config THEN
				gCyclicChlCfgIf.Sts.Configuring := TRUE;
				gCyclicChlCfgIf.Sts.Ready := FALSE;
				
				Fbs.CfgReadCyclicPos.Controller := ADR(gMcAcp6DController);
				Fbs.CfgReadCyclicPos.NumberOfChannels := 2;
								
				Fbs.CfgReadCyclicPos.ChannelID[0] := 1;
				Fbs.CfgReadCyclicPos.ChannelID[1] := 2;
				Fbs.CfgReadCyclicPos.FeedbackMode[0] := mcACP6D_READ_CYCLIC_POSITION;
				Fbs.CfgReadCyclicPos.FeedbackMode[1] := mcACP6D_READ_CYCLIC_POSITION;
				
				//We must always configure 2 channels. In order to make it easier, channel 1 will always be the "load" channel and channel 2 will be the unload channel.
				//This means however that if there is no current shuttle in the station, we must still keep the channel enabled, so we're just going to use shuttle IDs 1 and 2 in the event
				//that there is no shuttle present
				IF gCyclicChlCfgIf.Pars.LoadShuttleIdx <> STATION_IS_EMPTY THEN
					Fbs.CfgReadCyclicPos.ShuttleID[0] := gShuttleIf[gCyclicChlCfgIf.Pars.LoadShuttleIdx].Cfg.ShuttleId;
				ELSE
					Fbs.CfgReadCyclicPos.ShuttleID[0] := 1;
				END_IF
				IF gCyclicChlCfgIf.Pars.UnloadShuttleIdx <> STATION_IS_EMPTY THEN
					Fbs.CfgReadCyclicPos.ShuttleID[1] := gShuttleIf[gCyclicChlCfgIf.Pars.UnloadShuttleIdx].Cfg.ShuttleId;
				ELSE
					Fbs.CfgReadCyclicPos.ShuttleID[1] := 2;
				END_IF
				Fbs.CfgReadCyclicPos.Execute := TRUE;			
				
				state := CFG_CONFIG;
			END_IF
			
		CFG_CONFIG:  //********************************************************************************Configuration state - wait for status to report done/error
			IF Fbs.CfgReadCyclicPos.Error THEN
				logArgs[0] := ADR(Fbs.CfgReadCyclicPos.ShuttleID[0]);
				logArgs[1] := ADR(Fbs.CfgReadCyclicPos.ShuttleID[1]);
				logArgs[2] := ADR(Fbs.CfgReadCyclicPos.ErrorID);
				logFatal('CycChlCfg','Cyclic Channel configuration failed. Ch1 ID: %d CH2 ID: %d Error #: %d.',ADR(logArgs));
				state := CFG_ERROR;
			ELSIF Fbs.CfgReadCyclicPos.Done THEN
				gCyclicChlCfgIf.Cmds.Config := FALSE;
				gCyclicChlCfgIf.Sts.Configuring := FALSE;
				gCyclicChlCfgIf.Sts.Ready := TRUE;
				
				Fbs.CfgReadCyclicPos.Execute := FALSE;
				state := CFG_IDLE;
			END_IF
		CFG_ERROR:  //********************************************************************************Error State - wait for reset command
			Fbs.CfgReadCyclicPos.Execute := FALSE;
			
			//TODO: We'll need to reset the error flag (leaving it high just for debugging assistance)
			state := CFG_IDLE;
		
	END_CASE;
	//This is hard coded for 2 axes to get the X position cyclically for the two FBs
	
	 Fbs.CfgReadCyclicPos();
END_PROGRAM
