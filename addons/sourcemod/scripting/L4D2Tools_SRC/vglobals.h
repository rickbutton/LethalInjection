#ifndef _INCLUDE_L4D2TOOLS_VGLOBALS_H_
#define _INCLUDE_L4D2TOOLS_VGLOBALS_H_
#include "l4d2sdk/director.h"

extern CDirector **g_pDirector;	/*Director*/
extern void *g_pZombieManager;	/*ZombieManager*/

void InitializeValveGlobals();

#endif
