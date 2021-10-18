(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Author: Giovanni Fassina <giovanni.fassina@br-automation.com>
 * Created: Oct 16, 2018
 ********************************************************************)

TYPE
	SFBshaperTypeEnum : 
		( (*Define the type of the shaper that must be calculated*)
		sfbSHAPER_OFF, (*No shaper is used*)
		sfbSHAPER_ZV, (*Zero Vibration (ZV) shaper is used*)
		sfbSHAPER_ZVD (*Zero Vibration Derivative (ZVD) shaper is used*)
		);
END_TYPE

(* *)

TYPE
	SFBcontShapeEnum : 
		( (*Define the shape of the container*)
		sfbRECTANGULAR, (*Rectangular shape*)
		sfbCIRCULAR, (*Circular/Cylindrical shape*)
		_sfbSHAPEn (*THIS MUST BE THE LAST !!!!! this is the number of available shapes*)
		);
END_TYPE

(* *)
