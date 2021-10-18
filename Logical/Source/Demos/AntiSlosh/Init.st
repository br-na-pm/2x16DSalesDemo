

PROGRAM _INIT
	Fbs.AxisFb.MpLink := ADR(gAxis_1);
	Fbs.AxisFb.Parameters := ADR(AxisPars);
	Fbs.AxisFb.Enable := TRUE;	
	Fbs.AxisFb();
	
	height := 0.001;
	
	Pars.ProfilePars.AccelerationNegDirection := 5000;
	Pars.ProfilePars.AccelerationPosDirection := 5000;
	Pars.ProfilePars.DecelerationNegDirection := 5000;
	Pars.ProfilePars.DecelerationPosDirection := 5000;
	Pars.ProfilePars.VelocityPosDirection := 1000;
	Pars.ProfilePars.VelocityNegDirection := 1000;
	
	
	Fbs.ProfGen.Enable := TRUE;
	Fbs.ProfGen.Parameter := Pars.ProfilePars;
	Fbs.ProfGen.HomePosition := 0;
	Fbs.ProfGen();
	
	Pars.ContainerLength := 0.065;
	Pars.FillHeight := 0.0325;
	AxisPars.Homing.Position := 0;
		
	 
END_PROGRAM