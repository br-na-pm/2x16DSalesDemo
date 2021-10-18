

PROGRAM _EXIT
	recipeXmlFb.Enable := FALSE;
	recipeXmlFb();
	processRecipeRegParFb.Enable := FALSE;
	processRecipeRegParFb();
	pickPlaceCfgRegParFb.Enable := FALSE;
	pickPlaceCfgRegParFb();
	pickPlaceTuneRegParFb.Enable := FALSE;
	pickPlaceTuneRegParFb();
	 
END_PROGRAM