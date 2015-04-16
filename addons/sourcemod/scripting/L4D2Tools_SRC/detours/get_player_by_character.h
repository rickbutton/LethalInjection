#ifndef _INCLUDE_SOURCEMOD_DETOUR_GET_PLAYER_BY_CHARACTER_H_
#define _INCLUDE_SOURCEMOD_DETOUR_GET_PLAYER_BY_CHARACTER_H_

#include "detour_template.h"

class Character;

namespace Detours {

class GetPlayerByCharacter;
typedef void* (GetPlayerByCharacter::*GetPlayerByCharacterFunc)(int fu, Character* character);

class GetPlayerByCharacter : public DetourTemplate<GetPlayerByCharacterFunc, GetPlayerByCharacter>
{
private: //note: implementation of DetourTemplate abstracts

	void* OnGetPlayerByCharacter(int, Character*);

	// get the signature name (i.e. "GetPlayerByCharacter") from the game conf
	virtual const char *GetSignatureName()
	{
		return "GetPlayerByCharacter";
	}

	//notify our patch system which function should be used as the detour
	virtual GetPlayerByCharacterFunc GetDetour()
	{
		return &GetPlayerByCharacter::OnGetPlayerByCharacter;
	}
};

};
#endif