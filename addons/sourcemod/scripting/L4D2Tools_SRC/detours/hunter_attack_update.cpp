#include "hunter_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t HunterAttackUpdate::OnHunterAttackUpdate(Hunter* pHunter, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnHunterAttackUpdate)
		{
			edict_t *pHunterEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pHunter));
			cell_t entity = IndexOfEdict(pHunterEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnHunterAttackUpdate->PushCell(entity);
			g_pFwdOnHunterAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnHunterAttackUpdate->Execute(&result);
			if(result == Pl_Handled)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = NULL;
			}
			else if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pHunter, fu);
		return ActionResult;
	}
};