#ifndef _INCLUDE_SOURCEMOD_DETOUR_CHANGE_FINALE_STAGE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_CHANGE_FINALE_STAGE_H_

#include "detour_template.h"

namespace Detours {
	
class ChangeFinaleStage;

typedef void (ChangeFinaleStage::*ChangeFinaleStageFunc)(int, const char*);

class ChangeFinaleStage : public DetourTemplate<ChangeFinaleStageFunc, ChangeFinaleStage>
{
private: //note: implementation of DetourTemplate abstracts

	void OnChangeFinaleStage(int, const char*);

	// get the signature name (i.e. "ChangeFinaleStage") from the game conf
	virtual const char *GetSignatureName()
	{
		return "ChangeFinaleStage";
	}

	//notify our patch system which function should be used as the detour
	virtual ChangeFinaleStageFunc GetDetour()
	{
		return &ChangeFinaleStage::OnChangeFinaleStage;
	}
};

};
#endif
