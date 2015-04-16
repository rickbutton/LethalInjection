#include "extension.h"
#include "vglobals.h"
#include "util.h"
#include "l4d2sdk/constants.h"

// native L4D_RestartScenarioFromVote(const String:map[])
cell_t L4D2_RestartScenarioFromVote(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	// Director::RestartScenario()
	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("RestartScenarioFromVote", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(char *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, /*returnInfo*/NULL, pass, /*numparams*/1));
	}

	void *addr;
	if (!g_pGameConf->GetMemSig("RestartScenarioFromVote", (void **)&addr) || !addr)
	{
		return pContext->ThrowNativeError( "Could not read RestartScenarioFromVote from GameConf");
	}

	/* Get the Director pointer */
	if (g_pDirector == NULL)
	{
		return pContext->ThrowNativeError("Director unsupported or not available; file a bug report");
	}

	CDirector *director = *g_pDirector;

	if (director == NULL)
	{
		return pContext->ThrowNativeError("Director not available before map is loaded");
	}
	L4D_DEBUG_LOG("Director pointer calculated to be 0x%x", director);

	char *map = NULL;
	pContext->LocalToString(params[1], &map);

	/* Build the vcall argument stack */
	unsigned char vstk[sizeof(void *) + sizeof(char *)];
	unsigned char *vptr = vstk;

	*(void **)vptr = director;
	vptr += sizeof(void *);
	*(char **)vptr = map;
	//vptr += sizeof(char *);
	pWrapper->Execute(vstk, /*retbuffer*/NULL);

	return 1;
}

cell_t L4D2_IsMissionFinalMap(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;
	
	if(!pWrapper)
	{
		PassInfo retInfo; 
		retInfo.flags = PASSFLAG_BYVAL; 
		retInfo.size = sizeof(bool);  //ret value in al on windows, eax on linux
		retInfo.type = PassType_Basic;
		REGISTER_NATIVE_ADDR("IsMissionFinalMap", 
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_Cdecl, \
							/*retInfo*/&retInfo, /*paramInfo*/NULL, /*numparams*/0));

		L4D_DEBUG_LOG("Built call wrapper CTerrorGameRules::IsMissionFinalMap");
	}
	
	cell_t retbuffer = 0;
	
	L4D_DEBUG_LOG("Going to execute CTerrorGameRules::IsMissionFinalMap");
	pWrapper->Execute(NULL, &retbuffer);
	
	L4D_DEBUG_LOG("Invoked CTerrorGameRules::IsMissionFinalMap, got back = %d", retbuffer);
	
	return retbuffer;
}


// CDirector::ResetMobTimer()
// native L4D_ResetMobTimer()
cell_t L4D2_ResetMobTimer(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	// CDirector::ResetMobTimer()
	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("ResetMobTimer", 
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, /*returnInfo*/NULL, /*Pass*/NULL, /*numparams*/0));
	}
	
	if (g_pDirector == NULL)
	{
		return pContext->ThrowNativeError("Director unsupported or not available; file a bug report");
	}

	void *director = *g_pDirector;

	if (director == NULL)
	{
		return pContext->ThrowNativeError("Director not available before map is loaded");
	}
	
	/* Build the vcall argument stack */
	unsigned char vstk[sizeof(void *)];
	unsigned char *vptr = vstk;

	*(void **)vptr = director;
	pWrapper->Execute(vstk, /*retbuffer*/NULL);
	
	return 0;
}

