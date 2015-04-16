#include "extension.h"
#include "vglobals.h"

cell_t L4D2_GetTankCount(IPluginContext *pContext, const cell_t *params)
{
	if (g_pDirector == NULL)
	{
		return pContext->ThrowNativeError("Director unsupported or not available; file a bug report");
	}

	CDirector *director = *g_pDirector;

	if (director == NULL)
	{
		return pContext->ThrowNativeError("Director not available before map is loaded");
	}
	return director->m_iTankCount;
}

sp_nativeinfo_t  g_L4DoDirectorNatives[] = 
{
	{"L4D2_GetTankCount",				L4D2_GetTankCount},
	{NULL,										NULL}
};
