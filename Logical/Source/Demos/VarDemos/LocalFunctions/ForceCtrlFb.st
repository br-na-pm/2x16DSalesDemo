(*
*)
FUNCTION_BLOCK ForceCtrlFb
	CASE int.State OF
		FORCE_IDLE: //******************************************************************************** Idle Wait State
			IF Enable THEN
				Active := TRUE;
				Update := FALSE;
				
				int.Fbs.ForceCtrlFb.Controller := ADR(Controller);
				int.Fbs.ForceCtrlFb.Mode := Pars.ForceMode;
				int.Fbs.ForceCtrlFb.ForceX := Pars.ForceX;
				int.Fbs.ForceCtrlFb.ForceY := Pars.ForceY;
				int.Fbs.ForceCtrlFb.ForceZ := Pars.ForceZ;
				int.Fbs.ForceCtrlFb.ShuttleID := Pars.ShId;
				int.Fbs.ForceCtrlFb.Execute := TRUE;
				
				int.State := FORCE_ENABLE;
			END_IF
		FORCE_ENABLE:  //******************************************************************************** Enabling Force Ctrl
			IF int.Fbs.ForceCtrlFb.Error THEN
				int.ErrorState := int.State;
				int.State := FORCE_ERROR;
			ELSIF int.Fbs.ForceCtrlFb.Done THEN
				int.Fbs.ForceCtrlFb.Execute := FALSE;
				
				int.State := FORCE_CTRL;
			END_IF
				
		FORCE_CTRL://******************************************************************************** Force Ctrl Active
			IF NOT Enable OR Update THEN
				int.Fbs.ForceCtrlFb.Mode := mcACP6D_FORCE_MODE_EXIT;
				int.Fbs.ForceCtrlFb.Execute := TRUE;
				
				int.State := FORCE_DISABLE;
			END_IF
		FORCE_DISABLE: //******************************************************************************** Exiting Force Ctrl
			IF int.Fbs.ForceCtrlFb.Error THEN
				int.ErrorState := int.State;
				int.State := FORCE_ERROR;
			ELSIF int.Fbs.ForceCtrlFb.Done THEN
				int.Fbs.ForceCtrlFb.Execute := FALSE;
				
				IF Update THEN
					Update := FALSE;
					int.Fbs.ForceCtrlFb.Mode := Pars.ForceMode;
					int.Fbs.ForceCtrlFb.ForceX := Pars.ForceX;
					int.Fbs.ForceCtrlFb.ForceY := Pars.ForceY;
					int.Fbs.ForceCtrlFb.ForceZ := Pars.ForceZ;
					int.Fbs.ForceCtrlFb.ShuttleID := Pars.ShId;
					int.Fbs.ForceCtrlFb.Execute := TRUE;
				ELSE
					int.State := FORCE_RESET;
				END_IF
				
			END_IF
		FORCE_ERROR: //******************************************************************************** Error present
			IF NOT Enable THEN
				int.State := FORCE_RESET;
			END_IF
		FORCE_RESET: //******************************************************************************** Reset State
			Active := FALSE;
			Error := FALSE;
			
			int.Fbs.ForceCtrlFb.Execute := FALSE;
		
			int.State := FORCE_IDLE;
	END_CASE; 
	
	//Call the FBs
	int.Fbs.ForceCtrlFb();
	
END_FUNCTION_BLOCK
