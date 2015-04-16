#include "infected_alert_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t InfectedAlertUpdate::OnInfectedAlertUpdate(Infected* pInfected, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnInfectedAlertUpdate)
		{
			edict_t *pInfectedEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pInfected));
			cell_t entity = IndexOfEdict(pInfectedEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnInfectedAlertUpdate->PushCell(entity);
			g_pFwdOnInfectedAlertUpdate->PushCellByRef(&victim);
			g_pFwdOnInfectedAlertUpdate->Execute(&result);
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