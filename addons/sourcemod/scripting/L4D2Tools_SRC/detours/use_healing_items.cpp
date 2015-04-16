#include "use_healing_items.h"
#include "extension.h"

namespace Detours
{
	class VfuncEmptyClass {};
	char* ActionGetFullName(void* pAction)
	{
		void **this_ptr = *(void ***)&pAction;
		void **vtable = *(void ***)pAction;
		void *func = vtable[42]; 

		union {char *(VfuncEmptyClass::*mfpnew)();
#ifndef __linux__
		void *addr;	} u; 	u.addr = func;
#else
		struct {void *addr; intptr_t adjustor;} s; } u; u.s.addr = func; u.s.adjustor = 0;
#endif

		return (char *) (reinterpret_cast<VfuncEmptyClass*>(this_ptr)->*u.mfpnew)();
	}
	ActionStruct_t UseHealingItems::OnUseHealingItems(ActionSurvivorBot* pAction)
	{
		cell_t result = Pl_Continue;
		if(g_pFwdOnUseHealingItems)
		{
			edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
			int client = IndexOfEdict(pEntity);
			g_pFwdOnUseHealingItems->PushCell(client);
			g_pFwdOnUseHealingItems->Execute(&result);
		}

		if(result == Pl_Handled)
		{
			ActionStruct_t blank = {0,0,0};
			return blank;
		}
		else
		{
			ActionStruct_t ActionResult = (this->*(GetTrampoline()))(pAction);
			if(g_pFwdOnUseHealingItemsPost)
			{

				edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
				int client = IndexOfEdict(pEntity);
				g_pFwdOnUseHealingItemsPost->PushCell(client);

				g_pFwdOnUseHealingItemsPost->PushCell(ActionResult.ActionState);
				char* strDebugString = NULL;

				if (pAction)
				{
					L4D_DEBUG_LOG("Getting Action Name (%x)...", pAction);
					strDebugString = ActionGetFullName(pAction);
				}

				if (ActionResult.ActionState && ActionResult.ActionToTake)
				{
					L4D_DEBUG_LOG("Getting New Action (%d) Name (%x)...", ActionResult.ActionState, ActionResult.ActionToTake);
				}

				if (strDebugString)
				{
					g_pFwdOnUseHealingItemsPost->PushString(strDebugString);
				}
				else
				{
					g_pFwdOnUseHealingItemsPost->PushString("NULL");
				}
				L4D_DEBUG_LOG("L4D2_OnUseHealingItemsPost(client %d, ActionState %d, FullName %s) forward has been sent out", client, ActionResult.ActionState, strDebugString);
				g_pFwdOnUseHealingItemsPost->Execute(&result);
			}
			return ActionResult;
		}
	}
};
