#ifndef _INCLUDE_SOURCEMOD_DETOUR_ON_REVIVED_H_
#define _INCLUDE_SOURCEMOD_DETOUR_ON_REVIVED_H_

#include "detour_template.h"

namespace Detours {
	
class Revived;

typedef int (Revived::*RevivedFunc)();

class Revived: public DetourTemplate<RevivedFunc, Revived>
{
private: //note: implementation of DetourTemplate abstracts

	int OnRevived();

	// get the signature name (i.e. "GetCrouchTopSpeed") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CTerrorPlayer_OnRevived";
	}

	//notify our patch system which function should be used as the detour
	virtual RevivedFunc GetDetour()
	{
		return &Revived::OnRevived;
	}
};

};
#endif
