
PROGRAM _CYCLIC

	IF NOT gInspectIf.Cmd.LocalOverride THEN
		stationPars := gProcessRecipe.Inspect;
	END_IF
	
	CASE state OF
		INSPECT_OFF: //********************************************************************************Load station is currently disabled
			IF gInspectIf.Cmd.Enable THEN
				state := INSPECT_INIT;
			ELSIF gInspectIf.Cmd.Reset THEN
				state := INSPECT_ERROR;
			END_IF
		INSPECT_INIT: //********************************************************************************Load station is initalizing
			gInspectIf.Sts.ReadyForNewShuttle := TRUE;
			gInspectIf.Sts.Enabled := TRUE;
			
			state := INSPECT_WAIT_FOR_SHUTTLE;	
		INSPECT_WAIT_FOR_SHUTTLE: //********************************************************************************Load station is waiting for a shuttle to be present
			IF NOT gInspectIf.Cmd.Enable THEN
				gInspectIf.Sts.ReadyForNewShuttle := FALSE;
				gInspectIf.Sts.Enabled := FALSE;
				state := INSPECT_OFF;
			ELSIF gInspectIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gInspectIf.Cmd.Process THEN
				gInspectIf.Sts.ReadyForNewShuttle := FALSE;
				gInspectIf.Sts.Processing := TRUE;
				
				stationFbs.Timer.IN := TRUE;
				stationFbs.Timer.PT := stationPars.DwellTime;
				
				stationFbs.LedTimer.IN := TRUE;
				stationFbs.LedTimer.PT := LedTime;
				state := INSPECT_INSPECTING;
			END_IF
		INSPECT_INSPECTING:
			IF stationFbs.LedTimer.Q THEN
				stationFbs.LedTimer.IN := FALSE;
			END_IF
			IF stationFbs.Timer.Q THEN
				stationFbs.Timer.IN := FALSE;
				
				state := INSPECT_WAIT_FOR_UNLOAD_ENABLE;
			END_IF
		INSPECT_WAIT_FOR_UNLOAD_ENABLE: 
			IF gUnloadStIf.Sts.Enabled THEN
				gInspectIf.Sts.Processing := FALSE;
				gInspectIf.Sts.Done := TRUE;
				gShuttleIf[gInspectIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;				
				
				state := INSPECT_DONE;
			ELSIF NOT gInspectIf.Cmd.Enable THEN
				gInspectIf.Sts.Done := FALSE;
				gInspectIf.Sts.Enabled := FALSE;
				gInspectIf.Sts.ReadyForNewShuttle := FALSE;
				gInspectIf.Sts.Processing := FALSE;
				stationFbs.Timer.IN := FALSE;
				
				gInspectIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				state := INSPECT_OFF;
			END_IF
		INSPECT_DONE: //********************************************************************************Load station is done with the load process
			IF NOT gInspectIf.Cmd.Enable THEN
				gInspectIf.Sts.Done := FALSE;
				gInspectIf.Sts.Enabled := FALSE;
				gInspectIf.Sts.ReadyForNewShuttle := FALSE;
				stationFbs.Timer.IN := FALSE;
				gInspectIf.Sts.Processing := FALSE;
				
				gInspectIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				state := INSPECT_OFF;
			ELSE
				gInspectIf.Cmd.Process := FALSE;
				gInspectIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gInspectIf.Sts.Done := FALSE;
				gInspectIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := INSPECT_WAIT_FOR_SHUTTLE;
			END_IF
			
		INSPECT_ERROR: //********************************************************************************Load station had an error
			IF gInspectIf.Cmd.Reset THEN
				gInspectIf.Cmd.Reset := FALSE;
				
				gInspectIf.Sts.Done := FALSE;
				gInspectIf.Sts.Enabled := FALSE;
				gInspectIf.Sts.Error := FALSE;
				gInspectIf.Sts.Processing := FALSE;
				gInspectIf.Sts.ReadyForNewShuttle := FALSE;
				
				stationFbs.LedTimer.IN := FALSE;
				stationFbs.Timer.IN := FALSE;
				
				gInspectIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF gInspectIf.Cmd.Enable THEN
					state := INSPECT_INIT;
				ELSE
					state := INSPECT_OFF;
				END_IF
			END_IF
	END_CASE;
		
	stationFbs.Timer();
	stationFbs.LedTimer();
END_PROGRAM
