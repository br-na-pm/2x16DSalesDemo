(*
*)
FUNCTION_BLOCK WeighShuttleFb
	CASE int.State OF
		WEIGH_IDLE: //******************************************************************************** Idle Wait State
			IF Execute THEN
				Active := TRUE;
				
				int.Fbs.SettleFb.IN := TRUE;
				int.Fbs.SettleFb.PT := Pars.SettleTime;
				
				int.State := WEIGH_SETTLE;
			END_IF
		WEIGH_SETTLE:  //******************************************************************************** Waiting for settle
			IF int.Fbs.SettleFb.Q THEN
				int.Fbs.SettleFb.IN := FALSE;
				
				int.Fbs.WeighFb.Controller := ADR(Controller);
				int.Fbs.WeighFb.ShuttleID := Pars.ShId;
				int.Fbs.WeighFb.Execute := TRUE;
				
				int.State := WEIGH_WEIGH;
			END_IF
		WEIGH_WEIGH://******************************************************************************** Weighing shuttle payload
			IF int.Fbs.WeighFb.Error THEN
				int.ErrorState := int.State;
				int.State := WEIGH_ERROR;
			ELSIF int.Fbs.WeighFb.Valid THEN
				Weight := int.Fbs.WeighFb.Payload - Pars.TareWeight;
				Done := TRUE;
				
				int.State := WEIGH_DONE;
			END_IF
		WEIGH_DONE: //******************************************************************************** Done
			IF NOT Execute THEN
				int.State := WEIGH_RESET;
			END_IF
		WEIGH_ERROR: //******************************************************************************** Error present
			IF NOT Execute THEN
				int.State := WEIGH_RESET;
			END_IF
		WEIGH_RESET: //******************************************************************************** Reset State
			Active := FALSE;
			Done := FALSE;
			Error := FALSE;
			
			int.Fbs.SettleFb.IN := FALSE;
			int.Fbs.WeighFb.Execute := FALSE;
		
			int.State := WEIGH_IDLE;
	END_CASE; 
	
	//Call the FBs
	int.Fbs.SettleFb();
	int.Fbs.WeighFb();
	
END_FUNCTION_BLOCK
