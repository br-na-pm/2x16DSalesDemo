
//Hz is times per second, in this case times is revolutions. 
//To convert the Hz to revolutions and then scale by the task class cycle time
//1 hz, would mean that every TC cycle, we'd be incrementing by 2*PI/CycleTime

//Rx and Rz cylcic positions are always relative to the current position at the 
//  ENABLING of the cyclic channel. Why? Who knows but that's the way it works

PROGRAM _CYCLIC
	Wavepars.X := Wavepars.X + Wavepars.Freq / 1000 * 2 * 3.14;
	Slide.X := Slide.X + Slide.Freq / 1000 * 2 * 3.14;
	IF Wavepars.X > 2 * 3.14 THEN
		Wavepars.X := 0;
	END_IF
	 
	IF Slide.X > 2 * 3.14 THEN
		Slide.X := 0;
	END_IF
	
	Wavepars.Y := SIN(Wavepars.X);
	ShCtrl.Height := Wavepars.Y * Wavepars.Amp + Wavepars.Center;

	//For the angle,just going to scale between -20/+20mRad.
	ShCtrl.Angle := COS(Wavepars.X) * 20;
	
	ShCtrl.X := SIN(Slide.X) * 180 + 240;
	
	CASE state OF
		WAVE_IDLE: //**************************************************************** Idle State
			IF wave THEN
				Fbs.AutoDriveFB.Controller := ADR(gMcAcp6DController);
				Fbs.AutoDriveFB.Velocity := 1.0;
				Fbs.AutoDriveFB.Acceleration := 10.0;
				Fbs.AutoDriveFB.ShuttleID[0] := 1;
				Fbs.AutoDriveFB.ShuttleID[1] := 2;
				Fbs.AutoDriveFB.NumberOfShuttles := 2;
				Fbs.AutoDriveFB.PositionX[0] := 0.420;
				Fbs.AutoDriveFB.PositionX[1] := 0.420;
				Fbs.AutoDriveFB.PositionY[0] := 0.055;
				Fbs.AutoDriveFB.PositionY[1] := 0.185;
				Fbs.AutoDriveFB.Execute := TRUE;
								
				state := WAVE_MOVE_TO_START;
			END_IF
		WAVE_MOVE_TO_START: //**************************************************************** Move to the start position
			IF Fbs.AutoDriveFB.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.AutoDriveFB.Done THEN
				Fbs.AutoDriveFB.Execute := FALSE;
				
				Fbs.GroupCreateFb.Controller := ADR(gMcAcp6DController);
				Fbs.GroupCreateFb.GroupID := 1;
				Fbs.GroupCreateFb.NumberOfShuttles := 2;
				Fbs.GroupCreateFb.ShuttleID[0] := 1;
				Fbs.GroupCreateFb.ShuttleID[1] := 2;
				Fbs.GroupCreateFb.Execute := TRUE;
				
				state := WAVE_CREATE_GROUP;
			END_IF
		WAVE_CREATE_GROUP: //**************************************************************** Create Sh Group
			IF Fbs.GroupCreateFb.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.GroupCreateFb.Done THEN
				Fbs.GroupCreateFb.Execute := FALSE;
				
				Fbs.GroupCtrlFb.Controller := ADR(gMcAcp6DController);
				Fbs.GroupCtrlFb.CoupleMode := mcACP6D_GROUP_COUPLE_ONLY_XY;
				Fbs.GroupCtrlFb.GroupID := 1;
				Fbs.GroupCtrlFb.Option := mcACP6D_GROUP_COUPLE;
				Fbs.GroupCtrlFb.Execute := TRUE;
				
				state := WAVE_BOND_GROUP;
			END_IF
		WAVE_BOND_GROUP: //**************************************************************** Bond Sh Group
			IF Fbs.GroupCtrlFb.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.GroupCtrlFb.Done THEN
				Fbs.GroupCtrlFb.Execute := FALSE;
				
				Fbs.ShortAxisFb.Controller := ADR(gMcAcp6DController);
				Fbs.ShortAxisFb.ShuttleID := shId;
				Fbs.ShortAxisFb.PositionZ := (Wavepars.Amp + Wavepars.Center) / 1000.0;
				Fbs.ShortAxisFb.PositionRx := 0.0;
				Fbs.ShortAxisFb.PositionRy := 0;
				Fbs.ShortAxisFb.PositionRz := 0;
				Fbs.ShortAxisFb.VelocityZ := 1;
				Fbs.ShortAxisFb.VelocityRx := 1;
				Fbs.ShortAxisFb.VelocityRy := 1;
				Fbs.ShortAxisFb.VelocityRz := 1;
				Fbs.ShortAxisFb.Execute := TRUE;
					
				startRef.Height := Fbs.ShortAxisFb.PositionZ;
				startRef.Angle := Fbs.ShortAxisFb.PositionRx;
				
				state := WAVE_CFG_CHANNEL;
			END_IF
		WAVE_CFG_CHANNEL: //**************************************************************** Configure cyclic channel
			IF Fbs.ShortAxisFb.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.ShortAxisFb.Done THEN
				Fbs.ShortAxisFb.Execute := FALSE;
				
				//Wavepars.Freq := 1.0;
				Wavepars.X := 1.57;
				Slide.X := 1.57;
				Wavepars.Y := SIN(Wavepars.X);
				ShCtrl.Height := Wavepars.Y * Wavepars.Amp + Wavepars.Center;

				//For the angle,just going to scale between -25/+25mRad.
				ShCtrl.Angle := COS(Wavepars.X) * 25;
				
				Fbs.CyclicZFb.AxisID := 3;
				Fbs.CyclicZFb.ChannelID := 1;
				Fbs.CyclicZFb.Controller := ADR(gMcAcp6DController);
				Fbs.CyclicZFb.Value := (Wavepars.Amp + Wavepars.Center) - ShCtrl.Height ;
				Fbs.CyclicZFb.Enable := TRUE;
				
				Fbs.CyclicRxFb.AxisID := 5;
				Fbs.CyclicRxFb.ChannelID := 1;
				Fbs.CyclicRxFb.Controller := ADR(gMcAcp6DController);
				Fbs.CyclicRxFb.Value := 0;
				Fbs.CyclicRxFb.Enable := TRUE;
				
				Fbs.CyclicXFb.AxisID := 1;
				Fbs.CyclicXFb.ChannelID := 1;
				Fbs.CyclicXFb.Controller := ADR(gMcAcp6DController);
				Fbs.CyclicXFb.Value := 0.42;
				Fbs.CyclicXFb.Enable := TRUE;
				state := WAVE_SET_HEIGHT;
			END_IF
			
		WAVE_SET_HEIGHT: //**************************************************************** Set the starting height
			Fbs.CyclicChCtrlFb.Controller := ADR(gMcAcp6DController);
			Fbs.CyclicChCtrlFb.ShuttleID[0] := shId;
			Fbs.CyclicChCtrlFb.ChannelID[0] := 1;
			Fbs.CyclicChCtrlFb.AxisID[0].0 := TRUE; //X
			Fbs.CyclicChCtrlFb.AxisID[0].2 := TRUE; //Z
			Fbs.CyclicChCtrlFb.AxisID[0].4 := TRUE; //Ry
			Fbs.CyclicChCtrlFb.Execute := TRUE;
			Fbs.CyclicChCtrlFb.NumberOfShuttles := 1;
			Fbs.CyclicChCtrlFb.Level := 1;
			
