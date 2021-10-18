
TYPE
	WaveParsTyp : 	STRUCT 
		Amp : REAL;
		Center : REAL;
		Freq : REAL;
		X : REAL;
		Y : REAL;
	END_STRUCT;
	ShuttleOutputTyp : 	STRUCT 
		Height : REAL;
		Angle : REAL;
		X : REAL;
	END_STRUCT;
	WaveStateEnum : 
		(
		WAVE_IDLE,
		WAVE_MOVE_TO_START,
		WAVE_CREATE_GROUP,
		WAVE_BOND_GROUP,
		WAVE_CFG_CHANNEL,
		WAVE_SET_HEIGHT,
		WAVE_WAVE,
		WAVE_EXIT_CFG,
		WAVE_STOP,
		WAVE_MOVE_BACK,
		WAVE_UNBOUND_GROUP,
		WAVE_DELETE_GROUP,
		WAVE_ERROR
		);
	WaveFbsTyp : 	STRUCT 
		CyclicChCtrlFb : MC_BR_WriteCyclicChCtrl_Acp6D;
		CyclicZFb : MC_BR_WriteCyclicCh_Acp6D;
		CyclicRxFb : MC_BR_WriteCyclicCh_Acp6D;
		CyclicXFb : MC_BR_WriteCyclicCh_Acp6D;
		AutoDriveFB : MC_BR_MoveInPlaneAsync_Acp6D;
		GroupCreateFb : MC_BR_ShGroupCreate_Acp6D;
		GroupDeleteFb : MC_BR_ShGroupDelete_Acp6D;
		GroupCtrlFb : MC_BR_ShGroupCoupleCtrl_Acp6D;
		ShortAxisFb : MC_BR_MoveShortAxis_Acp6D;
	END_STRUCT;
END_TYPE
