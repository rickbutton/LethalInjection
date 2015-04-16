#ifndef _INCLUDE_SOURCEMOD_DETOUR_SPAWN_SPECIAL_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SPAWN_SPECIAL_H_

#include "detour_template.h"
#include "l4d2sdk/constants.h"

namespace Detours {

class SpawnSpecial;
typedef void * (SpawnSpecial::*SpawnSpecialFunc)(ZombieClassType, void *, void*);

class SpawnSpecial : public DetourTemplate<SpawnSpecialFunc, SpawnSpecial>
{
private: //note: implementation of DetourTemplate abstracts

	void *OnSpawnSpecial(ZombieClassType zombieClassType, void *vector, void *qangle);

	// get the signature name (i.e. "SpawnSpecial") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SpawnSpecial";
	}

	//notify our patch system which function should be used as the detour
	virtual SpawnSpecialFunc GetDetour()
	{
		return &SpawnSpecial::OnSpawnSpecial;
	}
};

};
#endif
