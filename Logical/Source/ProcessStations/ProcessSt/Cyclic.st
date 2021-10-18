
PROGRAM _CYCLIC

	IF NOT pStIf.Cmd.LocalOverride THEN
		stationPars := pStPars;
	END_IF
	
	CASE state OF
		STATION_OFF: //********************************************************************************Load station is currently disabled
			IF pStIf.Cmd.Enable THEN
				state := STATION_INIT;
			ELSIF pStIf.Cmd.Reset THEN
				state := STATION_ERROR;
			END_IF
		STATION_INIT: //********************************************************************************Load station is initalizing
			pStIf.Sts.ReadyForNewShuttle := TRUE;
			pStIf.Sts.Enabled := TRUE;
			
			state := STATION_WAIT_FOR_SHUTTLE;	
		STATION_WAIT_FOR_SHUTTLE: //********************************************************************************Load station is waiting for a shuttle to be present
			IF NOT pStIf.Cmd.Enable THEN
				pStIf.Sts.ReadyForNewShuttle := FALSE;
				pStIf.Sts.Enabled := FALSE;
				state := STATION_OFF;
			ELSIF pStIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND pStIf.Cmd.Process THEN
				pStIf.Sts.ReadyForNewShuttle := FALSE;
				pStIf.Sts.Processing := TRUE;
				
				stationFbs.MovePlane.Controller := ADR(gMcAcp6DController);
				stationFbs.MovePlane.Velocity := gProcessRecipe.General.Velocity;
				stationFbs.MovePlane.EndVelocity := 0;
				stationFbs.MovePlane.Acceleration := gProcessRecipe.General.Accel;
				stationFbs.MovePlane.PositionX := stationPars.OperationPos.X;
				stationFbs.MovePlane.PositionY := stationPars.OperationPos.Y;
				stationFbs.MovePlane.Path := mcACP6D_PATH_X_THEN_Y;
				stationFbs.MovePlane.Mode := mcACP6D_MOVE_ABSOLUTE;
				stationFbs.MovePlane.ShuttleID := gShuttleIf[pStIf.Par.ShuttleIdx].Cfg.ShuttleId;
				stationFbs.MovePlane.Execute := TRUE;
								
				state := STATION_SH_ENTER;
			END_IF
		STATION_SH_ENTER:
			IF stationFbs.MovePlane.Error THEN
				pStIf.Sts.Error := TRUE;
				state := STATION_ERROR;
			ELSIF stationFbs.MovePlane.Done THEN
				stationFbs.MovePlane.Execute := FALSE;
				
				stationFbs.Timer.IN := TRUE;
				stationFbs.Timer.PT := stationPars.DwellTime;
				
				CASE gShuttleIf[pStIf.Par.ShuttleIdx].Sts.ProductState OF
					PROD_DOSING:
						IF taskName = 'ProcSt1' THEN
							processDemoTyp := PROC_MATRIX;
						ELSIF taskName = 'ProcSt2' THEN
							processDemoTyp := PROC_SPIRAL;
						END_IF
					PROD_CUBE:
						IF taskName = 'ProcSt1' THEN
							processDemoTyp := PROC_Z_ROT;
						ELSIF taskName = 'ProcSt2' THEN
							processDemoTyp := PROC_NCR;
						END_IF
				END_CASE
				
				//processDemoTyp := PROC_SPIRAL;
				stationFbs.RunMacroFb.Controller := ADR(gMcAcp6DController);
				stationFbs.RunMacroFb.ShuttleID := gShuttleIf[pStIf.Par.ShuttleIdx].Cfg.ShuttleId;
				CASE processDemoTyp OF
					PROC_SPIRAL:	//************************ Spiral Demo
						stationFbs.RunMacroFb.MacroID := 180;
						stationFbs.RunMacroFb.Execute := TRUE;
					PROC_MATRIX:    //************************ Matrix Demo
						stationFbs.MatrixFb.Controller := ADR(gMcAcp6DController);
						stationFbs.MatrixFb.ShId := gShuttleIf[pStIf.Par.ShuttleIdx].Cfg.ShuttleId;
						stationFbs.MatrixFb.NumColumns := 3;
						stationFbs.MatrixFb.NumRows := 3;
						stationFbs.MatrixFb.FillTime := T#170ms;
						stationFbs.MatrixFb.Velocity := 1;
						stationFbs.MatrixFb.Acceleration := 10;
						stationFbs.MatrixFb.ColSpacing := 0.03;
						stationFbs.MatrixFb.RowSpacing := 0.03;
						stationFbs.MatrixFb.Execute := TRUE;
					PROC_Z_ROT:     //************************ Z Rot Demo
						stationFbs.RunMacroFb.MacroID := 182;
						stationFbs.RunMacroFb.Execute := TRUE;
					PROC_NCR:     //************************ NCR Demo
						stationFbs.NCR_DemoFb.Controller := ADR(gMcAcp6DController);
						stationFbs.NCR_DemoFb.ShId := gShuttleIf[pStIf.Par.ShuttleIdx].Cfg.ShuttleId;
						stationFbs.NCR_DemoFb.Execute := TRUE;
				END_CASE
				
				
				state := STATION_OPERATING;
			END_IF
			
		STATION_OPERATING:
			IF stationFbs.RunMacroFb.Error OR stationFbs.NCR_DemoFb.Error OR stationFbs.MatrixFb.Error THEN
				state := STATION_ERROR;
			ELSIF (stationFbs.RunMacroFb.Execute AND stationFbs.RunMacroFb.Done) OR (stationFbs.NCR_DemoFb.Execute AND stationFbs.NCR_DemoFb.Done) OR (stationFbs.MatrixFb.Execute AND stationFbs.MatrixFb.Done) THEN
				stationFbs.MatrixFb.Execute := FALSE;
				stationFbs.RunMacroFb.Execute := FALSE;
				stationFbs.NCR_DemoFb.Execute := FALSE;
				stationFbs.Timer.IN := FALSE;
				
				stationFbs.MovePlane.Controller := ADR(gMcAcp6DController);
				stationFbs.MovePlane.Velocity := gProcessRecipe.General.Velocity;
				stationFbs.MovePlane.EndVelocity := 0;
				stationFbs.MovePlane.Acceleration := gProcessRecipe.General.Accel;
				stationFbs.MovePlane.PositionX := stationPars.ExitPos.X;
				stationFbs.MovePlane.PositionY := stationPars.ExitPos.Y;
				stationFbs.MovePlane.Path := mcACP6D_PATH_Y_THEN_X;
				stationFbs.MovePlane.Mode := mcACP6D_MOVE_ABSOLUTE;
				stationFbs.MovePlane.ShuttleID := gShuttleIf[pStIf.Par.ShuttleIdx].Cfg.ShuttleId;
				stationFbs.MovePlane.Execute := TRUE;
								
				state := STATION_SH_EXIT;
			END_IF
			
			CASE processDemoTyp OF
				PROC_SPIRAL:
				PROC_MATRIX:
					CASE matrixState OF 
						0:
							IF stationFbs.MatrixFb.Filling THEN
								gShuttleIf[pStIf.Par.ShuttleIdx].Sts.ProdFill[stationFbs.MatrixFb.CurrentPocket - 1] := gShuttleIf[pStIf.Par.ShuttleIdx].Sts.ProdFill[stationFbs.MatrixFb.CurrentPocket - 1] + 1;
								matrixState := 1;
							END_IF
						1:
							IF NOT stationFbs.MatrixFb.Filling THEN
								matrixState := 0;
							END_IF
					END_CASE
				PROC_Z_ROT:	//************************ Macro Demos
					
				PROC_NCR:    //************************ NCR FB Demo
			END_CASE
			
				
		STATION_SH_EXIT:
			IF stationFbs.MovePlane.Error THEN
				pStIf.Sts.Error := TRUE;
				state := STATION_ERROR;
			ELSIF stationFbs.MovePlane.Acknowledge THEN
				stationFbs.MovePlane.Execute := FALSE;				 
				pStIf.Sts.Processing := FALSE;
				pStIf.Sts.Done := TRUE;
				gShuttleIf[pStIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;				
							
				state := STATION_DONE;
			END_IF
					
		STATION_DONE: //********************************************************************************Load station is done with the load process
			IF NOT pStIf.Cmd.Enable THEN
				pStIf.Sts.Done := FALSE;
				pStIf.Sts.Enabled := FALSE;
				pStIf.Sts.ReadyForNewShuttle := FALSE;
				stationFbs.Timer.IN := FALSE;
				
				pStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				state := STATION_OFF;
			ELSE
				pStIf.Cmd.Process := FALSE;
				pStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				pStIf.Sts.Done := FALSE;
				pStIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := STATION_WAIT_FOR_SHUTTLE;
			END_IF
			
		STATION_ERROR: //********************************************************************************Load station had an error
			IF pStIf.Cmd.Reset THEN
				pStIf.Cmd.Reset := FALSE;
				
				pStIf.Sts.Done := FALSE;
				pStIf.Sts.Enabled := FALSE;
				pStIf.Sts.Error := FALSE;
				pStIf.Sts.Processing := FALSE;
				pStIf.Sts.ReadyForNewShuttle := FALSE;
				
				stationFbs.Timer.IN := FALSE;
				stationFbs.MovePlane.Execute := FALSE;
				stationFbs.RunMacroFb.Execute := FALSE;
				stationFbs.NCR_DemoFb.Execute := FALSE;
				stationFbs.MatrixFb.Execute := FALSE;
				
				pStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF pStIf.Cmd.Enable THEN
					state := STATION_INIT;
				ELSE
					state := STATION_OFF;
				END_IF
			END_IF
	END_CASE;
		
	stationFbs.Timer();
	stationFbs.MovePlane();
	stationFbs.RunMacroFb();
	stationFbs.NCR_DemoFb();
	stationFbs.MatrixFb();
END_PROGRAM
