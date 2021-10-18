
TYPE
	StationStateEnum : 
		(
		STATION_OFF, (*Station is currently disabled*)
		STATION_INIT, (*Station is initalizing*)
		STATION_WAIT_FOR_SHUTTLE, (*Station is waiting for a shuttle*)
		STATION_SH_ENTER,
		STATION_OPERATING, (*Station is preforming operation on shuttle*)
		STATION_SH_EXIT,
		STATION_DONE, (*Station is done with the process*)
		STATION_ERROR (*Station had an error*)
		);
	StationFbTyp : 	STRUCT 
		Timer : TON;
		MovePlane : MC_BR_MoveInPlane_Acp6D;
		RunMacroFb : MC_BR_MacroRun_Acp6D;
		NCR_DemoFb : NonCenterRotationFb;
		MatrixFb : MatrixProcessFb;
	END_STRUCT;
	ProcessStationDemoEnum : 
		(
		PROC_SPIRAL,
		PROC_MATRIX,
		PROC_Z_ROT,
		PROC_NCR
		);
END_TYPE
