
ACTION AsignWeighDemo: 
	//weighPars[0].SettleTime := T#500ms;
	weighPars[0].ShId := 1;
	weighPars[0].TareWeight := -0.013;
	weighPars[0].StartPosition.X := 0.060;
	weighPars[0].StartPosition.Y := 0.060;
	
	//weighPars[1].SettleTime := T#500ms;
	weighPars[1].ShId := 2;
	weighPars[1].TareWeight := -0.0325;
	weighPars[1].StartPosition.X := 0.420;
	weighPars[1].StartPosition.Y := 0.060;
	
	Fbs.WeighFB[0].Controller := ADR(gMcAcp6DController);
	Fbs.WeighFB[0].Pars := ADR(weighPars[0]);
	
	Fbs.WeighFB[1].Controller := ADR(gMcAcp6DController);
	Fbs.WeighFB[1].Pars := ADR(weighPars[1]);
	
	Fbs.AutoDriveFb.Controller := ADR(gMcAcp6DController);
	Fbs.AutoDriveFb.Velocity := 0.5;
	Fbs.AutoDriveFb.Acceleration := 2;
	Fbs.AutoDriveFb.NumberOfShuttles := 2;
	Fbs.AutoDriveFb.ShuttleID[0] := weighPars[0].ShId;
	Fbs.AutoDriveFb.ShuttleID[1] := weighPars[1].ShId;
	Fbs.AutoDriveFb.PositionX[0] := weighPars[0].StartPosition.X;
	Fbs.AutoDriveFb.PositionX[1] := weighPars[1].StartPosition.X;
	Fbs.AutoDriveFb.PositionY[0] := weighPars[0].StartPosition.Y;
	Fbs.AutoDriveFb.PositionY[1] := weighPars[1].StartPosition.Y;
	
	gVariousDemoIf.Sts.CurrentDemo := VAR_DEMO_WEIGH;
END_ACTION
