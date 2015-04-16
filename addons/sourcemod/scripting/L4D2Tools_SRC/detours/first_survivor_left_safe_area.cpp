#include "first_survivor_left_safe_area.h"
#include "extension.h"

namespace Detours
{
	void *FirstSurvivorLeftSafeArea::OnFirstSurvivorLeftSafeArea(CTerrorPlayer *p)
	{
		L4D_DEBUG_LOG("CDirector::OnFirstSurvivorLeftSafeArea has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnFirstSurvivorLeftSafeArea)
		{
			int client;
			if(p == NULL)
			{
				/*
				quite possible the survivor is NULL
				e.g. CDirectorScavengeMode::ShouldUpdateTeamReadiness
				calls OnFirstSurvivorLeftSafeArea(NULL)
				*/
				client = 0;
			}
			else
			{
				edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(p));
				client = IndexOfEdict(pEntity);
			}

			L4D_DEBUG_LOG("L4D_OnFirstSurvivorLeftSafeArea(%d) forward has been sent out", client);
			g_pFwdOnFirstSurvivorLeftSafeArea->PushCell(client);
			g_pFwdOnFirstSurvivorLeftSafeArea->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("CDirector::OnFirstSurvivorLeftSafeArea will be skipped");
			return NULL;
		}
		else
		{
			return (this->*(GetTrampoline()))(p);
		}
	}
};
