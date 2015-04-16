#ifndef _INCLUDE_SOURCEMOD_DETOUR_GET_CROUCH_TOP_SPEED_H_
#define _INCLUDE_SOURCEMOD_DETOUR_GET_CROUCH_TOP_SPEED_H_

#include "detour_template.h"

namespace Detours {
	
class GetCrouchTopSpeed;

typedef float (GetCrouchTopSpeed::*GetCrouchTopSpeedFunc)();

class GetCrouchTopSpeed : public DetourTemplate<GetCrouchTopSpeedFunc, GetCrouchTopSpeed>
{
private: //note: implementation of DetourTemplate abstracts

	float OnGetCrouchTopSpeed();

	// get the signature name (i.e. "GetCrouchTopSpeed") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CTerrorPlayer_GetCrouchTopSpeed";
	}

	//notify our patch system which function should be used as the detour
	virtual GetCrouchTopSpeedFunc GetDetour()
	{
		return &GetCrouchTopSpeed::OnGetCrouchTopSpeed;
	}
};

};
#endif
