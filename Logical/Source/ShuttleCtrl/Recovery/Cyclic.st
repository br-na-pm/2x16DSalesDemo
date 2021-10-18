
PROGRAM _CYCLIC
	
	(*
	Shuttle reocvery
		Move all shuttles to autodrive positions		
		Wait for autodrive to be finished
		loop through each shuttle
			if that shuttle's group is current
				it is not recovered, 
					groupRecovered=false
					Evaluate each shuttle's position 
					Send it to the unload position and set the "Next step cmd" to be true
				else
					onwards, do nothing

	*)
	 
	CASE state OF
		RECOVER_IDLE:   //******************************************************************************** Recovery is in an idle state*)
			IF g6DRecoveryIf.Cmd.Recover THEN
				g6DRecoveryIf.Sts.Recovering := TRUE;
				state := RECOVER_INIT;
			END_IF
		RECOVER_INIT:   //******************************************************************************** Initalize recovery state*)
			RecoverFbs.AsyncMoveFb.Controller := ADR(gMcAcp6DController);
			RecoverFbs.AsyncMoveFb.NumberOfShuttles := gMainIf.Cfg.ShuttleCount;
			RecoverFbs.AsyncMoveFb.Velocity := g6DRecoveryIf.Par.Vel;
			RecoverFbs.AsyncMoveFb.Acceleration := g6DRecoveryIf.Par.Accel;
			FOR i:=0 TO gMainIf.Cfg.ShuttleCount - 1 DO
				RecoverFbs.AsyncMoveFb.PositionX[i] := g6DRecoveryIf.Par.AutoDrivePositions[i].X; 	
				RecoverFbs.AsyncMoveFb.PositionY[i] := g6DRecoveryIf.Par.AutoDrivePositions[i].Y; 	
				RecoverFbs.AsyncMoveFb.ShuttleID[i] := gShuttleIf[g6DRecoveryIf.Par.AutoDrivePositions[i].ShIdx].Cfg.ShuttleId;
				IF RecoverFbs.AsyncMoveFb.ShuttleID[i] = 0 THEN// Invalid shuttle id here
					g6DRecoveryIf.Sts.Error := TRUE;
				END_IF
			END_FOR;
			IF NOT g6DRecoveryIf.Sts.Error THEN
				RecoverFbs.AsyncMoveFb.Execute := TRUE;
				state := RECOVER_AUTODRIVE;
			ELSE
				state := RECOVER_ERROR;
			END_IF
			
		RECOVER_AUTODRIVE:   //******************************************************************************** Preform autodrive movement for recovery*)
			IF RecoverFbs.AsyncMoveFb.Error AND RecoverFbs.AsyncMoveFb.ErrorID = mcACP6D_ERR_WRONG_SH_STATE THEN
				RecoverFbs.AsyncMoveFb.Execute := FALSE;
				
				RecoverFbs.DelayFb.IN := TRUE;
				RecoverFbs.DelayFb.PT := T#5s;
				
				RecoverFbs.ShStopFb.Controller := ADR(gMcAcp6DController);
				RecoverFbs.ShStopFb.ShuttleID := 0;
				RecoverFbs.ShStopFb.Execute := TRUE;
				
				state := RECOVER_STOP;
			ELSIF RecoverFbs.AsyncMoveFb.Error THEN
				g6DRecoveryIf.Sts.Error := TRUE;
				state := RECOVER_ERROR;
			ELSIF RecoverFbs.AsyncMoveFb.Done THEN
				g6DRecoveryIf.Sts.ReadyToStartProc := TRUE;
				RecoverFbs.AsyncMoveFb.Execute := FALSE;
				
				state := RECOVER_DONE;
			END_IF
		RECOVER_STOP:  //******************************************************************************** Stop All shuttles
			IF RecoverFbs.ShStopFb.Error THEN
				g6DRecoveryIf.Sts.Error := TRUE;
				state := RECOVER_ERROR;
			ELSIF RecoverFbs.ShStopFb.Done AND RecoverFbs.DelayFb.Q THEN
				RecoverFbs.DelayFb.IN := FALSE;
				RecoverFbs.ShStopFb.Execute := FALSE;
				
				RecoverFbs.AsyncMoveFb.Execute := TRUE;
				
				state := RECOVER_AUTODRIVE;
			END_IF
		RECOVER_DONE:   //******************************************************************************** Recovery has been completed*)
			IF NOT g6DRecoveryIf.Cmd.Recover THEN
				g6DRecoveryIf.Cmd.Reset := FALSE;
				RecoverFbs.DelayFb.IN := FALSE;
				g6DRecoveryIf.Sts.Done := FALSE;
				g6DRecoveryIf.Sts.ReadyToStartProc := FALSE;
				g6DRecoveryIf.Sts.Recovering := FALSE;
				g6DRecoveryIf.Sts.ShuttlesRecovered := FALSE;
				g6DRecoveryIf.Sts.Error := FALSE;
				
				RecoverFbs.AsyncMoveFb.Execute := FALSE;
				state := RECOVER_IDLE;
			END_IF
		RECOVER_ERROR:   //******************************************************************************** Recovery had an error*)
			IF g6DRecoveryIf.Cmd.Reset THEN
				RecoverFbs.DelayFb.IN := FALSE;
				g6DRecoveryIf.Cmd.Reset := FALSE;
				g6DRecoveryIf.Cmd.Recover := FALSE;
				
				g6DRecoveryIf.Sts.Done := FALSE;
				g6DRecoveryIf.Sts.ReadyToStartProc := FALSE;
				g6DRecoveryIf.Sts.Recovering := FALSE;
				g6DRecoveryIf.Sts.ShuttlesRecovered := FALSE;
				g6DRecoveryIf.Sts.Error := FALSE;
								
				RecoverFbs.AsyncMoveFb.Execute := FALSE;
				RecoverFbs.ShStopFb.Execute := FALSE;
				state := RECOVER_IDLE;
			END_IF
	END_CASE;
	RecoverFbs.AsyncMoveFb();
	RecoverFbs.ShStopFb();
	RecoverFbs.DelayFb();
END_PROGRAM
