
{REDUND_ERROR} FUNCTION_BLOCK NonCenterRotationFb (* *) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL;
		Controller : REFERENCE TO McAcp6DControllerType;
		ShId : USINT;
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		DemoRunning : BOOL;
		Done : BOOL;
		Error : BOOL;
	END_VAR
	VAR
		Internal : NonCenterRotateInternalTyp;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MatrixProcessFb
	VAR_INPUT
		Execute : BOOL;
		Controller : REFERENCE TO McAcp6DControllerType;
		ShId : USINT;
		NumRows : UINT;
		NumColumns : UINT;
		RowSpacing : REAL; (*Spacing between rows in meters*)
		ColSpacing : REAL; (*Spacing between columns in meters*)
		Acceleration : REAL; (*Acceleration for movements m/s2*)
		Velocity : REAL; (*Velocity for movements in m/s*)
		FillTime : TIME; (*Time to wait at each fill station*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		CurrentPocket : UINT;
		Filling : BOOL;
		Done : BOOL;
		Error : BOOL;
	END_VAR
	VAR
		Internal : MatrixProcInternalTyp;
	END_VAR
END_FUNCTION_BLOCK
