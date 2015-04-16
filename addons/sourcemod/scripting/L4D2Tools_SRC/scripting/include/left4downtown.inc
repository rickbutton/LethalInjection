/**
 * vim: set ts=4 :
 * =============================================================================
 * Left 4 Downtown SourceMod Extension
 * Copyright (C) 2009 Igor "Downtown1" Smirnov.
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 *
 * Version: $Id$
 */
#if defined _l4do_included
 #endinput
#endif
#define _l4do_included

#include <l4d2timers>
#include <l4d2weapons>
#include <l4d2director>

/**
 * @brief Called whenever ZombieManager::SpawnTank(Vector&,QAngle&) is invoked
 * @remarks Not invoked if z_spawn tank is used and it gives a ghosted/dead player tank
 *
 * @param vector	Vector coordinate where tank is spawned
 * @param qangle	QAngle where tank will be facing
 * @return 		Pl_Handled to block tank from spawning, Pl_Continue otherwise.
 */
forward Action:L4D_OnSpawnTank(const Float:vector[3], const Float:qangle[3]);

/**
 * @brief Called whenever ZombieManager::SpawnWitch(Vector&,QAngle&) is invoked
 *
 * @param vector	Vector coordinate where witch is spawned
 * @param qangle	QAngle where witch will be facing
 * @return 		Pl_Handled to block witch from spawning, Pl_Continue otherwise.
 */
forward Action:L4D_OnSpawnWitch(const Float:vector[3], const Float:qangle[3]);

/**
 * @brief Called whenever ZombieManager::SpawnWitchBride(Vector&,QAngle&) is invoked
 *
 * @param vector	Vector coordinate where witch is spawned
 * @param qangle	QAngle where witch will be facing
 * @return 		Pl_Handled to block witch from spawning, Pl_Continue otherwise.
 */
forward Action:L4D_OnSpawnWitchBride(const Float:vector[3], const Float:qangle[3]);

/**
 * @brief Called whenever ZombieManager::SpawnSpecial(ZombieClassType,Vector&,QAngle&) is invoked
 * @remarks Only used for bot special spawns (not players)
 *
 * @param zombieClass	Zombie class that will be spawned.
 * @param vector		Vector coordinate where special will be spawned
 * @param qangle		QAngle where spcial will be facing
 * @return 				Pl_Handled to block special from spawning, 
 * 				Pl_Changed to change the zombie class type to spawn, Pl_Continue otherwise.
 */
forward Action:L4D_OnSpawnSpecial(&zombieClass, const Float:vector[3], const Float:qangle[3]);

/**
 * @brief Called whenever CDirector::OnFirstSurvivorLeftSafeArea is invoked
 * @remarks A versus round is started when survivors leave the safe room, or force started
 *           after 90 seconds regardless.
 * 
 * @param client  the survivor that left the safe area first
 * 
 * @return 		Pl_Handled to block round from being started, Pl_Continue otherwise.
 */
forward Action:L4D_OnFirstSurvivorLeftSafeArea(client);

/**
 * @brief Called whenever CTerrorPlayer::OnEnterGhostState(CTerrorPlayer*) is invoked
 * @remarks This happens when a player enters ghost mode (or in finales auto-materialized)
 * 
 * @param client  the client that has entered ghost mode
 */
forward L4D_OnEnterGhostState(client);

/**
 * @brief Called whenever CDirector::TryOfferingTankBot is invoked
 * @remarks Is used for displaying the "X gets Tank" window and transferring Tank control
 * 
 * @return 		Pl_Handled to block window from showing and to keep Tank Bot, Pl_Continue otherwise
 */
forward Action:L4D_OnTryOfferingTankBot(tank_index, &bool:enterStasis);

