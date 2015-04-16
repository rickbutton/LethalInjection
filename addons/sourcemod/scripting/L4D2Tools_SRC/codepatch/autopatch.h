#ifndef _INCLUDE_SOURCEMOD_AUTOPATCH_H_
#define _INCLUDE_SOURCEMOD_AUTOPATCH_H_

/*
use this class to automatically construct a codepatch and then have it call patch
*/
template <typename TPatchable>
class AutoPatch : public ICodePatch
{
public:
	AutoPatch() : codePatch()
	{
		//L4D_DEBUG_LOG("AutoPatch constructor");
		Patch(); //note: codePatch.Unpatch() is called automatically by its own destructor.. if it wants to
	}

	~AutoPatch()
	{
		L4D_DEBUG_LOG("AutoPatch destructor");
	}

	/* 
		patch the code memory
	*/
	void Patch()
	{
		codePatch.Patch();
	}

	/*
		unpatch the code memory, restoring it to its original state
	*/
	void Unpatch()
	{
		codePatch.Unpatch();
	}

	/*
		get the underlying ICodePatch if we need to access it directly for some reason
	*/
	TPatchable &GetCodePatch()
	{
		return codePatch;
	}

private:
	TPatchable codePatch;
};

#endif