// CTerrorPlayer::OnStaggered(CBaseEntity*, Vector*);
// native L4D_StaggerPlayer(target, source_ent, Float:source_vector[3])
cell_t L4D2_StaggerPlayer(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	// CBasePlayer::OnStaggered(CBaseEntity*, Vector*);
	if (!pWrapper)
	{

		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnStaggered", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(Vector *); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, /*returnInfo*/NULL, pass, /*numparams*/2));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnStaggered: Invalid target entity");		
	}
	
	int source_ent = params[2];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, false);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnStaggered: Invalid source entity");
	}
	
	cell_t * source_vector;
	pContext->LocalToPhysAddr(params[3], &source_vector);
	
	Vector vSourceVector;
	Vector *pSourceVector = NULL;
	
	if(source_vector != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		vSourceVector[0] = sp_ctof(source_vector[0]);
		vSourceVector[1] = sp_ctof(source_vector[1]);
		vSourceVector[2] = sp_ctof(source_vector[2]);
		pSourceVector = &vSourceVector;
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *) + sizeof(Vector *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);
	*(Vector **)vptr = pSourceVector;

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnStaggered");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnStaggered");
	
	return 0;
}

cell_t L4D2_ShoveInfectedPlayer(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	// CBasePlayer::OnStaggered(CBaseEntity*, Vector*);
	if (!pWrapper)
	{

		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnShovedBySurvivor", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(Vector *); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, /*returnInfo*/NULL, pass, /*numparams*/2));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnShovedBySurvivor: Invalid target entity");		
	}
	
	int source_ent = params[2];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, false);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnShovedBySurvivor: Invalid source entity");
	}
	
	cell_t * source_vector;
	pContext->LocalToPhysAddr(params[3], &source_vector);
	
	Vector vSourceVector;
	Vector *pSourceVector = NULL;
	
	if(source_vector != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		vSourceVector[0] = sp_ctof(source_vector[0]);
		vSourceVector[1] = sp_ctof(source_vector[1]);
		vSourceVector[2] = sp_ctof(source_vector[2]);
		pSourceVector = &vSourceVector;
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *) + sizeof(Vector *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);
	*(Vector **)vptr = pSourceVector;

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnShovedBySurvivor");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnShovedBySurvivor");
	
	return 0;
}

// CDirectorScriptedEventManager::SendInRescueVehicle(void)
// L4D2_SendInRescueVehicle()
cell_t L4D2_SendInRescueVehicle(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("SendInRescueVehicle", 
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, /*returnInfo*/NULL, /*Pass*/NULL, /*numparams*/0));
	}
	
	if (g_pDirector == NULL)
	{
		return pContext->ThrowNativeError("Director unsupported or not available; file a bug report");
	}

	void *scriptedeventmanager = (*g_pDirector)->ScriptedEventManagerPtr;

	if (scriptedeventmanager == NULL)
	{
		return pContext->ThrowNativeError("DirectorScriptedEventManager pointer is NULL");
	}
	
	/* Build the vcall argument stack */
	unsigned char vstk[sizeof(void *)];
	unsigned char *vptr = vstk;

	*(void **)vptr = scriptedeventmanager;
	pWrapper->Execute(vstk, /*retbuffer*/NULL);
	
	return 0;
}

// CDirectorScriptedEventManager::ChangeFinaleStage(CDirectorScriptedEventManager::FinaleStageType,char  const*)
// L4D2_ChangeFinaleStage(finaleType, String:input)
cell_t L4D2_ChangeFinaleStage(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("ChangeFinaleStage", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(int); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(char *); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, /*returnInfo*/NULL, /*Pass*/pass, /*numparams*/2));
	}
	
	if (g_pDirector == NULL)
	{
		return pContext->ThrowNativeError("Director unsupported or not available; file a bug report");
	}

	void *scriptedeventmanager = (*g_pDirector)->ScriptedEventManagerPtr;

	if (scriptedeventmanager == NULL)
	{
		return pContext->ThrowNativeError("DirectorScriptedEventManager pointer is NULL");
	}
	
	/* Build the vcall argument stack */
	unsigned char vstk[sizeof(void *) + sizeof(int) + sizeof(char *)];
	unsigned char *vptr = vstk;

	*(void **)vptr = scriptedeventmanager;
	vptr += sizeof(CDirectorScriptedEventManager *);
	
	*(int *)vptr = params[1];
	vptr += sizeof(int *);

	char *arg = NULL;
	pContext->LocalToString(params[2], &arg);
	*(char **)vptr = arg;

	pWrapper->Execute(vstk, /*retbuffer*/NULL);
	
	return 0;
}

