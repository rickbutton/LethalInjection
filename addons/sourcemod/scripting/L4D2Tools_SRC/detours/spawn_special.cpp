#include "spawn_special.h"
#include "extension.h"

namespace Detours
{
	void *SpawnSpecial::OnSpawnSpecial(ZombieClassType zombieClassType, void *vector, void *qangle)
	{
		L4D_DEBUG_LOG("ZombieManager::SpawnSpecial has been called with class %d", zombieClassType);

		cell_t result = Pl_Continue;
		cell_t overrideZombieClass = zombieClassType;
		if(g_pFwdOnSpawnSpecial)
		{
			L4D_DEBUG_LOG("L4D_OnSpawnSpecial forward has been sent out");
			g_pFwdOnSpawnSpecial->PushCellByRef(&overrideZombieClass);
			g_pFwdOnSpawnSpecial->PushArray(reinterpret_cast<cell_t*>(vector), 3);
			g_pFwdOnSpawnSpecial->PushArray(reinterpret_cast<cell_t*>(qangle), 3);
			g_pFwdOnSpawnSpecial->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("ZombieManager::SpawnSpecial will be skipped");
			return NULL;
		}
		else if(result == Pl_Changed)
		{
			L4D_DEBUG_LOG("ZombieManager::SpawnSpecial will be called with class %d", overrideZombieClass);
			return (this->*(GetTrampoline()))(*reinterpret_cast<ZombieClassType*>(&overrideZombieClass), vector, qangle);
		}
		else
		{
			return (this->*(GetTrampoline()))(zombieClassType, vector, qangle);
		}
	}
};
