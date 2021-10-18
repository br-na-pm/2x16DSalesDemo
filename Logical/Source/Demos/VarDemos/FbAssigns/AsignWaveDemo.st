
ACTION AsignWaveDemo: 
	wavePars.DefaultLevitationHeight := 0.001;
	
	wavePars.StartPosition[0].X := 0.420;
	wavePars.StartPosition[0].Y := 0.055;
	wavePars.StartPosition[1].X := 0.420;
	wavePars.StartPosition[1].Y := 0.185;
	
	wavePars.Wave.Center := 2.2;
	wavePars.Wave.Amp := 1.0;
	
	wavePars.Wave.Freq := 1.5;
	wavePars.Slide.Freq := 0.05;
		
	Fbs.WaveFb.Controller := ADR(gMcAcp6DController);
	Fbs.WaveFb.Pars := ADR(wavePars);
	
	Fbs.AutoDriveFb.Controller := ADR(gMcAcp6DController);
	Fbs.AutoDriveFb.Velocity := 2;
	Fbs.AutoDriveFb.Acceleration := 0.5;
	Fbs.AutoDriveFb.NumberOfShuttles := 2;
	Fbs.AutoDriveFb.ShuttleID[0] := 1;
	Fbs.AutoDriveFb.ShuttleID[1] := 2;
	Fbs.AutoDriveFb.PositionX[0] := wavePars.StartPosition[0].X;
	Fbs.AutoDriveFb.PositionX[1] := wavePars.StartPosition[1].X;
	Fbs.AutoDriveFb.PositionY[0] := wavePars.StartPosition[0].Y;
	Fbs.AutoDriveFb.PositionY[1] := wavePars.StartPosition[1].Y;
	
	gVariousDemoIf.Sts.CurrentDemo := VAR_DEMO_WAVE;
END_ACTION
