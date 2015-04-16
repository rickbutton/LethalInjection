#include "on_staggered.h"
#include "extension.h"

namespace Detours
{
	int PlayerStagger::OnPlayerStagger(CBaseEntity *sourceEnt, void *sourceDir)
	{
		cell_t result = Pl_Continue;

		if (g_pFwdOnPlayerStagger)
		{
			cell_t target = IndexOfEdict(gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this)));
			edict_t *pSource = gameents->BaseEntityToEdict(sourceEnt);

			g_pFwdOnPlayerStagger->PushCell(target);
			g_pFwdOnPlayerStagger->PushCell(pSource ? IndexOfEdict(pSource) : 0);
			g_pFwdOnPlayerStagger->Execute(&result);
		}

		return result == Pl_Handled ? 0 : (this->*(GetTrampoline()))(sourceEnt, sourceDir);
	}
};
