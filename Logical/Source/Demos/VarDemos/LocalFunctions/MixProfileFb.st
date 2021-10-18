(*
*)
FUNCTION_BLOCK MixProfileFb
	CASE int.State OF
		MIX_IDLE: //******************************************************************************** Idle Wait State
			IF Enable THEN
				IF Pars.VirtualShuttle.Id <> 0 THEN
					int.Fbs.PlanetCtrlFb.Controller := ADR(Controller);
					int.Fbs.PlanetCtrlFb.Level := mcACP6D_PLANET_CONNECT;
					int.Fbs.PlanetCtrlFb.StarShuttleID:= Pars.VirtualShuttle.Id;
					int.Fbs.PlanetCtrlFb.NumberOfPlanets := 1;
					int.Fbs.PlanetCtrlFb.PlanetShuttleID[0] := Pars.Shuttle.Id;
					int.Fbs.PlanetCtrlFb.Execute := TRUE;
				
					int.State := MIX_ENABLE_GROUP;
				ELSE
					int.Fbs.RunMacroFb.Controller := ADR(Controller);
					int.Fbs.RunMacroFb.MacroID := Pars.Shuttle.MacroId;
					int.Fbs.RunMacroFb.ShuttleID := Pars.Shuttle.Id;
					int.Fbs.RunMacroFb.Execute := TRUE;
					
					int.State := MIX_RUN_MACRO_REAL;
				END_IF
			END_IF
		MIX_ENABLE_GROUP:  //******************************************************************************** Enable group 
			IF int.Fbs.PlanetCtrlFb.Error THEN
				int.ErrorState := int.State;
				int.State := MIX_ERROR;
			ELSIF int.Fbs.PlanetCtrlFb.Done THEN
				int.Fbs.PlanetCtrlFb.Execute := FALSE;
				
				int.Fbs.RunMacroFb.Controller := ADR(Controller);
				int.Fbs.RunMacroFb.MacroID := Pars.VirtualShuttle.MacroId;
				int.Fbs.RunMacroFb.ShuttleID := Pars.VirtualShuttle.Id;
				int.Fbs.RunMacroFb.Execute := TRUE;
				
				int.State := MIX_RUN_MACRO_VIRT;
			END_IF
		MIX_RUN_MACRO_VIRT://******************************************************************************** Run macro on virtual shuttle
			IF int.Fbs.RunMacroFb.Error THEN
				int.ErrorState := int.State;
				int.State := MIX_ERROR;
			ELSIF int.Fbs.RunMacroFb.Acknowledge THEN
				int.Fbs.RunMacroFb.Execute := FALSE;
				
				int.Fbs.RunMacroFb.MacroID := Pars.Shuttle.MacroId;
				int.Fbs.RunMacroFb.ShuttleID := Pars.Shuttle.Id;
				
				int.State := MIX_RUN_MACRO_REAL;
			END_IF
		MIX_RUN_MACRO_REAL: //******************************************************************************** RUn Maro on real shuttle
			int.Fbs.RunMacroFb.Execute := TRUE;
			IF int.Fbs.RunMacroFb.Error THEN
				int.ErrorState := int.State;
				int.State := MIX_ERROR;
			ELSIF int.Fbs.RunMacroFb.Acknowledge THEN
				int.Fbs.RunMacroFb.Execute := FALSE;
				
				int.Fbs.TimerTon.IN := TRUE;
				int.Fbs.TimerTon.PT := Pars.MixTime;
				
				int.State := MIX_RUN_DEMO;
			END_IF
		MIX_RUN_DEMO: //******************************************************************************** Running the demo
			IF NOT Enable OR int.Fbs.TimerTon.Q THEN
				int.Fbs.TimerTon.IN := FALSE;
				int.Fbs.StopFb.Controller := ADR(Controller);
				int.Fbs.StopFb.ShuttleID := Pars.VirtualShuttle.Id;
				int.Fbs.StopFb.Execute := TRUE;
				
				int.State := MIX_STOP_VIRTUAL;
			END_IF
		MIX_STOP_VIRTUAL: //******************************************************************************** Stopping the real shuttle
			IF int.Fbs.StopFb.Error THEN
				int.ErrorState := int.State;
				int.State := MIX_ERROR;
			ELSIF int.Fbs.StopFb.Done THEN
				int.Fbs.StopFb.Execute := FALSE;
				
				int.Fbs.StopFb.ShuttleID := Pars.Shuttle.Id;
				int.State := MIX_STOP_REAL;
			END_IF
		MIX_STOP_REAL: //******************************************************************************** Stopping the virtual shuttle
			int.Fbs.StopFb.Execute := TRUE;
			IF int.Fbs.StopFb.Error THEN
				int.ErrorState := int.State;
				int.State := MIX_ERROR;
			ELSIF int.Fbs.StopFb.Done THEN
				int.Fbs.StopFb.Execute := FALSE;
				
				IF Pars.VirtualShuttle.Id <> 0 THEN
					int.Fbs.PlanetCtrlFb.Level := mcACP6D_PLANET_DISCONNECT;
					int.Fbs.PlanetCtrlFb.Execute := TRUE;
					int.State := MIX_DELETE_GROUP;
				ELSE
					int.Fbs.MoveShortFb.Controller := ADR(Controller);
					int.Fbs.MoveShortFb.ShuttleID := Pars.Shuttle.Id;
					int.Fbs.MoveShortFb.PositionRx := 0;
					int.Fbs.MoveShortFb.PositionRy := 0;
					int.Fbs.MoveShortFb.PositionRz := 0;
					int.Fbs.MoveShortFb.PositionZ := Pars.LevitationHeight;
					int.Fbs.MoveShortFb.VelocityRx := 0.5;
					int.Fbs.MoveShortFb.VelocityRy := 0.5;
					int.Fbs.MoveShortFb.VelocityRz := 0.5;
					int.Fbs.MoveShortFb.VelocityZ := 1;
					int.Fbs.MoveShortFb.Execute := TRUE;
				
					int.State := MIX_RESET_HEIGHT;
				END_IF
						
			END_IF
		MIX_DELETE_GROUP: //******************************************************************************** Deleteing the sun/planet
			IF int.Fbs.PlanetCtrlFb.Error THEN
				int.ErrorState := int.State;
				int.State := MIX_ERROR;
			ELSIF int.Fbs.PlanetCtrlFb.Done THEN
				int.Fbs.PlanetCtrlFb.Execute := FALSE;
				
				int.Fbs.MoveShortFb.Controller := ADR(Controller);
				int.Fbs.MoveShortFb.ShuttleID := Pars.Shuttle.Id;
				int.Fbs.MoveShortFb.PositionRx := 0;
				int.Fbs.MoveShortFb.PositionRy := 0;
				int.Fbs.MoveShortFb.PositionRz := 0;
				int.Fbs.MoveShortFb.PositionZ := Pars.LevitationHeight;
				int.Fbs.MoveShortFb.VelocityRx := 0.5;
				int.Fbs.MoveShortFb.VelocityRy := 0.5;
				int.Fbs.MoveShortFb.VelocityRz := 0.5;
				int.Fbs.MoveShortFb.VelocityZ := 1;
				int.Fbs.MoveShortFb.Execute := TRUE;
				
				int.State := MIX_RESET_HEIGHT;
			END_IF
		MIX_RESET_HEIGHT: //******************************************************************************** Reset the shuttle's height
			IF int.Fbs.MoveShortFb.Error THEN
				int.ErrorState := int.State;
				int.State := MIX_ERROR;
			ELSIF int.Fbs.MoveShortFb.Done THEN
				int.Fbs.MoveShortFb.Execute := FALSE;
				
				Active := FALSE;
				int.State := MIX_RESET;
			END_IF
		MIX_ERROR: //******************************************************************************** Error State
			IF NOT Enable THEN
				int.State := MIX_RESET;
				
			END_IF
		MIX_RESET: //******************************************************************************** Reset the fbs and outputs
			Active := FALSE;
			Error := FALSE;
				
			int.Fbs.TimerTon.IN := FALSE;
			int.Fbs.MoveShortFb.Execute := FALSE;
			int.Fbs.PlanetCtrlFb.Execute := FALSE;
			int.Fbs.RunMacroFb.Execute := FALSE;
			int.Fbs.StopFb.Execute := FALSE;
		
			int.State := MIX_IDLE;
	END_CASE; 
	
	//Call the FBs
	
	int.Fbs.RunMacroFb();
	//int.Fbs.TimerTon();
	int.Fbs.PlanetCtrlFb();
	int.Fbs.MoveShortFb();
	int.Fbs.StopFb();
	
END_FUNCTION_BLOCK
