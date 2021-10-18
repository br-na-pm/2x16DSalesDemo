
PROGRAM _CYCLIC

	IF NOT gLoadStIf.Cmd.LocalOverride THEN
		stationPars := gProcessRecipe.Load;
	END_IF
	
	stationFbs.PosGen.MaxPosSlewRate := gProcessPickPlaceIf.Par.SyncSpeed.Vel;
	stationFbs.PosGen.MaxNegSlewRate := gProcessPickPlaceIf.Par.SyncSpeed.Vel;
	
	CASE state OF
		LOAD_OFF: //********************************************************************************Load station is currently disabled
			IF gLoadStIf.Cmd.Enable THEN
				startupCounter := 0;
				state := LOAD_INIT;
			ELSIF gLoadStIf.Cmd.Reset THEN
				state := LOAD_ERROR;
			END_IF
		LOAD_INIT: //********************************************************************************Load station is initalizing
			gLoadStIf.Sts.ReadyForNewShuttle := TRUE;
			gLoadStIf.Sts.Enabled := TRUE;
						
			startupCounter := 0;
			
			gProcessPickPlaceIf.Par.NextProduct := PROD_DOSING;
			
			state := LOAD_WAIT_FOR_SHUTTLE;	
		LOAD_WAIT_FOR_SHUTTLE: //********************************************************************************Load station is waiting for a shuttle to be present
			//This is a hacky fix to try and fix a SV issue, that's all..
			IF startupCounter < 8 AND NOT gProcessPickPlaceIf.Sts.UnfinishedProductPresent AND gMainIf.Cfg.EnableRobot AND NOT gProcessPickPlaceIf.Cmd.GetLoadPart THEN
				gProcessPickPlaceIf.Sts.RobotProduct := gProcessPickPlaceIf.Par.NextProduct;
			END_IF
			
			IF NOT gLoadStIf.Cmd.Enable THEN
				gLoadStIf.Sts.ReadyForNewShuttle := FALSE;
				gLoadStIf.Sts.Enabled := FALSE;
				state := LOAD_OFF;
			ELSIF startupCounter < 7 AND NOT gProcessPickPlaceIf.Sts.UnfinishedProductPresent AND gMainIf.Cfg.EnableRobot AND NOT gProcessPickPlaceIf.Cmd.GetLoadPart THEN
				gProcessPickPlaceIf.Cmd.GetLoadPart := TRUE;
				gProcessPickPlaceIf.Sts.RobotProduct := gProcessPickPlaceIf.Par.NextProduct;
			ELSIF gLoadStIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gLoadStIf.Cmd.Process THEN
				gLoadStIf.Sts.ReadyForNewShuttle := FALSE;
				gLoadStIf.Sts.Processing := TRUE;
				
				stationFbs.PosGen.Enable := TRUE;
				stationFbs.PosGen.In := 0;
				stationFbs.PosGen.MaxPosSlewRate := gProcessPickPlaceIf.Par.SyncSpeed.Vel;
				stationFbs.PosGen.MaxNegSlewRate := gProcessPickPlaceIf.Par.SyncSpeed.Vel;
				
				state := LOAD_WAIT_CFG_IF;
			END_IF
		LOAD_WAIT_CFG_IF: //********************************************************************************Waiting for the channel configuration interface to be ready
			IF gCyclicChlCfgIf.Sts.Ready THEN
				
				gCyclicChlCfgIf.Cmds.Config := TRUE;
				gCyclicChlCfgIf.Pars.LoadShuttleIdx := gLoadStIf.Par.ShuttleIdx;
				
				state := LOAD_CFG_CYCLIC_POS;
			END_IF
		LOAD_CFG_CYCLIC_POS: //********************************************************************************Waiting for the channel configuration to be configured
			IF gCyclicChlCfgIf.Sts.Ready THEN //Cyclic Channel is configured, we can go ahead and start reading the position
				stationFbs.ReadCyclicPos.Controller := ADR(gMcAcp6DController);
				stationFbs.ReadCyclicPos.ChannelID := 1;
				stationFbs.ReadCyclicPos.AxisID := 1;
				
				stationFbs.ReadCyclicPos.Enable := TRUE;
				
				stationFbs.RunMacro.Controller := ADR(gMcAcp6DController);
				stationFbs.RunMacro.MacroID := 150;
				stationFbs.RunMacro.ShuttleID := gShuttleIf[gLoadStIf.Par.ShuttleIdx].Cfg.ShuttleId;
			//	stationFbs.RunMacro.Execute := TRUE;
				
				logArgs[0] := ADR(gShuttleIf[gLoadStIf.Par.ShuttleIdx].Cfg.ShuttleId);
				logDebug('LoadSt','ShID %d attempted to read CyclicPos and RunLoadMacro',ADR(logArgs));
				
				state := LOAD_WAIT_ROBOT;
			END_IF
		LOAD_WAIT_ROBOT: //********************************************************************************Waiting for the robot to be ready to load state
			//Waiting for the robot to be ready to pick or alternatively the position value to pass the 'end position'
			IF gDelta.Status.Error THEN
				state := LOAD_ERROR;
			ELSIF gShuttleIf[gLoadStIf.Par.ShuttleIdx].Sts.ShuttleInfo.Position.Value.X >= gProcessRecipe.Load.EndPos.X 
					AND stationFbs.ReadCyclicPos.Valid THEN //This should only really happen when we're not using the robot
				logArgs[0] := ADR(gShuttleIf[gLoadStIf.Par.ShuttleIdx].Cfg.ShuttleId);
				logDebug('LoadSt','ShID %d Position passed endpoint with no robot being ready, skipping load.',ADR(logArgs));			
				
				stationFbs.Stop.Controller := ADR(gMcAcp6DController);
				stationFbs.Stop.Execute := TRUE;
				stationFbs.Stop.ShuttleID := gShuttleIf[gLoadStIf.Par.ShuttleIdx].Cfg.ShuttleId;
				
				state := LOAD_CLEAR_BUFFER;
			ELSIF gProcessPickPlaceIf.Sts.ReadyForLoad AND stationFbs.ReadCyclicPos.Valid AND NOT gProcessPickPlaceIf.Sts.Sync THEN
				logArgs[0] := ADR(gShuttleIf[gLoadStIf.Par.ShuttleIdx].Cfg.ShuttleId);
				logDebug('LoadSt','ShID %d syncing with robot',ADR(logArgs));
				stationFbs.PathInfluence.PositionOffset[0] :=  (stationFbs.ReadCyclicPos.Value) * 1000;
				stationFbs.PathInfluence.AxesGroup := ADR(g3AxDeltaA);
				stationFbs.PathInfluence.CoordSystem := mcMCS;
				stationFbs.PathInfluence.Enable := gProcessPickPlaceIf.Cmd.EnableTracking;
				
				gProcessPickPlaceIf.Cmd.PickLoad := TRUE;
				gProcessPickPlaceIf.Sts.Sync := TRUE;
				state := LOAD_LOADING;
			END_IF
		
		LOAD_LOADING: //********************************************************************************Waiting for the load to be complete
			stationFbs.PosGen.In := (stationFbs.ReadCyclicPos.Value - gLoadStIf.Cfg.StationPos.X) * 1000;
			stationFbs.PathInfluence.PositionOffset[0] :=  (stationFbs.ReadCyclicPos.Value) * 1000;
			
			IF NOT gProcessPickPlaceIf.Sts.UnfinishedProductPresent AND gProcessPickPlaceIf.Sts.Place THEN
				gShuttleIf[gLoadStIf.Par.ShuttleIdx].Sts.ProductState := gProcessPickPlaceIf.Par.NextProduct;
				gProcessPickPlaceIf.Sts.Place := FALSE;
			END_IF
			
			IF gDelta.Status.Error THEN
				gLoadStIf.Sts.Error := TRUE;
				state := LOAD_ERROR;
			ELSIF NOT gProcessPickPlaceIf.Sts.Sync THEN
				logArgs[0] := ADR(gShuttleIf[gLoadStIf.Par.ShuttleIdx].Cfg.ShuttleId);
				logDebug('LoadSt','ShID %d product removed from robot. Exiting macro movement',ADR(logArgs));
				
				stationFbs.PosGen.In := 0;
				
				gProcessPickPlaceIf.Cmd.PickLoad := FALSE;
				
				stationFbs.Stop.Controller := ADR(gMcAcp6DController);
				stationFbs.Stop.Execute := TRUE;
				stationFbs.Stop.ShuttleID := gShuttleIf[gLoadStIf.Par.ShuttleIdx].Cfg.ShuttleId;
								
				IF startupCounter <= 7 THEN
					startupCounter := startupCounter + 1;
					gProcessPickPlaceIf.Cmd.GetLoadPart := TRUE;
				END_IF
				
				IF startupCounter >= 8 AND NOT gUnloadStIf.Sts.Enabled AND NOT gProcessPickPlaceIf.Sts.StartupComplete THEN
					gUnloadStIf.Cmd.Enable := TRUE;
					gProcessPickPlaceIf.Cmd.GetLoadPart := FALSE;
					gProcessPickPlaceIf.Sts.StartupComplete := TRUE;
					gProcessPickPlaceIf.Sts.ReadyForUnload := TRUE;
				END_IF
				
				state := LOAD_CLEAR_BUFFER;
			END_IF
			
		LOAD_CLEAR_BUFFER: //********************************************************************************Waiting for the buffer to be cleared
			IF stationFbs.Stop.Error THEN
				logArgs[0] := ADR(stationFbs.ClearBuffer.ErrorID);
				logError('LoadStation','Sh%d had error %d clearing buffer at the load station',ADR(logArgs));
				gLoadStIf.Sts.Error := TRUE;
				
				state := LOAD_ERROR;
			ELSIF stationFbs.Stop.Done THEN
				stationFbs.RunMacro.Execute := FALSE;
				stationFbs.ReadCyclicPos.Enable := FALSE;
				stationFbs.Stop.Execute := FALSE;
				
				gShuttleIf[gLoadStIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;
				
				gLoadStIf.Sts.Processing := FALSE;
				gLoadStIf.Sts.Done := TRUE;
								
				state := LOAD_DONE;
			END_IF	
		LOAD_DONE: //********************************************************************************Load station is done with the load process
			IF NOT gLoadStIf.Cmd.Enable THEN
				gLoadStIf.Sts.Done := FALSE;
				gLoadStIf.Sts.Enabled := FALSE;
				gLoadStIf.Sts.ReadyForNewShuttle := FALSE;
				stationFbs.Timer.IN := FALSE;
				
				gLoadStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				state := LOAD_OFF;
			ELSE
				IF gProcessPickPlaceIf.Par.NextProduct = PROD_DOSING THEN
					gProcessPickPlaceIf.Par.NextProduct := PROD_CUBE;
				ELSE
					gProcessPickPlaceIf.Par.NextProduct := PROD_DOSING;
				END_IF
				
				gLoadStIf.Cmd.Process := FALSE;
				gLoadStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gLoadStIf.Sts.Done := FALSE;
				gLoadStIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := LOAD_WAIT_FOR_SHUTTLE;
			END_IF
			
		LOAD_ERROR: //********************************************************************************Load station had an error
			IF gLoadStIf.Cmd.Reset THEN
				gLoadStIf.Cmd.Reset := FALSE;
				
				startupCounter := 0;
				
				gLoadStIf.Sts.Done := FALSE;
				gLoadStIf.Sts.Enabled := FALSE;
				gLoadStIf.Sts.Error := FALSE;
				gLoadStIf.Sts.Processing := FALSE;
				gLoadStIf.Sts.ReadyForNewShuttle := FALSE;
				
				stationFbs.RunMacro.Execute := FALSE;
				stationFbs.ReadCyclicPos.Enable := FALSE;
				stationFbs.ClearBuffer.Execute := FALSE;
				stationFbs.Stop.Execute := FALSE;
				stationFbs.Timer.IN := FALSE;
				stationFbs.PathInfluence.Enable := FALSE;
				
				gLoadStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF gLoadStIf.Cmd.Enable THEN
					state := LOAD_INIT;
				ELSE
					state := LOAD_OFF;
				END_IF
			END_IF
	END_CASE;
		
	IF NOT gProcessPickPlaceIf.Sts.Sync AND stationFbs.PosGen.Out <= 0.1 AND stationFbs.PosGen.Out >= -0.1 THEN
		stationFbs.PathInfluence.Enable := FALSE;
	END_IF
	stationFbs.PathInfluence.PositionOffset[0] := stationFbs.PosGen.Out;
	
	stationFbs.RunMacro();
	stationFbs.ReadCyclicPos();
	stationFbs.Stop();
	stationFbs.ClearBuffer();
	stationFbs.PosGen();
	stationFbs.Timer();
	stationFbs.PathInfluence();
END_PROGRAM
