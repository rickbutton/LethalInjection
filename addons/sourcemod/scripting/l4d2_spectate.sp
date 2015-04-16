#include <sourcemod>
#pragma semicolon 1

public OnPluginStart()
{
	RegAdminCmd("sm_spectate", Command_Spectate, ADMFLAG_SLAY);
}

public Action:Command_Spectate(client, args)
{
	ChangeClientTeam(client, 1);

	return Plugin_Handled;
}
