

PROGRAM _INIT
	gLoadStIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gLoadStIf.Cfg.StationPos.X := 0.54;
	gLoadStIf.Cfg.StationPos.Y := 0.06;
	
	
	stationFbs.PosGen();
END_PROGRAM