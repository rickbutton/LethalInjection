#include "charger_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t ChargerAttackUpdate::OnChargerAttackUpdate(Charger* pCharger, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnChargerAttackUpdate)
		{
			edict_t *pChargerEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pCharger));
			cell_t entity = IndexOfEdict(pChargerEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnChargerAttackUpdate->PushCell(entity);
			g_pFwdOnChargerAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnChargerAttackUpdate->Execute(&result);
			if(result == Pl_Handled)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = NULL;
			}
			else if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pCharger, fu);
		return ActionResult;
	}
};