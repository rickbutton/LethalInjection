#ifndef _INCLUDE_SOURCEMOD_DETOUR_TRYOFFERINGTANKBOT_H_
#define _INCLUDE_SOURCEMOD_DETOUR_TRYOFFERINGTANKBOT_H_

#include "detour_template.h"

namespace Detours {

class TryOfferingTankBot;
typedef void (TryOfferingTankBot::*TryOfferingTankBotFunc)(CBaseEntity*, bool);

class TryOfferingTankBot : public DetourTemplate<TryOfferingTankBotFunc, TryOfferingTankBot>
{
private: //note: implementation of DetourTemplate abstracts

	void OnTryOfferingTankBot(CBaseEntity* tank, bool enterStasis);

	// get the signature name (i.e. "TryOfferingTankBot") from the game conf
	virtual const char *GetSignatureName()
	{
		return "TryOfferingTankBot";
	}

	//notify our patch system which function should be used as the detour
	virtual TryOfferingTankBotFunc GetDetour()
	{
		return &TryOfferingTankBot::OnTryOfferingTankBot;
	}
};

};
#endif
