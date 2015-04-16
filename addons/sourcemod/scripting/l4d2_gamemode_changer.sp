#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

public OnPluginStart()
{
	CreateTimer(30.0,TimerUpdate, _, TIMER_REPEAT);
}
public Action:TimerUpdate(Handle:timer)
{
	if (!IsServerProcessing()) return Plugin_Continue;

	decl String:gamemode[24];
	GetConVarString(FindConVar("mp_gamemode"), gamemode, sizeof(gamemode));

       	if (!StrEqual(gamemode, "coop", false) && !StrEqual(gamemode, "realism", false))
	{
		SetConVarString(FindConVar("mp_gamemode"), "coop");
		CreateTimer(1.0, ChangeGameModeTimer);			
	}
	return Plugin_Continue;
}

public Action:ChangeGameModeTimer(Handle:timer)
{
	decl String:Map[56];
	GetCurrentMap(Map, sizeof(Map));
	ForceChangeLevel(Map, "Changing gamemode back to Coop.");
}
