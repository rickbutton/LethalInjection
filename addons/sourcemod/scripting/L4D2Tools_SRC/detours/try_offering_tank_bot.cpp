#include "try_offering_tank_bot.h"
#include "extension.h"

namespace Detours
{
	void TryOfferingTankBot::OnTryOfferingTankBot(CBaseEntity* tank, bool enterStasis)
	{
		L4D_DEBUG_LOG("CTerrorPlayer::TryOfferingTankBot has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnTryOfferingTankBot)
		{
			cell_t tankindex = tank ? IndexOfEdict(gameents->BaseEntityToEdict(tank)) : 0;
			cell_t cellEnterStasis = static_cast<bool>(enterStasis);
			
			L4D_DEBUG_LOG("L4D_OnTryOfferingTankBot(tank %d, enterStasis %d) forward has been sent out", tank, enterStasis);
			g_pFwdOnTryOfferingTankBot->PushCell(tankindex);
			g_pFwdOnTryOfferingTankBot->PushCellByRef(&cellEnterStasis);
			L4D_DEBUG_LOG("L4D_OnTryOfferingTankBot() forward has been sent out");
			g_pFwdOnTryOfferingTankBot->Execute(&result);
			enterStasis = cellEnterStasis != 0;
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("CDirector::TryOfferingTankBot will be skipped");
			return;
		}
		else
		{
			L4D_DEBUG_LOG("CTerrorGameRules::SetCampaignScores will be invoked with enterStasis=%d", enterStasis);
			(this->*(GetTrampoline()))(tank, enterStasis);
			return;
		}
	}
};
