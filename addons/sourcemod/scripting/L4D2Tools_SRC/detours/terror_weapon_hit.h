#ifndef _INCLUDE_SOURCEMOD_DETOUR_TERROR_WEAPON_HIT_H_
#define _INCLUDE_SOURCEMOD_DETOUR_TERROR_WEAPON_HIT_H_

#include "detour_template.h"

class CGameTrace;

namespace Detours {

class TerrorWeaponHit;
typedef void * (TerrorWeaponHit::*TerrorWeaponHitFunc)(CGameTrace*, void*, bool);

class TerrorWeaponHit : public DetourTemplate<TerrorWeaponHitFunc, TerrorWeaponHit>
{
private: //note: implementation of DetourTemplate abstracts

    void *OnTerrorWeaponHit(CGameTrace*, void*, bool);

    // get the signature name from the game conf
    virtual const char *GetSignatureName()
    {
        return "CTerrorWeapon__OnHit";
    }

    //notify our patch system which function should be used as the detour
    virtual TerrorWeaponHitFunc GetDetour()
    {
        return &TerrorWeaponHit::OnTerrorWeaponHit;
    }
};

};
#endif