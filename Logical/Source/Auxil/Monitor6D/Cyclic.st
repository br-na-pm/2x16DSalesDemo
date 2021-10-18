(* 
	Task that monitors the 6D system and segment temperatures

	Every Cycle polls a new segment to get it's status, iterates through all segments
	
	TODO: Will generate an alarm should a any of the segments report a temperature above the configured value
	
	States
		Wait for 6D system to report available/on
		Check system state
		Check segments temps/status
			Iterates multiplexed through all segments to update the data
		Error
		Reset
*)
PROGRAM _CYCLIC
	CASE state OF
		MON_IDLE:  //******************************************************************************** Idle State
			IF (gAcp6DCtrlIf.Sts.ReadyToPowerOn OR gAcp6DCtrlIf.Sts.PowerOn OR gAcp6DCtrlIf.Sts.Ready) AND NOT SystemStsIf.Cmd.DisableMon THEN
				FOR i:=0 TO NUM_SEGMENTS_ARRAY DO
					Fbs.SegStsFb[i].Controller := ADR(gMcAcp6DController);
					Fbs.SegStsFb[i].SegmentID := i + 1;
				END_FOR;
				Fbs.SysStsFb.Controller := ADR(gMcAcp6DController);
				Fbs.SysStsFb.Execute := TRUE;
				
				state := MON_SYS_STATUS;
			ELSIF SystemStsIf.Cmd.Reset THEN
				state := MON_RESET;
			END_IF
		MON_SYS_STATUS:  //******************************************************************************** Checking System Status
			IF Fbs.SysStsFb.Error THEN
				state := MON_ERROR;
			ELSIF SystemStsIf.Cmd.DisableMon THEN
				state := MON_RESET;
			ELSIF Fbs.SysStsFb.Valid OR Fbs.SysStsFb.Aborted THEN
				SystemStsIf.Sts.System := Fbs.SysStsFb.SystemInfo;
				Fbs.SysStsFb.Execute := FALSE;
				
				AbortCount := AbortCount + BOOL_TO_UDINT(Fbs.SysStsFb.Aborted);
				
				state := MON_SEG_STATUS;
			END_IF
		MON_SEG_STATUS:  //******************************************************************************** Checking the segment status's. Multiplexed
			Fbs.SegStsFb[curSegIdx].Execute := TRUE;
			IF Fbs.SegStsFb[curSegIdx].Error THEN
				state := MON_ERROR;
			ELSIF SystemStsIf.Cmd.DisableMon THEN
				state := MON_RESET;
			ELSIF Fbs.SegStsFb[curSegIdx].Valid OR Fbs.SegStsFb[curSegIdx].Aborted THEN
				Fbs.SegStsFb[curSegIdx].Execute := FALSE;
				SystemStsIf.Sts.Segments[curSegIdx] := Fbs.SegStsFb[curSegIdx].SegmentInfo;
				curSegIdx := curSegIdx + 1;
				AbortCount := AbortCount + BOOL_TO_UDINT(Fbs.SegStsFb[curSegIdx].Aborted);
				IF curSegIdx = NUM_SEGMENTS THEN
					Fbs.WaitTonFb.IN := TRUE;	
					Fbs.WaitTonFb.PT := T#5s;
					state := MON_WAIT;
				END_IF
			END_IF
		MON_WAIT:  //******************************************************************************** Wait State
			IF Fbs.WaitTonFb.Q THEN
				Fbs.WaitTonFb.IN := FALSE;
				
				Fbs.SysStsFb.Execute := TRUE;
				curSegIdx := 0;
				state := MON_SYS_STATUS;
			END_IF
		MON_ERROR:  //******************************************************************************** Error Present State
			state := MON_RESET;
		MON_RESET:  //******************************************************************************** Reset state
			SegStatusCheck := TRUE;
			AbortCount := 0;
			FOR i:=0 TO NUM_SEGMENTS_ARRAY DO
				Fbs.SegStsFb[i].Execute := FALSE;
				SegStatusCheck := Fbs.SegStsFb[i].Error;
			END_FOR;
			Fbs.SysStsFb.Execute := FALSE;
			Fbs.WaitTonFb.IN := FALSE;
			IF SegStatusCheck AND NOT Fbs.SysStsFb.Error THEN
				curSegIdx := 0;
				SystemStsIf.Cmd.Reset := FALSE;
				
				state := MON_IDLE;
			END_IF		
	END_CASE;
	 
	//Fb Calls
	Fbs.SysStsFb();
	Fbs.WaitTonFb();
	FOR i:=0 TO NUM_SEGMENTS_ARRAY DO
		Fbs.SegStsFb[i]();
	END_FOR;
END_PROGRAM
