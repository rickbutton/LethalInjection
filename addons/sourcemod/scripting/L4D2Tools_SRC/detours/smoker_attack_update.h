#ifndef _INCLUDE_SOURCEMOD_DETOUR_SMOKER_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SMOKER_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Smoker;

namespace Detours {

class SmokerAttackUpdate;

typedef ActionStruct_t (SmokerAttackUpdate::*SmokerAttackUpdateFunc)(Smoker* pSmoker, float);

class SmokerAttackUpdate : public DetourTemplate<SmokerAttackUpdateFunc, SmokerAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnSmokerAttackUpdate(Smoker*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SmokerAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual SmokerAttackUpdateFunc GetDetour()
	{
		return &SmokerAttackUpdate::OnSmokerAttackUpdate;
	}
};

};
#endif
