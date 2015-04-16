#include "cthrow_activate_ability.h"
#include "extension.h"

namespace Detours
{
	void CThrowActivate::OnCThrowActivate()
	{
		L4D_DEBUG_LOG("CThrow::ActivateAbility has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnCThrowActivate)
		{
			edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
			int entity = IndexOfEdict(pEntity);
			L4D_DEBUG_LOG("L4D_OnCThrowActivate(%d) forward has been sent out", entity);

			g_pFwdOnCThrowActivate->PushCell(entity);
			g_pFwdOnCThrowActivate->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("CThrow::ActivateAbility will be skipped");
			return;
		}
		else
		{
			(this->*(GetTrampoline()))();
			return;
		}
	}
};
