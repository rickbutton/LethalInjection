#ifndef _INCLUDE_SOURCEMOD_DETOUR_WITCH_RETREAT_H_
#define _INCLUDE_SOURCEMOD_DETOUR_WITCH_RETREAT_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Witch;

namespace Detours {

class WitchRetreat;

typedef ActionStruct_t (WitchRetreat::*WitchRetreatFunc)(Witch* pWitch, float);

class WitchRetreat : public DetourTemplate<WitchRetreatFunc, WitchRetreat>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnWitchRetreat(Witch*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "WitchRetreat::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual WitchRetreatFunc GetDetour()
	{
		return &WitchRetreat::OnWitchRetreat;
	}
};

};
#endif
