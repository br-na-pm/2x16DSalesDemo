(*Slide Up/Down Demo datatypes*)

TYPE
	SlideUpDownParTyp : 	STRUCT 
		StartPositions : ARRAY[0..1]OF StationPositionTyp;
		Shuttles : ARRAY[0..1]OF ShParTyp;
		VirtualShuttle : ShParTyp;
		GrpId : USINT;
		MoveDistance : REAL;
		MoveVelocity : REAL;
		MoveAcceleration : REAL;
	END_STRUCT;
	ShParTyp : 	STRUCT 
		Id : USINT;
		MacroId : USINT; (*Macro To Execute for the up/down movement*)
	END_STRUCT;
	SlideUpDownStateEnum : 
		(
		SLIDE_IDLE,
		SLIDE_CREATE_GROUP,
		SLIDE_RUN_MACRO,
		SLIDE_SLIDE,
		SLIDE_STOP,
		SLIDE_DELETE_GROUP,
		SLIDE_ERROR,
		SLIDE_RESET
		);
	SlideUpDownInternalTyp : 	STRUCT 
		State : SlideUpDownStateEnum;
		ErrorState : SlideUpDownStateEnum;
		Fbs : SlideUpDownFbsTyp;
	END_STRUCT;
	SlideUpDownFbsTyp : 	STRUCT 
		PlanetCtrlFb : MC_BR_PlanetCtrl_Acp6D;
		RunMacroFb1 : MC_BR_MacroRun_Acp6D;
		RunMacroFb2 : MC_BR_MacroRun_Acp6D;
		MovePlaneFb : MC_BR_MoveInPlane_Acp6D;
		StopFb : MC_BR_Stop_Acp6D;
	END_STRUCT;
END_TYPE

(*Mix Profile Types*)

TYPE
	MixProfileIntTyp : 	STRUCT 
		State : MixProfileStateEnum;
		ErrorState : MixProfileStateEnum;
		Fbs : MixProfileFbTyp;
	END_STRUCT;
	MixProfileParTyp : 	STRUCT 
		Shuttle : ShParTyp;
		VirtualShuttle : ShParTyp;
		LevitationHeight : REAL;
		StartPosition : StationPositionTyp;
		MixTime : TIME;
	END_STRUCT;
	MixProfileFbTyp : 	STRUCT 
		PlanetCtrlFb : MC_BR_PlanetCtrl_Acp6D;
		RunMacroFb : MC_BR_MacroRun_Acp6D;
		StopFb : MC_BR_Stop_Acp6D;
		MoveShortFb : MC_BR_MoveShortAxis_Acp6D;
		TimerTon : TON;
	END_STRUCT;
	MixProfileStateEnum : 
		(
		MIX_IDLE,
		MIX_ENABLE_GROUP,
		MIX_RUN_MACRO_VIRT,
		MIX_RUN_MACRO_REAL,
		MIX_RUN_DEMO,
		MIX_STOP_REAL,
		MIX_STOP_VIRTUAL,
		MIX_DELETE_GROUP,
		MIX_RESET_HEIGHT,
		MIX_ERROR,
		MIX_RESET
		);
END_TYPE

(*Weight Shuttle Fb Types*)

TYPE
	WeighShuttleParTyp : 	STRUCT 
		ShId : USINT;
		StartPosition : StationPositionTyp;
		TareWeight : REAL;
		SettleTime : TIME;
	END_STRUCT;
	WeighShuttleIntTyp : 	STRUCT 
		State : WeighShuttleStatesEnum;
		ErrorState : WeighShuttleStatesEnum;
		Fbs : WeighShuttleFbTyp;
	END_STRUCT;
	WeighShuttleFbTyp : 	STRUCT 
		SettleFb : TON;
		WeighFb : MC_BR_GetPayload_Acp6D;
	END_STRUCT;
	WeighShuttleStatesEnum : 
		(
		WEIGH_IDLE,
		WEIGH_SETTLE,
		WEIGH_WEIGH,
		WEIGH_DONE,
		WEIGH_ERROR,
		WEIGH_RESET
		);
END_TYPE

(*Force Ctrl Fb Types*)

TYPE
	ForceCtrlParTyp : 	STRUCT 
		ShId : USINT;
		ForceX : REAL;
		ForceY : REAL;
		ForceZ : REAL;
		ForceMode : McAcp6DForceModeLevelEnum;
		StartPosition : StationPositionTyp;
	END_STRUCT;
	ForceCtrlIntTyp : 	STRUCT 
		State : ForceCtrlStatesEnum;
		ErrorState : ForceCtrlStatesEnum;
		Fbs : ForceCtrlFbsTyp;
	END_STRUCT;
	ForceCtrlFbsTyp : 	STRUCT 
		ForceCtrlFb : MC_BR_ForceModeCtrl_Acp6D;
	END_STRUCT;
	ForceCtrlStatesEnum : 
		(
		FORCE_IDLE,
		FORCE_ENABLE,
		FORCE_CTRL,
		FORCE_DISABLE,
		FORCE_ERROR,
		FORCE_RESET
		);
