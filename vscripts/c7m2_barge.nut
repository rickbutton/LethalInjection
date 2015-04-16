//-----------------------------------------------------
//
//
//-----------------------------------------------------
Msg("SQUIRREL c7m2_barge script\n");

BargeCommonLimit <- 50	// use a lower common limit to combat infected related perf issues

if ( Director.IsPlayingOnConsole() )
{
	BargeCommonLimit <- 20
}


DirectorOptions <-
{
	CommonLimit = BargeCommonLimit	
}


