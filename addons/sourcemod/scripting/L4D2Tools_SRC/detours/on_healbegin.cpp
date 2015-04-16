#include "on_healbegin.h"
#include "extension.h"

namespace Detours
{
	int HealBegin::OnHealBegin(CBaseEntity *sourceEnt)
	{
		cell_t result = Pl_Continue;

		if (g_pFwdOnHealBegin)
		{
			cell_t target = IndexOfEdict(gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this)));
			edict_t *pSource = gameents->BaseEntityToEdict(sourceEnt);

			g_pFwdOnHealBegin->PushCell(target);
			g_pFwdOnHealBegin->PushCell(pSource ? IndexOfEdict(pSource) : 0);
			g_pFwdOnHealBegin->Execute(&result);
		}

		return result == Pl_Handled ? 0 : (this->*(GetTrampoline()))(sourceEnt);
	}
};
