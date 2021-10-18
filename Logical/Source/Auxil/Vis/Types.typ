
TYPE
	ShVisTyp : 	STRUCT 
		ID : USINT;
		Visible : BOOL;
		Color : INT;
		DoseHolder : BOOL;
		CubeHolder : BOOL;
		ProdFill : ARRAY[0..8]OF FillProductTyp;
		ProdColor : INT;
		Pos : McAcp6DShPositionInfoType;
		ScnViewer : ScnViewerConnectionTyp;
	END_STRUCT;
	VisTyp : 	STRUCT 
		Shuttles : {REDUND_UNREPLICABLE} ARRAY[0..MAX_SHUTTLE_COUNT_ARRAY]OF ShVisTyp;
		Camera : ARRAY[0..1]OF USINT;
		Robot : RobotTyp;
	END_STRUCT;
	VisShuttleStateEnum : 
		(
		VIS_INIT,
		VIS_ACTIVE,
		VIS_ERROR
		);
	ScnViewerConnectionTyp : 	STRUCT 
		EnablePositioner : USINT;
		EnablePath : BOOL;
		ClearPath : BOOL;
		PathColor : ARRAY[0..2]OF REAL; (*0-Red, 1-Green, 2-Blue*)
		PathLength : UDINT;
		PathOffset : PointTyp;
	END_STRUCT;
	ShuttleColorEnum : 
		(
		COLOR_RED := 1,
		COLOR_BLUE_MATTE,
		COLOR_GREY_MATTE,
		COLOR_YELLOW_MATTE,
		COLOR_GREEN_MATTE,
		COLOR_ORANGE_MATTE,
		COLOR_WHITE_MATTE,
		COLOR_BLACK_MATTE
		);
	PointTyp : 	STRUCT 
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
	RobotTyp : 	STRUCT 
		PosQ1 : REAL;
		PosQ2 : REAL;
		PosQ3 : REAL;
		DoseHolder : BOOL;
		CubeHolder : BOOL;
	END_STRUCT;
	FillProductTyp : 	STRUCT 
		Vis : BOOL;
		Material : USINT;
	END_STRUCT;
END_TYPE
