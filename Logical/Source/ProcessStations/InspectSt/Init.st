

PROGRAM _INIT
	gInspectIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gInspectIf.Cfg.StationPos.X := 0.30;
	gInspectIf.Cfg.StationPos.Y := 0.30;
	LedTime := T#150ms;
END_PROGRAM