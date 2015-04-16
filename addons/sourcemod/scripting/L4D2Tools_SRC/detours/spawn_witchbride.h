#ifndef _INCLUDE_SOURCEMOD_DETOUR_SPAWN_WITCHBRIDE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SPAWN_WITCHBRIDE_H_

#include "detour_template.h"

namespace Detours {

class SpawnWitchBride;
typedef void * (SpawnWitchBride::*SpawnWitchBrideFunc)(void *, void*);

class SpawnWitchBride : public DetourTemplate<SpawnWitchBrideFunc, SpawnWitchBride>
{
private: //note: implementation of DetourTemplate abstracts

	void *OnSpawnWitchBride(void *vector, void *qangle);

	// get the signature name (i.e. "SpawnWitch") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SpawnWitchBride";
	}

	//notify our patch system which function should be used as the detour
	virtual SpawnWitchBrideFunc GetDetour()
	{
		return &SpawnWitchBride::OnSpawnWitchBride;
	}
};

};
#endif
