#include "start_melee_swing.h"
#include "extension.h"

namespace Detours
{
	void *StartMeleeSwing::OnStartMeleeSwing(CTerrorPlayer *p, int boolean)
	{
		L4D_DEBUG_LOG("CTerrorMeleeWeapon::StartMeleeSwing has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnStartMeleeSwing)
		{
			int client;
			if(p == NULL)
			{
				client = 0;
			}
			else
			{
				edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(p));
				client = IndexOfEdict(pEntity);
			}

			L4D_DEBUG_LOG("L4D_OnStartMeleeSwing(client %d, boolean %d) forward has been sent out", client, boolean);
			g_pFwdOnStartMeleeSwing->PushCell(client);
			g_pFwdOnStartMeleeSwing->PushCell(boolean);
			g_pFwdOnStartMeleeSwing->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("CTerrorMeleeWeapon::OnStartMeleeSwing will be skipped");
			return NULL;
		}
		else
		{
			return (this->*(GetTrampoline()))(p, boolean);
		}
	}
};
