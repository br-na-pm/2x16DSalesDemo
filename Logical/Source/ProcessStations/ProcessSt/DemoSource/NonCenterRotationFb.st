
(* Demo implementation to showcase non center rotation capabilities*)
(*
	Will rotate a shuttle around 2 points some amount. The center location points are hardcoded for the AtxWest/PackExpo 2021 Demo layout
	Send start macro command to # of shuttles defined by input
	Wait Input Time
		Increment group count
	Repeat until group count * shuttlesPerGroup >= TotalShuttleCount
	Stop
		Send all shuttles to default height
	Error
	Reset

*)
FUNCTION_BLOCK NonCenterRotationFb
	CASE Internal.state OF
		NCR_IDLE: //******************************************************************************** Idle Wait State
			IF Execute THEN
				Active := TRUE;
				DemoRunning := TRUE;
				
				Internal.Fbs.ShortAxisFb.Controller := ADR(Controller);
				Internal.Fbs.ShortAxisFb.ShuttleID := ShId;
				Internal.Fbs.ShortAxisFb.RotationType := mcACP6D_SHORT_AX_ROTATION_CENTER;
				Internal.Fbs.ShortAxisFb.RotationCenterX := 0;
				Internal.Fbs.ShortAxisFb.RotationCenterY := 0.6;
				Internal.Fbs.ShortAxisFb.PositionZ := 0.00175;
				Internal.Fbs.ShortAxisFb.VelocityRz := 0.2;
				Internal.Fbs.ShortAxisFb.VelocityZ := 0.5;
				Internal.Fbs.ShortAxisFb.PositionRz := 0.080;
				Internal.state := NCR_MOVE_1;
			END_IF
		NCR_MOVE_1: //******************************************************************************** Move 1 state
			Internal.Fbs.ShortAxisFb.Execute := TRUE;
			
			IF Internal.Fbs.ShortAxisFb.Error THEN
				Error := TRUE;
				Internal.errorState := Internal.state;
				Internal.state := NCR_ERROR;
			ELSIF Internal.Fbs.ShortAxisFb.Acknowledge THEN
				Internal.Fbs.DelayTimerFb.PT := T#100ms;
				Internal.Fbs.DelayTimerFb.IN := TRUE;
				IF Internal.Fbs.DelayTimerFb.Q THEN
					Internal.Fbs.DelayTimerFb.IN := FALSE;
					Internal.Fbs.ShortAxisFb.Execute := FALSE;
					Internal.Fbs.ShortAxisFb.RotationCenterX := 0;
					Internal.Fbs.ShortAxisFb.RotationCenterY := 0.6;
					Internal.Fbs.ShortAxisFb.PositionRz := -0.080;
					
					Internal.state := NCR_MOVE_2;
				END_IF
			END_IF
		NCR_MOVE_2: //******************************************************************************** Move 2 state
			Internal.Fbs.ShortAxisFb.Execute := TRUE;
			
			IF Internal.Fbs.ShortAxisFb.Error THEN
				Error := TRUE;
				Internal.errorState := Internal.state;
				Internal.state := NCR_ERROR;
			ELSIF Internal.Fbs.ShortAxisFb.Acknowledge THEN
				Internal.Fbs.DelayTimerFb.PT := T#100ms;
				Internal.Fbs.DelayTimerFb.IN := TRUE;
				IF Internal.Fbs.DelayTimerFb.Q THEN
					Internal.Fbs.DelayTimerFb.IN := FALSE;
					Internal.Fbs.ShortAxisFb.Execute := FALSE;
					Internal.Fbs.ShortAxisFb.RotationCenterX := 0;
					Internal.Fbs.ShortAxisFb.RotationCenterY := 0.6;
					Internal.Fbs.ShortAxisFb.PositionRz := 0.0;
					
					Internal.state := NCR_MOVE_3;
				END_IF
			END_IF
		NCR_MOVE_3: //******************************************************************************** Move 3 state
			Internal.Fbs.ShortAxisFb.Execute := TRUE;
			
			IF Internal.Fbs.ShortAxisFb.Error THEN
				Error := TRUE;
				Internal.errorState := Internal.state;
				Internal.state := NCR_ERROR;
			ELSIF Internal.Fbs.ShortAxisFb.Acknowledge THEN
				Internal.Fbs.DelayTimerFb.PT := T#100ms;
				Internal.Fbs.DelayTimerFb.IN := TRUE;
				IF Internal.Fbs.DelayTimerFb.Q THEN
					Internal.Fbs.DelayTimerFb.IN := FALSE;
					Internal.Fbs.ShortAxisFb.Execute := FALSE;
					Internal.Fbs.ShortAxisFb.RotationCenterX := 0.9;
					Internal.Fbs.ShortAxisFb.RotationCenterY := 0.6;
					Internal.Fbs.ShortAxisFb.PositionRz := -0.08;
					
					Internal.state := NCR_MOVE_4;
				END_IF
			END_IF
		NCR_MOVE_4: //******************************************************************************** Move 4 state
			Internal.Fbs.ShortAxisFb.Execute := TRUE;
			
			IF Internal.Fbs.ShortAxisFb.Error THEN
				Error := TRUE;
				Internal.errorState := Internal.state;
				Internal.state := NCR_ERROR;
			ELSIF Internal.Fbs.ShortAxisFb.Acknowledge THEN
				Internal.Fbs.DelayTimerFb.PT := T#100ms;
				Internal.Fbs.DelayTimerFb.IN := TRUE;
				IF Internal.Fbs.DelayTimerFb.Q THEN
					Internal.Fbs.DelayTimerFb.IN := FALSE;
					Internal.Fbs.ShortAxisFb.Execute := FALSE;
					Internal.Fbs.ShortAxisFb.RotationCenterX := 0.9;
					Internal.Fbs.ShortAxisFb.RotationCenterY := 0.6;
					Internal.Fbs.ShortAxisFb.PositionRz := 0.080;
					
					Internal.state := NCR_MOVE_5;
				END_IF
			END_IF
		NCR_MOVE_5: //******************************************************************************** Move 5 state
			Internal.Fbs.ShortAxisFb.Execute := TRUE;
			
			IF Internal.Fbs.ShortAxisFb.Error THEN
				Error := TRUE;
				Internal.errorState := Internal.state;
				Internal.state := NCR_ERROR;
			ELSIF Internal.Fbs.ShortAxisFb.Acknowledge THEN
				Internal.Fbs.DelayTimerFb.PT := T#100ms;
				Internal.Fbs.DelayTimerFb.IN := TRUE;
				IF Internal.Fbs.DelayTimerFb.Q THEN
					Internal.Fbs.DelayTimerFb.IN := FALSE;
					Internal.Fbs.ShortAxisFb.Execute := FALSE;
					Internal.Fbs.ShortAxisFb.RotationCenterX := 0.9;
					Internal.Fbs.ShortAxisFb.RotationCenterY := 0.6;
					Internal.Fbs.ShortAxisFb.PositionRz := 0.0;
					
					Internal.state := NCR_MOVE_6;
				END_IF
			END_IF
		NCR_MOVE_6: //******************************************************************************** Move 6 state
			Internal.Fbs.ShortAxisFb.Execute := TRUE;
			
			IF Internal.Fbs.ShortAxisFb.Error THEN
				Error := TRUE;
				Internal.errorState := Internal.state;
				Internal.state := NCR_ERROR;
			ELSIF Internal.Fbs.ShortAxisFb.Done THEN //Wait for the last one to be done for the movement to be completely finished
				Internal.Fbs.DelayTimerFb.PT := T#100ms;
				Internal.Fbs.DelayTimerFb.IN := TRUE;
				IF Internal.Fbs.DelayTimerFb.Q THEN
					Internal.Fbs.DelayTimerFb.IN := FALSE;
					Internal.Fbs.ShortAxisFb.Execute := FALSE;
					
					Done := TRUE;
					
					Internal.state := NCR_DONE;
				END_IF
			END_IF
		NCR_DONE: //******************************************************************************** Done State
			IF NOT Execute THEN
				Internal.state := NCR_RESET;
			END_IF
		NCR_ERROR: //******************************************************************************** Error Present State
			IF NOT Execute THEN
				Internal.state := NCR_RESET;
			END_IF
		NCR_RESET: //******************************************************************************** Reset State
			
			Internal.Fbs.ShortAxisFb.Execute := FALSE;
			Internal.Fbs.ShStopFb.Execute := FALSE;
			Internal.Fbs.DelayTimerFb.IN := FALSE;
								
			Active := FALSE;
			DemoRunning := FALSE;
			Error := FALSE;
			Done := FALSE;
			
			Internal.state := NCR_IDLE;
	END_CASE;
	
	//Function block calls
	Internal.Fbs.DelayTimerFb();
	Internal.Fbs.ShStopFb();
	Internal.Fbs.ShortAxisFb();
	
END_FUNCTION_BLOCK
