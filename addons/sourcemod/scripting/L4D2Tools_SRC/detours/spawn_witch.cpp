#include "spawn_witch.h"
#include "extension.h"

namespace Detours
{
	void *SpawnWitch::OnSpawnWitch(void *vector, void *qangle)
	{
		L4D_DEBUG_LOG("ZombieManager::SpawnWitch has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnSpawnWitch)
		{
			L4D_DEBUG_LOG("L4D_OnSpawnWitch forward has been sent out");
			g_pFwdOnSpawnWitch->PushArray(reinterpret_cast<cell_t*>(vector), 3);
			g_pFwdOnSpawnWitch->PushArray(reinterpret_cast<cell_t*>(qangle), 3);
			g_pFwdOnSpawnWitch->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("ZombieManager::SpawnWitch will be skipped");
			return NULL;
		}
		else
		{
			return (this->*(GetTrampoline()))(vector, qangle);
		}
	}
};
