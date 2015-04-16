#ifndef _INCLUDE_SOURCEMOD_DETOUR_SPAWN_IT_MOB_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SPAWN_IT_MOB_H_

#include "detour_template.h"

namespace Detours {

class SpawnITMob;
typedef void (SpawnITMob::*SpawnITMobFunc)(int);

class SpawnITMob : public DetourTemplate<SpawnITMobFunc, SpawnITMob>
{
private: //note: implementation of DetourTemplate abstracts

	void OnSpawnITMob(int);

	// get the signature name (i.e. "OnSpawnITMob") from the game conf
	virtual const char *GetSignatureName()
	{
		return "Zombiemanager_SpawnITMob";
	}

	//notify our patch system which function should be used as the detour
	virtual SpawnITMobFunc GetDetour()
	{
		return &SpawnITMob::OnSpawnITMob;
	}
};

};
#endif
