#include "witch_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t WitchAttackUpdate::OnWitchAttackUpdate(Witch* pWitch, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnWitchAttackUpdate)
		{
			edict_t *pWitchEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pWitch));
			cell_t entity = IndexOfEdict(pWitchEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnWitchAttackUpdate->PushCell(entity);
			g_pFwdOnWitchAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnWitchAttackUpdate->Execute(&result);
			if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pWitch, fu);
		return ActionResult;
	}
};