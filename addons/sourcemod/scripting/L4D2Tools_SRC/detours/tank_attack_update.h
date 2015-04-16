#ifndef _INCLUDE_SOURCEMOD_DETOUR_TANK_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_TANK_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Tank;

namespace Detours {

class TankAttackUpdate;

typedef ActionStruct_t (TankAttackUpdate::*TankAttackUpdateFunc)(Tank* pTank, float);

class TankAttackUpdate : public DetourTemplate<TankAttackUpdateFunc, TankAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnTankAttackUpdate(Tank*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "TankAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual TankAttackUpdateFunc GetDetour()
	{
		return &TankAttackUpdate::OnTankAttackUpdate;
	}
};

};
#endif
