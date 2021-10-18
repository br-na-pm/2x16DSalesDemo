
TYPE
	LoadStationStateEnum : 
		(
		LOAD_OFF, (*Load station is currently disabled*)
		LOAD_INIT, (*Load station is initalizing*)
		LOAD_WAIT_FOR_SHUTTLE, (*Load Station is waiting for a shuttle*)
		LOAD_WAIT_CFG_IF,
		LOAD_CFG_CYCLIC_POS,
		LOAD_WAIT_ROBOT,
		LOAD_LOADING, (*Load station is loading product onto a shuttle*)
		LOAD_CLEAR_BUFFER,
		LOAD_DONE, (*Load station is done with the unload process*)
		LOAD_ERROR (*Load station had an error*)
		);
	LoadStationFbTyp : 	STRUCT 
		Timer : TON;
		ReadCyclicPos : MC_BR_ReadCyclicChAxis_Acp6D;
		RunMacro : MC_BR_MacroRun_Acp6D;
		ClearBuffer : MC_BR_BufferCtrl_Acp6D;
		PathInfluence : MC_BR_OnlinePathInfluence_15;
		Stop : MC_BR_Stop_Acp6D;
		PosGen : MTBasicsLimiter;
	END_STRUCT;
END_TYPE
