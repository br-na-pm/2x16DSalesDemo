
{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK SlideUpDownFb (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Enable : {REDUND_UNREPLICABLE} BOOL;
		Pars : REFERENCE TO SlideUpDownParTyp;
	END_VAR
	VAR_OUTPUT
		Error : {REDUND_UNREPLICABLE} BOOL;
		Active : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR
		int : {REDUND_UNREPLICABLE} SlideUpDownInternalTyp;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MixProfileFb
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Enable : BOOL;
		Pars : REFERENCE TO MixProfileParTyp;
	END_VAR
	VAR_OUTPUT
		Error : BOOL;
		Active : BOOL;
	END_VAR
	VAR
		int : MixProfileIntTyp;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK WeighShuttleFb
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Execute : BOOL;
		Pars : REFERENCE TO WeighShuttleParTyp;
	END_VAR
	VAR_OUTPUT
		Error : BOOL;
		Active : BOOL;
		Done : BOOL;
		Weight : REAL;
	END_VAR
	VAR
		int : WeighShuttleIntTyp;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ForceCtrlFb
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Enable : BOOL;
		Update : BOOL;
		Pars : REFERENCE TO ForceCtrlParTyp;
	END_VAR
	VAR_OUTPUT
		Error : BOOL;
		Active : BOOL;
	END_VAR
	VAR
		int : ForceCtrlIntTyp;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK WaveFb (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Enable : {REDUND_UNREPLICABLE} BOOL;
		Pars : REFERENCE TO WaveParTyp;
	END_VAR
	VAR_OUTPUT
		Error : {REDUND_UNREPLICABLE} BOOL;
		Active : {REDUND_UNREPLICABLE} BOOL;
		Running : BOOL;
	END_VAR
	VAR
		int : {REDUND_UNREPLICABLE} WaveIntTyp;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK AntiSloshFb (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Enable : {REDUND_UNREPLICABLE} BOOL;
		ReCalcContainer : BOOL;
		Pars : REFERENCE TO AntiSloshParTyp;
	END_VAR
	VAR_OUTPUT
		Error : {REDUND_UNREPLICABLE} BOOL;
		ContainerParsCalculated : BOOL;
		Active : {REDUND_UNREPLICABLE} BOOL;
		ShuttleWriteValid : BOOL;
		ShapeActive : BOOL;
		VirtualCyclicActive : BOOL;
	END_VAR
	VAR
		int : {REDUND_UNREPLICABLE} AntiSloshIntTyp;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK LandFb (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Enable : {REDUND_UNREPLICABLE} BOOL;
		Land : {REDUND_UNREPLICABLE} BOOL;
		Pars : REFERENCE TO LandParsTyp;
	END_VAR
	VAR_OUTPUT
		Error : {REDUND_UNREPLICABLE} BOOL;
		Active : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR
		int : {REDUND_UNREPLICABLE} LandIntTyp;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK GenericMotionDemoFB (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Enable : {REDUND_UNREPLICABLE} BOOL;
		Land : {REDUND_UNREPLICABLE} BOOL;
		Pars : REFERENCE TO GenDemoParType;
	END_VAR
	VAR_OUTPUT
		Error : {REDUND_UNREPLICABLE} BOOL;
		Active : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR
		int : {REDUND_UNREPLICABLE} GenDemoIntTyp;
	END_VAR
END_FUNCTION_BLOCK
