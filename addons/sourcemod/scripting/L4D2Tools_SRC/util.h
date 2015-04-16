#ifndef _INCLUDE_L4D2TOOLS_UTIL_H_
#define _INCLUDE_L4D2TOOLS_UTIL_H_

#define REGISTER_NATIVE_ADDR(name, code) \
	void *addr; \
	if (!g_pGameConf->GetMemSig(name, &addr) || !addr) \
	{ \
		return pContext->ThrowNativeError("Failed to locate function " #name); \
	} \
	code; 


size_t UTIL_Format(char *buffer, size_t maxlength, const char *fmt, ...);

/* Taken from Sourcemod Tf2 Extension */
CBaseEntity *UTIL_GetCBaseEntity(int num, bool onlyPlayers);

#endif
