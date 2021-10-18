
PROGRAM _CYCLIC
	
	FOR i:= 0 TO gMainIf.Cfg.ShuttleCount - 1 DO
		IF NOT gShuttleIf[i].Cmd.Enable AND gShuttleIf[i].Sts.Active THEN			
			shState[i] := SH_RESET;
		END_IF
		
		CASE shState[i] OF
			SH_OFF:  //******************************************************************************** Shuttle is in the off/idle state
				IF gShuttleIf[i].Cmd.Enable THEN
					shState[i] := SH_INIT;
				ELSE
				
				END_IF
			SH_INIT:  //******************************************************************************** Shuttle is in the initilization state
				//In this state we could make any checks on the current shuttle process perhaps in order to aide in recovery?
				
				shState[i] := SH_STARTUP;
			SH_STARTUP:  //******************************************************************************** Shuttle is in the startup state
				//In this state maybe we have triggered recovery and we're waiting for the autodrive to complete
				shState[i] := SH_IDLE;
				
			SH_IDLE:  //************************* ******************************************************* Shuttle is in the idle state
				shFbs[i].MovePlane.Controller := ADR(gMcAcp6DController);
				shFbs[i].MovePlane.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
				shFbs[i].MovePlane.Velocity := gProcessRecipe.General.Velocity;
				shFbs[i].MovePlane.Acceleration := gProcessRecipe.General.Accel;
				shFbs[i].MovePlane.EndVelocity := 0;
				shFbs[i].MovePlane.PositionX := gLoadStIf.Cfg.StationPos.X;
				shFbs[i].MovePlane.PositionY := gLoadStIf.Cfg.StationPos.Y;
				shFbs[i].MovePlane.Mode := mcACP6D_MOVE_ABSOLUTE;
				shFbs[i].MovePlane.Path := mcACP6D_PATH_Y_THEN_X;
				shFbs[i].MovePlane.Execute := TRUE;
				
				gShuttleIf[i].Sts.Active := TRUE;
				gShuttleIf[i].Sts.CurrentDestination := DEST_LOAD;
				
				shState[i] := SH_GO_TO_LOAD;
			
			SH_GO_TO_LOAD: //******************************************************************************** Shuttle is moving to the load station
				IF shFbs[i].MovePlane.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					logArgs[0] := ADR(i);
					logArgs[1] := ADR(shFbs[i].MovePlane.ErrorID);
					logError('ShCtrl','Sh%d had error %d moving to load',ADR(logArgs));
					
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].MovePlane.Done AND (gLoadStIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gLoadStIf.Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gLoadStIf.Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gLoadStIf.Par.ShuttleIdx := i;
					gLoadStIf.Cmd.Process := TRUE;
				
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d arrived at Load',ADR(logArgs));
					
					shFbs[i].MovePlane.Execute := FALSE;
					shState[i] := SH_LOADING;
				END_IF
			SH_LOADING://******************************************************************************** Shuttle is at the load station
				IF gShuttleIf[i].Cmd.NextStep THEN
					gShuttleIf[i].Cmd.NextStep := FALSE;
					gLoadStIf.Cmd.Process := FALSE;
					
					gShuttleIf[i].Sts.LoopCounter := RandValueDINT(1,gProcessRecipe.General.St1St2Cycles);
					
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d Load complete',ADR(logArgs));
					
					shState[i] := SH_CHECK_RECIPE;
				END_IF
			SH_CHECK_RECIPE: //******************************************************************************** Shuttle is being checked for the recipe values
				IF gShuttleIf[i].Sts.LoopCounter <= 0 THEN
					shFbs[i].MovePlane.Controller := ADR(gMcAcp6DController);
					shFbs[i].MovePlane.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].MovePlane.Velocity := gProcessRecipe.General.Velocity;
					shFbs[i].MovePlane.Acceleration := gProcessRecipe.General.Accel;
					shFbs[i].MovePlane.EndVelocity := 0;
					
					shFbs[i].MovePlane.PositionX := gInspectIf.Cfg.StationPos.X;
					shFbs[i].MovePlane.PositionY := gInspectIf.Cfg.StationPos.Y;
					shFbs[i].MovePlane.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].MovePlane.Path := mcACP6D_PATH_X_THEN_Y;
					shFbs[i].MovePlane.Execute := TRUE;
					
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d sending to Inspect',ADR(logArgs));
						
					gShuttleIf[i].Sts.CurrentDestination := DEST_INSPECT;
					shState[i] := SH_GO_TO_INSPECT;
				ELSE
					
					shFbs[i].MovePlane.Controller := ADR(gMcAcp6DController);
					shFbs[i].MovePlane.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].MovePlane.Velocity := gProcessRecipe.General.Velocity;
					shFbs[i].MovePlane.Acceleration := gProcessRecipe.General.Accel;
					shFbs[i].MovePlane.EndVelocity := 0;
					
					shFbs[i].MovePlane.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].MovePlane.Path := mcACP6D_PATH_Y_THEN_X;
					shFbs[i].MovePlane.Execute := TRUE;
					
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d sending to Station 1',ADR(logArgs));
					
					gShuttleIf[i].Sts.CurrentDestination := DEST_PROCESS_1;
					shState[i] := SH_GO_TO_ST_1;
				END_IF
				
				
			SH_GO_TO_ST_1: //******************************************************************************** Shuttle is going to the #1 operating station
				IF shFbs[i].MovePlane.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					logArgs[0] := ADR(i);
					logArgs[1] := ADR(shFbs[i].MovePlane.ErrorID);
					logError('ShCtrl','Sh%d had error %d moving to Station 1',ADR(logArgs));
					
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].MovePlane.Done AND (gProcessStIf[STATION_1].Par.ShuttleIdx = STATION_IS_EMPTY AND gProcessStIf[STATION_1].Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gProcessStIf[STATION_1].Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gProcessStIf[STATION_1].Par.ShuttleIdx := i;
					gProcessStIf[STATION_1].Cmd.Process := TRUE;
				
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d arrived at Station 1',ADR(logArgs));
					
					shFbs[i].MovePlane.Execute := FALSE;
					shState[i] := SH_PREFORM_ST_1;				
				END_IF
			SH_PREFORM_ST_1: //******************************************************************************** Shuttle is being operated on at station 1
				IF gShuttleIf[i].Cmd.NextStep THEN
					gShuttleIf[i].Cmd.NextStep := FALSE;
										
					shFbs[i].MovePlane.Controller := ADR(gMcAcp6DController);
					shFbs[i].MovePlane.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].MovePlane.Velocity := gProcessRecipe.General.Velocity;
					shFbs[i].MovePlane.Acceleration := gProcessRecipe.General.Accel;
					shFbs[i].MovePlane.EndVelocity := 0;
					shFbs[i].MovePlane.PositionX := gProcessStIf[STATION_2].Cfg.StationPos.X;
					shFbs[i].MovePlane.PositionY := gProcessStIf[STATION_2].Cfg.StationPos.Y;
					shFbs[i].MovePlane.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].MovePlane.Path := mcACP6D_PATH_Y_THEN_X;
					shFbs[i].MovePlane.Execute := TRUE;
					
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d sent to Station 2',ADR(logArgs));
					
					gShuttleIf[i].Sts.CurrentDestination := DEST_PROCESS_2;
					shState[i] := SH_GO_TO_ST_2;				
				END_IF
			SH_GO_TO_ST_2: //******************************************************************************** Shuttle is going to the #2 operating station
				IF shFbs[i].MovePlane.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					logArgs[0] := ADR(i);
					logArgs[1] := ADR(shFbs[i].MovePlane.ErrorID);
					logError('ShCtrl','Sh%d had error %d moving to Station 2',ADR(logArgs));
					
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].MovePlane.Done AND (gProcessStIf[STATION_2].Par.ShuttleIdx = STATION_IS_EMPTY AND gProcessStIf[STATION_2].Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gProcessStIf[STATION_2].Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gProcessStIf[STATION_2].Par.ShuttleIdx := i;
					gProcessStIf[STATION_2].Cmd.Process := TRUE;
				
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d arrived at Station 2',ADR(logArgs));
					
					shFbs[i].MovePlane.Execute := FALSE;
					shState[i] := SH_PREFORM_ST_2;				
				END_IF
			SH_PREFORM_ST_2: //******************************************************************************** Shuttle is being operated on at station 2
				IF gShuttleIf[i].Cmd.NextStep THEN
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d sent to inspection',ADR(logArgs));
					
					shState[i] := SH_CHECK_RECIPE;
				END_IF
			SH_GO_TO_INSPECT: //******************************************************************************** Shuttle is going to the inspection station
				IF shFbs[i].MovePlane.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					logArgs[0] := ADR(i);
					logArgs[1] := ADR(shFbs[i].MovePlane.ErrorID);
					logError('ShCtrl','Sh%d had error %d moving to inspection',ADR(logArgs));
					
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].MovePlane.Done AND (gInspectIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gInspectIf.Sts.ReadyForNewShuttle) 
						AND PositionValidation(ADR(gInspectIf.Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gInspectIf.Par.ShuttleIdx := i;
					gInspectIf.Cmd.Process := TRUE;
				
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d arrived at inspection',ADR(logArgs));
					
					shFbs[i].MovePlane.Execute := FALSE;
					shState[i] := SH_INSPECT;
				END_IF
			SH_INSPECT: //******************************************************************************** Shuttle is being operated on at the inspection station
				IF gShuttleIf[i].Cmd.NextStep THEN
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					shFbs[i].MovePlane.Controller := ADR(gMcAcp6DController);
					shFbs[i].MovePlane.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].MovePlane.Velocity := gProcessRecipe.General.Velocity;
					shFbs[i].MovePlane.Acceleration := gProcessRecipe.General.Accel;
					shFbs[i].MovePlane.EndVelocity := 0;
					shFbs[i].MovePlane.PositionX := gUnloadStIf.Cfg.StationPos.X;
					shFbs[i].MovePlane.PositionY := gUnloadStIf.Cfg.StationPos.Y;
					shFbs[i].MovePlane.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].MovePlane.Path := mcACP6D_PATH_Y_THEN_X;
					shFbs[i].MovePlane.Execute := TRUE;
					
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d sent to unload',ADR(logArgs));
					
					gShuttleIf[i].Sts.CurrentDestination := DEST_UNLOAD;
					shState[i] := SH_GO_TO_UNLOAD;				
				END_IF
			SH_GO_TO_UNLOAD: //******************************************************************************** Shuttle is going to the unload station
				IF shFbs[i].MovePlane.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					logArgs[0] := ADR(i);
					logArgs[1] := ADR(shFbs[i].MovePlane.ErrorID);
					logError('ShCtrl','Sh%d had error %d moving to unload',ADR(logArgs));
					
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].MovePlane.Done AND (gUnloadStIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gUnloadStIf.Sts.ReadyForNewShuttle) 
						AND PositionValidation(ADR(gUnloadStIf.Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gUnloadStIf.Par.ShuttleIdx := i;
					gUnloadStIf.Cmd.Process := TRUE;
					
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d arrived at unload',ADR(logArgs));
					
					shFbs[i].MovePlane.Execute := FALSE;
					shState[i] := SH_UNLOAD;				
				END_IF
			SH_UNLOAD: //******************************************************************************** Shuttle is being operated on at the unload station
				IF gShuttleIf[i].Cmd.NextStep THEN
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					shFbs[i].MovePlane.Controller := ADR(gMcAcp6DController);
					shFbs[i].MovePlane.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					//shFbs[i].MovePlane.Velocity := gProcessRecipe.General.Velocity;
					shFbs[i].MovePlane.Velocity := 0.5;
					shFbs[i].MovePlane.Acceleration := gProcessRecipe.General.Accel;
					shFbs[i].MovePlane.EndVelocity := 0;
					shFbs[i].MovePlane.PositionX := gLoadStIf.Cfg.StationPos.X;
					shFbs[i].MovePlane.PositionY := gLoadStIf.Cfg.StationPos.Y;
					shFbs[i].MovePlane.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].MovePlane.Path := mcACP6D_PATH_Y_THEN_X;
					shFbs[i].MovePlane.Execute := TRUE;
					
					logArgs[0] := ADR(i);
					logDebug('ShCtrl','Sh%d sent to load',ADR(logArgs));
					gShuttleIf[i].Cmd.ResetProductInfo := TRUE;
					
					gShuttleIf[i].Sts.CurrentDestination := DEST_LOAD;
					shState[i] := SH_GO_TO_LOAD;
				END_IF
			SH_STOPPING: //******************************************************************************** Shuttle is in the stopping state
				IF shFbs[i].Stop.Error THEN
					shState[i] := SH_ERROR;
				ELSIF gShuttleIf[i].Sts.ShuttleInfo.State.Valid AND
						(gShuttleIf[i].Sts.ShuttleInfo.State.Value = mcACP6D_SH_STATE_IDLING OR gShuttleIf[i].Sts.ShuttleInfo.State.Value = mcACP6D_SH_STATE_DISABLED) THEN
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					shFbs[i].Stop.Execute := FALSE;
					shFbs[i].MovePlane.Execute := FALSE;
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					
					shState[i] := SH_RESET;
				END_IF
			
				
			SH_ERROR: //******************************************************************************** Shuttle is in the error state
				IF gShuttleIf[i].Cmd.Reset THEN
					shState[i] := SH_RESET;
				END_IF
			SH_RESET: //******************************************************************************** Reset all shuttle values
				gShuttleIf[i].Cmd.ResetProductInfo := TRUE;
				gShuttleIf[i].Cmd.Reset := FALSE;
				gShuttleIf[i].Cmd.NextStep := FALSE;
				gShuttleIf[i].Cmd.RunProcessDemo := FALSE;
				
				gShuttleIf[i].Sts.Active := FALSE;
				
				shFbs[i].MovePlane.Execute := FALSE;
				shFbs[i].ShRunMacroFb.Execute := FALSE;
				shFbs[i].Stop.Execute := FALSE;
		
				shState[i] := SH_OFF;
		END_CASE;
		
		shFbs[i].Stop();
		shFbs[i].MovePlane();
		
		IF gShuttleIf[i].Cmd.ResetProductInfo THEN
			gShuttleIf[i].Sts.Error := FALSE;
			gShuttleIf[i].Sts.ErrorState := 0;
			gShuttleIf[i].Cmd.ResetProductInfo := FALSE;
			gShuttleIf[i].Sts.LoopCounter := 0;
			gShuttleIf[i].Sts.ProductState := PROD_EMPTY;
			brsmemset(ADR(gShuttleIf[i].Sts.ProdFill),0,SIZEOF(gShuttleIf[i].Sts.ProdFill));
		END_IF
				
	END_FOR;
	
	pDebugIf ACCESS ADR(gShuttleIf[debugIdx]);
	pDebugState ACCESS ADR(shState[debugIdx]);
	pDebugFbs ACCESS ADR(shFbs[debugIdx]);
	
END_PROGRAM
