#ifndef _INCLUDE_SOURCEMOD_ICODEPATCH_H_
#define _INCLUDE_SOURCEMOD_ICODEPATCH_H_

/*
A simple interface for a patch that can change code memory or restore it to the original state

NOTE: To use this with PatchManager make sure to inherit public ICodePatch
*/
class ICodePatch
{
public:
	/* 
		patch the code memory
	*/
	virtual void Patch() = 0;

	/*
		unpatch the code memory, restoring it to its original state
	*/
	virtual void Unpatch() = 0;

	/*
		so that we can delete
	*/
	virtual ~ICodePatch() {}
};

#endif
