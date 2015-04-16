#ifndef _INCLUDE_SOURCEMOD_DETOUR_ON_NAV_AREA_CHANGED_H_
#define _INCLUDE_SOURCEMOD_DETOUR_ON_NAV_AREA_CHANGED_H_
 
#include "detour_template.h"
 
namespace Detours {

class NavAreaChanged;
 
typedef void (NavAreaChanged::*NavAreaChangedFunc)(int, int);
 
class NavAreaChanged: public DetourTemplate<NavAreaChangedFunc, NavAreaChanged>
{
	private: //note: implementation of DetourTemplate abstracts
 
	void OnNavAreaChanged(int CNavArea1, int CNavArea2);
 
 	// get the signature name (i.e. "GetCrouchTopSpeed") from the game conf
 	virtual const char *GetSignatureName()
 	{
		return "CTerrorPlayer_OnNavAreaChanged";
 	}
 
 	//notify our patch system which function should be used as the detour
	virtual NavAreaChangedFunc GetDetour()
 	{
		return &NavAreaChanged::OnNavAreaChanged;
 	}
};

};
#endif