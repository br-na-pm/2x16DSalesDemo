
PROGRAM _CYCLIC
	IF gAcp6DCtrlIf.Sts.Error THEN
		state := MAIN_ERROR;
	END_IF
	
	IF gMainIf.Cmd.StopAllShuttles THEN
		Fbs.StopAllFb.Controller := ADR(gMcAcp6DController);
		Fbs.StopAllFb.Execute := TRUE;
		IF Fbs.StopAllFb.Done OR Fbs.StopAllFb.Error THEN
			Fbs.StopAllFb.Execute := FALSE;
			gMainIf.Cmd.StopAllShuttles := FALSE;
		END_IF
	END_IF
	
	
	CASE state OF
		MAIN_OFF: //******************************************************************************** Main Off State
			IF gMainIf.Cmd.Power THEN
				gAcp6DCtrlIf.Cmd.Power := gMainIf.Cfg.Enable6D;
				
				state := MAIN_INIT;
			END_IF
			
		MAIN_INIT: //******************************************************************************** Main Initializing State
			IF (gAcp6DCtrlIf.Sts.PowerOn AND gAcp6DCtrlIf.Sts.Ready OR NOT gMainIf.Cfg.Enable6D) THEN
				gMainIf.Sts.Power6D := TRUE;
				
				state := MAIN_READY;
			ELSIF NOT gMainIf.Cmd.Power THEN
				gAcp6DCtrlIf.Cmd.Power := FALSE;
				
				gMainIf.Sts.Power6D := FALSE;
				
				state := MAIN_OFF;
			END_IF
		MAIN_RECOVERING: //******************************************************************************** Main Recovery State
			IF (g6DRecoveryIf.Sts.ReadyToStartProc OR NOT gMainIf.Cfg.Enable6D) THEN
				g6DRecoveryIf.Cmd.Recover := FALSE;
				
				state := MAIN_READY;
			END_IF	
		MAIN_READY://******************************************************************************** Main Ready State
			IF NOT gMainIf.Cmd.Power THEN
				gMainIf.Sts.Power6D := FALSE;
				gAcp6DCtrlIf.Cmd.Power := FALSE;
				
				state := MAIN_OFF;
			END_IF
					
		MAIN_STARTING://******************************************************************************** Main Starting State
			IF gAcp6DCtrlIf.Sts.Error THEN
				state := MAIN_ERROR;
			ELSIF NOT gMainIf.Cmd.Power THEN 
				gMainIf.Cmd.StartDemoCycle := FALSE;
				gMainIf.Sts.Power6D := FALSE;
				gAcp6DCtrlIf.Cmd.Power := FALSE;
				
				state := MAIN_OFF;
			END_IF			
						
		MAIN_RUN_PROCESS: //******************************************************************************** Main Process State
		MAIN_STOPPING: //******************************************************************************** Main Stopping State
			
		MAIN_ERROR: //******************************************************************************** Main Error State
			IF gMainIf.Cmd.Reset THEN
				gMainIf.Cmd.Reset := FALSE;
				
				gMainIf.Sts.Running := FALSE;
				gAcp6DCtrlIf.Cmd.ErrorReset := TRUE;
				Fbs.TimerFb.IN := FALSE;
				
				IF gMainIf.Cmd.Power THEN
					state := MAIN_READY;
				ELSE
					state := MAIN_OFF;
				END_IF
			END_IF	
	END_CASE; 
	 
	Fbs.StopAllFb();
END_PROGRAM