/**
 * @brief Called whenever CDirector::OnMobRushStart(void) is invoked
 * @remarks called on random hordes, mini- and finale hordes, and boomer hordes, causes Zombies to attack
 *           Not called on "z_spawn mob", hook the console command and check arguments to catch plugin mobs
 *           This function is used to reset the Director's natural horde timer
 * 
 * @return 		Pl_Handled to block, Pl_Continue otherwise
 */
forward Action:L4D_OnMobRushStart();

/**
 * @brief Called whenever ZombieManager::SpawnITMob(int) is invoked
 * @remarks called on boomer hordes, increases Zombie Spawn Queue
 * 
 * @param amount	Amount of Zombies to add to Queue
 * 
 * @return 		Pl_Handled to block, Pl_Continue otherwise
 */
forward Action:L4D_OnSpawnITMob(&amount);

/**
 * @brief Called whenever ZombieManager::SpawnMob(int) is invoked
 * @remarks called on natural hordes & z_spawn mob, increases Zombie Spawn 
 *           Queue, triggers player OnMobSpawned (vocalizations), sets horde
 *           direction, and plays horde music.
 * 
 * @param amount	Amount of Zombies to add to Queue
 * 
 * @return 		Pl_Handled to block, Pl_Continue otherwise
 */
forward Action:L4D_OnSpawnMob(&amount);

/**
 * @brief Called whenever CTerrorPlayer::OnShovedBySurvivor(CTerrorPlayer, Vector&) is invoked
 * @remarks L4D2 only uses this on Special Infected
 *
 * @param client	the client that did the shoving
 * @param victim	the client that was shoved (CAUTION: retrieved from function pointer, dont meddle with it)
 * @param vector	Vector Angle of Shoveforce
 *
 * @return 		Pl_Handled to block melee effect (staggering), Pl_Continue otherwise.
 */
forward Action:L4D_OnShovedBySurvivor(client, victim, const Float:vector[3]);

/**
 * @brief Called whenever CTerrorPlayer::GetCrouchTopSpeed() is invoked
 *
 * @param target	the client that its being called on (not changible)
 * @param retVal  what to override the return value with
 * 
 * @return 		Pl_Handled to override return value, Pl_Continue otherwise.
 */
forward Action:L4D_OnGetCrouchTopSpeed(target, &Float:retVal);

/**
 * @brief Called whenever CTerrorPlayer::GetRunTopSpeed() is invoked
 *
 * @param target	the client that its being called on (not changible)
 * @param retVal  what to override the return value with
 * 
 * @return 		Pl_Handled to override return value, Pl_Continue otherwise.
 */
forward Action:L4D_OnGetRunTopSpeed(target, &Float:retVal);

/**
 * @brief Called whenever CTerrorPlayer::GetWalkTopSpeed() is invoked
 *
 * @param target	the client that its being called on (not changible)
 * @param retVal  what to override the return value with
 * 
 * @return 		Pl_Handled to override return value, Pl_Continue otherwise.
 */
forward Action:L4D_OnGetWalkTopSpeed(target, &Float:retVal);

/**
 * @brief Called whenever CTerrorGameRules::HasConfigurableDifficultySetting() is invoked
 * @remarks used to deny/allow difficulty changes in different game modes
 *
 * @param retVal  what to override the return value with. 1 to allow difficulty configuration, 0 to deny.
 * 
 * @return 		Pl_Handled to override return value, Pl_Continue otherwise.
 */
forward Action:L4D_OnHasConfigurableDifficulty(&retVal);

/**
 * @brief Called whenever CThrow::ActivateAbility(void) is invoked
 * @remarks Called when a tank throws a rock. Blocking this call will
 *			keep the tank from throwing a rock.
 *
 * @param ability	ability_throw entity index
 * 
 * @return 		Pl_Handled to block, Pl_Continue otherwise
 */
forward Action:L4D_OnCThrowActivate(ability);

/**
 * @brief Called whenever InfectedShoved::OnShoved(Infected *, CBaseEntity *) is invoked
 * @remarks Called when common Infected are about to get shoved
 * 
 * @return 		Pl_Handled to block, Pl_Continue otherwise
 */
