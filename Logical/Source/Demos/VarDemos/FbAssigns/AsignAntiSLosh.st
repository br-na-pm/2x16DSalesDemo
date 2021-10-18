
ACTION AsignAntiSLosh: 
	
	Fbs.AutoDriveFb.Controller := ADR(gMcAcp6DController);
	Fbs.AutoDriveFb.Velocity := 0.5;
	Fbs.AutoDriveFb.Acceleration := 2;
	Fbs.AutoDriveFb.NumberOfShuttles := 2;
	Fbs.AutoDriveFb.ShuttleID[0] := 1;
	Fbs.AutoDriveFb.ShuttleID[1] := 2;
	Fbs.AutoDriveFb.PositionX[0] := 0.06;
	Fbs.AutoDriveFb.PositionX[1] := 0.06;
	Fbs.AutoDriveFb.PositionY[0] := 0.06;
	Fbs.AutoDriveFb.PositionY[1] := 0.18;
	
	gVariousDemoIf.Sts.CurrentDemo := VAR_DEMO_ANTI_SLOSH;
END_ACTION
