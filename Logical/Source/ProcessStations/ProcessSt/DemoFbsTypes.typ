(*Non Center Rotate Internal Typ*)

TYPE
	NonCenterRotateInternalTyp : 	STRUCT 
		state : NCRStateEnum;
		errorState : NCRStateEnum;
		Fbs : NonCenterRotateFbsTyp;
	END_STRUCT;
	NCRStateEnum : 
		(
		NCR_IDLE,
		NCR_MOVE_1,
		NCR_MOVE_2,
		NCR_MOVE_3,
		NCR_MOVE_4,
		NCR_MOVE_5,
		NCR_MOVE_6,
		NCR_DONE,
		NCR_ERROR,
		NCR_RESET
		);
	NonCenterRotateFbsTyp : 	STRUCT 
		DelayTimerFb : TON;
		ShortAxisFb : MC_BR_MoveShortAxis_Acp6D;
		ShStopFb : MC_BR_Stop_Acp6D;
	END_STRUCT;
END_TYPE

(*Matrix Process Types*)

TYPE
	MatrixProcInternalTyp : 	STRUCT 
		state : MatrixProcStateEnum;
		errorState : MatrixProcStateEnum;
		cRow : UINT;
		cCol : UINT;
		fillDir : MatrixFillDirType;
		Fbs : MatrixProcFbsTyp;
	END_STRUCT;
	MatrixProcFbsTyp : 	STRUCT 
		MoveInPlaneFb : MC_BR_MoveInPlane_Acp6D;
		FillTimerFb : TON;
	END_STRUCT;
	MatrixProcStateEnum : 
		(
		MAT_IDLE,
		MAT_MOVE,
		MAT_FILL,
		MAT_MOVE_BACK,
		MAT_DONE,
		MAT_ERROR,
		MAT_RESET
		);
	MatrixFillDirType : 
		(
		FILL_RIGHT,
		FILL_LEFT
		);
END_TYPE
