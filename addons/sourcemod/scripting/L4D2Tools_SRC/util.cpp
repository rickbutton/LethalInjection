#include <stdarg.h>
#include <stdio.h>

#include "extension.h"
#include "util.h"

size_t UTIL_Format(char *buffer, size_t maxlength, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	size_t len = vsnprintf(buffer, maxlength, fmt, ap);
	va_end(ap);

	if (len >= maxlength)
	{
		buffer[maxlength - 1] = '\0';
		return (maxlength - 1);
	}
	else
	{
		return len;
	}
}

/* Taken from Sourcemod Tf2 Extension */
CBaseEntity *UTIL_GetCBaseEntity(int num, bool onlyPlayers)
{
	edict_t *pEdict = PEntityOfEntIndex(num);
	if (!pEdict || pEdict->IsFree())
	{
		return NULL;
	}

	if (num > 0 && num <= playerhelpers->GetMaxClients())
	{
		IGamePlayer *pPlayer = playerhelpers->GetGamePlayer(pEdict);
		if (!pPlayer || !pPlayer->IsConnected())
		{
			return NULL;
		}
	}
	else if (onlyPlayers)
	{
		return NULL;
	}

	IServerUnknown *pUnk;
	if ((pUnk=pEdict->GetUnknown()) == NULL)
	{
		return NULL;
	}

	return pUnk->GetBaseEntity();
}
