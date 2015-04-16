#include "shoved_by_survivor.h"
#include "extension.h"

namespace Detours
{
	int ShovedBySurvivor::OnShovedBySurvivor(CBaseEntity *sourceEnt, void *sourceDir)
	{
		cell_t result = Pl_Continue;

		if (g_pFwdOnShovedBySurvivor)
		{
			cell_t target = IndexOfEdict(gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this)));
			edict_t *pSource = gameents->BaseEntityToEdict(sourceEnt);

			g_pFwdOnShovedBySurvivor->PushCell(target);
			g_pFwdOnShovedBySurvivor->PushCell(pSource ? IndexOfEdict(pSource) : 0);
			g_pFwdOnShovedBySurvivor->Execute(&result);
		}

		return result == Pl_Handled ? 0 : (this->*(GetTrampoline()))(sourceEnt, sourceDir);
	}
};
