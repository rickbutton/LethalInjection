#ifndef _INCLUDE_SOURCEMOD_DETOUR_PLAYER_USE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_PLAYER_USE_H_

#include "detour_template.h"

namespace Detours {

class PlayerUse;
typedef void* (PlayerUse::*PlayerUseFunc)(CBaseEntity*);

class PlayerUse : public DetourTemplate<PlayerUseFunc, PlayerUse>
{
private: //note: implementation of DetourTemplate abstracts

	void *OnPlayerUse(CBaseEntity *p);

	// get the signature name (i.e. "CTerrorPlayer_OnPlayerUse") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CTerrorPlayer_PlayerUse";
	}

	//notify our patch system which function should be used as the detour
	virtual PlayerUseFunc GetDetour()
	{
		return &PlayerUse::OnPlayerUse;
	}
};

};
#endif
