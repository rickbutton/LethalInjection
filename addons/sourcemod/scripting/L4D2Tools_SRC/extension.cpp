#include <string.h>

#include "extension.h"
#include "iplayerinfo.h"
#include "vglobals.h"
#include "util.h"
#include "convar_public.h"

#include <ISDKTools.h>

#include "codepatch/patchmanager.h"
#include "codepatch/autopatch.h"

#include "detours/spawn_special.h"
#include "detours/spawn_witch.h"
#include "detours/spawn_witchbride.h"
#include "detours/spawn_tank.h"
#include "detours/first_survivor_left_safe_area.h"
#include "detours/get_script_value_int.h"
#include "detours/get_script_value_float.h"
#include "detours/get_script_value_string.h"
#include "detours/on_enter_ghost_state.h"
#include "detours/try_offering_tank_bot.h"
#include "detours/mob_rush_start.h"
#include "detours/spawn_it_mob.h"
#include "detours/spawn_mob.h"
#include "detours/get_crouch_top_speed.h"
#include "detours/get_run_top_speed.h"
#include "detours/get_walk_top_speed.h"
#include "detours/has_configurable_difficulty.h"
#include "detours/cthrow_activate_ability.h"
#include "detours/start_melee_swing.h"
#include "detours/send_in_rescue_vehicle.h"
#include "detours/change_finale_stage.h"
#include "detours/select_sequence.h"
#include "detours/on_revived.h"
#include "detours/on_staggered.h"
#include "detours/on_healbegin.h"
#include "detours/use_healing_items.h"
#include "detours/find_scavenge_item.h"
#include "detours/witch_attack_update.h"
#include "detours/witch_kill_incap_victim.h"
#include "detours/witch_retreat.h"
#include "detours/infected_alert_update.h"
#include "detours/infected_attack_update.h"
#include "detours/smoker_attack_update.h"
#include "detours/boomer_attack_update.h"
#include "detours/hunter_attack_update.h"
#include "detours/spitter_attack_update.h"
#include "detours/jockey_attack_update.h"
#include "detours/charger_attack_update.h"
#include "detours/tank_attack_update.h"
#include "detours/survivor_use_object_update.h"

#define GAMECONFIG_FILE "l4d2addresses"

L4D2Tools g_L4D2Tools;		/**< Global singleton for extension's main interface */
IGameConfig *g_pGameConf = NULL;
IGameConfig *g_pGameConfSDKTools = NULL;
IBinTools *g_pBinTools = NULL;
IServer *g_pServer = NULL; //ptr to CBaseServer
ISDKTools *g_pSDKTools = NULL;
IServerGameEnts *gameents = NULL;
CGlobalVars *gpGlobals;

