#include "tank_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t TankAttackUpdate::OnTankAttackUpdate(Tank* pTank, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnTankAttackUpdate)
		{
			edict_t *pTankEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pTank));
			cell_t entity = IndexOfEdict(pTankEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnTankAttackUpdate->PushCell(entity);
			g_pFwdOnTankAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnTankAttackUpdate->Execute(&result);
			if(result == Pl_Handled)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = NULL;
			}
			else if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pTank, fu);
		return ActionResult;
	}
};