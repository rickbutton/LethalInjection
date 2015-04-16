#include "send_in_rescue_vehicle.h"
#include "extension.h"

namespace Detours
{
	void SendInRescueVehicle::OnSendInRescueVehicle()
	{
		L4D_DEBUG_LOG("SendInRescueVehicle has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnSendInRescueVehicle)
		{
			L4D_DEBUG_LOG("L4D2_OnSendInRescueVehicle() forward has been sent out");
			g_pFwdOnSendInRescueVehicle->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("SendInRescueVehicle will be skipped");
			return;
		}
		else
		{
			(this->*(GetTrampoline()))();
			return;
		}
	}
};