IForward *g_pFwdOnSpawnSpecial = NULL;
IForward *g_pFwdOnSpawnTank = NULL;
IForward *g_pFwdOnSpawnWitch = NULL;
IForward *g_pFwdOnSpawnWitchBride = NULL;
IForward *g_pFwdOnFirstSurvivorLeftSafeArea = NULL;
IForward *g_pFwdOnGetScriptValueInt = NULL;
IForward *g_pFwdOnGetScriptValueFloat = NULL;
IForward *g_pFwdOnGetScriptValueString = NULL;
IForward *g_pFwdOnTryOfferingTankBot = NULL;
IForward *g_pFwdOnMobRushStart = NULL;
IForward *g_pFwdOnSpawnITMob = NULL;
IForward *g_pFwdOnSpawnMob = NULL;
IForward *g_pFwdOnGetCrouchTopSpeed = NULL;
IForward *g_pFwdOnGetRunTopSpeed = NULL;
IForward *g_pFwdOnGetWalkTopSpeed = NULL;
IForward *g_pFwdOnHasConfigurableDifficulty = NULL;
IForward *g_pFwdOnCThrowActivate = NULL;
IForward *g_pFwdOnStartMeleeSwing = NULL;
IForward *g_pFwdOnSendInRescueVehicle = NULL;
IForward *g_pFwdOnChangeFinaleStage = NULL;
IForward *g_pFwdOnSelectSequence = NULL;
IForward *g_pFwdOnRevived = NULL;
IForward *g_pFwdOnPlayerStagger = NULL;
IForward *g_pFwdOnHealBegin = NULL;
IForward *g_pFwdOnUseHealingItems = NULL;
IForward *g_pFwdOnUseHealingItemsPost = NULL;
IForward *g_pFwdOnFindScavengeItem = NULL;
IForward *g_pFwdOnWitchAttackUpdate = NULL;
IForward *g_pFwdOnWitchKillIncapVictim = NULL;
IForward *g_pFwdOnWitchRetreat = NULL;
IForward *g_pFwdOnInfectedAlertUpdate = NULL;
IForward *g_pFwdOnInfectedAttackUpdate = NULL;
IForward *g_pFwdOnSmokerAttackUpdate = NULL;
IForward *g_pFwdOnBoomerAttackUpdate = NULL;
IForward *g_pFwdOnHunterAttackUpdate = NULL;
IForward *g_pFwdOnSpitterAttackUpdate = NULL;
IForward *g_pFwdOnJockeyAttackUpdate = NULL;
IForward *g_pFwdOnChargerAttackUpdate = NULL;
IForward *g_pFwdOnTankAttackUpdate = NULL;
IForward *g_pFwdOnSurvivorUseObjectUpdate = NULL;

ICvar *icvar = NULL;
SMEXT_LINK(&g_L4D2Tools);

extern sp_nativeinfo_t g_L4DoNatives[];
extern sp_nativeinfo_t g_L4DoTimerNatives[];

ConVar g_Version("L4D2Tools_version", SMEXT_CONF_VERSION, FCVAR_SPONLY|FCVAR_NOTIFY, "L4D2Tools Extension Version");
PatchManager g_PatchManager;

/**
 * @file extension.cpp
 * @brief Implement extension code here.
 */

