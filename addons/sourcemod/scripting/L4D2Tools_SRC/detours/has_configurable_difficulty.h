#ifndef _INCLUDE_SOURCEMOD_DETOUR_HAS_CONFIGURABLE_DIFFICULTY_H_
#define _INCLUDE_SOURCEMOD_DETOUR_HAS_CONFIGURABLE_DIFFICULTY_H_

#include "detour_template.h"

namespace Detours {
	
class HasConfigurableDifficulty;

typedef int (HasConfigurableDifficulty::*HasConfigurableDifficultyFunc)();

class HasConfigurableDifficulty : public DetourTemplate<HasConfigurableDifficultyFunc, HasConfigurableDifficulty>
{
private: //note: implementation of DetourTemplate abstracts

	int OnHasConfigurableDifficulty();

	// get the signature name (i.e. "HasConfigurableDifficulty") from the game conf
	virtual const char * GetSignatureName()
	{
		return "HasConfigurableDifficulty";
	}

	//notify our patch system which function should be used as the detour
	virtual HasConfigurableDifficultyFunc GetDetour()
	{
		return &HasConfigurableDifficulty::OnHasConfigurableDifficulty;
	}
};

};
#endif
