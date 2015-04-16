#ifndef _INCLUDE_SOURCEMOD_DETOUR_SHOVED_BY_SURVIVOR_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SHOVED_BY_SURVIVOR_H_

#include "detour_template.h"

namespace Detours {

class ShovedBySurvivor;

typedef int (ShovedBySurvivor::*ShovedBySurvivorFunc)(CBaseEntity *, void *);

class ShovedBySurvivor : public DetourTemplate<ShovedBySurvivorFunc, ShovedBySurvivor>
{
private: //note: implementation of DetourTemplate abstracts

	int OnShovedBySurvivor(CBaseEntity *sourceEnt, void *sourceDir);

	// get the signature name (i.e. "CTerrorPlayer_OnShovedBySurvivor") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CTerrorPlayer_OnShovedBySurvivor";
	}

	//notify our patch system which function should be used as the detour
	virtual ShovedBySurvivorFunc GetDetour()
	{
		return &ShovedBySurvivor::OnShovedBySurvivor;
	}
};

};
#endif
