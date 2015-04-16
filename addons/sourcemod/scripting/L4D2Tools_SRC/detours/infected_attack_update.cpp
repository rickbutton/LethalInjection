#include "infected_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t InfectedAttackUpdate::OnInfectedAttackUpdate(Infected* pInfected, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnInfectedAttackUpdate)
		{
			edict_t *pInfectedEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pInfected));
			cell_t entity = IndexOfEdict(pInfectedEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnInfectedAttackUpdate->PushCell(entity);
			g_pFwdOnInfectedAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnInfectedAttackUpdate->Execute(&result);
			if(result == Pl_Handled)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = NULL;
			}
			else if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pInfected, fu);
		return ActionResult;
	}
};