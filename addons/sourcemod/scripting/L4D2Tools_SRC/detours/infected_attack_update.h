#ifndef _INCLUDE_SOURCEMOD_DETOUR_INFECTED_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_INFECTED_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Infected;

namespace Detours {

class InfectedAttackUpdate;

typedef ActionStruct_t (InfectedAttackUpdate::*InfectedAttackUpdateFunc)(Infected* pInfected, float);

class InfectedAttackUpdate : public DetourTemplate<InfectedAttackUpdateFunc, InfectedAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnInfectedAttackUpdate(Infected*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "InfectedAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual InfectedAttackUpdateFunc GetDetour()
	{
		return &InfectedAttackUpdate::OnInfectedAttackUpdate;
	}
};

};
#endif
