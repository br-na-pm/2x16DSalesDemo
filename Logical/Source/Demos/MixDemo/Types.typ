
TYPE
	MoveTyp : 	STRUCT 
		X : REAL;
		Y : REAL;
		Vel : REAL;
		Accel : REAL;
		EndVel : REAL;
		Angle : REAL;
	END_STRUCT;
	FbsTyp : 	STRUCT 
		MovePlaneFb : MC_BR_MoveInPlane_Acp6D;
		MoveArcFb : MC_BR_MoveArcAngle_Acp6D;
		Wait : TON;
		RunMacroFb : MC_BR_MacroRun_Acp6D;
		LoadMacroFb : MC_BR_MacroLoad_Acp6D;
	END_STRUCT;
END_TYPE