forward Action:L4D_OnInfectedShoved(infected, entity);

/**
 * @brief Called whenever CTerrorMeleeWeapon::StartMeleeSwing(CTerrorPlayer *, bool) is invoked
 * @remarks Called when a player uses his melee Weapons primary attack. This is before the game
 *			reads the melee weapon data (model etc) and decides if he CAN attack at all.
 * 
 * @return 		Pl_Handled to block, Pl_Continue otherwise
 */
forward Action:L4D_OnStartMeleeSwing(client, bool:boolean);

/**
 * @brief Called whenever CDirectorScriptedEventManager::SendInRescueVehicle(void) is invoked
 * @remarks Called when the last Finale stage is reached and the Rescue Means becomes 'available'.
 *			Take note this forward WILL fire upon using the native of the same function.
 * 
 * @return 		Pl_Handled to block, Pl_Continue otherwise
 */
forward Action:L4D2_OnSendInRescueVehicle();

/**
 * @brief Called whenever CDirectorScriptedEventManager::ChangeFinaleStage is invoked
 *
 * @param FinaleStageType	integer value
 * @remarks some values for FinaleStageType: 1 - Finale Started; 6 - Rescue Vehicle Ready; 7 - Zombie Hordes; 8 - Tank; 10 - Combat Respite (nothing spawns)
 * @remarks SendInRescueVehicle does not depend on Finale Stage being 6, that only signals endless Hordes/Tanks
 * 
 * @return 		Pl_Handled to block, Pl_Continue otherwise
 */
forward Action:L4D2_OnChangeFinaleStage(&finaleType, const String:arg[]);

/**
 * @brief Called when CBaseAnimating::SelectWeightedSequence(int Activity) is invoked with tank attack activity
 * @remarks Called whenever a tank uses his primary (punch) or secondary (throw) attack
 *
 * @param client   the client that is playing as tank
 * @param sequence  current selected sequence for attack, option to override the return value with it
 * @remarks	sequences(punches): 40(uppercut), 43(right hook), 45(left hook), 46 and 47 (pounding the ground)
 * @remarks	sequences(throws): 48(undercut), 49(1handed overhand), 50(throw from the hip), 51(2handed overhand)
 * 
 * @return 		Pl_Handled to override return value, Pl_Continue otherwise.
 */
forward Action:L4D2_OnSelectTankAttack(client, &sequence);

/**
 * @brief Called when CTerrorPlayer::OnRevived(void) is invoked
 * @remarks Called post-revive so all data values are post-revive status.
 *
 * @param client   the client that has been revived
 *
 * @noreturn Pl_Handled to override return value, Pl_Continue otherwise.
 */
forward Action:L4D2_OnRevived(client);

/**
 * @brief Restarts the round, switching the map if necessary
 * @remarks Set the map to the current map to restart the round
 * 
 * @param map  the mapname it should go to after the round restarts
 * @return     1 always
 */
native L4D_RestartScenarioFromVote(const String:map[]);

/**
 * @brief Tells if the Mission (map) is the final map of the campaign
 *
 * @return		true if the map is the last map of the campaign (finale)
 */
native bool:L4D_IsMissionFinalMap();

/**
 * @brief Resets the natural mob (horde) timer
 * @remarks	Requires the Director to be available--map must be started
 *
 * @noreturn
 */
native L4D_ResetMobTimer();

/**
 * @brief Trigger's a target player's stagger behavior 
 * @remarks Works on any CTerrorPlayer--survivor or infected.
 * 
 * @param target 		Player to stagger
 * @param source_ent	Source of the stagger (another player, etc)
 * @param source_vector Source location of the stagger. If NULL_VECTOR, origins of source_ent is used.
 * @noreturn 				
 */
native L4D_StaggerPlayer(target, source_ent, Float:source_vector[3]);

