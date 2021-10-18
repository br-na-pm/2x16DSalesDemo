(* This task control the demo routine for the process demo
	The robot and the 6D are expected to be powered on, homed and not in any error states before starting this demo

	Recovery
	Robot Setup
	Enable Stations
	Run Demo
	Error
	Stopping
	Reset	
*)

PROGRAM _CYCLIC
	CASE state OF
		PROCESS_IDLE:  //******************************************************************************** Idle Wait State
			IF gProcessPickPlaceIf.Cmd.RunDemo THEN
				g6DRecoveryIf.Cmd.Recover := TRUE;
				
				state := PROCESS_ROUTING;
			ELSIF gProcessPickPlaceIf.Cmd.Reset THEN
				state := PROCESS_RESET;
			END_IF
		PROCESS_ROUTING:  //******************************************************************************** Running the routing demo
			IF g6DRecoveryIf.Sts.Error THEN
				gProcessPickPlaceIf.Sts.Error := TRUE;
				state := PROCESS_ERROR;
			ELSIF (g6DRecoveryIf.Sts.ReadyToStartProc) THEN
				g6DRecoveryIf.Cmd.Recover := FALSE;
				
				gLoadStIf.Cmd.Enable := TRUE;
				//gUnloadStIf.Cmd.Enable := TRUE; The Load station will enable the Unload station in order to complete the Load process first
				gProcessStIf[STATION_1].Cmd.Enable := TRUE;
				gProcessStIf[STATION_2].Cmd.Enable := TRUE;
				gInspectIf.Cmd.Enable := TRUE;
				
				Fbs.MoveProgramFb.AxesGroup := ADR(g3AxDeltaA); 
				Fbs.MoveProgramFb.Name := 'ProcessDemo.gcode';
				Fbs.MoveProgramFb.Execute := TRUE;
				
				state := PROCESS_STARTUP;
			END_IF	
		PROCESS_STARTUP:  //******************************************************************************** Starting up the demos state
			IF gLoadStIf.Sts.Error OR 
					gInspectIf.Sts.Error OR
					gProcessStIf[STATION_1].Sts.Error OR
					gProcessStIf[STATION_2].Sts.Error OR
					Fbs.MoveProgramFb.Error THEN
				gProcessPickPlaceIf.Sts.Error := TRUE;
				state := PROCESS_ERROR;
			ELSIF (gLoadStIf.Sts.Enabled AND
					//gUnloadStIf.Sts.Enabled AND The load station enables the unload station once the startup process has completed
					gInspectIf.Cmd.Enable AND 
					gProcessStIf[STATION_1].Sts.Enabled AND
					gProcessStIf[STATION_2].Sts.Enabled OR NOT gMainIf.Cfg.Enable6D)
					AND
					Fbs.MoveProgramFb.Phase = mcPRGPH_REAL_RUN THEN
			
				CmdShEnable(TRUE, ADR(gShuttleIf),gMainIf.Cfg.ShuttleCount);
				
				gProcessPickPlaceIf.Sts.DemoRunning := TRUE;	
				
				state := PROCESS_RUN_DEMO;		
			
			END_IF
		PROCESS_RUN_DEMO:  //******************************************************************************** Running the process demo
			IF Fbs.MoveProgramFb.Error OR
					gLoadStIf.Sts.Error OR
					gUnloadStIf.Sts.Error OR
					gProcessStIf[STATION_1].Sts.Error OR
					gProcessStIf[STATION_2].Sts.Error OR
					gInspectIf.Sts.Error THEN 
				state := PROCESS_ERROR;
			ELSIF NOT gProcessPickPlaceIf.Cmd.RunDemo THEN
				gLoadStIf.Cmd.Enable := FALSE;
				gUnloadStIf.Cmd.Enable := FALSE; 
				gProcessStIf[STATION_1].Cmd.Enable := FALSE;
				gProcessStIf[STATION_2].Cmd.Enable := FALSE;
				gInspectIf.Cmd.Enable := FALSE;
				
				state := PROCESS_STOPPING_STATIONS;
			END_IF
		PROCESS_STOPPING_STATIONS:  //******************************************************************************** Stopping the Stations
			gLoadStIf.Cmd.Enable := FALSE;
			gUnloadStIf.Cmd.Enable := FALSE; 
			gProcessStIf[STATION_1].Cmd.Enable := FALSE;
			gProcessStIf[STATION_2].Cmd.Enable := FALSE;
			gInspectIf.Cmd.Enable := FALSE;
			IF (NOT gLoadStIf.Sts.Enabled AND
					//gUnloadStIf.Sts.Enabled AND The load station enables the unload station once the startup process has completed
					NOT gInspectIf.Cmd.Enable AND 
					NOT gProcessStIf[STATION_1].Sts.Enabled AND
					NOT gProcessStIf[STATION_2].Sts.Enabled AND NOT gUnloadStIf.Sts.Enabled) AND Fbs.MoveProgramFb.Done 
					THEN
				
				Fbs.StopRobotFb.AxesGroup := ADR(g3AxDeltaA);
				Fbs.StopRobotFb.Execute := TRUE;
								
				Fbs.Stop6DFb.Controller := ADR(gMcAcp6DController);
				Fbs.Stop6DFb.ShuttleID := 0;
				Fbs.Stop6DFb.Execute := TRUE;
				
				state := PROCESS_STOPPING;				
			END_IF
		PROCESS_STOPPING:  //******************************************************************************** Stopping the demo
			IF Fbs.Stop6DFb.Error OR Fbs.StopRobotFb.Error THEN
				gProcessPickPlaceIf.Sts.Error := TRUE;
				
				state := PROCESS_ERROR;
			ELSIF Fbs.Stop6DFb.Done AND Fbs.StopRobotFb.Done THEN 
				Fbs.StopRobotFb.Execute := FALSE;
				Fbs.Stop6DFb.Execute := FALSE;
				
				gProcessPickPlaceIf.Sts.DemoRunning := FALSE;
				
				FOR i:=0 TO gMainIf.Cfg.ShuttleCount - 1 DO
					gShuttleIf[i].Cmd.Enable := FALSE;
					gShuttleIf[i].Sts.Recovered := FALSE;
				END_FOR;
				
				Fbs.UnloadProgramFb.AxesGroup := ADR(g3AxDeltaA);
				Fbs.UnloadProgramFb.Execute := TRUE;
				Fbs.UnloadProgramFb.Mode := mcUNLOADPRG_ALL;
				
				state := PROCESS_UNLOAD_PROGRAM;
			END_IF
		PROCESS_UNLOAD_PROGRAM:   //******************************************************************************** Unloading the program
			IF Fbs.UnloadProgramFb.Error THEN
				gProcessPickPlaceIf.Sts.Error := TRUE;
				
				state := PROCESS_ERROR;
			ELSIF Fbs.UnloadProgramFb.Done THEN
				Fbs.UnloadProgramFb.Execute := FALSE;
				
				state := PROCESS_RESET;
			END_IF
			
		PROCESS_ERROR:  //******************************************************************************** Demo in error state
			IF gProcessPickPlaceIf.Cmd.Reset THEN
				gLoadStIf.Cmd.Reset := TRUE;
				gUnloadStIf.Cmd.Reset:= TRUE; 
				gProcessStIf[STATION_1].Cmd.Reset := TRUE;
				gProcessStIf[STATION_2].Cmd.Reset := TRUE;
				gInspectIf.Cmd.Reset := TRUE;
				
				Fbs.Stop6DFb.Controller := ADR(gMcAcp6DController);
				Fbs.Stop6DFb.ShuttleID := 0;
				Fbs.Stop6DFb.Execute := TRUE;
				
				FOR i:= 0 TO gMainIf.Cfg.ShuttleCount - 1 DO
					gShuttleIf[i].Cmd.Enable := FALSE;
					gShuttleIf[i].Cmd.Reset := TRUE;
				END_FOR;
				state := PROCESS_RESET;
			END_IF
		PROCESS_RESET:  //******************************************************************************** Resetting the demo state
			Fbs.Stop6DFb.Execute := FALSE;
			Fbs.MoveProgramFb.Execute := FALSE;
			Fbs.StopRobotFb.Execute := FALSE;
			Fbs.UnloadProgramFb.Execute := FALSE;
			
			gDelta.Cmd.ErrorReset := gDelta.Status.Error;
			
			g6DRecoveryIf.Cmd.Reset := g6DRecoveryIf.Sts.Error;
			
			gLoadStIf.Cmd.Enable := FALSE;
			gUnloadStIf.Cmd.Enable := FALSE; 
			gProcessStIf[STATION_1].Cmd.Enable := FALSE;
			gProcessStIf[STATION_2].Cmd.Enable := FALSE;
			gInspectIf.Cmd.Enable := FALSE;
			
			gProcessPickPlaceIf.Cmd.PickLoad := FALSE;
			gProcessPickPlaceIf.Cmd.PickUnload := FALSE;
			gProcessPickPlaceIf.Cmd.RunDemo := FALSE;
			gProcessPickPlaceIf.Cmd.GetLoadPart := FALSE;
			
			gProcessPickPlaceIf.Sts.Error := FALSE;
			gProcessPickPlaceIf.Sts.DemoRunning := FALSE;
			gProcessPickPlaceIf.Sts.FinishedProductPresent := FALSE;
			gProcessPickPlaceIf.Sts.ReadyForLoad := FALSE;
			gProcessPickPlaceIf.Sts.ReadyForUnload := FALSE;
			gProcessPickPlaceIf.Sts.StartupComplete := FALSE;
			gProcessPickPlaceIf.Sts.Sync := FALSE;
			gProcessPickPlaceIf.Sts.UnfinishedProductPresent := FALSE;
			gProcessPickPlaceIf.Cmd.Reset := FALSE;
			gProcessPickPlaceIf.Sts.Place := FALSE;
			
			state := PROCESS_IDLE;	
	END_CASE;
	 
	Fbs.Stop6DFb();
	Fbs.MoveProgramFb();
	Fbs.UnloadProgramFb();
	Fbs.StopRobotFb();
END_PROGRAM
