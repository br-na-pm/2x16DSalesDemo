
ACTION AsignLandDemo: 
	landPars[0].ShId := 1;
	landPars[1].ShId := 2;
		
	landPars[0].StartPosition.X := 0.12;
	landPars[0].StartPosition.Y := 0.12;

	landPars[1].StartPosition.X := 0.36;
	landPars[1].StartPosition.Y := 0.12;
	
	Fbs.LandCtrlFb[0].Controller := ADR(gMcAcp6DController);
	Fbs.LandCtrlFb[0].Pars := ADR(landPars[0]);
	Fbs.LandCtrlFb[1].Controller := ADR(gMcAcp6DController);
	Fbs.LandCtrlFb[1].Pars := ADR(landPars[1]);
	
	Fbs.AutoDriveFb.Controller := ADR(gMcAcp6DController);
	Fbs.AutoDriveFb.Velocity := 0.5;
	Fbs.AutoDriveFb.Acceleration := 2;
	Fbs.AutoDriveFb.NumberOfShuttles := 2;
	Fbs.AutoDriveFb.ShuttleID[0] := 1;
	Fbs.AutoDriveFb.ShuttleID[1] := 2;
	Fbs.AutoDriveFb.PositionX[0] := landPars[0].StartPosition.X;
	Fbs.AutoDriveFb.PositionX[1] := landPars[1].StartPosition.X;
	Fbs.AutoDriveFb.PositionY[0] := landPars[0].StartPosition.Y;
	Fbs.AutoDriveFb.PositionY[1] := landPars[1].StartPosition.Y;
	
	gVariousDemoIf.Sts.CurrentDemo := VAR_DEMO_LAND;
END_ACTION
