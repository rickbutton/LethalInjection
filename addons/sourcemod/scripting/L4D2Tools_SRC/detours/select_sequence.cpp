#include "select_sequence.h"
#include "extension.h"

namespace Detours
{
	int SelectSequence::OnSelectSequence(int Activity)
	{
		//L4D_DEBUG_LOG("SelectTankAttack(%d) has been called", Activity);
		cell_t result = Pl_Continue;
		int actualSequence;
		actualSequence = (this->*(GetTrampoline()))(Activity);

		int overrideSequence = actualSequence;
		if (g_pFwdOnSelectSequence)
		{
			edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
			int client = IndexOfEdict(pEntity);
			L4D_DEBUG_LOG("L4D2_OnSelectSequence(client %d, sequence %d) forward has been sent out", client, overrideSequence);
			g_pFwdOnSelectSequence->PushCell(client);
			g_pFwdOnSelectSequence->PushCellByRef(&overrideSequence);
			g_pFwdOnSelectSequence->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			L4D_DEBUG_LOG("SelectSequence() return value overriden with %d", overrideSequence);
			return overrideSequence;
		}
		else
		{
			return actualSequence;
		}
	}
};
