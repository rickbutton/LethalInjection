#include "jockey_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t JockeyAttackUpdate::OnJockeyAttackUpdate(Jockey* pJockey, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnJockeyAttackUpdate)
		{
			edict_t *pJockeyEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pJockey));
			cell_t entity = IndexOfEdict(pJockeyEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnJockeyAttackUpdate->PushCell(entity);
			g_pFwdOnJockeyAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnJockeyAttackUpdate->Execute(&result);
			if(result == Pl_Handled)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = NULL;
			}
			else if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pJockey, fu);
		return ActionResult;
	}
};