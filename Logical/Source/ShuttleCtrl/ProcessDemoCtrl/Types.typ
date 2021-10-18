
TYPE
	ProcessDemoStateEnum : 
		(
		PROCESS_IDLE,
		PROCESS_ROUTING,
		PROCESS_STARTUP,
		PROCESS_RUN_DEMO,
		PROCESS_STOPPING_STATIONS,
		PROCESS_STOPPING,
		PROCESS_UNLOAD_PROGRAM,
		PROCESS_ERROR,
		PROCESS_RESET
		);
	ProcessDemoFbsTyp : 	STRUCT 
		Stop6DFb : MC_BR_Stop_Acp6D;
		MoveProgramFb : MC_BR_MoveProgram;
		StopRobotFb : MC_GroupStop;
		UnloadProgramFb : MC_BR_UnloadProgram;
	END_STRUCT;
END_TYPE
