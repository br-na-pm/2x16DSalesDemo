
(*
	Demo routine
	
*)

PROGRAM _CYCLIC
	
	CASE state OF
		0:
			IF startVibration THEN
				RunMacroFB.Controller := ADR(gMcAcp6DController);
				RunMacroFB.ShuttleID := shuttleId;
				RunMacroFB.MacroID := 138;
				RunMacroFB.Execute := TRUE;
					
				state := 10;
			END_IF
		10:
			IF RunMacroFB.Error THEN
				state := 255;
			ELSIF RunMacroFB.Acknowledge THEN
				RunMacroFB.Execute := FALSE;
				
				WaitTon.IN := TRUE;
				WaitTon.PT := vibrationTime;
				
				state := 20;
			END_IF
		20:
			IF WaitTon.Q THEN
				WaitTon.IN := FALSE;
				StopFb.Controller := ADR(gMcAcp6DController);
				StopFb.ShuttleID := shuttleId;
				StopFb.Execute := TRUE;
				state := 30;
			END_IF
		30:
			IF StopFb.Error THEN
				state := 255;
			ELSIF StopFb.Done THEN
				StopFb.Execute := FALSE;
				startVibration := FALSE;
					
				state := 0;
			END_IF
		255:
			IF errorReset THEN
				StopFb.Execute := FALSE;
				WaitTon.IN := FALSE;
				RunMacroFB.Execute := FALSE;
			END_IF
	END_CASE
	StopFb();
	WaitTon();
	RunMacroFB();
	
	profFb.Controller := ADR(gMcAcp6DController);
	profFb.Pars := ADR(moveProf);
	profFb();
	
	IF resetMove THEN
		brsmemset(ADR(hmiMove),0,SIZEOF(moveProf.Moves[0]));
		resetMove := FALSE;
	END_IF	
	
	hmiMove ACCESS ADR(moveProf.Moves[hmiIndex]);
	
	
	
END_PROGRAM
