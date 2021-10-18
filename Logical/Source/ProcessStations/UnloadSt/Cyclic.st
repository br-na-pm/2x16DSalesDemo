
PROGRAM _CYCLIC

	IF NOT gUnloadStIf.Cmd.LocalOverride THEN
		stationPars := gProcessRecipe.Unload;
	END_IF
	
	CASE state OF
		UNLOAD_OFF: //********************************************************************************Load station is currently disabled
			IF gUnloadStIf.Cmd.Enable THEN
				state := UNLOAD_INIT;
			ELSIF gUnloadStIf.Cmd.Reset THEN
				state := UNLOAD_ERROR;
			END_IF
		UNLOAD_INIT: //********************************************************************************Load station is initalizing
			gUnloadStIf.Sts.ReadyForNewShuttle := TRUE;
			gUnloadStIf.Sts.Enabled := TRUE;
			
			state := UNLOAD_WAIT_FOR_SHUTTLE;	
		UNLOAD_WAIT_FOR_SHUTTLE: //********************************************************************************Load station is waiting for a shuttle to be present
			IF NOT gUnloadStIf.Cmd.Enable THEN
				gUnloadStIf.Sts.ReadyForNewShuttle := FALSE;
				gUnloadStIf.Sts.Enabled := FALSE;
				state := UNLOAD_OFF;
			ELSIF gUnloadStIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gUnloadStIf.Cmd.Process THEN
				gUnloadStIf.Sts.ReadyForNewShuttle := FALSE;
				gUnloadStIf.Sts.Processing := TRUE;
				gProcessPickPlaceIf.Sts.RobotProduct := gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Sts.ProductState;
				
				state := UNLOAD_WAIT_CFG_IF;
			END_IF
		UNLOAD_WAIT_CFG_IF: //********************************************************************************Waiting for the channel configuration interface to be ready
			IF gCyclicChlCfgIf.Sts.Ready THEN
				gCyclicChlCfgIf.Cmds.Config := TRUE;
				gCyclicChlCfgIf.Pars.UnloadShuttleIdx := gUnloadStIf.Par.ShuttleIdx;
				
				state := UNLOAD_CFG_CYCLIC_POS;
			END_IF
		UNLOAD_CFG_CYCLIC_POS: //********************************************************************************Waiting for the channel configuration to be configured
			IF gCyclicChlCfgIf.Sts.Ready THEN //Cyclic Channel is configured, we can go ahead and start reading the position
				stationFbs.ReadCyclicPos.Controller := ADR(gMcAcp6DController);
				stationFbs.ReadCyclicPos.ChannelID := 2;
				stationFbs.ReadCyclicPos.AxisID := 1;
				
				stationFbs.ReadCyclicPos.Enable := TRUE;
				
				stationFbs.RunMacro.Controller := ADR(gMcAcp6DController);
				stationFbs.RunMacro.MacroID := 150;
				stationFbs.RunMacro.ShuttleID := gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Cfg.ShuttleId;
			//	stationFbs.RunMacro.Execute := TRUE;
				
				logArgs[0] := ADR(gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Cfg.ShuttleId);
				logDebug('UnloadSt','ShID %d attempted to read CyclicPos and RunUnloadMacro',ADR(logArgs));
				
				state := UNLOAD_WAIT_ROBOT;
			END_IF
		UNLOAD_WAIT_ROBOT: //********************************************************************************Waiting for the robot to be ready to unload state
			//Waiting for the robot to be ready to pick or alternatively the position value to pass the 'end position'
			IF gDelta.Status.Error THEN
				state := UNLOAD_ERROR;
			ELSIF gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Sts.ShuttleInfo.Position.Value.X >= gProcessRecipe.Unload.EndPos.X 
					AND stationFbs.ReadCyclicPos.Valid THEN //This should only really happen when we're not using the robot
				logArgs[0] := ADR(gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Cfg.ShuttleId);
				logDebug('UnloadSt','ShID %d Position passed endpoint with no robot being ready, skipping unload.',ADR(logArgs));				
				
				stationFbs.Stop.Controller := ADR(gMcAcp6DController);
				stationFbs.Stop.Execute := TRUE;
				stationFbs.Stop.ShuttleID := gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Cfg.ShuttleId;
				
				state := UNLOAD_CLEAR_BUFFER;
			ELSIF gProcessPickPlaceIf.Sts.ReadyForUnload AND stationFbs.ReadCyclicPos.Valid AND NOT gProcessPickPlaceIf.Sts.Sync THEN
				logArgs[0] := ADR(gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Cfg.ShuttleId);
				logDebug('UnloadSt','ShID %d syncing with robot',ADR(logArgs));
				stationFbs.PathInfluence.AxesGroup := ADR(g3AxDeltaA);
				stationFbs.PathInfluence.CoordSystem := mcMCS;
				stationFbs.PathInfluence.Enable := gProcessPickPlaceIf.Cmd.EnableTracking;
				
				gProcessPickPlaceIf.Cmd.PickUnload := TRUE;
				gProcessPickPlaceIf.Sts.Sync := TRUE;
				state := UNLOAD_UNLOADING;
			END_IF
		
		UNLOAD_UNLOADING: //********************************************************************************Waiting for the unload to be complete
			stationFbs.PathInfluence.PositionOffset[0] := (stationFbs.ReadCyclicPos.Value - gUnloadStIf.Cfg.StationPos.X) * 1000 ;
			IF gDelta.Status.Error THEN
				state := UNLOAD_ERROR;
			ELSIF NOT gProcessPickPlaceIf.Sts.Sync THEN
				logArgs[0] := ADR(gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Cfg.ShuttleId);
				logDebug('UnloadSt','ShID %d product removed from shuttle. Exiting macro movement',ADR(logArgs));
												
				stationFbs.PathInfluence.Enable := FALSE;
				stationFbs.PathInfluence.PositionOffset[0] := 0;
				gProcessPickPlaceIf.Cmd.PickUnload := FALSE;
				
				stationFbs.Stop.Controller := ADR(gMcAcp6DController);
				stationFbs.Stop.Execute := TRUE;
				stationFbs.Stop.ShuttleID := gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Cfg.ShuttleId;
				
				state := UNLOAD_CLEAR_BUFFER;
			END_IF
			
		UNLOAD_CLEAR_BUFFER: //********************************************************************************Waiting for the buffer to be cleared
			IF stationFbs.Stop.Error THEN
				logArgs[0] := ADR(stationFbs.ClearBuffer.ErrorID);
				logError('UnloadStation','Sh%d had error %d clearing buffer at the unload station',ADR(logArgs));
				gUnloadStIf.Sts.Error := TRUE;
				
				state := UNLOAD_ERROR;
			ELSIF stationFbs.Stop.Done THEN
				stationFbs.RunMacro.Execute := FALSE;
				stationFbs.ReadCyclicPos.Enable := FALSE;
				stationFbs.Stop.Execute := FALSE;
				
				gUnloadStIf.Sts.Processing := FALSE;
				gUnloadStIf.Sts.Done := TRUE;
				gShuttleIf[gUnloadStIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;	
				
				state := UNLOAD_DONE;
			END_IF	
		UNLOAD_DONE: //********************************************************************************Load station is done with the load process
			IF NOT gUnloadStIf.Cmd.Enable THEN
				gUnloadStIf.Sts.Done := FALSE;
				gUnloadStIf.Sts.Enabled := FALSE;
				gUnloadStIf.Sts.ReadyForNewShuttle := FALSE;
				stationFbs.Timer.IN := FALSE;
				
				gUnloadStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				state := UNLOAD_OFF;
			ELSE
				gUnloadStIf.Cmd.Process := FALSE;
				gUnloadStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gUnloadStIf.Sts.Done := FALSE;
				gUnloadStIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := UNLOAD_WAIT_FOR_SHUTTLE;
			END_IF
			
		UNLOAD_ERROR: //********************************************************************************Load station had an error
			IF gUnloadStIf.Cmd.Reset THEN
				gUnloadStIf.Cmd.Reset := FALSE;
				
				gUnloadStIf.Sts.Done := FALSE;
				gUnloadStIf.Sts.Enabled := FALSE;
				gUnloadStIf.Sts.Error := FALSE;
				gUnloadStIf.Sts.Processing := FALSE;
				gUnloadStIf.Sts.ReadyForNewShuttle := FALSE;
				
				stationFbs.RunMacro.Execute := FALSE;
				stationFbs.ReadCyclicPos.Enable := FALSE;
				stationFbs.ClearBuffer.Execute := FALSE;
				stationFbs.Stop.Execute := FALSE;
				stationFbs.Timer.IN := FALSE;
				stationFbs.PathInfluence.Enable := FALSE;
				
				gUnloadStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF gUnloadStIf.Cmd.Enable THEN
					state := UNLOAD_INIT;
				ELSE
					state := UNLOAD_OFF;
				END_IF
			END_IF
	END_CASE;
		
	stationFbs.RunMacro();
	stationFbs.ReadCyclicPos();
	stationFbs.ClearBuffer();
	stationFbs.Stop();
	stationFbs.Timer();
	stationFbs.PathInfluence();
END_PROGRAM
