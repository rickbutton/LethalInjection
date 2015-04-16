#ifndef _INCLUDE_SOURCEMOD_DETOUR_CTHROWACTIVATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_CTHROWACTIVATE_H_

#include "detour_template.h"

namespace Detours {

class CThrowActivate;
typedef void (CThrowActivate::*CThrowActivateFunc)();

class CThrowActivate : public DetourTemplate<CThrowActivateFunc, CThrowActivate>
{
private: //note: implementation of DetourTemplate abstracts

	void OnCThrowActivate();

	// get the signature name (i.e. "CThrowActivate") from the game conf
	virtual const char *GetSignatureName()
	{
		return "CThrowActivate";
	}

	//notify our patch system which function should be used as the detour
	virtual CThrowActivateFunc GetDetour()
	{
		return &CThrowActivate::OnCThrowActivate;
	}
};

};
#endif
