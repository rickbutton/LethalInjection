#ifndef _INCLUDE_SOURCEMOD_DETOUR_SPITTER_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SPITTER_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Spitter;

namespace Detours {

class SpitterAttackUpdate;

typedef ActionStruct_t (SpitterAttackUpdate::*SpitterAttackUpdateFunc)(Spitter* pSpitter, float);

class SpitterAttackUpdate : public DetourTemplate<SpitterAttackUpdateFunc, SpitterAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnSpitterAttackUpdate(Spitter*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SpitterAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual SpitterAttackUpdateFunc GetDetour()
	{
		return &SpitterAttackUpdate::OnSpitterAttackUpdate;
	}
};

};
#endif