END_TYPE

(*Wave Fb Types*)

TYPE
	WaveParTyp : 	STRUCT 
		Wave : SinWaveParType;
		Slide : SinWaveParType;
		DefaultLevitationHeight : REAL;
		StartPosition : ARRAY[0..1]OF StationPositionTyp;
	END_STRUCT;
	SinWaveParType : 	STRUCT 
		Amp : REAL;
		Center : REAL;
		Freq : REAL;
		X : REAL;
		Y : REAL;
	END_STRUCT;
	ShuttleOutputTyp : 	STRUCT 
		Height : REAL;
		Angle : REAL;
		Pos : REAL;
		WaveX : REAL;
		WaveY : REAL;
	END_STRUCT;
	WaveIntTyp : 	STRUCT 
		State : WaveStateEnum;
		ErrorState : WaveStateEnum;
		WaveCtrl : ShuttleOutputTyp;
		SlideCtrl : ShuttleOutputTyp;
		Fbs : WaveFbsTyp;
	END_STRUCT;
	WaveFbsTyp : 	STRUCT 
		CyclicChCtrlFb : MC_BR_WriteCyclicChCtrl_Acp6D;
		CyclicZFb : MC_BR_WriteCyclicCh_Acp6D;
		CyclicRxFb : MC_BR_WriteCyclicCh_Acp6D;
		CyclicXFb : MC_BR_WriteCyclicCh_Acp6D;
		GroupCreateFb : MC_BR_ShGroupCreate_Acp6D;
		GroupDeleteFb : MC_BR_ShGroupDelete_Acp6D;
		GroupCtrlFb : MC_BR_ShGroupCoupleCtrl_Acp6D;
		ShortAxisFb : MC_BR_MoveShortAxis_Acp6D;
	END_STRUCT;
END_TYPE

(*Anti Slosh Fb Types*)

TYPE
	WaveStateEnum : 
		(
		WAVE_IDLE,
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
	AntiSloshParTyp : 	STRUCT 
		AxisRef : REFERENCE TO McAxisType;
		AxisPars : MpAxisBasicParType;
		ShId : USINT;
		ContainerLength : REAL;
		FillHeight : REAL;
		ContainerType : SFBcontShapeEnum;
		AdvPars : SFBcontAdvancedType;
		ProfilePars : MTProfilePositionParameterType;
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
	END_STRUCT;
	AntiSloshStatesEnum : 
		(
		AS_IDLE,
		AS_ENABLE_AXIS,
		AS_POWER_AXIS,
		AS_HOME_AXIS,
		AS_CALC_PARS,
		AS_SETUP_CYCLIC_CHANNEL,
		AS_ENABLE_CHANNEL,
		AS_SETUP_CYCLIC_AXIS_CTRL,
		AS_WAIT_MOVE,
		AS_MOVE,
		AS_ERROR,
		AS_RESET
		);
END_TYPE

(*Land/Levitate Types*)

TYPE
	LandParsTyp : 	STRUCT 
		ShId : USINT;
		StartPosition : StationPositionTyp;
		Move : McAcp6DLevitationLevelEnum;
	END_STRUCT;
	LandIntTyp : 	STRUCT 
		State : LandStateEnum;
		ErrorState : LandStateEnum;
		Landed : BOOL;
		Fbs : LandFbsTyp;
	END_STRUCT;
	LandFbsTyp : 	STRUCT 
		LandFb : MC_BR_LevitationCtrl_Acp6D;
	END_STRUCT;
	LandStateEnum : 
		(
		LAND_IDLE,
		LAND_ISSUE_CMD,
		LAND_WAIT,
		LAND_ERROR,
		LAND_RESET
		);
END_TYPE

(*Generic Motion Profile Demo Types*)

TYPE
	GenDemoParType : 	STRUCT 
		ShId : ARRAY[0..1]OF USINT;
		MacroId : ARRAY[0..1]OF USINT;
		StartPositions : ARRAY[0..1]OF StationPositionTyp;
	END_STRUCT;
	GenDemoStateEnum : 
		(
		GEN_IDLE,
		GEN_BLOCK_BUFFER,
		GEN_RUN_MACRO1,
		GEN_RUN_MACRO2,
		GEN_RELEASE_BUFFER,
		GEN_RUN_DEMO,
		GEN_STOP,
		GEN_RESET_HEIGHT1,
		GEN_RESET_HEIGHT2,
		GEN_ERROR,
		GEN_RESET
		);
	GenDemoFbsTyp : 	STRUCT 
		ShortAxisFb : MC_BR_MoveShortAxis_Acp6D;
		MacroRunFB : MC_BR_MacroRun_Acp6D;
		BufferCtrl : MC_BR_BufferCtrl_Acp6D;
		StopFb : MC_BR_Stop_Acp6D;
	END_STRUCT;
	GenDemoIntTyp : 	STRUCT 
		State : GenDemoStateEnum;
		ErrorState : GenDemoStateEnum;
		Fbs : GenDemoFbsTyp;
	END_STRUCT;
END_TYPE
