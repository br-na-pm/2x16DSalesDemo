
FUNCTION_BLOCK GenericMotionDemoFB
	
	CASE int.State OF
		GEN_IDLE: //**************************************************************** Idle State
			IF Enable THEN
				Active := TRUE;
				
				int.Fbs.BufferCtrl.Controller := ADR(Controller);
				int.Fbs.BufferCtrl.Option := mcACP6D_BUFFER_BLOCK;
				int.Fbs.BufferCtrl.ShuttleID := 0;
				int.Fbs.BufferCtrl.Execute := TRUE;
				
				int.State := GEN_BLOCK_BUFFER;
			END_IF
		GEN_BLOCK_BUFFER: //**************************************************************** Block Buffer
			IF int.Fbs.BufferCtrl.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := GEN_ERROR;
			ELSIF int.Fbs.BufferCtrl.Done THEN
				int.Fbs.BufferCtrl.Execute := FALSE;
				
				int.Fbs.MacroRunFB.Controller := ADR(Controller);
				int.Fbs.MacroRunFB.ShuttleID := Pars.ShId[0];
				int.Fbs.MacroRunFB.MacroID := Pars.MacroId[0];
				int.Fbs.MacroRunFB.Execute := TRUE;
				
				int.State := GEN_RUN_MACRO1;
			END_IF
		GEN_RUN_MACRO1: //**************************************************************** Run Macro 1
			IF int.Fbs.MacroRunFB.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := GEN_ERROR;
			ELSIF int.Fbs.MacroRunFB.Acknowledge THEN
				int.Fbs.MacroRunFB.Execute := FALSE;
				int.Fbs.MacroRunFB.ShuttleID := Pars.ShId[1];
				int.Fbs.MacroRunFB.MacroID := Pars.MacroId[1];
				
				int.State := GEN_RUN_MACRO2;
			END_IF
		GEN_RUN_MACRO2: //**************************************************************** Run Macro 2
			int.Fbs.MacroRunFB.Execute := TRUE;
			IF int.Fbs.MacroRunFB.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := GEN_ERROR;
			ELSIF int.Fbs.MacroRunFB.Acknowledge THEN
				int.Fbs.MacroRunFB.Execute := FALSE;
				
				int.Fbs.BufferCtrl.Option := mcACP6D_BUFFER_RELEASE;
				int.Fbs.BufferCtrl.Execute := TRUE;
				
				int.State := GEN_RELEASE_BUFFER;
			END_IF	
			
		GEN_RELEASE_BUFFER: //**************************************************************** Block Buffer
			IF int.Fbs.BufferCtrl.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := GEN_ERROR;
			ELSIF int.Fbs.BufferCtrl.Done THEN
				int.Fbs.BufferCtrl.Execute := FALSE;
				
				int.State := GEN_RUN_DEMO;
			END_IF
		GEN_RUN_DEMO: //**************************************************************** Run Demo State
			IF NOT Enable THEN
				int.Fbs.StopFb.Controller := ADR(Controller);
				int.Fbs.StopFb.ShuttleID := 0;
				int.Fbs.StopFb.Execute := TRUE;
				int.State := GEN_STOP;
			END_IF
		GEN_STOP:  //**************************************************************** Stopping Shuttle state
			IF int.Fbs.StopFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := GEN_ERROR;
			ELSIF int.Fbs.StopFb.Done THEN
				int.Fbs.StopFb.Execute := FALSE;
					
				int.Fbs.ShortAxisFb.Controller := ADR(Controller);
				int.Fbs.ShortAxisFb.PositionZ := 0.001;
				int.Fbs.ShortAxisFb.ShuttleID := Pars.ShId[0];
				int.Fbs.ShortAxisFb.VelocityZ := 1;
				int.Fbs.ShortAxisFb.Execute := TRUE;
				
				int.State := GEN_RESET_HEIGHT1;
			END_IF
		GEN_RESET_HEIGHT1: //**************************************************************** Reset Height 1
			IF int.Fbs.ShortAxisFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := GEN_ERROR;
			ELSIF int.Fbs.ShortAxisFb.Done THEN
				int.Fbs.ShortAxisFb.Execute := FALSE;
				
				int.Fbs.ShortAxisFb.ShuttleID := Pars.ShId[1];
				int.State := GEN_RESET_HEIGHT2;
			END_IF
		GEN_RESET_HEIGHT2: //**************************************************************** Reset Height 2
			int.Fbs.ShortAxisFb.Execute := TRUE;
			IF int.Fbs.ShortAxisFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := GEN_ERROR;
			ELSIF int.Fbs.ShortAxisFb.Done THEN
				int.Fbs.ShortAxisFb.Execute := FALSE;
				
				int.State := GEN_RESET;
			END_IF
		GEN_ERROR: //**************************************************************** Error state
			IF NOT Enable THEN
				int.State := GEN_RESET;
			END_IF
			
		GEN_RESET: //**************************************************************** Reset state
			Active := FALSE;
			Error := FALSE;
			
			
			int.Fbs.ShortAxisFb.Execute := FALSE;
			int.Fbs.BufferCtrl.Execute := FALSE;
			int.Fbs.MacroRunFB.Execute := FALSE;
			int.Fbs.StopFb.Execute := FALSE;
			
			int.State := GEN_IDLE;;
	END_CASE;
	
	int.Fbs.ShortAxisFb();
	int.Fbs.BufferCtrl();
	int.Fbs.MacroRunFB();
	int.Fbs.StopFb();
	
END_FUNCTION_BLOCK
