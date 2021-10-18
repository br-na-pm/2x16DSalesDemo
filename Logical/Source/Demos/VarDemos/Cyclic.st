(* 
	
*)

PROGRAM _CYCLIC
	IF gVariousDemoIf.Cmd.Reset THEN
		gAntiSloshIf.Cmd.Reset := TRUE;
	END_IF
	CASE state OF
		VAR_DEMO_IDLE: //******************************************************************************** Idle Wait State
			IF gVariousDemoIf.Cmd.RunDemo OR gVariousDemoIf.Cmd.ChangeDemo THEN
				gVariousDemoIf.Cmd.ChangeDemo := FALSE;
				gVariousDemoIf.Cmd.RunDemo := FALSE;
				
				gVariousDemoIf.Sts.Active := TRUE;
				CASE gVariousDemoIf.Par.Demo OF
					VAR_DEMO_SLIDE:
						AsignSlideDemo;
					VAR_DEMO_MIX:
						AsignMixDemo;
					VAR_DEMO_WEIGH:
						AsignWeighDemo;
					VAR_DEMO_WAVE:
						AsignWaveDemo;
					VAR_DEMO_FORCE:
						AsignForceDemo;
					VAR_DEMO_LAND:
						AsignLandDemo;
					VAR_DEMO_ANTI_SLOSH:
						AsignAntiSLosh;
					VAR_DEMO_GENERIC_MOVEMENT:
						AsignGenericDemoMovement;
					
				END_CASE
				Fbs.AutoDriveFb.Execute := TRUE;
				state := VAR_DEMO_MOVE_TO_START;
			END_IF
		VAR_DEMO_MOVE_TO_START: //******************************************************************************** Moving to start
			IF Fbs.AutoDriveFb.Error THEN
				state := VAR_DEMO_ERROR;
				gVariousDemoIf.Sts.Error := TRUE;
			ELSIF Fbs.AutoDriveFb.Done THEN
				Fbs.AutoDriveFb.Execute := FALSE;
				CASE gVariousDemoIf.Par.Demo OF
					VAR_DEMO_SLIDE:
						Fbs.SlideFb.Enable := TRUE;
					VAR_DEMO_MIX:
						Fbs.MixProfFb[0].Enable := TRUE;
						Fbs.MixProfFb[1].Enable := TRUE;
					VAR_DEMO_WEIGH:
//						Fbs.WeighFB[0].Execute := TRUE;
//						Fbs.WeighFB[1].Execute := TRUE;
					VAR_DEMO_WAVE:
						Fbs.WaveFb.Enable := TRUE;
					VAR_DEMO_FORCE:
						Fbs.ForceCtrlFB[0].Enable := TRUE;
						Fbs.ForceCtrlFB[1].Enable := TRUE;
					VAR_DEMO_LAND:
						Fbs.LandCtrlFb[0].Enable := TRUE;
						Fbs.LandCtrlFb[1].Enable := TRUE;
					VAR_DEMO_ANTI_SLOSH:
						gAntiSloshIf.Cmd.Enable := TRUE;
					VAR_DEMO_GENERIC_MOVEMENT:
						Fbs.GenericDemoFb.Enable := TRUE;
				END_CASE
				gVariousDemoIf.Sts.Running := TRUE;
				state := VAR_DEMO_RUN;
			END_IF
		VAR_DEMO_RUN: //******************************************************************************** Run Demo
			CASE gVariousDemoIf.Par.Demo OF
				VAR_DEMO_WEIGH:
					Fbs.WeighFB[0].Execute := NOT Fbs.WeighFB[0].Done;
					Fbs.WeighFB[1].Execute := NOT Fbs.WeighFB[1].Done;
			END_CASE
			
			IF Fbs.SlideFb.Error 
				OR Fbs.MixProfFb[0].Error 
				OR Fbs.MixProfFb[1].Error 
				OR Fbs.WeighFB[0].Error 
				OR Fbs.WeighFB[1].Error 
				OR Fbs.WaveFb.Error 
				OR Fbs.ForceCtrlFB[0].Error 
				OR Fbs.ForceCtrlFB[1].Error
				OR Fbs.LandCtrlFb[0].Error
				OR Fbs.LandCtrlFb[1].Error
				OR gAntiSloshIf.Sts.Error
				OR Fbs.GenericDemoFb.Error 
				THEN
				
				gVariousDemoIf.Sts.Error := TRUE;
				state := VAR_DEMO_ERROR;
			ELSIF gVariousDemoIf.Cmd.Stop OR gVariousDemoIf.Cmd.ChangeDemo THEN
				gVariousDemoIf.Cmd.Stop := FALSE;
				Fbs.SlideFb.Enable := FALSE;
				Fbs.MixProfFb[0].Enable := FALSE;
				Fbs.MixProfFb[1].Enable := FALSE;
				Fbs.WeighFB[0].Execute := FALSE;
				Fbs.WeighFB[1].Execute := FALSE;
				Fbs.ForceCtrlFB[0].Enable := FALSE;
				Fbs.ForceCtrlFB[1].Enable := FALSE;
				Fbs.LandCtrlFb[0].Enable := FALSE;
				Fbs.LandCtrlFb[1].Enable:= FALSE;
				Fbs.GenericDemoFb.Enable := FALSE;
				gAntiSloshIf.Cmd.Enable := FALSE;
				
				Fbs.WaveFb.Enable := FALSE;
				state := VAR_DEMO_STOP;
			END_IF
		VAR_DEMO_STOP: //******************************************************************************** Stopping the demo
			IF Fbs.SlideFb.Error 
				OR Fbs.MixProfFb[0].Error 
				OR Fbs.MixProfFb[1].Error 
				OR Fbs.WaveFb.Error 
				OR gAntiSloshIf.Sts.Error 
				OR Fbs.GenericDemoFb.Error THEN
				
				gVariousDemoIf.Sts.Error := TRUE;
				state := VAR_DEMO_ERROR;
			ELSIF NOT Fbs.SlideFb.Active AND NOT Fbs.MixProfFb[0].Active 
				AND NOT Fbs.MixProfFb[1].Active 
				AND NOT Fbs.WeighFB[0].Active 
				AND NOT Fbs.WeighFB[1].Active 
				AND NOT Fbs.ForceCtrlFB[0].Active 
				AND NOT Fbs.ForceCtrlFB[1].Active 
				AND NOT Fbs.LandCtrlFb[0].Active 
				AND NOT Fbs.LandCtrlFb[1].Active 
				AND NOT gAntiSloshIf.Sts.Enabled
				AND NOT Fbs.GenericDemoFb.Active THEN
				
				Fbs.DelayFb.PT := delayTime;
				Fbs.DelayFb.IN := TRUE;
				IF Fbs.DelayFb.Q THEN
					Fbs.DelayFb.IN := FALSE;
					IF gVariousDemoIf.Cmd.ChangeDemo THEN
						state := VAR_DEMO_IDLE;
					ELSE
						state := VAR_DEMO_RESET;
					END_IF
				END_IF
			END_IF
		VAR_DEMO_ERROR: //******************************************************************************** Error present
			IF gVariousDemoIf.Cmd.Reset THEN
				state := VAR_DEMO_RESET;
			END_IF
		VAR_DEMO_RESET: //******************************************************************************** Resetting Everything
			gVariousDemoIf.Cmd.Reset := FALSE;
			
			gVariousDemoIf.Sts.Active := FALSE;
			gVariousDemoIf.Sts.Error := FALSE;
			gVariousDemoIf.Sts.Running := FALSE;
			Fbs.AutoDriveFb.Execute := FALSE;
			Fbs.MixProfFb[0].Enable := FALSE;
			Fbs.MixProfFb[1].Enable := FALSE;
			Fbs.WeighFB[0].Execute := FALSE;
			Fbs.WeighFB[1].Execute := FALSE;
			Fbs.ForceCtrlFB[0].Enable := FALSE;
			Fbs.ForceCtrlFB[1].Enable := FALSE;
			Fbs.WaveFb.Enable := FALSE;
			Fbs.LandCtrlFb[0].Enable := FALSE;
			Fbs.LandCtrlFb[1].Enable := FALSE;
			gAntiSloshIf.Cmd.Enable := FALSE;
			gAntiSloshIf.Cmd.Reset := TRUE;
			Fbs.GenericDemoFb.Enable := FALSE;
			IF NOT gAntiSloshIf.Sts.Error THEN
				state := VAR_DEMO_IDLE;
			END_IF
	END_CASE
	
	Fbs.AutoDriveFb();
	Fbs.SlideFb();
	Fbs.MixProfFb[0]();
	Fbs.MixProfFb[1]();
	Fbs.DelayFb();
	Fbs.WeighFB[0]();
	Fbs.WeighFB[1]();
	Fbs.ForceCtrlFB[0]();
	Fbs.ForceCtrlFB[1]();
	Fbs.LandCtrlFb[0]();
	Fbs.LandCtrlFb[1]();
	Fbs.WaveFb();
	Fbs.GenericDemoFb();
	
	HmiConnections;
END_PROGRAM
