

PROGRAM _INIT
	gMacroLoadIf.Par.SingleMacroLoad.Load := TRUE;
	
		//Fill Station 2
	gMacroLoadIf.Par.MacroList[0].Load := TRUE;
	gMacroLoadIf.Par.MacroList[0].MacroFileName := '135_UpDown.xml';
	gMacroLoadIf.Par.MacroList[0].MacroID := 135;
	
	gMacroLoadIf.Par.MacroList[1].Load := TRUE;
	gMacroLoadIf.Par.MacroList[1].MacroFileName := '136_DownUp.xml';
	gMacroLoadIf.Par.MacroList[1].MacroID := 136;
	
	gMacroLoadIf.Par.MacroList[2].Load := TRUE;
	gMacroLoadIf.Par.MacroList[2].MacroFileName := '137_LevUpDown.xml';
	gMacroLoadIf.Par.MacroList[2].MacroID := 137;
	
	gMacroLoadIf.Par.MacroList[3].Load := TRUE;
	gMacroLoadIf.Par.MacroList[3].MacroFileName := '138_Circle.xml';
	gMacroLoadIf.Par.MacroList[3].MacroID := 138;
	
	gMacroLoadIf.Par.MacroList[4].Load := TRUE;
	gMacroLoadIf.Par.MacroList[4].MacroFileName := '180_SpiralProc.xml';
	gMacroLoadIf.Par.MacroList[4].MacroID := 180;
	
	gMacroLoadIf.Par.MacroList[5].Load := TRUE;
	gMacroLoadIf.Par.MacroList[5].MacroFileName := '139_CircleCCW.xml';
	gMacroLoadIf.Par.MacroList[5].MacroID := 139;
	
	gMacroLoadIf.Par.MacroList[6].Load := TRUE;
	gMacroLoadIf.Par.MacroList[6].MacroFileName := '140_Sh1Cycle.xml';
	gMacroLoadIf.Par.MacroList[6].MacroID := 140;
	
	gMacroLoadIf.Par.MacroList[7].Load := TRUE;
	gMacroLoadIf.Par.MacroList[7].MacroFileName := '141_Sh2Cycle.xml';
	gMacroLoadIf.Par.MacroList[7].MacroID := 141;
	//Define the parameters for the macro load IF
	gMacroLoadIf.Par.FileDevice := '6DMacro';
END_PROGRAM