bool L4D2Tools::SDK_OnLoad(char *error, size_t maxlength, bool late)
{
	//only load extension for l4d2
	if (strcmp(g_pSM->GetGameFolderName(), "left4dead2") != 0)
	{
		UTIL_Format(error, maxlength, "Cannot Load L4D2Tools Ext on mods other than L4D2");
		return false;
	}


	//load sigscans and offsets, etc from our gamedata file
	char conf_error[255] = "";
	if (!gameconfs->LoadGameConfigFile(GAMECONFIG_FILE, &g_pGameConf, conf_error, sizeof(conf_error)))
	{
		if (conf_error[0])
		{
			UTIL_Format(error, maxlength, "Could not read " GAMECONFIG_FILE ".txt: %s", conf_error);
		}
		return false;
	}

	//load sigscans and offsets from the sdktools gamedata file
	if (!gameconfs->LoadGameConfigFile("sdktools.games", &g_pGameConfSDKTools, conf_error, sizeof(conf_error)))
	{
		return false;
	}
	sharesys->AddDependency(myself, "bintools.ext", true, true);
	sharesys->RegisterLibrary(myself, "L4D2Tools");
	sharesys->AddNatives(myself, g_L4DoNatives);
	sharesys->AddNatives(myself, g_L4DoTimerNatives);

	g_pFwdOnSpawnSpecial = forwards->CreateForward("L4D2_OnSpawnSpecial", ET_Event, 3, /*types*/NULL, Param_CellByRef, Param_Array, Param_Array);
	g_pFwdOnSpawnTank = forwards->CreateForward("L4D2_OnSpawnTank", ET_Event, 2, /*types*/NULL, Param_Array, Param_Array);
	g_pFwdOnSpawnWitch = forwards->CreateForward("L4D2_OnSpawnWitch", ET_Event, 2, /*types*/NULL, Param_Array, Param_Array);
	g_pFwdOnSpawnWitchBride = forwards->CreateForward("L4D2_OnSpawnWitchBride", ET_Event, 2, /*types*/NULL, Param_Array, Param_Array);
	g_pFwdOnFirstSurvivorLeftSafeArea = forwards->CreateForward("L4D2_OnFirstSurvivorLeftSafeArea", ET_Event, 1, /*types*/NULL, Param_Cell);
	g_pFwdOnGetScriptValueInt = forwards->CreateForward("L4D2_OnGetScriptValueInt", ET_Event, 2, /*types*/NULL, Param_String, Param_CellByRef);
	g_pFwdOnGetScriptValueFloat = forwards->CreateForward("L4D2_OnGetScriptValueFloat", ET_Event, 2, /*types*/NULL, Param_String, Param_FloatByRef);
	g_pFwdOnGetScriptValueString = forwards->CreateForward("L4D2_OnGetScriptValueString", ET_Event, 4, /*types*/NULL, Param_String, Param_String, Param_String, Param_CellByRef);
	g_pFwdOnTryOfferingTankBot = forwards->CreateForward("L4D2_OnTryOfferingTankBot", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnMobRushStart = forwards->CreateForward("L4D2_OnMobRushStart", ET_Event, 0, /*types*/NULL);
	g_pFwdOnSpawnITMob = forwards->CreateForward("L4D2_OnSpawnITMob", ET_Event, 1, /*types*/NULL, Param_CellByRef);
	g_pFwdOnSpawnMob = forwards->CreateForward("L4D2_OnSpawnMob", ET_Event, 1, /*types*/NULL, Param_CellByRef);
	g_pFwdOnGetCrouchTopSpeed = forwards->CreateForward("L4D2_OnGetCrouchTopSpeed", ET_Event, 2, /*types*/NULL, Param_Cell, Param_FloatByRef);
	g_pFwdOnGetRunTopSpeed = forwards->CreateForward("L4D2_OnGetRunTopSpeed", ET_Event, 2, /*types*/NULL, Param_Cell, Param_FloatByRef);
	g_pFwdOnGetWalkTopSpeed = forwards->CreateForward("L4D2_OnGetWalkTopSpeed", ET_Event, 2, /*types*/NULL, Param_Cell, Param_FloatByRef);
	g_pFwdOnHasConfigurableDifficulty = forwards->CreateForward("L4D2_OnHasConfigurableDifficulty", ET_Event, 1, /*types*/NULL, Param_CellByRef);
	g_pFwdOnCThrowActivate = forwards->CreateForward("L4D2_OnCThrowActivate", ET_Event, 1, /*types*/NULL, Param_Cell);
	g_pFwdOnStartMeleeSwing = forwards->CreateForward("L4D2_OnStartMeleeSwing", ET_Event, 2, /*types*/NULL, Param_Cell, Param_Cell);
	g_pFwdOnSendInRescueVehicle = forwards->CreateForward("L4D2_OnSendInRescueVehicle", ET_Event, 0, /*types*/NULL);
	g_pFwdOnChangeFinaleStage = forwards->CreateForward("L4D2_OnChangeFinaleStage", ET_Event, 2, /*types*/NULL, Param_CellByRef, Param_String);
	g_pFwdOnSelectSequence = forwards->CreateForward("L4D2_OnSelectSequence", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnRevived = forwards->CreateForward("L4D2_OnRevived", ET_Event, 1, /*types*/NULL, Param_Cell);
	g_pFwdOnPlayerStagger = forwards->CreateForward("L4D2_OnStagger", ET_Event, 2, /*types*/NULL, Param_Cell, Param_Cell);
	g_pFwdOnHealBegin = forwards->CreateForward("L4D2_OnHealBegin", ET_Event, 2, /*types*/NULL, Param_Cell, Param_Cell);
	g_pFwdOnUseHealingItems = forwards->CreateForward("L4D2_OnUseHealingItems", ET_Event, 1, /*types*/NULL, Param_Cell);
	g_pFwdOnUseHealingItemsPost = forwards->CreateForward("L4D2_OnUseHealingItemsPost", ET_Event, 3, /*types*/NULL, Param_Cell, Param_Cell, Param_String);
	g_pFwdOnFindScavengeItem = forwards->CreateForward("L4D2_OnFindScavengeItem", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnWitchAttackUpdate = forwards->CreateForward("L4D2_OnWitchAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnWitchKillIncapVictim = forwards->CreateForward("L4D2_OnWitchKillIncapVictim", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnWitchRetreat = forwards->CreateForward("L4D2_OnWitchRetreat", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnInfectedAlertUpdate = forwards->CreateForward("L4D2_OnInfectedAlertUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnInfectedAttackUpdate = forwards->CreateForward("L4D2_OnInfectedAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnSmokerAttackUpdate = forwards->CreateForward("L4D2_OnSmokerAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnBoomerAttackUpdate = forwards->CreateForward("L4D2_OnBoomerAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnHunterAttackUpdate = forwards->CreateForward("L4D2_OnHunterAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnSpitterAttackUpdate = forwards->CreateForward("L4D2_OnSpitterAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnJockeyAttackUpdate = forwards->CreateForward("L4D2_OnJockeyAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnChargerAttackUpdate = forwards->CreateForward("L4D2_OnChargerAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnTankAttackUpdate = forwards->CreateForward("L4D2_OnTankAttackUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	g_pFwdOnSurvivorUseObjectUpdate = forwards->CreateForward("L4D2_OnSurvivorUseObjectUpdate", ET_Event, 2, /*types*/NULL, Param_Cell, Param_CellByRef);
	
	playerhelpers->AddClientListener(&g_L4D2Tools);
	playerhelpers->RegisterCommandTargetProcessor(&g_L4D2Tools);

	Detour::Init(g_pSM->GetScriptingEngine(), g_pGameConf);

	return true;
}

void L4D2Tools::SDK_OnAllLoaded()
{
	SM_GET_LATE_IFACE(BINTOOLS, g_pBinTools);
	SM_GET_LATE_IFACE(SDKTOOLS, g_pSDKTools);

	if (!g_pBinTools || !g_pSDKTools)
	{
		L4D_DEBUG_LOG("Failed to load bintools or failed to load sdktools");
		return;
	}

	IServer *server = g_pSDKTools->GetIServer();
	L4D_DEBUG_LOG("Address of IServer is %p", server);
	//reading out server->GetName() we consistently seem to get (the same?) 
	//garbage characters. this is possibly causing a crash on windows servers
	//when a player connects. so lets not read the server name :(
	//L4D_DEBUG_LOG("Server name is %s", server->GetName());
	g_pServer = server;

	InitializeValveGlobals();
	/*
	detour the witch/spawn spawns
	*/
	//automatically will unregister/cleanup themselves when the ext is unloaded

	g_PatchManager.Register(new AutoPatch<Detours::SpawnSpecial>());
	g_PatchManager.Register(new AutoPatch<Detours::SpawnTank>());
	g_PatchManager.Register(new AutoPatch<Detours::SpawnWitch>());
	g_PatchManager.Register(new AutoPatch<Detours::SpawnWitchBride>());
	g_PatchManager.Register(new AutoPatch<Detours::FirstSurvivorLeftSafeArea>());
	g_PatchManager.Register(new AutoPatch<Detours::GetScriptValueInt>());
	g_PatchManager.Register(new AutoPatch<Detours::GetScriptValueFloat>());
	g_PatchManager.Register(new AutoPatch<Detours::GetScriptValueString>());
	g_PatchManager.Register(new AutoPatch<Detours::TryOfferingTankBot>());
	g_PatchManager.Register(new AutoPatch<Detours::MobRushStart>());
	g_PatchManager.Register(new AutoPatch<Detours::SpawnITMob>());
	g_PatchManager.Register(new AutoPatch<Detours::SpawnMob>());
	g_PatchManager.Register(new AutoPatch<Detours::GetCrouchTopSpeed>());
	g_PatchManager.Register(new AutoPatch<Detours::GetRunTopSpeed>());
	g_PatchManager.Register(new AutoPatch<Detours::GetWalkTopSpeed>());
	g_PatchManager.Register(new AutoPatch<Detours::HasConfigurableDifficulty>());
	g_PatchManager.Register(new AutoPatch<Detours::CThrowActivate>());
	g_PatchManager.Register(new AutoPatch<Detours::StartMeleeSwing>());
	g_PatchManager.Register(new AutoPatch<Detours::SendInRescueVehicle>());
	g_PatchManager.Register(new AutoPatch<Detours::ChangeFinaleStage>());
	g_PatchManager.Register(new AutoPatch<Detours::SelectSequence>());//for SelectTankAttack
	g_PatchManager.Register(new AutoPatch<Detours::Revived>());
	g_PatchManager.Register(new AutoPatch<Detours::PlayerStagger>());
	g_PatchManager.Register(new AutoPatch<Detours::HealBegin>());
	g_PatchManager.Register(new AutoPatch<Detours::UseHealingItems>());
	g_PatchManager.Register(new AutoPatch<Detours::FindScavengeItem>());
	g_PatchManager.Register(new AutoPatch<Detours::WitchAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::WitchKillIncapVictim>());
	g_PatchManager.Register(new AutoPatch<Detours::WitchRetreat>());
	g_PatchManager.Register(new AutoPatch<Detours::InfectedAlertUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::InfectedAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::SmokerAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::BoomerAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::HunterAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::SpitterAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::JockeyAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::ChargerAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::TankAttackUpdate>());
	g_PatchManager.Register(new AutoPatch<Detours::SurvivorUseObjectUpdate>());

	//new style detours that create/destroy the forwards themselves
	g_PatchManager.Register(new AutoPatch<Detours::OnEnterGhostState>());
}

void L4D2Tools::SDK_OnUnload()
{
	gameconfs->CloseGameConfigFile(g_pGameConf);
	gameconfs->CloseGameConfigFile(g_pGameConfSDKTools);

	playerhelpers->RemoveClientListener(&g_L4D2Tools);
	playerhelpers->UnregisterCommandTargetProcessor(&g_L4D2Tools);
	g_PatchManager.UnregisterAll();

	forwards->ReleaseForward(g_pFwdOnSpawnSpecial);
	forwards->ReleaseForward(g_pFwdOnSpawnTank);
	forwards->ReleaseForward(g_pFwdOnSpawnWitch);
	forwards->ReleaseForward(g_pFwdOnSpawnWitchBride);

	forwards->ReleaseForward(g_pFwdOnFirstSurvivorLeftSafeArea);
	forwards->ReleaseForward(g_pFwdOnGetScriptValueInt);
	forwards->ReleaseForward(g_pFwdOnGetScriptValueFloat);
	forwards->ReleaseForward(g_pFwdOnGetScriptValueString);
	forwards->ReleaseForward(g_pFwdOnTryOfferingTankBot);
	forwards->ReleaseForward(g_pFwdOnMobRushStart);
	forwards->ReleaseForward(g_pFwdOnSpawnITMob);
	forwards->ReleaseForward(g_pFwdOnSpawnMob);
	forwards->ReleaseForward(g_pFwdOnGetCrouchTopSpeed);
	forwards->ReleaseForward(g_pFwdOnGetRunTopSpeed);
	forwards->ReleaseForward(g_pFwdOnGetWalkTopSpeed);
	forwards->ReleaseForward(g_pFwdOnHasConfigurableDifficulty);
	forwards->ReleaseForward(g_pFwdOnCThrowActivate);
	forwards->ReleaseForward(g_pFwdOnStartMeleeSwing);
	forwards->ReleaseForward(g_pFwdOnSendInRescueVehicle);
	forwards->ReleaseForward(g_pFwdOnChangeFinaleStage);
	forwards->ReleaseForward(g_pFwdOnSelectSequence);
	forwards->ReleaseForward(g_pFwdOnRevived);
	forwards->ReleaseForward(g_pFwdOnPlayerStagger);
	forwards->ReleaseForward(g_pFwdOnHealBegin);
	forwards->ReleaseForward(g_pFwdOnUseHealingItems);
	forwards->ReleaseForward(g_pFwdOnUseHealingItemsPost);
	forwards->ReleaseForward(g_pFwdOnFindScavengeItem);
	forwards->ReleaseForward(g_pFwdOnWitchAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnWitchKillIncapVictim);
	forwards->ReleaseForward(g_pFwdOnWitchRetreat);
	forwards->ReleaseForward(g_pFwdOnInfectedAlertUpdate);
	forwards->ReleaseForward(g_pFwdOnInfectedAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnSmokerAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnBoomerAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnHunterAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnSpitterAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnJockeyAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnChargerAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnTankAttackUpdate);
	forwards->ReleaseForward(g_pFwdOnSurvivorUseObjectUpdate);
}

class BaseAccessor : public IConCommandBaseAccessor
{
public:
	bool RegisterConCommandBase(ConCommandBase *pCommandBase)
	{
		/* Always call META_REGCVAR instead of going through the engine. */
		return META_REGCVAR(pCommandBase);
	}
} s_BaseAccessor;


bool L4D2Tools::SDK_OnMetamodLoad(SourceMM::ISmmAPI *ismm, char *error, size_t maxlen, bool late)
{
	GET_V_IFACE_CURRENT(GetEngineFactory, icvar, ICvar, CVAR_INTERFACE_VERSION);

	g_pCVar = icvar;
	ConVar_Register(0, &s_BaseAccessor);

	GET_V_IFACE_ANY(GetServerFactory, gameents, IServerGameEnts, INTERFACEVERSION_SERVERGAMEENTS);
	gpGlobals = ismm->GetCGlobals();

	return true;
}

bool L4D2Tools::ProcessCommandTarget(cmd_target_info_t *info)
{
	int max_clients;
	IPlayerInfo *pInfo;
	unsigned int team_index = 0;
	IGamePlayer *pPlayer, *pAdmin;

	if ((info->flags & COMMAND_FILTER_NO_MULTI) == COMMAND_FILTER_NO_MULTI)
	{
		return false;
	}

	if (info->admin)
	{
		if ((pAdmin = playerhelpers->GetGamePlayer(info->admin)) == NULL)
		{
			return false;
		}
		if (!pAdmin->IsInGame())
		{
			return false;
		}
	}
	else
	{
		pAdmin = NULL;
	}

	if (strcmp(info->pattern, "@survivors") == 0 )
	{
		team_index = 2;
	}
	else if (strcmp(info->pattern, "@infected") == 0)
	{
		team_index = 3;
	}
	else
	{
		return false;
	}

	info->num_targets = 0;

	max_clients = playerhelpers->GetMaxClients();
	for (int i = 1; 
		 i <= max_clients && (cell_t)info->num_targets < info->max_targets; 
		 i++)
	{
		if ((pPlayer = playerhelpers->GetGamePlayer(i)) == NULL)
		{
			continue;
		}
		if (!pPlayer->IsInGame())
		{
			continue;
		}
		if ((pInfo = pPlayer->GetPlayerInfo()) == NULL)
		{
			continue;
		}
		if (pInfo->GetTeamIndex() != (int)team_index)
		{
			continue;
		}
		if (playerhelpers->FilterCommandTarget(pAdmin, pPlayer, info->flags) 
			!= COMMAND_TARGET_VALID)
		{
			continue;
		}
		info->targets[info->num_targets] = i;
		info->num_targets++;
	}

	if (info->num_targets == 0)
	{
		info->reason = COMMAND_TARGET_EMPTY_FILTER;
	}
	else
	{
		info->reason = COMMAND_TARGET_VALID;
	}

	info->target_name_style = COMMAND_TARGETNAME_RAW;
	if (team_index == 2)
	{
		UTIL_Format(info->target_name, info->target_name_maxlength, "Survivors");
	}
	else if (team_index == 3)
	{
		UTIL_Format(info->target_name, info->target_name_maxlength, "Infected");
	}

	return true;
}
