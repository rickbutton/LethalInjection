#ifndef _INCLUDE_SOURCEMOD_DETOUR_H_
#define _INCLUDE_SOURCEMOD_DETOUR_H_

#include "../extension.h"
#include "../codepatch/icodepatch.h"

struct patch_t;

class Detour : public ICodePatch
{
public:

	//Initialize the Detour classes before ever calling Patch()
	static void Init(ISourcePawnEngine *spengine, IGameConfig *gameconf);

	Detour();
	virtual ~Detour();

	//enable the detour
	void Patch();

	//disable the detour
	void Unpatch();

	// get the signature name (i.e. "SpawnTank") from the game conf
	virtual const char *GetSignatureName() = 0;
	
	virtual unsigned char *GetSignatureAddress() { return NULL; }

protected: //note: implemented by direct superclass

	//call back when detour is successfully enabled
	virtual void OnPatched() = 0;

	//save the trampoline pointer
	virtual void SetTrampoline(void *trampoline) = 0;

	//return a void* to the detour function
	virtual void *GetDetourRaw() = 0;

	//return a void* to the trampoline (after we Set it)
	virtual void *GetTrampolineRaw() = 0;

	static IGameConfig *gameconf;
private:
	bool isPatched;

	unsigned char *signature;

	const char *signatureName;
	patch_t *restore;
	unsigned char *trampoline;


	static ISourcePawnEngine *spengine;

	void PatchFromSignature(const char *signatureName, void *targetFunction, unsigned char *&originalFunction, unsigned char *&signature);
	
	void PatchFromAddress(void *targetFunction, unsigned char *&originalFunction, unsigned char *&signature);

	//insert a specific JMP instruction at the given location, save it to the buffer
	void InjectJmp(void *buffer, void *source, void *destination);
};

#endif
