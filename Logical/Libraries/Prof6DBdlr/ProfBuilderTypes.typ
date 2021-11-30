
TYPE
	ProfBuilderIntTyp : 	STRUCT 
		State : ProfBuilderStatesEnum;
		ErrorState : ProfBuilderStatesEnum;
		idx : USINT;
		Fbs : ProfBuilderFbIntTyp;
	END_STRUCT;
	ProfBuilderFbIntTyp : 	STRUCT 
		InPlaneFb : MC_BR_MoveInPlane_Acp6D;
		ArcFb : MC_BR_MoveArcAngle_Acp6D;
		WaitFb : MC_BR_WaitUntilTime_Acp6D;
		LevitateCtrlFb : MC_BR_LevitationCtrl_Acp6D;
	END_STRUCT;
	ProfBuilderStatesEnum : 
		(
		PB_IDLE,
		PB_CHECK_IDX,
		PB_CMD_MOVE,
		PB_WAIT_LAST,
		PB_DONE,
		PB_ERROR,
		PB_RESET
		);
END_TYPE