cell_t L4D2_SpawnSpecial(IPluginContext *pContext, const cell_t *params)
{
	if (g_pZombieManager == NULL)
	{
		return pContext->ThrowNativeError("ZombieManager unsupported or not available; file a bug report");
	}

	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		PassInfo passInfo;
		passInfo.flags = PASSFLAG_BYVAL;
		passInfo.size = sizeof( CBaseEntity* );
		passInfo.type = PassType_Basic;

		REGISTER_NATIVE_ADDR("SpawnSpecial", 
			PassInfo pass[3]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(ZombieClassType); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(Vector*); \
			pass[1].type = PassType_Basic; \
			pass[2].flags = PASSFLAG_BYVAL; \
			pass[2].size = sizeof(QAngle*); \
			pass[2].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, &passInfo, pass, 3));
	}

	CBaseEntity* entity;
	
	unsigned char vstk[ sizeof(void*) + sizeof(ZombieClassType) + sizeof(Vector*) + sizeof(QAngle*) ];
	unsigned char *vptr = vstk;
	
	cell_t* source_vector;
	pContext->LocalToPhysAddr(params[2], &source_vector);

	cell_t* source_qangle;
	pContext->LocalToPhysAddr(params[3], &source_qangle);

	Vector vector;
	QAngle qangle;

	if(source_vector != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		vector[0] = sp_ctof(source_vector[0]);
		vector[1] = sp_ctof(source_vector[1]);
		vector[2] = sp_ctof(source_vector[2]);
	}
	if(source_qangle != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		qangle[0] = sp_ctof(source_qangle[0]);
		qangle[1] = sp_ctof(source_qangle[1]);
		qangle[2] = sp_ctof(source_qangle[2]);
	}

	*(void**)vptr = g_pZombieManager;
	vptr += sizeof(void*);
	
	*(cell_t*)vptr = params[1];
	vptr += sizeof(ZombieClassType);

	*(Vector**)vptr = &vector;
	vptr += sizeof(Vector*);

	*(QAngle**)vptr = &qangle;
	vptr += sizeof(QAngle*);

	pWrapper->Execute( vstk, (void*) &entity );
	return gamehelpers->EntityToBCompatRef( entity );
}

cell_t L4D2_SpawnTank(IPluginContext *pContext, const cell_t *params)
{
	if (g_pZombieManager == NULL)
	{
		return pContext->ThrowNativeError("ZombieManager unsupported or not available; file a bug report");
	}

	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		PassInfo passInfo;
		passInfo.flags = PASSFLAG_BYVAL;
		passInfo.size = sizeof( CBaseEntity* );
		passInfo.type = PassType_Basic;

		REGISTER_NATIVE_ADDR("SpawnTank", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(Vector*); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(QAngle*); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, &passInfo, pass, 2));
	}

	CBaseEntity* entity;
	
	unsigned char vstk[ sizeof(void*) + sizeof(Vector*) + sizeof(QAngle*) ];
	unsigned char *vptr = vstk;
	
	cell_t* source_vector;
	pContext->LocalToPhysAddr(params[1], &source_vector);

	cell_t* source_qangle;
	pContext->LocalToPhysAddr(params[2], &source_qangle);

	Vector vector;
	QAngle qangle;

	if(source_vector != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		vector[0] = sp_ctof(source_vector[0]);
		vector[1] = sp_ctof(source_vector[1]);
		vector[2] = sp_ctof(source_vector[2]);
	}
	if(source_qangle != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		qangle[0] = sp_ctof(source_qangle[0]);
		qangle[1] = sp_ctof(source_qangle[1]);
		qangle[2] = sp_ctof(source_qangle[2]);
	}
	
	*(void**)vptr = g_pZombieManager;
	vptr += sizeof(void*);

	*(Vector**)vptr = &vector;
	vptr += sizeof(Vector*);

	*(QAngle**)vptr = &qangle;
	vptr += sizeof(QAngle*);

	pWrapper->Execute( vstk, (void*) &entity );
	return gamehelpers->EntityToBCompatRef( entity );
}

