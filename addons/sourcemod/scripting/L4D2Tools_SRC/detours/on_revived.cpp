#include "on_revived.h"
#include "extension.h"

namespace Detours
{
	int Revived::OnRevived()
	{
		cell_t result = Pl_Continue;

		int actualInvocationResult = (this->*(GetTrampoline()))();

		if(g_pFwdOnRevived)
		{
			edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
			int target = IndexOfEdict(pEntity);
		
			g_pFwdOnRevived->PushCell(target);
			g_pFwdOnRevived->Execute(&result);
		}

		return actualInvocationResult;
	}
};
