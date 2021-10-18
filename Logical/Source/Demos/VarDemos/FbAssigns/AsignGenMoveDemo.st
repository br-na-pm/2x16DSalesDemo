
ACTION AsignGenericDemoMovement: 
	genDemoPars.ShId[0] := 1;
	genDemoPars.ShId[1] := 2;
	genDemoPars.MacroId[0] := 140;
	genDemoPars.MacroId[1] := 141;

	genDemoPars.StartPositions[0].X := 0.240;
	genDemoPars.StartPositions[0].Y := 0.06;
	genDemoPars.StartPositions[1].X := 0.240;
	genDemoPars.StartPositions[1].Y := 0.18;
	
	Fbs.GenericDemoFb.Controller := ADR(gMcAcp6DController);
	Fbs.GenericDemoFb.Pars := ADR(genDemoPars);
	
	Fbs.AutoDriveFb.Controller := ADR(gMcAcp6DController);
	Fbs.AutoDriveFb.Velocity := 0.5;
	Fbs.AutoDriveFb.Acceleration := 2;
	Fbs.AutoDriveFb.NumberOfShuttles := 2;
	Fbs.AutoDriveFb.ShuttleID[0] := 1;
	Fbs.AutoDriveFb.ShuttleID[1] := 2;
	Fbs.AutoDriveFb.PositionX[0] := genDemoPars.StartPositions[0].X;
	Fbs.AutoDriveFb.PositionX[1] := genDemoPars.StartPositions[1].X;
	Fbs.AutoDriveFb.PositionY[0] := genDemoPars.StartPositions[0].Y;
	Fbs.AutoDriveFb.PositionY[1] := genDemoPars.StartPositions[1].Y;;
	
	gVariousDemoIf.Sts.CurrentDemo := VAR_DEMO_GENERIC_MOVEMENT;
END_ACTION
