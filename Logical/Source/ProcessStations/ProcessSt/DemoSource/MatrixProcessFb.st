
(* implementation of a matrix movement process*)
(*
	Moves a shuttle in a matrix square pattern
	Assuming the following pattern, will move to the location -x,-y first 
	  0 1 2
	2 x x x
	1 x x x
	0 o x x
	
	Will make a "snake" path through the matrix (move to the right, then to the left, repeat)

	Pauses at each location for the defined time

*)
FUNCTION_BLOCK MatrixProcessFb
	CASE Internal.state OF
		MAT_IDLE: //******************************************************************************** Idle Wait State
			IF Execute THEN
				Active := TRUE;
								
				Internal.cCol := 0;
				Internal.cRow := 0;
				CurrentPocket := 1;
				
				Internal.Fbs.MoveInPlaneFb.Controller := ADR(Controller);
				Internal.Fbs.MoveInPlaneFb.ShuttleID := ShId;
				Internal.Fbs.MoveInPlaneFb.Velocity := Velocity;
				Internal.Fbs.MoveInPlaneFb.Acceleration := Acceleration;
				Internal.Fbs.MoveInPlaneFb.Mode := mcACP6D_MOVE_RELATIVE;
				//This is a temporary fix for time constraints on the demo. This will only work for the 3x3 design in this demo
//				Internal.Fbs.MoveInPlaneFb.PositionX := - (ColSpacing * UINT_TO_REAL(NumColumns) / 2.0);
//				Internal.Fbs.MoveInPlaneFb.PositionY := - (RowSpacing * UINT_TO_REAL(NumRows) / 2.0);
				Internal.Fbs.MoveInPlaneFb.PositionX := - ColSpacing;
				Internal.Fbs.MoveInPlaneFb.PositionY := - RowSpacing;
				Internal.Fbs.MoveInPlaneFb.Execute := TRUE;
				
				Internal.state := MAT_MOVE;
			
			END_IF
		MAT_MOVE: //******************************************************************************** Moving State
			
			IF Internal.Fbs.MoveInPlaneFb.Error THEN
				Error := TRUE;
				Internal.errorState := Internal.state;
				Internal.state := MAT_ERROR;
			ELSIF Internal.Fbs.MoveInPlaneFb.Done THEN
				Internal.Fbs.MoveInPlaneFb.Execute := FALSE;
				
				Filling := TRUE;
				
				Internal.Fbs.FillTimerFb.PT := FillTime;
				Internal.Fbs.FillTimerFb.IN := TRUE;
				
				Internal.state := MAT_FILL;
			END_IF
		MAT_FILL: //******************************************************************************** Filling State
			IF Internal.Fbs.FillTimerFb.Q THEN
				Internal.Fbs.FillTimerFb.IN := FALSE;
				Filling := FALSE;
				
				IF Internal.fillDir = FILL_RIGHT THEN
					Internal.cCol := Internal.cCol + 1;
				ELSE 
					Internal.cCol := Internal.cCol - 1;
				END_IF
				
				IF Internal.cCol >= NumColumns OR Internal.cCol <= 0 THEN
					//Finished a row
					Internal.cRow := Internal.cRow + 1;
					IF Internal.cRow >= NumRows THEN
						//Done
						Done := TRUE;
						
						Internal.state := MAT_DONE;
					ELSE
						IF Internal.fillDir = FILL_RIGHT THEN
							Internal.fillDir := FILL_LEFT;
							Internal.cCol := NumColumns;
						ELSE
							Internal.fillDir := FILL_RIGHT;
							Internal.cCol := 0;
						END_IF
						Internal.Fbs.MoveInPlaneFb.PositionX := 0;
						Internal.Fbs.MoveInPlaneFb.PositionY := RowSpacing;
						Internal.Fbs.MoveInPlaneFb.Execute := TRUE;
						CurrentPocket := CurrentPocket + 1;
						Internal.state := MAT_MOVE;
					END_IF
				ELSE
					IF Internal.fillDir = FILL_RIGHT THEN
						Internal.Fbs.MoveInPlaneFb.PositionX := ColSpacing;
					ELSE
						Internal.Fbs.MoveInPlaneFb.PositionX := -ColSpacing;
					END_IF
					Internal.Fbs.MoveInPlaneFb.PositionY := 0;
					Internal.Fbs.MoveInPlaneFb.Execute := TRUE;
					Internal.state := MAT_MOVE;
					CurrentPocket := CurrentPocket + 1;
				END_IF
			END_IF
		MAT_DONE: //******************************************************************************** Finished with the process
			IF NOT Execute THEN
				Internal.state := MAT_RESET;
			END_IF
		MAT_ERROR: //******************************************************************************** Error State
			IF NOT Execute THEN
				Internal.state := MAT_RESET;
			END_IF
		MAT_RESET: //******************************************************************************** Reset State
			Active := FALSE;
			Done := FALSE;
			Error := FALSE;
			CurrentPocket := 0;
			Filling := 0;
			
			Internal.cCol := 0;
			Internal.cRow := 0;
			Internal.fillDir := FILL_RIGHT;
			Internal.Fbs.FillTimerFb.IN := FALSE;
			Internal.Fbs.MoveInPlaneFb.Execute := FALSE;
			
			IF NOT Internal.Fbs.MoveInPlaneFb.Error THEN 
				Internal.state := MAT_IDLE;
			END_IF
	END_CASE;
	
	//Function block calls
	Internal.Fbs.MoveInPlaneFb();
	Internal.Fbs.FillTimerFb();
	
END_FUNCTION_BLOCK
