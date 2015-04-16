#ifndef _INCLUDE_SOURCEMOD_DETOUR_SPAWN_MOB_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SPAWN_MOB_H_

#include "detour_template.h"

namespace Detours {

class SpawnMob;
typedef void (SpawnMob::*SpawnMobFunc)(int);

class SpawnMob : public DetourTemplate<SpawnMobFunc, SpawnMob>
{
private: //note: implementation of DetourTemplate abstracts

	void OnSpawnMob(int);

	// get the signature name from the game conf
	virtual const char *GetSignatureName()
	{
		return "Zombiemanager_SpawnMob";
	}

	//notify our patch system which function should be used as the detour
	virtual SpawnMobFunc GetDetour()
	{
		return &SpawnMob::OnSpawnMob;
	}
};

};
#endif
