(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Author: Giovanni Fassina <giovanni.fassina@br-automation.com>
 * Created: Oct 16, 2018
 ********************************************************************)

TYPE
	_SFBshaperPrivType : 	STRUCT 
		Ts : LREAL;
		step : UDINT;
		pMem : UDINT;
		nSlots : UDINT;
		rc : UINT;
		update_old : BOOL;
		updating : BOOL;
		updated : BOOL;
	END_STRUCT;
END_TYPE

(* *)

TYPE
	_SFBcontainerPrivType : 	STRUCT 
		Done : BOOL;
		Error : BOOL;
	END_STRUCT;
END_TYPE
