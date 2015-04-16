#include "patchmanager.h"
#include "extension.h"

/* 
	register a code patch
*/
void PatchManager::Register(ICodePatch* patch)
{
	patchList.push_back(patch);
}

/*
	unregister all code patches, deleting every one of them
*/
void PatchManager::UnregisterAll()
{
	L4D_DEBUG_LOG("PatchManager::UnregisterAll()");

	for(PatchList::iterator iter = patchList.begin(); iter != patchList.end(); ++iter)
	{
		L4D_DEBUG_LOG("PatchManager deleted a patch");

		ICodePatch *patch = *iter;
		delete patch;
	}

	patchList.clear();
}

PatchManager::~PatchManager()
{
	UnregisterAll();
}
