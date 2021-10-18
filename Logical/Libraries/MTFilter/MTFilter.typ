
TYPE
	MTFilterMovingAvgInternalType : 	STRUCT  (*Internal variables of function block MTFilterMovingAverage.*)
		Ts : REAL; (*Data for internal use.*)
		ParameterValid : BOOL; (*Data for internal use.*)
		NumOfElmements : UINT; (*Number of elements of calculating output.*)
		Sum : LREAL; (*Data for internal use.*)
		pBuffer : {REDUND_UNREPLICABLE} UDINT; (*Data for internal use.*)
		CntAct : UINT; (*Data for internal use.*)
		CntOld : UINT; (*Data for internal use.*)
		WindowLength : UINT; (*Data for internal use.*)
		BufferLength : UINT; (*Length of window.*)
		BufferFull : BOOL; (*Data for internal use.*)
		MemAllocated : BOOL; (*Data for internal use.*)
		Update : BOOL; (*Data for internal use.*)
		UpdateOld : BOOL; (*Data for internal use.*)
		EnableOld : BOOL; (*Data for internal use.*)
		statusTMP : UINT; (*Data for internal use.*)
	END_STRUCT;
	MTFilterTypeEnum : 
		( (*Filtertype.*)
		mtFILTER_BESSEL := 0, (*Bessel Filter.*)
		mtFILTER_BUTTERWORTH := 1 (*Butterworth Filter.*)
		);
	MTFilterLowPassInternalType : 	STRUCT  (*Internal variables of function block MTFilterLowPass.*)
		Ts : REAL; (*Task cycle time. Unit: [s].*)
		SamplingFrequency : LREAL; (*Sampling frequency. Unit: [Hz].*)
		ParameterValid : BOOL; (*Data for internal use.*)
		AngularFrequency : LREAL; (*Data for internal use.*)
		Num : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		Den : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		BVector : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		AVector : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		XVector : ARRAY[0..4]OF LREAL; (*Data for internal use.*)
		TypeOld : USINT; (*Data for internal use.*)
		OrderOld : USINT; (*Data for internal use.*)
		CutOffFrequencyOld : REAL; (*Data for internal use.*)
		UpdateOld : BOOL; (*Data for internal use.*)
		EnableOld : BOOL; (*Data for internal use.*)
		EnableDone : BOOL; (*Data for internal use.*)
		DisabledBusy : BOOL; (*Data for internal use.*)
		CounterOld : UDINT; (*Data for internal use.*)
		SysRefParaNew : BOOL; (*Data for internal use.*)
		SystemReference : MTTransferFcnType; (*Data for internal use.*)
	END_STRUCT;
	MTFilterHighPassInternalType : 	STRUCT  (*Internal variables of function block MTFilterHighPass.*)
		Ts : REAL; (*Task cycle time. Unit: [s].*)
		SamplingFrequency : LREAL; (*Sampling frequency. Unit: [Hz].*)
		ParameterValid : BOOL; (*Data for internal use.*)
		AngularFrequency : LREAL; (*Frequency in radians*)
		Num : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		Den : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		BVector : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		AVector : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		XVector : ARRAY[0..4]OF LREAL; (*Data for internal use.*)
		TypeOld : USINT; (*Data for internal use.*)
		OrderOld : USINT; (*Data for internal use.*)
		CutOffFrequencyOld : REAL; (*Data for internal use.*)
		UpdateOld : BOOL; (*Data for internal use.*)
		EnableOld : BOOL; (*Data for internal use.*)
		EnableDone : BOOL; (*Data for internal use.*)
		DisabledBusy : BOOL; (*Data for internal use.*)
		CounterOld : UDINT; (*Data for internal use.*)
		SysRefParaNew : BOOL; (*Data for internal use.*)
		SystemReference : MTTransferFcnType; (*Data for internal use.*)
	END_STRUCT;
	MTFilterBandPassInternalType : 	STRUCT  (*Internal variables of function block MTFilterBandPass.*)
		Ts : REAL; (*Task cycle time. Unit: [s].*)
		SamplingFrequency : LREAL; (*Sampling frequency. Unit: [Hz].*)
		ParameterValid : BOOL; (*Data for internal use.*)
		AngularFrequency : LREAL; (*Frequency in radians*)
		BandwidthRad : LREAL; (*Frequency in radians*)
		Num : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		Den : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		BVector : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		AVector : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		XVector : ARRAY[0..4]OF LREAL; (*Data for internal use.*)
		TypeOld : USINT; (*Data for internal use.*)
		OrderOld : USINT; (*Data for internal use.*)
		CenterFrequencyOld : REAL; (*Data for internal use.*)
		BandwidthOld : REAL; (*Data for internal use.*)
		UpdateOld : BOOL; (*Data for internal use.*)
		EnableOld : BOOL; (*Data for internal use.*)
		EnableDone : BOOL; (*Data for internal use.*)
		DisabledBusy : BOOL; (*Data for internal use.*)
		CounterOld : UDINT; (*Data for internal use.*)
		SysRefParaNew : BOOL; (*Data for internal use.*)
		SystemReference : MTTransferFcnType; (*Data for internal use.*)
	END_STRUCT;
	MTFilterBandStopInternalType : 	STRUCT  (*Internal variables of function block MTFilterBandStop.*)
		Ts : REAL; (*Task cycle time. Unit: [s].*)
		SamplingFrequency : LREAL; (*Sampling frequency. Unit: [Hz].*)
		ParameterValid : BOOL; (*Data for internal use.*)
		AngularFrequency : LREAL; (*Data for internal use.*)
		BandwidthRad : LREAL; (*Frequency in radians*)
		Num : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		Den : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		BVector : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		AVector : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		XVector : ARRAY[0..4]OF LREAL; (*Data for internal use.*)
		TypeOld : USINT; (*Data for internal use.*)
		OrderOld : USINT; (*Data for internal use.*)
		CenterFrequencyOld : REAL; (*Data for internal use.*)
		BandwidthOld : REAL; (*Data for internal use.*)
		UpdateOld : BOOL; (*Data for internal use.*)
		EnableOld : BOOL; (*Data for internal use.*)
		EnableDone : BOOL; (*Data for internal use.*)
		DisabledBusy : BOOL; (*Data for internal use.*)
		CounterOld : UDINT; (*Data for internal use.*)
		SysRefParaNew : BOOL; (*Data for internal use.*)
		SystemReference : MTTransferFcnType; (*Data for internal use.*)
	END_STRUCT;
	MTFilterNotchInternalType : 	STRUCT  (*Internal variables of function block MTFilterNotch.*)
		Ts : REAL; (*Task cycle time. Unit: [s].*)
		SamplingFrequency : LREAL; (*Sampling frequency. Unit: [Hz].*)
		ParametersValid : BOOL; (*Data for internal use.*)
		UpperFrequency : REAL; (*Data for internal use.*)
		LowerFrequency : REAL; (*Data for internal use.*)
		BandwidthAct : REAL; (*Data for internal use.*)
		DampingConstant : REAL; (*Data for internal use.*)
		FilterTimeConstant : REAL; (*Data for internal use.*)
		Num : ARRAY[0..2]OF LREAL; (*Data for internal use.*)
		Den : ARRAY[0..2]OF LREAL; (*Data for internal use.*)
		BVector : ARRAY[0..2]OF LREAL; (*Data for internal use.*)
		AVector : ARRAY[0..2]OF LREAL; (*Data for internal use.*)
		XVector : ARRAY[0..1]OF LREAL; (*Data for internal use.*)
		TypeOld : USINT; (*Data for internal use.*)
		OrderOld : USINT; (*Data for internal use.*)
		CutOffFrequencyOld : REAL; (*Data for internal use.*)
		UpdateOld : BOOL; (*Data for internal use.*)
		EnableOld : BOOL; (*Data for internal use.*)
		EnableDone : BOOL; (*Data for internal use.*)
		DisabledBusy : BOOL; (*Data for internal use.*)
		SysRefParaNew : BOOL; (*Data for internal use.*)
		CounterOld : UDINT; (*Data for internal use.*)
		SystemReference : MTTransferFcnType; (*Data for internal use.*)
	END_STRUCT;
	MTFilterBiQuadInternalType : 	STRUCT  (*Internal variables of function block MTFilterBiQuad.*)
		Ts : REAL; (*Task cycle time. Unit: [s].*)
		SamplingFrequency : LREAL; (*Sampling frequency. Unit: [Hz]*)
		ParameterValid : BOOL; (*Data for internal use.*)
		Num : ARRAY[0..2]OF LREAL; (*Data for internal use.*)
		Den : ARRAY[0..2]OF LREAL; (*Data for internal use.*)
		BVector : ARRAY[0..2]OF LREAL; (*Data for internal use.*)
		AVector : ARRAY[0..2]OF LREAL; (*Data for internal use.*)
		XVector : ARRAY[0..1]OF LREAL; (*Data for internal use.*)
		FrequencyNumeratorOld : REAL; (*Data for internal use.*)
		DampingRatioNumeratorOld : REAL; (*Data for internal use.*)
		FrequencyDenominatorOld : REAL; (*Data for internal use.*)
		DampingRatioDenominatorOld : REAL; (*Data for internal use.*)
		FrequencyNumeratorRad : LREAL; (*Data for internal use.*)
		FrequencyDenominatorRad : LREAL; (*Data for internal use.*)
		UpdateOld : BOOL; (*Data for internal use.*)
		EnableOld : BOOL; (*Data for internal use.*)
		EnableDone : BOOL; (*Data for internal use.*)
		DisabledBusy : BOOL; (*Data for internal use.*)
		SysRefParaNew : BOOL; (*Data for internal use.*)
		CounterOld : UDINT; (*Data for internal use.*)
		SystemReference : MTTransferFcnType; (*Data for internal use.*)
	END_STRUCT;
