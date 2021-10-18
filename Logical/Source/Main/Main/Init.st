

PROGRAM _INIT
	gMainIf.Cfg.ShuttleCount := 8;
	
	gMainIf.Cfg.Enable6D := TRUE;
	gMainIf.Cfg.EnableRobot := TRUE;
	
	gMainIf.Par.ProcessDemoTime := T#120s;
	gMainIf.Par.DanceDemoTime := T#180s;
	
	//Used to initialize the shuttle indecies.
	FOR i:=0 TO gMainIf.Cfg.ShuttleCount-1 DO
		gShuttleIf[i].Cfg.ShuttleId := i + 1;
	END_FOR;
	 
END_PROGRAM