#ifndef _INCLUDE_SOURCEMOD_DETOUR_START_MELEE_SWING_H_
#define _INCLUDE_SOURCEMOD_DETOUR_START_MELEE_SWING_H_

#include "detour_template.h"

class CTerrorPlayer;

namespace Detours {

class StartMeleeSwing;
typedef void * (StartMeleeSwing::*StartMeleeSwingFunc)(CTerrorPlayer*, int boolean);

class StartMeleeSwing : public DetourTemplate<StartMeleeSwingFunc, StartMeleeSwing>
{
private: //note: implementation of DetourTemplate abstracts

	void *OnStartMeleeSwing(CTerrorPlayer*, int);

	// get the signature name (i.e. "StartMeleeSwing") from the game conf
	virtual const char *GetSignatureName()
	{
		return "StartMeleeSwing";
	}

	//notify our patch system which function should be used as the detour
	virtual StartMeleeSwingFunc GetDetour()
	{
		return &StartMeleeSwing::OnStartMeleeSwing;
	}
};

};
#endif
