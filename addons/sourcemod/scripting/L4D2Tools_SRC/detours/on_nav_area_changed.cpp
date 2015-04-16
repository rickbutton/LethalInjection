#include "on_nav_area_changed.h"
#include "extension.h"
 
namespace Detours
{
	void NavAreaChanged::OnNavAreaChanged(int CNavArea1, int CNavArea2)
 	{
 		cell_t result = Pl_Continue;
 
		if(g_pFwdOnNavAreaChanged)
 		{
 			edict_t *pEntity = gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity*>(this));
 			int client = IndexOfEdict(pEntity);
 		
			g_pFwdOnNavAreaChanged->PushCell(client);
			g_pFwdOnNavAreaChanged->PushCellByRef(&CNavArea1);
			g_pFwdOnNavAreaChanged->PushCellByRef(&CNavArea2);
			g_pFwdOnNavAreaChanged->Execute(&result);
 		}
 
		(this->*(GetTrampoline()))(CNavArea1, CNavArea2);
 	}
 };