
TYPE
	InspectStationStateEnum : 
		(
		INSPECT_OFF, (*Inspect station is currently disabled*)
		INSPECT_INIT, (*Inspect station is initalizing*)
		INSPECT_WAIT_FOR_SHUTTLE, (*Inspect Station is waiting for a shuttle*)
		INSPECT_INSPECTING, (*Inspect station is inspecting product on the shuttle*)
		INSPECT_WAIT_FOR_UNLOAD_ENABLE,
		INSPECT_DONE, (*Inspect station is done with the inspection process*)
		INSPECT_ERROR (*Inspect station had an error*)
		);
	InspectStationFbTyp : 	STRUCT 
		Timer : TON;
		LedTimer : TOF;
	END_STRUCT;
END_TYPE
