#ifndef _INCLUDE_SOURCEMOD_DETOUR_INFECTED_ALERT_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_INFECTED_ALERT_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Infected;

namespace Detours {

class InfectedAlertUpdate;

typedef ActionStruct_t (InfectedAlertUpdate::*InfectedAlertUpdateFunc)(Infected* pInfected, float);

class InfectedAlertUpdate : public DetourTemplate<InfectedAlertUpdateFunc, InfectedAlertUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnInfectedAlertUpdate(Infected*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "InfectedAlert::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual InfectedAlertUpdateFunc GetDetour()
	{
		return &InfectedAlertUpdate::OnInfectedAlertUpdate;
	}
};

};
#endif
