(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Author: Giovanni Fassina <giovanni.fassina@br-automation.com>
 * Created: Oct 16, 2018
 ********************************************************************)

TYPE
	SFBshaperDataType : 	STRUCT  (*Data about the shaper to be calculated*)
		Frequency : REAL; (*[rad/s] Damped frequency*)
		Damping : REAL; (*[1] Damping factor*)
		Type : SFBshaperTypeEnum; (*Type of shaper to use*)
	END_STRUCT;
END_TYPE

(* *)

TYPE
	SFBrecordType : 	STRUCT  (*General element of the fifo queue*)
		val : LREAL; (*Value*)
		a : LREAL; (*Coefficient*)
	END_STRUCT;
END_TYPE

(* *)

TYPE
	SFBinfoType : 	STRUCT  (*Informations about the shaper, useful for statistics*)
		ShaperDepthTime : REAL; (*[s] how many time is needed before the output is not affected by an input impulse*)
	END_STRUCT;
END_TYPE

(* *)

TYPE
	SFBcontAdvancedType : 	STRUCT  (*Data for advanced parameters of the SFBcontainer function block*)
		csi : REAL; (*Damping factor of the liquid in the sense of a second order oscillating system (if 0 the default value of 0.1 will be used)*)
		LiquidMass : REAL; (*[kg] mass of the liquid (if 0 will be assumed a water based liquid and the mass will be calculated using the container dimensions)*)
		Density : REAL; (*[kg/m^3] density of the liquid (if 0 will be assumed the density of water)*)
	END_STRUCT;
END_TYPE

(* *)

TYPE
	SFBmodelType : 	STRUCT  (*Data of the pendulum approximation model*)
		m0 : LREAL; (*[kg] mass of the fixed part of the liquid*)
		m1 : LREAL; (*[kg] mass of the pendulum*)
		l : LREAL; (*[m] length of the pendulum*)
		c_rot : LREAL; (*[Nm s/rad] viscous friction of the pendulum*)
	END_STRUCT;
END_TYPE
