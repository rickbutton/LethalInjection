#include "get_walk_top_speed.h"
#include "extension.h"

namespace Detours
{
	float GetWalkTopSpeed::OnGetWalkTopSpeed()
	{
		//L4D_DEBUG_LOG("CTerrorPlayer::GetWalkTopSpeed() has been called");

		cell_t result = Pl_Continue;

		float actualInvocationResult = (this->*(GetTrampoline()))();

		float overrideValue = actualInvocationResult;
		
		if(g_pFwdOnGetWalkTopSpeed)
		{
			edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
			int target = IndexOfEdict(pEntity);
		
			//L4D_DEBUG_LOG("L4D_OnGetWalkTopSpeed(target %d) forward has been sent out", target);
			g_pFwdOnGetWalkTopSpeed->PushCell(target);
			g_pFwdOnGetWalkTopSpeed->PushFloatByRef(&overrideValue);
			g_pFwdOnGetWalkTopSpeed->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			//L4D_DEBUG_LOG("CTerrorPlayer::GetWalkTopSpeed() return value overriden with %d", overrideValue);
			return overrideValue;
		}
		else
		{
			return actualInvocationResult;
		}
	}
};
