#ifndef _INCLUDE_SOURCEMOD_DETOUR_STAGGERED_H_
#define _INCLUDE_SOURCEMOD_DETOUR_STAGGERED_H_

#include "detour_template.h"

namespace Detours {

class PlayerStagger;

typedef int (PlayerStagger::*PlayerStaggerFunc)(CBaseEntity *, void *);

class PlayerStagger : public DetourTemplate<PlayerStaggerFunc, PlayerStagger>
{
private: //note: implementation of DetourTemplate abstracts

	int OnPlayerStagger(CBaseEntity *sourceEnt, void *sourceDir);

	// get the signature name (i.e. "CTerrorPlayer_OnStaggered") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CTerrorPlayer_OnStaggered";
	}

	//notify our patch system which function should be used as the detour
	virtual PlayerStaggerFunc GetDetour()
	{
		return &PlayerStagger::OnPlayerStagger;
	}
};

};
#endif
