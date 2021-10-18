
TYPE
	IndvDanceDemoIfTyp : 	STRUCT 
		Cmd : IndvDanceDemoCmdTyp;
		Par : IndvDanceDemoParTyp;
		Sts : IndvDanceDemoStsTyp;
	END_STRUCT;
	IndvDanceDemoCmdTyp : 	STRUCT 
		Run : BOOL;
		Reset : BOOL;
	END_STRUCT;
	IndvDanceDemoStsTyp : 	STRUCT 
		Running : BOOL;
		Error : BOOL;
		Active : BOOL;
	END_STRUCT;
	IndvDanceDemoParTyp : 	STRUCT 
		RobotVelocity : REAL;
		RobotProgramName : STRING[260];
	END_STRUCT;
END_TYPE
