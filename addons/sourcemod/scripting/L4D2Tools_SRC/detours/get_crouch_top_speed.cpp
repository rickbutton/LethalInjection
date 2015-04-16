#include "get_crouch_top_speed.h"
#include "extension.h"

namespace Detours
{
	float GetCrouchTopSpeed::OnGetCrouchTopSpeed()
	{
		//L4D_DEBUG_LOG("CTerrorPlayer::GetCrouchTopSpeed() has been called");

		cell_t result = Pl_Continue;

		float actualInvocationResult = (this->*(GetTrampoline()))();

		float overrideValue = actualInvocationResult;
		
		if(g_pFwdOnGetCrouchTopSpeed)
		{
			edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
			int target = IndexOfEdict(pEntity);
		
			//L4D_DEBUG_LOG("L4D_OnGetCrouchTopSpeed(target %d) forward has been sent out", target);
			g_pFwdOnGetCrouchTopSpeed->PushCell(target);
			g_pFwdOnGetCrouchTopSpeed->PushFloatByRef(&overrideValue);
			g_pFwdOnGetCrouchTopSpeed->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			//L4D_DEBUG_LOG("CTerrorPlayer::GetCrouchTopSpeed() return value overriden with %d", overrideValue);
			return overrideValue;
		}
		else
		{
			return actualInvocationResult;
		}
	}
};
