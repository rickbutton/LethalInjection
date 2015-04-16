#include <sourcemod>
#include <sdktools>
#pragma semicolon 1

new Handle:hGLAmmo = INVALID_HANDLE;
new Handle:hM60Ammo = INVALID_HANDLE;
new bool:bM60Patch = false;
new Address:patchAddr;
new savedBytes[2];
new iOffset;

public Plugin:myinfo = 
{
	name = "[L4D2] Ammo Pickup",
	author = "Dr!fter",
	description = "Allow ammo pickup for m60 and grenade launcher",
	version = "1.1.1"
}
public OnPluginStart()
{
	hGLAmmo = FindConVar("ammo_grenadelauncher_max");
	hM60Ammo = FindConVar("ammo_m60_max");
	HookEvent("ammo_pile_weapon_cant_use_ammo", OnWeaponDosntUseAmmo, EventHookMode_Pre);
	PatchM60Drop();
}
public Action:OnWeaponDosntUseAmmo(Handle:event, const String:name[], bool:dontBroadcast)
{	
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new weaponIndex = GetPlayerWeaponSlot(client, 0);
	
	if(weaponIndex == -1)
		return Plugin_Continue;
	
	new String:classname[64];
	
	GetEdictClassname(weaponIndex, classname, sizeof(classname));
	
	if(StrEqual(classname, "weapon_rifle_m60") || StrEqual(classname, "weapon_grenade_launcher"))
	{
		new iClip1 = GetEntProp(weaponIndex, Prop_Send, "m_iClip1");
		new iPrimType = GetEntProp(weaponIndex, Prop_Send, "m_iPrimaryAmmoType");
		
		if(StrEqual(classname, "weapon_rifle_m60"))
		{
			SetEntProp(client, Prop_Send, "m_iAmmo", ((GetConVarInt(hM60Ammo)+150)-iClip1), _, iPrimType);
		}
		else
		{
			SetEntProp(client, Prop_Send, "m_iAmmo", ((GetConVarInt(hGLAmmo)+1)-iClip1), _, iPrimType);
		}
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
public OnPluginEnd()
{
	UnPatchM60Drop();
}
stock PatchM60Drop()
{
	if(!bM60Patch)
	{
		new Handle:conf = LoadGameConfigFile("l4d2m60-patch.games");
		
		if(conf == INVALID_HANDLE)
		{
			LogError("Could not locate l4d2m60-patch.games gamedata");
			return;
		}
		
		patchAddr = GameConfGetAddress(conf, "CRifleM60::PrimaryAttack");
		iOffset = GameConfGetOffset(conf, "PrimaryAttackOffset");
		
		if(iOffset == -1)
		{
			LogError("Failed to get PrimaryAttackOffset");
		}
		else if(!patchAddr)
		{
			LogError("Failed to get Address");
		}
		else if(LoadFromAddress(patchAddr+Address:iOffset, NumberType_Int8) == 0x0F)
		{
			//Two byte jump
			savedBytes[0] = LoadFromAddress(patchAddr+Address:iOffset, NumberType_Int8);
			savedBytes[1] = LoadFromAddress(patchAddr+Address:(1+iOffset), NumberType_Int8);
			StoreToAddress(patchAddr+Address:iOffset, 0x90, NumberType_Int8);
			StoreToAddress(patchAddr+Address:(1+iOffset), 0xE9, NumberType_Int8);
		}
		else if(LoadFromAddress(patchAddr+Address:iOffset, NumberType_Int8) == 0x75 || LoadFromAddress(patchAddr+Address:iOffset, NumberType_Int8) == 0x74)
		{
			//One byte jump
			savedBytes[0] = LoadFromAddress(patchAddr+Address:iOffset, NumberType_Int8);
			StoreToAddress(patchAddr+Address:iOffset, 0xEB, NumberType_Int8);
		}
		else
		{
			LogError("Failed to patch M60 Drop invalid patch Address");
		}
		
		CloseHandle(conf);
	}
}
stock UnPatchM60Drop()
{
	if(!bM60Patch)
	{
		if(savedBytes[0] == 0x0F)
		{
			//Two byte jump
			StoreToAddress(patchAddr+Address:iOffset, savedBytes[0], NumberType_Int8);
			StoreToAddress(patchAddr+Address:(1+iOffset), savedBytes[1], NumberType_Int8);
		}
		else if(savedBytes[0] == 0x75 || savedBytes[0] == 0x74)
		{
			//One byte jump
			StoreToAddress(patchAddr+Address:iOffset, savedBytes[0], NumberType_Int8);
		}
	}
}