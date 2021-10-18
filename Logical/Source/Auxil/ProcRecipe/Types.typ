
TYPE
	RecipeIfParTyp : 	STRUCT 
		FileDevice : STRING[80];
		FileName : STRING[80];
	END_STRUCT;
	RecipeIfCmdTyp : 	STRUCT 
		Save : BOOL;
		Load : BOOL;
		Reset : BOOL;
	END_STRUCT;
	RecipeIfStsTyp : 	STRUCT 
		Done : USINT;
		Error : USINT;
	END_STRUCT;
	RecipeIfTyp : 	STRUCT 
		Cmd : RecipeIfCmdTyp;
		Par : RecipeIfParTyp;
		Sts : RecipeIfStsTyp;
	END_STRUCT;
	RecipeStatesEnum : 
		(
		RECIPE_IDLE,
		RECIPE_LOAD,
		RECIPE_SAVE,
		RECIPE_DONE,
		RECIPE_ERROR,
		RECIPE_RESET
		);
END_TYPE
