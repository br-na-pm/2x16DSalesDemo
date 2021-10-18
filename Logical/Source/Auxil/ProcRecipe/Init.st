

PROGRAM _INIT
	
	gProcessRecipe.General.St1St2Cycles := 2;
	
	gProcessRecipe.Unload.EndPos.X := 0.48;
	gProcessRecipe.Load.EndPos.X := 0.62;
	
	gProcessRecipe.Inspect.DwellTime := T#1s;
	gProcessRecipe.St1.DwellTime := T#1s;
	gProcessRecipe.St2.DwellTime := T#1s;
	
	gProcessPickPlaceIf.Par.WaitTune.ApproachHeight := 0;
	gProcessPickPlaceIf.Par.WaitTune.DepartHeight := 00;
	gProcessPickPlaceIf.Par.WaitTune.DwellTime := 0;
	gProcessPickPlaceIf.Par.WaitTune.Radius := 300;
	
	//Load Parameters and configuration
	gProcessPickPlaceIf.Cfg.LoadPickPos.X := 540;
	gProcessPickPlaceIf.Cfg.LoadPickPos.Y := -60;
	gProcessPickPlaceIf.Cfg.LoadPickPos.Z := 50;
	
	gProcessPickPlaceIf.Cfg.LoadPlacePos.X := 540;
	gProcessPickPlaceIf.Cfg.LoadPlacePos.Y := 60;
	gProcessPickPlaceIf.Cfg.LoadPlacePos.Z := 40;
	
	gProcessPickPlaceIf.Par.LoadPickTune.ApproachHeight := 25;
	gProcessPickPlaceIf.Par.LoadPickTune.DepartHeight := 10;
	gProcessPickPlaceIf.Par.LoadPickTune.DwellTime := 75;
	gProcessPickPlaceIf.Par.LoadPickTune.Radius := 10;
	
	gProcessPickPlaceIf.Par.LoadPlaceTune.ApproachHeight := 30;
	gProcessPickPlaceIf.Par.LoadPlaceTune.DepartHeight := 10;
	gProcessPickPlaceIf.Par.LoadPlaceTune.DwellTime := 50;
	gProcessPickPlaceIf.Par.LoadPlaceTune.Radius := 10;
	
	//Unload Parameters and configuration
	gProcessPickPlaceIf.Cfg.UnloadPickPos.X := 420;
	gProcessPickPlaceIf.Cfg.UnloadPickPos.Y := 60;
	gProcessPickPlaceIf.Cfg.UnloadPickPos.Z := 40;
	
	gProcessPickPlaceIf.Cfg.UnloadPlacePos.X := 420;
	gProcessPickPlaceIf.Cfg.UnloadPlacePos.Y := -60;
	gProcessPickPlaceIf.Cfg.UnloadPlacePos.Z := 50;
	
	gProcessPickPlaceIf.Par.UnloadPickTune.ApproachHeight := 20;
	gProcessPickPlaceIf.Par.UnloadPickTune.DepartHeight := 15;
	gProcessPickPlaceIf.Par.UnloadPickTune.DwellTime := 50;
	gProcessPickPlaceIf.Par.UnloadPickTune.Radius := 25;
	
	gProcessPickPlaceIf.Par.UnloadPlaceTune.ApproachHeight := 25;
	gProcessPickPlaceIf.Par.UnloadPlaceTune.DepartHeight := 15;
	gProcessPickPlaceIf.Par.UnloadPlaceTune.DwellTime := 75;
	gProcessPickPlaceIf.Par.UnloadPlaceTune.Radius := 5;
	
	gProcessPickPlaceIf.Par.EmptySpeed.Vel := 1200;
	gProcessPickPlaceIf.Par.EmptySpeed.Accel := 3000;
	gProcessPickPlaceIf.Par.EmptySpeed.Decel := 3000;
	
	gProcessPickPlaceIf.Par.ProductSpeed.Vel := 700;
	gProcessPickPlaceIf.Par.ProductSpeed.Accel := 3000;
	gProcessPickPlaceIf.Par.ProductSpeed.Decel := 3000;
	
	gProcessPickPlaceIf.Cfg.WaitPos.X := 420;
	gProcessPickPlaceIf.Cfg.WaitPos.Y := 60;
	gProcessPickPlaceIf.Cfg.WaitPos.Z := 60;
	
	
		
	recipeIf.Par.FileDevice := 'Recipe';
	recipeIf.Par.FileName := 'DemoPars.xml';
	
	recipeXmlFb.MpLink := ADR(gRecipeXml);
	recipeXmlFb.Enable := TRUE;
	recipeXmlFb.Category := ADR('6D');
	recipeXmlFb();
	
	processRecipeRegParFb.MpLink := ADR(gRecipeXml);
	processRecipeRegParFb.PVName := ADR('gProcessRecipe');
	processRecipeRegParFb.Enable := TRUE;
	processRecipeRegParFb.Category := ADR('6D');
	processRecipeRegParFb();
	
	pickPlaceCfgRegParFb.MpLink := ADR(gRecipeXml);
	pickPlaceCfgRegParFb.PVName := ADR('gProcessPickPlaceIf.Cfg');
	pickPlaceCfgRegParFb.Enable := TRUE;
	pickPlaceCfgRegParFb.Category := ADR('6D');
	pickPlaceCfgRegParFb();
	
	pickPlaceTuneRegParFb.MpLink := ADR(gRecipeXml);
	pickPlaceTuneRegParFb.PVName := ADR('gProcessPickPlaceIf.Par');
	pickPlaceTuneRegParFb.Enable := TRUE;
	pickPlaceTuneRegParFb.Category := ADR('6D');
	pickPlaceTuneRegParFb();
END_PROGRAM
