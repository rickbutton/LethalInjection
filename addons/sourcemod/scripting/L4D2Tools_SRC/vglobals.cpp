#include "vglobals.h"
#include "extension.h"
#include "util.h"

CDirector **g_pDirector = NULL;
void *g_pZombieManager = NULL;

void InitializeValveGlobals()
{
	char *addr = NULL;
	int offset = NULL;

	L4D_DEBUG_LOG("InitializeValveGlobals() running");

	const char *directorConfKey = "DirectorMusicBanks_OnRoundStart";
	if (!g_pGameConf->GetMemSig(directorConfKey, (void **)&addr) || !addr)
	{
		return;
	}
	if (!g_pGameConf->GetOffset("TheDirector", &offset) || !offset)
	{
		return;
	}
	g_pDirector = *reinterpret_cast<CDirector ***>(addr + offset);

	if (!g_pGameConf->GetAddress("CZombieManager", (void **)&addr) || !addr)
	{
		L4D_DEBUG_LOG("CZombieManager address not found.");
		return;
	}
	g_pZombieManager = addr;
	L4D_DEBUG_LOG("ZombieManager found at: %p", g_pZombieManager);
}
