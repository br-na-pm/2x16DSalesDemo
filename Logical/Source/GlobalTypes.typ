(*Main System Interface Types*)

TYPE
	MainIfTyp : 	STRUCT 
		Cmd : MainIfCmdTyp;
		Par : MainIfParTyp;
		Cfg : MainIfCfgTyp;
		Sts : MainIfStatusTyp;
	END_STRUCT;
	MainIfCmdTyp : 	STRUCT 
		Power : BOOL;
		StartDemoCycle : BOOL;
		StartDefinedDemo : BOOL;
		Stop : BOOL;
		Reset : BOOL;
		StopAllShuttles : BOOL;
	END_STRUCT;
	MainIfParTyp : 	STRUCT 
		AutoRecover6D : BOOL;
		DefinedDemo : USINT;
		ProcessDemoTime : TIME;
		DanceDemoTime : TIME;
	END_STRUCT;
	MainIfCfgTyp : 	STRUCT 
		ShuttleCount : USINT;
		EnableRobot : BOOL; (*Signals that the Robot should be powered on and used for the control*)
		Enable6D : BOOL; (*Signals that the 6D should be powered on and used for the control*)
	END_STRUCT;
	MainIfStatusTyp : 	STRUCT 
		Power6D : BOOL;
		PowerRobot : BOOL;
		Running : BOOL;
		Error : BOOL;
	END_STRUCT;
END_TYPE

(*Process Info Interface*)

TYPE
	ProcessInfoIfTyp : 	STRUCT 
		Cmd : ProcessInfoIfCmdTyp;
		Par : ProcessInfoIfParTyp;
		Sts : ProcessInfoIfStsTyp;
	END_STRUCT;
	ProcessInfoIfCmdTyp : 	STRUCT 
		Enable : BOOL;
		ResetData : BOOL;
	END_STRUCT;
	ProcessInfoIfParTyp : 	STRUCT 
		CurrentProductCount : UDINT;
	END_STRUCT;
	ProcessInfoIfStsTyp : 	STRUCT 
		Enabled : BOOL;
		CurrentPPM : REAL;
		CurrentPPH : REAL;
		CurrentBlistersPerMinute : REAL;
		CurrentLayersPerMinute : REAL;
	END_STRUCT;
END_TYPE

(*6D Controller Interface Types*)

TYPE
	Acp6DCmdType : 	STRUCT 
		Power : BOOL;
		ErrorReset : BOOL;
		GetErrorInfo : BOOL;
	END_STRUCT;
	Acp6DCtrlType : 	STRUCT 
		Cmd : Acp6DCmdType;
		Sts : Acp6DStatusType;
		Par : Acp6DParType;
	END_STRUCT;
	Acp6DParType : 	STRUCT 
		Mode : McAcp6DMoveModeEnum;
		PathType : McAcp6DInPlaneMovePathEnum;
		Acceleration : REAL;
		EndVelocity : REAL;
		Velocity : REAL;
		ShuttleID : USINT;
		SegmentID : USINT;
		PositionX : REAL;
		PositionY : REAL;
		MacroEnabled : BOOL;
	END_STRUCT;
	Acp6DStatusType : 	STRUCT 
		Error : BOOL;
		ErrorID : DINT;
		Ready : BOOL;
		PowerOn : BOOL;
		ReadyToPowerOn : BOOL;
		ErrorCodes : ARRAY[0..8]OF DINT;
	END_STRUCT;
	Acp6DShuttleInfoType : 	STRUCT 
		State : Acp6DShuttleStateInfoTyp;
		Force : Acp6DShuttleForceInfoTyp;
		Position : Acp6DShuttlePosInfoTyp;
	END_STRUCT;
	Acp6DShuttleStateInfoTyp : 	STRUCT 
		Valid : BOOL;
		Value : McAcp6DShuttleStateEnum;
	END_STRUCT;
	Acp6DShuttlePosInfoTyp : 	STRUCT 
		Valid : BOOL;
		Value : McAcp6DShPositionInfoType;
	END_STRUCT;
	Acp6DShuttleForceInfoTyp : 	STRUCT 
		Valid : BOOL;
		Value : McAcp6DShForceInfoType;
	END_STRUCT;
