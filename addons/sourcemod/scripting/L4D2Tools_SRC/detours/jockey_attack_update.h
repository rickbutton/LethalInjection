#ifndef _INCLUDE_SOURCEMOD_DETOUR_JOCKEY_ATTACK_UPDATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_JOCKEY_ATTACK_UPDATE_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Jockey;

namespace Detours {

class JockeyAttackUpdate;

typedef ActionStruct_t (JockeyAttackUpdate::*JockeyAttackUpdateFunc)(Jockey* pJockey, float);

class JockeyAttackUpdate : public DetourTemplate<JockeyAttackUpdateFunc, JockeyAttackUpdate>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnJockeyAttackUpdate(Jockey*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "JockeyAttack::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual JockeyAttackUpdateFunc GetDetour()
	{
		return &JockeyAttackUpdate::OnJockeyAttackUpdate;
	}
};

};
#endif