cell_t L4D2_SpawnWitch(IPluginContext *pContext, const cell_t *params)
{
	if (g_pZombieManager == NULL)
	{
		return pContext->ThrowNativeError("ZombieManager unsupported or not available; file a bug report");
	}

	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		PassInfo passInfo;
		passInfo.flags = PASSFLAG_BYVAL;
		passInfo.size = sizeof( CBaseEntity* );
		passInfo.type = PassType_Basic;

		REGISTER_NATIVE_ADDR("SpawnWitch", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(Vector*); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(QAngle*); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, &passInfo, pass, 2));
	}

	CBaseEntity* entity;
	
	unsigned char vstk[ sizeof(void*) + sizeof(Vector*) + sizeof(QAngle*) ];
	unsigned char *vptr = vstk;
	
	cell_t* source_vector;
	pContext->LocalToPhysAddr(params[1], &source_vector);

	cell_t* source_qangle;
	pContext->LocalToPhysAddr(params[2], &source_qangle);

	Vector vector;
	QAngle qangle;

	if(source_vector != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		vector[0] = sp_ctof(source_vector[0]);
		vector[1] = sp_ctof(source_vector[1]);
		vector[2] = sp_ctof(source_vector[2]);
	}
	if(source_qangle != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		qangle[0] = sp_ctof(source_qangle[0]);
		qangle[1] = sp_ctof(source_qangle[1]);
		qangle[2] = sp_ctof(source_qangle[2]);
	}
	
	*(void**)vptr = g_pZombieManager;
	vptr += sizeof(void*);

	*(Vector**)vptr = &vector;
	vptr += sizeof(Vector*);

	*(QAngle**)vptr = &qangle;
	vptr += sizeof(QAngle*);

	pWrapper->Execute( vstk, (void*) &entity );
	return gamehelpers->EntityToBCompatRef( entity );	
}

cell_t L4D2_SpawnWitchBride(IPluginContext *pContext, const cell_t *params)
{
	if (g_pZombieManager == NULL)
	{
		return pContext->ThrowNativeError("ZombieManager unsupported or not available; file a bug report");
	}

	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		PassInfo passInfo;
		passInfo.flags = PASSFLAG_BYVAL;
		passInfo.size = sizeof( CBaseEntity* );
		passInfo.type = PassType_Basic;

		REGISTER_NATIVE_ADDR("SpawnWitchBride", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(Vector*); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(QAngle*); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, &passInfo, pass, 2));
	}

	CBaseEntity* entity;
	
	unsigned char vstk[ sizeof(void*) + sizeof(Vector*) + sizeof(QAngle*) ];
	unsigned char *vptr = vstk;
	
	cell_t* source_vector;
	pContext->LocalToPhysAddr(params[1], &source_vector);

	cell_t* source_qangle;
	pContext->LocalToPhysAddr(params[2], &source_qangle);

	Vector vector;
	QAngle qangle;

	if(source_vector != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		vector[0] = sp_ctof(source_vector[0]);
		vector[1] = sp_ctof(source_vector[1]);
		vector[2] = sp_ctof(source_vector[2]);
	}
	if(source_qangle != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		qangle[0] = sp_ctof(source_qangle[0]);
		qangle[1] = sp_ctof(source_qangle[1]);
		qangle[2] = sp_ctof(source_qangle[2]);
	}
	
	*(void**)vptr = g_pZombieManager;
	vptr += sizeof(void*);

	*(Vector**)vptr = &vector;
	vptr += sizeof(Vector*);

	*(QAngle**)vptr = &qangle;
	vptr += sizeof(QAngle*);

	pWrapper->Execute( vstk, (void*) &entity );
	return gamehelpers->EntityToBCompatRef( entity );
}

