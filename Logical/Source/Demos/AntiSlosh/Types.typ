
TYPE
	AntiSloshParTyp : 	STRUCT 
		ShId : USINT;
		NonSloshShId : USINT;
		ContainerLength : REAL;
		FillHeight : REAL;
		ContainerType : SFBcontShapeEnum;
		AdvPars : SFBcontAdvancedType;
		ProfilePars : MTProfilePositionParameterType;
		Payload : REAL;
		DestPos : REAL;
	END_STRUCT;
	AntiSloshIntTyp : 	STRUCT 
		State : AntiSloshStatesEnum;
		ErrorState : AntiSloshStatesEnum;
		Fbs : AntiSloshFbsTyp;
		ContainerCalculated : BOOL;
	END_STRUCT;
	AntiSloshFbsTyp : 	STRUCT 
		ShaperFb : SFBshaper;
		ContainerFb : SFBcontainer;
		AxisFb : MpAxisBasic;
		CylcicPosFb : MC_BR_MoveCyclicPosition;
		CyclicChCtrlFb : MC_BR_WriteCyclicChCtrl_Acp6D;
		CyclicXFb : MC_BR_WriteCyclicCh_Acp6D;
		MoveCyclicPosFb : MC_BR_MoveCyclicPosition;
		ProfGen : MTProfilePositionGenerator;
		ShPropFb : MC_BR_ShSetProperty_Acp6D;
		ShortAxisFb : MC_BR_MoveShortAxis_Acp6D;
		MovePlaneFb : MC_BR_MoveInPlane_Acp6D;
		SettleTon : TON;
	END_STRUCT;
	AntiSloshStatesEnum : 
		(
		AS_IDLE,
		AS_POWER_AXIS,
		AS_HOME_AXIS,
		AS_HOME_GENERATOR,
		AS_CALC_PARS,
		AS_SET_HEIGHT,
		AS_SET_PAYLOAD,
		AS_SETUP_CYCLIC_CHANNEL,
		AS_ENABLE_CHANNEL,
		AS_SETUP_CYCLIC_AXIS_CTRL,
		AS_WAIT_MOVE,
		AS_MOVE,
		AS_DISABLE_CHANNEL,
		AS_RESET_HEIGHT,
		AS_RESET_PAYLOAD,
		AS_ERROR,
		AS_RESET
		);
END_TYPE
