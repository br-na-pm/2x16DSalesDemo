
TYPE
	Monitor6DFbsTyp : 	STRUCT 
		SegStsFb : ARRAY[0..NUM_SEGMENTS_ARRAY]OF MC_BR_SegGetStatus_Acp6D;
		SysStsFb : MC_BR_SysGetStatus_Acp6D;
		WaitTonFb : TON;
	END_STRUCT;
	Monitor6DStateEnum : 
		(
		MON_IDLE,
		MON_SYS_STATUS,
		MON_SEG_STATUS,
		MON_WAIT,
		MON_ERROR,
		MON_RESET
		);
	Monitor6DIfTyp : 	STRUCT 
		Cmd : Monitor6DCmdTyp;
		Sts : Monitor6DStsTyp;
	END_STRUCT;
	Monitor6DCmdTyp : 	STRUCT 
		DisableMon : BOOL;
		Reset : BOOL;
	END_STRUCT;
	Monitor6DStsTyp : 	STRUCT 
		Segments : ARRAY[0..NUM_SEGMENTS_ARRAY]OF McAcp6DGetSegStatusInfoType;
		System : McAcp6DGetSysStatusInfoType;
	END_STRUCT;
END_TYPE
