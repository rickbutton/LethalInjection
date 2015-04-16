#ifndef _INCLUDE_SOURCEMOD_DETOUR_CHARGER_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_CHARGER_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Charger;

namespace Detours {

class ChargerAttackUpdate;

typedef ActionStruct_t (ChargerAttackUpdate::*ChargerAttackUpdateFunc)(Charger* pCharger, float);

class ChargerAttackUpdate : public DetourTemplate<ChargerAttackUpdateFunc, ChargerAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnChargerAttackUpdate(Charger*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "ChargerAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual ChargerAttackUpdateFunc GetDetour()
	{
		return &ChargerAttackUpdate::OnChargerAttackUpdate;
	}
};

};
#endif
