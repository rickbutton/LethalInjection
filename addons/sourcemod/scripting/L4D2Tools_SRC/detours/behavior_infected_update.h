#ifndef _INCLUDE_SOURCEMOD_DETOUR_BEHAVIOR_INFECTED_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_BEHAVIOR_INFECTED_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Infected;

namespace Detours {

class BehaviorInfectedUpdate;

typedef ActionStruct_t (BehaviorInfectedUpdate::*BehaviorInfectedUpdateFunc)(Infected* pInfected, float);

class BehaviorInfectedUpdate : public DetourTemplate<BehaviorInfectedUpdateFunc, BehaviorInfectedUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnBehaviorInfectedUpdate(Infected*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "BehaviorInfectedUpdate";
	}

	//notify our patch system which function should be used as the detour
	virtual BehaviorInfectedUpdateFunc GetDetour()
	{
		return &BehaviorInfectedUpdate::OnBehaviorInfectedUpdate;
	}
};

};
#endif
