#include "player_use.h"
#include "extension.h"

namespace Detours
{
	void *PlayerUse::OnPlayerUse(CBaseEntity *p)
	{
		cell_t result = Pl_Continue;

		if (g_pFwdOnPlayerUse)
		{
			cell_t client = IndexOfEdict(gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this)));	
			cell_t entity = IndexOfEdict(gameents->BaseEntityToEdict(p));

			g_pFwdOnPlayerUse->PushCell(client);
			g_pFwdOnPlayerUse->PushCell(entity);
			g_pFwdOnPlayerUse->Execute(&result);
		}

		return result == Pl_Handled ? 0 : (this->*(GetTrampoline()))(p);
	}
};