/**
 * @brief Get the time remaining before the next director horde. 
 * @remarks This timer is used for scripted event hordes and natural timed hordes
 * 
 * @return 	Time remaining before next director horde
 */
#pragma deprecated Use L4D2_CTimerGetRemainingTime(L4D2CT_MobSpawnTimer)
native Float:L4D_GetMobSpawnTimerRemaining();

/**
 * @brief Get the duration the horde timer was set to after the last horde
 * @remarks This timer is used for scripted event hordes and natural timed hordes
 * 
 * @return 	Total time from last horde to next horde.
 */
#pragma deprecated Use L4D2_CTimerGetCountdownDuration(L4D2CT_MobSpawnTimer)
native Float:L4D_GetMobSpawnTimerDuration();

/**
 * @brief Get the remaining spawn time for an SI
 * @remarks This is meant for Special infected in ghost mode in versus.
 * 
 * @return 	Time (seconds) until the SI will spawn.
 */
native Float:L4D_GetPlayerSpawnTime(player);

/**
 * @brief Calls CDirectorScriptedEventManager::SendInRescueVehicle(void)
 *
 * @remarks will fire the forward of the same function
 * 
 * @noreturn
 */
native L4D2_SendInRescueVehicle();

/**
 * @brief Calls CDirectorScriptedEventManager::ChangeFinaleStage(CDirectorScriptedEventManager::FinaleStageType,char  const*)
 *
 * @param FinaleStageType	integer value
 * @remarks some values for FinaleStageType: 1 - Finale Started; 6 - Rescue Vehicle Ready; 7 - Zombie Hordes; 8 - Tank; 10 - Combat Respite (nothing spawns)
 * @remarks
 * @remarks will fire the forward of the same function
 *
 * @noreturn
 */
native L4D2_ChangeFinaleStage(finaleType, const String:arg[]);

/**
 * @brief Calls ZombieManager::SpawnTank(Vector&,QAngle&)
 *
 * @param vector	Vector coordinate where the tank will be spawned
 * @param qangle	QAngle where the tank will be facing
 * @return 			Entity index of the spawned tank
 */
native L4D2_SpawnTank(const Float:vector[3], const Float:qangle[3]);

/**
 * @brief Calls ZombieManager::SpawnSpecial(ZombieClassType,Vector&,QAngle&)
 * @remarks Only used for bot special spawns (not players)
 *
 * @param vector	Vector coordinate where the SI will be spawned
 * @param qangle	QAngle where the SI will be facing
 * @return 			Entity index of the spawned SI
 */
native L4D2_SpawnSpecial(zombieClass, const Float:vector[3], const Float:qangle[3]);

/**
 * @brief Calls ZombieManager::SpawnWitch(Vector&,QAngle&)
 *
 * @param vector	Vector coordinate where the witch will be spawned
 * @param qangle	QAngle where the witch will be facing
 * @return 			Entity index of the spawned witch
 */
native L4D2_SpawnWitch(const Float:vector[3], const Float:qangle[3]);

/**
 * @brief Calls ZombieManager::SpawnWitchBride(Vector&,QAngle&)
 *
 * @param vector	Vector coordinate where the witch bride will be spawned
 * @param qangle	QAngle where the witch bride will be facing
 * @return 			Entity index of the spawned witch bride
 */
native L4D2_SpawnWitchBride(const Float:vector[3], const Float:qangle[3]);

/*
Makes the extension required by the plugins, undefine REQUIRE_EXTENSIONS
if you want to use it optionally before including this .inc file
*/
public Extension:__ext_left4downtown = 
{
	name = "Left 4 Downtown",
	file = "left4downtown.ext",
#if defined AUTOLOAD_EXTENSIONS
	autoload = 1,
#else
	autoload = 0,
#endif
#if defined REQUIRE_EXTENSIONS
	required = 1,
#else
	required = 0,
#endif
};
