#ifndef _INCLUDE_SOURCEMOD_DETOUR_VERSUS_ROUND_STARTED_H_
#define _INCLUDE_SOURCEMOD_DETOUR_VERSUS_ROUND_STARTED_H_

#include "detour_template.h"

class CTerrorPlayer;

namespace Detours {

class FirstSurvivorLeftSafeArea;
typedef void * (FirstSurvivorLeftSafeArea::*FirstSurvivorLeftSafeAreaFunc)(CTerrorPlayer*);

class FirstSurvivorLeftSafeArea : public DetourTemplate<FirstSurvivorLeftSafeAreaFunc, FirstSurvivorLeftSafeArea>
{
private: //note: implementation of DetourTemplate abstracts

	void *OnFirstSurvivorLeftSafeArea(CTerrorPlayer*);

	// get the signature name (i.e. "FirstSurvivorLeftSafeArea") from the game conf
	virtual const char *GetSignatureName()
	{
		return "OnFirstSurvivorLeftSafeArea";
	}

	//notify our patch system which function should be used as the detour
	virtual FirstSurvivorLeftSafeAreaFunc GetDetour()
	{
		return &FirstSurvivorLeftSafeArea::OnFirstSurvivorLeftSafeArea;
	}
};

};
#endif
