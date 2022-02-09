//Mixing demo

(*
	Move shuttle to segment center position
	Wait for some time (here food coloring is added)
	Preform mixing movement
	Move back to other side
	Wait for some time (food coloring added)
	Preform mixing movement
	Move shuttle to start position
	
*)

PROGRAM _CYCLIC
	Fbs.LoadMacroFb.Controller := ADR(gMcAcp6DController);
	
	Fbs.RunMacroFb.Controller := ADR(gMcAcp6DController);
	Fbs.RunMacroFb.ShuttleID := shId;
	Fbs.RunMacroFb.MacroID := macroId;
	
	CASE state OF
		0:
			Fbs.LoadMacroFb.MacroID := macroId;
			IF run THEN
				Fbs.RunMacroFb.Execute := TRUE;
				Fbs.RunMacroFb.MacroID := 130;
				state := 10;
			END_IF
		10:
			IF Fbs.RunMacroFb.Done THEN
				Fbs.RunMacroFb.Execute := FALSE;
				state := 11;
			END_IF
		11:
			Fbs.RunMacroFb.Execute := TRUE;
			Fbs.RunMacroFb.MacroID := 131;
			state := 20;
		20:
			IF Fbs.RunMacroFb.Done THEN
				Fbs.RunMacroFb.Execute := FALSE;
				state := 21;
			END_IF
		21:
			Fbs.RunMacroFb.Execute := TRUE;
			Fbs.RunMacroFb.MacroID := 132;
			state := 30;
		30:
			IF Fbs.RunMacroFb.Done THEN
				Fbs.RunMacroFb.Execute := FALSE;
				state := 31;
			END_IF
		31:
			Fbs.RunMacroFb.Execute := TRUE;
			Fbs.RunMacroFb.MacroID := 131;
			state := 40;
		40:
			IF Fbs.RunMacroFb.Done THEN
				Fbs.RunMacroFb.Execute := FALSE;
				
				Fbs.MovePlaneFb.Controller := ADR(gMcAcp6DController);
				Fbs.MovePlaneFb.ShuttleID := shId;
				Fbs.MovePlaneFb.PositionX := 0.24;
				Fbs.MovePlaneFb.PositionY := 0.12;
				Fbs.MovePlaneFb.Velocity := 0.5;
				Fbs.MovePlaneFb.Acceleration := 1;
				Fbs.MovePlaneFb.Execute := TRUE;
				state := 50;
			END_IF
		50:
			IF Fbs.MovePlaneFb.Done THEN
				Fbs.MovePlaneFb.Execute := FALSE;
				run := FALSE;
				state := 0;
			END_IF
	END_CASE;
	 
	Fbs.LoadMacroFb();
	Fbs.MovePlaneFb();
	Fbs.RunMacroFb();
END_PROGRAM
