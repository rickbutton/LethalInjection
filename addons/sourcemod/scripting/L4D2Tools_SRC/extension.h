#ifndef _INCLUDE_SOURCEMOD_EXTENSION_PROPER_H_
#define _INCLUDE_SOURCEMOD_EXTENSION_PROPER_H_
//#define L4D_DEBUG

#ifdef L4D_DEBUG
#define L4D_DEBUG_LOG(...) g_pSM->LogMessage(myself, __VA_ARGS__)
#else
#define L4D_DEBUG_LOG(...)
#endif

#include "smsdk_ext.h"
#include <IBinTools.h>
#include <iserver.h>
#include <convar.h>
#include <icvar.h>
#include <icommandline.h>

class L4D2Tools :
	public SDKExtension,
	public IClientListener,
	public ICommandTargetProcessor
{
public:
	/**
	 * @brief This is called after the initial loading sequence has been processed.
	 *
	 * @param error		Error message buffer.
	 * @param maxlength	Size of error message buffer.
	 * @param late		Whether or not the module was loaded after map load.
	 * @return			True to succeed loading, false to fail.
	 */
	virtual bool SDK_OnLoad(char *error, size_t maxlength, bool late);
	
	/**
	 * @brief This is called right before the extension is unloaded.
	 */
	virtual void SDK_OnUnload();

	/**
	 * @brief This is called once all known extensions have been loaded.
	 * Note: It is is a good idea to add natives here, if any are provided.
	 */
	virtual void SDK_OnAllLoaded();

	/**
	 * @brief Called when the pause state is changed.
	 */
	//virtual void SDK_OnPauseChange(bool paused);

	/**
	 * @brief this is called when Core wants to know if your extension is working.
	 *
	 * @param error		Error message buffer.
	 * @param maxlength	Size of error message buffer.
	 * @return			True if working, false otherwise.
	 */
	//virtual bool QueryRunning(char *error, size_t maxlength);
public:
	/**
	 * @brief Called when Metamod is attached, before the extension version is called.
	 *
	 * @param error			Error buffer.
	 * @param maxlength		Maximum size of error buffer.
	 * @param late			Whether or not Metamod considers this a late load.
	 * @return				True to succeed, false to fail.
	 */
	virtual bool SDK_OnMetamodLoad(ISmmAPI *ismm, char *error, size_t maxlength, bool late);

public: //ICommandTargetProcessor
	bool ProcessCommandTarget(cmd_target_info_t *info);
};

extern IForward *g_pFwdOnSpawnSpecial;
extern IForward *g_pFwdOnSpawnTank;
extern IForward *g_pFwdOnSpawnWitch;
extern IForward *g_pFwdOnSpawnWitchBride;
extern IForward *g_pFwdOnFirstSurvivorLeftSafeArea;
extern IForward *g_pFwdOnGetScriptValueInt;
extern IForward *g_pFwdOnGetScriptValueFloat;
extern IForward *g_pFwdOnGetScriptValueString;
extern IForward *g_pFwdOnTryOfferingTankBot;
extern IForward *g_pFwdOnMobRushStart;
extern IForward *g_pFwdOnSpawnITMob;
extern IForward *g_pFwdOnSpawnMob;
extern IForward *g_pFwdOnGetCrouchTopSpeed;
extern IForward *g_pFwdOnGetRunTopSpeed;
extern IForward *g_pFwdOnGetWalkTopSpeed;
extern IForward *g_pFwdOnHasConfigurableDifficulty;
extern IForward *g_pFwdOnCThrowActivate;
extern IForward *g_pFwdOnStartMeleeSwing;
extern IForward *g_pFwdOnSendInRescueVehicle;
extern IForward *g_pFwdOnChangeFinaleStage;
extern IForward *g_pFwdOnSelectSequence;
extern IForward *g_pFwdOnRevived;
extern IForward *g_pFwdOnPlayerStagger;
extern IForward *g_pFwdOnHealBegin;
extern IForward *g_pFwdOnUseHealingItems;
extern IForward *g_pFwdOnUseHealingItemsPost;
extern IForward *g_pFwdOnFindScavengeItem;
extern IForward *g_pFwdOnWitchAttackUpdate;
extern IForward *g_pFwdOnWitchKillIncapVictim;
extern IForward *g_pFwdOnWitchRetreat;
extern IForward *g_pFwdOnInfectedAlertUpdate;
extern IForward *g_pFwdOnInfectedAttackUpdate;
extern IForward *g_pFwdOnSmokerAttackUpdate;
extern IForward *g_pFwdOnBoomerAttackUpdate;
extern IForward *g_pFwdOnHunterAttackUpdate;
extern IForward *g_pFwdOnSpitterAttackUpdate;
extern IForward *g_pFwdOnJockeyAttackUpdate;
extern IForward *g_pFwdOnChargerAttackUpdate;
extern IForward *g_pFwdOnTankAttackUpdate;
extern IForward *g_pFwdOnSurvivorUseObjectUpdate;

extern IBinTools *g_pBinTools;
extern IServer *g_pServer; //pointer to CBaseServer
extern IGameConfig *g_pGameConf;
extern IGameConfig *g_pGameConfSDKTools;

/* Interfaces from engine or gamedll */
extern IServerGameEnts *gameents;
extern ICvar *icvar;
extern IServer *iserver;
extern CGlobalVars *gpGlobals;
/* Interfaces from SourceMod */

#include "compat_wrappers.h"

#endif
