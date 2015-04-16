#include "spawn_tank.h"
#include "extension.h"

namespace Detours
{
	void *SpawnTank::OnSpawnTank(void *vector, void *qangle)
	{
		L4D_DEBUG_LOG("ZombieManager::SpawnTank has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnSpawnTank)
		{
			L4D_DEBUG_LOG("L4D_OnTankSpawn forward has been sent out");
			g_pFwdOnSpawnTank->PushArray(reinterpret_cast<cell_t*>(vector), 3);
			g_pFwdOnSpawnTank->PushArray(reinterpret_cast<cell_t*>(qangle), 3);
			g_pFwdOnSpawnTank->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("ZombieManager::SpawnTank will be skipped");
			return NULL;
		}
		else
		{
			return (this->*(GetTrampoline()))(vector, qangle);
		}
	}
};
