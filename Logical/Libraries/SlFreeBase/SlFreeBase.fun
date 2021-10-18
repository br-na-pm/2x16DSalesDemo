(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Author: Giovanni Fassina <giovanni.fassina@br-automation.com>
 * Created: Oct 16, 2018
 ********************************************************************)

FUNCTION_BLOCK SFBshaper (*Deform (shape) the input quatity*) (*$GROUP=User,$CAT=User,$GROUPICON=LD_FilterProcessing.png,$CATICON=LD_Math.png*)
	VAR_INPUT
		Enable : BOOL; (*Activate the function block*)
		In : LREAL; (*Input, quantity to be shaped*)
		Parameters : SFBshaperDataType; (*Parameters of the shaper*)
		Update : BOOL; (*At rising edge update the parameters*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*The function block is working*)
		UpdateDone : BOOL; (*If 1 the update command is completed*)
		Error : BOOL; (*There is an error in the function block*)
		StatusID : DINT; (*Error code*)
		Out : LREAL; (*Output (forced 0 if enable is 0)*)
		Bypass : BOOL; (*If 1 the input is directly copied to the output*)
		Info : SFBinfoType; (*Informations about the function block, useful for statistics*)
	END_VAR
	VAR
		priv : _SFBshaperPrivType;
	END_VAR
END_FUNCTION_BLOCK
(* *)

FUNCTION_BLOCK SFBcontainer (*Provide the first oscillation mode based on the container's geometry and the data for a model based on the pendulum approximation*) (*$GROUP=User,$CAT=User,$GROUPICON=LD_Math.png,$CATICON=LD_Math.png*)
	VAR_INPUT
		Enable : BOOL; (*Activate the function*)
		Length : REAL; (*[m] Length of the container in the direction of the movement*)
		FillLevel : REAL; (*[m] Height of the liquid inside the container*)
		Shape : SFBcontShapeEnum; (*Shape of the container*)
		Advanced : SFBcontAdvancedType; (*Advanced parameters*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*The function block is working*)
		Error : BOOL; (*There is an error in the function block*)
		StatusID : DINT; (*Error code*)
		Done : BOOL; (*The calculation is done*)
		Result : SFBshaperDataType; (*The result of the calculation is here*)
		ResultModel : SFBmodelType; (*Here are calculated the parameters for the pendulum approximation*)
	END_VAR
	VAR
		priv : _SFBcontainerPrivType;
	END_VAR
END_FUNCTION_BLOCK
(**)
