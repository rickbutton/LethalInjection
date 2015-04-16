#ifndef _INCLUDE_SOURCEMOD_DETOUR_SELECT_WEIGHTED_SEQUENCE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SELECT_WEIGHTED_SEQUENCE_H_

#include "detour_template.h"

class CTerrorPlayer;

namespace Detours {

class SelectSequence;

typedef int (SelectSequence::*SelectSequenceFunc)(int);

class SelectSequence : public DetourTemplate<SelectSequenceFunc, SelectSequence>
{
private: //note: implementation of DetourTemplate abstracts

	int OnSelectSequence(int);

	// get the signature name (i.e. "SelectWeightedSequence") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SelectWeightedSequence";
	}

	//notify our patch system which function should be used as the detour
	virtual SelectSequenceFunc GetDetour()
	{
		return &SelectSequence::OnSelectSequence;
	}
};

};

#endif