END_TYPE

(*Shuttle Interface Types*)

TYPE
	ShuttleIfCmdTyp : 	STRUCT  (*Commands for controlling a shuttle*)
		Enable : BOOL; (*Command for enabling the control of a shuttle in the process*)
		NextStep : BOOL; (*Command for a shuttle to start the next step in the process*)
		ResetProductInfo : BOOL; (*Command to reset all the product info on a shuttle*)
		Stop : BOOL; (*Command to stop the process for a shuttle*)
		RunProcessDemo : BOOL; (*Command to start the process demo*)
		Reset : BOOL;
	END_STRUCT;
	ShuttleIfCfgMacrosTyp : 	STRUCT  (*Structure of the macro IDs used for operation*)
		RobotProcessMacro : ShuttleIfMacroEnum; (*Macro ID used for sending a shuttle from the load station to the print station*)
	END_STRUCT;
	ShuttleIfParTyp : 	STRUCT  (*Parameters for the shuttle's operation*)
		X : REAL;
		Y : REAL;
		Vel : REAL;
		EndVel : REAL;
		Accel : REAL;
	END_STRUCT;
	ShuttleIfConfigTyp : 	STRUCT  (*Configuration values for a shuttle*)
		ShuttleId : USINT; (*ShuttleID of this shuttle*)
	END_STRUCT;
	ShuttleIfMacroEnum : 
		( (*Macro IDs that are used to denote which macro means what*)
		MACRO_ROBOT_PROCESS := 128, (*Macro ID used for sending a shuttle from the load station to the print station*)
		MACRO_ROBOT_PROCESS1, (*Macro ID used for sending a shuttle from the load station to the print station*)
		MACRO_RECOVERY_GROUP0 := 135, (*Macro ID used for recovering the group 0 shuttles*)
		MACRO_RECOVERY_GROUP1 (*Macro ID used for recovering the group 0 shuttles*)
		);
	ShuttleIfDestEnum : 
		( (*Destinations for a shuttle to move to*)
		DEST_LOAD,
		DEST_PROCESS_1,
		DEST_PROCESS_2,
		DEST_INSPECT,
		DEST_UNLOAD (*Destination unload*)
		);
	ShuttleProductStateEnum : 
		(
		PROD_EMPTY,
		PROD_DOSING,
		PROD_CUBE
		);
	ShuttleIfStatusTyp : 	STRUCT  (*Status information for the shuttle*)
		CurrentDestination : ShuttleIfDestEnum; (*Destination the shuttle is currently moving towards*)
		ShuttleInfo : Acp6DShuttleInfoType; (*CurrentStatus Information about the shuttle*)
		Error : BOOL; (*Shuttle is currently in an error state*)
		ErrorState : ShStateEnum; (*State the shuttle errored at*)
		Recovered : BOOL; (*Shuttle has been recovered*)
		ProductState : ShuttleProductStateEnum;
		LoopCounter : DINT;
		Active : BOOL;
		ProdFill : ARRAY[0..8]OF USINT;
	END_STRUCT;
	ShStateEnum : 
		(
		SH_OFF, (*Shuttle is in the off/idle state*)
		SH_INIT, (*Shuttle is in the initilization state*)
		SH_STARTUP, (*Shuttle is in the startup state*)
		SH_IDLE, (*Shuttle is in the idle state after having been recovered*)
		SH_GO_TO_LOAD,
		SH_LOADING,
		SH_CHECK_RECIPE,
		SH_GO_TO_ST_1,
		SH_PREFORM_ST_1,
		SH_GO_TO_ST_2,
		SH_PREFORM_ST_2,
		SH_GO_TO_INSPECT,
		SH_INSPECT,
		SH_GO_TO_UNLOAD,
		SH_UNLOAD,
		SH_STOPPING,
		SH_RESET,
		SH_ERROR := 65535 (*Shuttle is in the error state*)
		);
	ShuttleIfTyp : 	STRUCT  (*Interface for controlling a shuttle*)
		Cmd : ShuttleIfCmdTyp; (*Commands to issue to a shuttle*)
		Par : ShuttleIfParTyp; (*Parameters for the process for this shuttle*)
		Cfg : ShuttleIfConfigTyp; (*Configuration values for this shuttle*)
		Sts : ShuttleIfStatusTyp; (*Status information related to this shuttle*)
	END_STRUCT;
	SceneViewerTyp : 	STRUCT 
		Cmds : SceneViewerCmdsTyp;
		Pars : SceneViewerParsTyp;
	END_STRUCT;
	SceneViewerCmdsTyp : 	STRUCT 
		Record : BOOL;
		Clear : BOOL;
	END_STRUCT;
	SceneViewerParsTyp : 	STRUCT 
		LineColor : SceneViewerColorTyp;
	END_STRUCT;
	SceneViewerColorTyp : 	STRUCT 
		Red : REAL;
		Green : REAL;
		Blue : REAL;
	END_STRUCT;
END_TYPE

(*Recovery Interface Type*)

TYPE
	Acp6DRecoveryIfTyp : 	STRUCT 
		Cmd : Acp6DRecoveryCmdTyp;
		Par : Acp6DRecoveryParTyp;
		Sts : Acp6DRecoveryStsTyp;
	END_STRUCT;
	Acp6DRecoveryCmdTyp : 	STRUCT 
		Recover : BOOL;
		Reset : BOOL;
	END_STRUCT;
	Acp6DRecoveryParTyp : 	STRUCT 
		AutoDrivePositions : ARRAY[0..MAX_SHUTTLE_COUNT_ARRAY]OF Acp6DAutoDrivePosTyp;
		Vel : REAL;
		Accel : REAL;
	END_STRUCT;
	Acp6DRecoveryStsTyp : 	STRUCT 
		Recovering : BOOL;
		ReadyToStartProc : BOOL;
		Done : BOOL;
		ShuttlesRecovered : BOOL;
		Error : BOOL;
	END_STRUCT;
	Acp6DAutoDrivePosTyp : 	STRUCT 
		ShIdx : USINT;
		X : REAL;
		Y : REAL;
	END_STRUCT;
END_TYPE

(*Process Demo Recipe Types*)

TYPE
	ProcessRecipeTyp : 	STRUCT 
		General : ProcessRecipeGenTyp;
		Load : ProcessRecipeLoadTyp;
		Unload : ProcessRecipeLoadTyp;
		St1 : ProcessRecipeStationTyp;
		St2 : ProcessRecipeStationTyp;
		Inspect : ProcessRecipeStationTyp;
	END_STRUCT;
	ProcessRecipeGenTyp : 	STRUCT 
		St1St2Cycles : USINT;
		Velocity : REAL;
		Accel : REAL;
		Decel : REAL;
	END_STRUCT;
	ProcessRecipeLoadTyp : 	STRUCT 
		StartPos : StationPositionTyp;
		EndPos : StationPositionTyp;
	END_STRUCT;
	ProcessRecipeStationTyp : 	STRUCT 
		MacroId : USINT;
		DwellTime : TIME;
		OperationPos : StationPositionTyp;
		ExitPos : StationPositionTyp;
	END_STRUCT;
END_TYPE

(*6D Cyclic Channel Configurationi Types*)

TYPE
	CycChnlCfgIfTyp : 	STRUCT 
		Cmds : CycChnlCfgCmdsIfTyp;
		Pars : CycChnlCfgParsIfTyp;
		Sts : CycChnlCfgStsIfTyp;
	END_STRUCT;
	CycChnlCfgCmdsIfTyp : 	STRUCT 
		Config : BOOL;
	END_STRUCT;
	CycChnlCfgParsIfTyp : 	STRUCT 
		LoadShuttleIdx : USINT;
		UnloadShuttleIdx : USINT;
	END_STRUCT;
	CycChnlCfgStsIfTyp : 	STRUCT 
		Ready : BOOL;
		Configuring : BOOL;
		Error : BOOL;
	END_STRUCT;
END_TYPE

(***********************Station Types*)

TYPE
	StationIfTyp : 	STRUCT 
		Cmd : StationIfCmdTyp; (*Commands to a station*)
		Par : {REDUND_UNREPLICABLE} StationIfParTyp; (*Parameters for the station's operation*)
		Cfg : StationIfCfgTyp; (*Configuration values for the station*)
		Sts : StationIfStsTyp; (*Status of the station*)
	END_STRUCT;
	StationIfCmdTyp : 	STRUCT 
		Enable : BOOL; (*Enables the process station*)
		Process : BOOL; (*Start a process for the station with the defined shuttle index*)
		Reset : BOOL; (*Resets the process from an any state*)
		LocalOverride : BOOL; (*Denotes that local settings can be overwritten from global*)
	END_STRUCT;
	StationIfCfgTyp : 	STRUCT 
		StationPos : StationPositionTyp; (*Station's center world position*)
	END_STRUCT;
	StationIfParTyp : 	STRUCT 
		ShuttleIdx : USINT; (*Index in the gShuttle array for the shuttle in question*)
	END_STRUCT;
	StationIfStsTyp : 	STRUCT 
		Enabled : BOOL; (*Signal denoting the station is enabled and in an operational state*)
		Processing : BOOL; (*Signal denoting the station is currently operating on a shuttle*)
		Done : BOOL; (*Signal denoting the current operation has completed*)
		ReadyForNewShuttle : BOOL; (*Signal denoting the station is ready for a new shuttle*)
		Error : BOOL; (*Signal denoting the station has an error present*)
	END_STRUCT;
	StationPositionTyp : 	STRUCT 
		X : REAL; (*Station's Global X position*)
		Y : REAL; (*Station's Global Y position*)
	END_STRUCT;
	FillStationEnum : 
		(
		ST_UNDEF,
		ST1,
		ST2,
		ST3,
		ST4
		);
END_TYPE

(*Dance Demo If*)

TYPE
	DanceDemoIfTyp : 	STRUCT 
		Cmd : DanceDemoCmdTyp;
		Par : DanceDemoParTyp;
		Sts : DanceDemoStsTyp;
	END_STRUCT;
	DanceDemoCmdTyp : 	STRUCT 
		Run : BOOL;
		Reset : BOOL;
	END_STRUCT;
	DanceDemoParTyp : 	STRUCT 
		DemoTime : TIME; (*How long each demo should run for*)
	END_STRUCT;
	DanceDemoStsTyp : 	STRUCT 
		Running : BOOL;
		Error : BOOL;
	END_STRUCT;
END_TYPE

(**************************** Various Demo Types*)

TYPE
	VariousDemoTypesEnum : 
		(
		VAR_DEMO_SLIDE,
		VAR_DEMO_MIX,
		VAR_DEMO_WEIGH,
		VAR_DEMO_WAVE,
		VAR_DEMO_FORCE,
		VAR_DEMO_ANTI_SLOSH,
		VAR_DEMO_LAND,
		VAR_DEMO_CYCLE,
		VAR_DEMO_GENERIC_MOVEMENT
		);
	VariousDemoIf : 	STRUCT 
		Cmd : VariousDemoIfCmdTyp;
		Par : VariousDemoIfParTyp;
		Sts : VariousDemoIfStsTyp;
	END_STRUCT;
	VariousDemoIfParTyp : 	STRUCT 
		Demo : VariousDemoTypesEnum;
	END_STRUCT;
	VariousDemoIfCmdTyp : 	STRUCT 
		RunDemo : BOOL;
		ChangeDemo : BOOL;
		Stop : BOOL;
		Reset : BOOL;
	END_STRUCT;
	VariousDemoIfStsTyp : 	STRUCT 
		CurrentDemo : VariousDemoTypesEnum;
		Active : BOOL;
		Error : BOOL;
		Running : BOOL;
	END_STRUCT;
END_TYPE