END_TYPE

(*MTKalmanFilter*)

TYPE
	MTFilterKalmanInternalType : 	STRUCT  (*Internal variables of function block MTFilterKalman.*)
		CycleTime : LREAL; (*Task cycle time. Unit: [s].*)
		InhibitUpdate : BOOL; (*Data for internal use.*)
		ParametersValid : BOOL; (*Data for internal use.*)
		UpdateOld : BOOL; (*Data for internal use.*)
		EnableOld : BOOL; (*Data for internal use.*)
		StateSpace : MTFilterKalmanStateSpaceType; (*Data for internal use.*)
		Rk : LREAL; (*Covariance matrix of the measuring noise.*)
		DisturbanceModel : MTFilterKalmanDisturbanceType; (*Data for internal use.*)
		nTmp : USINT; (*Data for internal use.*)
		Qk : ARRAY[0..5]OF LREAL; (*Diagonal matrix entries to weight the estimated states.*)
		xk : ARRAY[0..5]OF LREAL; (*Discrete states.*)
		Pk : ARRAY[0..35]OF LREAL; (*Error covariance matrix.*)
		Status : USINT; (*Data for internal use.*)
		yk : LREAL; (*Data for internal use.*)
		yk_p : LREAL; (*Data for internal use.*)
	END_STRUCT;
	MTFilterKalmanStateSpaceType : 	STRUCT  (*Data for internal use.*)
		Sys : MTFilterKalmanSysType; (*Data for internal use.*)
		ExtSys : MTFilterKalmanExtSysType; (*Data for internal use.*)
		DiscreteExtSys : MTFilterKalmanDiscreteExtSysType; (*Data for internal use.*)
	END_STRUCT;
	MTFilterKalmanSysType : 	STRUCT  (*Data for internal use.*)
		A : ARRAY[0..15]OF LREAL; (*Data for internal use.*)
		b : ARRAY[0..3]OF LREAL; (*Data for internal use.*)
		cT : ARRAY[0..3]OF LREAL; (*Data for internal use.*)
		d : LREAL; (*Data for internal use.*)
		n : USINT; (*System ordern.*)
	END_STRUCT;
	MTFilterKalmanExtSysType : 	STRUCT  (*Data for internal use.*)
		A : ARRAY[0..35]OF LREAL; (*Data for internal use.*)
		b : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		cT : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		d : LREAL; (*Data for internal use.*)
		n : USINT; (*Extended ystem ordern.*)
	END_STRUCT;
	MTFilterKalmanDiscreteExtSysType : 	STRUCT  (*Data for internal use.*)
		Phi : ARRAY[0..35]OF LREAL; (*Data for internal use.*)
		Gamma : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		cT : ARRAY[0..5]OF LREAL; (*Data for internal use.*)
		d : LREAL; (*Data for internal use.*)
		n : USINT; (*Extended system ordern.*)
	END_STRUCT;
	MTFilterKalmanDisturbanceType : 	STRUCT  (*Data for internal use.*)
		Mode : MTFilterKalmanModeEnum := mtFILTER_NO_DISTURBANCE;
		Frequency : REAL;
	END_STRUCT;
	MTFilterKalmanModeEnum : 
		( (*Filtertype.*)
		mtFILTER_NO_DISTURBANCE := 0, (*No disturbance.*)
		mtFILTER_CONST_DISTURBANCE := 1, (*Constant disturbance.*)
		mtFILTER_OSCILLATING_DISTURBANCE := 2 (*Harmonic oscillating disturbance.*)
		);
END_TYPE