cell_t L4D2_FlashLightTurnOn(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("FlashLightTurnOn", 
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, NULL, 0));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("FlashLightTurnOn: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute FlashLightTurnOn");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked FlashLightTurnOn");
	
	return 0;
}

cell_t L4D2_PummelEnd(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnPummelEnd",
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnPummelEnd: Invalid target entity");		
	}

	CBaseEntity * pVictim = UTIL_GetCBaseEntity(target, true);
	if(pVictim == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnPummelEnd: Invalid victim entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pVictim;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnPummelEnd");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnPummelEnd");
	
	return 0;
}

cell_t L4D2_PounceEnd(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnPounceEnd",
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnPounceEnd: Invalid target entity");		
	}

	CBaseEntity * pVictim = UTIL_GetCBaseEntity(target, true);
	if(pVictim == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnPounceEnd: Invalid victim entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pVictim;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnPounceEnd");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnPounceEnd");
	
	return 0;
}

cell_t L4D2_RideEnd(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnRideEnd",
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnRideEnd: Invalid target entity");		
	}

	CBaseEntity * pVictim = UTIL_GetCBaseEntity(target, true);
	if(pVictim == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnRideEnd: Invalid victim entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pVictim;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnRideEnd");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnRideEnd");
	
	return 0;
}

cell_t L4D2_TongueBreak(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnTongueBreak",
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnTongueBreak: Invalid target entity");		
	}

	CBaseEntity * pVictim = UTIL_GetCBaseEntity(target, true);
	if(pVictim == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnTongueBreak: Invalid victim entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pVictim;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnTongueBreak");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnTongueBreak");
	
	return 0;
}

cell_t L4D2_Respawn(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("RoundRespawn", 
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, NULL, 0));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("RoundRespawn: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute RoundRespawn");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked RoundRespawn");
	
	return 0;
}

cell_t L4D2_SpitBurst(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CSpitterProjectile_Detonate", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(int); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, false);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CSpitterProjectile_Detonate: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(int)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = 1;
	vptr += sizeof(int);

	L4D_DEBUG_LOG("Going to execute CSpitterProjectile_Detonate");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CSpitterProjectile_Detonate");
	
	return 0;
}

cell_t L4D2_VomitOnPlayer(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnVomitedUpon", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(int); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 2));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnVomitedUpon: Invalid target entity");		
	}
	
	int source_ent = params[2];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, true);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnVomitedUpon: Invalid source entity");
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *) + sizeof(int)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = 1;
	vptr += sizeof(int);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnVomitedUpon");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnVomitedUpon");
	
	return 0;
}

cell_t L4D2_AdrenalineUsed(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnAdrenalineUsed", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(float); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnAdrenalineUsed: Invalid target entity");		
	}
	float duration = params[2];

	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(float)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = duration;
	vptr += sizeof(float);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnAdrenalineUsed");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnAdrenalineUsed");
	
	return 0;
}

