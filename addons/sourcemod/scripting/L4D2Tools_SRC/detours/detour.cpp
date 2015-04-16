#include "extension.h"
#include "detour.h"
#include "asm/asm.h"
#include "CDetour/detourhelpers.h"

IGameConfig *Detour::gameconf = NULL;
ISourcePawnEngine *Detour::spengine = NULL;

void Detour::Init(ISourcePawnEngine *spengine, IGameConfig *gameconf)
{
	Detour::spengine = spengine;
	Detour::gameconf = gameconf;
}

Detour::Detour()
: isPatched(false), restore(new patch_t()), trampoline(NULL) {}

Detour::~Detour()
{
	L4D_DEBUG_LOG("Detour destructor");	
	//isPatched = true;
	Unpatch(); //ok since our Unpatch is not virtual
	delete restore;
}

void Detour::Patch()
{
	if(isPatched)
	{
		return;
	}

	signatureName = GetSignatureName();
	if(signatureName != NULL)
	{
		PatchFromSignature(signatureName,  GetDetourRaw(), trampoline, signature);
	}
	else
	{
		signature=GetSignatureAddress();
		if(signature == NULL)
		{
			g_pSM->LogError(myself, "Detour -- Could not find address for detour");
			return;
		}
		PatchFromAddress(GetDetourRaw(), trampoline, signature);
	}
	SetTrampoline(trampoline);

	OnPatched();
}

void Detour::PatchFromSignature(const char *signatureName, void *targetFunction, unsigned char *&originalFunction, unsigned char *&signature)
{
	if (!gameconf->GetMemSig(signatureName, (void**)&signature) || !signature) 
	{ 
		g_pSM->LogError(myself, "Detour -- Could not find '%s' signature", signatureName);
		return;
	} 
	L4D_DEBUG_LOG("Detour -- beginning patch routine for %s", signatureName);
	
	PatchFromAddress(targetFunction, originalFunction, signature);
}
	
void Detour::PatchFromAddress(void *targetFunction, unsigned char *&originalFunction, unsigned char *&signature)
{
	L4D_DEBUG_LOG("Detour -- beginning patch routine on address %p", signature);

	//copy the original func's first few bytes into the trampoline
	int copiedBytes = copy_bytes(/*src*/signature, /*dest*/NULL, OP_JMP_SIZE);

	assert(copiedBytes >= OP_JMP_SIZE);

	// create the jmp to our detour function
	patch_t detourJmpPatch;
	detourJmpPatch.bytes = copiedBytes;
	InjectJmp(detourJmpPatch.patch, signature, targetFunction);
	fill_nop(detourJmpPatch.patch + OP_JMP_SIZE, copiedBytes - OP_JMP_SIZE);

	trampoline = (unsigned char*) spengine->AllocatePageMemory(copiedBytes + OP_JMP_SIZE);
	//bugfix: when copying to trampoline call/jmp edges must be fixed up
	copy_bytes(/*src*/signature, /*dest*/trampoline, copiedBytes);
	L4D_DEBUG_LOG("Detour -- Copied %d bytes to trampoline @ %p", copiedBytes, trampoline);

	//at end of trampoline, place jmp back to resume spot of the original func
	inject_jmp(/*src*/trampoline + copiedBytes, /*dest*/signature + copiedBytes);
	//NOTE: above will 'break' if there is any JMP that goes into the first copiedBytes anywhere else :(
	ApplyPatch(signature, /*offset*/0, &detourJmpPatch, restore);
	originalFunction = trampoline;

	L4D_DEBUG_LOG("Detour has been patched for function @ %p", signature);

	isPatched = true;
}

void Detour::Unpatch()
{
	//NOTE: careful not to call any vfuncs here since its invoked by destructor

	L4D_DEBUG_LOG("Detour::Unpatch()");
	if(!isPatched) return;

	L4D_DEBUG_LOG("Detour::Unpatch() -- restoring %s to original state", signatureName);
	ApplyPatch(signature, /*offset*/0, restore, /*restore*/NULL);
	L4D_DEBUG_LOG("Detour::Unpatch() -- freeing trampoline");
	spengine->FreePageMemory(trampoline);

	isPatched = false;
	L4D_DEBUG_LOG("Detour %s has been unpatched", signatureName);
}

//insert a specific JMP instruction at the given location, save it to the buffer
void Detour::InjectJmp(void *buffer, void* src, void* dest) {
	*(unsigned char*)buffer = OP_JMP;
	*(long*)((unsigned char*)buffer+1) = (long)((unsigned char*)dest - ((unsigned char*)src + OP_JMP_SIZE));
}
