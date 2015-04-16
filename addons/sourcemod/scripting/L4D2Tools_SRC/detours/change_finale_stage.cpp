#include "change_finale_stage.h"
#include "extension.h"

namespace Detours
{
	void ChangeFinaleStage::OnChangeFinaleStage(int finaleType, const char *key)
	{
		cell_t result = Pl_Continue;

		if(g_pFwdOnChangeFinaleStage)
		{
			//L4D_DEBUG_LOG("L4D2_OnChangeFinaleStage(%i, [%s]) forward has been sent out", finaleType, key);
			g_pFwdOnChangeFinaleStage->PushCellByRef(&finaleType);

			if (key != NULL)
			{
				g_pFwdOnChangeFinaleStage->PushString(key);
			}
			else
			{
				g_pFwdOnChangeFinaleStage->PushString("");
			}
			g_pFwdOnChangeFinaleStage->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			//L4D_DEBUG_LOG("L4D2_OnChangeFinaleStage() will be skipped");
			return;
		}
		else
		{
			(this->*(GetTrampoline()))(finaleType, key);
			return;
		}
	}
};