cell_t L4D2_WeaponDrop(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("WeaponDrop", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("WeaponDrop: Invalid target entity");		
	}
	int weapon = params[2];
	CBaseEntity * pWeapon = UTIL_GetCBaseEntity(weapon, false);
	if(pWeapon == NULL) 
	{
		return pContext->ThrowNativeError("WeaponDrop: Invalid source entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pWeapon;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute WeaponDrop");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked WeaponDrop");
	
	return 0;
}

cell_t L4D2_BecomeGhost(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("BecomeGhost", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(int); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("BecomeGhost: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(int)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = 1;
	vptr += sizeof(int);

	L4D_DEBUG_LOG("Going to execute BecomeGhost");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked BecomeGhost");
	
	return 0;
}

cell_t L4D2_StateTransition(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("State_Transition", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(int); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("State_Transition: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(int)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = 6;
	vptr += sizeof(int);

	L4D_DEBUG_LOG("Going to execute State_Transition");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked State_Transition");
	
	return 0;
}

cell_t L4D2_CreateAbility(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		PassInfo retInfo;
		retInfo.flags = PASSFLAG_BYVAL;
		retInfo.size = sizeof(CBaseEntity *);
		retInfo.type = PassType_Basic;

		REGISTER_NATIVE_ADDR("CreateAbility", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, &retInfo, pass, 1));
	}
	CBaseEntity* entity;
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CreateAbility: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(void *) + sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(void**)vptr = g_pZombieManager;
	vptr += sizeof(void*);

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute CreateAbility");
	pWrapper->Execute(vstk, (void*) &entity);
	L4D_DEBUG_LOG("Invoked CreateAbility");
	
	return gamehelpers->EntityToBCompatRef(entity);
}

cell_t L4D2_SetClass(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("SetClass", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(int); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("SetClass: Invalid target entity");		
	}

	int zombieclass = params[2];
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(int)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = zombieclass;
	vptr += sizeof(int);

	L4D_DEBUG_LOG("Going to execute SetClass");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked SetClass");
	
	return 0;
}

cell_t L4D2_PlayerHitByVomitJar(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnHitByVomitJar", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnHitByVomitJar: Invalid target entity");		
	}
	int source_ent = params[2];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, true);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnHitByVomitJar: Invalid source entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnHitByVomitJar");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnHitByVomitJar");
	
	return 0;
}

cell_t L4D2_InfectedHitByVomitJar(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("Infected_OnHitByVomitJar", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, false);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("Infected_OnHitByVomitJar: Invalid target entity");		
	}
	int source_ent = params[2];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, true);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("Infected_OnHitByVomitJar: Invalid source entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute Infected_OnHitByVomitJar");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked Infected_OnHitByVomitJar");
	
	return 0;
}

cell_t L4D2_ReviveSurvivor(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnRevived",
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, NULL, 0));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnRevived: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnRevived");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnRevived");
	
	return 0;
}

cell_t L4D2_Fling(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_Fling", 
			PassInfo pass[4]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(Vector*); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(int); \
			pass[1].type = PassType_Basic; \
			pass[2].flags = PASSFLAG_BYVAL; \
			pass[2].size = sizeof(CBaseEntity *); \
			pass[2].type = PassType_Basic; \
			pass[3].flags = PASSFLAG_BYVAL; \
			pass[3].size = sizeof(float); \
			pass[3].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 4));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_Fling: Invalid target entity");		
	}
	int source_ent = params[4];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, true);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_Fling: Invalid source entity");		
	}

	cell_t * velocity;
	pContext->LocalToPhysAddr(params[2], &velocity);
	
	Vector vVelocity;
	Vector *pVelocity = NULL;
	
	if(velocity != pContext->GetNullRef(SP_NULL_VECTOR))
	{
		vVelocity[0] = sp_ctof(velocity[0]);
		vVelocity[1] = sp_ctof(velocity[1]);
		vVelocity[2] = sp_ctof(velocity[2]);
		pVelocity = &vVelocity;
	}
	int anim_event = params[3];
	if (anim_event == 0) anim_event = 76;
	float stun_time = params[5];
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(Vector*) + sizeof(int) + sizeof(CBaseEntity *) + sizeof(float)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(Vector **)vptr = pVelocity;
	vptr += sizeof(Vector*);
	*(cell_t*)vptr = anim_event;
	vptr += sizeof(int);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = stun_time;
	vptr += sizeof(float);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_Fling");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_Fling");
	
	return 0;
}

