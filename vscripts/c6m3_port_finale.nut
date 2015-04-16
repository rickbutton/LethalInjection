

Msg("----------------------FINALE SCRIPT------------------\n")
//-----------------------------------------------------
PANIC <- 0
TANK <- 1
DELAY <- 2
ONSLAUGHT <- 3
//-----------------------------------------------------

SharedOptions <-
{
 	A_CustomFinale1 = PANIC
	A_CustomFinaleValue1 = 999

	PreferredMobDirection = SPAWN_LARGE_VOLUME
	PreferredSpecialDirection = SPAWN_LARGE_VOLUME

	ZombieSpawnRange = 3000
	MobRechargeRate = 0.5
	
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 2
	MusicDynamicMobScanStopSize = 1
} 

InitialOnslaughtOptions <-
{
    	LockTempo = 0
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 2
	RelaxMaxInterval = 4
	SustainPeakMinTime = 25
	SustainPeakMaxTime = 30
}

PanicOptions <-
{
}

TankOptions <-
{
	ShouldAllowMobsWithTank = true
	ShouldAllowSpecialsWithTank = true
}


DirectorOptions <- clone SharedOptions
{
}


//-----------------------------------------------------

// number of cans needed to escape.
NumCansNeeded <- 16

// fewer cans in single player since bots don't help much
if ( Director.IsSinglePlayerGame() )
{
	NumCansNeeded <- 10
}

// duration of delay stage.
DelayMin <- 10
DelayMax <- 20

// Number of touches and/or pours allowed before a delay is aborted.
DelayPourThreshold <- 1
DelayTouchedOrPouredThreshold <- 2


// Once the delay is aborted, amount of time before it progresses to next stage.
AbortDelayMin <- 1
AbortDelayMax <- 3

// Number of touches and pours it takes to transition out of c1m4_finale_wave_1
GimmeThreshold <- 4

//-----------------------------------------------------
//      INIT
//-----------------------------------------------------

GasCansTouched          <- 0
GasCansPoured           <- 0
DelayTouchedOrPoured    <- 0
DelayPoured             <- 0

EntFire( "timer_delay_end", "LowerRandomBound", DelayMin )
EntFire( "timer_delay_end", "UpperRandomBound", DelayMax )
EntFire( "timer_delay_abort", "LowerRandomBound", AbortDelayMin )
EntFire( "timer_delay_abort", "UpperRandomBound", AbortDelayMax )

// this is too late. Moved to c1m4_atrium.nut
//EntFire( "progress_display", "SetTotalItems", NumCansNeeded )

function AbortDelay(){}  	// only defined during a delay, in c1m4_delay.nut
function EndDelay(){}		// only defined during a delay, in c1m4_delay.nut

NavMesh.UnblockRescueVehicleNav()

//-----------------------------------------------------

function GasCanTouched()
{
    GasCansTouched++
    Msg(" Touched: " + GasCansTouched + "\n")   
     
    EvalGasCansPouredOrTouched()    
}
    
function GasCanPoured()
{
    GasCansPoured++
    DelayPoured++
    Msg(" Poured: " + GasCansPoured + "\n")   

    if ( GasCansPoured == NumCansNeeded )
    {
        Msg(" needed: " + NumCansNeeded + "\n") 
        EntFire( "relay_car_ready", "trigger" )
    }

    EvalGasCansPouredOrTouched()
}

function EvalGasCansPouredOrTouched()
{
    TouchedOrPoured <- GasCansPoured + GasCansTouched
    Msg(" Poured or touched: " + TouchedOrPoured + "\n")

    DelayTouchedOrPoured++
    Msg(" DelayTouchedOrPoured: " + DelayTouchedOrPoured + "\n")
    Msg(" DelayPoured: " + DelayPoured + "\n")
    
    if (( DelayTouchedOrPoured >= DelayTouchedOrPouredThreshold ) || ( DelayPoured >= DelayPourThreshold ))
    {
        AbortDelay()
    }
    
    switch( TouchedOrPoured )
    {
        case GimmeThreshold:
            EntFire( "@director", "EndCustomScriptedStage" )
            break
    }
}
//-----------------------------------------------------

function AddTableToTable( dest, src )
{
	foreach( key, val in src )
	{
		dest[key] <- val
	}
}

function OnBeginCustomFinaleStage( num, type )
{
	printl( "Beginning custom finale stage " + num + " of type " + type );
	
	local waveOptions = null
	if ( num == 1 )
	{
		waveOptions = InitialOnslaughtOptions
	}
	else if ( type == PANIC )
	{
		waveOptions = PanicOptions
		
	}
	else if ( type == TANK )
	{
		waveOptions = TankOptions
		EntFire( "bonus_relay", "Trigger", 0 )
	}
	
	// give out items at certain stages
	if ( num == 3 || num == 7 || num == 15 || num == 23 )
	{
		Director.L4D1SurvivorGiveItem()
	}
	
	//---------------------------------


	MapScript.DirectorOptions.clear()
	

	AddTableToTable( MapScript.DirectorOptions, SharedOptions );

	if ( waveOptions != null )
	{
		AddTableToTable( MapScript.DirectorOptions, waveOptions );
	}
	
	
	Director.ResetMobTimer()
	
	if ( developer() > 0 )
	{
		Msg( "\n*****\nMapScript.DirectorOptions:\n" );
		foreach( key, value in MapScript.DirectorOptions )
		{
			Msg( "    " + key + " = " + value + "\n" );
		}

		if ( LocalScript.rawin( "DirectorOptions" ) )
		{
			Msg( "\n*****\nLocalScript.DirectorOptions:\n" );
			foreach( key, value in LocalScript.DirectorOptions )
			{
				Msg( "    " + key + " = " + value + "\n" );
			}
		}
	}
}

