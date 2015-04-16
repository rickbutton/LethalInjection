#ifndef _INCLUDE_SOURCEMOD_PATCH_MANAGER_H_
#define _INCLUDE_SOURCEMOD_PATCH_MANAGER_H_

#include <sh_list.h>
#include "icodepatch.h"

/*
Use this class to automatically clean up the patches when the extension is unloaded
*/
class PatchManager
{
public:
	~PatchManager();

	/* 
		register a code patch
	*/
	void Register(ICodePatch* patch);

	/*
		unregister all code patches, calling delete on each
	*/
	void UnregisterAll();

private:
	typedef SourceHook::List<ICodePatch*> PatchList;

	PatchList patchList;
};

#endif