//			Wavepars.Freq := 1.5;
//			Slide.Freq := 0.05;
			
			IF Fbs.CyclicChCtrlFb.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.CyclicChCtrlFb.Done THEN
				Fbs.CyclicChCtrlFb.Execute := FALSE;
								
				//state := WAVE_WAVE;
				state := WAVE_ERROR;
			END_IF
		WAVE_WAVE: //**************************************************************** Write channels, ride the wave
			Fbs.CyclicZFb.Value := -((Wavepars.Amp + Wavepars.Center) - ShCtrl.Height) / 1000.0;
			Fbs.CyclicRxFb.Value := ShCtrl.Angle / 1000.0;
			Fbs.CyclicXFb.Value := ShCtrl.X / 1000.0;
			
			IF NOT wave THEN
				Fbs.CyclicZFb.Enable := FALSE;
				Fbs.CyclicRxFb.Enable := FALSE;
				Fbs.CyclicXFb.Enable := FALSE;
				Fbs.CyclicChCtrlFb.Execute := TRUE;
				Fbs.CyclicChCtrlFb.Level := 0;
				
				state := WAVE_EXIT_CFG;
			END_IF
		WAVE_EXIT_CFG:  //**************************************************************** Exit config channel
			IF Fbs.CyclicChCtrlFb.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.CyclicChCtrlFb.Done THEN
				Fbs.CyclicChCtrlFb.Execute := FALSE;
				
				Fbs.ShortAxisFb.Controller := ADR(gMcAcp6DController);
				Fbs.ShortAxisFb.ShuttleID := shId;
				Fbs.ShortAxisFb.PositionZ := defaultLevitationHeight;
				Fbs.ShortAxisFb.PositionRx := 0.0;
				Fbs.ShortAxisFb.PositionRy := 0;
				Fbs.ShortAxisFb.PositionRz := 0;
				Fbs.ShortAxisFb.VelocityZ := 1;
				Fbs.ShortAxisFb.VelocityRx := 1;
				Fbs.ShortAxisFb.VelocityRy := 1;
				Fbs.ShortAxisFb.VelocityRz := 1;
				Fbs.ShortAxisFb.Execute := TRUE;
								
				
				state := WAVE_MOVE_BACK;
			END_IF
		WAVE_MOVE_BACK: //**************************************************************** Move Back to level
			IF Fbs.ShortAxisFb.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.ShortAxisFb.Done THEN
				Fbs.ShortAxisFb.Execute := FALSE;
				
				Fbs.GroupCtrlFb.Option := mcACP6D_GROUP_DECOUPLE;
				Fbs.GroupCtrlFb.Execute := TRUE;
				
				state := WAVE_UNBOUND_GROUP;
			END_IF
		WAVE_UNBOUND_GROUP: //**************************************************************** Unbond Sh Group
			IF Fbs.GroupCtrlFb.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.GroupCtrlFb.Done THEN
				Fbs.GroupCtrlFb.Execute := FALSE;
				
				Fbs.GroupDeleteFb.Controller := ADR(gMcAcp6DController);
				Fbs.GroupDeleteFb.GroupID := 1;
				Fbs.GroupDeleteFb.Execute := TRUE;
				
				state := WAVE_DELETE_GROUP;
			END_IF
		WAVE_DELETE_GROUP: //**************************************************************** Delete Sh Group
			IF Fbs.GroupDeleteFb.Error THEN
				state := WAVE_ERROR;
			ELSIF Fbs.GroupDeleteFb.Done THEN
				Fbs.GroupDeleteFb.Execute := FALSE;
				
				Wavepars.X := 0;
				Slide.X := 0;
				state := WAVE_IDLE;
			END_IF
		WAVE_ERROR: //**************************************************************** Error State
			IF Reset THEN
				Reset := FALSE;
				
				Fbs.ShortAxisFb.Execute := FALSE;
				Fbs.CyclicChCtrlFb.Execute := FALSE;
				Fbs.CyclicZFb.Enable := FALSE;
				Fbs.CyclicRxFb.Enable := FALSE;
				Fbs.CyclicXFb.Enable := FALSE;
				Fbs.AutoDriveFB.Execute := FALSE;
				Fbs.GroupCreateFb.Execute := FALSE;
				Fbs.GroupCtrlFb.Execute := FALSE;
				Fbs.GroupDeleteFb.Execute := FALSE;
				
				Wavepars.X := 0;
				Slide.X := 0;
				state := WAVE_IDLE;
			END_IF

	END_CASE;
	
	Fbs.ShortAxisFb();
	Fbs.CyclicChCtrlFb();
	Fbs.CyclicZFb();
	Fbs.CyclicRxFb();
	Fbs.CyclicXFb();
	Fbs.AutoDriveFB();
	Fbs.GroupCreateFb();
	Fbs.GroupCtrlFb();
	Fbs.GroupDeleteFb();
END_PROGRAM
