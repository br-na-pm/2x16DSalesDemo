

PROGRAM _INIT
	//Temporarily disable the monitoring of the status of the system to prevent log book flooding
	SystemStsIf.Cmd.DisableMon := FALSE;
	 
END_PROGRAM