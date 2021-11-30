
TYPE
	ProfBuilderMovePosParTyp : 	STRUCT 
		XPos : REAL;
		YPos : REAL;
		ZPos : REAL;
		RxPos : REAL;
		RyPos : REAL;
		RzPos : REAL;
	END_STRUCT;
	ProfBuilderMoveDynParTyp : 	STRUCT 
		Vel : REAL;
		Accel : REAL;
		EndVel : REAL;
	END_STRUCT;
	ProfBuilderPlaneParTyp : 	STRUCT 
		Path : McAcp6DInPlaneMovePathEnum;
		Mode : McAcp6DMoveModeEnum;
	END_STRUCT;
	ProfBuilderArcParTyp : 	STRUCT 
		Angle : REAL;
		Mode : McAcp6DMoveModeEnum;
		Direction : McAcp6DArcDirectionEnum;
	END_STRUCT;
	ProfBuilderMoveTyp : 
		(
		profMoveNone,
		profMovePlane,
		profMoveArc,
		profLand
		);
	ProfBuilderMoveParTyp : 	STRUCT 
		Positions : ProfBuilderMovePosParTyp;
		Dynamics : ProfBuilderMoveDynParTyp;
		InPlanePar : ProfBuilderPlaneParTyp;
		ArcPar : ProfBuilderArcParTyp;
		MoveType : ProfBuilderMoveTyp;
		WaitTime : UDINT;
		LandPar : McAcp6DLevitationLevelEnum;
	END_STRUCT;
	ProfBuilderParTyp : 	STRUCT 
		NumMoves : USINT;
		Moves : ARRAY[0..MAX_NUM_MOVES_ARRAY]OF ProfBuilderMoveParTyp;
	END_STRUCT;
END_TYPE
