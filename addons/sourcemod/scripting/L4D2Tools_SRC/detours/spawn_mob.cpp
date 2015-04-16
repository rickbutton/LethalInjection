#include "spawn_mob.h"
#include "extension.h"

namespace Detours
{
	void SpawnMob::OnSpawnMob(int amount)
	{
		L4D_DEBUG_LOG("ZombieManager::SpawnMob(%d) has been called", amount);

		cell_t result = Pl_Continue;
		if(g_pFwdOnSpawnMob)
		{
			L4D_DEBUG_LOG("L4D_OnSpawnMob() forward has been sent out");
			g_pFwdOnSpawnMob->PushCellByRef(&amount);
			g_pFwdOnSpawnMob->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("ZombieManager::SpawnMob will be skipped");
			return;
		}
		else
		{
			(this->*(GetTrampoline()))(amount);
			return;
		}
	}
};
