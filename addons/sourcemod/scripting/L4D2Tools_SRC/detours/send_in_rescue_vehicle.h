#ifndef _INCLUDE_SOURCEMOD_DETOUR_SendInRescueVehicle_H_
#define _INCLUDE_SOURCEMOD_DETOUR_SendInRescueVehicle_H_

#include "detour_template.h"

namespace Detours {

class SendInRescueVehicle;
typedef void (SendInRescueVehicle::*SendInRescueVehicleFunc)();

class SendInRescueVehicle : public DetourTemplate<SendInRescueVehicleFunc, SendInRescueVehicle>
{
private: //note: implementation of DetourTemplate abstracts

	void OnSendInRescueVehicle();

	// get the signature name (i.e. "OnSendInRescueVehicle") from the game conf
	virtual const char *GetSignatureName()
	{
		return "SendInRescueVehicle";
	}

	//notify our patch system which function should be used as the detour
	virtual SendInRescueVehicleFunc GetDetour()
	{
		return &SendInRescueVehicle::OnSendInRescueVehicle;
	}
};

};
#endif
