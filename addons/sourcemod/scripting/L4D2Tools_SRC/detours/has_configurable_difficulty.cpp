#include "has_configurable_difficulty.h"
#include "extension.h"

namespace Detours
{
	int HasConfigurableDifficulty::OnHasConfigurableDifficulty()
	{
		//L4D_DEBUG_LOG("HasConfigurableDifficulty() has been called");

		cell_t result = Pl_Continue;

		int actualInvocationResult = (this->*(GetTrampoline()))();

		int overrideValue = actualInvocationResult;
		
		if(g_pFwdOnHasConfigurableDifficulty)
		{
			//L4D_DEBUG_LOG("L4D_OnHasConfigurableDifficulty(return %d) forward has been sent out", target);
			g_pFwdOnHasConfigurableDifficulty->PushCellByRef(&overrideValue);
			g_pFwdOnHasConfigurableDifficulty->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			//L4D_DEBUG_LOG("CTerrorGameRules::HasConfigurableDifficulty() return value overriden with %d", overrideValue);
			return overrideValue;
		}
		else
		{
			return actualInvocationResult;
		}
	}
};
