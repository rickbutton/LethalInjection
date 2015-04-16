//-----------------------------------------------------
//
//
//-----------------------------------------------------
Msg("SQUIRREL c7m1_docks script\n");

DocksCommonLimit <- 50	// use a lower common limit to combat pathing related perf issues
DocksMegaMobSize <- 50	

if ( Director.IsPlayingOnConsole() )
{
	DocksCommonLimit <- 20
}

if ( Director.GetGameMode() == "coop" )
{
	DocksMegaMobSize <- 50	// use a smaller megamob for the panic event in the train car area. 
}

DirectorOptions <-
{
	//ProhibitBosses = true
	CommonLimit = DocksCommonLimit	
	MegaMobSize = DocksMegaMobSize
}


