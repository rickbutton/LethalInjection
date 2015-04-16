#include "infected_shoved.h"
#include "extension.h"

namespace Detours
{
	void *InfectedShoved::OnInfectedShoved(Infected *z, int entity)
	{
		L4D_DEBUG_LOG("Infected::OnInfectedShoved has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnInfectedShoved)
		{
			int infected;
			if(z == NULL)
			{
				infected = 0;
			}
			else
			{
				edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(z));
				infected = IndexOfEdict(pEntity);
			}
			
			edict_t *pEntity2 = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(entity));
			int entity = IndexOfEdict(pEntity2);

			L4D_DEBUG_LOG("L4D_OnInfectedShoved(infected %d, entity %d) forward has been sent out", infected, entity);
			g_pFwdOnInfectedShoved->PushCell(infected);
			g_pFwdOnInfectedShoved->PushCell(entity);
			g_pFwdOnInfectedShoved->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("Infected::OnInfectedShoved will be skipped");
			return NULL;
		}
		else
		{
			return (this->*(GetTrampoline()))(z, entity);
		}
	}
};