(*
	Simple program to control the MpRecipe Interface
	Offers ability to save/load recipes on command
*)

PROGRAM _CYCLIC
	CASE state OF
		RECIPE_IDLE: //******************************************************************************** Idle Wait State
			IF recipeXmlFb.Error THEN
				recipeIf.Sts.Error := TRUE;
				state := RECIPE_ERROR;
			ELSIF recipeIf.Cmd.Load THEN
				recipeIf.Cmd.Load := FALSE;
				recipeXmlFb.FileName := ADR(recipeIf.Par.FileName);
				recipeXmlFb.DeviceName := ADR(recipeIf.Par.FileDevice);
				recipeXmlFb.Load := TRUE;
				state := RECIPE_LOAD;
			ELSIF recipeIf.Cmd.Save THEN
				recipeIf.Cmd.Save := FALSE;
				recipeXmlFb.FileName := ADR(recipeIf.Par.FileName);
				recipeXmlFb.DeviceName := ADR(recipeIf.Par.FileDevice);
				recipeXmlFb.Save := TRUE;
				state := RECIPE_SAVE;
			ELSIF recipeIf.Cmd.Reset THEN
			END_IF
		RECIPE_LOAD: //******************************************************************************** Loading recipe state
			IF recipeXmlFb.Error THEN
				state := RECIPE_ERROR;
				recipeIf.Sts.Error := TRUE;
			ELSIF recipeXmlFb.CommandDone THEN
				recipeXmlFb.Load := FALSE;
				
				recipeIf.Sts.Done := TRUE;
				state := RECIPE_DONE;
			END_IF
		RECIPE_SAVE: //******************************************************************************** Saving recipe state
			IF recipeXmlFb.Error THEN
				state := RECIPE_ERROR;
				recipeIf.Sts.Error := TRUE;
			ELSIF recipeXmlFb.CommandDone THEN
				recipeXmlFb.Save := FALSE;
				
				recipeIf.Sts.Done := TRUE;
				state := RECIPE_DONE;
			END_IF
		RECIPE_DONE: //******************************************************************************** Done State
			IF NOT recipeIf.Cmd.Load AND NOT recipeIf.Cmd.Save THEN
				state := RECIPE_RESET;
			END_IF
		RECIPE_ERROR: //******************************************************************************** Error State
			IF recipeIf.Cmd.Reset THEN
				recipeXmlFb.ErrorReset := TRUE;
				state := RECIPE_RESET;
			END_IF
		RECIPE_RESET: //******************************************************************************** Reset State
			recipeXmlFb.Save := FALSE;
			recipeXmlFb.Load := FALSE;
			recipeIf.Cmd.Load := FALSE;
			recipeIf.Cmd.Save := FALSE;
			
			IF NOT recipeXmlFb.Error THEN
				recipeIf.Sts.Done := FALSE;
				recipeIf.Sts.Error := FALSE;
				
				recipeXmlFb.ErrorReset := FALSE;
				
				recipeIf.Cmd.Reset := FALSE;
				
				state := RECIPE_IDLE;
			END_IF
	END_CASE;
	 
	recipeXmlFb();
	processRecipeRegParFb();
	pickPlaceCfgRegParFb();
	pickPlaceTuneRegParFb();
END_PROGRAM
