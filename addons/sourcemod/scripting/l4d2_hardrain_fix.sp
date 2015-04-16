#include <sourcemod>
#include <sdktools>

new String:current_map[24];
new status

public OnPluginStart()
{
	HookEvent("player_spawn", Player_Spawn);
	HookEvent("round_start", Round_Start);
	CreateTimer(1.0,TimerUpdate, _, TIMER_REPEAT);
}
public OnMapStart()
{
	GetCurrentMap(current_map, 24);
}
public Action:Player_Spawn(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (StrEqual(current_map, "c4m2_sugarmill_a", false))
	{
		if (client > 0)
		{
			if (IsClientInGame(client) && GetClientTeam(client) == 3)
			{
				if (IsFakeClient(client) && IsPlayerAlive(client))
				{
					CreateTimer(0.1, MoveEntityA, client);
				}
			}
		}
	}
}
public Action:Round_Start(Handle:event, String:event_name[], bool:dontBroadcast)
{
	status = 0;
}
public OnEntityCreated(entity, const String:classname[])
{
	if (StrEqual(current_map, "c4m2_sugarmill_a", false))
	{
		if (StrEqual(classname, "infected") || StrEqual(classname, "witch"))
		{
			CreateTimer(0.1, MoveEntityA, entity);
		}
	}
}
public Action:MoveEntityA(Handle:timer, any:entity)
{
	if (StrEqual(current_map, "c4m2_sugarmill_a", false))
	{
		if (IsValidEntity(entity))
		{
			decl String:classname[32];
			GetEdictClassname(entity, classname, sizeof(classname));
			if (StrEqual(classname, "infected", false) || StrEqual(classname, "witch", false))
			{
				new Float:Dest[3], Float:Origin[3];
				GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
				if ((Origin[1] < -9425.0) && (Origin[2] < 512.0) && (status < 4))
				{
					new random = GetRandomInt(1,3);
					switch(random)
					{
						case 1: 
						{
							Dest[0] = -441.0
							Dest[1] = -6907.0
							Dest[2] = 121.0
						}
						case 2: 
						{
							Dest[0] = 624.0
							Dest[1] = -8496.0
							Dest[2] = 97.0
						}
						case 3: 
						{
							Dest[0] = -1230.0
							Dest[1] = -8007.0
							Dest[2] = 97.0
						}
					}
					TeleportEntity(entity, Dest, NULL_VECTOR, NULL_VECTOR);
				}
				else if ((Origin[1] > -9425.0) && (status >= 4))
				{
					new random = GetRandomInt(1,3);
					switch(random)
					{
						case 1: 
						{
							Dest[0] = -2083.0
							Dest[1] = -13580.0
							Dest[2] = 125.0
						}
						case 2: 
						{
							Dest[0] = -2363.0
							Dest[1] = -12338.0
							Dest[2] = 101.0
						}
						case 3: 
						{
							Dest[0] = -252.0
							Dest[1] = -12359.0
							Dest[2] = 106.0
						}
					}
					TeleportEntity(entity, Dest, NULL_VECTOR, NULL_VECTOR);
				}
			}
			else if (StrEqual(classname, "player", false))
			{
				if (entity > 0 && IsClientInGame(entity) && IsFakeClient(entity) && IsPlayerAlive(entity) && GetClientTeam(entity) == 3)
				{
					new Float:Dest[3], Float:Origin[3];
					GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
					if ((Origin[1] < -9425.0) && (Origin[2] < 512.0) && (status < 4))
					{
						new random = GetRandomInt(1,3);
						switch(random)
						{
							case 1: 
							{
								Dest[0] = -441.0
								Dest[1] = -6907.0
								Dest[2] = 121.0
							}
							case 2: 
							{
								Dest[0] = 624.0
								Dest[1] = -8496.0
								Dest[2] = 97.0
							}
							case 3: 
							{
								Dest[0] = -1230.0
								Dest[1] = -8007.0
								Dest[2] = 97.0
							}
						}
						TeleportEntity(entity, Dest, NULL_VECTOR, NULL_VECTOR);
					}
				}
			}
		}
	}
}
public Action:TimerUpdate(Handle:timer)
{
	if (!IsServerProcessing()) return Plugin_Continue;

	if (StrEqual(current_map, "c4m2_sugarmill_a", false))
	{
		decl String: classname[32];
		new entitycount = GetMaxEntities();
		for (new j=1; j<=entitycount; j++)
		{
			if (IsValidEntity(j))
			{
				GetEdictClassname(j, classname, sizeof(classname));
				if (StrEqual(classname, "func_elevator", false))
				{
					switch(status)
					{
						case 0:
						{
							new ismoving = GetEntProp(j, Prop_Send, "m_isMoving");
							if (ismoving > 0)
							{
								status = 1;
							}
						}
						case 1:
						{
							new ismoving = GetEntProp(j, Prop_Send, "m_isMoving");
							if (ismoving <= 0)
							{
								status = 2;
							}
						}
						case 2:
						{
							new ismoving = GetEntProp(j, Prop_Send, "m_isMoving");
							if (ismoving > 0)
							{
								status = 3;
							}
						}
						case 3:
						{
							new ismoving = GetEntProp(j, Prop_Send, "m_isMoving");
							if (ismoving <= 0)
							{
								status = 4;
							}
						}
					}
				}
				else if (StrEqual(classname, "func_brush", false))
				{
					switch(status)
					{
						case 3:
						{
							new hammerid = GetEntProp(j, Prop_Data, "m_iHammerID");
							if (hammerid == 12345678)
							{
								AcceptEntityInput(j, "Kill");
							}
						}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}			