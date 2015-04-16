#ifndef _INCLUDE_SOURCEMOD_DETOUR_WITCH_KILL_INCAP_VICTIM_H_
#define _INCLUDE_SOURCEMOD_DETOUR_WITCH_KILL_INCAP_VICTIM_H_

#include "detour_template.h"
#include "use_healing_items.h"

class Witch;

namespace Detours {

class WitchKillIncapVictim;

typedef ActionStruct_t (WitchKillIncapVictim::*WitchKillIncapVictimFunc)(Witch* pWitch, float);

class WitchKillIncapVictim : public DetourTemplate<WitchKillIncapVictimFunc, WitchKillIncapVictim>
{
private: //note: implementation of DetourTemplate abstracts

	ActionStruct_t OnWitchKillIncapVictim(Witch*, float);

	// get the signature name (i.e. "UseHealingItems") from the game conf
	virtual const char *GetSignatureName()
	{
		return "WitchKillIncapVictim::Update";
	}

	//notify our patch system which function should be used as the detour
	virtual WitchKillIncapVictimFunc GetDetour()
	{
		return &WitchKillIncapVictim::OnWitchKillIncapVictim;
	}
};

};
#endif
