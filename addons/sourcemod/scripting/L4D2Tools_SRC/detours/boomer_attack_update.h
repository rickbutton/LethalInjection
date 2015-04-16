#ifndef _INCLUDE_SOURCEMOD_DETOUR_BOOMER_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_BOOMER_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Boomer;

namespace Detours {

class BoomerAttackUpdate;

typedef ActionStruct_t (BoomerAttackUpdate::*BoomerAttackUpdateFunc)(Boomer* pBoomer, float);

class BoomerAttackUpdate : public DetourTemplate<BoomerAttackUpdateFunc, BoomerAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnBoomerAttackUpdate(Boomer*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "BoomerAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual BoomerAttackUpdateFunc GetDetour()
	{
		return &BoomerAttackUpdate::OnBoomerAttackUpdate;
	}
};

};
#endif
