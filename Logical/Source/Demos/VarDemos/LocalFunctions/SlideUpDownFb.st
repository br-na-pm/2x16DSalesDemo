(* Demo implementation TO showcase robot tracking a master shuttle *)
(*
	Change robot program and call Sync Program (robot should be powered and ready to run)
	Cfg Cyclic Channel for shuttle
	Setup Sun/Planet for virtual shuttle/real shuttle
	Once ready to sync, enable online path influencer
	call loop macro on shuttle
	When no enable, stop shuttle, stop robot
	Reset

*)
FUNCTION_BLOCK SlideUpDownFb
	CASE int.State OF
		SLIDE_IDLE: //******************************************************************************** Idle Wait State
			IF Enable THEN
				int.Fbs.PlanetCtrlFb.Controller := ADR(Controller);
				int.Fbs.PlanetCtrlFb.Level := mcACP6D_PLANET_CONNECT;
				int.Fbs.PlanetCtrlFb.NumberOfPlanets := 2;
				int.Fbs.PlanetCtrlFb.StarShuttleID := Pars.VirtualShuttle.Id;
				int.Fbs.PlanetCtrlFb.PlanetShuttleID[0] := Pars.Shuttles[0].Id;
				int.Fbs.PlanetCtrlFb.PlanetShuttleID[1] := Pars.Shuttles[1].Id;
				int.Fbs.PlanetCtrlFb.Execute := TRUE;
								
				int.State := SLIDE_CREATE_GROUP;
			END_IF
		SLIDE_CREATE_GROUP: //******************************************************************************** Setting up the groups
			IF int.Fbs.PlanetCtrlFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := SLIDE_ERROR;
			ELSIF int.Fbs.PlanetCtrlFb.Done THEN
				int.Fbs.PlanetCtrlFb.Execute := FALSE;
				
				int.Fbs.RunMacroFb1.Controller := ADR(Controller);
				int.Fbs.RunMacroFb1.ShuttleID := Pars.Shuttles[0].Id;
				int.Fbs.RunMacroFb1.MacroID := Pars.Shuttles[0].MacroId;
				int.Fbs.RunMacroFb1.Execute := TRUE;
				
				int.Fbs.RunMacroFb2.Controller := ADR(Controller);
				int.Fbs.RunMacroFb2.ShuttleID := Pars.Shuttles[1].Id;
				int.Fbs.RunMacroFb2.MacroID := Pars.Shuttles[1].MacroId;
				int.Fbs.RunMacroFb2.Execute := TRUE;
				
				int.State := SLIDE_RUN_MACRO;
			END_IF
		SLIDE_RUN_MACRO: //******************************************************************************** Running Macro State
			IF int.Fbs.RunMacroFb2.Error OR int.Fbs.RunMacroFb1.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := SLIDE_ERROR;
			ELSIF int.Fbs.RunMacroFb2.Acknowledge AND int.Fbs.RunMacroFb1.Acknowledge THEN
				int.Fbs.RunMacroFb2.Execute := FALSE;
				int.Fbs.RunMacroFb1.Execute := FALSE;
				
				int.Fbs.MovePlaneFb.Controller := ADR(Controller);
				int.Fbs.MovePlaneFb.ShuttleID := Pars.VirtualShuttle.Id;
				int.Fbs.MovePlaneFb.Mode := mcACP6D_MOVE_RELATIVE;
				int.Fbs.MovePlaneFb.Path := mcACP6D_PATH_DIRECT;
				int.Fbs.MovePlaneFb.PositionX := Pars.MoveDistance;
				int.Fbs.MovePlaneFb.PositionY := 0;
				int.Fbs.MovePlaneFb.Velocity := Pars.MoveVelocity;
				int.Fbs.MovePlaneFb.Acceleration := Pars.MoveAcceleration;
				int.Fbs.MovePlaneFb.Execute := TRUE;
				
				int.State := SLIDE_SLIDE;
			END_IF
		SLIDE_SLIDE: //******************************************************************************** Slide demo state
			int.Fbs.MovePlaneFb.Execute := TRUE;
			IF int.Fbs.MovePlaneFb.Error THEN
				int.ErrorState := int.State ;
				Error := TRUE;
				int.State := SLIDE_ERROR;
			ELSIF NOT Enable THEN
				int.Fbs.MovePlaneFb.Execute := FALSE;
				
				int.Fbs.StopFb.Controller := ADR(Controller);
				int.Fbs.StopFb.ShuttleID := 0;
				int.Fbs.StopFb.Execute := TRUE;
				
				int.State := SLIDE_STOP;
			ELSIF int.Fbs.MovePlaneFb.Done THEN
				int.Fbs.MovePlaneFb.Execute := FALSE;
				int.Fbs.MovePlaneFb.PositionX := int.Fbs.MovePlaneFb.PositionX * -1; //Invert the position to move left/right
				
			END_IF
		SLIDE_STOP: //******************************************************************************** Stopping state
			IF int.Fbs.StopFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := SLIDE_ERROR;
			ELSIF int.Fbs.StopFb.Done THEN
				int.Fbs.StopFb.Execute := FALSE;
				
				int.Fbs.PlanetCtrlFb.Level := mcACP6D_PLANET_DISCONNECT;
				int.Fbs.PlanetCtrlFb.Execute := TRUE;
				
				int.State := SLIDE_DELETE_GROUP;
			END_IF
		SLIDE_DELETE_GROUP: //******************************************************************************** Deleting the group
			IF int.Fbs.PlanetCtrlFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := SLIDE_ERROR;
			ELSIF int.Fbs.PlanetCtrlFb.Done THEN
				int.Fbs.PlanetCtrlFb.Execute := FALSE;
				
				Active := FALSE;
								
				int.State := SLIDE_RESET;
			END_IF
		SLIDE_ERROR: //******************************************************************************** Error State
			IF NOT Enable THEN
				int.State := SLIDE_RESET;
			END_IF
		SLIDE_RESET: //******************************************************************************** Reset State
			Active := FALSE;
			Error := FALSE;
			
			int.Fbs.PlanetCtrlFb.Execute := FALSE;
			int.Fbs.MovePlaneFb.Execute := FALSE;
			int.Fbs.RunMacroFb1.Execute := FALSE;
			int.Fbs.RunMacroFb2.Execute := FALSE;
			int.Fbs.StopFb.Execute := FALSE;
		
			int.State := SLIDE_IDLE;
		

	END_CASE; 
	
	//Call the FBs
	int.Fbs.PlanetCtrlFb();
	int.Fbs.MovePlaneFb();
	int.Fbs.RunMacroFb1();
	int.Fbs.RunMacroFb2();
	int.Fbs.StopFb();
	
END_FUNCTION_BLOCK
