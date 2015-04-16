#include "mob_rush_start.h"
#include "extension.h"

namespace Detours
{
	void MobRushStart::OnMobRushStart()
	{
		L4D_DEBUG_LOG("CDirector::OnMobRushStart has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnMobRushStart)
		{
			L4D_DEBUG_LOG("L4D_OnMobRushStart() forward has been sent out");
			g_pFwdOnMobRushStart->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("CDirector::OnMobRushStart will be skipped");
			return;
		}
		else
		{
			(this->*(GetTrampoline()))();
			return;
		}
	}
};
