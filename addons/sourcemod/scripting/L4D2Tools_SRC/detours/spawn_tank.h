#ifndef _INCLUDE_SOURCEMOD_DETOUR_SPAWN_TANK_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SPAWN_TANK_H_

#include "detour_template.h"

namespace Detours {

class SpawnTank;
typedef void * (SpawnTank::*SpawnTankFunc)(void *, void*);

class SpawnTank : public DetourTemplate<SpawnTankFunc, SpawnTank>
{
private: //note: implementation of DetourTemplate abstracts

	void *OnSpawnTank(void *vector, void *qangle);

	// get the signature name (i.e. "SpawnTank") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SpawnTank";
	}

	//notify our patch system which function should be used as the detour
	virtual SpawnTankFunc GetDetour()
	{
		return &SpawnTank::OnSpawnTank;
	}
};

};

#endif
