//-----------------------------------------------------
// This script handles the logic for the Port / Bridge
// finale in the River Campaign. 
//
//-----------------------------------------------------
Msg("Initiating c7m3_port_finale script\n");

//-----------------------------------------------------
ERROR		<- -1
PANIC 		<- 0
TANK 		<- 1
DELAY 		<- 2

//-----------------------------------------------------
DirectorOptions <-
{	
	 
	A_CustomFinale_StageCount = 1
	A_CustomFinale1 = PANIC
	A_CustomFinaleValue1 = 999
}