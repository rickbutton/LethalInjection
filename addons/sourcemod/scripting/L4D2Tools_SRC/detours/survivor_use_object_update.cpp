#include "survivor_use_object_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t SurvivorUseObjectUpdate::OnSurvivorUseObjectUpdate(SurvivorBot* pSurvivorBot, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnSurvivorUseObjectUpdate)
		{
			edict_t *pSurvivorBotEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pSurvivorBot));
			cell_t entity = IndexOfEdict(pSurvivorBotEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnSurvivorUseObjectUpdate->PushCell(entity);
			g_pFwdOnSurvivorUseObjectUpdate->PushCellByRef(&victim);
			g_pFwdOnSurvivorUseObjectUpdate->Execute(&result);
			if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pSurvivorBot, fu);
		return ActionResult;
	}
};