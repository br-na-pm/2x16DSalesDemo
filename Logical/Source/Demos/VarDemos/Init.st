

PROGRAM _INIT
	
	delayTime := T#400ms;
		
	Fbs.ForceCtrlFB[0].Controller := ADR(gMcAcp6DController);
	Fbs.ForceCtrlFB[0].Pars := ADR(forcePars[0]);
	
	mixPars[0].MixTime := T#4s;
	mixPars[1].MixTime := T#4s;
END_PROGRAM