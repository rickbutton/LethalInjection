#include "get_player_by_character.h"
#include "extension.h"

namespace Detours
{
	void* GetPlayerByCharacter::OnGetPlayerByCharacter(int fu, Character* character)
	{
		cell_t result = Pl_Continue;

		if (g_pFwdOnGetPlayerByCharacter)
		{
			cell_t victim = *(reinterpret_cast<DWORD*>(this)+14);
			g_pFwdOnGetPlayerByCharacter->PushCellByRef(&victim);
			g_pFwdOnGetPlayerByCharacter->Execute(&result);
		}
		return character;
	}
};
