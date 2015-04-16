#include "smoker_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t SmokerAttackUpdate::OnSmokerAttackUpdate(Smoker* pSmoker, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnSmokerAttackUpdate)
		{
			edict_t *pSmokerEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pSmoker));
			cell_t entity = IndexOfEdict(pSmokerEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnSmokerAttackUpdate->PushCell(entity);
			g_pFwdOnSmokerAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnSmokerAttackUpdate->Execute(&result);
			if(result == Pl_Handled)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = NULL;
			}
			else if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pSmoker, fu);
		return ActionResult;
	}
};