
TYPE
	UnloadStationStateEnum : 
		(
		UNLOAD_OFF, (*Unload station is currently disabled*)
		UNLOAD_INIT, (*Unload station is initalizing*)
		UNLOAD_WAIT_FOR_SHUTTLE, (*Unload Station is waiting for a shuttle*)
		UNLOAD_WAIT_CFG_IF,
		UNLOAD_CFG_CYCLIC_POS,
		UNLOAD_WAIT_ROBOT,
		UNLOAD_UNLOADING, (*Unload station is loading product onto a shuttle*)
		UNLOAD_CLEAR_BUFFER,
		UNLOAD_DONE, (*Unload station is done with the unload process*)
		UNLOAD_ERROR (*Unload station had an error*)
		);
	UnloadStationFbTyp : 	STRUCT 
		Timer : TON;
		ReadCyclicPos : MC_BR_ReadCyclicChAxis_Acp6D;
		RunMacro : MC_BR_MacroRun_Acp6D;
		ClearBuffer : MC_BR_BufferCtrl_Acp6D;
		PathInfluence : MC_BR_OnlinePathInfluence_15;
		Stop : MC_BR_Stop_Acp6D;
	END_STRUCT;
END_TYPE
