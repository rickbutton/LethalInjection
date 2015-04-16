#ifndef _INCLUDE_SOURCEMOD_DETOUR_GET_WALK_TOP_SPEED_H_
#define _INCLUDE_SOURCEMOD_DETOUR_GET_WALK_TOP_SPEED_H_

#include "detour_template.h"

namespace Detours {
	
class GetWalkTopSpeed;

typedef float (GetWalkTopSpeed::*GetWalkTopSpeedFunc)();

class GetWalkTopSpeed : public DetourTemplate<GetWalkTopSpeedFunc, GetWalkTopSpeed>
{
private: //note: implementation of DetourTemplate abstracts

	float OnGetWalkTopSpeed();

	// get the signature name (i.e. "GetWalkTopSpeed") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CTerrorPlayer_GetWalkTopSpeed";
	}

	//notify our patch system which function should be used as the detour
	virtual GetWalkTopSpeedFunc GetDetour()
	{
		return &GetWalkTopSpeed::OnGetWalkTopSpeed;
	}
};

};
#endif
