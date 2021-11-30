
(* TODO: Add your comment here *)
FUNCTION_BLOCK ProfBuilderFb
	CASE int.State OF
		PB_IDLE: 	//******************************************************************************** Idle State
			IF Execute THEN
				Active := TRUE;
				IF Pars.NumMoves > MAX_NUM_MOVES THEN
					Error := TRUE;
					int.State := PB_ERROR;
				ELSE
					int.State := PB_CHECK_IDX;
				END_IF
			END_IF
			    
		PB_CHECK_IDX: 	//******************************************************************************** Checking the Index State
			
			CASE Pars.Moves[int.idx].MoveType OF
				profMoveNone:
				profMovePlane:
					int.Fbs.InPlaneFb.Controller := ADR(Controller);
					int.Fbs.InPlaneFb.ShuttleID := ShId;
					int.Fbs.InPlaneFb.PositionX := Pars.Moves[int.idx].Positions.XPos;
					int.Fbs.InPlaneFb.PositionY := Pars.Moves[int.idx].Positions.YPos;
					int.Fbs.InPlaneFb.Velocity := Pars.Moves[int.idx].Dynamics.Vel;
					int.Fbs.InPlaneFb.Acceleration := Pars.Moves[int.idx].Dynamics.Accel;
					int.Fbs.InPlaneFb.EndVelocity := Pars.Moves[int.idx].Dynamics.EndVel;
					int.Fbs.InPlaneFb.Mode := Pars.Moves[int.idx].InPlanePar.Mode;
					int.Fbs.InPlaneFb.Path := Pars.Moves[int.idx].InPlanePar.Path;
					int.Fbs.InPlaneFb.Execute := TRUE;
				profMoveArc:
					int.Fbs.ArcFb.Controller := ADR(Controller);
					int.Fbs.ArcFb.ShuttleID := ShId;
					int.Fbs.ArcFb.CenterX := Pars.Moves[int.idx].Positions.XPos;
					int.Fbs.ArcFb.CenterY := Pars.Moves[int.idx].Positions.YPos;
					int.Fbs.ArcFb.Velocity := Pars.Moves[int.idx].Dynamics.Vel;
					int.Fbs.ArcFb.Acceleration := Pars.Moves[int.idx].Dynamics.Accel;
					int.Fbs.ArcFb.EndVelocity := Pars.Moves[int.idx].Dynamics.EndVel;
					int.Fbs.ArcFb.Mode := Pars.Moves[int.idx].ArcPar.Mode;
					int.Fbs.ArcFb.Direction := Pars.Moves[int.idx].ArcPar.Direction;
					int.Fbs.ArcFb.Angle := Pars.Moves[int.idx].ArcPar.Angle;
					int.Fbs.ArcFb.Execute := TRUE;
				profLand:
					int.Fbs.LevitateCtrlFb.Controller := ADR(Controller);
					int.Fbs.LevitateCtrlFb.ShuttleID := ShId;
					int.Fbs.LevitateCtrlFb.Level := Pars.Moves[int.idx].LandPar;
					int.Fbs.LevitateCtrlFb.Execute := TRUE;
				
			END_CASE;
			
			IF int.idx = Pars.NumMoves - 1 THEN
				int.State := PB_WAIT_LAST;
			ELSE
				int.State := PB_CMD_MOVE;
			END_IF
		PB_CMD_MOVE: 	//******************************************************************************** Command Move State
			IF int.Fbs.ArcFb.Error OR int.Fbs.InPlaneFb.Error OR int.Fbs.LevitateCtrlFb.Error THEN
				int.ErrorState := int.State;
				int.State := PB_ERROR;
				Error := TRUE;
			ELSE 
				CASE Pars.Moves[int.idx].MoveType OF
					profMovePlane:
						IF int.Fbs.InPlaneFb.Acknowledge THEN
							int.Fbs.InPlaneFb.Execute := FALSE;
							int.idx := int.idx + 1;
							int.State := PB_CHECK_IDX;
						END_IF
					profMoveArc:
						IF int.Fbs.ArcFb.Acknowledge THEN
							int.Fbs.ArcFb.Execute := FALSE;
							int.idx := int.idx + 1;
							int.State := PB_CHECK_IDX;
						END_IF
					profLand:
						IF int.Fbs.LevitateCtrlFb.Acknowledge THEN
							int.Fbs.LevitateCtrlFb.Execute := FALSE;
							int.idx := int.idx + 1;
							int.State := PB_CHECK_IDX;
						END_IF
				END_CASE
			END_IF
		PB_WAIT_LAST: 	//******************************************************************************** Waiting for Last Move State
			IF int.Fbs.ArcFb.Error OR int.Fbs.InPlaneFb.Error THEN
				int.ErrorState := int.State;
				int.State := PB_ERROR;
				Error := TRUE;
			ELSE 
				CASE Pars.Moves[int.idx].MoveType OF
					profMovePlane:
						IF int.Fbs.InPlaneFb.Done THEN
							int.Fbs.InPlaneFb.Execute := FALSE;
							int.State := PB_DONE;
						END_IF
					profMoveArc:
						IF int.Fbs.ArcFb.Done THEN
							int.Fbs.ArcFb.Execute := FALSE;
							int.State := PB_DONE;
						END_IF
					profLand:
						IF int.Fbs.LevitateCtrlFb.Done THEN
							int.Fbs.LevitateCtrlFb.Execute := FALSE;
							int.State := PB_DONE;
						END_IF
				END_CASE
			END_IF
		PB_DONE: 	//******************************************************************************** Done State
			IF NOT Execute THEN
				int.State := PB_RESET;
			END_IF
		PB_ERROR: 	//******************************************************************************** Error State
			IF Reset THEN
				Reset := FALSE;
				int.State := PB_RESET;
			END_IF
		PB_RESET: 	//******************************************************************************** Reset State
			int.Fbs.ArcFb.Execute := FALSE;
			int.Fbs.InPlaneFb.Execute := FALSE;
			int.Fbs.WaitFb.Execute := FALSE;
			int.Fbs.LevitateCtrlFb.Execute := FALSE;
			
			int.idx := 0;
			Error := FALSE;
			ErrorID := 0;
			Active := FALSE;
			Done := FALSE;
			
			IF NOT int.Fbs.ArcFb.Error AND NOT int.Fbs.InPlaneFb.Error AND NOT int.Fbs.LevitateCtrlFb.Error AND NOT int.Fbs.WaitFb.Error THEN
				int.State := PB_IDLE;
			END_IF
	END_CASE
	
	int.Fbs.ArcFb();
	int.Fbs.InPlaneFb();
	int.Fbs.WaitFb();
	int.Fbs.LevitateCtrlFb();
END_FUNCTION_BLOCK
