#include "spawn_witchbride.h"
#include "extension.h"

namespace Detours
{
	void *SpawnWitchBride::OnSpawnWitchBride(void *vector, void *qangle)
	{
		L4D_DEBUG_LOG("ZombieManager::SpawnWitchBride has been called");

		cell_t result = Pl_Continue;
		if(g_pFwdOnSpawnWitchBride)
		{
			L4D_DEBUG_LOG("L4D_OnSpawnWitchBride forward has been sent out");
			g_pFwdOnSpawnWitchBride->PushArray(reinterpret_cast<cell_t*>(vector), 3);
			g_pFwdOnSpawnWitchBride->PushArray(reinterpret_cast<cell_t*>(qangle), 3);
			g_pFwdOnSpawnWitchBride->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("ZombieManager::SpawnWitchBride will be skipped");
			return NULL;
		}
		else
		{
			return (this->*(GetTrampoline()))(vector, qangle);
		}
	}
};
