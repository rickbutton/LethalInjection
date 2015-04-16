#ifndef _INCLUDE_SOURCEMOD_DETOUR_TEMPLATE_H_
#define _INCLUDE_SOURCEMOD_DETOUR_TEMPLATE_H_

#include "detour.h"
#include "auto_forward.h"
#define MFP_CODE_ADDRESS(mfp) (*(void **)(&(mfp)))

template <typename TDetour, typename TParent>
class DetourTemplate : public Detour
{
protected: //note: virtuals should be implemented by the TParent class

	// get the signature name (i.e. "SpawnTank") from the game conf
	virtual const char *GetSignatureName() = 0;

	//notify our patch system which function should be used as the detour
	virtual TDetour GetDetour() = 0;

	//get the trampoline, use it to call the original function in a detour
	static TDetour GetTrampoline()
	{
		return GetTrampolineRef();
	}

	//onpatched callback
	virtual void OnPatched() { }

	//yes this assumes that we instantiate a Singleton
	DetourTemplate() { GetAutoForwardPtrRef() = NULL; }
	~DetourTemplate() { if(GetAutoForward()) { delete GetAutoForward(); SetAutoForward(NULL); } }

	static void SetAutoForward(AutoForward *autoForward)
	{
		GetAutoForwardPtrRef() = autoForward;
	}

	static AutoForward* GetAutoForward()
	{
		AutoForward *autoFwd = GetAutoForwardPtrRef();
		return autoFwd;
	}

private: 

	static AutoForward*& GetAutoForwardPtrRef()
	{
		static AutoForward* autoForward = NULL;
		return autoForward;
	}

	//get the trampoline ref so we can change the value later
	static TDetour& GetTrampolineRef()
	{
		static TDetour trampoline = NULL;
		return trampoline;
	}

//note: implementation of Detour abstract virtual functions

	//save the trampoline pointer
	virtual void SetTrampoline(void *trampoline)
	{
		MFP_CODE_ADDRESS(GetTrampolineRef()) = trampoline;
	}

	//return a void* to the detour function
	virtual void *GetDetourRaw()
	{
		TDetour detour = GetDetour();
		return MFP_CODE_ADDRESS(detour);
	}

	//return a void* to the trampoline (after we Set it)
	virtual void *GetTrampolineRaw()
	{
		TDetour trampoline = GetTrampoline();
		return MFP_CODE_ADDRESS(trampoline);
	}
};

#undef MFP_CODE_ADDRESS

#endif
