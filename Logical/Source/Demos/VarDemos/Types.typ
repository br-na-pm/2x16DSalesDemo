
TYPE
	FbsTyp : 	STRUCT 
		SlideFb : SlideUpDownFb;
		MixProfFb : ARRAY[0..1]OF MixProfileFb;
		AutoDriveFb : MC_BR_MoveInPlaneAsync_Acp6D;
		DelayFb : TON;
		WeighFB : ARRAY[0..1]OF WeighShuttleFb;
		ForceCtrlFB : ARRAY[0..1]OF ForceCtrlFb;
		WaveFb : WaveFb;
		LandCtrlFb : ARRAY[0..1]OF LandFb;
		GenericDemoFb : GenericMotionDemoFB;
	END_STRUCT;
	VariousDemoStateEnum : 
		(
		VAR_DEMO_IDLE,
		VAR_DEMO_MOVE_TO_START,
		VAR_DEMO_RUN,
		VAR_DEMO_STOP,
		VAR_DEMO_ERROR,
		VAR_DEMO_RESET
		);
	DemoHmiTyp : 	STRUCT 
		ModeChangable : BOOL;
		ResetEnable : BOOL;
		StopEnable : BOOL;
		RunEnable : BOOL;
	END_STRUCT;
END_TYPE
