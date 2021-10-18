
PROGRAM _CYCLIC
	IF ContainerParsCalculated THEN
		Fbs.ShaperFb.In := Fbs.ProfGen.Position;
		Fbs.ShaperFb.Enable := TRUE;
	ELSE
		Fbs.ShaperFb.Enable := FALSE;
	END_IF
	
	IF Fbs.ShaperFb.Active AND Fbs.AxisFb.PowerOn THEN
		Fbs.MoveCyclicPosFb.Axis := ADR(gAxis_1);
		Fbs.MoveCyclicPosFb.CyclicPosition := Fbs.ShaperFb.Out;
		Fbs.MoveCyclicPosFb.Enable := TRUE;
	ELSE
		Fbs.MoveCyclicPosFb.Enable := FALSE;
	END_IF
	
	IF ShuttleCyclicChannelEnabled THEN
		Fbs.CyclicXFb.Value := LREAL_TO_REAL(Fbs.AxisFb.Position / 1000.0);
	END_IF
	
	CASE state OF
		AS_IDLE: //**************************************************************** Idle State
			IF NOT Fbs.AxisFb.PowerOn AND Fbs.AxisFb.Info.ReadyToPowerOn THEN
				Fbs.AxisFb.Power := TRUE;
				
				state := AS_POWER_AXIS;
			ELSIF gAntiSloshIf.Cmd.Reset THEN
				gAntiSloshIf.Cmd.Reset := FALSE;
				
				state := AS_RESET;
			ELSIF gAntiSloshIf.Cmd.Enable THEN
				gAntiSloshIf.Sts.Enabled := TRUE;
				Fbs.ContainerFb.Length := Pars.ContainerLength;
				Fbs.ContainerFb.FillLevel := Pars.FillHeight;
				Fbs.ContainerFb.Advanced := Pars.AdvPars;
				Fbs.ContainerFb.Shape := Pars.ContainerType;
				Fbs.ContainerFb.Enable := TRUE;
					
				state := AS_CALC_PARS;
			END_IF
		AS_POWER_AXIS: //**************************************************************** Power Virtual Axis
			IF Fbs.AxisFb.PowerOn THEN
				Fbs.AxisFb.Home := TRUE;
				
				state := AS_HOME_AXIS;
			END_IF
		AS_HOME_AXIS: //**************************************************************** Homing the virtual axis
			IF Fbs.AxisFb.Error THEN
				errorState := state;
				state := AS_ERROR;
				gAntiSloshIf.Sts.Error := TRUE;
			ELSIF Fbs.AxisFb.IsHomed AND Fbs.AxisFb.Position = AxisPars.Homing.Position THEN
				Fbs.AxisFb.Home := FALSE;
				
				IF NOT ProfGenHomed THEN
					Fbs.ProfGen.HomePosition := LREAL_TO_REAL(AxisPars.Homing.Position);
					Fbs.ProfGen.SetHomePosition := TRUE;
					state := AS_HOME_GENERATOR;
				ELSE
					state := AS_IDLE;
				END_IF
			END_IF
		AS_HOME_GENERATOR: //**************************************************************** Home the position generator
			IF Fbs.ProfGen.Error THEN
				errorState := state;
				state := AS_ERROR;
			ELSIF Fbs.ProfGen.Done THEN
				Fbs.ProfGen.SetHomePosition := FALSE;
				ProfGenHomed := TRUE;
				state := AS_IDLE;
			END_IF
		AS_CALC_PARS: //**************************************************************** Calculating the Anti-Slosh parameters
			IF Fbs.ContainerFb.Error THEN
				errorState := state;
				gAntiSloshIf.Sts.Error := TRUE;
				state := AS_ERROR;
			ELSIF Fbs.ContainerFb.Done THEN
				Fbs.ContainerFb.Enable := FALSE;
				
				ContainerParsCalculated := TRUE;
				Fbs.ShaperFb.Parameters := Fbs.ContainerFb.Result;
				
				Fbs.ShortAxisFb.Controller := ADR(gMcAcp6DController);
				Fbs.ShortAxisFb.ShuttleID := 1;
				Fbs.ShortAxisFb.PositionZ := height;
				Fbs.ShortAxisFb.VelocityZ := 1.0;
				Fbs.ShortAxisFb.Execute := TRUE;
				
				state := AS_SET_HEIGHT;
				
			END_IF
		AS_SET_HEIGHT: //**************************************************************** Set the shuttle's height
			IF Fbs.ShortAxisFb.Error THEN
				gAntiSloshIf.Sts.Error := TRUE;
				errorState := state;
				state := AS_ERROR;
			ELSIF Fbs.ShortAxisFb.Done THEN
				Fbs.ShortAxisFb.Execute := FALSE;
				
				Fbs.ShPropFb.Controller := ADR(gMcAcp6DController);
				Fbs.ShPropFb.ShuttleID[0] := Pars.ShId;
				Fbs.ShPropFb.NumberOfProperties := 1;
				Fbs.ShPropFb.Property[0] := mcACP6D_PROPERTY_PAYLOAD;
				Fbs.ShPropFb.Value[0] := Pars.Payload;
				Fbs.ShPropFb.Execute := TRUE;
								
				state := AS_SET_PAYLOAD;
			END_IF
		AS_SET_PAYLOAD: //**************************************************************** Set the shuttle's height
			IF Fbs.ShPropFb.Error THEN
				gAntiSloshIf.Sts.Error := TRUE;
				errorState := state;
				state := AS_ERROR;
			ELSIF Fbs.ShPropFb.Done THEN
				Fbs.ShPropFb.Execute := FALSE;
				Fbs.CyclicChCtrlFb.Controller := ADR(gMcAcp6DController);
				Fbs.CyclicChCtrlFb.ShuttleID[0] := 1;
				Fbs.CyclicChCtrlFb.ChannelID[0] := 2;
				Fbs.CyclicChCtrlFb.AxisID[0].0 := TRUE; //X
				Fbs.CyclicChCtrlFb.Execute := TRUE;
				Fbs.CyclicChCtrlFb.NumberOfShuttles := 1;
				Fbs.CyclicChCtrlFb.Level := 1;
				Fbs.CyclicChCtrlFb.OffsetX[0] := 0.060;
				
				state := AS_SETUP_CYCLIC_CHANNEL;
			END_IF
		AS_SETUP_CYCLIC_CHANNEL: //**************************************************************** Configuring Cyclic Channel
			
			IF Fbs.CyclicChCtrlFb.Error THEN
				errorState := state;
				gAntiSloshIf.Sts.Error := TRUE;
				state := AS_ERROR;
			ELSIF Fbs.CyclicChCtrlFb.Done THEN
				Fbs.CyclicChCtrlFb.Execute := FALSE;
				
				Fbs.CyclicXFb.Controller := ADR(gMcAcp6DController);
				Fbs.CyclicXFb.AxisID := 1;
				Fbs.CyclicXFb.ChannelID := 2;
				Fbs.CyclicXFb.Value := LREAL_TO_REAL(Fbs.AxisFb.Position / 1000.0);
				Fbs.CyclicXFb.Enable := TRUE;
				
				state := AS_ENABLE_CHANNEL;
			END_IF
		
		AS_ENABLE_CHANNEL: //**************************************************************** Starting to write to the cyclic channel
			IF Fbs.CyclicXFb.Valid THEN
				ShuttleCyclicChannelEnabled := TRUE;
				
				Fbs.SettleTon.PT := T#3s;
				Fbs.SettleTon.IN := TRUE;
				
				state := AS_WAIT_MOVE;
			END_IF
		AS_WAIT_MOVE: //**************************************************************** waiting for a move command
			IF NOT gAntiSloshIf.Cmd.Enable THEN 
				Fbs.CyclicXFb.Enable := FALSE;
				
				Fbs.CyclicChCtrlFb.Level := 0;
				Fbs.CyclicChCtrlFb.Execute := TRUE;
				
				state := AS_DISABLE_CHANNEL;
			ELSIF Fbs.SettleTon.Q THEN
				Fbs.SettleTon.IN := FALSE;
				IF Fbs.ProfGen.Position = 360 THEN
					Fbs.MovePlaneFb.PositionX := 0.06;
					Pars.DestPos := 0;
					
				ELSE
					Fbs.MovePlaneFb.PositionX := 0.42;
					Pars.DestPos := 360;
				END_IF
				
				Fbs.MovePlaneFb.Controller := ADR(gMcAcp6DController);
				Fbs.MovePlaneFb.PositionY := 0.18;
				Fbs.MovePlaneFb.ShuttleID := 2;
				Fbs.MovePlaneFb.Velocity := 1;
				Fbs.MovePlaneFb.Acceleration := 10;
				Fbs.MovePlaneFb.Execute := TRUE;
				Fbs.ProfGen.Start := TRUE;
				
				Fbs.ProfGen.EndPosition := Pars.DestPos;
				state := AS_MOVE;
			END_IF
		AS_MOVE: //**************************************************************** Move shuttles
			IF Fbs.MovePlaneFb.Error THEN
				errorState := state;
				gAntiSloshIf.Sts.Error := TRUE;
				state := AS_ERROR;
			ELSIF gAntiSloshIf.Cmd.Reset THEN
				gAntiSloshIf.Cmd.Reset := FALSE;
				Fbs.CyclicXFb.Enable := FALSE;
				
				Fbs.CyclicChCtrlFb.Level := 0;
				Fbs.CyclicChCtrlFb.Execute := TRUE;
				state := AS_DISABLE_CHANNEL;
			ELSIF Fbs.MovePlaneFb.Done AND Fbs.AxisFb.Position <= Pars.DestPos + 0.1 AND Fbs.AxisFb.Position >= Pars.DestPos - 0.1 THEN
				Fbs.ProfGen.Start := FALSE;
				Fbs.MovePlaneFb.Execute := FALSE;
					
				Fbs.SettleTon.IN := TRUE;
				state := AS_WAIT_MOVE;
			END_IF
		AS_DISABLE_CHANNEL: //**************************************************************** Disable Channel
			IF Fbs.CyclicChCtrlFb.Error THEN
				errorState := state;
				gAntiSloshIf.Sts.Error := TRUE;
				state := AS_ERROR;
			ELSIF Fbs.CyclicChCtrlFb.Done THEN
				Fbs.CyclicChCtrlFb.Execute := FALSE;
				ShuttleCyclicChannelEnabled := FALSE;
				
				//Have to do this to reset the cyclic position on the 6D, for some reason otherwise it'll just error and it's really awkward to troubleshoot
				Fbs.CyclicXFb.Value := 0;
				Fbs.CyclicXFb.Enable := TRUE;
				
				Fbs.ShortAxisFb.PositionZ := 0.001;
				Fbs.ShortAxisFb.Execute := TRUE;
				
				state := AS_RESET_HEIGHT;
			END_IF
		AS_RESET_HEIGHT: //**************************************************************** Reset Shuttle Height
			IF Fbs.ShortAxisFb.Error THEN
				gAntiSloshIf.Sts.Error := TRUE;
				errorState := state;
				state := AS_ERROR;
			ELSIF Fbs.ShortAxisFb.Done THEN
				Fbs.ShortAxisFb.Execute := FALSE;
				Fbs.CyclicXFb.Enable := FALSE;
				
				Fbs.ShPropFb.Value[0] := 0;
				Fbs.ShPropFb.Execute := TRUE;
				
				state := AS_RESET_PAYLOAD;
			END_IF
		AS_RESET_PAYLOAD: //**************************************************************** Reset Payload
			IF Fbs.ShPropFb.Error THEN
				gAntiSloshIf.Sts.Error := TRUE;
				errorState := state;
				state := AS_ERROR;
			ELSIF Fbs.ShPropFb.Done THEN
				Fbs.ShPropFb.Execute := FALSE;
				
				state := AS_RESET;
			END_IF
		AS_ERROR: //**************************************************************** Error State
			IF gAntiSloshIf.Cmd.Reset THEN
				state := AS_RESET;
			END_IF
		AS_RESET: //**************************************************************** Reset State
			
			gAntiSloshIf.Sts.Enabled := FALSE;
			gAntiSloshIf.Sts.Error := FALSE;
			gAntiSloshIf.Sts.Processing := FALSE;
				
			gAntiSloshIf.Cmd.Reset := FALSE;
					
			Fbs.ContainerFb.Enable := FALSE;
			Fbs.CyclicChCtrlFb.Execute := FALSE;
			Fbs.CyclicXFb.Enable := FALSE;
			Fbs.MoveCyclicPosFb.Enable := FALSE;
			Fbs.ShaperFb.Enable := FALSE;
			Fbs.ShortAxisFb.Execute := FALSE;
			Fbs.MovePlaneFb.Execute := FALSE;
			Fbs.SettleTon.IN := FALSE;
			Fbs.ShPropFb.Execute := FALSE;
						
			ShuttleCyclicChannelEnabled := FALSE;
			ContainerParsCalculated := FALSE;
			ProfGenHomed := FALSE;
				
			Fbs.AxisFb.ErrorReset := TRUE;
					
			IF NOT Fbs.AxisFb.Error THEN
				Fbs.AxisFb.ErrorReset := FALSE;
				Fbs.AxisFb.Power := FALSE;
					
				state := AS_IDLE;
			END_IF
												
	END_CASE;
	
	Fbs.AxisFb();
	IF Fbs.AxisFb.Error AND Fbs.AxisFb.ErrorReset THEN
		Fbs.AxisFb.ErrorReset := FALSE;
		Fbs.AxisFb();
	END_IF
	Fbs.ContainerFb();
	Fbs.CyclicChCtrlFb();
	Fbs.CyclicXFb();
	Fbs.MoveCyclicPosFb();
	Fbs.ProfGen();
	Fbs.ShaperFb();
	Fbs.ShPropFb();
	Fbs.MovePlaneFb();
	Fbs.ShortAxisFb();
	Fbs.SettleTon();
END_PROGRAM
