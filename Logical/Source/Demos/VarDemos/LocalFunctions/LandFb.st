
FUNCTION_BLOCK LandFb
	
	CASE int.State OF
		LAND_IDLE: //**************************************************************** Idle State
			IF Enable THEN
				Active := TRUE;
				
				int.State := LAND_WAIT;
			END_IF
		LAND_ISSUE_CMD: //**************************************************************** Create Sh Group
			IF int.Fbs.LandFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := LAND_ERROR;
			ELSIF NOT Enable AND int.Fbs.LandFb.Done THEN
				int.Fbs.LandFb.Execute := FALSE;
				
				int.State := LAND_RESET;
			ELSIF int.Fbs.LandFb.Done THEN
				int.Landed := NOT int.Landed;
				int.Fbs.LandFb.Execute := FALSE;
				
				int.State := LAND_WAIT;
			END_IF
		LAND_WAIT: //**************************************************************** Waiting for an update cmd
			IF NOT Enable THEN
				IF Land THEN
					int.Fbs.LandFb.Controller := ADR(Controller);
					int.Fbs.LandFb.Level := mcACP6D_LEVEL_LEVITATE;
					int.Fbs.LandFb.ShuttleID := Pars.ShId;
					int.Fbs.LandFb.Execute := TRUE;
					
					int.State := LAND_ISSUE_CMD;
				ELSE
					int.State := LAND_RESET;
				END_IF
			ELSIF (Land AND NOT int.Landed) OR (NOT Land AND int.Landed) THEN
				IF int.Landed THEN
					int.Fbs.LandFb.Level := mcACP6D_LEVEL_LEVITATE;
				ELSE 
					int.Fbs.LandFb.Level := mcACP6D_LEVEL_LAND;
				END_IF
				int.Fbs.LandFb.Controller := ADR(Controller);
				int.Fbs.LandFb.ShuttleID := Pars.ShId;
				int.Fbs.LandFb.Execute := TRUE;
				
				int.State := LAND_ISSUE_CMD;
			END_IF
			
		LAND_ERROR: //**************************************************************** Error STate
			IF NOT Enable THEN
				int.State := LAND_RESET;
			END_IF
			
		LAND_RESET: //**************************************************************** Reset state
			Active := FALSE;
			Error := FALSE;
			int.Landed := FALSE;
			
			int.Fbs.LandFb.Execute := FALSE;
			
			int.State := LAND_IDLE;
	END_CASE;
	
	int.Fbs.LandFb();
END_FUNCTION_BLOCK
