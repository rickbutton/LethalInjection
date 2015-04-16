#include "boomer_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t BoomerAttackUpdate::OnBoomerAttackUpdate(Boomer* pBoomer, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnBoomerAttackUpdate)
		{
			edict_t *pBoomerEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pBoomer));
			cell_t entity = IndexOfEdict(pBoomerEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnBoomerAttackUpdate->PushCell(entity);
			g_pFwdOnBoomerAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnBoomerAttackUpdate->Execute(&result);
			if(result == Pl_Handled)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = NULL;
			}
			else if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pBoomer, fu);
		return ActionResult;
	}
};