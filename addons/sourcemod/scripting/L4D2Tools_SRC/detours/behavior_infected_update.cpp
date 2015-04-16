#include "behavior_infected_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t BehaviorInfectedUpdate::OnBehaviorInfectedUpdate(Infected* pInfected, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnBehaviorInfectedUpdate)
		{
			edict_t *pInfectedEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pInfected));
			cell_t entity = IndexOfEdict(pInfectedEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnBehaviorInfectedUpdate->PushCell(entity);
			g_pFwdOnBehaviorInfectedUpdate->PushCellByRef(&victim);
			g_pFwdOnBehaviorInfectedUpdate->Execute(&result);
			if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pInfected, fu);
		return ActionResult;
	}
};