cell_t L4D2_ReplaceTank(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("ReplaceTank",
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(CBaseEntity *); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 2));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("ReplaceTank: Invalid target entity");		
	}
	int source_ent = params[2];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, true);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("ReplaceTank: Invalid source entity");		
	}
	
	unsigned char vstk[sizeof(void*) + sizeof(CBaseEntity *) + sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(void**)vptr = g_pZombieManager;
	vptr += sizeof(void*);
	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute ReplaceTank");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked ReplaceTank");
	
	return 0;
}

cell_t L4D2_ReplaceWithBot(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("ReplaceWithBot", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(int); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("ReplaceWithBot: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(int)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = 1;
	vptr += sizeof(int);

	L4D_DEBUG_LOG("Going to execute ReplaceWithBot");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked ReplaceWithBot");
	
	return 0;
}

cell_t L4D2_ZombieAbortControl(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("ZombieAbortControl", 
			PassInfo pass[1]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(float); \
			pass[0].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 1));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("ZombieAbortControl: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(float)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = 0.0;
	vptr += sizeof(float);

	L4D_DEBUG_LOG("Going to execute ZombieAbortControl");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked ZombieAbortControl");
	
	return 0;
}

cell_t L4D2_RefEntityHandle(IPluginContext *pContext, const cell_t *params)
{
	int offset = NULL;

	if (!g_pGameConf->GetOffset("RefEntityHandle", &offset) || !offset)
	{
		L4D_DEBUG_LOG("RefEntityHandle offset not found.");
		return 0;
	}
	L4D_DEBUG_LOG("RefEntityHandle found at: %i", offset);

	return offset;
}

cell_t L4D2_CarryEnd(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_OnCarryEnd", 
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, NULL, 0));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_OnCarryEnd: Invalid target entity");		
	}
	
	unsigned char vstk[sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_OnCarryEnd");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_OnCarryEnd");
	
	return 0;
}

cell_t L4D2_GetTankCount(IPluginContext *pContext, const cell_t *params)
{
	if (g_pDirector == NULL)
	{
		return pContext->ThrowNativeError("Director unsupported or not available; file a bug report");
	}

	CDirector *director = *g_pDirector;

	if (director == NULL)
	{
		return pContext->ThrowNativeError("Director not available before map is loaded");
	}
	return director->m_iTankCount;
}

cell_t L4D2_RevivedByDefibrillator(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("CTerrorPlayer_RevivedByDefibrillator", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(int); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 2));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, true);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_RevivedByDefibrillator: Invalid target entity");		
	}
	
	int source_ent = params[2];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, true);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("CTerrorPlayer_RevivedByDefibrillator: Invalid source entity");
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *) + sizeof(int)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);
	*(cell_t*)vptr = 1;
	vptr += sizeof(int);

	L4D_DEBUG_LOG("Going to execute CTerrorPlayer_RevivedByDefibrillator");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked CTerrorPlayer_RevivedByDefibrillator");
	
	return 0;
}

