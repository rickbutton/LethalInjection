#ifndef _INCLUDE_SOURCEMOD_DETOUR_WITCH_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_WITCH_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Witch;

namespace Detours {

class WitchAttackUpdate;

typedef ActionStruct_t (WitchAttackUpdate::*WitchAttackUpdateFunc)(Witch* pWitch, float);

class WitchAttackUpdate : public DetourTemplate<WitchAttackUpdateFunc, WitchAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnWitchAttackUpdate(Witch*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "WitchAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual WitchAttackUpdateFunc GetDetour()
	{
		return &WitchAttackUpdate::OnWitchAttackUpdate;
	}
};

};
#endif
