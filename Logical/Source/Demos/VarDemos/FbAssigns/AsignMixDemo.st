
ACTION AsignMixDemo: 
	mixPars[0].VirtualShuttle.Id := 0;
	mixPars[0].VirtualShuttle.MacroId := 138;
	mixPars[0].Shuttle.Id := 1;
	mixPars[0].Shuttle.MacroId := 139;
	mixPars[0].StartPosition.X := 0.125;
	mixPars[0].StartPosition.Y := 0.125;
	mixPars[0].LevitationHeight := 0.001;

	mixPars[1].VirtualShuttle.Id := 0;
	mixPars[1].VirtualShuttle.MacroId := 138;
	mixPars[1].Shuttle.Id := 2;
	mixPars[1].Shuttle.MacroId := 138;
	mixPars[1].StartPosition.X := 0.365;
	mixPars[1].StartPosition.Y := 0.125;
	mixPars[1].LevitationHeight := 0.001;
	
	Fbs.MixProfFb[0].Controller := ADR(gMcAcp6DController);
	Fbs.MixProfFb[0].Pars := ADR(mixPars[0]);
	
	Fbs.MixProfFb[1].Controller := ADR(gMcAcp6DController);
	Fbs.MixProfFb[1].Pars := ADR(mixPars[1]);
	
	Fbs.AutoDriveFb.Controller := ADR(gMcAcp6DController);
	Fbs.AutoDriveFb.Velocity := 0.5;
	Fbs.AutoDriveFb.Acceleration := 2;
	Fbs.AutoDriveFb.NumberOfShuttles := 2;
	Fbs.AutoDriveFb.ShuttleID[0] := mixPars[0].Shuttle.Id;
	Fbs.AutoDriveFb.ShuttleID[1] := mixPars[1].Shuttle.Id;
	Fbs.AutoDriveFb.PositionX[0] := mixPars[0].StartPosition.X;
	Fbs.AutoDriveFb.PositionX[1] := mixPars[1].StartPosition.X;
	Fbs.AutoDriveFb.PositionY[0] := mixPars[0].StartPosition.Y;
	Fbs.AutoDriveFb.PositionY[1] := mixPars[1].StartPosition.Y;
	
	gVariousDemoIf.Sts.CurrentDemo := VAR_DEMO_MIX;
END_ACTION