cell_t L4D2_InfectedShoved(IPluginContext *pContext, const cell_t *params)
{
	static ICallWrapper *pWrapper = NULL;

	if (!pWrapper)
	{
		REGISTER_NATIVE_ADDR("InfectedShoved::OnShoved", 
			PassInfo pass[2]; \
			pass[0].flags = PASSFLAG_BYVAL; \
			pass[0].size = sizeof(CBaseEntity *); \
			pass[0].type = PassType_Basic; \
			pass[1].flags = PASSFLAG_BYVAL; \
			pass[1].size = sizeof(CBaseEntity *); \
			pass[1].type = PassType_Basic; \
			pWrapper = g_pBinTools->CreateCall(addr, CallConv_ThisCall, NULL, pass, 2));
	}
	
	int target = params[1];
	CBaseEntity * pTarget = UTIL_GetCBaseEntity(target, false);
	if(pTarget == NULL) 
	{
		return pContext->ThrowNativeError("InfectedShoved::OnShoved: Invalid target entity");		
	}
	
	int source_ent = params[2];
	CBaseEntity * pSource = UTIL_GetCBaseEntity(source_ent, true);
	if(pSource == NULL) 
	{
		return pContext->ThrowNativeError("InfectedShoved::OnShoved: Invalid source entity");
	}
	
	unsigned char vstk[sizeof(CBaseEntity *) + sizeof(CBaseEntity *)];
	unsigned char *vptr = vstk;

	*(CBaseEntity **)vptr = pTarget;
	vptr += sizeof(CBaseEntity *);
	*(CBaseEntity **)vptr = pSource;
	vptr += sizeof(CBaseEntity *);

	L4D_DEBUG_LOG("Going to execute InfectedShoved::OnShoved");
	pWrapper->Execute(vstk, NULL);
	L4D_DEBUG_LOG("Invoked InfectedShoved::OnShoved");
	
	return 0;
}
sp_nativeinfo_t g_L4DoNatives[] = 
{
	{"L4D2_RestartScenarioFromVote",	L4D2_RestartScenarioFromVote},
	{"L4D2_IsMissionFinalMap",			L4D2_IsMissionFinalMap},
	{"L4D2_ResetMobTimer",				L4D2_ResetMobTimer},
	{"L4D2_StaggerPlayer",				L4D2_StaggerPlayer},
	{"L4D2_ShoveInfectedPlayer",		L4D2_ShoveInfectedPlayer},
	{"L4D2_SendInRescueVehicle",  		L4D2_SendInRescueVehicle},
	{"L4D2_ChangeFinaleStage",  		L4D2_ChangeFinaleStage},
	{"L4D2_SpawnSpecial",				L4D2_SpawnSpecial},
	{"L4D2_SpawnTank",					L4D2_SpawnTank},
	{"L4D2_SpawnWitch",					L4D2_SpawnWitch},
	{"L4D2_SpawnWitchBride",  			L4D2_SpawnWitchBride},
	{"L4D2_FlashLightTurnOn",  			L4D2_FlashLightTurnOn},
	{"L4D2_PummelEnd",  				L4D2_PummelEnd},
	{"L4D2_PounceEnd",  				L4D2_PounceEnd},
	{"L4D2_RideEnd",  					L4D2_RideEnd},
	{"L4D2_TongueBreak",  				L4D2_TongueBreak},
	{"L4D2_Respawn",  					L4D2_Respawn},
	{"L4D2_SpitBurst",  				L4D2_SpitBurst},
	{"L4D2_VomitOnPlayer",  			L4D2_VomitOnPlayer},
	{"L4D2_AdrenalineUsed",  			L4D2_AdrenalineUsed},
	{"L4D2_WeaponDrop",  				L4D2_WeaponDrop},
	{"L4D2_BecomeGhost",  				L4D2_BecomeGhost},
	{"L4D2_StateTransition",  			L4D2_StateTransition},
	{"L4D2_CreateAbility",  			L4D2_CreateAbility},
	{"L4D2_SetClass",  					L4D2_SetClass},
	{"L4D2_PlayerHitByVomitJar",  		L4D2_PlayerHitByVomitJar},
	{"L4D2_InfectedHitByVomitJar",  	L4D2_InfectedHitByVomitJar},
	{"L4D2_ReviveSurvivor",  			L4D2_ReviveSurvivor},
	{"L4D2_Fling",  					L4D2_Fling},
	{"L4D2_ReplaceTank",  				L4D2_ReplaceTank},
	{"L4D2_ReplaceWithBot",  			L4D2_ReplaceWithBot},
	{"L4D2_ZombieAbortControl",  		L4D2_ZombieAbortControl},
	{"L4D2_RefEntityHandle",  			L4D2_RefEntityHandle},
	{"L4D2_CarryEnd",  					L4D2_CarryEnd},
	{"L4D2_GetTankCount",				L4D2_GetTankCount},
	{"L4D2_RevivedByDefibrillator",		L4D2_RevivedByDefibrillator},
	{"L4D2_InfectedShoved",				L4D2_InfectedShoved},
	{NULL,							NULL}
};
