#ifndef _INCLUDE_SOURCEMOD_DETOUR_SURVIVOR_USE_OBJECT_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SURVIVOR_USE_OBJECT_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class SurvivorBot;

namespace Detours {

class SurvivorUseObjectUpdate;

typedef ActionStruct_t (SurvivorUseObjectUpdate::*SurvivorUseObjectUpdateFunc)(SurvivorBot* pSurvivorBot, float);

class SurvivorUseObjectUpdate : public DetourTemplate<SurvivorUseObjectUpdateFunc, SurvivorUseObjectUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnSurvivorUseObjectUpdate(SurvivorBot*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SurvivorUseObject::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual SurvivorUseObjectUpdateFunc GetDetour()
	{
		return &SurvivorUseObjectUpdate::OnSurvivorUseObjectUpdate;
	}
};

};
#endif
