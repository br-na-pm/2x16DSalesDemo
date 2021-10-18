
TYPE
	RecoveryFbs : 	STRUCT 
		AsyncMoveFb : MC_BR_MoveInPlaneAsync_Acp6D;
		ShStopFb : MC_BR_Stop_Acp6D;
		DelayFb : TON;
	END_STRUCT;
	RecoveryStateEnum : 
		(
		RECOVER_IDLE, (*Recovery is in an idle state*)
		RECOVER_INIT, (*Initalize recovery state*)
		RECOVER_AUTODRIVE, (*Preform autodrive movement for recovery*)
		RECOVER_STOP,
		RECOVER_DONE, (*Recovery has been completed*)
		RECOVER_ERROR (*Recovery had an error*)
		);
END_TYPE
