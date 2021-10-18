

PROGRAM _INIT
	
	FOR i:=0 TO gMainIf.Cfg.ShuttleCount-1 DO
		gShuttleIf[i].Par.X := 0.06;
		gShuttleIf[i].Par.Y := 0.06 * (i + 1) + 0.06*i;
		gShuttleIf[i].Par.Accel := 10;
		gShuttleIf[i].Par.Vel := 0.5;
		gShuttleIf[i].Par.EndVel := 0;
	END_FOR;
	gProcessRecipe.General.Velocity := 1;
	gProcessRecipe.General.Accel := 10;
END_PROGRAM