(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Author: Giovanni Fassina <giovanni.fassina@br-automation.com>
 * Created: Oct 16, 2018
 ********************************************************************)

TYPE
	SFBoscModeType : 	STRUCT  (*caracterization of the oscillation mode*)
		wd : LREAL; (*[rad/s] damped pulsation*)
		D : LREAL; (*[1] damping*)
	END_STRUCT;
END_TYPE

(* *)

TYPE
	SFBcontShaperType : 	STRUCT  (*basic impulse data for continuos time shaper*)
		A : LREAL; (*[1] impulse amplitude*)
		t : LREAL; (*[s] impulse time*)
	END_STRUCT;
END_TYPE

(* *)

TYPE
	SFBdiscShaperType : 	STRUCT  (*basic impulse data for discrete time shaper*)
		A : LREAL; (*impulse amplitude*)
		n : UDINT; (*sample number, that is also the array index*)
	END_STRUCT;
END_TYPE

(* *)

TYPE
	SFBshaperType : 	STRUCT  (*collection of data for the calculation of the shaper*)
		Osc_mode : SFBoscModeType; (*oscillation mode to suppress*)
		Type : SFBshaperTypeEnum; (*type of the shaper*)
		CT_shaper : ARRAY[0.._sfbNUM_IMP_ZVDm1]OF SFBcontShaperType; (*continuos time shaper solution*)
		DT_shaper : ARRAY[0.._sfbNUM_IMP_ZVD_DTm1]OF SFBdiscShaperType; (*discrete time shaper solution*)
		wn : LREAL; (*natural pulsation*)
		Td : LREAL; (*pseudo period of the damped oscillation*)
	END_STRUCT;
END_TYPE
