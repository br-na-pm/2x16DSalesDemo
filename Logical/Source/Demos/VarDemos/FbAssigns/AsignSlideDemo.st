
ACTION AsignSlideDemo: 
	slidePars.GrpId := 1;
	slidePars.Shuttles[0].Id := 1;
	slidePars.Shuttles[0].MacroId := 135;
	slidePars.Shuttles[1].Id := 2;
	slidePars.Shuttles[1].MacroId := 136;
	slidePars.VirtualShuttle.Id := 100;
	slidePars.MoveVelocity := 1;
	slidePars.MoveDistance := 0.240;
	slidePars.MoveAcceleration := 10;
	slidePars.StartPositions[0].X := 0.060;
	slidePars.StartPositions[1].X := 0.180;
	slidePars.StartPositions[0].Y := 0.120;
	slidePars.StartPositions[1].Y := 0.120;
	
	Fbs.AutoDriveFb.Controller := ADR(gMcAcp6DController);
	Fbs.AutoDriveFb.NumberOfShuttles := 2;
	Fbs.AutoDriveFb.ShuttleID[0] := slidePars.Shuttles[0].Id;
	Fbs.AutoDriveFb.ShuttleID[1] := slidePars.Shuttles[1].Id;
	Fbs.AutoDriveFb.Velocity := 0.5;
	Fbs.AutoDriveFb.Acceleration := 2;
	Fbs.AutoDriveFb.PositionX[0] := slidePars.StartPositions[0].X;
	Fbs.AutoDriveFb.PositionX[1] := slidePars.StartPositions[1].X;
	Fbs.AutoDriveFb.PositionY[0] := slidePars.StartPositions[0].Y;
	Fbs.AutoDriveFb.PositionY[1] := slidePars.StartPositions[1].Y;
	
	Fbs.SlideFb.Controller := ADR(gMcAcp6DController);
	Fbs.SlideFb.Pars := ADR(slidePars);
	gVariousDemoIf.Sts.CurrentDemo := VAR_DEMO_SLIDE;
END_ACTION
