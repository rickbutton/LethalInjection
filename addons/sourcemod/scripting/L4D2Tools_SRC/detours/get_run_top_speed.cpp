#include "get_run_top_speed.h"
#include "extension.h"

namespace Detours
{
	float GetRunTopSpeed::OnGetRunTopSpeed()
	{
		//L4D_DEBUG_LOG("CTerrorPlayer::GetRunTopSpeed() has been called");

		cell_t result = Pl_Continue;

		float actualInvocationResult = (this->*(GetTrampoline()))();

		float overrideValue = actualInvocationResult;
		
		if(g_pFwdOnGetRunTopSpeed)
		{
			edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
			int target = IndexOfEdict(pEntity);
		
			//L4D_DEBUG_LOG("L4D_OnGetRunTopSpeed(target %d) forward has been sent out", target);
			g_pFwdOnGetRunTopSpeed->PushCell(target);
			g_pFwdOnGetRunTopSpeed->PushFloatByRef(&overrideValue);
			g_pFwdOnGetRunTopSpeed->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			//L4D_DEBUG_LOG("CTerrorPlayer::GetRunTopSpeed() return value overriden with %d", overrideValue);
			return overrideValue;
		}
		else
		{
			return actualInvocationResult;
		}
	}
};
