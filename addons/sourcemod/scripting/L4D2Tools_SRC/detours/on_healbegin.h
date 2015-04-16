#ifndef _INCLUDE_SOURCEMOD_DETOUR_HEALBEGIN_H_
#define _INCLUDE_SOURCEMOD_DETOUR_HEALBEGIN_H_

#include "detour_template.h"

namespace Detours {

class HealBegin;

typedef int (HealBegin::*HealBeginFunc)(CBaseEntity *);

class HealBegin : public DetourTemplate<HealBeginFunc, HealBegin>
{
private: //note: implementation of DetourTemplate abstracts

	int OnHealBegin(CBaseEntity *sourceEnt);

	// get the signature name (i.e. "CTerrorPlayer_OnHealBegin") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CTerrorPlayer_HealBegin";
	}

	//notify our patch system which function should be used as the detour
	virtual HealBeginFunc GetDetour()
	{
		return &HealBegin::OnHealBegin;
	}
};

};
#endif
