#ifndef _INCLUDE_SOURCEMOD_DETOUR_MOBRUSHSTART_H_
#define _INCLUDE_SOURCEMOD_DETOUR_MOBRUSHSTART_H_

#include "detour_template.h"

namespace Detours {

class MobRushStart;
typedef void (MobRushStart::*MobRushStartFunc)();

class MobRushStart : public DetourTemplate<MobRushStartFunc, MobRushStart>
{
private: //note: implementation of DetourTemplate abstracts

	void OnMobRushStart();

	// get the signature name (i.e. "OnMobRushStart") from the game conf
	virtual const char *GetSignatureName()
	{
		return "OnMobRushStart";
	}

	//notify our patch system which function should be used as the detour
	virtual MobRushStartFunc GetDetour()
	{
		return &MobRushStart::OnMobRushStart;
	}
};

};
#endif
