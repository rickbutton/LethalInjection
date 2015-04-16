#include "witch_kill_incap_victim.h"
#include "extension.h"

namespace Detours
{
	ActionStruct_t WitchKillIncapVictim::OnWitchKillIncapVictim(Witch* pWitch, float fu)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnWitchKillIncapVictim)
		{
			edict_t *pWitchEdict = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(pWitch));
			cell_t entity = IndexOfEdict(pWitchEdict);
			cell_t victim = *(reinterpret_cast<cell_t*>(this)+13);
			g_pFwdOnWitchKillIncapVictim->PushCell(entity);
			g_pFwdOnWitchKillIncapVictim->PushCellByRef(&victim);
			g_pFwdOnWitchKillIncapVictim->Execute(&result);
			if (result == Pl_Changed)
			{
				*(reinterpret_cast<DWORD*>(this)+13) = victim;
			}
		}
		ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pWitch, fu);
		return ActionResult;
	}
};