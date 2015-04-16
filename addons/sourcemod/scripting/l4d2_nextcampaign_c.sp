#include <sourcemod>
#include <sdktools>
new String:current_map[32];

public OnPluginStart()
{
	HookEvent("finale_win", Event_FinalWin);
}
public OnMapStart()
{
	GetCurrentMap(current_map, 24);
}
public Action:Event_FinalWin(Handle:event, const String:name[], bool:dontBroadcast)
{
	CreateTimer(65.0, ChangeCampaign, _, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(15.0, AnnounceNextCampaign, _, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(30.0, AnnounceNextCampaign, _, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(45.0, AnnounceNextCampaign, _, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(60.0, AnnounceNextCampaign, _, TIMER_FLAG_NO_MAPCHANGE);
}
public Action:ChangeCampaign(Handle:timer)
{
	if (StrEqual(current_map, "c1m4_atrium", false))
	{
		ServerCommand("changelevel c6m1_riverbank");
	}
	else if (StrEqual(current_map, "c6m3_port", false))
	{
		ServerCommand("changelevel c2m1_highway");
	}
	else if (StrEqual(current_map, "c2m5_concert", false))
	{
		ServerCommand("changelevel c3m1_plankcountry");
	}
	else if (StrEqual(current_map, "c3m4_plantation", false))
	{
		ServerCommand("changelevel c4m1_milltown_a");
	}
	else if (StrEqual(current_map, "c4m5_milltown_escape", false))
	{
		ServerCommand("changelevel c5m1_waterfront");
	}
	else if (StrEqual(current_map, "c5m5_bridge", false))
	{
		ServerCommand("changelevel c8m1_apartment");
	}
	else if (StrEqual(current_map, "c8m5_rooftop", false))
	{
		ServerCommand("changelevel c9m1_alleys");
	}
	else if (StrEqual(current_map, "c9m2_lots", false))
	{
		ServerCommand("changelevel c10m1_caves");
	}
	else if (StrEqual(current_map, "c10m5_houseboat", false))
	{
		ServerCommand("changelevel c11m1_greenhouse");
	}
	else if (StrEqual(current_map, "c11m5_runway", false))
	{
		ServerCommand("changelevel c12m1_hilltop");
	}
	else if (StrEqual(current_map, "c12m5_cornfield", false))
	{
		ServerCommand("changelevel c7m1_docks");
	}
	else if (StrEqual(current_map, "c7m3_port", false))
	{
		ServerCommand("changelevel c13m1_alpinecreek");
	}
	else if (StrEqual(current_map, "c13m4_cutthroatcreek", false))
	{
		ServerCommand("changelevel c1m1_hotel");
	}
//Custom Campaigns
	else if (StrEqual(current_map, "cwm4_building", false))
	{
		ServerCommand("changelevel zmb13_m1_barracks");
	}
	else if (StrEqual(current_map, "zmb13_m3_surface", false))
	{
		ServerCommand("changelevel cdta_01detour");
	}
	else if (StrEqual(current_map, "cdta_05finalroad", false))
	{
		ServerCommand("changelevel p84m1_crash");
	}
	else if (StrEqual(current_map, "p84m4_precinct", false))
	{
		ServerCommand("changelevel uf1_boulevard");
	}
	else if (StrEqual(current_map, "uf4_airfield", false))
	{
		ServerCommand("changelevel l4d2_stadium1_apartment");
	}
	else if (StrEqual(current_map, "l4d2_stadium5_stadium", false))
	{
		ServerCommand("changelevel srocchurch");
	}
	else if (StrEqual(current_map, "mnac", false))
	{
		ServerCommand("changelevel l4d_yama_1");
	}
	else if (StrEqual(current_map, "l4d_yama_5", false))
	{
		ServerCommand("changelevel l4d_ihm01_forest");
	}
	else if (StrEqual(current_map, "l4d_ihm05_lakeside", false))
	{
		ServerCommand("changelevel l4d2_bts01_forest");
	}
	else if (StrEqual(current_map, "l4d2_bts06_school", false))
	{
		ServerCommand("changelevel cwm1_intro");
	}
}
public Action:AnnounceNextCampaign(Handle:timer)
{
	if (StrEqual(current_map, "c1m4_atrium", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03The Passing\x01");
	}
	else if (StrEqual(current_map, "c6m3_port", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Dark Carnival\x01");
	}
	else if (StrEqual(current_map, "c2m5_concert", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Swamp Fever\x01");
	}
	else if (StrEqual(current_map, "c3m4_plantation", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Hard Rain\x01");
	}
	else if (StrEqual(current_map, "c4m5_milltown_escape", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03The Parish\x01");
	}
	else if (StrEqual(current_map, "c5m5_bridge", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03No Mercy\x01");
	}
	else if (StrEqual(current_map, "c8m5_rooftop", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Crash Course\x01");
	}
	else if (StrEqual(current_map, "c9m2_lots", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Death Toll\x01");
	}
	else if (StrEqual(current_map, "c10m5_houseboat", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Dead Air\x01");
	}
	else if (StrEqual(current_map, "c11m5_runway", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Blood Harvest\x01");
	}
	else if (StrEqual(current_map, "c12m5_cornfield", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03The Sacrifice\x01");
	}
	else if (StrEqual(current_map, "c7m3_port", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Cold Stream\x01");
	}
	else if (StrEqual(current_map, "c13m4_cutthroatcreek", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Dead Center\x01");
	}
//Custom Campaigns
	else if (StrEqual(current_map, "cwm4_building", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03ZMB-13\x01");
	}
	else if (StrEqual(current_map, "zmb13_m3_surface", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Detour Ahead\x01");
	}
	else if (StrEqual(current_map, "cdta_05finalroad", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Precinct 84\x01");
	}
	else if (StrEqual(current_map, "p84m4_precinct", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Urban Flight\x01");
	}
	else if (StrEqual(current_map, "uf4_airfield", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Suicide Blitz 2\x01");
	}
	else if (StrEqual(current_map, "l4d2_stadium5_stadium", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Warcelona\x01");
	}
	else if (StrEqual(current_map, "mnac", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Yama\x01");
	}
	else if (StrEqual(current_map, "l4d_yama_5", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03I Hate Mountains 2\x01");
	}
	else if (StrEqual(current_map, "l4d_ihm05_lakeside", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Back to School\x01");
	}
	else if (StrEqual(current_map, "l4d2_bts06_school", false))
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 Campaign changer in effect. DO NOT VOTE SKIP! Next Campaign is: \x03Carried Off\x01");
	}
}