#include "terror_weapon_hit.h"
#include "extension.h"

namespace Detours
{
    void *TerrorWeaponHit::OnTerrorWeaponHit(CGameTrace *trace/* a1 */, void *vector/* a2 */, bool userCall/* a3 */)
    {
        L4D_DEBUG_LOG("CTerrorWeapon::OnHit() has been called");
        cell_t result = Pl_Continue;

        int hEntity = *(int *)((unsigned char*)trace + 76);    // did the m2 trace hit anyone(i.e. an entity)
        /*  
            deadstop check: see if it's going to be versus_shove_hunter_fov_pouncing(true) or versus_shove_hunter_fov(false)
            often returns 0 when it shouldn't  - either this shit is unreliable, or the game is buggy as fuck
            probably both
        */
        int isDeadstop = *(int *)((unsigned char *)hEntity + 16024);
        int weapon = IndexOfEdict(gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity *>(this)));
        int entity = IndexOfEdict(gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity *>(hEntity)));
        CBaseHandle &weaponOwner = *(CBaseHandle *)((unsigned char *)this + 5108);  // get the weapon's owner and thus check its validity(shoves are a secondary attack of anything you're able to hold, even pills and cola)
        int client = !weaponOwner.IsValid() ? -1 : weaponOwner.GetEntryIndex();   // very simplistic and unreliable check, but meh
        /* there's another check being performed here to see if the current gamemode allows bashing... we don't need it */
        if (g_pFwdOnTerrorWeaponHit && client && entity && userCall)
        {
            g_pFwdOnTerrorWeaponHit->PushCell(client); // who shoved
            g_pFwdOnTerrorWeaponHit->PushCell(entity); // who got shoved
            g_pFwdOnTerrorWeaponHit->PushCell(weapon); // weapon that's been held while shoving
            g_pFwdOnTerrorWeaponHit->PushArray(reinterpret_cast<cell_t *>(vector), 3); // shove angles
            g_pFwdOnTerrorWeaponHit->PushCell(isDeadstop ? true : false); // reliable for high pounces only
            g_pFwdOnTerrorWeaponHit->Execute(&result);
        }

        if(result == Pl_Handled)
        {
            L4D_DEBUG_LOG("CTerrorWeapon::OnHit() will be skipped");
            return NULL;
        }
        else
        {
            return (this->*(GetTrampoline()))(trace, vector, userCall);
        }
    }
};