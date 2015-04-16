#ifndef _INCLUDE_SOURCEMOD_DETOUR_SPAWN_WITCH_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SPAWN_WITCH_H_

#include "detour_template.h"

namespace Detours {

class SpawnWitch;
typedef void * (SpawnWitch::*SpawnWitchFunc)(void *, void*);

class SpawnWitch : public DetourTemplate<SpawnWitchFunc, SpawnWitch>
{
private: //note: implementation of DetourTemplate abstracts

	void *OnSpawnWitch(void *vector, void *qangle);

	// get the signature name (i.e. "SpawnWitch") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SpawnWitch";
	}

	//notify our patch system which function should be used as the detour
	virtual SpawnWitchFunc GetDetour()
	{
		return &SpawnWitch::OnSpawnWitch;
	}
};

};
#endif
