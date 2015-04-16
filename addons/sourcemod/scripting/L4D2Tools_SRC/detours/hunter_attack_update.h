#ifndef _INCLUDE_SOURCEMOD_DETOUR_HUNTER_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_HUNTER_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Hunter;

namespace Detours {

class HunterAttackUpdate;

typedef ActionStruct_t (HunterAttackUpdate::*HunterAttackUpdateFunc)(Hunter* pHunter, float);

class HunterAttackUpdate : public DetourTemplate<HunterAttackUpdateFunc, HunterAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnHunterAttackUpdate(Hunter*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "HunterAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual HunterAttackUpdateFunc GetDetour()
	{
		return &HunterAttackUpdate::OnHunterAttackUpdate;
	}
};

};
#endif
