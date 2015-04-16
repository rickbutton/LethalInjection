#ifndef _INCLUDE_SOURCEMOD_DETOUR_INFECTED_SHOVED_H_
#define _INCLUDE_SOURCEMOD_DETOUR_INFECTED_SHOVED_H_

#include "detour_template.h"

class Infected;

namespace Detours {

class InfectedShoved;
typedef void * (InfectedShoved::*InfectedShovedFunc)(Infected*, int entity);

class InfectedShoved : public DetourTemplate<InfectedShovedFunc, InfectedShoved>
{
private: //note: implementation of DetourTemplate abstracts

	void *OnInfectedShoved(Infected*, int);

	// get the signature name (i.e. "OnInfectedShoved") from the game conf
	virtual const char *GetSignatureName()
	{
		return "OnInfectedShoved";
	}

	//notify our patch system which function should be used as the detour
	virtual InfectedShovedFunc GetDetour()
	{
		return &InfectedShoved::OnInfectedShoved;
	}
};

};
#endif
