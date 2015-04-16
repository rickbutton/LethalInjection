#ifndef _INCLUDE_SOURCEMOD_DETOUR_GET_RUN_TOP_SPEED_H_
#define _INCLUDE_SOURCEMOD_DETOUR_GET_RUN_TOP_SPEED_H_

#include "detour_template.h"

namespace Detours {
	
class GetRunTopSpeed;

typedef float (GetRunTopSpeed::*GetRunTopSpeedFunc)();

class GetRunTopSpeed : public DetourTemplate<GetRunTopSpeedFunc, GetRunTopSpeed>
{
private: //note: implementation of DetourTemplate abstracts

	float OnGetRunTopSpeed();

	// get the signature name (i.e. "GetRunTopSpeed") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CTerrorPlayer_GetRunTopSpeed";
	}

	//notify our patch system which function should be used as the detour
	virtual GetRunTopSpeedFunc GetDetour()
	{
		return &GetRunTopSpeed::OnGetRunTopSpeed;
	}
};

};
#endif
