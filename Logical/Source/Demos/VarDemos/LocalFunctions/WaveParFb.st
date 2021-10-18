(*
 This FB only atm works at 1ms cycle time

//Hz is times per second, in this case times is revolutions. 
//To convert the Hz to revolutions and then scale by the task class cycle time
//1 hz, would mean that every TC cycle, we'd be incrementing by 2*PI/CycleTime

//Rx and Rz cylcic positions are always relative to the current position at the 
//  ENABLING of the cyclic channel. Why? Who knows but that's the way it works
*)
FUNCTION_BLOCK WaveFb
	IF Enable AND Active AND Running THEN
		int.WaveCtrl.WaveX := int.WaveCtrl.WaveX + Pars.Wave.Freq / 1000 * 2 * 3.14;
		int.SlideCtrl.WaveX := int.SlideCtrl.WaveX + Pars.Slide.Freq / 1000 * 2 * 3.14;
		IF int.WaveCtrl.WaveX > 2 * 3.14 THEN
			int.WaveCtrl.WaveX := 0;
		END_IF
		 
		IF int.SlideCtrl.WaveX > 2 * 3.14 THEN
			int.SlideCtrl.WaveX := 0;
		END_IF
		
		int.WaveCtrl.WaveY := SIN(int.WaveCtrl.WaveX);
		int.WaveCtrl.Height := int.WaveCtrl.WaveY * Pars.Wave.Amp + Pars.Wave.Center;
	
		//For the angle,just going to scale between -20/+20mRad.
		int.WaveCtrl.Angle := COS(int.WaveCtrl.WaveX) * 20;
		
		int.SlideCtrl.Height := SIN(int.SlideCtrl.WaveX) * 180 + 240;
	END_IF
	CASE int.State OF
		WAVE_IDLE: //**************************************************************** Idle State
			IF Enable THEN
				int.Fbs.GroupCreateFb.Controller := ADR(Controller);
				int.Fbs.GroupCreateFb.GroupID := 1;
				int.Fbs.GroupCreateFb.NumberOfShuttles := 2;
				int.Fbs.GroupCreateFb.ShuttleID[0] := 1;
				int.Fbs.GroupCreateFb.ShuttleID[1] := 2;
				int.Fbs.GroupCreateFb.Execute := TRUE;
				
				Active := TRUE;
				
				int.State := WAVE_CREATE_GROUP;
			END_IF
		WAVE_CREATE_GROUP: //**************************************************************** Create Sh Group
			IF int.Fbs.GroupCreateFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := WAVE_ERROR;
			ELSIF int.Fbs.GroupCreateFb.Done THEN
				int.Fbs.GroupCreateFb.Execute := FALSE;
				
				int.Fbs.GroupCtrlFb.Controller := ADR(Controller);
				int.Fbs.GroupCtrlFb.CoupleMode := mcACP6D_GROUP_COUPLE_ONLY_XY;
				int.Fbs.GroupCtrlFb.GroupID := 1;
				int.Fbs.GroupCtrlFb.Option := mcACP6D_GROUP_COUPLE;
				int.Fbs.GroupCtrlFb.Execute := TRUE;
				
				int.State := WAVE_BOND_GROUP;
			END_IF
		WAVE_BOND_GROUP: //**************************************************************** Bond Sh Group
			IF int.Fbs.GroupCtrlFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := WAVE_ERROR;
			ELSIF int.Fbs.GroupCtrlFb.Done THEN
				int.Fbs.GroupCtrlFb.Execute := FALSE;
				
				int.Fbs.ShortAxisFb.Controller := ADR(Controller);
				int.Fbs.ShortAxisFb.ShuttleID := 1; //Hard coded to 1 for now
				int.Fbs.ShortAxisFb.PositionZ := (Pars.Wave.Amp + Pars.Wave.Center) / 1000.0;
				int.Fbs.ShortAxisFb.PositionRx := 0.0;
				int.Fbs.ShortAxisFb.PositionRy := 0;
				int.Fbs.ShortAxisFb.PositionRz := 0;
				int.Fbs.ShortAxisFb.VelocityZ := 1;
				int.Fbs.ShortAxisFb.VelocityRx := 1;
				int.Fbs.ShortAxisFb.VelocityRy := 1;
				int.Fbs.ShortAxisFb.VelocityRz := 1;
				int.Fbs.ShortAxisFb.Execute := TRUE;
					
				int.State := WAVE_CFG_CHANNEL;
			END_IF
		WAVE_CFG_CHANNEL: //**************************************************************** Configure cyclic channel
			IF int.Fbs.ShortAxisFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := WAVE_ERROR;
			ELSIF int.Fbs.ShortAxisFb.Done THEN
				int.Fbs.ShortAxisFb.Execute := FALSE;
				
				//Start at the peak of the sine wave, so pi/2
				int.WaveCtrl.WaveX := 1.57;
				int.SlideCtrl.WaveX := 1.57;
				int.WaveCtrl.WaveY := SIN(int.WaveCtrl.WaveX);
				int.WaveCtrl.Height := int.WaveCtrl.WaveY * Pars.Wave.Amp + Pars.Wave.Center;

				//For the angle,just going to scale between -25/+25mRad.
				int.WaveCtrl.Angle := COS(int.WaveCtrl.WaveX) * 25;
				
				int.Fbs.CyclicZFb.AxisID := 3;
				int.Fbs.CyclicZFb.ChannelID := 1;
				int.Fbs.CyclicZFb.Controller := ADR(Controller);
				int.Fbs.CyclicZFb.Value := (Pars.Wave.Amp + Pars.Wave.Center) - int.WaveCtrl.Height;
				int.Fbs.CyclicZFb.Enable := TRUE;
				
				int.Fbs.CyclicRxFb.AxisID := 5;
				int.Fbs.CyclicRxFb.ChannelID := 1;
				int.Fbs.CyclicRxFb.Controller := ADR(Controller);
				int.Fbs.CyclicRxFb.Value := 0;
				int.Fbs.CyclicRxFb.Enable := TRUE;
				
				int.Fbs.CyclicXFb.AxisID := 1;
				int.Fbs.CyclicXFb.ChannelID := 1;
				int.Fbs.CyclicXFb.Controller := ADR(Controller);
				int.Fbs.CyclicXFb.Value := 0.42;
				int.Fbs.CyclicXFb.Enable := TRUE;
				int.State := WAVE_SET_HEIGHT;
			END_IF
			
		WAVE_SET_HEIGHT: //**************************************************************** Set the starting height
			int.Fbs.CyclicChCtrlFb.Controller := ADR(Controller);
			int.Fbs.CyclicChCtrlFb.ShuttleID[0] := 1;
			int.Fbs.CyclicChCtrlFb.ChannelID[0] := 1;
			int.Fbs.CyclicChCtrlFb.AxisID[0].0 := TRUE; //X
			int.Fbs.CyclicChCtrlFb.AxisID[0].2 := TRUE; //Z
			int.Fbs.CyclicChCtrlFb.AxisID[0].4 := TRUE; //Ry
			int.Fbs.CyclicChCtrlFb.Execute := TRUE;
			int.Fbs.CyclicChCtrlFb.NumberOfShuttles := 1;
			int.Fbs.CyclicChCtrlFb.Level := 1;
			
			IF int.Fbs.CyclicChCtrlFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := WAVE_ERROR;
			ELSIF int.Fbs.CyclicChCtrlFb.Done THEN
				int.Fbs.CyclicChCtrlFb.Execute := FALSE;
				Running := TRUE;
				int.State := WAVE_WAVE;
			END_IF
		WAVE_WAVE: //**************************************************************** Write channels, ride the wave
			int.Fbs.CyclicZFb.Value := -((Pars.Wave.Amp + Pars.Wave.Center) - int.WaveCtrl.Height) / 1000.0;
			int.Fbs.CyclicRxFb.Value := int.WaveCtrl.Angle / 1000.0;
			int.Fbs.CyclicXFb.Value := int.SlideCtrl.Height / 1000.0;
			
			IF NOT Enable THEN
				Running := FALSE;
				int.Fbs.CyclicZFb.Enable := FALSE;
				int.Fbs.CyclicRxFb.Enable := FALSE;
				int.Fbs.CyclicXFb.Enable := FALSE;
				int.Fbs.CyclicChCtrlFb.Execute := TRUE;
				int.Fbs.CyclicChCtrlFb.Level := 0;
				
				int.State := WAVE_EXIT_CFG;
			END_IF
		WAVE_EXIT_CFG:  //**************************************************************** Exit config channel
			IF int.Fbs.CyclicChCtrlFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := WAVE_ERROR;
			ELSIF int.Fbs.CyclicChCtrlFb.Done THEN
				int.Fbs.CyclicChCtrlFb.Execute := FALSE;
				
				int.Fbs.ShortAxisFb.Controller := ADR(Controller);
				int.Fbs.ShortAxisFb.ShuttleID := 1;
				int.Fbs.ShortAxisFb.PositionZ := Pars.DefaultLevitationHeight;
				int.Fbs.ShortAxisFb.PositionRx := 0.0;
				int.Fbs.ShortAxisFb.PositionRy := 0;
				int.Fbs.ShortAxisFb.PositionRz := 0;
				int.Fbs.ShortAxisFb.VelocityZ := 1;
				int.Fbs.ShortAxisFb.VelocityRx := 1;
				int.Fbs.ShortAxisFb.VelocityRy := 1;
				int.Fbs.ShortAxisFb.VelocityRz := 1;
				int.Fbs.ShortAxisFb.Execute := TRUE;
								
				
				int.State := WAVE_MOVE_BACK;
			END_IF
		WAVE_MOVE_BACK: //**************************************************************** Move Back to level
			IF int.Fbs.ShortAxisFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := WAVE_ERROR;
			ELSIF int.Fbs.ShortAxisFb.Done THEN
				int.Fbs.ShortAxisFb.Execute := FALSE;
				
				int.Fbs.GroupCtrlFb.Option := mcACP6D_GROUP_DECOUPLE;
				int.Fbs.GroupCtrlFb.Execute := TRUE;
				
				int.State := WAVE_UNBOUND_GROUP;
			END_IF
		WAVE_UNBOUND_GROUP: //**************************************************************** Unbond Sh Group
			IF int.Fbs.GroupCtrlFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := WAVE_ERROR;
			ELSIF int.Fbs.GroupCtrlFb.Done THEN
				int.Fbs.GroupCtrlFb.Execute := FALSE;
				
				int.Fbs.GroupDeleteFb.Controller := ADR(Controller);
				int.Fbs.GroupDeleteFb.GroupID := 1;
				int.Fbs.GroupDeleteFb.Execute := TRUE;
				
				int.State := WAVE_DELETE_GROUP;
			END_IF
		WAVE_DELETE_GROUP: //**************************************************************** Delete Sh Group
			IF int.Fbs.GroupDeleteFb.Error THEN
				int.ErrorState := int.State;
				Error := TRUE;
				int.State := WAVE_ERROR;
			ELSIF int.Fbs.GroupDeleteFb.Done THEN
				int.Fbs.GroupDeleteFb.Execute := FALSE;
				
				Active := FALSE;
				int.WaveCtrl.WaveX := 0;
				int.SlideCtrl.WaveX := 0;
				int.State := WAVE_IDLE;
			END_IF
		WAVE_ERROR: //**************************************************************** Error State
			IF NOT Enable THEN
				
				Active := FALSE;
				Error := FALSE;
				Running := FALSE;
				
				int.Fbs.ShortAxisFb.Execute := FALSE;
				int.Fbs.CyclicChCtrlFb.Execute := FALSE;
				int.Fbs.CyclicZFb.Enable := FALSE;
				int.Fbs.CyclicRxFb.Enable := FALSE;
				int.Fbs.CyclicXFb.Enable := FALSE;
				int.Fbs.GroupCreateFb.Execute := FALSE;
				int.Fbs.GroupCtrlFb.Execute := FALSE;
				int.Fbs.GroupDeleteFb.Execute := FALSE;
				
				int.WaveCtrl.WaveX := 0;
				int.SlideCtrl.WaveX := 0;
				int.State := WAVE_IDLE;
			END_IF

	END_CASE;
	
	int.Fbs.ShortAxisFb();
	int.Fbs.CyclicChCtrlFb();
	int.Fbs.CyclicZFb();
	int.Fbs.CyclicRxFb();
	int.Fbs.CyclicXFb();
	int.Fbs.GroupCreateFb();
	int.Fbs.GroupCtrlFb();
	int.Fbs.GroupDeleteFb();
	
END_FUNCTION_BLOCK
