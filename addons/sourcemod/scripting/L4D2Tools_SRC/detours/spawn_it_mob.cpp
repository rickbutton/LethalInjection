#include "spawn_it_mob.h"
#include "extension.h"

namespace Detours
{
	void SpawnITMob::OnSpawnITMob(int amount)
	{
		L4D_DEBUG_LOG("ZombieManager::SpawnITMob(%d) has been called", amount);

		cell_t result = Pl_Continue;
		if(g_pFwdOnSpawnITMob)
		{
			L4D_DEBUG_LOG("L4D_OnSpawnITMob() forward has been sent out");
			g_pFwdOnSpawnITMob->PushCellByRef(&amount);
			g_pFwdOnSpawnITMob->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("ZombieManager::SpawnITMob will be skipped");
			return;
		}
		else
		{
			(this->*(GetTrampoline()))(amount);
			return;
		}
	}
};
