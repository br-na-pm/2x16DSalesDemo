

PROGRAM _INIT
	ST_name(0,ADR(taskName),0);
	
	stationFbs.NCR_DemoFb.Controller := ADR(gMcAcp6DController);
	
	IF taskName = 'ProcSt1' THEN
		pStIf ACCESS ADR(gProcessStIf[STATION_1]);
		pStPars ACCESS ADR(gProcessRecipe.St1);
		
	ELSIF taskName = 'ProcSt2' THEN
		pStIf ACCESS ADR(gProcessStIf[STATION_2]);
		pStPars ACCESS ADR(gProcessRecipe.St2);
	END_IF
	
	
	gProcessStIf[STATION_1].Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gProcessStIf[STATION_1].Cfg.StationPos.X := 0.66;
	gProcessStIf[STATION_1].Cfg.StationPos.Y := 0.54;
	
	gProcessStIf[STATION_2].Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gProcessStIf[STATION_2].Cfg.StationPos.X := 0.30;
	gProcessStIf[STATION_2].Cfg.StationPos.Y := 0.66;
	
	gProcessRecipe.St1.OperationPos.X := 0.84;
	gProcessRecipe.St1.OperationPos.Y := 0.6;
	
	gProcessRecipe.St1.ExitPos.X := 0.66;
	gProcessRecipe.St1.ExitPos.Y := 0.66;
		
	gProcessRecipe.St2.OperationPos.X := 0.12;
	gProcessRecipe.St2.OperationPos.Y := 0.6;
	
	gProcessRecipe.St2.ExitPos.X := 0.30;
	gProcessRecipe.St2.ExitPos.Y := 0.54;
END_PROGRAM