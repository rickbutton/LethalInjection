#include "spitter_attack_update.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t SpitterAttackUpdate::OnSpitterAttackUpdate(Spitter* pSpitter, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnSpitterAttackUpdate)
		{
			edict_t *pSpitterEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pSpitter));
			cell_t entity = IndexOfEdict(pSpitterEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnSpitterAttackUpdate->PushCell(entity);
			g_pFwdOnSpitterAttackUpdate->PushCellByRef(&victim);
			g_pFwdOnSpitterAttackUpdate->Execute(&result);
			if(result == Pl_Handled)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = NULL;
			}
			else if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pSpitter, fu);
		return ActionResult;
	}
};