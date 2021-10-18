
ACTION AsignForceDemo: 
	forcePars[0].ShId := 1;
	forcePars[0].ForceX := 0;
	forcePars[0].ForceY := 0;
	
	forcePars[0].StartPosition.X := 0.12;
	forcePars[0].StartPosition.Y := 0.12;
	
	forcePars[0].ForceMode := mcACP6D_FORCE_MODE_X_AXIS;
	
	forcePars[1].ShId := 2;
	forcePars[1].ForceX := 0;
	forcePars[1].ForceY := 0;
	
	forcePars[1].StartPosition.X := 0.36;
	forcePars[1].StartPosition.Y := 0.12;
	
	forcePars[1].ForceMode := mcACP6D_FORCE_MODE_X_AXIS;
	
	Fbs.ForceCtrlFB[0].Controller := ADR(gMcAcp6DController);
	Fbs.ForceCtrlFB[0].Pars := ADR(forcePars[0]);
	Fbs.ForceCtrlFB[1].Controller := ADR(gMcAcp6DController);
	Fbs.ForceCtrlFB[1].Pars := ADR(forcePars[1]);
	
	Fbs.AutoDriveFb.Controller := ADR(gMcAcp6DController);
	Fbs.AutoDriveFb.Velocity := 0.5;
	Fbs.AutoDriveFb.Acceleration := 2;
	Fbs.AutoDriveFb.NumberOfShuttles := 2;
	Fbs.AutoDriveFb.ShuttleID[0] := 1;
	Fbs.AutoDriveFb.ShuttleID[1] := 2;
	Fbs.AutoDriveFb.PositionX[0] := forcePars[0].StartPosition.X;
	Fbs.AutoDriveFb.PositionX[1] := forcePars[1].StartPosition.X;
	Fbs.AutoDriveFb.PositionY[0] := forcePars[0].StartPosition.Y;
	Fbs.AutoDriveFb.PositionY[1] := forcePars[1].StartPosition.Y;
	
	gVariousDemoIf.Sts.CurrentDemo := VAR_DEMO_FORCE;
END_ACTION
