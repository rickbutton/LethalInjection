#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <left4downtown>

static const String:CONFIG_COW_SPAWNS[]		= "data/cow_level.cfg";
static const String:CONFIG_CLIP_SPAWNS[]	= "data/clip_brushes.cfg";
static const String:CONFIG_CHECKPOINTS[]	= "data/checkpoints.cfg";

static const FFADE_IN = 0x0001;
static const FFADE_OUT = 0x0002;
static const FFADE_MODULATE = 0x0004;
static const FFADE_STAYOUT = 0x0008;
static const FFADE_PURGE = 0x0010;

static const String:MODEL_NICK[] 		= "models/survivors/survivor_gambler.mdl";
static const String:MODEL_ROCHELLE[] 		= "models/survivors/survivor_producer.mdl";
static const String:MODEL_COACH[] 		= "models/survivors/survivor_coach.mdl";
static const String:MODEL_ELLIS[] 		= "models/survivors/survivor_mechanic.mdl";
static const String:MODEL_BILL[] 		= "models/survivors/survivor_namvet.mdl";
static const String:MODEL_ZOEY[] 		= "models/survivors/survivor_teenangst.mdl";
static const String:MODEL_FRANCIS[] 		= "models/survivors/survivor_biker.mdl";
static const String:MODEL_LOUIS[] 		= "models/survivors/survivor_manager.mdl";

static const String:MODEL_TANK_DLC3[] 		= "models/infected/hulk_dlc3.mdl";

static const String:MODEL_V_FIREAXE[] 		= "models/weapons/melee/v_fireaxe.mdl";
static const String:MODEL_V_FRYING_PAN[] 	= "models/weapons/melee/v_frying_pan.mdl";
static const String:MODEL_V_MACHETE[] 		= "models/weapons/melee/v_machete.mdl";
static const String:MODEL_V_BAT[] 		= "models/weapons/melee/v_bat.mdl";
static const String:MODEL_V_CROWBAR[] 		= "models/weapons/melee/v_crowbar.mdl";
static const String:MODEL_V_CRICKET_BAT[] 	= "models/weapons/melee/v_cricket_bat.mdl";
static const String:MODEL_V_TONFA[] 		= "models/weapons/melee/v_tonfa.mdl";
static const String:MODEL_V_KATANA[] 		= "models/weapons/melee/v_katana.mdl";
static const String:MODEL_V_ELECTRIC_GUITAR[] 	= "models/weapons/melee/v_electric_guitar.mdl";
static const String:MODEL_V_KNIFE[] 		= "models/v_models/v_knife_t.mdl";
static const String:MODEL_V_GOLFCLUB[] 		= "models/weapons/melee/v_golfclub.mdl";

//addon melee
static const String:MODEL_V_ARM[] 		= "models/weapons/melee/v_arm.mdl";
static const String:MODEL_V_FOOT[] 		= "models/weapons/melee/v_foot.mdl";
static const String:MODEL_V_FOAMFINGER[] 	= "models/bunny/weapons/melee/v_b_foamfinger.mdl";
static const String:MODEL_V_MUFFLER[] 		= "models/weapons/melee/v_muffler.mdl";
static const String:MODEL_V_CONCRETE1[] 	= "models/weapons/melee/v_concretev1.mdl";
static const String:MODEL_V_CONCRETE2[] 	= "models/weapons/melee/v_concretev2.mdl";

static const String:MODEL_50CAL[] 		= "models/w_models/weapons/50cal.mdl";
static const String:MODEL_M60[] 		= "models/w_models/weapons/w_m60.mdl";
static const String:MODEL_PIPEBOMB[] 		= "models/w_models/weapons/w_eq_pipebomb.mdl";

static const String:MODEL_GASCAN[] 		= "models/props_junk/gascan001a.mdl";
static const String:MODEL_PROPANE[] 		= "models/props_junk/propanecanister001a.mdl";
static const String:MODEL_OXYGEN[] 		= "models/props_equipment/oxygentank01.mdl";	
static const String:MODEL_FIREWORKS[] 		= "models/props_junk/explosive_box001.mdl";
static const String:MODEL_FLARE[] 		= "models/props_lighting/light_flares.mdl";
static const String:MODEL_MISSILE[] 		= "models/missiles/f18_agm65maverick.mdl";
static const String:MODEL_DEFENSEGRID[]		= "models/props_shacks/bug_lamp01.mdl";

static const String:MODEL_COWPILE[]		= "models/props_debris/dead_cow_smallpile.mdl";
static const String:MODEL_COW[]			= "models/props_debris/dead_cow.mdl";
static const String:MODEL_GIFT[]		= "models/items/l4d_gift.mdl";

static const String:PARTICLE_SPARKSA[] 		= "weapon_pipebomb_child_sparks2";
static const String:PARTICLE_SPARKSB[] 		= "weapon_pipebomb_child_sparks3";
//static const String:PARTICLE_SMOKERCLOUD[] 	= "smoker_smokecloud";
static const String:PARTICLE_SMOKE[] 		= "apc_wheel_smoke1";
static const String:PARTICLE_FIRE[] 		= "aircraft_destroy_fastFireTrail";
static const String:PARTICLE_WARP[] 		= "electrical_arc_01_system";
static const String:PARTICLE_SPIT[] 		= "spitter_areaofdenial_glow2";
static const String:PARTICLE_SPITPROJ[] 	= "spitter_projectile";
static const String:PARTICLE_ELEC[] 		= "electrical_arc_01_parent";
static const String:PARTICLE_BLOOD_EXPLODE[] 	= "boomer_explode_D";
static const String:PARTICLE_EXPLODE[] 		= "boomer_explode";
static const String:PARTICLE_METEOR[] 		= "smoke_medium_01";
static const String:PARTICLE_BLOOD[] 		= "blood_impact_red_01";
static const String:PARTICLE_50CAL_TRACER[] 	= "weapon_tracers_50cal";
static const String:PARTICLE_RIFLE_FLASH[] 	= "weapon_muzzle_flash_assaultrifle";
static const String:PARTICLE_50CAL_FLASH[] 	= "weapon_muzzle_flash_autoshotgun";
static const String:PARTICLE_LS_BOLT[] 		= "storm_lightning_01_thin";
static const String:PARTICLE_BERSERKER[] 	= "sparks_generic_random";
static const String:PARTICLE_NIGHTCRAWLER[] 	= "weapon_pipebomb_child_firesmoke";
static const String:PARTICLE_SECONDCHANCE[] 	= "mini_fireworks";
//static const String:PARTICLE_FLAMESHIELD[] 	= "burning_gib_01_follower1";
static const String:PARTICLE_FLAMESHIELD[] 	= "inferno_grow"; //fire_medium_02_nosmoke
//static const String:PARTICLE_DETECTGREATERZ[] 	= "lights_moving_straight_bounce_4";
//static const String:PARTICLE_VOMITCLOUD[] 	= "vomit_jar_c";
static const String:PARTICLE_POLYMORPH[] 	= "impact_explosive_ammo_large";
static const String:PARTICLE_FLARE[] 		= "flare_burning";
static const String:PARTICLE_DEMON_SMOKE[] 	= "smoke_campfire";
//static const String:PARTICLE_DEMON_HEAT[] 	= "fire_medium_heatwave";
static const String:PARTICLE_FUSE[] 		= "weapon_pipebomb_fuse";
static const String:PARTICLE_LASER[] 		= "weapon_tracers_50cal_low";
//static const String:PARTICLE_SHOCK[] 		= "st_elmos_fire";
static const String:PARTICLE_DEFENSEGRID_GLOW[] = "electrical_arc_01_cp0";
static const String:PARTICLE_SOULSHIELD_GLOW[] 	= "impact_explosive_glow";

static const String:PARTICLE_JETIDLE[] 		= "burning_gib_01b";
static const String:PARTICLE_JETFIRE[] 		= "fire_small_base";
static const String:PARTICLE_JETSMOKE[] 	= "smoke_gib_01";

static const String:PARTICLE_NUKEHIT[] 		= "gen_hit_up";
static const String:PARTICLE_NUKEWAVE[] 	= "gas_explosion_ground_wave";
static const String:PARTICLE_NUKESMOKEA[] 	= "gas_explosion_firesmoke";
static const String:PARTICLE_NUKESMOKEB[] 	= "gen_hit1_edynamicBillow";
//static const String:PARTICLE_NUKECHUNKA[] 	= "gas_explosion_chunks_01";
//static const String:PARTICLE_NUKECHUNKB[] 	= "gas_explosion_chunks_02";
static const String:PARTICLE_NUKEDEBRISA[] 	= "gas_explosion_debris_parents";
static const String:PARTICLE_NUKEDEBRISB[] 	= "gen_hit1_b";
static const String:PARTICLE_NUKEFIREA[] 	= "gas_fireball";
static const String:PARTICLE_NUKEFIREB[] 	= "gas_explosion_fireball";
static const String:PARTICLE_NUKEFIREC[] 	= "gas_explosion_fireball2";

static const String:SOUND_50CAL_FIRE[] 		= "weapons/50cal/50cal_shoot.wav";
static const String:SOUND_M60_FIRE[] 		= "weapons/machinegun_m60/gunfire/machinegun_fire_1.wav";
static const String:SOUND_IMPACT[] 		= "physics/flesh/flesh_impact_bullet1.wav";
static const String:SOUND_CRACKLE[] 		= "ambient/fire/fire_small_loop2.wav";
static const String:SOUND_ARTILLERY[] 		= "animation/tanker_explosion.wav";
static const String:SOUND_IONCANNON[] 		= "ambient/spacial_loops/lights_flicker.wav";
static const String:SOUND_JETPACKFIRE[] 	= "ambient/fire/interior_fireclose01_mono.wav";
static const String:SOUND_JETPACKIDLE[] 	= "ambient/fire/exterior_fire01_stereo.wav";
static const String:SOUND_NUKERUMBLE[] 		= "ambient/levels/caves/rumble3.wav";
static const String:SOUND_NUKEEXPLODE[] 	= "weapons/grenade_launcher/grenadefire/grenade_launcher_explode_1.wav";

static String:current_map[32];
static iChapter;
static iChapterStage;
static bool:bIsL4D2		= false;
static bool:bIsFinale		= false;
static bool:bRoundEnded		= true;

static const String:MapNames[][] =
{
	"c1m1_hotel",
	"c1m2_streets",
	"c1m3_mall",
	"c1m4_atrium", //3
	"c2m1_highway",
	"c2m2_fairgrounds",
	"c2m3_coaster",
	"c2m4_barns",
	"c2m5_concert", //8
	"c3m1_plankcountry",
	"c3m2_swamp",
	"c3m3_shantytown",
	"c3m4_plantation", //12
	"c4m1_milltown_a",
	"c4m2_sugarmill_a",
	"c4m3_sugarmill_b",
	"c4m4_milltown_b",
	"c4m5_milltown_escape", //17
	"c5m1_waterfront",
	"c5m2_park",
	"c5m3_cemetery",
	"c5m4_quarter",
	"c5m5_bridge", //22
	"c6m1_riverbank",
	"c6m2_bedlam",
	"c6m3_port", //25
	"c7m1_docks",
	"c7m2_barge",
	"c7m3_port", //28
	"c8m1_apartment",
	"c8m2_subway",
	"c8m3_sewers",
	"c8m4_interior",
	"c8m5_rooftop", //33
	"c9m1_alleys",
	"c9m2_lots", //35
	"c10m1_caves",
	"c10m2_drainage",
	"c10m3_ranchhouse",
	"c10m4_mainstreet",
	"c10m5_houseboat", //40
	"c11m1_greenhouse",
	"c11m2_offices",
	"c11m3_garage",
	"c11m4_terminal",
	"c11m5_runway", //45
	"c12m1_hilltop",
	"c12m2_traintunnel",
	"c12m3_bridge",
	"c12m4_barn",
	"c12m5_cornfield", //50
	"c13m1_alpinecreek",
	"c13m2_southpinestream",
	"c13m3_memorialbridge",
	"c13m4_cutthroatcreek", //54
	"cwm1_intro",
	"cwm2_warehouse",
	"cwm3_drain",
	"cwm4_building", //58
	"zmb13_m1_barracks",
	"zmb13_m2_labs",
	"zmb13_m3_surface", //61
	"cdta_01detour",
	"cdta_02road",
	"cdta_03warehouse",
	"cdta_04onarail",
	"cdta_05finalroad", //66
	"p84m1_crash",
	"p84m2_train",
	"p84m3_clubd",
	"p84m4_precinct", //70
	"uf1_boulevard",
	"uf2_rooftops",
	"uf3_harbor",
	"uf4_airfield", //74
	"l4d2_stadium1_apartment",
	"l4d2_stadium2_riverwalk",
	"l4d2_stadium3_city1",
	"l4d2_stadium4_city2",
	"l4d2_stadium5_stadium", //79
	"srocchurch",
	"plaza_espana",
	"maria_cristina",
	"mnac", //83
	"l4d_yama_1",
	"l4d_yama_2",
	"l4d_yama_3",
	"l4d_yama_4",
	"l4d_yama_5", //88
	"l4d_ihm01_forest",
	"l4d_ihm02_manor",
	"l4d_ihm03_underground",
	"l4d_ihm04_lumberyard",
	"l4d_ihm05_lakeside", //93
	"l4d2_bts01_forest",
	"l4d2_bts02_station",
	"l4d2_bts03_town",
	"l4d2_bts04_cinema",
	"l4d2_bts05_church",
	"l4d2_bts06_school" //99
};
static const String:LaserWeapons[][] =
{
	"weapon_rifle",
	"weapon_smg",
	"weapon_hunting_rifle",
	"weapon_sniper_scout",
	"weapon_sniper_military",
	"weapon_sniper_awp",
	"weapon_smg_silenced",
	"weapon_smg_mp5",
	"weapon_rifle_sg552",
	"weapon_rifle_desert",
	"weapon_rifle_ak47",
	"weapon_rifle_m60"
};
static const String:WeaponViewModels[][] =
{
	"models/v_models/v_rifle.mdl",
	"models/v_models/v_smg.mdl",
	"models/v_models/v_huntingrifle.mdl",
	"models/v_models/v_snip_scout.mdl",
	"models/v_models/v_sniper_military.mdl",
	"models/v_models/v_snip_awp.mdl",
	"models/v_models/v_silenced_smg.mdl",
	"models/v_models/v_smg_mp5.mdl",
	"models/v_models/v_rif_sg552.mdl",
	"models/v_models/v_desert_rifle.mdl",
	"models/v_models/v_rifle_ak47.mdl",
	"models/v_models/v_m60.mdl"
};
static const String:HatFileName[][] =
{
	"models/infected/gibs/gibs.mdl",
	"models/infected/limbs/exploded_boomer_head.mdl",
	"models/infected/limbs/limb_male_head01.mdl",
	"models/props/cs_militia/circularsaw01.mdl",
	"models/props/de_nuke/emergency_lighta.mdl",
	"models/props_fairgrounds/alligator.mdl",
	"models/props_fairgrounds/mr_mustachio.mdl",
	"models/props_fortifications/orange_cone001_clientside.mdl",
	"models/props_interiors/teddy_bear.mdl",
	"models/props_interiors/toilet_b_breakable01_part13.mdl",
	"models/props_interiors/waterbottle.mdl",
	"models/props_urban/dock_pylon_cap001.mdl",
	"models/props_urban/life_ring001.mdl",
	"models/props_lighting/light_construction02.mdl",
	"models/extras/info_speech.mdl",
	"models/infected/smoker_tongue_attach.mdl",
	"models/props/de_inferno/ceiling_fan_blade.mdl",
	"models/f18/f18_placeholder.mdl",
	"models/deadbodies/dead_male_civilian_radio.mdl",
	"models/infected/cim_riot_faceplate.mdl",
	"models/props_interiors/styrofoam_cups.mdl",
	"models/props_interiors/tv.mdl",
	"models/props_unique/spawn_apartment/lantern.mdl",
	"models/props_urban/exit_sign002.mdl",
	"models/props_urban/garden_hose001.mdl",
	"models/props_urban/plastic_flamingo001.mdl",
	"models/props_waterfront/money_pile.mdl",
	"models/props_fairgrounds/elephant.mdl",
	"models/props_fairgrounds/giraffe.mdl",
	"models/props_fairgrounds/garbage_popcorn_box.mdl",
	"models/props_fairgrounds/snake.mdl",
	"models/props_interiors/toaster.mdl",
	"models/props_unique/doll01.mdl",
	"models/props_junk/garbage_hubcap01a.mdl",
	"models/props_mall/mall_mannequin_rhand.mdl",
	"models/props_lab/desklamp01.mdl"
};
static const Float:HatOrigin[36][3] =
{
	{2.0, 0.5, 0.5},
	{0.0, 0.0, 0.0},
	{0.0, 0.0, -5.0},
	{-4.0, 1.5, 1.5},
	{-8.0, -0.5, 11.5},
	{-3.0, 0.5, 0.5},
	{-2.0, 0.0, 5.0},
	{-3.0, 0.0, 1.0},
	{-10.0, 0.0, 8.0},
	{-34.0, 0.5, -14.0},
	{-2.5, -0.5, 26.0},
	{-4.0, 0.0, 10.5},
	{-2.5, 1.0, 6.0},
	{-7.0, 0.0, 9.0},
	{-3.5, 0.0, 18.5},
	{-5.5, -2.5, 48.0},
	{-2.0, -0.5, 6.0},
	{-5.5, 0.0, 6.0},
	{-3.0, -7.0, -1.0},
	{-5.5, 0.0, -66.0},
	{-9.0, 0.0, 18.0},
	{-6.5, 0.0, 9.0},
	{-4.0, 0.0, 5.5},
	{-4.0, 0.0, 12.5},
	{-8.0, 0.0, 2.5},
	{-5.5, 0.0, -12.0},
	{-6.0, 9.0, 5.0},
	{-2.5, 0.0, 6.5},
	{-2.5, 0.0, 3.5},
	{-4.0, 0.0, 7.0},
	{-10.0, -5.5, -37.5},
	{-4.5, 0.0, 7.5},
	{-6.0, 0.0, 8.5},
	{-6.5, 0.0, 8.5},
	{-5.5, 5.5, 6.5},
	{-11.5, 0.0, 6.0}
};
static const Float:HatAngles[36][3] =
{
	{0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, 80.0, 0.0},
	{-30.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, 60.0, -40.0},
	{-10.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{180.0, 60.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{-200.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, -60.0, 180.0},
	{0.0, 40.0, 0.0},
	{0.0, 180.0, 0.0},
	{30.0, 10.0, -60.0},
	{90.0, 0.0, 0.0},
	{-20.0, 0.0, 0.0},
	{0.0, 100.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{40.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{-20.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{-80.0, 0.0, 0.0},
	{0.0, 0.0, 0.0},
	{60.0, 0.0, 0.0},
	{-30.0, 0.0, 0.0},
	{60.0, 30.0, 70.0},
	{0.0, 0.0, 0.0}
};
static WeaponDropDelay[33];
static BackpackDelay[33];
static BackpackItemID[33][13];
static BackpackGunInfo[33][13][5];
static const String:WeaponItemName[][] =
{
	"0", //0
	"Pipe Bomb",
	"Molotov",
	"Vomit Jar", //1-3
	"Med Kit",
	"Defibrillator",
	"Explosive Ammo Pack",
	"Incendiary Ammo Pack", //4-7
	"Pain Pills",
	"Adrenaline Shot", //8-9
	"Pistol",
	"Magnum",
	"Chainsaw",
	"Fireaxe",
	"Frying Pan",
	"Machete",
	"Baseball Bat",
	"Crowbar",
	"Cricket Bat",
	"Tonfa",
	"Katana",
	"Electric Guitar",
	"Knife",
	"Golfclub", //10-23
	"Pump Shotgun",
	"Auto Shotgun",
	"M16 Rifle",
	"SMG",
	"Hunting Rifle",
	"Sniper Scout Rifle",
	"Sniper Rifle",
	"Sniper AWP",
	"Silenced SMG",
	"MP5",
	"SPAS Shotgun",
	"Chrome Shotgun",
	"SG552",
	"Desert Rifle",
	"AK47",
	"Grenade Launcher",
	"M60", //24-40
	"Gas Can",
	"Propane Tank",
	"Oxygen Tank",
	"Gnome",
	"Cola Bottles",
	"Firework Crate", //41-46
	"Melee" //polymorph
};
static const String:WeaponClassname[][] =
{
	"0", //0
	"weapon_pipe_bomb",
	"weapon_molotov",
	"weapon_vomitjar", //1-3
	"weapon_first_aid_kit",
	"weapon_defibrillator",
	"weapon_upgradepack_explosive",
	"weapon_upgradepack_incendiary", //4-7
	"weapon_pain_pills",
	"weapon_adrenaline", //8-9
	"weapon_pistol",
	"weapon_pistol_magnum",
	"weapon_chainsaw",
	"weapon_fireaxe",
	"weapon_frying_pan",
	"weapon_machete",
	"weapon_baseball_bat",
	"weapon_crowbar",
	"weapon_cricket_bat",
	"weapon_tonfa",
	"weapon_katana",
	"weapon_electric_guitar",
	"weapon_knife",
	"weapon_golfclub", //10-23
	"weapon_pumpshotgun",
	"weapon_autoshotgun",
	"weapon_rifle",
	"weapon_smg",
	"weapon_hunting_rifle",
	"weapon_sniper_scout",
	"weapon_sniper_military",
	"weapon_sniper_awp",
	"weapon_smg_silenced",
	"weapon_smg_mp5",
	"weapon_shotgun_spas",
	"weapon_shotgun_chrome",
	"weapon_rifle_sg552",
	"weapon_rifle_desert",
	"weapon_rifle_ak47",
	"weapon_grenade_launcher",
	"weapon_rifle_m60", //24-40
	"weapon_gascan",
	"weapon_propanetank",
	"weapon_oxygentank",
	"weapon_gnome",
	"weapon_cola_bottles",
	"weapon_fireworkcrate", //41-46
	"weapon_melee" //polymorph
};
/////////////////////////
/// Perks Information ///
/////////////////////////
new const String:InfoName[][] =
{
	"0",
	"Acrobatics",
	"Medic",
	"Pack Rat",
	"Desert Cobra",
	"Gene Mutations",
	"Self Revive",
	"Sleight of Hand",
	"Knife",
	"Hard to Kill",
	"Arms Dealer",
	"Gene Mutations II",
	"Surgeon",
	"Extreme Conditioning",
	"BullsEye",
	"Size Matters",
	"Gene Mutations III",
	"Master at Arms",
	"Hardened Stance",
	"Critical Hit!",
	"Gene Mutations IV",
	"Commando",
	"Second Chance",
	"Laser Rounds",

	"Ammo Pile",
	"UV Light",
	"High Frequency Emitter",
	"Healing Station",
	"Sentry Gun",
	"Resurrection Bag",
	"Defense Grid",

	"Detect Zombie",
	"Berserker",
	"Acid Bath",
	"Lifestealer",
	"Flameshield",
	"Nightcrawler",
	"Rapid Fire",
	"Chainsaw Massacre",
	"Heat Seeker",
	"Speed Freak",
	"Healing Aura",
	"Soulshield",
	"Polymorph",
	"Instagib",

	"Artillery Barrage",
	"Ion Cannon",
	"Nuclear Strike",

	"Shoulder Cannon",
	"Jetpack",
	"Hats"
};
new const String:InfoDesc[][] =
{
	"0",

	"This skill increases your jump height and reduces fall damage.\nDuration: Constant Effect.\nLevel Unlocked: 2",
	"This skill gives bonus health effects when using health recovering items.\nDuration: Constant Effect.\nLevel Unlocked: 4",
	"This skill allows you to carry more ammo.\nDuration: Constant Effect.\nLevel Unlock: 6",
	"This skill replaces your Pistol with a Magnum Pistol when you are incapacitated.\nDuration: Constant Effect.\nLevel Unlock: 8",
	"This skill increases your maximum health by +100hp.\nYou also get health regeneration +1.\nDuration: Constant Effect.\nLevel Unlock: 10",
	"This skill allows you to revive yourself when incapacitated with the [USE] key.\nDuration: 2.5 seconds.\nLevel Unlocked: 11",
	"This skill increases your weapon reloading speed.\nDuration: Constant Effect.\nLevel Unlock: 13",
	"This skill allows you to stab at special infected when captured with the [USE] key.\nDuration: 1.5 seconds.\nLevel Unlocked: 15",
	"This skill makes you harder to kill by increasing your incapacitation health.\nDuration: Constant Effect.\nLevel Unlock: 17",
	"This skill expands your backpack to carry guns and melee weapons.\nDuration: Constant Effect.\nLevel Unlocked: 19",
	"This skill increases your maximum health by +200hp.\nYou also get health regeneration +2.\nDuration: Constant Effect.\nLevel Unlock: 20",
	"This skill reduces health recovering items application time in half.\nDuration: Constant Effect.\nLevel Unlocked: 22",
	"This skill increases your movement speed.\nDuration: Constant Effect.\nLevel Unlock: 24",
	"This skill will equip a free laser sight to any primary weapon\nfor increased accuracy.\nDuration: Constant Effect.\nLevel Unlocked: 26",
	"This skill allows you to refill the M60 and Grenade Launcher at an ammo pile.\nDuration: Constant Effect.\nLevel Unlocked: 29",
	"This skill increases your maximum health by +300hp.\nYou also get health regeneration +3.\nDuration: Constant Effect.\nLevel Unlock: 30",
	"This skill doubles your melee damage output.\nDuration: Constant Effect.\nLevel Unlocked: 32",
	"This skill removes the 'witch stagger' effect when witches bump into you.\nDuration: Constant Effect.\nLevel Unlock: 35",
	"This skill simply allows you to get critical damage hits when you attack.\nDuration: Constant Effect.\nLevel Unlock: 38",
	"This skill increases your maximum health by +400hp.\nYou also get health regeneration +4.\nDuration: Constant Effect.\nLevel Unlock: 40",
	"This skill allows you to reload your M60.\nThe extended cartridge holds 300 rounds.\nDuration: Constant Effect.\nLevel Unlock: 41",
	"This skill automatically brings you back from the dead once per round.\nDuration: Constant Effect.\nLevel Unlocked: 44",
	"This skill upgrades all equipped rifles and smgs to use laser ammunition.\nThe laser rounds do added damage and incinerates enemies.\nDuration: Constant Effect.\nLevel Unlocked: 47",

	"This deployable spawns an ammo pile at your location.\nDuration: 60 seconds.\nRedeployment Time: 5 minutes.\nLevel Unlocked: 1",
	"This deployable incinerates common zombies around its location.\nDuration: 60 seconds.\nRedeployment Time: 5 minutes.\nLevel Unlocked: 7",
	"This deployable stuns Special Infected around its location.\nDuration: 60 seconds.\nRedeployment Time: 5 minutes.\nLevel Unlocked: 14",
	"This deployable spawns a reuseable healing station.\nIn addition it will boost your adrenaline.\nDuration: 60 seconds.\nRedeployment Time: 5 minutes.\nLevel Unlocked: 21",
	"This deployable spawns an autonomous 50cal turret that\nwill attack any infected around its location.\nDuration: 60 seconds.\nRedeployment Time: 5 minutes.\nLevel Unlocked: 28",
	"This deployable spawns a reuseable body bag that brings\ndead survivors back from the dead.\nDuration: 60 seconds.\nRedeployment Time: 5 minutes.\nLevel Unlocked: 34",
	"This deployable creates a shield that prevents Special Infected\nand Tanks from entering its radius.\nIt kills Witches and Commons on contact.\nDuration: 30 seconds.\nRedeployment Time: 5 minutes.\nLevel Unlocked: 42",

	"This ability allows you to see special infected and tanks through walls.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 3",
	"This ability speeds up attacks and gives double damage with melee weapons.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nRequirements: Must have melee weapon.\nLevel Unlocked: 5",
	"This ability makes the spitter goo heal you instead of hurt you.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 9",
	"This ability will heal the user a small portion of damage delivered.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 12",
	"This ability creates a shield of fire on your character\nthat ignites any zombies that come too close.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 16",
	"This ability when active, grants the power of teleportation.\nPress your [Walk] key to cycle between survivors.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 18",
	"This ability rapidly increases the firing rate of the M16 Assault rifle\nand quickly resupplys its used ammunition.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nRequirements: Must have an M16 Assault Rifle.\nLevel Unlocked: 23",
	"This ability gives you a chainsaw with infinite ammo.\nWhen you kill an infected with it you also get bonus xp.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 25",
	"This ability makes the explosive shells from the Grenade Launcher heat seeking.\nIn addition you will have infinite ammo.\nPress the [Walk] key to cycle between target priorities.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nRequirements: Must have Grenade Launcher.\nLevel Unlocked: 27",
	"This ability gives you insanely fast movement speed.\nIn addition, you can use healing items much faster.\nYou will only have 50 Health in this state however.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 31",
	"This ability slowly heals all nearby survivors including the user.\nThe closer a nearby survivor is, the faster they will heal.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 33",
	"This ability creates a powerful energy field around the user\nnegating all damage dealt.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 37",
	"This ability will transform any common zombies into useable items by attacking them.\nThere is a 1-2% chance this could go wrong though.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 39",
	"This ability gives your guns some unique anti-virus coated ammunition, the results\nare extremely deadly to any infected that gets hit with one.\nDuration: 60 seconds.\nReuse Time: 5 minutes.\nLevel Unlocked: 46",

	"This bombardment calls an artillery barrage to your location.\nUseful for clearing an area.\nDuration: 15 seconds.\nReuse Time: 1 Per Campaign.\nLevel Unlocked: 36",
	"This bombardment signals an Ion cannon to blast a fairly large ground area.\nIts ionized rays will burn infectious cells on contact.\nDuration: 15 seconds.\nReuse Time: 1 Per Campaign.\nLevel Unlocked: 43",
	"This bombardment launches an ICBM to your location.\nIt's the ultimate weapon, guaranteed to cleanse any virus, airbourne or otherwise.\nDuration: 15 seconds.\nReuse Time: 1 Per Campaign.\nLevel Unlocked: 48",

	"This special gives you a shoulder mounted cannon. It's auto-fire capabilities \nand manual tuning makes it a very valuable weapon against the zombie hordes.\nDuration: Constant Effect.\nLevel Unlocked: 45",
	"This special gives you a Jetpack. Although it can only be used in finales,\nwhen it is used it gives its wearer a much higher survivability rate.\nDuration: Finale Events Only.\nLevel Unlocked: 49",
	"Instead of receiving the typical\n''I made it all the way to level 50, and all I got was this stupid t-shirt''\nYou have been given 'Hats'. Congratulations!\nDuration: Constant Effect.\nLevel Unlocked: 50"
};
static Handle:hBotControl               = INVALID_HANDLE;
static Handle:hMenuOn                	= INVALID_HANDLE;
static Handle:hHealthDisplay		= INVALID_HANDLE;
static Handle:hDoorsOn                	= INVALID_HANDLE;
static Handle:hBloodmoon               	= INVALID_HANDLE;
static Handle:hBloodmoonWeek            = INVALID_HANDLE;
static Handle:hHell                	= INVALID_HANDLE;
static Handle:hHellWeek                	= INVALID_HANDLE;
static Handle:hCowLevel                	= INVALID_HANDLE;
static Handle:hInferno                	= INVALID_HANDLE;
static Handle:hNightmare                = INVALID_HANDLE;
static Handle:hNightmareBegin           = INVALID_HANDLE;
static Handle:hNightmareTime            = INVALID_HANDLE;
static Handle:hCustomMapsOn           	= INVALID_HANDLE;

static bool:bBotControl			= false;
static bool:bMenuOn			= false;
static bool:bHealthDisplay		= false;
static bool:bDoorsOn			= false;
static bool:bBloodmoon			= false;
static bool:bBloodmoonWeek		= false;
static bool:bHell			= false;
static bool:bHellWeek			= false;
static bool:bCowLevel			= false;
static bool:bInferno			= false;
static bool:bNightmare			= false;
static bool:bDiffOverride		= false;
static bool:bCustomMapsOn		= false;

static iNightmareBegin;
static iNightmareTime;
static iNMTimeExpert;
static iNMTimeAdvanced;
static iNMTimeNormal;
static iNMTimeEasy;
static iSpecialMin;
static iSpecialMax;
static iSpecialAmount;
static iNumDefeats;
static iDifficulty;
static iNumDeaths;
static iMapTimeTick;
static iNightmareTick;
static iCountDownTimer;
static iSpawnBotTick;
static iFinaleStage;
static iFinaleWin;
static iNumTanksWave;
static iNumTanks;
static iAnnounceTick;
static iGasCanPlacementTick;
static iGasCanPoured;
static iTeamScore;
static iCreateInstaCapper;
static iCreateBreeder;
static iSpawnHeavy;
static iZombieType;
static iZombieAmount;
static iDiffOverride;
static iRound = 0;
static iDiffWins;
static iCowLevelSpawns;
static iClipBrush;
static aClipBrush[33];
static iQuantifyWeapons;
static iFinaleCountdown;
static iCheckpoint;
static bool:bCPStartHasExtraData;
static bool:bCPEndHasExtraData;
static Float:CPStartLocA[3];
static Float:CPStartLocB[3];
static Float:CPStartLocC[3];
static Float:CPStartLocD[3];
static Float:CPEndLocA[3];
static Float:CPEndLocB[3];
static Float:CPEndLocC[3];
static Float:CPEndLocD[3];
static Float:CPStartRotate;
static Float:CPEndRotate;
static bool:bFreezeAI;

//Custom Tanks
static Handle:hTankType               = INVALID_HANDLE;
static iTankType;

//PortPoint
static Float:PortPoint[3];

//Voting
static bool:bVoteInProgress = false;
static bool:bVoteChangeMission = false;
static bool:bVoteRestartGame = false;
static bool:bVoteDiffOverride = false;

//Hell//Inferno
static Float:aFogStart[33];
static Float:aFogEnd[33];
static timeofday;
static iCCEnt;
static iFogVolEnt;
static iPrecipitation;
static iGameMode;
static iFogControl;

//Hostname
static Handle:hHostname			= INVALID_HANDLE;

//DATABASE
static Handle:hDataBase 			= INVALID_HANDLE;
static Handle:hDataBaseName			= INVALID_HANDLE;

//DATABASE CLIENT DATA
static cID[33];
static cExp[33];
static cExp_accum[33];
static cLevel[33];
static cLevel_accum[33];
static cLevelReset[33];
static cExpToLevel[33];
static cVoteAccess[33];
static cVoteAccess_accum[33];
static ReadWriteDelay[33];

//Other Arrays
static Character[33];
static cNotifications[33];
static CritMessages[33];
static cLevelUpMessage[33];
static cCampaignBonus[33];
static ReduceSpeed75[33];
static Float:DeathOrigin[33][3];

//Survivor Damage
static iCriticalNotice;
static aDamageType[33];

//ANTI AFK
static Float:AFKAngles[33][3];
static AFKTime[33];

//Gascans
static Float:GCOrigin[30][3];
static Float:GCAngles[30][3];

//Tank Related
static XPDamage[33][33][8];
static ChainsawDamage[33][33];
static TankAbility[33];
static TankAlive[33];
static ShieldsUp[33];
static ShieldState[33];
static GravityClaw[33];
static Rock[33];
static TechTankGun[33][2];
static TankAbilityTimer[33];

//Misc
static MODEL_DEFIB;
static ChoiceDelay[33];
static UseDelay[33];

//Saferoom Door
static iSRDoor;
static iSRDoorStart;
static iSRLocked;
static iSRDoorTick;
static iSRDoorDelay;
static iSRDoorFix;

//RescueZone
static iRescue;
static iRescueZone;
static WaitRescue[33];

//Server Joiner
static String:CurrentClientID[33][24];
static NewClient[33];
static PlayerSpawn[33];
static JoinedServer[33];
static String:DeadPlayer[33][24];
static String:DisconnectPlayer[33][24];
static DisconnectPlayerAmmo[33][3];

//Healing
static Handle:hReviveDuration              = INVALID_HANDLE;
static Handle:hHealDuration              = INVALID_HANDLE;
static Handle:hDefibDuration             = INVALID_HANDLE;
static Float:flReviveDuration;
static Float:flHealDuration;
static Float:flDefibDuration;
static bool:BlockHeal[33];
static Float:BlockHealTime[33];
static SavedHealth[33];
static HealthMap[33];
static String:HealthMapName[33][24];
static DefibHealth[33];

//WeaponDrop Saver
static String:cSlot0Weapon[33][32];
static String:cSlot1Weapon[33][32];
static String:cSlot2Weapon[33][32];
static String:cSlot3Weapon[33][32];
static String:cSlot4Weapon[33][32];
static cSlot0Upgrade[33];
static cSlot0Clip[33];
static cSlot0UpgradeAmmo[33];
static cSlot0Ammo[33];
static cSlot0AmmoOffset[33];
static cSlot1Clip[33];
static cSlot1Dual[33];
static WeaponsRestored[33];

//Level Perks
static ReviveStart[33];
static Float:ReviveStartTime[33];
static KnifeStart[33];
static Float:KnifeStartTime[33];
static Teleporter[33];

static CannonEnt[33];
static CannonAmmo[33];
static CannonOn[33];
static CannonNeverTarget[33];
static CannonTargetFirst[33];
static Float:CannonRate[33];
static CannonEquip[33];

static JetPackAEnt[33];
static JetPackBEnt[33];
static JetPackOn[33];
static bool:JetPackAscend[33];
static bool:JetPackDescend[33];
static bool:JetPackFlight[33];
static JetPackParticleTimer[33];
static JetPackFuel[33];
static JetPackJump[33];
static JetPackDisrupt[33];
static JetPackEquip[33];
static JetPackIdle[33];
static Float:JetPackIdleOrigin[33][3];

static HatEnt[33];
static HatEquip[33];
static HatIndex[33];

static Handle:hViewTimer[33];

//Skills Arrays
static SecChance[33];
static SecChanceTimer[33];

//Deployable Arrays
static UVLightModel[33];
static UVLightGlow[33];
static EmitterSpeaker[33];
static EmitterBase[33];
static Sentry[33];
static SentryEnemy[33];
static Float:SentryAngles[33][2];
static Float:SentryTime[33][3];
static SentryNeverTarget[33];
static SentryTargetFirst[33];
static HSModel[33];
static HSTrigger[33];
static RBModel[33];
static RBTrigger[33];
static DefenseGridEnt[33][8];
static AmmoPile[33];

//Ability Arrays
static HealingAuraOn[33];
static SoulShieldOn[33];
static LifeStealerOn[33];
static BerserkerOn[33];
static NightCrawlerOn[33];
static RapidFireOn[33];
static FlameShieldOn[33];
static InstaGibOn[33];
static PolyMorphOn[33];
static DetectGZOn[33];
static AcidBathOn[33];
static ChainsawMassOn[33];
static HeatSeekerOn[33];
static SpeedFreakOn[33];

static ZombieClone[33];
static HealingAuraPlayer[33];
static HealingAuraTarget[33];
static SoulShieldGlow[33][2];
static HeatSeekerTarget[33];

//Bombardment Arrays 
static Float:FindFloorfloor[3]; 
static Float:FindFloorceiling[3]; 
static Float:FindFloordirection[3]; 
static Float:FindFloortotalHeight;

static ArtyFlareEnts[33][6];
static Float:ArtilleryOrigin[33][3];

static IonFlareEnts[33][6];
static Float:IonCannonOrigin[33][3];
static Float:IonBeamOrigin[33][6][3];
static Float:IonBeamDegrees[33][6];
static IonBeamSprite;
static IonHaloSprite;

static NukeFlareEnts[33][6];
static bool:DisableBombardments = false;

//Timer Arrays
static UVLightTimer[33];
static EmitterTimer[33];
static SentryTimer[33];
static HSTimer[33];
static RBTimer[33];
static DefenseGridTimer[33];
static AmmoTimer[33];

static DetectGZTimer[33];
static AcidBathTimer[33];
static ChainsawMassTimer[33];
static HeatSeekerTimer[33];
static SpeedFreakTimer[33];
static HealingAuraTimer[33];
static SoulShieldTimer[33];
static LifeStealerTimer[33];
static BerserkerTimer[33];
static NightCrawlerTimer[33];
static RapidFireTimer[33];
static FlameShieldTimer[33];
static InstaGibTimer[33];
static PolyMorphTimer[33];

static ArtilleryAmmo[33];
static IonCannonAmmo[33];
static NukeAmmo[33];

static ArtilleryTimer[33];
static IonCannonTimer[33];
static NukeTimer[33];

public OnPluginStart()
{
	/*Commands*/
	RegConsoleCmd("csm", CharMenu);
	RegConsoleCmd("join", Join);
	RegConsoleCmd("info", ShowInfo);
	RegConsoleCmd("killself", KillSelf);
	RegConsoleCmd("menu", ShowMenu);
	RegConsoleCmd("store", StoreItem);
	RegConsoleCmd("drop", WeaponDrop);
	RegConsoleCmd("backpack", BackpackMenu);
	RegConsoleCmd("deployables", DeployablesMenu);
	RegConsoleCmd("abilities", AbilitiesMenu);
	RegConsoleCmd("bombardments", BombardmentsMenu);
	RegConsoleCmd("specials", SpecialsMenu);
	RegConsoleCmd("shouldercannon", ShoulderCannonMenu);
	RegConsoleCmd("jetpack", JetPackMenu);
	RegConsoleCmd("jetpackhelp", JetPackHelpMenu);
	RegConsoleCmd("hats", HatsMenu);
	RegConsoleCmd("choosehat", ChooseHatMenu);
	RegConsoleCmd("sentrycontrol", SentryControlMenu);
	RegConsoleCmd("infoskills", InfoSkills);
	RegConsoleCmd("infodeployables", InfoDeployables);
	RegConsoleCmd("infoabilities", InfoAbilities);
	RegConsoleCmd("infobombardments", InfoBombardments);
	RegConsoleCmd("infospecials", InfoSpecials);
	RegConsoleCmd("resetlevel", ResetLevel);
	RegConsoleCmd("teams", ShowTeams);
	RegConsoleCmd("callvote", VoteHandler);
	RegConsoleCmd("kickvote", KickvoteMenu);
	RegConsoleCmd("votekick", KickvoteMenu);

	RegAdminCmd("test", TestMenu, ADMFLAG_KICK, "");
	RegAdminCmd("test2", TestMenu2, ADMFLAG_KICK, "");
	//RegAdminCmd("test3", TestMenu3, ADMFLAG_KICK, "");
	//RegAdminCmd("test4", TestMenu4, ADMFLAG_KICK, "");
	//RegAdminCmd("test5", TestMenu5, ADMFLAG_KICK, "");

	RegAdminCmd("veto", VetoHandler, ADMFLAG_KICK, "veto");
	RegAdminCmd("passvote", PassVoteHandler, ADMFLAG_KICK, "passvote");

	RegAdminCmd("sm_clientsetvoting", Command_SetVoting, ADMFLAG_KICK, "sm_clientsetvoting <#userid|name> [level]");

	RegAdminCmd("sm_nightmare", Command_Nightmare, ADMFLAG_KICK, "Nightmare Gamemode On/Off");
	RegAdminCmd("sm_rescue", Command_SendInRescueVehicle, ADMFLAG_KICK, "Send Rescue Vehicle");
	//RegAdminCmd("sm_hell", Command_Hell, ADMFLAG_KICK, "Hell Gamemode On/Off");
	//RegAdminCmd("sm_inferno", Command_Inferno, ADMFLAG_KICK, "Inferno Gamemode On/Off");
	//RegAdminCmd("sm_bloodmoon", Command_Bloodmoon, ADMFLAG_KICK, "Bloodmoon Gamemode On/Off");

	AddCommandListener(Command_JoinTeam, "jointeam");

	hHostname = FindConVar("hostname");
	hBotControl = CreateConVar("bot_control", "1", "Auto manage bot spawning?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hMenuOn = CreateConVar("menu_on", "1", "Level menu on or off?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hHealthDisplay = CreateConVar("health_display_on", "1", "Display Tank health?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hDoorsOn = CreateConVar("doors_on", "1", "Lockdown Saferoom Doors Enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hBloodmoon = CreateConVar("bloodmoon_on", "0", "Is bloodmoon gamemode enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hBloodmoonWeek = CreateConVar("bloodmoon_week_on", "0", "Is bloodmoon week gamemode enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hHell = CreateConVar("hell_on", "0", "Is hell gamemode enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hHellWeek = CreateConVar("hell_week_on", "0", "Is hell week gamemode enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hCowLevel = CreateConVar("cowlevel_on", "0", "Is cow level gamemode enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hInferno = CreateConVar("inferno_on", "0", "Is inferno gamemode enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hNightmare = CreateConVar("nightmare_on", "0", "Is nightmare gamemode enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hNightmareBegin = CreateConVar("nightmare_begin", "0", "Begin nightmare mode countdown?", FCVAR_PLUGIN, true, -1.0, true, 1.0);
	hNightmareTime = CreateConVar("nightmare_time", "570", "Seconds until Nightmare countdown begins.", FCVAR_PLUGIN, true, 0.0, true, 1000.0);
	hCustomMapsOn = CreateConVar("custom_maps_on","0", "Are custom maps enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	hTankType = CreateConVar("tank_type", "0", "Sets the next Tank to be this type.", FCVAR_PLUGIN, true, 0.0, true, 999.0);

	bBotControl = GetConVarBool(hBotControl);
	bMenuOn = GetConVarBool(hMenuOn);
	bHealthDisplay = GetConVarBool(hHealthDisplay);
	bDoorsOn = GetConVarBool(hDoorsOn);
	bBloodmoon = GetConVarBool(hBloodmoon);
	bBloodmoonWeek = GetConVarBool(hBloodmoonWeek);
	bHell = GetConVarBool(hHell);
	bHellWeek = GetConVarBool(hHellWeek);
	bCowLevel = GetConVarBool(hCowLevel);
	bInferno = GetConVarBool(hInferno);
	bNightmare = GetConVarBool(hNightmare);
	iNightmareBegin = GetConVarInt(hNightmareBegin);
	iNightmareTime = GetConVarInt(hNightmareTime);
	bCustomMapsOn = GetConVarBool(hCustomMapsOn);
	iTankType = GetConVarInt(hTankType);

	hReviveDuration = FindConVar("survivor_revive_duration");
	hHealDuration = FindConVar("first_aid_kit_use_duration");
	hDefibDuration = FindConVar("defibrillator_use_duration");

	hDataBaseName = CreateConVar("level50_db","default","Configuration read from databases.cfg.",FCVAR_PLUGIN);

	HookConVarChange(hBotControl, BotControlChanged);
	HookConVarChange(hMenuOn, MenuChanged);
	HookConVarChange(hHealthDisplay, HealthDisplayChanged);
	HookConVarChange(hDoorsOn, DoorsChanged);
	HookConVarChange(hBloodmoon, BloodmoonChanged);
	HookConVarChange(hBloodmoonWeek, BloodmoonWeekChanged);
	HookConVarChange(hHell, HellChanged);
	HookConVarChange(hHellWeek, HellWeekChanged);
	HookConVarChange(hCowLevel, CowLevelChanged);
	HookConVarChange(hInferno, InfernoChanged);
	HookConVarChange(hNightmare, NightmareChanged);
	HookConVarChange(hNightmareBegin, NightmareBeginChanged);
	HookConVarChange(hNightmareTime, NightmareTimeChanged);

	HookConVarChange(hReviveDuration, UseDurationChanged);
	HookConVarChange(hHealDuration, UseDurationChanged);
	HookConVarChange(hDefibDuration, UseDurationChanged);

	HookConVarChange(hCustomMapsOn, CustomMapsOnChanged);
	HookConVarChange(hTankType, TankTypeChanged);

	HookEvent("ability_use", Ability_Use);
	HookEvent("adrenaline_used", Adrenaline_Used);
	HookEvent("ammo_pile_weapon_cant_use_ammo", Ammo_Pile_Cant_Use);
	HookEvent("charger_carry_end", Event_First);
	HookEvent("charger_carry_start", Event_Third);
	HookEvent("charger_impact", Charger_Impact);
	HookEvent("charger_pummel_end",	Event_First);
	HookEvent("charger_pummel_start", Charger_Pummel_Start);
	HookEvent("charger_pummel_start", Event_Third);
	HookEvent("defibrillator_begin", Defibrillator_Begin);
	HookEvent("defibrillator_used", Defibrillator_Used);
	HookEvent("difficulty_changed", Difficulty_Changed);
	HookEvent("entity_shoved", Entity_Shoved);
	HookEvent("finale_escape_start", Finale_Escape_Start);
	HookEvent("finale_start", Finale_Start, EventHookMode_Pre);
	HookEvent("finale_vehicle_leaving", Finale_Vehicle_Leaving);
	HookEvent("finale_vehicle_ready", Finale_Vehicle_Ready);
	HookEvent("finale_win", Finale_Win);
	HookEvent("gauntlet_finale_start", Finale_Start);
	HookEvent("gascan_pour_completed", Gascan_Pour_Completed);
	HookEvent("heal_begin", Heal_Begin);
	HookEvent("heal_success", Heal_Success);
	HookEvent("item_pickup", Item_Pickup);
	HookEvent("jockey_ride", Jockey_Ride);
	HookEvent("jockey_ride", Event_Third);
	HookEvent("jockey_ride_end", Event_First);
	HookEvent("lunge_pounce", Lunge_Pounce);
	HookEvent("lunge_pounce", Event_Third);
	HookEvent("map_transition", Map_Transition);
	HookEvent("mission_lost", Mission_Lost);
	HookEvent("pills_used", Pills_Used);
	HookEvent("player_death", Player_Death);
	HookEvent("player_hurt", Player_Hurt);
	HookEvent("player_incapacitated", Player_Incapacitated);
	HookEvent("player_incapacitated_start", Player_Incap_Start);
	HookEvent("player_ledge_grab", Event_Third1);
	HookEvent("player_now_it", Player_Now_It);
	HookEvent("player_shoved", Player_Shoved);
	HookEvent("player_spawn", Player_Spawn);
	HookEvent("player_team", Player_Team);
	HookEvent("player_use", Player_Use);
	HookEvent("pounce_end",	Event_First);
	HookEvent("revive_begin", Event_Third1);
	HookEvent("revive_end",	Event_First1);
	HookEvent("revive_success", Revive_Success);
	HookEvent("revive_success", Event_First1);
	HookEvent("round_end", Round_End);
	HookEvent("round_start", Round_Start);
	HookEvent("survivor_rescued", Survivor_Rescued);
	HookEvent("tongue_grab", Tongue_Grab);
	HookEvent("tongue_grab", Event_Third);
	HookEvent("tongue_release", Event_First);
	HookEvent("weapon_drop", Weapon_Drop);
	HookEvent("weapon_fire", Weapon_Fire);
	HookEvent("weapon_reload", Weapon_Reload);

	HookUserMessage(GetUserMessageId("VoteStart"), EventVoteStart, true);
	HookUserMessage(GetUserMessageId("VotePass"), EventVotePass, true);
	HookUserMessage(GetUserMessageId("VoteFail"), EventVoteFail, true);

	LoadTranslations("common.phrases");

	CreateTimer(0.1, TimerUpdate01, _, TIMER_REPEAT);
	CreateTimer(1.0, TimerUpdate1, _, TIMER_REPEAT);

	for (new i=1; i<=MaxClients; i++)
	{
		strcopy(CurrentClientID[i], 24, "");
	}
}
//=============================
// StartUp
//=============================
public OnMapStart()
{
	GetCurrentMap(current_map, sizeof(current_map));

	PrecacheParticle(PARTICLE_SMOKE);
	//PrecacheParticle(PARTICLE_SMOKERCLOUD);
	PrecacheParticle(PARTICLE_FIRE);
	PrecacheParticle(PARTICLE_WARP);
	PrecacheParticle(PARTICLE_SPIT);
	PrecacheParticle(PARTICLE_ELEC);
	PrecacheParticle(PARTICLE_BLOOD_EXPLODE);
	PrecacheParticle(PARTICLE_SPARKSA);
	PrecacheParticle(PARTICLE_SPARKSB);
	PrecacheParticle(PARTICLE_EXPLODE);
	PrecacheParticle(PARTICLE_METEOR);
	PrecacheParticle(PARTICLE_BERSERKER);
	PrecacheParticle(PARTICLE_NIGHTCRAWLER);
	PrecacheParticle(PARTICLE_SECONDCHANCE);
	PrecacheParticle(PARTICLE_FLAMESHIELD);
	//PrecacheParticle(PARTICLE_DETECTGREATERZ);
	//PrecacheParticle(PARTICLE_VOMITCLOUD);
	PrecacheParticle(PARTICLE_POLYMORPH);
	PrecacheParticle(PARTICLE_FLARE);
	PrecacheParticle(PARTICLE_DEMON_SMOKE);
	//PrecacheParticle(PARTICLE_DEMON_HEAT);
	PrecacheParticle(PARTICLE_FUSE);

	PrecacheParticle(PARTICLE_RIFLE_FLASH);
	PrecacheParticle(PARTICLE_50CAL_FLASH);
	PrecacheParticle(PARTICLE_50CAL_TRACER);
	PrecacheParticle(PARTICLE_BLOOD);
	PrecacheParticle(PARTICLE_LS_BOLT);
	PrecacheParticle(PARTICLE_LASER);
	//PrecacheParticle(PARTICLE_SHOCK);
	PrecacheParticle(PARTICLE_DEFENSEGRID_GLOW);
	PrecacheParticle(PARTICLE_SOULSHIELD_GLOW);

	PrecacheParticle(PARTICLE_JETIDLE);
	PrecacheParticle(PARTICLE_JETFIRE);
	PrecacheParticle(PARTICLE_JETSMOKE);

	PrecacheParticle(PARTICLE_NUKEHIT);
	PrecacheParticle(PARTICLE_NUKEWAVE);
	PrecacheParticle(PARTICLE_NUKESMOKEA);
	PrecacheParticle(PARTICLE_NUKESMOKEB);
	//PrecacheParticle(PARTICLE_NUKECHUNKA);
	//PrecacheParticle(PARTICLE_NUKECHUNKB);
	PrecacheParticle(PARTICLE_NUKEDEBRISA);
	PrecacheParticle(PARTICLE_NUKEDEBRISB);
	PrecacheParticle(PARTICLE_NUKEFIREA);
	PrecacheParticle(PARTICLE_NUKEFIREB);
	PrecacheParticle(PARTICLE_NUKEFIREC);

   	CheckModelPreCache(MODEL_NICK);
   	CheckModelPreCache(MODEL_ROCHELLE);
   	CheckModelPreCache(MODEL_COACH);
   	CheckModelPreCache(MODEL_ELLIS);
   	CheckModelPreCache(MODEL_BILL);
    	CheckModelPreCache(MODEL_ZOEY);
    	CheckModelPreCache(MODEL_FRANCIS);
    	CheckModelPreCache(MODEL_LOUIS);

    	CheckModelPreCache(MODEL_TANK_DLC3);

    	CheckModelPreCache("models/infected/hulk.mdl");
    	CheckModelPreCache("models/infected/witch.mdl");
	CheckModelPreCache("models/infected/witch_bride.mdl");
   	CheckModelPreCache("models/infected/boomette.mdl");
    	CheckModelPreCache("models/infected/common_male_ceda.mdl");
    	CheckModelPreCache("models/infected/common_male_clown.mdl");
    	CheckModelPreCache("models/infected/common_male_mud.mdl");
    	CheckModelPreCache("models/infected/common_male_roadcrew.mdl");
    	CheckModelPreCache("models/infected/common_male_riot.mdl");
    	CheckModelPreCache("models/infected/common_male_fallen_survivor.mdl");
    	CheckModelPreCache("models/infected/common_male_jimmy.mdl");

	CheckModelPreCache(MODEL_V_FIREAXE);
	CheckModelPreCache(MODEL_V_FRYING_PAN);
	CheckModelPreCache(MODEL_V_MACHETE);
	CheckModelPreCache(MODEL_V_BAT);
	CheckModelPreCache(MODEL_V_CROWBAR);
	CheckModelPreCache(MODEL_V_CRICKET_BAT);
	CheckModelPreCache(MODEL_V_TONFA);
	CheckModelPreCache(MODEL_V_KATANA);
	CheckModelPreCache(MODEL_V_ELECTRIC_GUITAR);
	CheckModelPreCache(MODEL_V_GOLFCLUB);

	CheckModelPreCache(MODEL_V_ARM);
	CheckModelPreCache(MODEL_V_FOOT);
	CheckModelPreCache(MODEL_V_FOAMFINGER);
	CheckModelPreCache(MODEL_V_MUFFLER);
	CheckModelPreCache(MODEL_V_CONCRETE1);
	CheckModelPreCache(MODEL_V_CONCRETE2);

	CheckModelPreCache(MODEL_M60);
	CheckModelPreCache(MODEL_50CAL);
	CheckModelPreCache(MODEL_PIPEBOMB);

	CheckModelPreCache(MODEL_GASCAN);
	CheckModelPreCache(MODEL_PROPANE);
	CheckModelPreCache(MODEL_OXYGEN);
	CheckModelPreCache(MODEL_FIREWORKS);
	CheckModelPreCache(MODEL_FLARE);
	CheckModelPreCache(MODEL_MISSILE);
	CheckModelPreCache(MODEL_DEFENSEGRID);

	CheckModelPreCache(MODEL_COWPILE);
	CheckModelPreCache(MODEL_COW);
	CheckModelPreCache(MODEL_GIFT);

	for (new i=0; i<=35; i++)
	{
		CheckModelPreCache(HatFileName[i]);
	}
	
	CheckModelPreCache("models/props_fairgrounds/mortar_rack.mdl");
    	CheckModelPreCache("models/props_misc/bodybag_01/bodybag_01.mdl");
    	CheckModelPreCache("models/props_fairgrounds/monitor_speaker.mdl");
    	CheckModelPreCache("models/props_interiors/makeshift_stove_battery.mdl");
    	CheckModelPreCache("models/props_lighting/light_battery_rigged_01.mdl");
    	CheckModelPreCache("models/props_vehicles/tire001c_car.mdl");
	CheckModelPreCache("models/props_unique/airport/atlas_break_ball.mdl");
    	CheckModelPreCache("models/props_unique/hospital/iv_pole.mdl");
    	CheckModelPreCache("models/props_doors/checkpoint_door_-02.mdl");
    	CheckModelPreCache("models/props_debris/concrete_chunk01a.mdl");
    	CheckModelPreCache("models/props_unique/spawn_apartment/coffeeammo.mdl");
    	CheckModelPreCache("models/deadbodies/dead_male_torso_01.mdl");
    	CheckModelPreCache("models/props_crates/static_crate_40.mdl");

	CheckSoundPreCache("ambient/ambience/rainscapes/rain/debris_05.wav");
	CheckSoundPreCache("ambient/fire/gascan_ignite1.wav");
	CheckSoundPreCache("ambient/materials/ripped_screen01.wav");
	CheckSoundPreCache("ambient/energy/spark5.wav");
	CheckSoundPreCache("ambient/energy/spark6.wav");
	CheckSoundPreCache("ambient/energy/zap5.wav");
	CheckSoundPreCache("ambient/energy/zap6.wav");
	CheckSoundPreCache("ambient/energy/zap7.wav");
	CheckSoundPreCache("ambient/energy/zap8.wav");
	CheckSoundPreCache("ambient/energy/zap9.wav");
	CheckSoundPreCache("ambient/tones/under1.wav");
	CheckSoundPreCache("items/suitchargeok1.wav");
	CheckSoundPreCache("npc/infected/action/die/male/death_42.wav");
	CheckSoundPreCache("npc/infected/action/die/male/death_43.wav");
	CheckSoundPreCache("npc/mega_mob/mega_mob_incoming.wav");
	CheckSoundPreCache("player/charger/hit/charger_smash_02.wav");
	CheckSoundPreCache("player/tank/voice/growl/tank_climb_01.wav");
	CheckSoundPreCache("player/spitter/voice/warn/spitter_spit_02.wav");
	CheckSoundPreCache("player/survivor/voice/teengirl/taunt28.wav");
	CheckSoundPreCache("player/survivor/voice/teengirl/taunt29.wav");
	CheckSoundPreCache("player/survivor/voice/teengirl/taunt35.wav");
	CheckSoundPreCache("player/survivor/voice/teengirl/taunt39.wav");
	CheckSoundPreCache("player/survivor/voice/biker/taunt01.wav");
	CheckSoundPreCache("player/survivor/voice/biker/taunt02.wav");
	CheckSoundPreCache("player/survivor/voice/biker/taunt03.wav");
	CheckSoundPreCache("player/survivor/voice/biker/taunt05.wav");
	CheckSoundPreCache("player/survivor/voice/namvet/taunt07.wav");
	CheckSoundPreCache("player/survivor/voice/namvet/taunt08.wav");
	CheckSoundPreCache("player/survivor/voice/namvet/taunt09.wav");
	CheckSoundPreCache("player/survivor/voice/manager/taunt01.wav");
	CheckSoundPreCache("player/survivor/voice/manager/taunt02.wav");
	CheckSoundPreCache("player/survivor/voice/manager/taunt03.wav");
	CheckSoundPreCache("player/survivor/voice/manager/taunt04.wav");
	CheckSoundPreCache("player/survivor/voice/coach/taunt01.wav");
	CheckSoundPreCache("player/survivor/voice/coach/taunt02.wav");
	CheckSoundPreCache("player/survivor/voice/coach/taunt03.wav");
	CheckSoundPreCache("player/survivor/voice/coach/taunt04.wav");
	CheckSoundPreCache("player/survivor/voice/gambler/taunt01.wav");
	CheckSoundPreCache("player/survivor/voice/gambler/taunt04.wav");
	CheckSoundPreCache("player/survivor/voice/gambler/taunt07.wav");
	CheckSoundPreCache("player/survivor/voice/gambler/taunt08.wav");
	CheckSoundPreCache("player/survivor/voice/producer/taunt01.wav");
	CheckSoundPreCache("player/survivor/voice/producer/taunt02.wav");
	CheckSoundPreCache("player/survivor/voice/producer/taunt04.wav");
	CheckSoundPreCache("player/survivor/voice/producer/taunt06.wav");
	CheckSoundPreCache("player/survivor/voice/mechanic/taunt02.wav");
	CheckSoundPreCache("player/survivor/voice/mechanic/taunt05.wav");
	CheckSoundPreCache("player/survivor/voice/mechanic/taunt07.wav");
	CheckSoundPreCache("player/survivor/voice/mechanic/taunt08.wav");
	CheckSoundPreCache("player/boomer/explode/explo_medium_09.wav");
	CheckSoundPreCache("player/boomer/explode/explo_medium_10.wav");
	CheckSoundPreCache("player/boomer/explode/explo_medium_14.wav");
	CheckSoundPreCache("player/heartbeatloop.wav");
	CheckSoundPreCache("npc/infected/gore/bullets/bullet_impact_04.wav");
	CheckSoundPreCache("ui/pickup_misc42.wav");
	CheckSoundPreCache("ui/critical_event_1.wav");
	CheckSoundPreCache("ui/beep22.wav");
	CheckSoundPreCache("weapons/fx/nearmiss/bulletltor13.wav");
	CheckSoundPreCache(SOUND_IMPACT);
	CheckSoundPreCache(SOUND_50CAL_FIRE);
	CheckSoundPreCache(SOUND_M60_FIRE);
	CheckSoundPreCache(SOUND_CRACKLE);
	CheckSoundPreCache(SOUND_ARTILLERY);
	CheckSoundPreCache(SOUND_IONCANNON);
	CheckSoundPreCache(SOUND_JETPACKFIRE);
	CheckSoundPreCache(SOUND_JETPACKIDLE);
	CheckSoundPreCache(SOUND_NUKERUMBLE);
	CheckSoundPreCache(SOUND_NUKEEXPLODE);

	//Model Indexes
	IonBeamSprite = PrecacheModel("materials/sprites/laserbeam.vmt", true);
	IonHaloSprite = PrecacheModel("materials/sprites/glow01.vmt", true);
	MODEL_DEFIB = PrecacheModel("models/w_models/weapons/w_eq_defibrillator.mdl", true);

	iNumDefeats = 0;
	bVoteInProgress = false;

	ReturnChapterData();
	iFogControl = 0;
}
stock CheckModelPreCache(const String:Modelfile[])
{
	if (!IsModelPrecached(Modelfile))
	{
		PrecacheModel(Modelfile, true);
		PrintToServer("Precaching Model:%s",Modelfile);
	}
}
stock CheckSoundPreCache(const String:Soundfile[])
{
	PrecacheSound(Soundfile, true);
	PrintToServer("Precaching Sound:%s",Soundfile);
}
public OnConfigsExecuted()
{
	if (hDataBase == INVALID_HANDLE)
	{
		ConnectDB();
	}
}
public BotControlChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	bBotControl = GetConVarBool(hBotControl);
}
public CustomMapsOnChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	bCustomMapsOn = GetConVarBool(hCustomMapsOn);
}
public TankTypeChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	iTankType = GetConVarInt(hTankType);
}
public MenuChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	bMenuOn = GetConVarBool(hMenuOn);
}
public HealthDisplayChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	bHealthDisplay = GetConVarBool(hHealthDisplay);
}
public DoorsChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hDoorsOn)
	{
		bDoorsOn = GetConVarBool(hDoorsOn);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			new entity = -1;
			while ((entity = FindEntityByClassname(entity, "prop_door_rotating_checkpoint")) != INVALID_ENT_REFERENCE)
			{
				if (iChapter == 20 && iChapterStage == 4)
				{
					return;
				}
				decl String:model[42];
            			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
				//PrintToServer("%s", model);
				if (StrContains(model, "models/bts_mdl/prison_door2.mdl", false) != -1 || StrContains(model, "models/weapons/w_c4.mdl", false) != -1 || 
StrContains(model, "models/bts_mdl/bts_vaultdoor02.mdl", false) != -1 || StrContains(model, "models/surgeon/ambulancedoor_rt.mdl", false) != -1 || StrContains(model, "models/surgeon/ambulancedoor_lf.mdl", false) != -1)
				{
					return;
				}
				if (GetEntProp(entity, Prop_Data, "m_hasUnlockSequence") == 0)
				{
					iSRDoor = entity;
					if (GetEntProp(entity, Prop_Data, "m_eDoorState") == 2)
					{
						if (newval == 1)
						{
							AcceptEntityInput(entity, "Close");
							SetVariantString("spawnflags 40960");
    							AcceptEntityInput(entity, "AddOutput");
							iSRLocked = 1;
						}
						else if (newval == 0)
						{
							SetVariantString("spawnflags 8192");
    							AcceptEntityInput(entity, "AddOutput");
							iSRLocked = 0;
						}
					}
					else if (GetEntProp(entity, Prop_Data, "m_eDoorState") == 0)
					{
						if (newval == 1)
						{
							SetVariantString("spawnflags 40960");
    							AcceptEntityInput(entity, "AddOutput");
							iSRLocked = 1;
						}
						else if (newval == 0)
						{
							SetVariantString("spawnflags 8192");
    							AcceptEntityInput(entity, "AddOutput");
    							AcceptEntityInput(entity, "Open");
							iSRLocked = 0;
						}
					}	
				}
			}
		}
	}
}
public BloodmoonChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hBloodmoon)
	{
		bBloodmoon = GetConVarBool(hBloodmoon);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			if (newval == 1)
			{
				iDiffWins = 0;
				if (bHell)
				{
					SetConVarBool(hHell, false);
				}
				else if (bCowLevel)
				{
					SetConVarBool(hCowLevel, false);
				}
				else if (bInferno)
				{
					SetConVarBool(hInferno, false);
				}
			}
			AutoDifficulty(true);
		}
	}
}
public BloodmoonWeekChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hBloodmoonWeek)
	{
		bBloodmoonWeek = GetConVarBool(hBloodmoonWeek);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			if (newval == 1)
			{
				SetConVarBool(hBloodmoon, true);
			}
		}
	}
}
public HellChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hHell)
	{
		bHell = GetConVarBool(hHell);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			if (newval == 1)
			{
				if (bBloodmoon)
				{
					SetConVarBool(hBloodmoon, false);
				}
				else if (bCowLevel)
				{
					SetConVarBool(hCowLevel, false);
				}
				else if (bInferno)
				{
					SetConVarBool(hInferno, false);
				}
			}
			AutoDifficulty(true);
		}
	}
}
public HellWeekChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hHellWeek)
	{
		bHellWeek = GetConVarBool(hHellWeek);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			if (newval == 1)
			{
				SetConVarBool(hHell, true);
			}
		}
	}
}
public CowLevelChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hCowLevel)
	{
		bCowLevel = GetConVarBool(hCowLevel);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			if (newval == 1)
			{
				if (bBloodmoon)
				{
					SetConVarBool(hBloodmoon, false);
				}
				else if (bHell)
				{
					SetConVarBool(hHell, false);
				}
				else if (bInferno)
				{
					SetConVarBool(hInferno, false);
				}
			}
			else if (newval == 0)
			{
				RemoveCowSpawns();
				iCowLevelSpawns = 0;
			}
			AutoDifficulty(true);
		}
	}
}
public InfernoChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hInferno)
	{
		bInferno = GetConVarBool(hInferno);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			if (newval == 1)
			{
				if (bHell)
				{
					SetConVarBool(hHell, false);
				}
				else if (bBloodmoon)
				{
					SetConVarBool(hBloodmoon, false);
				}
				else if (bCowLevel)
				{
					SetConVarBool(hCowLevel, false);
				}
			}
			AutoDifficulty(true);
		}
	}
}
public NightmareChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hNightmare)
	{
		bNightmare = GetConVarBool(hNightmare);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			if (newval == 1)
			{
				UnlockSRDoor();
				DisableAbilitiesAll();
				RemoveAttachmentsAll();
				DisableClientPerksAll();
			}
			else if (newval == 0)
			{
				iNightmareTick = 0;
			}
			AutoDifficulty(true);
		}
	}
}
public NightmareBeginChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hNightmareBegin)
	{
		iNightmareBegin = GetConVarInt(hNightmareBegin);
		new oldval = StringToInt(oldValue);
		new newval = StringToInt(newValue);
		if (oldval != newval)
		{
			if (newval == 0 || newval == -1)
			{
				iNightmareTick = 0;
				SetConVarBool(hNightmare, false);
			}
			else
			{
				iNightmareTick = 0;
			}
		}
	}
}
public NightmareTimeChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == hNightmareTime)
	{
		iNightmareTime = GetConVarInt(hNightmareTime);
	}
}
public UseDurationChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	flReviveDuration = GetConVarFloat(hReviveDuration);
	flHealDuration = GetConVarFloat(hHealDuration);
	flDefibDuration = GetConVarFloat(hDefibDuration);
}
//=============================
//	EVENTS
//=============================
public Action:EventVoteStart(UserMsg:msg_id, Handle:bf, const players[], playersNum, bool:reliable, bool:init)
{
	bVoteInProgress = true;
}
public Action:EventVotePass(UserMsg:msg_id, Handle:bf, const players[], playersNum, bool:reliable, bool:init)
{
	bVoteInProgress = false;
	if (bMenuOn)
	{
		if (bVoteChangeMission)
		{
			KickAIBots();
			bVoteChangeMission = false;
			if (bCowLevel)
			{
				iDiffWins = 0;
				SetConVarBool(hCowLevel, false);
			}
			else if (bInferno)
			{
				iDiffWins = 0;
				SetConVarBool(hInferno, false);
			}
			else if (bHell)
			{
				iDiffWins = 0;
				SetConVarBool(hHell, false);
				SetConVarInt(FindConVar("director_panic_forever"), 0);
			}
			else if (bBloodmoon)
			{
				iDiffWins = 0;
				SetConVarBool(hBloodmoon, false);
				SetConVarInt(FindConVar("director_panic_forever"), 0);
			}
		}
		else if (bVoteRestartGame)
		{
			KickAIBots();
			bVoteRestartGame = false;
			if (bCowLevel)
			{
				iDiffWins = 0;
				SetConVarBool(hCowLevel, false);
			}
			else if (bInferno)
			{
				iDiffWins = 0;
				SetConVarBool(hInferno, false);
			}
			else if (bHell)
			{
				iDiffWins = 0;
				SetConVarBool(hHell, false);
				SetConVarInt(FindConVar("director_panic_forever"), 0);
			}
			else if (bBloodmoon)
			{
				iDiffWins = 0;
				SetConVarBool(hBloodmoon, false);
				SetConVarInt(FindConVar("director_panic_forever"), 0);
			}
		}
		else if (bVoteDiffOverride)
		{
			bDiffOverride = true;
			iDiffOverride = 0;
			bVoteDiffOverride = false;
		}
	}		
}
public Action:EventVoteFail(UserMsg:msg_id, Handle:bf, const players[], playersNum, bool:reliable, bool:init)
{
	bVoteInProgress = false;
	bVoteChangeMission = false;
	bVoteDiffOverride = false;
	bVoteRestartGame = false;		
}
public OnClientPostAdminCheck(client)
{
	if (bMenuOn)
	{
		SDKHook(client, SDKHook_WeaponDrop, OnWeaponDrop);
		SDKHook(client, SDKHook_OnTakeDamage, OnPlayerTakeDamage);

		if (!IsFakeClient(client))
		{
			new String:steamid[24];
			GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
			ResetDatabaseArrays(client);
			ResetClientArrays(client);
			if (ReadWriteDelay[client] == 0)
			{
				ReadWriteDelay[client] = 1;
				ReadWriteDB(steamid, client, cExp_accum[client], cLevel_accum[client], cVoteAccess_accum[client], cLevelReset[client]);
			}
			PrintToChatAll("\x01Player \x04%N\x01 entered the game.", client);
			if (IsNewClient(client, steamid))
			{
				ResetNewClientArrays(client);
			}
		}
	}
}
public OnClientDisconnect(client)
{
	if (bMenuOn)
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "survivor_death_model")) != INVALID_ENT_REFERENCE)
		{
			decl Float:Origin[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
			if (DeathOrigin[client][0] == Origin[0] && DeathOrigin[client][1] == Origin[1] && DeathOrigin[client][2] == Origin[2])
			{
				AcceptEntityInput(entity, "Kill");
			}
		}
		if (hViewTimer[client] != INVALID_HANDLE)
		{
			CloseHandle(hViewTimer[client]);
			hViewTimer[client] = INVALID_HANDLE;
		}
		if (!IsFakeClient(client))
		{
			if (ReadWriteDelay[client] == 0)
			{
				new String:steamid[24];
				GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
				ReadWriteDelay[client] = 1;
				ReadWriteDB(steamid, client, cExp_accum[client], cLevel_accum[client], cVoteAccess_accum[client], cLevelReset[client]);
			}
		}
		ResetDatabaseArrays(client);
		ResetClientArrays(client);
	}
}
public Action:Ability_Use(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event,"userid"));
	if (bMenuOn)
	{
		if (IsTank(client))
		{
			new color = GetEntityRenderColor(client);
			switch(color)
			{		
				case 12800: ResetInfectedAbility(client, 6.0); //Fire Tank
				case 333435: ResetInfectedAbility(client, 10.0); //Gravity Tank
				case 0100170: ResetInfectedAbility(client, 6.0); //Ice Tank
				case 0105255: ResetInfectedAbility(client, 999.0); //Cobalt Tank
				case 1002525: ResetInfectedAbility(client, 10.0); //Meteor Tank
				case 2002550: ResetInfectedAbility(client, 999.0); //Jumper Tank
				case 2552000: ResetInfectedAbility(client, 2.0); //Jockey Tank
				case 7080100: ResetInfectedAbility(client, 30.0); //Smasher Tank
				case 7595105: ResetInfectedAbility(client, 15.0); //Tech Tank
				case 12115128: ResetInfectedAbility(client, 6.0); //Spitter Tank
				case 100255200: ResetInfectedAbility(client, 15.0); //Hulk Tank
				case 100100100: ResetInfectedAbility(client, 15.0); //Ghost Tank
				case 100165255: ResetInfectedAbility(client, 10.0); //Shock Tank
				case 130130255: ResetInfectedAbility(client, 9.0); //Warp Tank
				case 135205255:
				{
					ResetInfectedAbility(client, 8.0); //Shield Tank
					ShieldState[client] = 0;
				}
				case 255150100: ResetInfectedAbility(client, 999.0); //Demon Tank
				case 255200255: ResetInfectedAbility(client, 7.0); //Witch Tank
			}
		}
	}
}
public Action:Adrenaline_Used(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (bMenuOn)
	{
		if (client > 0)
		{
			new level = cLevel[client];
			if (IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 2 && level >= 4 && !bNightmare)
			{
				PrintToChat(client, "\x04[Medic]\x01 Receiving Health Bonus");
				GiveHealth(client, 25, false);
			}
		}
	}
}
public Action:Ammo_Pile_Cant_Use(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (bMenuOn)
	{
		if (client > 0)
		{
			new level = cLevel[client];
			if (IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 2 && level >= 29 && !bNightmare)
			{
				new String:name[24];
				GetEdictClassname(GetPlayerWeaponSlot(client, 0), name, sizeof(name));
				if (StrEqual(name, "weapon_rifle_m60", false))
				{
					new maxammo = 150;
					new ammo = GetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1");
					if (maxammo > ammo)
					{
						PrintToChat(client, "\x04[Size Matters]\x01 Heavy Weapon Ammo Collected");
						SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", maxammo);
					}
					//commando
					if (level >= 41)
					{
						ammo = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24));
						if (ammo < 300)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 300);
							PrintToChat(client, "\x04[Commando]\x01 Using Extended Cartridge Capacity");
						}
					}
				}
				else if (StrEqual(name, "weapon_grenade_launcher", false))
				{
					new maxammo = 30;
					new ammo = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68));
					if (maxammo > ammo)
					{
						PrintToChat(client, "\x04[Size Matters]\x01 Heavy Weapon Ammo Collected");
						SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), maxammo);
					}
				}
			}
		}
	}
}
public Action:Charger_Impact(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new target = GetClientOfUserId(GetEventInt(event, "victim"));

	if (bMenuOn)
	{
		if (IsInstaCapper(client))
		{
			if (IsSurvivor(target) && !IsPlayerIncap(target))
			{
				DealDamagePlayer(target, client, 128, 600, "point_hurt");
			}
		}
	}
}
public Action:Charger_Pummel_Start(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new target = GetClientOfUserId(GetEventInt(event, "victim"));

	if (bMenuOn)
	{
		if (IsInstaCapper(client))
		{
			if (IsSurvivor(target) && !IsPlayerIncap(target))
			{
				DealDamagePlayer(target, client, 128, 600, "point_hurt");
			}
		}
	}
}
public Action:Defibrillator_Begin(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (bMenuOn)
	{
		if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 2)
		{
			new level = cLevel[client];
			if (level >= 22 && !bNightmare)
			{
				PrintToChat(client, "\x04[Surgeon]\x01 Your skill allow you to use this item quicker.");
			}
		}
	}
}
public Action:Defibrillator_Used(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new target = GetClientOfUserId(GetEventInt(event, "subject"));
	if (bMenuOn)
	{
		if (!bNightmare)
		{
			if (client > 0 && target > 0)
			{
				if (client != target)
				{
					new level = cLevel[client];
					if (IsSurvivor(client) && !IsFakeClient(client))
					{
						new earnedxp = 25 * GetXPDiff(0);
						if (level < 50)
						{
							GiveXP(client, earnedxp);
							PrintToChat(client, "\x05[Lethal-Injection]\x01 Resurrected Teammate: \x03%i\x01 XP", earnedxp);
						}
						else
						{
							GiveXP(client, earnedxp);
						}
						if (level >= 4)
						{
							if (IsClientInGame(target) && GetClientTeam(target) == 2)
							{
								PrintToChat(client, "\x04[Medic]\x01 %N Receives Bonus Health", target);
								PrintToChat(target, "\x04[Medic]\x01 Receiving Health Bonus");
								DefibHealth[target] = 100;
							}
						}
						else
						{
							DefibHealth[target] = 50;
						}
					}
				}
			}
		}
	}
}
public Action:Difficulty_Changed(Handle:event, String:event_name[], bool:dontBroadcast)
{
	SetGameDifficulty();
	if (iDifficulty != 4)
	{
		iDiffWins = 0;
	}
	if (bDiffOverride)
	{
		if (iDiffOverride <= 0)
		{
			switch(iDifficulty)
			{
				case 1: iDiffOverride = 25;
				case 2: iDiffOverride = 50;
				case 3: iDiffOverride = 75;
				case 4: iDiffOverride = 100;
			}
		}
	}
	CreateTimer(0.1, AutoDiffTimer, _, TIMER_FLAG_NO_MAPCHANGE);
}
public Action:Entity_Shoved(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "attacker"));
	new zombie = GetEventInt(event, "entityid");

	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2 && !bNightmare)
		{
			if (level >= 12 && LifeStealerOn[client] == 1)
			{
				if (IsInfected(zombie) || IsWitch(zombie))
				{
					StealLife(client, 1);
					LifeStealerEffectsEntity(zombie);
				}
			}
			else if (level >= 39 && PolyMorphOn[client] == 1)
			{
				if (IsInfected(zombie))
				{
					PolyMorphTarget(zombie, client);
				}
			}
		}
	}	
}
public Action:Finale_Escape_Start(Handle:event, String:event_name[], bool:dontBroadcast)
{
	iFinaleStage = 3;
}
public Action:Finale_Start(Handle:event, String:event_name[], bool:dontBroadcast)
{
	iFinaleCountdown = 0;
	iFinaleStage = 1;

	if (bMenuOn)
	{
		if (iNightmareBegin == 1 && !bNightmare)
		{
			iCountDownTimer = 60;
			SetConVarInt(hNightmareBegin, 0);
			PrintHintTextToAll("Countdown Deactivated. Nightmare Prevented.");
		}

		if (bIsFinale && !bNightmare)
		{
			for (new i=1; i<=MaxClients; i++)
			{
				if (IsClientInGame(i) && IsPlayerAlive(i) && !IsFakeClient(i) && GetClientTeam(i) == 2)
				{
					new level = cLevel[i];
					if (level >= 49)
					{
						JetPackOn[i] = 1;
						PrintToChat(i, "\x04[Jetpack]\x01 The finale event has started. Your Jetpack has been enabled.");
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
public Action:Finale_Vehicle_Leaving(Handle:event, String:event_name[], bool:dontBroadcast)
{
	iFinaleStage = 4;
	if (bMenuOn)
	{
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && IsPlayerAlive(i) && !IsPlayerIncap(i) && GetClientTeam(i) == 2)
			{
				if (iChapter != 7)
				{
					TeleportEntity(i, PortPoint, NULL_VECTOR, NULL_VECTOR);
					//PrintToChatAll("Teleported Player %i", i);
				}
			}
		}
	}
}
public Action:Finale_Vehicle_Ready(Handle:event, String:event_name[], bool:dontBroadcast)
{
	iFinaleStage = 3;
	if (bMenuOn)
	{
		SetConVarInt(hNightmareBegin, 1);
	}
}
public Action:Finale_Win(Handle:event, String:event_name[], bool:dontBroadcast)
{
	iFinaleWin = 1;
	if (bMenuOn)
	{
		//DisableAbilitiesAll();
		//RemoveAttachmentsAll();
		//DisableClientPerksAll();
		DisableBombardments = true;

		new winxp = 500;
		if (bCowLevel)
		{
			winxp = 2500;
		}
		else if (bInferno)
		{
			winxp = 1200;
		}
		else if (bHell)
		{
			winxp = 900;
		}
		else if (bBloodmoon)
		{
			winxp = 600;
		}
		new bonusxp = GetBonusXPPool();
		for (new i=1; i<=MaxClients; i++)
		{
			strcopy(HealthMapName[i], 32, current_map);
			HealthMap[i] = 500;
			strcopy(DeadPlayer[i], 24, "");
			strcopy(DisconnectPlayer[i], 24, "");
			DisconnectPlayerAmmo[i][0] = 0;
			DisconnectPlayerAmmo[i][1] = 0;
			DisconnectPlayerAmmo[i][2] = 0;
			ArtilleryAmmo[i] = 0;
			IonCannonAmmo[i] = 0;
			NukeAmmo[i] = 0;
			if (IsSurvivor(i) && !IsFakeClient(i))
			{
				new level = cLevel[i];
				if (level < 50)
				{
					GiveXP(i, winxp);
					PrintToChat(i, "\x05[Lethal-Injection]\x01 Campaign Completed: \x04%i\x01 XP", winxp);
					new totalxp = cCampaignBonus[i];
					PrintToChat(i, "\x05[Lethal-Injection]\x01 Total XP earned this campaign: \x04%i\x01 XP", totalxp);
					if (bonusxp > 0)
					{
						GiveXP(i, bonusxp);
						PrintToChat(i, "\x05[Lethal-Injection]\x01 XP Bonus gained from Level 50s: \x04%i\x01 XP", bonusxp);
					}
				}
				else
				{
					new totalxp = cCampaignBonus[i];
					PrintToChat(i, "\x05[Lethal-Injection]\x01 XP to be distributed to low levels this campaign: \x04%i\x01 XP", totalxp);
				}
			}
		}
		if (!bHell && !bInferno && !bBloodmoon && !bCowLevel)
		{
			if (iDifficulty == 4)
			{
				if (iDiffWins == 2)
				{
					iDiffWins = 0;
					SetConVarBool(hHell, true);
					PrintToChatAll("\x05[Lethal-Injection]\x04 Hell Difficulty Unlocked");
					EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
				}
				else
				{
					iDiffWins += 1;
					new random = GetRandomInt(1,12);
					if (random == 6)
					{
						PrintToChatAll("\x05[Lethal-Injection]\x04 Bloodmoon Difficulty Unlocked");
						SetConVarBool(hBloodmoon, true);
						iDiffWins = 0;
					}
				}
			}
		}
		else if (bBloodmoon)
		{
			iDiffWins = 0;
			SetConVarBool(hHell, true);
			PrintToChatAll("\x05[Lethal-Injection]\x04 Hell Difficulty Unlocked");
			EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
		}
		else if (bHell)
		{
			if (iDiffWins == 2)
			{
				iDiffWins = 0;
				SetConVarBool(hInferno, true);
				PrintToChatAll("\x05[Lethal-Injection]\x04 Inferno Difficulty Unlocked");
				EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
			}
			else
			{
				iDiffWins += 1;
			}
		}
		else if (bInferno)
		{
			if (iDiffWins == 2)
			{
				iDiffWins = 0;
				SetConVarBool(hCowLevel, true);
				PrintToChatAll("\x05[Lethal-Injection]\x04 Secret Cow Level Unlocked");
				EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
			}
			else
			{
				iDiffWins += 1;
			}
		}
		else if (bCowLevel)
		{
			iDiffWins = 0;
			SetConVarBool(hCowLevel, false);
			PrintToChatAll("\x05[Lethal-Injection]\x04 You have conquered all difficulties and beaten Lethal-Injection! Congrats.");
		}
		iNumDeaths = 0;
		ResetCampaignBonuses();
	}
}
public Action:Gascan_Pour_Completed(Handle:event, String:event_name[], bool:dontBroadcast)
{
	iGasCanPoured += 1;
	if (iGasCanPoured >= 16)
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "logic_relay")) != INVALID_ENT_REFERENCE)
		{
			if (StrEqual(current_map, "c1m4_atrium", false))
			{
				new hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
				if (hammerid == 528450)
				{
					AcceptEntityInput(entity, "Trigger");
				}
			}
			else if (StrEqual(current_map, "c6m3_port", false))
			{
				new hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
				if (hammerid == 127703)
				{
					AcceptEntityInput(entity, "Trigger");
				}
			}
			else if (StrEqual(current_map, "p84m4_precinct", false))
			{
				new hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
				if (hammerid == 5230072)
				{
					AcceptEntityInput(entity, "Trigger");
				}
			}
			else if (StrEqual(current_map, "l4d_yama_5", false))
			{
				new hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
				if (hammerid == 550021)
				{
					AcceptEntityInput(entity, "Trigger");
				}
			}
		}
	}
}
public Action:Heal_Begin(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	//new target = GetClientOfUserId(GetEventInt(event, "subject"));
	if (bMenuOn)
	{
		if (IsSurvivor(client) && !IsFakeClient(client))
		{
			new level = cLevel[client];
			if (level >= 22 && !bNightmare)
			{
				PrintToChat(client, "\x04[Surgeon]\x01 Your skill allow you to use this item quicker.");
			}
		}
	}
}
public Action:Heal_Success(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new target = GetClientOfUserId(GetEventInt(event, "subject"));
	if (bMenuOn)
	{
		if (!bNightmare)
		{
			if (client > 0 && target > 0)
			{
				if (IsSurvivor(client) && IsSurvivor(target))
				{
					new level = cLevel[client];
					if (!IsFakeClient(client))
					{
						if (client != target)
						{
							new earnedxp = 25 * GetXPDiff(0);
							if (level < 50)
							{
								GiveXP(client, earnedxp);
								PrintToChat(client, "\x05[Lethal-Injection]\x01 Healed Teammate: \x03%i\x01 XP", earnedxp);
							}
							else
							{
								GiveXP(client, earnedxp);
							}
						}
						SetEntProp(target, Prop_Send, "m_iHealth", SavedHealth[target]);
						if (level >= 4)
						{
							GiveHealth(target, 200, true);
						}
						else
						{
							GiveHealth(target, 100, true);
						}
					}
				}
			}
		}
	}
}
public Action:Item_Pickup(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	//decl String:classname[16];
	//GetEventString(event, "item", classname, sizeof(classname));

	if (bMenuOn)
	{
		if (client > 0)
		{
			if (IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 2)
			{	
				new level = cLevel[client];
				if (level >= 26 && !bNightmare)
				{
					if (UseDelay[client] == 0)
					{
						if (GetPlayerWeaponSlot(client, 0) > 0)
						{
							new UpgradeBit = GetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec");
							if (UpgradeBit != 6 && UpgradeBit != 5 && UpgradeBit != 4)
							{
								if (UpgradeBit == 1)
								{
									PrintToChat(client, "\x04[BullsEye]\x01 Laser Sight Equipped");
									SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 5);
								}
								else if (UpgradeBit == 2)
								{
									PrintToChat(client, "\x04[BullsEye]\x01 Laser Sight Equipped");
									SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 6);
								}
								else
								{
									PrintToChat(client, "\x04[BullsEye]\x01 Laser Sight Equipped");
									SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 4);
								}
							}
						}
						UseDelay[client] = 1;
						CreateTimer(0.3, UseDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}
}
public Action:Jockey_Ride(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (bMenuOn)
	{
		if (IsInstaCapper(client))
		{
			if (IsSurvivor(victim) && !IsPlayerIncap(victim))
			{
				DealDamagePlayer(victim, client, 128, 600, "point_hurt");
			}
		}
	}
}
public Action:Lunge_Pounce(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (bMenuOn)
	{
		if (IsInstaCapper(client))
		{
			if (IsSurvivor(victim) && !IsPlayerIncap(victim))
			{
				DealDamagePlayer(victim, client, 128, 600, "point_hurt");
			}
		}
	}
}
public Action:Map_Transition(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	if (bMenuOn)
	{
		if (!bIsFinale)
		{
			for (new i=1; i<=MaxClients; i++)
			{
				if (IsSurvivor(i) && IsPlayerAlive(i))
				{
					new health = GetEntProp(i, Prop_Send, "m_iHealth");
					strcopy(HealthMapName[i], 32, current_map);
					HealthMap[i] = health;
				}
			}
		}
	}
}
public Action:Mission_Lost(Handle:event, String:event_name[], bool:dontBroadcast)
{
	bRoundEnded = true;
	//PrintToServer("Mission_lost: %i", bRoundEnded);
	if (bMenuOn)
	{
		//PrintToServer("iFinaleStage: %i, iChapter: %i", iFinaleStage, iChapter);
		iDiffWins = 0;
		if (iDifficulty != 1)
		{
			iNumDefeats += 1;
		}
		if (bCowLevel)
		{
			SetConVarBool(hInferno, true);
		}
		else if (bInferno)
		{
			SetConVarBool(hHell, true);
		}
		else if (bHell)
		{
			SetConVarBool(hHell, false);
			SetConVarInt(FindConVar("director_panic_forever"), 0);
		}
		else if (bBloodmoon)
		{
			SetConVarBool(hBloodmoon, false);
			SetConVarInt(FindConVar("director_panic_forever"), 0);
		}
		else
		{
			if (bDiffOverride)
			{
				switch(iDiffOverride)
				{
					case 25:
					{
						bDiffOverride = false;
						iDiffOverride = 0;
					}
					case 50:
					{
						iDiffOverride = 25;
					}
					case 75:
					{
						iDiffOverride = 50;
					}
					case 100:
					{
						iDiffOverride = 75;
					}
				}
			}
		}
		for (new i=1; i<=MaxClients; i++)
		{
			strcopy(HealthMapName[i], 32, "");
			HealthMap[i] = 500;
			RemoveShoulderCannon(i);
		}
		CreateTimer(0.1, GasCansDisableGlow, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}
public Action:Pills_Used(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (bMenuOn)
	{
		if (client > 0)
		{
			new level = cLevel[client];
			if (IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 2 && level >= 4 && !bNightmare)
			{
				PrintToChat(client, "\x04[Medic]\x01 Receiving Health Bonus");
				GiveHealth(client, 50, false);
			}
		}
	}
}
public Action:Player_Death(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new entityid = GetEventInt(event, "entityid");
	//new type = GetEventInt(event, "type");
	new String:weaponused[16];
	GetEventString(event, "weapon", weaponused, sizeof(weaponused));
	if (bMenuOn)
	{
		if (attacker > 0 && !bNightmare)
		{
			if (IsSurvivor(attacker) && !IsFakeClient(attacker))
			{
				new weapontype;
				if (StrEqual(weaponused, "sentry_gun", false))
				{
					weapontype = 1;
				}
				else if (StrEqual(weaponused, "shoulder_cannon", false))
				{
					weapontype = 2;
				}
				else if (StrEqual(weaponused, "uv_light", false))
				{
					weapontype = 3;
				}
				else if (StrEqual(weaponused, "emitter", false))
				{
					weapontype = 4;
				}
				else if (StrEqual(weaponused, "artillery_blast", false))
				{
					weapontype = 5;
				}
				else if (StrEqual(weaponused, "ion_cannon", false))
				{
					weapontype = 6;
				}
				else if (StrEqual(weaponused, "nuke_bomb", false))
				{
					weapontype = 7;
				}
				//PrintToChat(attacker, "Weapon:%s", weaponused);
				if (IsInfected(entityid))
				{
					if (IsUncommon(entityid))
					{
						new earnedxp = 2 * GetXPDiff(1);
						new messages = cNotifications[attacker];
						new level = cLevel[attacker];
						if (level < 50)
						{
							GiveXP(attacker, earnedxp);
							if (messages > 0)
							{
								switch(weapontype)
								{
									case 0: PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 1: PrintToChat(attacker, "\x04[Sentry Gun]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 2: PrintToChat(attacker, "\x04[Shoulder Cannon]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 3: PrintToChat(attacker, "\x04[UV Light]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 5: PrintToChat(attacker, "\x04[Artillery Barrage]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 6: PrintToChat(attacker, "\x04[Ion Cannon]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 7: PrintToChat(attacker, "\x04[Nuclear Strike]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
								}
								if (weapontype >= 5 && weapontype <= 7)
								{
									for (new i=1; i<=MaxClients; i++)
									{
										if (IsSurvivor(i) && IsPlayerAlive(i) && i != attacker)
										{
											new lvl = cLevel[i];
											if (lvl < 50)
											{
												new bombxp = earnedxp / 2;
												GiveXP(i, bombxp);
												new msgs = cNotifications[i];
												if (msgs > 0)
												{
													switch(weapontype)
													{
														case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", bombxp);
														case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", bombxp);
														case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", bombxp);
													}
												}
											}
										}
									}
								}
								if (ChainsawMassOn[attacker] == 1 && StrEqual(weaponused, "chainsaw", false))
								{
									new bonusxp = 1 * GetXPDiff(1);
									PrintToChat(attacker, "\x04[Chainsaw Massacre]\x01 Uncommon Zombie Killed \x03%i\x01 XP", bonusxp);
									GiveXP(attacker, bonusxp);
								}
							}
						}
						else
						{
							GiveXP(attacker, earnedxp);
							if (weapontype >= 5 && weapontype <= 7)
							{
								for (new i=1; i<=MaxClients; i++)
								{
									if (IsSurvivor(i) && IsPlayerAlive(i) && i != attacker)
									{
										new lvl = cLevel[i];
										if (lvl < 50)
										{
											new bombxp = earnedxp / 2;
											GiveXP(i, bombxp);
											new msgs = cNotifications[i];
											if (msgs > 0)
											{
												switch(weapontype)
												{
													case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", bombxp);
													case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", bombxp);
													case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", bombxp);
												}
											}
										}
									}
								}
							}
						}
					}
					else
					{
						new earnedxp = 1 * GetXPDiff(1);
						new messages = cNotifications[attacker];
						new level = cLevel[attacker];
						if (level < 50)
						{
							GiveXP(attacker, earnedxp);
							if (messages > 0)
							{
								switch(weapontype)
								{
									case 0: PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 1: PrintToChat(attacker, "\x04[Sentry Gun]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 2: PrintToChat(attacker, "\x04[Shoulder Cannon]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 3: PrintToChat(attacker, "\x04[UV Light]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 5: PrintToChat(attacker, "\x04[Artillery Barrage]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 6: PrintToChat(attacker, "\x04[Ion Cannon]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
									case 7: PrintToChat(attacker, "\x04[Nuclear Strike]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
								}
								if (weapontype >= 5 && weapontype <= 7)
								{
									for (new i=1; i<=MaxClients; i++)
									{
										if (IsSurvivor(i) && IsPlayerAlive(i) && i != attacker)
										{
											new lvl = cLevel[i];
											if (lvl < 50)
											{
												new bombxp = earnedxp / 2;
												if (bombxp == 0)
												{
													bombxp = 1;
												}
												GiveXP(i, bombxp);
												new msgs = cNotifications[i];
												if (msgs > 0)
												{
													switch(weapontype)
													{
														case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 Zombie Killed: \x03%i\x01 XP", bombxp);
														case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 Zombie Killed: \x03%i\x01 XP", bombxp);
														case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 Zombie Killed: \x03%i\x01 XP", bombxp);
													}
												}
											}
										}
									}
								}
								if (ChainsawMassOn[attacker] == 1 && StrEqual(weaponused, "chainsaw", false))
								{
									new bonusxp = 1 * GetXPDiff(1);
									PrintToChat(attacker, "\x04[Chainsaw Massacre]\x01 Zombie Killed \x03%i\x01 XP", bonusxp);
									GiveXP(attacker, bonusxp);
								}
							}
						}
						else
						{
							GiveXP(attacker, earnedxp);
							if (weapontype >= 5 && weapontype <= 7)
							{
								for (new i=1; i<=MaxClients; i++)
								{
									if (IsSurvivor(i) && IsPlayerAlive(i) && i != attacker)
									{
										new lvl = cLevel[i];
										if (lvl < 50)
										{
											new bombxp = earnedxp / 2;
											GiveXP(i, bombxp);
											new msgs = cNotifications[i];
											if (msgs > 0)
											{
												switch(weapontype)
												{
													case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 Zombie Killed: \x03%i\x01 XP", bombxp);
													case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 Zombie Killed: \x03%i\x01 XP", bombxp);
													case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 Zombie Killed: \x03%i\x01 XP", bombxp);
												}
											}
										}
									}
								}
							}
						}
					}
				}
				else if (IsWitch(entityid))
				{
					new color = GetEntProp(entityid, Prop_Send, "m_hOwnerEntity");
					if (color == 255200255)
					{
						new earnedxp = 10 * GetXPDiff(1);
						new level = cLevel[attacker];
						if (level < 50)
						{
							GiveXP(attacker, earnedxp);
							switch(weapontype)
							{
								case 0: PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Lesser Witch Killed: \x03%i\x01 XP", earnedxp);
								case 1: PrintToChat(attacker, "\x04[Sentry Gun]\x01 Lesser Witch Killed: \x03%i\x01 XP", earnedxp);
								case 2: PrintToChat(attacker, "\x04[Shoulder Cannon]\x01 Lesser Witch Killed: \x03%i\x01 XP", earnedxp);
								case 5: PrintToChat(attacker, "\x04[Artillery Barrage]\x01 Lesser Witch Killed: \x03%i\x01 XP", earnedxp);
								case 6: PrintToChat(attacker, "\x04[Ion Cannon]\x01 Lesser Witch Killed: \x03%i\x01 XP", earnedxp);
								case 7: PrintToChat(attacker, "\x04[Nuclear Strike]\x01 Lesser Witch Killed: \x03%i\x01 XP", earnedxp);
							}
							if (weapontype >= 5 && weapontype <= 7)
							{
								for (new i=1; i<=MaxClients; i++)
								{
									if (IsSurvivor(i) && IsPlayerAlive(i) && i != attacker)
									{
										new lvl = cLevel[i];
										if (lvl < 50)
										{
											new bombxp = earnedxp / 2;
											GiveXP(i, bombxp);
											new msgs = cNotifications[i];
											if (msgs > 0)
											{
												switch(weapontype)
												{
													case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 Lesser Witch Killed: \x03%i\x01 XP", bombxp);
													case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 Lesser Witch Killed: \x03%i\x01 XP", bombxp);
													case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 Lesser Witch Killed: \x03%i\x01 XP", bombxp);
												}
											}
										}
									}
								}
							}
							if (ChainsawMassOn[attacker] == 1 && StrEqual(weaponused, "chainsaw", false))
							{
								new bonusxp = 5 * GetXPDiff(1);
								PrintToChat(attacker, "\x04[Chainsaw Massacre]\x01 Lesser Witch Killed \x03%i\x01 XP", bonusxp);
								GiveXP(attacker, bonusxp);
							}
						}
						else
						{
							GiveXP(attacker, earnedxp);
							if (weapontype >= 5 && weapontype <= 7)
							{
								for (new i=1; i<=MaxClients; i++)
								{
									if (IsSurvivor(i) && IsPlayerAlive(i) && i != attacker)
									{
										new lvl = cLevel[i];
										if (lvl < 50)
										{
											new bombxp = earnedxp / 2;
											GiveXP(i, bombxp);
											new msgs = cNotifications[i];
											if (msgs > 0)
											{
												switch(weapontype)
												{
													case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 Lesser Witch Killed: \x03%i\x01 XP", bombxp);
													case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 Lesser Witch Killed: \x03%i\x01 XP", bombxp);
													case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 Lesser Witch Killed: \x03%i\x01 XP", bombxp);
												}
											}
										}
									}
								}
							}
						}
					}
					else
					{
						new earnedxp = 25 * GetXPDiff(1);
						new level = cLevel[attacker];
						if (level < 50)
						{
							GiveXP(attacker, earnedxp);
							switch(weapontype)
							{
								case 0: PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Witch Killed: \x03%i\x01 XP", earnedxp);
								case 1: PrintToChat(attacker, "\x04[Sentry Gun]\x01 Witch Killed: \x03%i\x01 XP", earnedxp);
								case 2: PrintToChat(attacker, "\x04[Shoulder Cannon]\x01 Witch Killed: \x03%i\x01 XP", earnedxp);
								case 5: PrintToChat(attacker, "\x04[Artillery Barrage]\x01 Witch Killed: \x03%i\x01 XP", earnedxp);
								case 6: PrintToChat(attacker, "\x04[Ion Cannon]\x01 Witch Killed: \x03%i\x01 XP", earnedxp);
								case 7: PrintToChat(attacker, "\x04[Nuclear Strike]\x01 Witch Killed: \x03%i\x01 XP", earnedxp);
							}
							if (weapontype >= 5 && weapontype <= 7)
							{
								for (new i=1; i<=MaxClients; i++)
								{
									if (IsSurvivor(i) && IsPlayerAlive(i) && i != attacker)
									{
										new lvl = cLevel[i];
										if (lvl < 50)
										{
											new bombxp = earnedxp / 2;
											GiveXP(i, bombxp);
											new msgs = cNotifications[i];
											if (msgs > 0)
											{
												switch(weapontype)
												{
													case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 Witch Killed: \x03%i\x01 XP", bombxp);
													case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 Witch Killed: \x03%i\x01 XP", bombxp);
													case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 Witch Killed: \x03%i\x01 XP", bombxp);
												}
											}
										}
									}
								}
							}
							if (ChainsawMassOn[attacker] == 1 && StrEqual(weaponused, "chainsaw", false))
							{
								new bonusxp = 12 * GetXPDiff(1);
								PrintToChat(attacker, "\x04[Chainsaw Massacre]\x01 Witch Killed \x03%i\x01 XP", bonusxp);
								GiveXP(attacker, bonusxp);
							}
						}
						else
						{
							GiveXP(attacker, earnedxp);
							if (weapontype >= 5 && weapontype <= 7)
							{
								for (new i=1; i<=MaxClients; i++)
								{
									if (IsSurvivor(i) && IsPlayerAlive(i) && i != attacker)
									{
										new lvl = cLevel[i];
										if (lvl < 50)
										{
											new bombxp = earnedxp / 2;
											GiveXP(i, bombxp);
											new msgs = cNotifications[i];
											if (msgs > 0)
											{
												switch(weapontype)
												{
													case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 Witch Killed: \x03%i\x01 XP", bombxp);
													case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 Witch Killed: \x03%i\x01 XP", bombxp);
													case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 Witch Killed: \x03%i\x01 XP", bombxp);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		if (client > 0)
		{
			if (IsClientInGame(client))
			{
				if (GetClientTeam(client) == 2)
				{
					SetEntityGravity(client, 1.0);
					SetEntityMoveType(client, MOVETYPE_OBSERVER);
					iNumDeaths += 1;
					GetClientAuthId(client, AuthId_Steam2, DeadPlayer[client], 24);
					new Float:Origin[3], Float:EOrigin[3];
					GetClientAbsOrigin(client, Origin);
					GetClientAbsOrigin(client, DeathOrigin[client]);
					new entity = -1;
					while ((entity = FindEntityByClassname(entity, "survivor_death_model")) != INVALID_ENT_REFERENCE)
					{
						GetEntPropVector(entity, Prop_Send, "m_vecOrigin", EOrigin);
						if (Origin[0] == EOrigin[0] && Origin[1] == EOrigin[1] && Origin[2] == EOrigin[2])
						{
							SetEntProp(entity, Prop_Send, "m_hOwnerEntity", client);
						}
					}
					DisableAbilities(client);
					RemoveAttachments(client);
					new level = cLevel[client];
					if (level >= 44 && SecChance[client] == 0 && !bNightmare)
					{
						CreateTimer(3.0, SecondChanceTimer, client, TIMER_FLAG_NO_MAPCHANGE); 
					}
					AutoDifficulty(false);
				}
				else if (GetClientTeam(client) == 3)
				{
					if (IsTank(client))
					{
						new type = 0;
						new color = GetEntityRenderColor(client);
						switch(color)
						{
							case 7595105: type = 1;
							case 7080100: type = 2;
							case 130130255: type = 3;
							case 1002525: type = 4;
							case 12115128: type = 5;
							case 100255200: type = 6;
							case 12800: type = 7;
							case 0100170: type = 8;
							case 2552000: type = 9;
							case 100100100: type = 10;
							case 100165255: type = 11;
							case 255200255: type = 12;
							case 135205255: type = 13;
							case 0105255: type = 14;
							case 2002550: type = 15;
							case 333435: type = 16;
							case 255255255: type = 255;
							case 255150100: type = 666;
						}
						ExecTankDeath(client, type);
					}
					else if (IsSpecialInfectedClass(client))
					{
						new class = GetZombieClass(client);
						new color = GetEntityGlowColor(client);
						new type = 0;
						if (color == 701200)
						{
							type = 2;
						}
						else if (color == 0175175)
						{
							type = 1;
						}
						ExecSpecialDeath(client, class, type);
						//PrintToChatAll("SI %i dead, class: %i, type: %i", client, class, type);
					}
				}
				WeaponsRestored[client] = 0;
				SetEntityGravity(client, 1.0);
				SetEntProp(client, Prop_Send, "m_iGlowType", 0);
				SetEntProp(client, Prop_Send, "m_glowColorOverride", 0);
			}
		}
		if (entityid > 32 && IsValidEntity(entityid))
		{
			SetEntProp(entityid, Prop_Send, "m_iGlowType", 0);
			SetEntProp(entityid, Prop_Send, "m_glowColorOverride", 0);
		}
	}
}
public Action:Player_Disconnect(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event,"userid"));
	if (bMenuOn)
	{
		if (client > 0)
		{
			CreateTimer(0.1, ResetNewClientArraysTimer, client);
			DisableClientPerks(client);
		}
	}
}
public Action:Player_Hurt(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event,"userid"));
	new attacker = GetClientOfUserId(GetEventInt(event,"attacker"));
	new damage = GetEventInt(event,"dmg_health");
	new String:weaponused[16];
	GetEventString(event, "weapon", weaponused, sizeof(weaponused));
	if (bMenuOn)
	{
		if (IsSurvivor(attacker))
		{
			new weapontype;
			if (StrEqual(weaponused, "sentry_gun", false))
			{
				weapontype = 1;
			}
			else if (StrEqual(weaponused, "shoulder_cannon", false))
			{
				weapontype = 2;
			}
			else if (StrEqual(weaponused, "uv_light", false))
			{
				weapontype = 3;
			}
			else if (StrEqual(weaponused, "emitter", false))
			{
				weapontype = 4;
			}
			else if (StrEqual(weaponused, "artillery_blast", false))
			{
				weapontype = 5;
			}
			else if (StrEqual(weaponused, "ion_cannon", false))
			{
				weapontype = 6;
			}
			else if (StrEqual(weaponused, "nuke_bomb", false))
			{
				weapontype = 7;
			}
			if (IsTank(victim) || IsSpecialInfected(victim))
			{
				if (ChainsawMassOn[attacker] == 1)
				{
					decl String:classname[24];
					GetClientWeapon(attacker, classname, sizeof(classname));
					if (StrEqual(classname, "weapon_chainsaw", false))
					{
						ChainsawDamage[victim][attacker] += damage;
					}
				}
				if (weapontype == 1)
				{
					XPDamage[victim][attacker][1] += damage;
				}
				else if (weapontype == 2)
				{
					XPDamage[victim][attacker][2] += damage;
				}
				else if (weapontype == 3)
				{
					XPDamage[victim][attacker][3] += damage;
				}
				else if (weapontype == 4)
				{
					XPDamage[victim][attacker][4] += damage;
				}
				else if (weapontype == 5)
				{
					XPDamage[victim][attacker][5] += damage;
				}
				else if (weapontype == 6)
				{
					XPDamage[victim][attacker][6] += damage;
				}
				else if (weapontype == 7)
				{
					XPDamage[victim][attacker][7] += damage;
				}
				else
				{
					XPDamage[victim][attacker][0] += damage;
				}
			}
		}
	}	
}
public Action:Player_Incapacitated(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (bMenuOn)
	{
		AutoDifficulty(false);
		if (IsSmoker(attacker) || IsHunter(attacker) || IsCharger(attacker))
		{
			BreakInfectedHold(attacker);
			ResetClassAbility(attacker);
		}
		//desert cobra
		if (IsSurvivor(client))
		{
			new level = cLevel[client];
			if (level >= 8)
			{
				CreateTimer(0.1, DesertCobraTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}	
		}
	}
}
public Action:Player_Incap_Start(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (bMenuOn)
	{
		if (IsSurvivor(client))
		{
			new level = cLevel[client];
			if (level >= 17)
			{
				if (GetConVarInt(FindConVar("survivor_incap_health")) != 500)
				{
					SetConVarInt(FindConVar("survivor_incap_health"), 500);
				}
			}
			else
			{
				if (GetConVarInt(FindConVar("survivor_incap_health")) != 300)
				{
					SetConVarInt(FindConVar("survivor_incap_health"), 300);
				}
			}
		}
	}
}
public Action:Player_Now_It(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
        if (bMenuOn)
        {
		if (attacker > 0 && client > 0)
		{
			if (IsInstaCapper(attacker))
			{
				if (IsSurvivor(client) && !IsPlayerIncap(client))
				{
					DealDamagePlayer(client, attacker, 128, 600, "point_hurt");
				}
			}
			else if (IsTank(client) && GetEntityRenderColor(client) == 100255200)
			{
				//disable healing ability for 20 secs
				TankAbilityTimer[client] = 20;
				SetEntProp(client, Prop_Send, "m_glowColorOverride", 0);
				SetEntProp(client, Prop_Send, "m_iGlowType", 0);
				SetEntProp(client, Prop_Send, "m_bFlashing", 0);
			}
		}
	}
}
public Action:Player_Shoved(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "attacker"));
	new zombie = GetClientOfUserId(GetEventInt(event, "userid"));

	if (bMenuOn)
	{
		if (IsSurvivor(client) && IsSpecialInfected(zombie))
		{
			new level = cLevel[client];
			if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2 && !bNightmare)
			{
				if (level >= 12 && LifeStealerOn[client] == 1)
				{
					StealLife(client, 4);
					if (!IsInstaCapper(zombie) && !IsBreeder(zombie))
					{
						LifeStealerEffectsPlayer(zombie);
					}
				}
			}
		}
	}	
}
public Action:Player_Spawn(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (bMenuOn)
	{
		if (client > 0)
		{
			if (IsClientInGame(client))
			{
				SetEntityGravity(client, 1.0);

				new entity = -1;
				while ((entity = FindEntityByClassname(entity, "survivor_death_model")) != INVALID_ENT_REFERENCE)
				{
					new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
					if (owner == client)
					{
						AcceptEntityInput(entity, "Kill");
					}
				}
				if (GetClientTeam(client) == 2)
				{
					PlayerSpawn[client] = 0;
					strcopy(DeadPlayer[client], 24, "");
					AutoDifficulty(false);
				}
				else if (IsSpecialInfected(client) && IsFakeClient(client))
				{
					CreateTimer(0.1, CreateSpecialInfected, client, TIMER_FLAG_NO_MAPCHANGE);
				}
				else if (GetClientTeam(client) == 3)
				{
					decl String:classname[16];
					GetEntityNetClass(client, classname, sizeof(classname));
					if (StrEqual(classname, "Tank", false))
					{
						CountTanks();
						if (iNumTanksWave > 0)
						{
							iNumTanksWave -= 1;
						}
						TankAlive[client] = 1;
						TankAbility[client] = 0;
						CreateTimer(0.1, TankSpawnTimer, client, TIMER_FLAG_NO_MAPCHANGE);
						if (iTankType == 0)
						{
							if (bInferno || bNightmare)
							{
								SetTankType(client, 666);
							}
							else if (bCowLevel)
							{
								SetTankType(client, 255);
							}
							else
							{
								SetTankType(client, 0);
							}
						}
						else
						{
							SetTankType(client, iTankType);
						}
						if (bIsFinale)
						{
							decl Float:Origin[3], Float:Angles[3];
							GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
							GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);
							if (iNumTanksWave > 0)
							{
								CreateTimer(5.0, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
							}
							else if (!bNightmare && (iNumTanksWave < 0))
							{
								if (IsFakeClient(client))
								{
									KickClient(client);
								}
							}
							else if (bNightmare && iNumTanks > 6)
							{
								if (IsFakeClient(client))
								{
									KickClient(client);
								}
							}
						}	
					}
				}
			}
		}
	}
}
public Action:Player_Team(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	//new team = GetEventInt(event, "team");
	if (bMenuOn)
	{
		if (client > 0)
		{
			if (IsClientInGame(client) && !IsFakeClient(client))
			{
				AutoDifficulty(false);
				DisableAbilities(client);
				RemoveAttachments(client);
			}
		}
	}
}
public Action:Player_Use(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new entity = GetEventInt(event, "targetid");
	if (bMenuOn)
	{
		if (IsSurvivor(client) && entity > 0 && IsValidEntity(entity))
		{
			if (!IsFakeClient(client))
			{
				new String:classname[32];
				GetEdictClassname(entity, classname, sizeof(classname));
				//PrintToChat(client, "Player_Use: %s", classname);
				new level = cLevel[client];
				if (StrEqual(classname, "weapon_rifle_m60", false))
				{
					//PrintToChatAll("Player_Use->m_iClip1: %i", GetEntProp(entity, Prop_Send, "m_iClip1"));
					if (GetEntProp(entity, Prop_Send, "m_iClip1") == 1)
					{
						SetEntProp(entity, Prop_Send, "m_iClip1", 0);
						//PrintToChatAll("Player_Use->m_iClip1: Set To 0");
					}
				}
				else if (StrContains(classname, "weapon_", false) != -1 && StrContains(classname, "melee", false) == -1)
				{
					if (!IsFakeClient(client) && level >= 26 && !bNightmare)
					{
						if (UseDelay[client] == 0)
						{
							if (GetPlayerWeaponSlot(client, 0) > 0)
							{
								new UpgradeBit = GetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec");
								if (UpgradeBit != 6 && UpgradeBit != 5 && UpgradeBit != 4)
								{
									if (UpgradeBit == 1)
									{
										PrintToChat(client, "\x04[BullsEye]\x01 Laser Sight Equipped");
										SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 5);
									}
									else if (UpgradeBit == 2)
									{
										PrintToChat(client, "\x04[BullsEye]\x01 Laser Sight Equipped");
										SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 6);
									}
									else
									{
										PrintToChat(client, "\x04[BullsEye]\x01 Laser Sight Equipped");
										SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_upgradeBitVec", 4);
									}
								}
							}
							UseDelay[client] = 1;
							CreateTimer(0.3, UseDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
				else if (StrContains(classname, "melee", false) != -1)
				{	
					new target = -1, target2 = -1;
					decl String:model[64], String:model2[64];
					decl Float:Origin[3], Float:TOrigin[3], Float:T2Origin[3];
					while ((target = FindEntityByClassname(target, "weapon_melee_spawn")) != INVALID_ENT_REFERENCE)
					{
            					GetEntPropString(target, Prop_Data, "m_ModelName", model, sizeof(model));
						GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
						GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
						new Float:distance = GetVectorDistance(Origin, TOrigin);
                       		 		if (distance < 125.0)
						{
							while ((target2 = FindEntityByClassname(target2, "weapon_melee")) != INVALID_ENT_REFERENCE)
							{
            							GetEntPropString(target2, Prop_Data, "m_ModelName", model2, sizeof(model2));
								GetEntPropVector(target2, Prop_Send, "m_vecOrigin", T2Origin);
								new Float:distance2 = GetVectorDistance(Origin, T2Origin);
                       		 				if (distance2 < 125.0)
								{
									if (StrEqual(model, model2, false))
									{
										AcceptEntityInput(target2, "Kill");
										new count = GetEntProp(target, Prop_Data, "m_itemCount");
										SetEntProp(target, Prop_Data, "m_itemCount", count+1);
									}
								}
							}
						}
					}	
				}
				if (StrContains(classname, "ammo", false) != -1)
				{	
					//pack rat
					GiveExtraAmmo(client);
				}
			}
		}
	}
}
stock GiveExtraAmmo(client)
{
	if (IsSurvivor(client))
	{
		new level = cLevel[client];
		if (level >= 6)
		{
			new entity = GetPlayerWeaponSlot(client, 0);
			if (entity > 0 && IsValidEntity(entity))
			{
				new offset = GetWeaponAmmoOffset(entity);
				if (offset != 24 && offset != 68 && offset > 0)
				{
					new ammo = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset));
					new String:classname[32];
					GetEdictClassname(entity, classname, sizeof(classname));
					if (StrEqual(classname, "weapon_rifle", false) || StrEqual(classname, "weapon_rifle_sg552", false))
					{
						if (ammo < 410)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 410);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_rifle_desert", false))
					{
						if (ammo < 420)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 420);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_rifle_ak47", false))
					{
						if (ammo < 400)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 400);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_smg", false) || StrEqual(classname, "weapon_smg_silenced", false) || StrEqual(classname, "weapon_smg_mp5", false))
					{
						if (ammo < 700)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 700);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_pumpshotgun", false) || StrEqual(classname, "weapon_shotgun_chrome", false))
					{
						if (ammo < 64)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 64);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_autoshotgun", false) || StrEqual(classname, "weapon_shotgun_spas", false))
					{
						if (ammo < 100)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 100);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_hunting_rifle", false))
					{
						if (ammo < 165)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 165);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_sniper_scout", false))
					{
						if (ammo < 195)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 195);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_sniper_military", false))
					{
						if (ammo < 210)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 210);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
					else if (StrEqual(classname, "weapon_sniper_awp", false))
					{
						if (ammo < 200)
						{
							SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), 200);
							PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
						}
					}
				}
			}
		}
	}
}
public Action:Revive_Success(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new target = GetClientOfUserId(GetEventInt(event, "subject"));
	new bool:ledgehang = GetEventBool(event, "ledge_hang");
	if (bMenuOn)
	{
		AutoDifficulty(false);
		if (!bNightmare)
		{
			if (client > 0 && target > 0 && !ledgehang)
			{
				if (client != target)
				{
					if (IsSurvivor(client) && !IsFakeClient(client))
					{
						new earnedxp = 15 * GetXPDiff(0);
						new level = cLevel[client];
						if (level < 50)
						{
							GiveXP(client, earnedxp);
							PrintToChat(client, "\x05[Lethal-Injection]\x01 Revived Teammate: \x03%i\x01 XP", earnedxp);
						}
						else
						{
							GiveXP(client, earnedxp);
						}
						if (level >= 4)
						{
							if (IsClientInGame(target) && GetClientTeam(target) == 2)
							{
								PrintToChat(client, "\x04[Medic]\x01 %N Receives Bonus Health", target);
								PrintToChat(target, "\x04[Medic]\x01 Receiving Bonus Health");
								GiveHealth(target, 30, false);
							}
						}
					}
				}
			}
		}
	}
}
public Action:Round_End(Handle:event, String:event_name[], bool:dontBroadcast)
{
	if (bMenuOn)
	{
		KickAIBots();
	}
}
public Action:Round_Start(Handle:event, String:event_name[], bool:dontBroadcast)
{
	iRound++;
	bRoundEnded = false;
	PrintToServer("Round_Start: %i", bRoundEnded);
	SetGameDifficulty();
	if (bMenuOn)
	{
		ResetVariables();

		SetConVarInt(hNightmareBegin, 0);
		SetConVarBool(hNightmare, false);

		CreateTimer(1.0, RemoveGasCans, _, TIMER_FLAG_NO_MAPCHANGE);
		
		ResetClientArraysAll();
		GetPortPoint();
		IdentifySRDoor();
		AutoDifficulty(true);

		if (bHell || bInferno || bBloodmoon || bCowLevel)
		{
			SetConVarInt(FindConVar("director_panic_forever"), 1);
		}
		if (bHellWeek)
		{
			SetConVarBool(hHell, true);
		}
		if (bBloodmoonWeek)
		{
			SetConVarBool(hBloodmoon, true);
		}
		//CreateTimer(5.0, FixDoors, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}
public Action:FixDoors(Handle:timer)
{
	PrintToServer("Fixing doors");
	SetConVarInt(hDoorsOn, 1);
	SetConVarInt(hDoorsOn, 0);
}

public Action:Survivor_Rescued(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event,"rescuer"));
	new target = GetClientOfUserId(GetEventInt(event,"victim"));
	if (bMenuOn)
	{
		if (!bNightmare)
		{
			if (IsSurvivor(client) && !IsFakeClient(client))
			{
				new earnedxp = 15 * GetXPDiff(0);
				new level = cLevel[client];
				if (level < 50)
				{
					GiveXP(client, earnedxp);
					PrintToChat(client, "\x05[Lethal-Injection]\x01 Rescued Teammate: \x03%i\x01 XP", earnedxp);
				}
				else
				{
					GiveXP(client, earnedxp);
				}
			}
			if (IsSurvivor(target))
			{
				DefibHealth[target] = 500;
			}
		}
	}
}
public Action:Tongue_Grab(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (bMenuOn)
	{
		if (IsInstaCapper(client))
		{
			if (IsSurvivor(victim) && !IsPlayerIncap(victim))
			{
				DealDamagePlayer(victim, client, 128, 600, "point_hurt");
			}
		}
	}
}
public Action:Weapon_Drop(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	//new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new entity = GetEventInt(event,"propid");

	if (bMenuOn)
	{
		if (entity > 0)
		{
			new String:classname[24];
			GetEdictClassname(entity, classname, sizeof(classname));
			//PrintToChatAll("Weapon_Drop: %s", classname);
			if (StrEqual(classname, "weapon_rifle_m60", false))
			{
				CreateTimer(0.1, M60DropTimer, entity, TIMER_FLAG_NO_MAPCHANGE);
			}
			if (bIsScavengeFinale())
			{
				if (iFinaleStage > 0)
				{
					if (IsValidEntity(entity))
					{
						if (StrEqual(classname, "weapon_gascan", false))
						{
							SetEntProp(entity, Prop_Send, "m_iGlowType", 3);
							new glowcolor = RGB_TO_INT(255, 150, 0);
							SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
						}
					}
				}
			}
		}
	}
}
public Action:Weapon_Fire(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new String:weapon[20];
	GetEventString(event, "weapon", weapon, sizeof(weapon));

	if (IsSurvivor(client) && !IsFakeClient(client) && IsPlayerAlive(client))
	{
		//PrintToChat(client, "Fire:%s", weapon);
		if (StrEqual(weapon, "pipe_bomb") || StrEqual(weapon, "vomitjar") || StrEqual(weapon, "molotov"))
		{
			BackpackDelay[client] = 1;
		}
		new level = cLevel[client];
		new mountedgun = GetEntProp(client, Prop_Send, "m_usingMountedGun");
		if (mountedgun == 0)
		{
			CorrectAmmoOffsets(client);
			if (level >= 47 && !bNightmare)
			{
				new viewmodel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
				if (viewmodel > 32 && IsValidEntity(viewmodel) && IsLaserViewModel(viewmodel))
				{
					new Float:Origin[3];
					new entity = GetPlayerEye(client, Origin, entity);
					//PrintToChat(client, "Trace: %f %f %f", Origin[0], Origin[1], Origin[2]);

					EmitSoundToAll("ambient/energy/zap6.wav", client, SNDCHAN_AUTO, SNDLEVEL_HOME, SND_NOFLAGS, SNDVOL_NORMAL, 125, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					//EmitAmbientSound("ambient/energy/zap6.wav", Origin, SOUND_FROM_WORLD, SNDLEVEL_HELICOPTER, SND_NOFLAGS, SNDVOL_NORMAL, 125, 0.0);

					CreateLaser(viewmodel, Origin);	

					if (InstaGibOn[client] == 0)
					{
						if (IsInfected(entity) || IsWitch(entity))
						{
							DealDamageEntity2(entity, client, 10, 25, "point_hurt");
						}
						else if (entity > 0 && entity <= 32)
						{
							if (IsClientInGame(entity) && IsPlayerAlive(entity) && GetClientTeam(entity) == 3 && !IsPlayerGhost(entity))
							{
								DealDamagePlayer(entity, client, 10, 25, "point_hurt");
							}
						}
					}
				}
			}
		}
		//heat seeker
		if (level >= 27)
		{
			if (HeatSeekerOn[client] == 1)
			{
				if (StrEqual(weapon, "grenade_launcher"))
				{
					new weaponid = GetPlayerWeaponSlot(client, 0);
					if (weaponid > 0 && IsValidEntity(weaponid))
					{
						SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 30);
					}
				}
			}
		}
		//chainsaw massacre
		if (level >= 25)
		{
			if (ChainsawMassOn[client] == 1)
			{
				if (StrEqual(weapon, "chainsaw"))
				{
					new weaponid = GetPlayerWeaponSlot(client, 1);
					if (weaponid > 0 && IsValidEntity(weaponid))
					{
						SetEntProp(weaponid, Prop_Send, "m_iClip1", 31);
					}
				}
			}
		}
	}
}
public Action:Weapon_Reload(Handle:event, const String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event,"userid"));
	if (bMenuOn)
	{
		if (client > 0)
		{
			if (IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 2 && !bNightmare)
			{
				UpdateReload(client);
			}
		}
	}
}
//=============================
// TANK SPAWN RELATED
//=============================
stock GetFinaleTankType()
{
	new survivorstrength = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSurvivor(i))
		{
			survivorstrength += 1;
			new level = cLevel[i];
			if (level >= 40)
			{
				survivorstrength += 4;
			}
			else if (level >= 30)
			{
				survivorstrength += 3;
			}
			else if (level >= 20)
			{
				survivorstrength += 2;
			}
			else if (level >= 10)
			{
				survivorstrength += 1;
			}
		}
	}
	survivorstrength = 60;
	if (survivorstrength >= 60)
	{
		new random = GetRandomInt(1,60);
		if (random <= 45)
		{
			return GetRandomInt(1,16);
		}
	}
	else if (survivorstrength >= 50)
	{
		new random = GetRandomInt(1,50);
		if (random <= 30)
		{
			return GetRandomInt(1,16);
		}
	}
	else if (survivorstrength >= 40)
	{
		new random = GetRandomInt(1,40);
		if (random <= 20)
		{
			return GetRandomInt(1,16);
		}
	}
	else if (survivorstrength >= 30)
	{
		new random = GetRandomInt(1,30);
		if (random <= 10)
		{
			return GetRandomInt(1,16);
		}
	}
	else if (survivorstrength >= 20)
	{
		new random = GetRandomInt(1,20);
		if (random <= 5)
		{
			return GetRandomInt(1,16);
		}
	}
	else if (survivorstrength >= 10)
	{
		new random = GetRandomInt(1,10);
		if (random <= 2)
		{
			return GetRandomInt(1,16);
		}
	}
	return 255;
}
stock SetTankType(client, type)
{
	if (type == 0)
	{
		type = GetFinaleTankType();
	}
	PrintToServer("Setting new tank type to %i", type);
	switch(type)
	{
		case 1: SetEntityRenderColor(client, 255, 255, 255, 255); //Tech 75,95,105,255
		case 2: SetEntityRenderColor(client, 70, 80, 100, 255); //Smasher
		case 3: SetEntityRenderColor(client, 130, 130, 255, 255); //Warp
		case 4: SetEntityRenderColor(client, 100, 25, 25, 255); //Meteor
		case 5: SetEntityRenderColor(client, 12, 115, 128, 255); //Spitter
		case 6: SetEntityRenderColor(client, 100, 255, 200, 255); //Heal
		case 7: SetEntityRenderColor(client, 128, 0, 0, 255); //Fire
		case 8:
		{
			//Ice
			SetEntityRenderMode(client, RenderMode:3);
      	 		SetEntityRenderColor(client, 0, 100, 170, 200);
		}
		case 9: SetEntityRenderColor(client, 255, 200, 0, 255); //Jockey
		case 10:
		{
			//Ghost
			SetEntityRenderMode(client, RenderMode:3);
      	 		SetEntityRenderColor(client, 100, 100, 100, 0);
		}
		case 11: SetEntityRenderColor(client, 100, 165, 255, 255); //Shock
		case 12: SetEntityRenderColor(client, 255, 200, 255, 255); //Witch
		case 13: SetEntityRenderColor(client, 135, 205, 255, 255); //Shield
		case 14: SetEntityRenderColor(client, 0, 105, 255, 255); //Cobalt
		case 15: SetEntityRenderColor(client, 200, 255, 0, 255); //Jumper
		case 16: SetEntityRenderColor(client, 33, 34, 35, 255); //Gravity
		case 255: SetEntityRenderColor(client, 255, 255, 255, 255); //Normal
		case 666: SetEntityRenderColor(client, 255, 150, 100, 255); //Demon
	}
	//PrintToChatAll("SetTankType: %i, Tank: %i, TankAlive: %i", type, client, TankAlive[client]);

	SetConVarInt(hTankType, 0);
}
public Action:TankSpawnTimer(Handle:timer, any:client)
{
	if (IsTank(client))
	{
		SetEntProp(client, Prop_Data, "m_iHealth", GetConVarInt(FindConVar("z_tank_health")));
		new color = GetEntityRenderColor(client);
		switch(color)
		{
			//Fire Tank
			case 12800:
			{
				ResetInfectedAbility(client, 6.0);
				CreateTimer(0.8, Timer_AttachFIRE,client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Fire Tank");
				}
			}
			//Gravity Tank
			case 333435:
			{
				ResetInfectedAbility(client, 10.0);
				CreateTimer(0.1, GravityTankTimer, client, TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Gravity Tank");
				}
			}
			//Ice Tank
			case 0100170:
			{
				ResetInfectedAbility(client, 6.0);
				CreateTimer(2.0, Timer_AttachICE, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Ice Tank");
				}
			}
			//Cobalt Tank
			case 0105255:
			{
				ResetInfectedAbility(client, 999.0);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Cobalt Tank");
				}
			}
			//Meteor Tank
			case 1002525:
			{
				ResetInfectedAbility(client, 10.0);
				CreateTimer(0.1, MeteorTankTimer, client, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(6.0, Timer_AttachMETEOR, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Meteor Tank");
				}
			}
			//Jumper Tank
			case 2002550:
			{
				ResetInfectedAbility(client, 999.0);
				CreateTimer(0.1, JumperTankTimer, client, TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Jumper Tank");
				}
			}
			//Jockey Tank
			case 2552000:
			{
				ResetInfectedAbility(client, 2.0);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Jockey Tank");
				}
			}
			//Smasher Tank
			case 7080100:
			{
				ResetInfectedAbility(client, 999.0);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Smasher Tank");
				}
			}
			//Tech Tank
			case 7595105:
			{
				ResetInfectedAbility(client, 15.0);
				CreateTimer(0.1, TechTankTimer, client, TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Tech Tank");
				}
			}		
			//Spitter Tank
			case 12115128:
			{
				ResetInfectedAbility(client, 6.0);
				CreateTimer(2.0, Timer_AttachSPIT, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Spitter Tank");
				}
			}
			//Hulk Tank
			case 100255200:
			{
				ResetInfectedAbility(client, 15.0);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Hulk Tank");
				}
			}				
			//Ghost Tank
			case 100100100:
			{
				ResetInfectedAbility(client, 15.0);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Ghost Tank");
				}
			}
			//Shock Tank
			case 100165255:
			{
				ResetInfectedAbility(client, 10.0);
				CreateTimer(0.8, Timer_AttachELEC, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Shock Tank");
				}
			}
			//Warp Tank
			case 130130255:
			{
				ResetInfectedAbility(client, 9.0);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Warp Tank");
				}
			}
			//Shield Tank
			case 135205255:
			{
				ResetInfectedAbility(client, 8.0);
				if (ShieldsUp[client] == 0)
				{
					ActivateShield(client);
				}
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Shield Tank");
				}
			}
			//Demon Tank
			case 255150100:
			{
				ResetInfectedAbility(client, 999.0);
				CreateTimer(0.1, DemonTankTimer, client, TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Demon Tank");
				}				
			}	
			//Witch Tank
			case 255200255:
			{
				ResetInfectedAbility(client, 7.0);
				CreateTimer(2.0, Timer_AttachBLOOD, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				if (IsFakeClient(client))
				{
					SetClientInfo(client, "name", "Witch Tank");
				}				
			}
		}
	}
}
//=============================
// TANK CONTROLLER
//=============================
public TankController()
{
	CountTanks();
	if (iNumTanks > 0)
	{
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsTank(i))
			{
				//Extinquish fire for certain custom tanks
				new color = GetEntityRenderColor(i);
				if (color != 255255255 && color != 7080100)
				{
					if (IsPlayerBurning(i))
					{
						ExtinguishEntity(i);
						SetEntPropFloat(i, Prop_Send, "m_burnPercent", 1.0);
					}
				}
				else
				{
					if (IsPlayerBurning(i))
					{
						new Float:speed = GetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue");
						if (color == 255255255)
						{
							if (speed == 1.0)
							{
								SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.2);
							}
						}
						else if (color == 7080100)
						{
							if (speed == 0.65)
							{
								SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 0.85);
							}
						}
					}
				}
				switch(color)
				{
					//Fire Tank
					case 12800:
					{
						IgniteEntity(i, 1.0);
						FireTankAbility(i);	
					}
					//Gravity Tank
					case 333435:
					{
						SetEntityGravity(i, 0.5);
					}
					//Ice Tank
					case 0100170:
					{
						IceTankAbility(i);
					}
					//Cobalt Tank
					case 0105255:
					{
						if (TankAbility[i] == 0)
						{
							SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.0);
							new random = GetRandomInt(1,9);
							if (random == 1)
							{
								TankAbility[i] = 1;
								CreateTimer(0.3, BlurEffect, i, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
							}
						}
						else if (TankAbility[i] == 1)
						{
							SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 2.5);
						}
					}
					//Meteor Tank
					case 1002525:
					{
						if (TankAbility[i] == 0)
						{
							new random = GetRandomInt(1,30);
							if (random == 1)
							{
								StartMeteorFall(i);
							}
						}
					}
					//Jumper Tank
					case 2002550:
					{
						JumperTankAbility(i);
						SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.20);
					}
					//Jockey Tank
					case 2552000:
					{
						SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.33);
					}
					//Smasher Tank
					case 7080100:
					{
						new glowcolor = RGB_TO_INT(50, 50, 50);
						SetEntProp(i, Prop_Send, "m_glowColorOverride", glowcolor);
						SetEntProp(i, Prop_Send, "m_iGlowType", 2);
						SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 0.65);		
					}
					//Tech Tank
					case 7595105:
					{	
						//TechTankAbility(i);
						//CreateTimer(0.5, TechTankAbilityTimer, i, TIMER_FLAG_NO_MAPCHANGE);
					}
					//Spitter Tank
					case 12115128:
					{
						SpitterTankAbility(i);
					}
					//Hulk Tank
					case 100255200:
					{
						HulkTankAbility(i);
						if (TankAbilityTimer[i] > 0)
						{
							TankAbilityTimer[i] -= 1;
						}
					}
					//Ghost Tank
					case 100100100:
					{
						InfectedCloak(i);
						if (CountSurvOutRange(i, 120) == CountSurvivorsAliveAll())
						{
							SetEntityRenderMode(i, RenderMode:3);
      	 						SetEntityRenderColor(i, 100, 100, 100, 50);
							EmitSoundToAll("npc/infected/action/die/male/death_43.wav", i);
						}
						else
						{
							SetEntityRenderMode(i, RenderMode:3);
      	 						SetEntityRenderColor(i, 100, 100, 100, 150);
							EmitSoundToAll("npc/infected/action/die/male/death_42.wav", i);
						}
						GhostTankAbility(i);
					}
					//Shock Tank
					case 100165255:
					{
						ShockTankAbility(i);
					}
					//Warp Tank
					case 130130255:
					{
						if (IsFakeClient(i))
						{
							new random = 0;
							new health = GetEntProp(i, Prop_Send, "m_iHealth");
							new maxhealth = GetConVarInt(FindConVar("z_tank_health"));
							if (maxhealth / 4 > health)
							{
								random = GetRandomInt(1,5);
							}
							else if (maxhealth / 2 > health)
							{
								random = GetRandomInt(1,12);
							}
							else
							{
								random = GetRandomInt(1,20);
							}
							if (random == 1)
							{
								TeleportTank(i);
							}
						}
					}
					//Shield Tank
					case 135205255:
					{
						ShieldState[i] -= 1;
						if (ShieldState[i] <= -60)
						{
							DeactivateShield(i, 30.0);
							ShieldState[i] = 0;
						}
						if (ShieldsUp[i] > 0)
						{
							new glowcolor = RGB_TO_INT(120, 90, 150);
							SetEntProp(i, Prop_Send, "m_iGlowType", 2);
							SetEntProp(i, Prop_Send, "m_bFlashing", 2);
							SetEntProp(i, Prop_Send, "m_glowColorOverride", glowcolor);
						}
						else
						{
							SetEntProp(i, Prop_Send, "m_iGlowType", 0);
							SetEntProp(i, Prop_Send, "m_bFlashing", 0);
							SetEntProp(i, Prop_Send, "m_glowColorOverride", 0);
						}
					}
					//Demon Tank
					case 255150100:
					{
						SetEntityGravity(i, 0.5);
					}
					//Witch Tank
					case 255200255:
					{
						WitchTankAbility(i);		
					}		
				}		
			}
		}
	}
}
//=============================
//	TANK FUNCTIONS
//=============================
stock XPGetWeaponType(zombie, player)
{
	new weapontype = 0;
	new damage = 0;
	new saveddamage = 0;
	for (new index=0; index<=7; index++)
	{
		damage = XPDamage[zombie][player][index];
		if (damage > saveddamage)
		{
			saveddamage = damage;
			weapontype = index;
		}
	}
	return weapontype;
}
stock XPGetTotalDamage(zombie, player)
{
	new totaldmg = 0;
	for (new index=0; index<=7; index++)
	{
		totaldmg += XPDamage[zombie][player][index];
	}
	return totaldmg;
}
stock XPClearDamageArray(zombie, player)
{
	for (new index=0; index<=7; index++)
	{
		XPDamage[zombie][player][index] = 0;
	}	
}
stock ExecSpecialDeath(client, class, type)
{
	if (!bNightmare)
	{
		if (type < 0 || type > 2)
		{
			return;
		}
		new xp = 0;
		switch(type)
		{
			case 0: xp = 10;
			case 1: xp = 50;
			case 2: xp = 100;
		}
		new bonusxp = xp / 2;
		decl String:zombieclass[24];
		switch(class)
		{
			case 1:
			{
				if (type == 0)
				{
					zombieclass = "Smoker";
				}
				else if (type == 1)
				{
					zombieclass = "Smoker Breeder";
				}
				else if (type == 2)
				{
					zombieclass = "Smoker Insta-Capper";
				}
			}
			case 2:
			{
				if (type == 0)
				{
					zombieclass = "Boomer";
				}
				else if (type == 1)
				{
					zombieclass = "Boomer Breeder";
				}
				else if (type == 2)
				{
					zombieclass = "Boomer Insta-Capper";
				}
			}
			case 3:
			{
				if (type == 0)
				{
					zombieclass = "Hunter";
				}
				else if (type == 1)
				{
					zombieclass = "Hunter Breeder";
				}
				else if (type == 2)
				{
					zombieclass = "Hunter Insta-Capper";
				}
			}
			case 4:
			{
				if (type == 0)
				{
					zombieclass = "Spitter";
				}
				else if (type == 1)
				{
					zombieclass = "Spitter Breeder";
				}
				else if (type == 2)
				{
					zombieclass = "Spitter Insta-Capper";
				}
			}
			case 5:
			{
				if (type == 0)
				{
					zombieclass = "Jockey";
				}
				else if (type == 1)
				{
					zombieclass = "Jockey Breeder";
				}
				else if (type == 2)
				{
					zombieclass = "Jockey Insta-Capper";
				}
			}
			case 6:
			{
				if (type == 0)
				{
					zombieclass = "Charger";
				}
				else if (type == 1)
				{
					zombieclass = "Charger Breeder";
				}
				else if (type == 2)
				{
					zombieclass = "Charger Insta-Capper";
				}
			}
		}
		for (new i=1; i<=MaxClients; i++)
		{
			new weapontype = XPGetWeaponType(client, i);
			new xpdmg = XPGetTotalDamage(client, i);
			if (xpdmg > 0 && IsSurvivor(i) && !IsFakeClient(i))
			{
				new earnedxp = 0;
				if (xpdmg > xp)
				{
					earnedxp = xp * GetXPDiff(1);
				}
				else
				{
					earnedxp = xpdmg * GetXPDiff(1);
				}
				new level = cLevel[i];
				if (level < 50)
				{
					GiveXP(i, earnedxp);
					switch(weapontype)
					{
						case 0: PrintToChat(i, "\x05[Lethal-Injection]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", zombieclass, xpdmg, earnedxp);
						case 1: PrintToChat(i, "\x04[Sentry Gun]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", zombieclass, xpdmg, earnedxp);
						case 2: PrintToChat(i, "\x04[Shoulder Cannon]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", zombieclass, xpdmg, earnedxp);
						case 4: PrintToChat(i, "\x04[High Frequency Emitter]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", zombieclass, xpdmg, earnedxp);
						case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", zombieclass, xpdmg, earnedxp);
						case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", zombieclass, xpdmg, earnedxp);
						case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", zombieclass, xpdmg, earnedxp);
					}
					if (weapontype >= 4 && weapontype <= 6)
					{
						for (new j=1; j<=MaxClients; j++)
						{
							if (IsSurvivor(j) && IsPlayerAlive(j) && j != i)
							{
								new lvl = cLevel[j];
								if (lvl < 50)
								{
									new bombxp = earnedxp / 2;
									new xpdmg2 = XPGetTotalDamage(client, j);
									if (bombxp > xpdmg2)
									{
										GiveXP(j, bombxp);
										switch(weapontype)
										{
											case 5: PrintToChat(j, "\x04[Artillery Barrage]\x01 %s Killed \x03%i\x01 XP", zombieclass, bombxp);
											case 6: PrintToChat(j, "\x04[Ion Cannon]\x01 %s Killed \x03%i\x01 XP", zombieclass, bombxp);
											case 7: PrintToChat(j, "\x04[Nuclear Strike]\x01 %s Killed \x03%i\x01 XP", zombieclass, bombxp);
										}
										XPClearDamageArray(client, j);
									}
								}
							}
						}
					}
				}
				else
				{
					GiveXP(i, earnedxp);
					if (weapontype >= 4 && weapontype <= 6)
					{
						for (new j=1; j<=MaxClients; j++)
						{
							if (IsSurvivor(j) && IsPlayerAlive(j) && j != i)
							{
								new lvl = cLevel[j];
								if (lvl < 50)
								{
									new bombxp = earnedxp / 2;
									new xpdmg2 = XPGetTotalDamage(client, j);
									if (bombxp > xpdmg2)
									{
										GiveXP(j, bombxp);
										switch(weapontype)
										{
											case 5: PrintToChat(j, "\x04[Artillery Barrage]\x01 %s Killed \x03%i\x01 XP", zombieclass, bombxp);
											case 6: PrintToChat(j, "\x04[Ion Cannon]\x01 %s Killed \x03%i\x01 XP", zombieclass, bombxp);
											case 7: PrintToChat(j, "\x04[Nuclear Strike]\x01 %s Killed \x03%i\x01 XP", zombieclass, bombxp);
										}
										XPClearDamageArray(client, j);
									}
								}
							}
						}
					}
				}
			}
			XPClearDamageArray(client, i);
			if (ChainsawDamage[client][i] > 0 && IsSurvivor(i) && !IsFakeClient(i))
			{
				new earnedxp = 0;
				new bonusdmg = ChainsawDamage[client][i];
				if (bonusdmg > 0)
				{
					if (bonusdmg > bonusxp)
					{
						earnedxp = bonusxp * GetXPDiff(1);
					}
					else
					{
						earnedxp = bonusdmg * GetXPDiff(1);
					}
					new level = cLevel[i];
					if (level < 50)
					{
						GiveXP(i, earnedxp);
						PrintToChat(i, "\x04[Chainsaw Massacre]\x01 %s Killed \x03%i\x01 XP", zombieclass, earnedxp);
					}
					else
					{
						GiveXP(i, earnedxp);
					}
				}
			}
			ChainsawDamage[client][i] = 0;
		}
	}
}
stock ExecTankDeath(client, type)
{
	TankAlive[client] = 0;
	TankAbility[client] = 0;

	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "prop_dynamic")) != INVALID_ENT_REFERENCE)
	{
		decl String:model[64];
            	GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
		if (StrEqual(model, "models/props_debris/concrete_chunk01a.mdl", false))
		{
			new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			if (owner == client)
			{
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.0);
				AcceptEntityInput(entity, "Kill");
			}
		}
		else if (StrEqual(model, "models/props_vehicles/tire001c_car.mdl", false))
		{
			new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			if (owner == client)
			{
				AcceptEntityInput(entity, "Kill");
			}
		}
		else if (StrEqual(model, "models/props_unique/airport/atlas_break_ball.mdl", false))
		{
			new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			if (owner == client)
			{
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.0);
				AcceptEntityInput(entity, "Kill");
			}
		}
		else if (StrEqual(model, "models/props_c17/substation_circuitbreaker03.mdl", false))
		{
			new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			if (owner == client)
			{
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.0);
				AcceptEntityInput(entity, "Kill");
			}
		}
		else if (StrEqual(model, MODEL_M60, false))
		{
			new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			if (owner == client)
			{
				if (entity == TechTankGun[client][0])
				{
					TechTankGun[client][0] = 0;
				}
				else if (entity == TechTankGun[client][1])
				{
					TechTankGun[client][1] = 0;
				}
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.0);
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
	while ((entity = FindEntityByClassname(entity, "beam_spotlight")) != INVALID_ENT_REFERENCE)
	{
		new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
		if (owner == client)
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
	while ((entity = FindEntityByClassname(entity, "point_push")) != INVALID_ENT_REFERENCE)
	{
		new owner = GetEntProp(entity, Prop_Send, "m_glowColorOverride");
		if (owner == client)
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
	while ((entity = FindEntityByClassname(entity, "info_particle_system")) != INVALID_ENT_REFERENCE)
	{
		new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
		if (owner == client)
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
	if (!bNightmare)
	{
		new xp = 200;
		if (type >= 1 && type <= 16)
		{
			xp = 250;
		}
		else if (type == 666)
		{
			xp = 300;
		}
		decl String:tanktype[24];
		switch(type)
		{
			case 1: tanktype = "Tech Tank";
			case 2: tanktype = "Smasher Tank";
			case 3: tanktype = "Warp Tank";
			case 4: tanktype = "Meteor Tank";
			case 5: tanktype = "Spitter Tank";
			case 6: tanktype = "Hulk Tank";
			case 7: tanktype = "Fire Tank";
			case 8: tanktype = "Ice Tank";
			case 9: tanktype = "Jockey Tank";
			case 10: tanktype = "Ghost Tank";
			case 11: tanktype = "Shock Tank";
			case 12: tanktype = "Witch Tank";
			case 13: tanktype = "Shield Tank";
			case 14: tanktype = "Cobalt Tank";
			case 15: tanktype = "Jumper Tank";
			case 16: tanktype = "Gravity Tank";
			case 255: tanktype = "Tank";
			case 666: tanktype = "Demon Tank";
		}
		new bonusxp = xp / 2;
		for (new i=1; i<=MaxClients; i++)
		{
			new weapontype = XPGetWeaponType(client, i);
			new xpdmg = XPGetTotalDamage(client, i);
			if (xpdmg > 0 && IsSurvivor(i) && !IsFakeClient(i))
			{
				new earnedxp = 0;
				if (xpdmg > xp)
				{
					earnedxp = xp * GetXPDiff(1);
				}
				else
				{
					earnedxp = xpdmg * GetXPDiff(1);
				}
				new level = cLevel[i];
				if (level < 50)
				{
					GiveXP(i, earnedxp);
					switch(weapontype)
					{
						case 0: PrintToChat(i, "\x05[Lethal-Injection]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", tanktype, xpdmg, earnedxp);
						case 1: PrintToChat(i, "\x04[Sentry Gun]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", tanktype, xpdmg, earnedxp);
						case 2: PrintToChat(i, "\x04[Shoulder Cannon]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", tanktype, xpdmg, earnedxp);
						case 5: PrintToChat(i, "\x04[Artillery Barrage]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", tanktype, xpdmg, earnedxp);
						case 6: PrintToChat(i, "\x04[Ion Cannon]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", tanktype, xpdmg, earnedxp);
						case 7: PrintToChat(i, "\x04[Nuclear Strike]\x01 %s Killed [\x04%i\x01 Damage]: \x03%i\x01 XP", tanktype, xpdmg, earnedxp);
					}
					if (weapontype >= 4 && weapontype <= 6)
					{
						for (new j=1; j<=MaxClients; j++)
						{
							if (IsSurvivor(j) && IsPlayerAlive(j) && j != i)
							{
								new lvl = cLevel[j];
								if (lvl < 50)
								{
									new bombxp = earnedxp / 2;
									new xpdmg2 = XPGetTotalDamage(client, j);
									if (bombxp > xpdmg2)
									{
										GiveXP(j, bombxp);
										switch(weapontype)
										{
											case 5: PrintToChat(j, "\x04[Artillery Barrage]\x01 %s Killed \x03%i\x01 XP", tanktype, bombxp);
											case 6: PrintToChat(j, "\x04[Ion Cannon]\x01 %s Killed \x03%i\x01 XP", tanktype, bombxp);
											case 7: PrintToChat(j, "\x04[Nuclear Strike]\x01 %s Killed \x03%i\x01 XP", tanktype, bombxp);
										}
										XPClearDamageArray(client, j);
									}
								}
							}
						}
					}
				}
				else
				{
					GiveXP(i, earnedxp);
					if (weapontype >= 4 && weapontype <= 6)
					{
						for (new j=1; j<=MaxClients; j++)
						{
							if (IsSurvivor(j) && IsPlayerAlive(j) && j != i)
							{
								new lvl = cLevel[j];
								if (lvl < 50)
								{
									new bombxp = earnedxp / 2;
									new xpdmg2 = XPGetTotalDamage(client, j);
									if (bombxp > xpdmg2)
									{
										GiveXP(j, bombxp);
										switch(weapontype)
										{
											case 5: PrintToChat(j, "\x04[Artillery Barrage]\x01 %s Killed \x03%i\x01 XP", tanktype, bombxp);
											case 6: PrintToChat(j, "\x04[Ion Cannon]\x01 %s Killed \x03%i\x01 XP", tanktype, bombxp);
											case 7: PrintToChat(j, "\x04[Nuclear Strike]\x01 %s Killed \x03%i\x01 XP", tanktype, bombxp);
										}
										XPClearDamageArray(client, j);
									}
								}
							}
						}
					}
				}
			}
			XPClearDamageArray(client, i);
			if (ChainsawDamage[client][i] > 0 && IsSurvivor(i) && !IsFakeClient(i))
			{
				new earnedxp = 0;
				new dmg = ChainsawDamage[client][i];
				if (dmg > bonusxp)
				{
					earnedxp = bonusxp * GetXPDiff(1);
				}
				else
				{
					earnedxp = dmg * GetXPDiff(1);
				}
				new level = cLevel[i];
				if (level < 50)
				{
					GiveXP(i, earnedxp);
					PrintToChat(i, "\x04[Chainsaw Massacre]\x01 %s Killed \x03%i\x01 XP", tanktype, earnedxp);
				}
				else
				{
					GiveXP(i, earnedxp);
				}
			}
			ChainsawDamage[client][i] = 0;
		}
	}
}
stock TeleportTank(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 130130255)
	{
		new target = PickNotInSR();
		if (target)
		{
			new Float:Origin[3], Float:Angles[3];
			GetClientAbsOrigin(target, Origin);
                        GetClientAbsAngles(target, Angles);
			CreateParticle(client, PARTICLE_WARP, 1.0, 0.0);
			TeleportEntity(client, Origin, Angles, NULL_VECTOR);
		}
	}
}
stock InfectedCloak(client)
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSpecialInfected(i))
		{
			decl Float:TankPos[3], Float:InfectedPos[3];
                        GetClientAbsOrigin(client, TankPos);
                        GetClientAbsOrigin(i, InfectedPos);
                       	new Float:distance = GetVectorDistance(TankPos, InfectedPos);
                        if (distance < 500)
			{
				SetEntityRenderMode(i, RenderMode:3);
      	 			SetEntityRenderColor(i, 255, 255, 255, 50);
			}
			else
			{
				SetEntityRenderMode(i, RenderMode:3);
      	 			SetEntityRenderColor(i, 255, 255, 255, 255);
			}
		}
	}
}
stock bool:SurvInRange(client, target, targetDist)
{
	if (IsSurvivor(target) && IsPlayerAlive(target))
	{
		decl Float:TankPos[3], Float:PlayerPos[3];
                GetClientAbsOrigin(client, TankPos);
                GetClientAbsOrigin(target, PlayerPos);
                new Float:distance = GetVectorDistance(TankPos, PlayerPos);
                if (distance <= targetDist)
		{
			return true;
		}
	}
	return false;
}
stock CountSurvInRange(client, targetDist)
{
	new count = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSurvivor(i) && IsPlayerAlive(i))
		{
			decl Float:TankPos[3], Float:PlayerPos[3];
                        GetClientAbsOrigin(client, TankPos);
                        GetClientAbsOrigin(i, PlayerPos);
                       	new Float:distance = GetVectorDistance(TankPos, PlayerPos);
                        if (distance <= targetDist)
			{
				count++;
			}
		}
	}
	return count;
}
stock CountSurvOutRange(client, targetDist)
{
	new count = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSurvivor(i) && IsPlayerAlive(i))
		{
			decl Float:TankPos[3], Float:PlayerPos[3];
                        GetClientAbsOrigin(client, TankPos);
                        GetClientAbsOrigin(i, PlayerPos);
                       	new Float:distance = GetVectorDistance(TankPos, PlayerPos);
                        if (distance > targetDist)
			{
				count++;
			}
		}
	}
	return count;
}
public Action:BlurEffect(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 0105255 && TankAbility[client] == 1)
	{
		new Float:TankPos[3], Float:TankAng[3];
		GetClientAbsOrigin(client, TankPos);
		GetClientAbsAngles(client, TankAng);
		new Anim = GetEntProp(client, Prop_Send, "m_nSequence");
		new entity = CreateEntityByName("prop_dynamic");
		if (IsValidEntity(entity))
		{
			DispatchKeyValue(entity, "model", "models/infected/hulk.mdl");
			DispatchKeyValue(entity, "solid", "6");
			DispatchSpawn(entity);
			AcceptEntityInput(entity, "DisableCollision");
			SetEntityRenderColor(entity, 0, 105, 255, 255);
			SetEntProp(entity, Prop_Send, "m_nSequence", Anim);
			SetEntPropFloat(entity, Prop_Send, "m_flPlaybackRate", 15.0);
			TeleportEntity(entity, TankPos, TankAng, NULL_VECTOR);
			CreateTimer(0.3, RemoveBlurEffect, entity, TIMER_FLAG_NO_MAPCHANGE);
			return Plugin_Continue;
		}		
	}
	return Plugin_Stop;
}
public Action:RemoveBlurEffect(Handle:timer, any:entity)
{
	if (IsValidEntity(entity))
	{
		decl String:classname[32];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[128];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/infected/hulk.mdl", false))
			{
				AcceptEntityInput(entity, "Kill");
			}
		}	
	}
}
stock StartMeteorFall(client)
{
	TankAbility[client] = 1;
	decl Float:pos[3];
	GetClientEyePosition(client, pos);
	
	new Handle:Pack = CreateDataPack();
	WritePackCell(Pack, iRound);
	WritePackCell(Pack, client);
	WritePackFloat(Pack, pos[0]);
	WritePackFloat(Pack, pos[1]);
	WritePackFloat(Pack, pos[2]);
	WritePackFloat(Pack, GetEngineTime());
	CreateTimer(0.6, UpdateMeteorFall, Pack);
}

public Action:UpdateMeteorFall(Handle:timer, any:data)
{
	ResetPack(data);
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	decl Float:pos[3];
	pos[0] = ReadPackFloat(data);
	pos[1] = ReadPackFloat(data);
	pos[2] = ReadPackFloat(data);
	new Float:time = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if ((GetEngineTime() - time) > 5.0)
	{
		TankAbility[client] = 0;
	}
	new entity = -1;
	if (IsTank(client) && TankAbility[client] == 1)
	{
		decl Float:angle[3], Float:velocity[3], Float:hitpos[3];
		angle[0] = 0.0 + GetRandomFloat(-20.0, 20.0);
		angle[1] = 0.0 + GetRandomFloat(-20.0, 20.0);
		angle[2] = 60.0;
		
		GetVectorAngles(angle, angle);
		GetRayHitPos(pos, angle, hitpos, client, true);
		new Float:dis = GetVectorDistance(pos, hitpos);
		if (GetVectorDistance(pos, hitpos) > 2000.0)
		{
			dis = 1600.0;
		}
		decl Float:t[3];
		MakeVectorFromPoints(pos, hitpos, t);
		NormalizeVector(t, t);
		ScaleVector(t, dis - 40.0);
		AddVectors(pos, t, hitpos);
		
		if (dis > 100.0)
		{
			new ent = CreateEntityByName("tank_rock");
			if (ent > 0)
			{
				DispatchKeyValue(ent, "model", "models/props_debris/concrete_chunk01a.mdl"); 
				DispatchSpawn(ent);  
				decl Float:angle2[3];
				angle2[0] = GetRandomFloat(-180.0, 180.0);
				angle2[1] = GetRandomFloat(-180.0, 180.0);
				angle2[2] = GetRandomFloat(-180.0, 180.0);

				velocity[0] = GetRandomFloat(0.0, 350.0);
				velocity[1] = GetRandomFloat(0.0, 350.0);
				velocity[2] = GetRandomFloat(0.0, 30.0);

				TeleportEntity(ent, hitpos, angle2, velocity);
				ActivateEntity(ent);
	 
				AcceptEntityInput(ent, "Ignite");
				SetEntProp(ent, Prop_Send, "m_hOwnerEntity", client);
			}
		} 
	}
	else if (TankAbility[client] == 0)
	{
		while ((entity = FindEntityByClassname(entity, "tank_rock")) != INVALID_ENT_REFERENCE)
		{
			new ownerent = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			if (client == ownerent)
			{
				ExplodeMeteor(entity, ownerent);
			}
		}
		return;
	}
	while ((entity = FindEntityByClassname(entity, "tank_rock")) != INVALID_ENT_REFERENCE)
	{
		new ownerent = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
		if (client == ownerent)
		{
			if (OnGroundUnits(entity) < 200.0)
			{
				ExplodeMeteor(entity, ownerent);
			}
		}
	}

	new Handle:Pack = CreateDataPack();
	WritePackCell(Pack, round);
	WritePackCell(Pack, client);
	WritePackFloat(Pack, pos[0]);
	WritePackFloat(Pack, pos[1]);
	WritePackFloat(Pack, pos[2]);
	WritePackFloat(Pack, time);
	CreateTimer(0.6, UpdateMeteorFall, Pack);
}
public Float:OnGroundUnits(i_Ent)
{
	if (!(GetEntityFlags(i_Ent) & (FL_ONGROUND)))
	{ 
		decl Handle:h_Trace, Float:f_Origin[3], Float:f_Position[3], Float:f_Down[3] = { 90.0, 0.0, 0.0 };
		GetEntPropVector(i_Ent, Prop_Send, "m_vecOrigin", f_Origin);
		h_Trace = TR_TraceRayFilterEx(f_Origin, f_Down, CONTENTS_SOLID|CONTENTS_MOVEABLE, RayType_Infinite, TraceRayDontHitSelfAndLive, i_Ent);
		if (TR_DidHit(h_Trace))
		{
			decl Float:f_Units;
			TR_GetEndPosition(f_Position, h_Trace);
			f_Units = f_Origin[2] - f_Position[2];
			CloseHandle(h_Trace);
			return f_Units;
		}
		CloseHandle(h_Trace);
	} 
	
	return 0.0;
}
stock GetRayHitPos(Float:pos[3], Float:angle[3], Float:hitpos[3], ent=0, bool:useoffset=false)
{
	new Handle:trace;
	new hit=0;
	
	trace = TR_TraceRayFilterEx(pos, angle, MASK_SOLID, RayType_Infinite, TraceRayDontHitSelfAndLive, ent);
	if (TR_DidHit(trace))
	{
		TR_GetEndPosition(hitpos, trace);
		hit=TR_GetEntityIndex( trace);
	}
	CloseHandle(trace);
	
	if (useoffset)
	{
		decl Float:v[3];
		MakeVectorFromPoints(hitpos, pos, v);
		NormalizeVector(v, v);
		ScaleVector(v, 15.0);
		AddVectors(hitpos, v, hitpos);
	}
	return hit;
}
stock ExplodeMeteor(entity, client)
{
	if (entity > 32 && IsValidEntity(entity) && IsTank(client))
	{
		decl String:classname[16];
		GetEdictClassname(entity, classname, 20);
		if (!StrEqual(classname, "tank_rock", true))
		{
			return;
		}

		new Float:pos[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);	
		pos[2]+=50.0;
		AcceptEntityInput(entity, "Kill");

		PropaneExplode(client, pos);

		new pointHurt = CreateEntityByName("point_hurt");   
		DispatchKeyValue(pointHurt, "Damage", "40");        
		DispatchKeyValue(pointHurt, "DamageType", "2");  
		DispatchKeyValue(pointHurt, "DamageDelay", "0.0");
		DispatchKeyValueFloat(pointHurt, "DamageRadius", 200.0);  
		DispatchSpawn(pointHurt);
		TeleportEntity(pointHurt, pos, NULL_VECTOR, NULL_VECTOR);  
		AcceptEntityInput(pointHurt, "Hurt", client);
		SetVariantString("OnUser1 !self:Kill::0.1:-1");
		AcceptEntityInput(pointHurt, "AddOutput");
		AcceptEntityInput(pointHurt, "FireUser1");   
		
		new push = CreateEntityByName("point_push");         
  		DispatchKeyValueFloat (push, "magnitude", 600.0);                     
		DispatchKeyValueFloat (push, "radius", 200.0*1.0);                     
  		SetVariantString("spawnflags 24");                     
		AcceptEntityInput(push, "AddOutput");
 		DispatchSpawn(push);   
		TeleportEntity(push, pos, NULL_VECTOR, NULL_VECTOR);  
 		AcceptEntityInput(push, "Enable", -1, -1);
		SetVariantString("OnUser1 !self:Kill::0.5:-1");
		AcceptEntityInput(push, "AddOutput");
		AcceptEntityInput(push, "FireUser1");
	}
} 
public bool:TraceRayDontHitSelfAndLive(entity, mask, any:data)
{
	if (entity == data) 
	{
		return false; 
	}
	else if (entity > 0 && entity <= MaxClients)
	{
		if (IsClientInGame(entity))
		{
			return false;
		}
	}
	return true;
}
public Action:RockThrowTimer(Handle:timer)
{
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "tank_rock")) != INVALID_ENT_REFERENCE)
	{
		new thrower = GetEntPropEnt(entity, Prop_Data, "m_hThrower");
		if (thrower > 0 && thrower < 33 && IsTank(thrower))
		{
			new color = GetEntityRenderColor(thrower);
			switch(color)
			{
				//Fire Tank
				case 12800:
				{
      	 				SetEntityRenderColor(entity, 128, 0, 0, 255);
					CreateTimer(0.8, Timer_AttachFIRE_Rock, entity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
				//Ice Tank
				case 0100170:
				{
					SetEntityRenderMode(entity, RenderMode:3);
					SetEntityRenderColor(entity, 0, 100, 170, 180);
				}
				//Jockey Tank
				case 2552000:
				{
					Rock[thrower] = entity;
					CreateTimer(0.1, JockeyThrow, thrower, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
				//Spitter Tank
				case 12115128:
				{
					SetEntityRenderMode(entity, RenderMode:3);
      	 				SetEntityRenderColor(entity, 121, 151, 28, 30);
					CreateTimer(0.8, Timer_SpitSound, thrower, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(0.8, Timer_AttachSPIT_Rock, entity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
				//Shock Tank
				case 100165255:
				{
					CreateTimer(0.8, Timer_AttachELEC_Rock, entity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
				//Shield Tank
				case 135205255:
				{
					Rock[thrower] = entity;
					CreateTimer(0.1, PropaneThrow, thrower, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}
public Action:PropaneThrow(Handle:timer, any:client)
{
	new Float:velocity[3];
	new entity = Rock[client];
	if (IsValidEntity(entity))
	{
		new g_iVelocity = FindSendPropOffs("CBasePlayer", "m_vecVelocity[0]");	
		GetEntDataVector(entity, g_iVelocity, velocity);
		new Float:v = GetVectorLength(velocity);
		if (v > 500.0)
		{
			new propane = CreateEntityByName("prop_physics");
			if (IsValidEntity(propane))
			{
				DispatchKeyValue(propane, "model", MODEL_PROPANE);
				DispatchSpawn(propane);
				new Float:Pos[3];
				GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Pos);	
				AcceptEntityInput(entity, "Kill");
				NormalizeVector(velocity, velocity);
				new Float:speed = GetConVarFloat(FindConVar("z_tank_throw_force"));
				ScaleVector(velocity, speed*1.4);
				TeleportEntity(propane, Pos, NULL_VECTOR, velocity);
			}	
			return Plugin_Stop;
		}		
	}
	else
	{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}
public Action:JockeyThrow(Handle:timer, any:client)
{
	new Float:velocity[3];
	new entity = Rock[client];
	if (IsValidEntity(entity))
	{
		new g_iVelocity = FindSendPropOffs("CBasePlayer", "m_vecVelocity[0]");	
		GetEntDataVector(entity, g_iVelocity, velocity);
		new Float:v = GetVectorLength(velocity);
		if (v > 500.0)
		{
			if (CountTotal() < 29)
			{
				new bot = CreateFakeClient("Jockey");
				if (bot > 0)
				{
					SpawnInfected(bot, 5, true);
					new Float:Pos[3];
					GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Pos);	
					AcceptEntityInput(entity, "Kill");
					NormalizeVector(velocity, velocity);
					new Float:speed = GetConVarFloat(FindConVar("z_tank_throw_force"));
					ScaleVector(velocity, speed*1.4);
					TeleportEntity(bot, Pos, NULL_VECTOR, velocity);
				}	
				return Plugin_Stop;
			}
		}		
	}
	else
	{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}
stock GetNearestSurvivorDist(client)
{
    	new Float:TankPos[3], Float:SurvPos[3], Float:nearest = 0.0, Float:distance = 0.0;
	if (client > 0)
	{
		if (IsTank(client))
		{
			GetClientAbsOrigin(client, TankPos);
   			for (new i=1; i<=MaxClients; i++)
    			{
        			if (IsSurvivor(i) && IsPlayerAlive(i))
				{
					GetClientAbsOrigin(i, SurvPos);
                        		distance = GetVectorDistance(TankPos, SurvPos);
                        		if (nearest == 0.0 || nearest > distance)
					{
						nearest = distance;
					}
				}
			}
		} 
    	}
    	return RoundFloat(distance);
}
stock EntityGetNearestSurvivorDist(entity, bool:incap)
{
	new target = 0;
	if (IsWitch(entity))
	{
		new Float:Origin[3], Float:TOrigin[3], Float:distance = 0.0, Float:savedDistance = 0.0;
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
   		for (new i=1; i<=MaxClients; i++)
    		{
        		if (IsSurvivor(i) && IsPlayerAlive(i) && !IsPlayerInSaferoom(i, 0))
			{
				if (incap == IsPlayerIncap(i))
				{
					GetEntPropVector(i, Prop_Send, "m_vecOrigin", TOrigin);
                        		distance = GetVectorDistance(Origin, TOrigin);
					if (savedDistance == 0.0 || savedDistance > distance)
					{
						savedDistance = distance;
						target = i;
					}
				}
			}
		} 
    	}
    	return target;
}
public FakeJump(client)
{
	if (IsTank(client))
	{
		new Float:vecVelocity[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vecVelocity);
		if (vecVelocity[0] > 0.0 && vecVelocity[0] < 500.0)
		{
			vecVelocity[0] += 500.0;
		}
		else if (vecVelocity[0] < 0.0 && vecVelocity[0] > -500.0)
		{
			vecVelocity[0] += -500.0;
		}
		if (vecVelocity[1] > 0.0 && vecVelocity[1] < 500.0)
		{
			vecVelocity[1] += 500.0;
		}
		else if (vecVelocity[1] < 0.0 && vecVelocity[1] > -500.0)
		{
			vecVelocity[1] += -500.0;
		}
		vecVelocity[2] += 750.0;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vecVelocity);
	}
}
public SkillFlameClaw(target)
{
	if (target > 0)
	{
		if (IsClientInGame(target) && IsPlayerAlive(target) && GetClientTeam(target) == 2)
		{
			IgniteEntity(target, 3.0);
			EmitSoundToAll("ambient/fire/gascan_ignite1.wav", target);
			PerformFade(target, 500, 250, 10, 1, {100, 50, 0, 150});
		}
	}
}
public SkillIceClaw(target, client)
{
	if (target > 0)
	{
		if (IsClientInGame(target) && IsPlayerAlive(target) && GetClientTeam(target) == 2)
		{
			DealDamagePlayer(target, client, 128, GetRandomInt(2,6), "point_hurt");
			SetEntityRenderMode(target, RenderMode:3);
			SetEntityRenderColor(target, 0, 100, 170, 180);
			SetEntityMoveType(target, MOVETYPE_VPHYSICS);
			CreateTimer(5.0, Timer_UnFreeze, target, TIMER_FLAG_NO_MAPCHANGE);
			EmitSoundToAll("ambient/ambience/rainscapes/rain/debris_05.wav", target);
			PerformFade(target, 500, 250, 10, 1, {0, 50, 100, 150});
		}
	}
}
public SkillGravityClaw(target)
{
	if (target > 0)
	{
		if (IsClientInGame(target) && IsPlayerAlive(target) && GetClientTeam(target) == 2)
		{
			GravityClaw[target] = 1;
			CreateTimer(2.0, Timer_ResetGravity, target, TIMER_FLAG_NO_MAPCHANGE);
			PerformFade(target, 500, 250, 10, 1, {100, 50, 100, 150});
			ScreenShake(target, 5.0);
		}
	}
}
public Action:MeteorTankTimer(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 1002525)
	{
		new Float:Origin[3], Float:Angles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);
		new ent[5];
		for (new count=1; count<=4; count++)
		{
			ent[count] = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(ent[count]))
			{
				DispatchKeyValue(ent[count], "model", "models/props_debris/concrete_chunk01a.mdl");
				DispatchKeyValueVector(ent[count], "origin", Origin);
				DispatchKeyValueVector(ent[count], "angles", Angles);
				DispatchSpawn(ent[count]);
				AcceptEntityInput(ent[count], "DisableCollision");
				SetEntProp(ent[count], Prop_Send, "m_hOwnerEntity", client);

				SetVariantString("!activator");
				AcceptEntityInput(ent[count], "SetParent", client);
				switch(count)
				{
					case 1:SetVariantString("relbow");
					case 2:SetVariantString("lelbow");
					case 3:SetVariantString("rshoulder");
					case 4:SetVariantString("lshoulder");
				}
				AcceptEntityInput(ent[count], "SetParentAttachment");
				switch(count)
				{
					case 1,2:SetEntPropFloat(ent[count], Prop_Data, "m_flModelScale", 0.4);
					case 3,4:SetEntPropFloat(ent[count], Prop_Data, "m_flModelScale", 0.5);
				}
				Angles[0] = Angles[0] + GetRandomFloat(-90.0, 90.0);
				Angles[1] = Angles[1] + GetRandomFloat(-90.0, 90.0);
				Angles[2] = Angles[2] + GetRandomFloat(-90.0, 90.0);
				TeleportEntity(ent[count], NULL_VECTOR, Angles, NULL_VECTOR);
			}
		}
	}
}
public Action:TechTankTimer(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 7595105)
	{
		new Float:Origin[3], Float:Angles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);
		for (new count=0; count<=1; count++)
		{
			new entity = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(entity))
			{
				DispatchKeyValue(entity, "model", MODEL_M60);
				DispatchSpawn(entity);
				TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
				AcceptEntityInput(entity, "DisableCollision");
				SetEntProp(entity, Prop_Send, "m_hOwnerEntity", client);
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.5);

				SetVariantString("!activator");
				AcceptEntityInput(entity, "SetParent", client);

				//switch(count)
				//{
				//	case 0:SetVariantString("rshoulder");
				//	case 1:SetVariantString("lshoulder");
				//}
				//AcceptEntityInput(entity, "SetParentAttachment");

				new Float:TOrigin[3], Float:TAngles[3];
				switch(count)
				{
					case 0:
					{
						TOrigin[1] = 7.0;
						TOrigin[2] = 68.0;
						TAngles[0] = 5.0;
						TAngles[1] = -15.0;
					}
					case 1:
					{
						TOrigin[0] = -10.0;
						TOrigin[1] = -14.0;
						TOrigin[2] = 68.0;
						TAngles[0] = 5.0;
						TAngles[1] = 330.0; //330?
					}
				}
				TeleportEntity(entity, TOrigin, TAngles, NULL_VECTOR);
				TechTankGun[client][count] = entity;
			}
		}
	}
}
public Action:JumperTankTimer(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 2002550)
	{
		new Float:Origin[3], Float:Angles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);
		Angles[0] += 90.0;
		new ent[3];
		for (new count=1; count<=2; count++)
		{
			ent[count] = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(ent[count]))
			{
				DispatchKeyValue(ent[count], "model", "models/props_vehicles/tire001c_car.mdl");
				DispatchKeyValueVector(ent[count], "origin", Origin);
				DispatchKeyValueVector(ent[count], "angles", Angles);
				DispatchSpawn(ent[count]);
				AcceptEntityInput(ent[count], "DisableCollision");
				SetEntProp(ent[count], Prop_Send, "m_hOwnerEntity", client);

				SetVariantString("!activator");
				AcceptEntityInput(ent[count], "SetParent", client);
				switch(count)
				{
					case 1:SetVariantString("rfoot");
					case 2:SetVariantString("lfoot");
				}
				AcceptEntityInput(ent[count], "SetParentAttachment");

				TeleportEntity(ent[count], NULL_VECTOR, Angles, NULL_VECTOR);
			}
		}
	}
}
public Action:GravityTankTimer(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 333435)
	{
		new Float:Origin[3], Float:Angles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);
		Angles[0] += -90.0;
		new entity = CreateEntityByName("beam_spotlight");
		if (IsValidEntity(entity))
		{
			DispatchKeyValueVector(entity, "origin", Origin);
			DispatchKeyValueVector(entity, "angles", Angles);
			DispatchKeyValue(entity, "spotlightwidth", "10");
			DispatchKeyValue(entity, "spotlightlength", "60");
			DispatchKeyValue(entity, "spawnflags", "3");
			DispatchKeyValue(entity, "rendercolor", "100 100 100");
			DispatchKeyValue(entity, "renderamt", "125");
			DispatchKeyValue(entity, "maxspeed", "100");
			DispatchKeyValue(entity, "HDRColorScale", "0.7");
			DispatchKeyValue(entity, "fadescale", "1");
			DispatchKeyValue(entity, "fademindist", "-1");
			DispatchSpawn(entity);
			AcceptEntityInput(entity, "Enable");
			AcceptEntityInput(entity, "DisableCollision");

			SetEntProp(entity, Prop_Send, "m_hOwnerEntity", client);

			SetVariantString("!activator");
			AcceptEntityInput(entity, "SetParent", client);
			SetVariantString("mouth");
			AcceptEntityInput(entity, "SetParentAttachment");

			TeleportEntity(entity, NULL_VECTOR, Angles, NULL_VECTOR);
		}
		new blackhole = CreateEntityByName("point_push");
		if (IsValidEntity(blackhole))
		{
			DispatchKeyValueVector(blackhole, "origin", Origin);
			DispatchKeyValueVector(blackhole, "angles", Angles);
			DispatchKeyValue(blackhole, "radius", "750");
			DispatchKeyValue(blackhole, "magnitude", "-50");
			DispatchKeyValue(blackhole, "spawnflags", "8");
			DispatchSpawn(blackhole);
			AcceptEntityInput(blackhole, "Enable");

			SetEntProp(blackhole, Prop_Send, "m_glowColorOverride", client);

			SetVariantString("!activator");
			AcceptEntityInput(blackhole, "SetParent", client);
		}
	}
}
stock FireTankAbility(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 12800)
	{
		decl Float:Origin[3];
		GetClientAbsOrigin(client, Origin);
		GasCanExplode(client, Origin);
	}
}
stock IceTankAbility(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 0100170)
	{
		new count = CountSurvInRange(client, 300);

		SetEntProp(client, Prop_Send, "m_glowColorOverride", 0);
		SetEntProp(client, Prop_Send, "m_iGlowType", 0);

		if (count >= 3)
		{
			new random = GetRandomInt(1,6);
			if (random == 1)
			{
				new glowcolor = RGB_TO_INT(30, 130, 230);
				SetEntProp(client, Prop_Send, "m_glowColorOverride", glowcolor);
				SetEntProp(client, Prop_Send, "m_iGlowType", 3);
				for (new j=1; j<=MaxClients; j++)
				{
					if (SurvInRange(client, j, 300))
					{
						SkillIceClaw(j, client);
					}
				}
			}
		}
	}
}
stock JumperTankAbility(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 2002550)
	{
		new flags = GetEntityFlags(client);
		if (flags & FL_ONGROUND)
		{
			new random = GetRandomInt(1,3);
			if (random == 1)
			{
				if (GetNearestSurvivorDist(client) > 200 && GetNearestSurvivorDist(client) < 2000)
				{
					FakeJump(client);
				}
			}
		}
	}
}
stock SpitterTankAbility(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 12115128)
	{
		new Float:Origin[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
		Origin[2] += 10.0;

		new ent = CreateEntityByName("spitter_projectile");
		if (IsValidEntity(ent))
		{
			DispatchSpawn(ent);
			SetEntPropFloat(ent, Prop_Send, "m_DmgRadius", 1024.0);
			SetEntProp(ent, Prop_Send, "m_bIsLive", 1 );
			SetEntPropEnt(ent, Prop_Send, "m_hThrower", client);
			TeleportEntity(ent, Origin, NULL_VECTOR, NULL_VECTOR);
			L4D2_SpitBurst(ent);
		}
	}
}
stock HulkTankAbility(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 100255200)
	{
		if (TankAbilityTimer[client] <= 0)
		{
			new count = CountSurvInRange(client, 300);

			if (count >= 3)
			{
				new glowcolor = RGB_TO_INT(0, 255, 0);
				SetEntProp(client, Prop_Send, "m_glowColorOverride", glowcolor);
				SetEntProp(client, Prop_Send, "m_iGlowType", 3);
				SetEntProp(client, Prop_Send, "m_bFlashing", 1);
			}
			else
			{
				SetEntProp(client, Prop_Send, "m_glowColorOverride", 0);
				SetEntProp(client, Prop_Send, "m_iGlowType", 0);
				SetEntProp(client, Prop_Send, "m_bFlashing", 0);
			}
		}
		else
		{
			SetEntProp(client, Prop_Send, "m_glowColorOverride", 0);
			SetEntProp(client, Prop_Send, "m_iGlowType", 0);
			SetEntProp(client, Prop_Send, "m_bFlashing", 0);
		}
	}
}
stock GhostTankAbility(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 100100100)
	{
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsSurvivor(i) && IsPlayerAlive(i))
			{
				if (SurvInRange(client, i, 300))
				{
					new random = GetRandomInt(1,8);
					if (random == 1)
					{
						if (ForceWeaponDrop(i))
						{
							PrintToChat(i, "Something disarmed you...");
							EmitSoundToAll("npc/infected/action/die/male/death_43.wav", i);
						}
						return;
					}
				}
			}
		}
	}
}
stock ShockTankAbility(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 100165255)
	{
		new count = CountSurvInRange(client, 400);

		for (new i=1; i<=MaxClients; i++)
		{
			if (IsSurvivor(i) && IsPlayerAlive(i))
			{
				if (SurvInRange(client, i, 400))
				{
					ShockBolt(client, i, count);
				}
			}
		}
	}
}
stock WitchTankAbility(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 255200255)
	{
		new random = GetRandomInt(1,3);
		if (random == 1)
		{
			new Float:Origin[3], Float:Angles[3];
			GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
			GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);

			for (new i=1; i<=MaxClients; i++)
			{
				if (SurvInRange(client, i, 400))
				{
					new witch = CreateEntityByName("witch");
					DispatchSpawn(witch);
					ActivateEntity(witch);
					TeleportEntity(witch, Origin, Angles, NULL_VECTOR);

					//DealDamageEntity(witch, i, 2, 1, "point_hurt");
					//SetEntProp(witch, Prop_Send, "m_hOwnerEntity", 255200255);	

					new Handle:Pack = CreateDataPack();
					WritePackCell(Pack, witch);
					WritePackCell(Pack, i);
					CreateTimer(0.1, AngerWitch, Pack, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}
stock TechTankAbility(client)
{
	new Float:Origin[3], Float:TOrigin[3], Float:distance = 0.0, Float:storeddist = 0.0, target = 0, sectarget = 0;
	GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSurvivor(i) && IsPlayerAlive(i))
		{
			GetEntPropVector(i, Prop_Send, "m_vecOrigin", TOrigin);
                       	distance = GetVectorDistance(Origin, TOrigin);
			if (storeddist == 0.0 || storeddist > distance)
			{
				if (InLineOfSight(client, i, Origin, TOrigin))
				{
					storeddist = distance;
					target = i;
				}
			}
		}
	}
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSurvivor(i) && IsPlayerAlive(i) && target != i)
		{
			GetEntPropVector(i, Prop_Send, "m_vecOrigin", TOrigin);
                       	distance = GetVectorDistance(Origin, TOrigin);
			if (storeddist == 0.0 || storeddist > distance)
			{
				if (InLineOfSight(client, i, Origin, TOrigin))
				{
					storeddist = distance;
					sectarget = i;
				}
			}
		}
	}
	if (target > 0)
	{
		FireTechTankGun(client, target, 0);
	}
	if (sectarget == 0)
	{
		FireTechTankGun(client, target, 1);
	}
	else
	{
		FireTechTankGun(client, sectarget, 1);
	}
}
stock FireTechTankGun(client, target, gun)
{
	new entity = TechTankGun[client][gun];
	if (entity > 0 && IsValidEntity(entity))
	{
		if (IsSurvivor(target) && IsPlayerAlive(target))
		{
			new Float:Origin[3], Float:TOrigin[3], Float:Angles[3];
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", Origin);
			Origin[2] += 35.0;
			if (IsTank(client))
			{
				GetEntPropVector(client, Prop_Send, "m_vecOrigin", TOrigin);
				TOrigin[2] += 68.0;

				decl Float:enemyDir[3]; 
				decl Float:newGunAngle[3];
				decl Float:targetAngle[3];

				SubtractVectors(Origin, TOrigin, enemyDir);
				NormalizeVector(enemyDir, enemyDir);	 
	 			GetVectorAngles(enemyDir, targetAngle);

				new Float:diff0 = AngleDiff(targetAngle[0], Angles[0]);
				new Float:diff1 = AngleDiff(targetAngle[1], Angles[1]);

				new Float:turn0 = 45.0*Sign(diff0)*1.0;
				new Float:turn1 = 180.0*Sign(diff1)*1.0;

				if (FloatAbs(turn0) >= FloatAbs(diff0))
				{
					turn0 = diff0;
				}
				if (FloatAbs(turn1) >= FloatAbs(diff1))
				{
					turn1 = diff1;
				}
				newGunAngle[0] = Angles[0] + turn0;
				newGunAngle[1] = Angles[1] + turn1;
				newGunAngle[2] = 0.0;

				DispatchKeyValueVector(entity, "Angles", newGunAngle);

				ShowMuzzleFlash(entity, PARTICLE_RIFLE_FLASH);
				AttachParticle(target, PARTICLE_BLOOD, 0.1, 0.0, 0.0, 30.0);
				CreateTracerParticles(entity, target);
				EmitSoundToAll(SOUND_M60_FIRE, client);
				DealDamagePlayer(target, client, 2, 1, "point_hurt");
			}
		}
	}
}
public Action:TechTankAbilityTimer(Handle:timer, any:client)
{
	TechTankAbility(client);
}
public Action:AngerWitch(Handle:timer, any:Pack)
{
	ResetPack(Pack, false);
	new entity = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	CloseHandle(Pack);

	if (IsWitch(entity) && IsSurvivor(client) && IsPlayerAlive(client))
	{
		DealDamageEntity(entity, client, 2, 1, "point_hurt");
		SetEntProp(entity, Prop_Send, "m_hOwnerEntity", 255200255);	
	}
}
stock HealTank(client, damage)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 100255200)
	{
		if (damage > 0)
		{
			new health = GetEntProp(client, Prop_Send, "m_iHealth");
			new maxhealth = GetConVarInt(FindConVar("z_tank_health"));
			if (health <= (maxhealth - damage) && health > 500)
			{
				SetEntProp(client, Prop_Data, "m_iHealth", health + damage);
			}
			else if (health > 500)
			{
				SetEntProp(client, Prop_Data, "m_iHealth", maxhealth);
			}
		}
	}
}
stock ShockBolt(client, target, damage)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 100165255)
	{
		if (IsSurvivor(target))
		{
			decl String:name[32];
			decl Float:Origin[3], Float:TOrigin[3];
			GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
			Origin[2] += 30.0;
			TOrigin[2] += 30.0;
			new endpoint = CreateEntityByName("info_particle_target");
			if (endpoint > 0 && IsValidEntity(endpoint))
			{
				Format(name, sizeof(name), "bolttarget%i", endpoint);
				DispatchKeyValue(endpoint, "targetname", name);	
				DispatchKeyValueVector(endpoint, "origin", TOrigin);
				DispatchSpawn(endpoint);
				ActivateEntity(endpoint);
				SetVariantString("OnUser1 !self:Kill::0.8:-1");
				AcceptEntityInput(endpoint, "AddOutput");
				AcceptEntityInput(endpoint, "FireUser1");
			}
			new particle = CreateEntityByName("info_particle_system");
			if (particle > 0 && IsValidEntity(particle))
			{
				DispatchKeyValue(particle, "effect_name", PARTICLE_LS_BOLT);
				DispatchKeyValue(particle, "cpoint1", name);
				DispatchKeyValueVector(particle, "origin", Origin);
				DispatchSpawn(particle);
				ActivateEntity(particle);
				SetVariantString("!activator");
				AcceptEntityInput(particle, "SetParent", client);
				AcceptEntityInput(particle, "start");
				SetVariantString("OnUser1 !self:Kill::0.8:-1");
				AcceptEntityInput(particle, "AddOutput");
				AcceptEntityInput(particle, "FireUser1");
			}
			if (damage > 4)
			{
				damage = 4;
			}
			DealDamagePlayer(target, client, 128, damage, "point_hurt");
			if (damage >= 3)
			{
				new random = GetRandomInt(1,5);
				switch(random)
				{
					case 1: EmitSoundToAll("ambient/energy/zap5.wav", target);
					case 2: EmitSoundToAll("ambient/energy/zap6.wav", target);
					case 3: EmitSoundToAll("ambient/energy/zap7.wav", target);
					case 4: EmitSoundToAll("ambient/energy/zap8.wav", target);
					case 5: EmitSoundToAll("ambient/energy/zap9.wav", target);
				}
			}	
		}
	}
}
public Action:DemonTankTimer(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 255150100)
	{
		new Float:Origin[3], Float:Angles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);
		Angles[0] += -90.0;
		SetEntityModel(client, MODEL_TANK_DLC3);

   		new particle = CreateEntityByName("info_particle_system");
    		if (IsValidEntity(particle))
    		{
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchKeyValueVector(particle, "angles", Angles);
			DispatchKeyValue(particle, "effect_name", PARTICLE_FLARE);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			AcceptEntityInput(particle, "start");

			SetEntProp(particle, Prop_Send, "m_hOwnerEntity", client);

			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", client);
			SetVariantString("mouth");
			AcceptEntityInput(particle, "SetParentAttachment");

			new Float:TOrigin[3] = {-0.5, 3.0, -2.0};
			TeleportEntity(particle, TOrigin, NULL_VECTOR, NULL_VECTOR);
		}
   		particle = CreateEntityByName("info_particle_system");
    		if (IsValidEntity(particle))
    		{
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchKeyValueVector(particle, "angles", Angles);
			DispatchKeyValue(particle, "effect_name", PARTICLE_FLARE);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			AcceptEntityInput(particle, "start");

			SetEntProp(particle, Prop_Send, "m_hOwnerEntity", client);

			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", client);
			SetVariantString("mouth");
			AcceptEntityInput(particle, "SetParentAttachment");

			new Float:TOrigin[3] = {-0.5, 3.0, 2.0};
			TeleportEntity(particle, TOrigin, NULL_VECTOR, NULL_VECTOR);
		}
/*
   		particle = CreateEntityByName("info_particle_system");
    		if (IsValidEntity(particle))
    		{
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchKeyValueVector(particle, "angles", Angles);
			DispatchKeyValue(particle, "effect_name", PARTICLE_DEMON_HEAT);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			AcceptEntityInput(particle, "start");

			SetEntProp(particle, Prop_Send, "m_hOwnerEntity", client);

			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", client);

			new Float:TOrigin[3] = {0.0, 0.0, 35.0};
			TeleportEntity(particle, TOrigin, NULL_VECTOR, NULL_VECTOR);
		}
*/
		new blackhole = CreateEntityByName("point_push");
		if (IsValidEntity(blackhole))
		{
			DispatchKeyValueVector(blackhole, "origin", Origin);
			DispatchKeyValueVector(blackhole, "angles", Angles);
			DispatchKeyValue(blackhole, "radius", "400");
			DispatchKeyValue(blackhole, "magnitude", "-20");
			DispatchKeyValue(blackhole, "spawnflags", "8");
			DispatchSpawn(blackhole);
			AcceptEntityInput(blackhole, "Enable");

			SetEntProp(blackhole, Prop_Send, "m_glowColorOverride", client);

			SetVariantString("!activator");
			AcceptEntityInput(blackhole, "SetParent", client);
		}
	}
}
stock DemonTankLevelUp(client)
{
	if (IsTank(client))
	{
		new health = GetEntProp(client, Prop_Send, "m_iHealth");
		new maxhealth = GetConVarInt(FindConVar("z_tank_health"));
		if ((health + 5000) < maxhealth)
		{
			SetEntProp(client, Prop_Data, "m_iHealth", health + 5000);
		}
		else
		{
			SetEntProp(client, Prop_Data, "m_iHealth", GetConVarInt(FindConVar("z_tank_health")));
		}
		new level = TankAbility[client];
		switch(level)
		{
			case 1:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.05);	
			}
			case 2:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.1);
			}
			case 3:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.15);
			}
			case 4:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.2);
			}
			case 5:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.25);
			}
			case 6:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.3);
			}
			case 7:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.35);
			}
			case 8:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.4);
			}
			case 9:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.45);
			}
			case 10:
			{
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.5);
			}
		}
		//PrintToChatAll("Tank: %i, Is Level: %i", client, level);
	}
}
public SkillSmashClaw(target)
{
	new health = GetEntProp(target, Prop_Data, "m_iHealth");
	if (health > 1 && !IsPlayerIncap(target))
	{
		new Float:time = GetGameTime();
		SetEntProp(target, Prop_Data, "m_iHealth", 1);
		SetEntPropFloat(target, Prop_Send, "m_healthBuffer", float(health));
		SetEntPropFloat(target, Prop_Send, "m_healthBufferTime", time);
	}
	EmitSoundToAll("player/charger/hit/charger_smash_02.wav", target);
	PerformFade(target, 800, 300, 10, 1, {10, 0, 0, 250});
	ScreenShake(target, 30.0);
}
public SkillSmashClawKill(client, attacker)
{
	EmitSoundToAll("player/tank/voice/growl/tank_climb_01.wav", attacker);
	AttachParticle(client, PARTICLE_EXPLODE, 0.1, 0.0, 0.0, 0.0);
	new random = GetRandomInt(1,3);
	switch(random)
	{
		case 1: EmitSoundToAll("player/boomer/explode/explo_medium_09.wav", client);
		case 2: EmitSoundToAll("player/boomer/explode/explo_medium_10.wav", client);
		case 3: EmitSoundToAll("player/boomer/explode/explo_medium_14.wav", client);
	}
	DealDamagePlayer(client, attacker, 128, 600, "point_hurt");
	DealDamagePlayer(client, attacker, 128, 600, "point_hurt");
	CreateTimer(0.1, RemoveDeathBody, client, TIMER_FLAG_NO_MAPCHANGE);
}
public Action:RemoveDeathBody(Handle:timer, any:client)
{
	if (client > 0)
	{
		if (IsClientInGame(client) && GetClientTeam(client) == 2)
		{
			new entity = -1;
			while ((entity = FindEntityByClassname(entity, "survivor_death_model")) != INVALID_ENT_REFERENCE)
			{
				new owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
				if (client == owner)
				{
					AcceptEntityInput(entity, "Kill");
				}
			}
		}
	}
}
public SkillElecClaw(target, tank)
{
	if (target > 0)
	{
		if (IsClientInGame(target) && IsPlayerAlive(target) && GetClientTeam(target) == 2)
		{
			ReduceSpeed75[target] += 3;
			new Handle:Pack = CreateDataPack();
			WritePackCell(Pack, iRound);
			WritePackCell(Pack, target);
			WritePackCell(Pack, tank);
			WritePackCell(Pack, 4);
			CreateTimer(5.0, Timer_Volt, Pack);

			PerformFade(target, 250, 100, 10, 1, {50, 150, 250, 100});
			ScreenShake(target, 15.0);
			AttachParticle(target, PARTICLE_ELEC, 2.0, 0.0, 0.0, 30.0);
	
			new random = GetRandomInt(1,2);
			switch(random)
			{
				case 1: EmitSoundToAll("ambient/energy/spark5.wav", target);
				case 2: EmitSoundToAll("ambient/energy/spark6.wav", target);
			}
		}
	}
}
public Action:Timer_Volt(Handle:timer, any:Pack)
{
	ResetPack(Pack, false);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new tank = ReadPackCell(Pack);
	new amount = ReadPackCell(Pack);
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (client > 0)
	{
		if (IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2 && ReduceSpeed75[client] == 0 && IsTank(tank))
		{
			if (amount > 0)
			{
				ReduceSpeed75[client] += 2;
				ScreenShake(client, 2.0);
				DealDamagePlayer(client, tank, 128, 12, "point_hurt");
				AttachParticle(client, PARTICLE_ELEC, 2.0, 0.0, 0.0, 30.0);
				new random = GetRandomInt(1,2);
				switch(random)
				{
					case 1: EmitSoundToAll("ambient/energy/spark5.wav", client);
					case 2: EmitSoundToAll("ambient/energy/spark6.wav", client);
				}
				new Handle:NewPack = CreateDataPack();
				WritePackCell(NewPack, iRound);
				WritePackCell(NewPack, client);
				WritePackCell(NewPack, tank);
				WritePackCell(NewPack, amount - 1);
				CreateTimer(5.0, Timer_Volt, NewPack);
			}
		}
	}
}
public Action:Timer_UnFreeze(Handle:timer, any:client)
{
	if (client > 0)
	{
		if (IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
		{
			SetEntityRenderMode(client, RenderMode:3);
			if (SoulShieldOn[client] == 1)
			{
      	 			SetEntityRenderColor(client, 255, 215, 0, 255);
			}
			else if (NightCrawlerOn[client] == 1)
			{
      	 			SetEntityRenderColor(client, 0, 0, 255, 255);
			}
			else
			{
				SetEntityRenderColor(client, 255, 255, 255, 255);
			}
			SetEntityMoveType(client, MOVETYPE_WALK);
		}
	}
}
public Action:Timer_ResetGravity(Handle:timer, any:client)
{
	if (client > 0)
	{
		if (IsClientInGame(client))
		{
			GravityClaw[client] = 0;
			//SetEntityGravity(client, 1.0);
		}
	}
}
public Action:Timer_AttachFIRE(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 12800)
	{
		AttachParticle(client, PARTICLE_FIRE, 0.8, 0.0, 0.0, 0.0);
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:Timer_AttachFIRE_Rock(Handle:timer, any:entity)
{
	if (IsValidEntity(entity))
	{
		decl String: classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "tank_rock", false))
		{
			IgniteEntity(entity, 100.0);
			return Plugin_Continue;
		}
	}
	return Plugin_Stop;
}
public Action:Timer_AttachICE(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 0100170)
	{
		AttachParticle(client, PARTICLE_SMOKE, 2.0, 0.0, 0.0, 30.0);
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:Timer_AttachSPIT(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 12115128)
	{
		AttachParticle(client, PARTICLE_SPIT, 2.0, 0.0, 0.0, 30.0);
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:Timer_SpitSound(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 12115128)
	{
		EmitSoundToAll("player/spitter/voice/warn/spitter_spit_02.wav", client);
	}
}
public Action:Timer_AttachSPIT_Rock(Handle:timer, any:entity)
{
	if (IsValidEntity(entity))
	{
		decl String: classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "tank_rock", false))
		{
			AttachParticle(entity, PARTICLE_SPITPROJ, 0.8, 0.0, 0.0, 0.0);
			return Plugin_Continue;
		}
	}
	return Plugin_Stop;
}
public Action:Timer_AttachELEC(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 100165255)
	{
		AttachParticle(client, PARTICLE_ELEC, 0.8, 0.0, 0.0, 30.0);
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:Timer_AttachELEC_Rock(Handle:timer, any:entity)
{
	if (IsValidEntity(entity))
	{
		decl String: classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "tank_rock", false))
		{
			AttachParticle(entity, PARTICLE_ELEC, 0.8, 0.0, 0.0, 0.0);
			return Plugin_Continue;
		}
	}
	return Plugin_Stop;
}
public Action:Timer_AttachBLOOD(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 255200255)
	{
		AttachParticle(client, PARTICLE_BLOOD_EXPLODE, 0.8, 0.0, 0.0, 30.0);
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:Timer_AttachMETEOR(Handle:timer, any:client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 1002525)
	{
		AttachParticle(client, PARTICLE_METEOR, 6.0, 0.0, 0.0, 30.0);
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:ActivateShieldTimer(Handle:timer, any:client)
{
	ActivateShield(client);
}
stock ActivateShield(client)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 135205255 && ShieldsUp[client] == 0)
	{
		decl Float:Origin[3];
		GetClientAbsOrigin(client, Origin);
		Origin[2] -= 120.0;
		new entity = CreateEntityByName("prop_dynamic_override");
		if (IsValidEntity(entity))
		{
			DispatchKeyValue(entity, "model", "models/props_unique/airport/atlas_break_ball.mdl");
			DispatchKeyValueVector(entity, "origin", Origin);
			DispatchSpawn(entity);

			SetEntityRenderMode(entity, RenderMode:3);
      	 		SetEntityRenderColor(entity, 25, 125, 125, 50);
			AcceptEntityInput(entity, "DisableCollision");
			AcceptEntityInput(entity, "DisableShadow");
			SetEntProp(entity, Prop_Data, "m_iEFlags", 0);
			SetEntProp(entity, Prop_Send, "m_hOwnerEntity", client);

			SetVariantString("!activator");
			AcceptEntityInput(entity, "SetParent", client);
		}
		ShieldsUp[client] = 1;
	}
}
stock DeactivateShield(client, Float:time)
{
	if (IsTank(client) && GetEntityRenderColor(client) == 135205255 && ShieldsUp[client] == 1)
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "prop_dynamic")) != INVALID_ENT_REFERENCE)
		{
			decl String:model[64];
            		GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_unique/airport/atlas_break_ball.mdl", false))
			{
				new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
				if (owner == client)
				{
					AcceptEntityInput(entity, "Kill");
				}
			}
		}
		CreateTimer(time, ActivateShieldTimer, client, TIMER_FLAG_NO_MAPCHANGE);
		ShieldsUp[client] = 0;
	}
}
stock KickAIBots()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSpecialInfected(i) && IsFakeClient(i))
		{
			if (CountInfectedAll() > 16)
			{
				KickClient(i);
			}
		}
	}
}
//=============================
//	HELPERS
//=============================
stock CountTotal()
{
	new count = 0;
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i))
		{
			count++;
		}
	}
	return count;
}
stock CountInGame()
{
	new count = 0;
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			count++;
		}
	}
	return count;
}
stock CountConnecting()
{
	new count = 0;
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientConnected(i) && !IsClientInGame(i) && !IsFakeClient(i))
		{
			count++;
		}
	}
	return count;
}
stock CountSurvivorsAll()
{
	new count = 0;
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == 2)
		{
			count++;
		}
	}
	return count;
}
stock CountHumanSurvivors()
{
	new count = 0;
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) == 2)
		{
			count++;
		}
	}
	return count;
}
stock CountBotSurvivors()
{
	new count = 0;
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && IsFakeClient(i) && GetClientTeam(i) == 2)
		{
			new String:classname[16];
			GetEntityNetClass(i, classname, sizeof(classname));
    			if (StrEqual(classname, "SurvivorBot", false))
			{
				count++;
			}
		}
	}
	return count;
}
stock CountSurvivorsAliveAll()
{
	new count = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
		{
			count++;
		}
	}
	return count;
}
stock CountIncapSurvivors()
{
	new count = 0;
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && IsPlayerAlive(i) && IsPlayerIncap(i) && GetClientTeam(i) == 2)
		{
			count++;
		}
	}
	return count;
}
stock CountDeadSurvivors()
{
	new count = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsPlayerAlive(i) && GetClientTeam(i) == 2)
		{
			count++;
		}
	}
	return count;
}
stock GetTotalLevelRating()
{
	new total;
	new rating;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == 2)
		{
			new level = cLevel[i];
			rating += level;
			total += 1;
		}
	}
	if (total > 0)
	{
		rating = rating / total;
	}
	return rating;
}
stock CountSI()
{
	new count = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSmoker(i) || IsBoomer(i) || IsHunter(i) || IsSpitter(i) || IsJockey(i) || IsCharger(i))
		{
			count++;
		}
	}
	return count;
}
stock CountTanks()
{
	iNumTanks = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsTank(i))
		{
			iNumTanks++;
		}
	}
}
stock CountBotHunters()
{
	new count = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsHunter(i) && IsFakeClient(i))
		{
			count++;
		}
	}
	return count;
}
stock CountHumanTanks()
{
	new count;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsTank(i) && !IsFakeClient(i))
		{
			count++;
		}
	}
	return count;
}
stock CountHumanInfected()
{
	new count = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) == 3)
		{
			count++;
		}
	}
	return count;
}
stock CountInfectedAll()
{
	new count = 0;
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == 3)
		{
			count++;
		}
	}
	return count;
}
stock bool:IsWorldFire(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String: classname[28];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "trigger_hurt", false) || StrEqual(classname, "env_fire", false) || StrEqual(classname, "prop_fuel_barrel", false)
		|| StrEqual(classname, "inferno", false) || StrEqual(classname, "entityflame", false) || StrEqual(classname, "prop_physics", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsInfected(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String: classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "infected", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsUncommon(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String: classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "infected", false))
		{
			decl String:model[64];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			{
				if (StrContains(model, "roadcrew", false) != -1 || StrContains(model, "ceda", false) != -1 || StrContains(model, "mud", false) != -1 || StrContains(model, "riot", false) != -1 || StrContains(model, "clown", false) != -1 || StrContains(model, "jimmy", false) != -1 || StrContains(model, "fallen", false) != -1)
				{
					return true;
				}	
			}
		}
	}
	return false;
}
stock bool:IsValidClient(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client))
	{
		return true;
	}
	return false;
}
stock bool:IsSurvivor(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2)
	{
		return true;
	}
	return false;
}
stock bool:IsSpectator(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 1)
	{
		return true;
	}
	return false;
}
stock bool:IsSpecialInfected(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Smoker", false) || StrEqual(classname, "Boomer", false) || StrEqual(classname, "Hunter", false) || StrEqual(classname, "Spitter", false) || StrEqual(classname, "Jockey", false) || StrEqual(classname, "Charger", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsSpecialInfectedClass(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Smoker", false) || StrEqual(classname, "Boomer", false) || StrEqual(classname, "Hunter", false) || StrEqual(classname, "Spitter", false) || StrEqual(classname, "Jockey", false) || StrEqual(classname, "Charger", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsSpecialInfectedDead(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Smoker", false) || StrEqual(classname, "Boomer", false) || StrEqual(classname, "Hunter", false) || StrEqual(classname, "Spitter", false) || StrEqual(classname, "Jockey", false) || StrEqual(classname, "Charger", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsSmoker(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Smoker", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsBoomer(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Boomer", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsHunter(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Hunter", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsSpitter(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Spitter", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsJockey(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Jockey", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsCharger(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Charger", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsWitch(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String: classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "witch", false))
			return true;
		return false;
	}
	return false;
}
stock bool:IsTank(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 3 && !IsPlayerIncap(client) && TankAlive[client] == 1)
	{
		decl String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
		if (StrEqual(classname, "Tank", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsInstaCapper(client)
{
	if (IsSpecialInfected(client))
	{
		new color = GetEntityGlowColor(client);
		if (color == 701200)
		{
			return true;
		}
	}
	return false;
}
stock bool:IsBreeder(client)
{
	if (IsSpecialInfected(client))
	{
		new color = GetEntityGlowColor(client);
		if (color == 0175175)
		{
			return true;
		}
	}
	return false;
}
stock bool:IsGasCan(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String: classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_gascan", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsMedKit(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String: classname[22];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_first_aid_kit", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:BotReserved(client)
{
	if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsFakeClient(client))
	{
		new String:classname[16];
		GetEntityNetClass(client, classname, sizeof(classname));
    		if (StrEqual(classname, "SurvivorBot", false))
		{
			new userid = GetEntProp(client, Prop_Send, "m_humanSpectatorUserID");
			if (userid > 0)
			{
				return true;
			}
		}
	}
	return false;
}
stock bool:IsPlayerBurning(client)
{
	new Float:IsBurning = GetEntPropFloat(client, Prop_Send, "m_burnPercent");
	if (IsBurning > 0) 
		return true;
	return false;
}
stock bool:IsPlayerGhost(client)
{
	if (GetEntProp(client, Prop_Send, "m_isGhost", 1)) return true;
	return false;
}
stock bool:IsPlayerIncap(client)
{
	if (GetEntProp(client, Prop_Send, "m_isIncapacitated", 1)) return true;
	return false;
}
stock bool:IsPlayerSpawned(client)
{
	if (PlayerSpawn[client] == 2)
	{
		return true;
	}
	return false;
}
stock bool:IsBlackWhite(client)
{
	if (GetEntProp(client, Prop_Send, "m_currentReviveCount", 2)) return true;
	return false;
}
stock bool:IsHanging(client)
{
	if (GetEntProp(client, Prop_Send, "m_isHangingFromLedge", 1)) return true;
	return false;
}
stock bool:IsPlayerPummel(client)
{
	new attacker = GetEntPropEnt(client, Prop_Send, "m_pummelAttacker");
	if (attacker > 0)
	{
		return true;
	}
	return false;
}
stock bool:IsCarryVictim(client)
{
	new attacker = GetEntPropEnt(client, Prop_Send, "m_carryAttacker");
	if (attacker > 0)
	{
		return true;
	}
	return false;
}
stock bool:IsPlayerHolding(client)
{
	new leapvictim = GetEntPropEnt(client, Prop_Send, "m_jockeyVictim");
	new pummelvictim = GetEntPropEnt(client, Prop_Send, "m_pummelVictim");
	new pouncevictim = GetEntPropEnt(client, Prop_Send, "m_pounceVictim");
	new tonguevictim = GetEntPropEnt(client, Prop_Send, "m_tongueVictim");
	if (leapvictim > 0 || pummelvictim > 0 || pouncevictim > 0 || tonguevictim > 0)
	{
		return true;
	}
	return false;
}
stock bool:IsPlayerHeld(client)
{
	new jockey = GetEntPropEnt(client, Prop_Send, "m_jockeyAttacker");
	new charger = GetEntPropEnt(client, Prop_Send, "m_pummelAttacker");
	new hunter = GetEntPropEnt(client, Prop_Send, "m_pounceAttacker");
	new smoker = GetEntPropEnt(client, Prop_Send, "m_tongueOwner");
	if (jockey > 0 || charger > 0 || hunter > 0 || smoker > 0)
	{
		return true;
	}
	return false;
}
stock Pick()
{
    	new count, clients[MaxClients];
    	for (new i=1; i<=MaxClients; i++)
    	{
        	if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
            		clients[count++] = i; 
    	}
    	return clients[GetRandomInt(0,count-1)];
}
stock PickNotInSR()
{
    	new count, clients[MaxClients];
    	for (new i=1; i<=MaxClients; i++)
    	{
        	if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && !IsPlayerInSaferoom(i, 0) && WaitRescue[i] == 0)
            		clients[count++] = i; 
    	}
    	return clients[GetRandomInt(0,count-1)];
}
stock PickAnyOther(client)
{
    	new count, clients[MaxClients];
    	for (new i=1; i<=MaxClients; i++)
    	{
        	if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && i != client)
            		clients[count++] = i; 
    	}
    	return clients[GetRandomInt(0,count-1)];
}
stock PickAnyOtherDist(client)
{
	if (iSRDoor > 0 && IsValidEntity(iSRDoor))
	{
		new target = 0, Float:distance = 0.0;
		decl Float:Origin[3], Float:TOrigin[3];
		GetEntPropVector(iSRDoor, Prop_Send, "m_vecOrigin", Origin);
    		for (new i=1; i<=MaxClients; i++)
    		{
        		if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && i != client)
			{
				GetEntPropVector(i, Prop_Send, "m_vecOrigin", TOrigin);		
				new Float:Tdistance = GetVectorDistance(Origin, TOrigin);
				if (Tdistance < distance || distance == 0.0)
				{
					distance = Tdistance;
            				target = i;
				}
			}
    		}
		//PrintToChat(client, "Second Chance chose player %N", target);
    		return target;
	}
	else
	{
		//PrintToChat(client, "Second Chance picking random player %N", PickAnyOther(client));
		return PickAnyOther(client);
	}
}
stock PickDeadSurvivor()
{
    	new count, clients[MaxClients];
    	for (new i=1; i<=MaxClients; i++)
    	{
        	if (IsClientInGame(i) && !IsPlayerAlive(i) && GetClientTeam(i) == 2)
            		clients[count++] = i; 
    	}
    	return clients[GetRandomInt(0,count-1)];
}
stock GetAnyClient()
{
    	new count, clients[MaxClients];
    	for (new i=1; i<= MaxClients; i++)
    	{
       	 	if (IsClientInGame(i) && !IsFakeClient(i))
		{
			clients[count++] = i;
		}
   	}
    	return clients[GetRandomInt(0,count-1)];
}
stock CheckZombieHold(client)
{
	new Target[4];
	if (IsSpecialInfected(client))
	{
		Target[0] = GetEntPropEnt(client, Prop_Send, "m_jockeyVictim");
		Target[1] = GetEntPropEnt(client, Prop_Send, "m_pummelVictim");
		Target[2] = GetEntPropEnt(client, Prop_Send, "m_pounceVictim");
		Target[3] = GetEntPropEnt(client, Prop_Send, "m_tongueVictim");
		if (IsSurvivor(Target[0]))
		{
			if (GetEntPropEnt(Target[0], Prop_Send, "m_jockeyAttacker") == client)
			{
				return Target[0];
			}
		}
		else if (IsSurvivor(Target[1]))
		{
			if (GetEntPropEnt(Target[1], Prop_Send, "m_pummelAttacker") == client)
			{
				return Target[1];
			}
		}
		else if (IsSurvivor(Target[2]))
		{
			if (GetEntPropEnt(Target[2], Prop_Send, "m_pounceAttacker") == client)
			{
				return Target[2];
			}
		}
		else if (IsSurvivor(Target[3]))
		{
			if (GetEntPropEnt(Target[3], Prop_Send, "m_tongueOwner") == client)
			{
				return Target[3];
			}
		}
	}
	else if (IsSurvivor(client))
	{
		Target[0] = GetEntPropEnt(client, Prop_Send, "m_jockeyAttacker");
		Target[1] = GetEntPropEnt(client, Prop_Send, "m_pummelAttacker");
		Target[2] = GetEntPropEnt(client, Prop_Send, "m_pounceAttacker");
		Target[3] = GetEntPropEnt(client, Prop_Send, "m_tongueOwner");
		if (IsSpecialInfected(Target[0]))
		{
			if (GetEntPropEnt(Target[0], Prop_Send, "m_jockeyVictim") == client)
			{
				return Target[0];
			}
		}
		else if (IsSpecialInfected(Target[1]))
		{
			if (GetEntPropEnt(Target[1], Prop_Send, "m_pummelVictim") == client)
			{
				return Target[1];
			}
		}
		else if (IsSpecialInfected(Target[2]))
		{
			if (GetEntPropEnt(Target[2], Prop_Send, "m_pounceVictim") == client)
			{
				return Target[2];
			}
		}
		else if (IsSpecialInfected(Target[3]))
		{
			if (GetEntPropEnt(Target[3], Prop_Send, "m_tongueVictim") == client)
			{
				return Target[3];
			}
		}
	}
	return 0;
}
stock GetZombieClass(client)
{
	new class = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_zombieClass"));
	return class;
}
stock CountGasCans()
{
	new count;
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "weapon_gascan")) != INVALID_ENT_REFERENCE)
	{
		count++;
	}
	while ((entity = FindEntityByClassname(entity, "prop_physics")) != INVALID_ENT_REFERENCE)
	{
		decl String:model[48];
		GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
		if (StrEqual(model, MODEL_GASCAN, false))
		{
			count++;
		}
	}
	//PrintToChatAll("totalgascans:%i", count);
	return count;
}
//=============================
// 	AUTO DIFFICULTY
//=============================
public Action:AutoDiffTimer(Handle:timer, any:client)
{
	if (!bHell && !bBloodmoon && !bInferno && !bCowLevel && !bNightmare)
	{
		new AD_mob_spawn_min_interval;
		new AD_mob_spawn_max_interval;
		new AD_special_spawn_delay_min;
		new AD_special_spawn_delay_max;
		new AD_special_spawn_amount;
		new AD_tank_burn_duration;
		new AD_tank_health;
		new AD_common_limit;
		new AD_reserved_wanderers;
		new AD_relax_max_flow_travel;
		new AD_mob_spawn_min_size;
		new AD_mob_spawn_max_size;
		new AD_mob_spawn_finale_size;
		new AD_mega_mob_size;
		new AD_mega_mob_spawn_min;
		new AD_mega_mob_spawn_max;
		new Float:AD_mob_population_density;
		new Float:AD_wandering_density;
		new AD_smoker_health;
		new AD_boomer_health;
		new AD_hunter_health;
		new AD_spitter_health;
		new AD_jockey_health;
		new AD_charger_health;
		new AD_witch_health;
		new AD_zombie_health;
		new Float:AD_witch_anger_rate;
		new AD_witch_personal_space;
		new AD_witch_burn_time;

		switch(iDifficulty)
		{
			case 1:
			{
				AD_mob_spawn_min_interval = 90;
				AD_mob_spawn_max_interval = 180;
				AD_special_spawn_delay_min = 18;
				AD_special_spawn_delay_max = 20;
				AD_special_spawn_amount = 6;
				AD_tank_burn_duration = 75;
				AD_tank_health = 5000;
				AD_common_limit = 30;
				AD_reserved_wanderers = 12;
				AD_relax_max_flow_travel = 2500;
				AD_mob_spawn_min_size = 20;
				AD_mob_spawn_max_size = 30;
				AD_mob_spawn_finale_size = 30;
				AD_mega_mob_size = 30;
				AD_mega_mob_spawn_min = 400;
				AD_mega_mob_spawn_max = 850;
				AD_mob_population_density = 0.0072;
				AD_wandering_density = 0.04;
				AD_smoker_health = 250;
				AD_boomer_health = 350;
				AD_hunter_health = 250;
				AD_spitter_health = 250;
				AD_jockey_health = 300;
				AD_charger_health = 600;
				AD_witch_health = 100;
				AD_zombie_health = 30;
				AD_witch_anger_rate = 0.4;
				AD_witch_personal_space = 120;
				AD_witch_burn_time = 20;
			}
			case 2:
			{
				AD_mob_spawn_min_interval = 70;
				AD_mob_spawn_max_interval = 160;
				AD_special_spawn_delay_min = 16;
				AD_special_spawn_delay_max = 18;
				AD_special_spawn_amount = 8;
				AD_tank_burn_duration = 90;
				AD_tank_health = 10000;
				AD_common_limit = 45;
				AD_reserved_wanderers = 18;
				AD_relax_max_flow_travel = 2000;
				AD_mob_spawn_min_size = 30;
				AD_mob_spawn_max_size = 45;
				AD_mob_spawn_finale_size = 45;
				AD_mega_mob_size = 45;
				AD_mega_mob_spawn_min = 350;
				AD_mega_mob_spawn_max = 800;
				AD_mob_population_density = 0.0080;
				AD_wandering_density = 0.06;
				AD_smoker_health = 300;
				AD_boomer_health = 400;
				AD_hunter_health = 300;
				AD_spitter_health = 300;
				AD_jockey_health = 350;
				AD_charger_health = 650;
				AD_witch_health = 200;
				AD_zombie_health = 50;
				AD_witch_anger_rate = 0.6;
				AD_witch_personal_space = 140;
				AD_witch_burn_time = 25;
			}
			case 3:
			{
				AD_mob_spawn_min_interval = 50;
				AD_mob_spawn_max_interval = 140;
				AD_special_spawn_delay_min = 14;
				AD_special_spawn_delay_max = 16;
				AD_special_spawn_amount = 10;
				AD_tank_burn_duration = 105;
				AD_tank_health = 15000;
				AD_common_limit = 60;
				AD_reserved_wanderers = 25;
				AD_relax_max_flow_travel = 1500;
				AD_mob_spawn_min_size = 40;
				AD_mob_spawn_max_size = 60;
				AD_mob_spawn_finale_size = 60;
				AD_mega_mob_size = 60;
				AD_mega_mob_spawn_min = 300;
				AD_mega_mob_spawn_max = 750;
				AD_mob_population_density = 0.0088;
				AD_wandering_density = 0.07;
				AD_smoker_health = 400;
				AD_boomer_health = 500;
				AD_hunter_health = 400;
				AD_spitter_health = 400;
				AD_jockey_health = 450;
				AD_charger_health = 750;
				AD_witch_health = 300;
				AD_zombie_health = 70;
				AD_witch_anger_rate = 0.8;
				AD_witch_personal_space = 160;
				AD_witch_burn_time = 30;
			}
			case 4:
			{
				AD_mob_spawn_min_interval = 30;
				AD_mob_spawn_max_interval = 120;
				AD_special_spawn_delay_min = 12;
				AD_special_spawn_delay_max = 14;
				AD_special_spawn_amount = 10;
				AD_tank_burn_duration = 120;
				AD_tank_health = 20000;
				AD_common_limit = 70;
				AD_reserved_wanderers = 35;
				AD_relax_max_flow_travel = 1000;
				AD_mob_spawn_min_size = 50;
				AD_mob_spawn_max_size = 60;
				AD_mob_spawn_finale_size = 60;
				AD_mega_mob_size = 60;
				AD_mega_mob_spawn_min = 250;
				AD_mega_mob_spawn_max = 700;
				AD_mob_population_density = 0.0096;
				AD_wandering_density = 0.08;
				AD_smoker_health = 500;
				AD_boomer_health = 600;
				AD_hunter_health = 500;
				AD_spitter_health = 500;
				AD_jockey_health = 550;
				AD_charger_health = 850;
				AD_witch_health = 400;
				AD_zombie_health = 90;
				AD_witch_anger_rate = 1.0;
				AD_witch_personal_space = 180;
				AD_witch_burn_time = 35;
			}
		}
		SetConVarInt(FindConVar("z_mob_spawn_min_interval_easy"), AD_mob_spawn_min_interval);
		SetConVarInt(FindConVar("z_mob_spawn_max_interval_easy"), AD_mob_spawn_max_interval);
		SetConVarInt(FindConVar("z_mob_spawn_min_interval_normal"), AD_mob_spawn_min_interval);
		SetConVarInt(FindConVar("z_mob_spawn_max_interval_normal"), AD_mob_spawn_max_interval);
		SetConVarInt(FindConVar("z_mob_spawn_min_interval_hard"), AD_mob_spawn_min_interval);
		SetConVarInt(FindConVar("z_mob_spawn_max_interval_hard"), AD_mob_spawn_max_interval);
		SetConVarInt(FindConVar("z_mob_spawn_min_interval_expert"), AD_mob_spawn_min_interval);
		SetConVarInt(FindConVar("z_mob_spawn_max_interval_expert"), AD_mob_spawn_max_interval);
		iSpecialMin = AD_special_spawn_delay_min;
		iSpecialMax = AD_special_spawn_delay_max;
		iSpecialAmount = AD_special_spawn_amount;
		SetConVarInt(FindConVar("tank_burn_duration"), AD_tank_burn_duration);
		SetConVarInt(FindConVar("tank_burn_duration_hard"), AD_tank_burn_duration);
		SetConVarInt(FindConVar("tank_burn_duration_expert"), AD_tank_burn_duration);
		SetConVarInt(FindConVar("z_tank_health"), AD_tank_health);
		SetConVarInt(FindConVar("z_common_limit"), AD_common_limit);
		SetConVarInt(FindConVar("z_reserved_wanderers"), AD_reserved_wanderers);
		SetConVarInt(FindConVar("director_relax_max_flow_travel"), AD_relax_max_flow_travel);
		SetConVarInt(FindConVar("z_mob_spawn_min_size"), AD_mob_spawn_min_size);
		SetConVarInt(FindConVar("z_mob_spawn_max_size"), AD_mob_spawn_max_size);
		SetConVarInt(FindConVar("z_mob_spawn_finale_size"), AD_mob_spawn_finale_size);
		SetConVarInt(FindConVar("z_mega_mob_size"), AD_mega_mob_size);
		SetConVarInt(FindConVar("z_mega_mob_spawn_min_interval"), AD_mega_mob_spawn_min);
		SetConVarInt(FindConVar("z_mega_mob_spawn_max_interval"), AD_mega_mob_spawn_max);
		SetConVarFloat(FindConVar("z_mob_population_density"), AD_mob_population_density);
		SetConVarFloat(FindConVar("z_wandering_density"), AD_wandering_density);
		SetConVarInt(FindConVar("z_gas_health"), AD_smoker_health);
		SetConVarInt(FindConVar("z_exploding_health"), AD_boomer_health);
		SetConVarInt(FindConVar("z_hunter_health"), AD_hunter_health);
		SetConVarInt(FindConVar("z_spitter_health"), AD_spitter_health);
		SetConVarInt(FindConVar("z_jockey_health"), AD_jockey_health);
		SetConVarInt(FindConVar("z_charger_health"), AD_charger_health);
		SetConVarInt(FindConVar("z_witch_health"), AD_witch_health);
		SetConVarInt(FindConVar("z_health"), AD_zombie_health);
		SetConVarFloat(FindConVar("z_witch_anger_rate"), AD_witch_anger_rate);
		SetConVarInt(FindConVar("z_witch_personal_space"), AD_witch_personal_space);
		SetConVarInt(FindConVar("z_witch_burn_time"), AD_witch_burn_time);
	}
	SetNightmareTime();
}
stock AutoDifficulty(bool:bDiffReset)
{
	if (!IsServerProcessing()) return;

	new diffchanged;
	iTeamScore = 0;
	decl String:GameDifficulty[16];
	GetConVarString(FindConVar("z_difficulty"), GameDifficulty, sizeof(GameDifficulty));
	//PrintToChatAll("iDifficulty: %i, z_difficulty: %s, bDiffReset: %i", iDifficulty, GameDifficulty, bDiffReset);

	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			if (GetClientTeam(i) == 2)
			{
				new level = cLevel[i];
				if (level >= 40)
				{
					if (!IsPlayerAlive(i))
					{
						iTeamScore -= 25;
					}
					else if (IsPlayerIncap(i))
					{
						iTeamScore -= 25;
					}
					else
					{
						iTeamScore += 25;
					}
				}
				else if (level >= 30)
				{
					if (!IsPlayerAlive(i))
					{
						iTeamScore -= 20;
					}
					else if (IsPlayerIncap(i))
					{
						iTeamScore -= 20;
					}
					else
					{
						iTeamScore += 20;
					}
				}
				else if (level >= 20)
				{
					if (!IsPlayerAlive(i))
					{
						iTeamScore -= 15;
					}
					else if (IsPlayerIncap(i))
					{
						iTeamScore -= 15;
					}
					else
					{
						iTeamScore += 15;
					}
				}
				else if (level >= 10)
				{
					if (!IsPlayerAlive(i))
					{
						iTeamScore -= 10;
					}
					else if (IsPlayerIncap(i))
					{
						iTeamScore -= 10;
					}
					else
					{
						iTeamScore += 10;
					}
				}
				else if (level >= 0)
				{
					if (!IsPlayerAlive(i))
					{
						iTeamScore -= 5;
					}
					else if (IsPlayerIncap(i))
					{
						iTeamScore -= 5;
					}
					else
					{
						iTeamScore += 5;
					}
				}
			}
		}	
	}

	if (bNightmare || bHell || bInferno || bBloodmoon || bCowLevel)
	{
		if (iDifficulty != 4)
		{
			if (!StrEqual(GameDifficulty, "Impossible", false))
			{
				SetConVarString(FindConVar("z_difficulty"), "Impossible");
				iDifficulty = 4;
				diffchanged = 1;
			}
		}
	}
	else
	{
		if (!bDiffOverride)
		{
			if (CountConnecting() == 0 && iMapTimeTick > 10)
			{
				if (iTeamScore <= 25)
				{
					if (iDifficulty != 1)
					{
						if (!StrEqual(GameDifficulty, "Easy", false))
						{
							SetConVarString(FindConVar("z_difficulty"), "Easy");
							iDifficulty = 1;
							diffchanged = 1;
						}
					}
				}
				else if (iTeamScore <= 50 && iTeamScore > 25)
				{
					if (iDifficulty != 2)
					{
						if (!StrEqual(GameDifficulty, "Normal", false))
						{
							SetConVarString(FindConVar("z_difficulty"), "Normal");
							iDifficulty = 2;
							diffchanged = 1;
						}
					}
				}
				else if (iTeamScore <= 75 && iTeamScore > 50)
				{
					if (iDifficulty != 3)
					{
						if (!StrEqual(GameDifficulty, "Hard", false))
						{
							SetConVarString(FindConVar("z_difficulty"), "Hard");
							iDifficulty = 3;
							diffchanged = 1;
						}
					}
				}
				else if (iTeamScore > 75)
				{
					if (iDifficulty != 4)
					{
						if (!StrEqual(GameDifficulty, "Impossible", false))
						{
							SetConVarString(FindConVar("z_difficulty"), "Impossible");
							iDifficulty = 4;
							diffchanged = 1;
						}
					}
				}
			}
		}
		else
		{
			switch(iDiffOverride)
			{
				case 25:
				{
					if (iDifficulty != 1)
					{
						if (!StrEqual(GameDifficulty, "Easy", false))
						{
							SetConVarString(FindConVar("z_difficulty"), "Easy");
							iDifficulty = 1;
							diffchanged = 1;
						}
					}
				}
				case 50:
				{
					if (iDifficulty != 2)
					{
						if (!StrEqual(GameDifficulty, "Normal", false))
						{
							SetConVarString(FindConVar("z_difficulty"), "Normal");
							iDifficulty = 2;
							diffchanged = 1;
						}
					}
				}
				case 75:
				{
					if (iDifficulty != 3)
					{
						if (!StrEqual(GameDifficulty, "Hard", false))
						{
							SetConVarString(FindConVar("z_difficulty"), "Hard");
							iDifficulty = 3;
							diffchanged = 1;
						}
					}
				}
				case 100:
				{
					if (iDifficulty != 4)
					{
						if (!StrEqual(GameDifficulty, "Impossible", false))
						{
							SetConVarString(FindConVar("z_difficulty"), "Impossible");
							iDifficulty = 4;
							diffchanged = 1;
						}
					}
				}
			}
		}
	}
	if (diffchanged == 1 || bDiffReset)
	{
		new AD_mob_spawn_min_interval;
		new AD_mob_spawn_max_interval;
		new AD_special_spawn_delay_min;
		new AD_special_spawn_delay_max;
		new AD_special_spawn_amount;
		new AD_tank_burn_duration;
		new AD_tank_health;
		new AD_common_limit;
		new AD_reserved_wanderers;
		new AD_relax_max_flow_travel;
		new AD_mob_spawn_min_size;
		new AD_mob_spawn_max_size;
		new AD_mob_spawn_finale_size;
		new AD_mega_mob_size;
		new AD_mega_mob_spawn_min;
		new AD_mega_mob_spawn_max;
		new Float:AD_mob_population_density;
		new Float:AD_wandering_density;
		new AD_smoker_health;
		new AD_boomer_health;
		new AD_hunter_health;
		new AD_spitter_health;
		new AD_jockey_health;
		new AD_charger_health;
		new AD_witch_health;
		new AD_zombie_health;
		new Float:AD_witch_anger_rate;
		new AD_witch_personal_space;
		new AD_witch_burn_time;

		if (bCowLevel)
		{
			AD_mob_spawn_min_interval = 0;
			AD_mob_spawn_max_interval = 0;
			AD_special_spawn_delay_min = 0;
			AD_special_spawn_delay_max = 0;
			AD_special_spawn_amount = 0;
			AD_tank_burn_duration = 666;
			AD_tank_health = 10000;
			AD_common_limit = 120;
			AD_reserved_wanderers = 35;
			AD_relax_max_flow_travel = 1000;
			AD_mob_spawn_min_size = 50;
			AD_mob_spawn_max_size = 60;
			AD_mob_spawn_finale_size = 60;
			AD_mega_mob_size = 60;
			AD_mega_mob_spawn_min = 15;
			AD_mega_mob_spawn_max = 30;
			AD_mob_population_density = 0.01;
			AD_wandering_density = 0.1;
			AD_smoker_health = 250;
			AD_boomer_health = 350;
			AD_hunter_health = 250;
			AD_spitter_health = 250;
			AD_jockey_health = 300;
			AD_charger_health = 600;
			AD_witch_health = 100;
			AD_zombie_health = 30;
			AD_witch_anger_rate = 1.0;
			AD_witch_personal_space = 180;
			AD_witch_burn_time = 35;
		}
		else if (bNightmare)
		{
			AD_mob_spawn_min_interval = 1;
			AD_mob_spawn_max_interval = 6;
			AD_special_spawn_delay_min = 6;
			AD_special_spawn_delay_max = 6;
			AD_special_spawn_amount = 10;
			AD_tank_burn_duration = 666;
			AD_tank_health = 60666;
			AD_common_limit = 0;
			AD_reserved_wanderers = 0;
			AD_relax_max_flow_travel = 666;
			AD_mob_spawn_min_size = 0;
			AD_mob_spawn_max_size = 0;
			AD_mob_spawn_finale_size = 0;
			AD_mega_mob_size = 0;
			AD_mega_mob_spawn_min = 0;
			AD_mega_mob_spawn_max = 0;
			AD_mob_population_density = 0.0;
			AD_wandering_density = 0.0;
			AD_smoker_health = 1666;
			AD_boomer_health = 1666;
			AD_hunter_health = 1666;
			AD_spitter_health = 1666;
			AD_jockey_health = 1666;
			AD_charger_health = 1666;
			AD_witch_health = 1666;
			AD_zombie_health = 666;
			AD_witch_anger_rate = 1.0;
			AD_witch_personal_space = 180;
			AD_witch_burn_time = 35;
		}
		else if (bInferno)
		{
			AD_mob_spawn_min_interval = 1;
			AD_mob_spawn_max_interval = 6;
			AD_special_spawn_delay_min = 6;
			AD_special_spawn_delay_max = 6;
			AD_special_spawn_amount = 10;
			AD_tank_burn_duration = 666;
			AD_tank_health = 30000;
			AD_common_limit = 0;
			AD_reserved_wanderers = 0;
			AD_relax_max_flow_travel = 666;
			AD_mob_spawn_min_size = 0;
			AD_mob_spawn_max_size = 0;
			AD_mob_spawn_finale_size = 0;
			AD_mega_mob_size = 0;
			AD_mega_mob_spawn_min = 0;
			AD_mega_mob_spawn_max = 0;
			AD_mob_population_density = 0.0;
			AD_wandering_density = 0.0;
			AD_smoker_health = 500;
			AD_boomer_health = 600;
			AD_hunter_health = 500;
			AD_spitter_health = 500;
			AD_jockey_health = 550;
			AD_charger_health = 850;
			AD_witch_health = 500;
			AD_zombie_health = 100;
			AD_witch_anger_rate = 1.0;
			AD_witch_personal_space = 160;
			AD_witch_burn_time = 25;
		}
		else if (bHell || bBloodmoon)
		{
			AD_mob_spawn_min_interval = 1;
			AD_mob_spawn_max_interval = 6;
			AD_special_spawn_delay_min = 6;
			AD_special_spawn_delay_max = 6;
			AD_special_spawn_amount = 10;
			AD_tank_burn_duration = 666;
			AD_tank_health = 25000;
			AD_common_limit = 36;
			AD_reserved_wanderers = 16;
			AD_relax_max_flow_travel = 666;
			AD_mob_spawn_min_size = 36;
			AD_mob_spawn_max_size = 36;
			AD_mob_spawn_finale_size = 36;
			AD_mega_mob_size = 36;
			AD_mega_mob_spawn_min = 1;
			AD_mega_mob_spawn_max = 6;
			AD_mob_population_density = 0.0064;
			AD_wandering_density = 0.03;
			AD_smoker_health = 500;
			AD_boomer_health = 600;
			AD_hunter_health = 500;
			AD_spitter_health = 500;
			AD_jockey_health = 550;
			AD_charger_health = 850;
			AD_witch_health = 500;
			AD_zombie_health = 100;
			AD_witch_anger_rate = 0.7;
			AD_witch_personal_space = 145;
			AD_witch_burn_time = 25;
		}
		else
		{
			switch(iDifficulty)
			{
				case 1:
				{
					AD_mob_spawn_min_interval = 90;
					AD_mob_spawn_max_interval = 180;
					AD_special_spawn_delay_min = 18;
					AD_special_spawn_delay_max = 20;
					AD_special_spawn_amount = 6;
					AD_tank_burn_duration = 75;
					AD_tank_health = 5000;
					AD_common_limit = 30;
					AD_reserved_wanderers = 12;
					AD_relax_max_flow_travel = 2500;
					AD_mob_spawn_min_size = 20;
					AD_mob_spawn_max_size = 30;
					AD_mob_spawn_finale_size = 30;
					AD_mega_mob_size = 30;
					AD_mega_mob_spawn_min = 400;
					AD_mega_mob_spawn_max = 850;
					AD_mob_population_density = 0.0072;
					AD_wandering_density = 0.04;
					AD_smoker_health = 250;
					AD_boomer_health = 350;
					AD_hunter_health = 250;
					AD_spitter_health = 250;
					AD_jockey_health = 300;
					AD_charger_health = 600;
					AD_witch_health = 100;
					AD_zombie_health = 30;
					AD_witch_anger_rate = 0.4;
					AD_witch_personal_space = 120;
					AD_witch_burn_time = 20;
				}
				case 2:
				{
					AD_mob_spawn_min_interval = 70;
					AD_mob_spawn_max_interval = 160;
					AD_special_spawn_delay_min = 16;
					AD_special_spawn_delay_max = 18;
					AD_special_spawn_amount = 8;
					AD_tank_burn_duration = 90;
					AD_tank_health = 10000;
					AD_common_limit = 45;
					AD_reserved_wanderers = 18;
					AD_relax_max_flow_travel = 2000;
					AD_mob_spawn_min_size = 30;
					AD_mob_spawn_max_size = 45;
					AD_mob_spawn_finale_size = 45;
					AD_mega_mob_size = 45;
					AD_mega_mob_spawn_min = 350;
					AD_mega_mob_spawn_max = 800;
					AD_mob_population_density = 0.0080;
					AD_wandering_density = 0.06;
					AD_smoker_health = 300;
					AD_boomer_health = 400;
					AD_hunter_health = 300;
					AD_spitter_health = 300;
					AD_jockey_health = 350;
					AD_charger_health = 650;
					AD_witch_health = 200;
					AD_zombie_health = 50;
					AD_witch_anger_rate = 0.6;
					AD_witch_personal_space = 140;
					AD_witch_burn_time = 25;
				}
				case 3:
				{
					AD_mob_spawn_min_interval = 50;
					AD_mob_spawn_max_interval = 140;
					AD_special_spawn_delay_min = 14;
					AD_special_spawn_delay_max = 16;
					AD_special_spawn_amount = 10;
					AD_tank_burn_duration = 105;
					AD_tank_health = 15000;
					AD_common_limit = 60;
					AD_reserved_wanderers = 25;
					AD_relax_max_flow_travel = 1500;
					AD_mob_spawn_min_size = 40;
					AD_mob_spawn_max_size = 60;
					AD_mob_spawn_finale_size = 60;
					AD_mega_mob_size = 60;
					AD_mega_mob_spawn_min = 300;
					AD_mega_mob_spawn_max = 750;
					AD_mob_population_density = 0.0088;
					AD_wandering_density = 0.07;
					AD_smoker_health = 400;
					AD_boomer_health = 500;
					AD_hunter_health = 400;
					AD_spitter_health = 400;
					AD_jockey_health = 450;
					AD_charger_health = 750;
					AD_witch_health = 300;
					AD_zombie_health = 70;
					AD_witch_anger_rate = 0.8;
					AD_witch_personal_space = 160;
					AD_witch_burn_time = 30;
				}
				case 4:
				{
					AD_mob_spawn_min_interval = 30;
					AD_mob_spawn_max_interval = 120;
					AD_special_spawn_delay_min = 12;
					AD_special_spawn_delay_max = 14;
					AD_special_spawn_amount = 10;
					AD_tank_burn_duration = 120;
					AD_tank_health = 20000;
					AD_common_limit = 70;
					AD_reserved_wanderers = 35;
					AD_relax_max_flow_travel = 1000;
					AD_mob_spawn_min_size = 50;
					AD_mob_spawn_max_size = 60;
					AD_mob_spawn_finale_size = 60;
					AD_mega_mob_size = 60;
					AD_mega_mob_spawn_min = 250;
					AD_mega_mob_spawn_max = 700;
					AD_mob_population_density = 0.0096;
					AD_wandering_density = 0.08;
					AD_smoker_health = 500;
					AD_boomer_health = 600;
					AD_hunter_health = 500;
					AD_spitter_health = 500;
					AD_jockey_health = 550;
					AD_charger_health = 850;
					AD_witch_health = 400;
					AD_zombie_health = 90;
					AD_witch_anger_rate = 1.0;
					AD_witch_personal_space = 180;
					AD_witch_burn_time = 35;
				}
			}
		}
		SetConVarInt(FindConVar("z_mob_spawn_min_interval_easy"), AD_mob_spawn_min_interval);
		SetConVarInt(FindConVar("z_mob_spawn_max_interval_easy"), AD_mob_spawn_max_interval);
		SetConVarInt(FindConVar("z_mob_spawn_min_interval_normal"), AD_mob_spawn_min_interval);
		SetConVarInt(FindConVar("z_mob_spawn_max_interval_normal"), AD_mob_spawn_max_interval);
		SetConVarInt(FindConVar("z_mob_spawn_min_interval_hard"), AD_mob_spawn_min_interval);
		SetConVarInt(FindConVar("z_mob_spawn_max_interval_hard"), AD_mob_spawn_max_interval);
		SetConVarInt(FindConVar("z_mob_spawn_min_interval_expert"), AD_mob_spawn_min_interval);
		SetConVarInt(FindConVar("z_mob_spawn_max_interval_expert"), AD_mob_spawn_max_interval);
		iSpecialMin = AD_special_spawn_delay_min;
		iSpecialMax = AD_special_spawn_delay_max;
		iSpecialAmount = AD_special_spawn_amount;
		SetConVarInt(FindConVar("tank_burn_duration"), AD_tank_burn_duration);
		SetConVarInt(FindConVar("tank_burn_duration_hard"), AD_tank_burn_duration);
		SetConVarInt(FindConVar("tank_burn_duration_expert"), AD_tank_burn_duration);
		SetConVarInt(FindConVar("z_tank_health"), AD_tank_health);
		SetConVarInt(FindConVar("z_common_limit"), AD_common_limit);
		SetConVarInt(FindConVar("z_reserved_wanderers"), AD_reserved_wanderers);
		SetConVarInt(FindConVar("director_relax_max_flow_travel"), AD_relax_max_flow_travel);
		SetConVarInt(FindConVar("z_mob_spawn_min_size"), AD_mob_spawn_min_size);
		SetConVarInt(FindConVar("z_mob_spawn_max_size"), AD_mob_spawn_max_size);
		SetConVarInt(FindConVar("z_mob_spawn_finale_size"), AD_mob_spawn_finale_size);
		SetConVarInt(FindConVar("z_mega_mob_size"), AD_mega_mob_size);
		SetConVarInt(FindConVar("z_mega_mob_spawn_min_interval"), AD_mega_mob_spawn_min);
		SetConVarInt(FindConVar("z_mega_mob_spawn_max_interval"), AD_mega_mob_spawn_max);
		SetConVarFloat(FindConVar("z_mob_population_density"), AD_mob_population_density);
		SetConVarFloat(FindConVar("z_wandering_density"), AD_wandering_density);
		SetConVarInt(FindConVar("z_gas_health"), AD_smoker_health);
		SetConVarInt(FindConVar("z_exploding_health"), AD_boomer_health);
		SetConVarInt(FindConVar("z_hunter_health"), AD_hunter_health);
		SetConVarInt(FindConVar("z_spitter_health"), AD_spitter_health);
		SetConVarInt(FindConVar("z_jockey_health"), AD_jockey_health);
		SetConVarInt(FindConVar("z_charger_health"), AD_charger_health);
		SetConVarInt(FindConVar("z_witch_health"), AD_witch_health);
		SetConVarInt(FindConVar("z_health"), AD_zombie_health);
		SetConVarFloat(FindConVar("z_witch_anger_rate"), AD_witch_anger_rate);
		SetConVarInt(FindConVar("z_witch_personal_space"), AD_witch_personal_space);
		SetConVarInt(FindConVar("z_witch_burn_time"), AD_witch_burn_time);
	}
	SetNightmareTime();
}
stock SetNightmareTime()
{
	switch(iDifficulty)
	{
		case 1:
		{
			SetConVarInt(hNightmareTime, iNMTimeEasy);
		}
		case 2:
		{
			SetConVarInt(hNightmareTime, iNMTimeNormal);
		}
		case 3:
		{
			SetConVarInt(hNightmareTime, iNMTimeAdvanced);
		}
		case 4:
		{
			SetConVarInt(hNightmareTime, iNMTimeExpert);
		}
	}
}
//=============================
//	FUNCTIONS
//=============================
stock DisableClientPerksAll()
{
	for (new i=1; i<=MaxClients; i++)
	{
		DestroyAmmoPile(i);
		DestroyUVLight(i);
		DestroyEmitter(i);
		DestroyDefenseGrid(i);
		DestroySentryGun(i);
		DestroyHealingStation(i);
		DestroyResurrectionBag(i);
	}
}
stock DisableClientPerks(client)
{
	DestroyAmmoPile(client);
	DestroyUVLight(client);
	DestroyEmitter(client);
	DestroyDefenseGrid(client);
	DestroySentryGun(client);
	DestroyHealingStation(client);
	DestroyResurrectionBag(client);
}
stock ResetVariables()
{
	DisableBombardments = false;
	iSRDoor = 0;
	iSRDoorStart = 0;
	iSRLocked = 0;
	iSRDoorTick = 0;
	iSRDoorDelay = 0;
	iSRDoorFix = 0;
	iMapTimeTick = 0;
	iNightmareTick = 0;
	iCountDownTimer = 0;
	iSpawnBotTick = 0;
	iFinaleStage = 0;
	iFinaleWin = 0;
	iNumTanksWave = 0;
	iAnnounceTick = 0;
	iCriticalNotice = 0;
	iGasCanPlacementTick = 0;
	iGasCanPoured = 0;
	iCreateInstaCapper = 0;
	iCreateBreeder = 0;
	iSpawnHeavy = 0;
	iZombieType = 0;
	iZombieAmount = 0;
	iCCEnt = 0;
	iFogVolEnt = 0;
	iPrecipitation = 0;
	iCowLevelSpawns = 0;
	iClipBrush = 0;
	for (new count=1; count<=32; count++)
	{
		aClipBrush[count] = 0;
	}
	iQuantifyWeapons = 0;
	iCheckpoint = 0;
	iRescue = 0;
	iRescueZone = 0;
	for (new i=0; i<=2; i++)
	{
		CPStartLocA[i] = 0.0;
		CPStartLocB[i] = 0.0;
		CPStartLocC[i] = 0.0;
		CPStartLocD[i] = 0.0;
		CPEndLocA[i] = 0.0;
		CPEndLocB[i] = 0.0;
		CPEndLocC[i] = 0.0;
		CPEndLocD[i] = 0.0;
	}
	bCPStartHasExtraData = false;
	bCPEndHasExtraData = false;
	CPStartRotate = 0.0;
	CPEndRotate = 0.0;
	bFreezeAI = true;
}
public Action:ResetNewClientArraysTimer(Handle:timer, any:client)
{
	ResetNewClientArrays(client);
}
stock ResetNewClientArrays(client)
{
	NewClient[client] = 1;
	strcopy(HealthMapName[client], 32, "");
	HealthMap[client] = 0;
	aDamageType[client] = 0;
	cExp_accum[client] = 0;
	cLevel_accum[client] = 0;
	cVoteAccess_accum[client] = 0;

	cSlot0Clip[client] = 0;
	cSlot0UpgradeAmmo[client] = 0;
	cSlot0AmmoOffset[client] = 0;
	cSlot0Ammo[client] = 0;
	cSlot1Clip[client] = 0;
	cSlot1Dual[client] = 0;
	cSlot0Upgrade[client] = 0;
	cSlot0Weapon[client] = "0";
	cSlot1Weapon[client] = "0";
	cSlot2Weapon[client] = "0";
	cSlot3Weapon[client] = "0";
	cSlot4Weapon[client] = "0";

	cCampaignBonus[client] = 0;
	cNotifications[client] = 0;
	CritMessages[client] = 0;

	SentryNeverTarget[client] = 0;
	SentryTargetFirst[client] = 0;

	CannonOn[client] = 0;
	CannonNeverTarget[client] = 0;
	CannonTargetFirst[client] = 0;
	CannonRate[client] = 0.0;
	CannonAmmo[client] = 0;
	CannonEquip[client] = 0;

	JetPackEquip[client] = 0;

	ArtilleryAmmo[client] = 0;
	IonCannonAmmo[client] = 0;
	NukeAmmo[client] = 0;

	HatEquip[client] = 0;
	HatIndex[client] = 0;

	for (new count=0; count<=12; count++)
	{
		BackpackItemID[client][count] = 0;
		for (new index=0; index<=4; index++)
		{
			BackpackGunInfo[client][count][index] = 0;
		}
	}
}
stock ResetDatabaseArrays(client)
{
	cID[client] = 0;
	cExp[client] = 0;
	cExp_accum[client] = 0;
	cLevel[client] = 0;
	cLevel_accum[client] = 0;
	cExpToLevel[client] = 0;
	cVoteAccess[client] = 0;
	cVoteAccess_accum[client] = 0;
	ReadWriteDelay[client] = 0;
}
stock ResetClientArrays(client)
{
	JoinedServer[client] = 1; //Only here, when client connects
	PlayerSpawn[client] = 0;
	GravityClaw[client] = 0;
	ReduceSpeed75[client] = 0;
	AFKTime[client] = 0;
	ShieldsUp[client] = 0;
	TankAbility[client] = 0;
	TankAlive[client] = 0;
	TankAbilityTimer[client] = 0;
	ChoiceDelay[client] = 0;
	UseDelay[client] = 0;
	cLevelUpMessage[client] = 0;
	WeaponsRestored[client] = 0;
	WeaponDropDelay[client] = 0;
	BackpackDelay[client] = 0;
	WaitRescue[client] = 0;

	CannonEnt[client] = 0;
	JetPackAEnt[client] = 0;
	JetPackBEnt[client] = 0;
	JetPackOn[client] = 0;
	JetPackAscend[client] = false;
	JetPackDescend[client] = false;
	JetPackFlight[client] = false;
	JetPackParticleTimer[client] = 0;
	JetPackFuel[client] = 150;
	JetPackJump[client] = 0;
	JetPackDisrupt[client] = 0;
	JetPackIdle[client] = 0;
	JetPackIdleOrigin[client][0] = 0.0;
	JetPackIdleOrigin[client][1] = 0.0;
	JetPackIdleOrigin[client][2] = 0.0;
	HatEnt[client] = 0;

	ReviveStart[client] = 0;
	ReviveStartTime[client] = 0.0;
	KnifeStart[client] = 0;
	KnifeStartTime[client] = 0.0;
	BlockHeal[client] = false;
	BlockHealTime[client] = 0.0;
	SavedHealth[client] = 0;
	DefibHealth[client] = 0;

	SecChance[client] = 0;
	SecChanceTimer[client] = 0;
	UVLightModel[client] = 0;
	UVLightGlow[client] = 0;
	EmitterSpeaker[client] = 0;
	EmitterBase[client] = 0;
	Sentry[client] = 0;
	SentryEnemy[client] = 0;
	SentryAngles[client][0] = 0.0;
	SentryAngles[client][1] = 0.0;
	SentryTime[client][0] = 0.0;
	SentryTime[client][1] = 0.0;
	SentryTime[client][2] = 0.0;
	HSModel[client] = 0;
	HSTrigger[client] = 0;
	RBModel[client] = 0;
	RBTrigger[client] = 0;
	AmmoPile[client] = 0;

	for (new index=0; index<=7; index++)
	{
		DefenseGridEnt[client][index] = 0;
	}

	for (new index=0; index<=5; index++)
	{
		ArtyFlareEnts[client][index] = 0;
		IonFlareEnts[client][index] = 0;
		NukeFlareEnts[client][index] = 0;
	}
	for (new index=0; index<=2; index++)
	{
		ArtilleryOrigin[client][index] = 0.0;
		IonCannonOrigin[client][index] = 0.0;
	}
	for (new index=0; index<=5; index++)
	{
		IonBeamOrigin[client][index][0] = 0.0;
		IonBeamOrigin[client][index][1] = 0.0;
		IonBeamOrigin[client][index][2] = 0.0;
		IonBeamDegrees[client][index] = 0.0;
	}

	HealingAuraOn[client] = 0;
	SoulShieldOn[client] = 0;
	LifeStealerOn[client] = 0;
	BerserkerOn[client] = 0;
	NightCrawlerOn[client] = 0;
	RapidFireOn[client] = 0;
	FlameShieldOn[client] = 0;
	InstaGibOn[client] = 0;
	PolyMorphOn[client] = 0;
	DetectGZOn[client] = 0;
	AcidBathOn[client] = 0;
	ChainsawMassOn[client] = 0;
	HeatSeekerOn[client] = 0;
	SpeedFreakOn[client] = 0;

	HealingAuraPlayer[client] = 0;
	HealingAuraTarget[client] = 0;
	SoulShieldGlow[client][0] = 0;
	SoulShieldGlow[client][1] = 0;
	HeatSeekerTarget[client] = 0;

	UVLightTimer[client] = 0;
	EmitterTimer[client] = 0;
	SentryTimer[client] = 0;
	HSTimer[client] = 0;
	RBTimer[client] = 0;
	DefenseGridTimer[client] = 0;
	AmmoTimer[client] = 0;

	HealingAuraTimer[client] = 0;
	SoulShieldTimer[client] = 0;
	LifeStealerTimer[client] = 0;
	BerserkerTimer[client] = 0;
	NightCrawlerTimer[client] = 0;
	RapidFireTimer[client] = 0;
	FlameShieldTimer[client] = 0;
	InstaGibTimer[client] = 0;
	PolyMorphTimer[client] = 0;
	DetectGZTimer[client] = 0;
	AcidBathTimer[client] = 0;
	ChainsawMassTimer[client] = 0;
	HeatSeekerTimer[client] = 0;
	SpeedFreakTimer[client] = 0;

	ArtilleryTimer[client] = 0;
	IonCannonTimer[client] = 0;
	NukeTimer[client] = 0;

	for (new count=0; count<=MaxClients; count++)
	{
		ChainsawDamage[client][count] = 0;
		for (new index=0; index<=7; index++)
		{
			XPDamage[client][count][index] = 0;
		}
	}
	if (client > 0 && IsClientInGame(client))
	{
		SetEntProp(client, Prop_Send, "m_iGlowType", 0);
		SetEntProp(client, Prop_Send, "m_glowColorOverride", 0);
		if (!IsFakeClient(client) && GetClientTeam(client) == 3)
		{
			SetEntProp(client, Prop_Send, "m_scrimmageType", 0);
		}
	}
}
stock ResetClientArraysAll()
{
	for (new client=1; client<=MaxClients; client++)
	{
		ZombieClone[client] = 0; //only here, at roundstart
		PlayerSpawn[client] = 0;
		GravityClaw[client] = 0;
		ReduceSpeed75[client] = 0;
		AFKTime[client] = 0;
		ShieldsUp[client] = 0;
		TankAbility[client] = 0;
		TankAlive[client] = 0;
		TankAbilityTimer[client] = 0;
		ChoiceDelay[client] = 0;
		UseDelay[client] = 0;
		cLevelUpMessage[client] = 0;
		WeaponsRestored[client] = 0;
		WeaponDropDelay[client] = 0;
		BackpackDelay[client] = 0;
		WaitRescue[client] = 0;

		CannonEnt[client] = 0;
		JetPackAEnt[client] = 0;
		JetPackBEnt[client] = 0;
		JetPackOn[client] = 0;
		JetPackAscend[client] = false;
		JetPackDescend[client] = false;
		JetPackFlight[client] = false;
		JetPackParticleTimer[client] = 0;
		JetPackFuel[client] = 150;
		JetPackJump[client] = 0;
		JetPackIdle[client] = 0;
		JetPackIdleOrigin[client][0] = 0.0;
		JetPackIdleOrigin[client][1] = 0.0;
		JetPackIdleOrigin[client][2] = 0.0;
		JetPackDisrupt[client] = 0;
		HatEnt[client] = 0;

		ReviveStart[client] = 0;
		ReviveStartTime[client] = 0.0;
		KnifeStart[client] = 0;
		KnifeStartTime[client] = 0.0;
		BlockHeal[client] = false;
		BlockHealTime[client] = 0.0;
		SavedHealth[client] = 0;
		DefibHealth[client] = 0;

		SecChance[client] = 0;
		SecChanceTimer[client] = 0;
		UVLightModel[client] = 0;
		UVLightGlow[client] = 0;
		EmitterSpeaker[client] = 0;
		EmitterBase[client] = 0;
		Sentry[client] = 0;
		SentryEnemy[client] = 0;
		SentryAngles[client][0] = 0.0;
		SentryAngles[client][1] = 0.0;
		SentryTime[client][0] = 0.0;
		SentryTime[client][1] = 0.0;
		SentryTime[client][2] = 0.0;
		HSModel[client] = 0;
		HSTrigger[client] = 0;
		RBModel[client] = 0;
		RBTrigger[client] = 0;
		AmmoPile[client] = 0;

		HealingAuraOn[client] = 0;
		SoulShieldOn[client] = 0;
		LifeStealerOn[client] = 0;
		BerserkerOn[client] = 0;
		NightCrawlerOn[client] = 0;
		RapidFireOn[client] = 0;
		FlameShieldOn[client] = 0;
		InstaGibOn[client] = 0;
		PolyMorphOn[client] = 0;
		DetectGZOn[client] = 0;
		AcidBathOn[client] = 0;
		ChainsawMassOn[client] = 0;
		HeatSeekerOn[client] = 0;
		SpeedFreakOn[client] = 0;

		HealingAuraPlayer[client] = 0;
		HealingAuraTarget[client] = 0;
		SoulShieldGlow[client][0] = 0;
		SoulShieldGlow[client][1] = 0;
		HeatSeekerTarget[client] = 0;

		for (new index=0; index<=7; index++)
		{
			DefenseGridEnt[client][index] = 0;
		}

		for (new index=0; index<=5; index++)
		{
			ArtyFlareEnts[client][index] = 0;
			IonFlareEnts[client][index] = 0;
			NukeFlareEnts[client][index] = 0;
		}
		for (new index=0; index<=2; index++)
		{
			ArtilleryOrigin[client][index] = 0.0;
			IonCannonOrigin[client][index] = 0.0;
		}
		for (new index=0; index<=5; index++)
		{
			IonBeamOrigin[client][index][0] = 0.0;
			IonBeamOrigin[client][index][1] = 0.0;
			IonBeamOrigin[client][index][2] = 0.0;
			IonBeamDegrees[client][index] = 0.0;
		}

		UVLightTimer[client] = 0;
		EmitterTimer[client] = 0;
		SentryTimer[client] = 0;
		HSTimer[client] = 0;
		RBTimer[client] = 0;
		DefenseGridTimer[client] = 0;
		AmmoTimer[client] = 0;

		HealingAuraTimer[client] = 0;
		SoulShieldTimer[client] = 0;
		LifeStealerTimer[client] = 0;
		BerserkerTimer[client] = 0;
		NightCrawlerTimer[client] = 0;
		RapidFireTimer[client] = 0;
		FlameShieldTimer[client] = 0;
		InstaGibTimer[client] = 0;
		PolyMorphTimer[client] = 0;
		DetectGZTimer[client] = 0;
		AcidBathTimer[client] = 0;
		ChainsawMassTimer[client] = 0;
		HeatSeekerTimer[client] = 0;
		SpeedFreakTimer[client] = 0;

		ArtilleryTimer[client] = 0;
		IonCannonTimer[client] = 0;
		NukeTimer[client] = 0;

		for (new count=0; count<=MaxClients; count++)
		{
			ChainsawDamage[client][count] = 0;
			for (new index=0; index<=7; index++)
			{
				XPDamage[client][count][index] = 0;
			}
		}
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_iGlowType", 0);
			SetEntProp(client, Prop_Send, "m_glowColorOverride", 0);
			if (!IsFakeClient(client) && GetClientTeam(client) == 3)
			{
				SetEntProp(client, Prop_Send, "m_scrimmageType", 0);
			}
		}
	}
}
stock ResetCampaignBonuses()
{
	for (new client=1; client<=MaxClients; client++)
	{
		cCampaignBonus[client] = 0;
	}
}
stock FrameUpdateClients()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSurvivor(i) && IsPlayerAlive(i))
		{
			UpdateMovementSpeed(i);
			AcrobaticsSkill(i);
			JetPackControl(i);
		}
		CreateClone(i);
	}
}
stock Announce()
{
	iCriticalNotice +=1;
	{
		if (iCriticalNotice >= 12)
		{
			for (new i=1; i<=MaxClients; i++)
			{
				if (IsSurvivor(i) && IsPlayerAlive(i))
				{
					new damagetype = aDamageType[i];
					switch(damagetype)
					{
						case 1: PrintToChat(i, "[Critical] You are bleeding. Use a First Aid Kit!");
						case 2: PrintToChat(i, "[Critical] You are bleeding profusely. Use a First Aid Kit!");
					}
				}
			}
			iCriticalNotice = 0;
		}
	}
	iAnnounceTick += 1;
	if (iAnnounceTick >= 80)
	{
		new random = GetRandomInt(1,10);
		switch(random)
		{
			case 1: PrintToChatAll("\x05[Lethal-Injection]\x01 Type \x03/menu\x01 to access certain features of the servers custom leveling plugin.");
			case 2: PrintToChatAll("\x05[Lethal-Injection]\x01 As you gain levels, your character will acquire more powerful abilities.");
			case 3: PrintToChatAll("\x05[Lethal-Injection]\x01 This server uses a database to save your XP and Levels.");
			case 4:	PrintToChatAll("\x05[Lethal-Injection]\x01 Character Select Menu: Type \x03!csm\x01 in chat to select your character.");
			case 5:	PrintToChatAll("\x05[Lethal-Injection]\x01 This server auto-manages all difficulty settings.");
			case 6:	PrintToChatAll("\x05[Lethal-Injection]\x01 Type \x03/info\x01 to view the server difficulty settings.");
			case 7:	PrintToChatAll("\x05[Lethal-Injection]\x01 Type \x03/teams\x01 to bring up the teams panel.");
			case 8:	PrintToChatAll("\x05[Lethal-Injection]\x01 When you see the countdown begin for Nightmare mode, run for the saferoom.");
			case 9:
			{
				if (bCowLevel)
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 MOOoooo.");
				}
				else if (bInferno)
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 Only death is the end of Inferno.");
				}
				else if (bHell)
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 Welcome to Hell.");
				}
				else if (bBloodmoon)
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 You beat Expert. Survive this...");
				}
				else
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 Hell can be reached by completing a campaign on Expert difficulty.");
				}
			}
			case 10:
			{
				if (bCowLevel)
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 Moo.");
				}
				else if (bInferno)
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 This will be your doom!");
				}
				else if (bHell)
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 Inferno can be reached by completing a campaign on Hell difficulty.");
				}
				else if (bBloodmoon)
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 Bloodmoon is a rare gamemode, XP gain is increased here.");
				}
				else
				{
					PrintToChatAll("\x05[Lethal-Injection]\x01 Please always remember to be respectful to other players.");
				}
			}
		}
		iAnnounceTick = 0;
	}
}
stock GasCanPlacementTimer()
{
	if (bIsScavengeFinale())
	{
		if (iFinaleStage > 0)
		{
			iGasCanPlacementTick += 1;
			if (iGasCanPlacementTick >= 27)
			{
				GasCanRandomPlacement();
				iGasCanPlacementTick = 0;
			}
			else
			{
				new random = GetRandomInt(1,27);
				if (random == 1)
				{
					GasCanRandomPlacement();
					iGasCanPlacementTick = 0;
				}
			}
		}
	}
}
stock UpdateTimers(client)
{
	
	if (IsSurvivor(client) || IsSpectator(client))
	{
		new damagetype = aDamageType[client];
		if (damagetype > 0 && !IsPlayerIncap(client))
		{
			switch(damagetype)
			{
				case 1: DealDamagePlayer(client, 0, 128, 1, "point_hurt");
				case 2: DealDamagePlayer(client, 0, 128, 2, "point_hurt");
			}
		}
		if (ReduceSpeed75[client] > 0)
		{
			ReduceSpeed75[client] -= 1;
		}
		if (WeaponDropDelay[client] > 0)
		{
			WeaponDropDelay[client] -= 1;
		}
		if (BackpackDelay[client] > 0)
		{
			BackpackDelay[client] -= 1;
		}
		if (JetPackDisrupt[client] > 0)
		{
			JetPackDisrupt[client] -= 1;
		}
		if (SecChanceTimer[client] > 0)
		{
			PrintToChat(client, "\x04[Second Chance]\x01 Invincibility will fade in %i seconds.", SecChanceTimer[client]);
			SecChanceTimer[client] -= 1;
		}
		
		new maxdeployables = 7;

		new deployabletimer[7+1];
		deployabletimer[1] = AmmoTimer[client];
		deployabletimer[2] = UVLightTimer[client];
		deployabletimer[3] = EmitterTimer[client];
		deployabletimer[4] = HSTimer[client];
		deployabletimer[5] = SentryTimer[client];
		deployabletimer[6] = RBTimer[client];
		deployabletimer[7] = DefenseGridTimer[client];

		new deployabletime[7+1];
		deployabletime[1] = 240;
		deployabletime[2] = 240;
		deployabletime[3] = 240;
		deployabletime[4] = 240;
		deployabletime[5] = 240;
		deployabletime[6] = 240;
		deployabletime[7] = 270;

		for (new deployables=1; deployables<=maxdeployables; deployables++)
		{
			if (deployabletimer[deployables] > 0)
			{
				if (deployabletimer[deployables] > deployabletime[deployables] || deployabletimer[deployables] < deployabletime[deployables])
				{
					UpdateDeployable(client, deployables);
				}
				else if (deployabletimer[deployables] == deployabletime[deployables])
				{
					DestroyDeployable(client, deployables);
				}
			}
		}

		new maxabilities = 14;

		new abilitytimer[14+1];
		abilitytimer[1] = DetectGZTimer[client];
		abilitytimer[2] = BerserkerTimer[client];
		abilitytimer[3] = AcidBathTimer[client];
		abilitytimer[4] = LifeStealerTimer[client];
		abilitytimer[5] = FlameShieldTimer[client];
		abilitytimer[6] = NightCrawlerTimer[client];
		abilitytimer[7] = RapidFireTimer[client];
		abilitytimer[8] = ChainsawMassTimer[client];
		abilitytimer[9] = HeatSeekerTimer[client];
		abilitytimer[10] = SpeedFreakTimer[client];
		abilitytimer[11] = HealingAuraTimer[client];
		abilitytimer[12] = SoulShieldTimer[client];
		abilitytimer[13] = PolyMorphTimer[client];
		abilitytimer[14] = InstaGibTimer[client];

		new abilitytime[14+1];
		abilitytime[1] = 240;
		abilitytime[2] = 240;
		abilitytime[3] = 240;
		abilitytime[4] = 240;
		abilitytime[5] = 240;
		abilitytime[6] = 240;
		abilitytime[7] = 240;
		abilitytime[8] = 240;
		abilitytime[9] = 240;
		abilitytime[10] = 240;
		abilitytime[11] = 240;
		abilitytime[12] = 240;
		abilitytime[13] = 240;
		abilitytime[14] = 240;

		for (new abilities=1; abilities<=maxabilities; abilities++)
		{
			if (abilitytimer[abilities] > 0)
			{
				if (abilitytimer[abilities] > abilitytime[abilities] || abilitytimer[abilities] < abilitytime[abilities])
				{
					UpdateAbility(client, abilities);
				}
				else if (abilitytimer[abilities] == abilitytime[abilities])
				{
					DestroyAbility(client, abilities);
				}
			}
		}


		new maxbombardments = 3;

		new bombardmenttimer[3+1];
		bombardmenttimer[1] = ArtilleryTimer[client];
		bombardmenttimer[2] = IonCannonTimer[client];
		bombardmenttimer[3] = NukeTimer[client];

		for (new bombardments=1; bombardments<=maxbombardments; bombardments++)
		{
			if (bombardmenttimer[bombardments] > 0)
			{
				UpdateBombardment(client, bombardments);
			}
		}
	}
}
stock UpdateDeployable(client, deployable)
{
	switch(deployable)
	{
		case 1: UpdateAmmoPile(client);
		case 2: UpdateUVLight(client);
		case 3: UpdateEmitter(client);
		case 4: UpdateHealingStation(client);
		case 5: UpdateSentryGun(client);
		case 6: UpdateResurrectionBag(client);
		case 7: UpdateDefenseGrid(client);
	}
}
stock DestroyDeployable(client, deployable)
{
	switch(deployable)
	{
		case 1: DestroyAmmoPile(client);
		case 2: DestroyUVLight(client);
		case 3: DestroyEmitter(client);
		case 4: DestroyHealingStation(client);
		case 5: DestroySentryGun(client);
		case 6: DestroyResurrectionBag(client);
		case 7: DestroyDefenseGrid(client);
	}
}
stock UpdateAbility(client, ability)
{
	switch(ability)
	{
		case 1: UpdateDetectGZ(client);
		case 2: UpdateBerserker(client);
		case 3: UpdateAcidBath(client);
		case 4: UpdateLifeStealer(client);
		case 5: UpdateFlameShield(client);
		case 6: UpdateNightCrawler(client);
		case 7: UpdateRapidFire(client);
		case 8: UpdateChainsawMass(client);
		case 9: UpdateHeatSeeker(client);
		case 10: UpdateSpeedFreak(client);
		case 11: UpdateHealingAura(client);
		case 12: UpdateSoulShield(client);
		case 13: UpdatePolyMorph(client);
		case 14: UpdateInstaGib(client);
	}
}
stock DestroyAbility(client, ability)
{
	switch(ability)
	{
		case 1: DestroyDetectGZ(client);
		case 2: DestroyBerserker(client);
		case 3: DestroyAcidBath(client);
		case 4: DestroyLifeStealer(client);
		case 5: DestroyFlameShield(client);
		case 6: DestroyNightCrawler(client);
		case 7: DestroyRapidFire(client);
		case 8: DestroyChainsawMass(client);
		case 9: DestroyHeatSeeker(client);
		case 10: DestroySpeedFreak(client);
		case 11: DestroyHealingAura(client);
		case 12: DestroySoulShield(client);
		case 13: DestroyPolyMorph(client);
		case 14: DestroyInstaGib(client);
	}
}
stock UpdateBombardment(client, bombardment)
{
	switch(bombardment)
	{
		case 1: UpdateArtillery(client);
		case 2: UpdateIonCannon(client);
		case 3: UpdateNuke(client);
	}
}
stock TimerUpdateClients()
{
	for (new i=1; i<=MaxClients; i++)
	{
		UpdateTimers(i);
		BreederTimer(i);
		UpdateAntiAFK(i);
		NewPlayerJoinGame(i);
		PlayerSpawned(i);
		RecordWeapons(i);
		UpdateRegeneration(i);
		UnfreezeAI(i);
	}
}
stock UnfreezeAI(client)
{
	if (IsSurvivor(client))
	{
		if (IsPlayerSpawned(client))
		{
			if (!IsPlayerInSaferoom(client, 0))
			{
				if (bFreezeAI == true)
				{
					bFreezeAI = false;
				}
			}
		}
	}
}
stock PlayerSpawned(client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client) && PlayerSpawn[client] == 0)
	{
		if (!IsFakeClient(client))
		{
			JetPackAscend[client] = false;
			JetPackDescend[client] = false;
			JetPackFlight[client] = false;
			JetPackParticleTimer[client] = 0;
			JetPackFuel[client] = 480;
			JetPackJump[client] = 0;
			JetPackIdle[client] = 0;
			JetPackIdleOrigin[client][0] = 0.0;
			JetPackIdleOrigin[client][1] = 0.0;
			JetPackIdleOrigin[client][2] = 0.0;
			JetPackDisrupt[client] = 0;
			if (JetPackEquip[client] == 1 && bIsFinale && iFinaleStage > 0 && !bNightmare)
			{
				JetPackOn[client] = 1;
			}
			else
			{
				JetPackOn[client] = 0;
			}

			WeaponsRestored[client] = 0;
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
		}
		PlayerSpawn[client] = 1;
		CreateTimer(1.0, PlayerInGameTimer, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}
public Action:PlayerInGameTimer(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client) && PlayerSpawn[client] == 1)
	{
		PlayerSpawn[client] = 2;
	}
}
stock UpdateAntiAFK(client)
{
	if ((IsSurvivor(client) || IsSpectator(client)) && !IsFakeClient(client))
	{
		new team = GetClientTeam(client);
		new Float:Angles[3];
		GetClientAbsAngles(client, Angles);
		if (Angles[0] == AFKAngles[client][0] && Angles[1] == AFKAngles[client][1] && Angles[2] == AFKAngles[client][2])
		{
			new time;
			switch(team)
			{
				case 1: time = 180;
				case 2: time = 90;
			}
			AFKTime[client] += 1;
			if (AFKTime[client] >= time)
			{
				switch(team)
				{
					case 1:
					{
						if (GetUserFlagBits(client) == 0)
						{
							AFKTime[client] = 0;
							KickClient(client, "AFK Timeout");
						}
					}
					case 2:
					{
						AFKTime[client] = 0;
						ChangeClientTeam(client, 1);
						CreateTimer(0.1, SetPlayerSpawnFlag, client, TIMER_FLAG_NO_MAPCHANGE);
						PrintToChat(client, "\x05[Lethal-Injection]\x01 You have been switched to a spectator for being AFK.");
					}
				}
			}
		}
		else
		{
			switch(team)
			{
				case 1:
				{
					AFKTime[client] = 0;
					GetClientAbsAngles(client, AFKAngles[client]);
				}
				case 2:
				{
					AFKTime[client] = 0;
					GetClientAbsAngles(client, AFKAngles[client]);
				}
			}
		}
	}
}
public Action:SetPlayerSpawnFlag(Handle:timer, any:client)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 1)
	{
		PlayerSpawn[client] = 0;
	}
}
stock SpawnInfectedInterval()
{
	if (bFreezeAI) return;

	iSpawnBotTick += 1;
	new spawninterval = GetRandomInt(iSpecialMin,iSpecialMax);
	if (iSpawnBotTick >= spawninterval)
	{
		if (CountSI() < iSpecialAmount)
		{
			SpawnInfectedBot();
		}
		iSpawnBotTick = 0;
	}
}
stock SpawnInfectedBot()
{
	if (CountTotal() < 29)
	{
		new bot = CreateFakeClient("Smoker");
		if (bot > 0)
		{
			new random = GetRandomInt(1,6);
			SpawnInfected(bot, random, true);
		}
	}
}
stock SpawnInfected(client, class, bool:bAuto)
{
	new bool:resetGhostState[MaxClients+1];
	new bool:resetIsAlive[MaxClients+1];
	new bool:resetLifeState[MaxClients+1];
	ChangeClientTeam(client, 3);
	new String:classname[16];
	new String:options[32];
	switch(class)
	{
		case 1: classname = "smoker";
		case 2: classname = "boomer";
		case 3: classname = "hunter";
		case 4: classname = "spitter";
		case 5: classname = "jockey";
		case 6: classname = "charger";
		case 8: classname = "tank";
	}
	if (class == 7 || (class < 1 || class > 8)) return false;
	if (GetClientTeam(client) != 3) return false;
	if (!IsClientInGame(client)) return false;
	if (IsPlayerAlive(client)) return false;
	
	for (new i=1; i<=MaxClients; i++)
	{ 
		if (i == client) continue; //dont disable the chosen one
		if (!IsClientInGame(i)) continue; //not ingame? skip
		if (GetClientTeam(i) != 3) continue; //not infected? skip
		if (IsFakeClient(i)) continue; //a bot? skip
		
		if (IsPlayerGhost(i))
		{
			resetGhostState[i] = true;
			SetPlayerGhostStatus(i, false);
			resetIsAlive[i] = true; 
			SetPlayerIsAlive(i, true);
		}
		else if (!IsPlayerAlive(i))
		{
			resetLifeState[i] = true;
			SetPlayerLifeState(i, false);
		}
	}
	if (bAuto)
	{
		Format(options, sizeof(options), "%s auto", classname);
		CheatCommand(client, "z_spawn_old", options);
	}
	else
	{
		decl Float:Origin[3], Float:Angles[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);
		ForceSpawnInfected(classname, Origin, Angles);
	}
	if (IsFakeClient(client)) KickClient(client);
	for (new i=1; i<=MaxClients; i++)
	{
		if (resetGhostState[i]) SetPlayerGhostStatus(i, true);
		if (resetIsAlive[i]) SetPlayerIsAlive(i, false);
		if (resetLifeState[i]) SetPlayerLifeState(i, true);
	}
	return true;
}
stock InfectedChangeClass(client, class)
{
	if (client > 0)
	{
		if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
		{
			if (class > 0 && class <= 6)
			{
				new claw = GetPlayerWeaponSlot(client, 0);
				if (IsValidEntity(claw))
				{
					RemovePlayerItem(client, claw);
				}
				L4D2_SetClass(client, class);
				AcceptEntityInput(GetEntPropEnt(client, Prop_Send, "m_customAbility"),"Kill");
				SetEntProp(client, Prop_Send, "m_customAbility", GetEntData(L4D2_CreateAbility(client), L4D2_RefEntityHandle()));
			}
		}
	}
}
stock InfectedForceGhost(client)
{
	if (client > 0)
	{
		if (IsClientInGame(client) && !IsFakeClient(client) && !IsPlayerGhost(client) && GetClientTeam(client) == 3)
		{
			L4D2_StateTransition(client);
			L4D2_BecomeGhost(client);
			L4D2_FlashLightTurnOn(client);
		}
	}
}
stock bool:IsMissionFinalMap()
{
	if (L4D2_IsMissionFinalMap())
	{
		PrintToServer("IsMissionFinalMap(): true");
		return true;
	}
	PrintToServer("IsMissionFinalMap(): false");
	return false;
}
stock SetGameDifficulty()
{
	decl String:GameDifficulty[16];
	GetConVarString(FindConVar("z_difficulty"), GameDifficulty, sizeof(GameDifficulty));
	if (StrEqual(GameDifficulty, "Easy", false))
	{
		iDifficulty = 1;
	}
	else if (StrEqual(GameDifficulty, "Normal", false))
	{
		iDifficulty = 2;
	}
	else if (StrEqual(GameDifficulty, "Hard", false))
	{
		iDifficulty = 3;
	}
	else if (StrEqual(GameDifficulty, "Impossible", false))
	{
		iDifficulty = 4;
	}
}
stock GetXPDiff(type)
{
	switch(iDifficulty)
	{
		case 1: return 1;
		case 2: return 2;
		case 3: return 3;
		case 4:
		{
			if (bCowLevel)
			{
				if (type == 1)
				{
					return 100;
				}
				return 1;
			}
			else if (bInferno)
			{
				return 10;
			}
			else if (bHell)
			{
				return 7;
			}
			else if (bBloodmoon)
			{
				return 5;
			}
			else
			{
				return 4;
			}
		}
	}
	return 1;
}
stock GetBonusXPPool()
{
	new amount = 0;
	new Float:bonus = 0.0;
	new givers = 0;
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsSurvivor(i) && !IsFakeClient(i))
		{
			amount++;
			if (cLevel[i] == 50)
			{
				givers++;
				bonus += cCampaignBonus[i];
			}
		}
	}
	amount = amount - givers;
	if (amount > 0 && givers > 0)
	{
		new division;
		switch(amount)
		{
			case 1: division = 1;
			case 2: division = 2;
			case 3: division = 3;
			case 4: division = 4;
			case 5: division = 5;
			case 6: division = 6;
			case 7: division = 7;
			case 8: division = 8;
			case 9: division = 9;
			case 10: division = 10;
			case 11: division = 11;
		}
		amount = RoundToFloor(bonus/division);
		if (amount > 0)
		{
			return amount;
		}
	}
	return 0;
}
stock GiveXP(client, amount)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 2)
	{
		new level = cLevel[client];
		if (level < 50)
		{
			new xp = cExp[client];
			new xptolevel = cExpToLevel[client];
			if ((xp + amount) >= xptolevel)
			{
				cExp[client] += amount;
				cExp_accum[client] += amount;
				if (ReadWriteDelay[client] == 0)
				{
					new String:steamid[24];
					GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
					ReadWriteDelay[client] = 1;
					ReadWriteDB(steamid, client, cExp_accum[client], cLevel_accum[client], cVoteAccess_accum[client], cLevelReset[client]);
				}
			}
			else
			{
				cExp[client] += amount;
				cExp_accum[client] += amount;
			}
			cCampaignBonus[client] += amount;
		}
		else
		{
			cCampaignBonus[client] += amount;
		}
	}
}
stock ExpToLevel(leveldata)
{
	new xp = 0;
	for (new level=0; level<=50; level++)
	{
		new exp = 0;
		if (level == 0)
		{
			exp = 400;
			xp = exp;
			exp = xp + ((level+1) * 400);
		}
		else if (level == 50)
		{
			exp = 0;
		}
		else
		{
			exp = xp + ((level * 400) + ((level+1) * 400));
			xp = exp;
		}
		if (leveldata == level)
		{
			return exp;
		}
	}
	return 0;
}
public Action:ResetLevelUpMessage(Handle:timer, any:client)
{
	if (cLevelUpMessage[client] == 1)
	{
		cLevelUpMessage[client] = 0;
		GiveXP(client, 0);
	}
}
stock DisplayLevelUp(client, level)
{
	if (client > 0 && IsClientInGame(client))
	{
		//level = level + 1;
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && i != client)
			{
				PrintToChat(i, "\x04[LEVEL-UP]\x01 Player \x04%N\x01 has reached level \x03%i\x01!", client, level);
			}
		}
		PrintToChat(client, "\x04[LEVEL-UP]\x01 Congratulations, you have reached level \x03%i\x01!", level);
		switch(level)
		{
			case 1:
			{
				PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Deployables Menu");
				PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Deployables Information");
				PrintToChat(client, "\x04[LEVEL-UP]\x01 New Deployable: \x03Ammo Pile");
			}
			case 2:
			{
				PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Skills Information");
				PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Acrobatics");
			}
			case 3:
			{
				PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Abilities Menu");
				PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Abilities Information");
				PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Detect Zombie");
			}
			case 4: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Medic");
			case 5: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Berserker");
			case 6: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Pack Rat");
			case 7:	PrintToChat(client, "\x04[LEVEL-UP]\x01 New Deployable: \x03UV Light");
			case 8: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Desert Cobra");
			case 9: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Acid Bath");
			case 10: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Gene Mutations");
			case 11: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Self Revive");
			case 12: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Lifestealer");
			case 13: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Sleight of Hand");
			case 14: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Deployable: \x03High Frequency Emitter");
			case 15: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Knife");
			case 16: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Flameshield");
			case 17: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Hard to Kill");
			case 18: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Nightcrawler");
			case 19: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Arms Dealer");
			case 20: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Gene Mutations II");
			case 21: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Deployable: \x03Healing Station");
			case 22: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Surgeon");
			case 23: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Rapid Fire");
			case 24: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Extreme Conditioning");
			case 25: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Chainsaw Massacre");
			case 26: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03BullsEye");
			case 27: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Heat Seeker");
			case 28:
			{
				 PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Sentry Control Menu");
				 PrintToChat(client, "\x04[LEVEL-UP]\x01 New Deployable: \x03Sentry Gun");
			}
			case 29: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Size Matters");
			case 30: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Gene Mutations III");
			case 31: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Speed Freak");
			case 32: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Master at Arms");
			case 33: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Healing Aura");
			case 34: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Deployable: \x03Resurrection Bag");
			case 35: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Hardened Stance");
			case 36:
			{
				 PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Bombardments Menu");
				 PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Bombardments Information");
				 PrintToChat(client, "\x04[LEVEL-UP]\x01 New Bombardment: \x03Artillery Barrage");
			}
			case 37: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Soulshield");
			case 38: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Critical Hit!");
			case 39: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Polymorph");
			case 40: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Gene Mutations IV");
			case 41: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Commando");
			case 42: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Deployable: \x03Defense Grid");
			case 43: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Bombardment: \x03Ion Cannon");
			case 44: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Second Chance");
			case 45:
			{
				 PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Specials Menu");
				 PrintToChat(client, "\x04[LEVEL-UP]\x01 New Menu: \x03Specials Information");
				 PrintToChat(client, "\x04[LEVEL-UP]\x01 New Special: \x03Shoulder Cannon");
			}
			case 46: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Ability: \x03Instagib");
			case 47: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Skill: \x03Laser Rounds");
			case 48: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Bombardment: \x03Nuclear Strike");
			case 49: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Special: \x03Jetpack");
			case 50: PrintToChat(client, "\x04[LEVEL-UP]\x01 New Special: \x03Hats");
		}
	}
}
stock SetPlayerGhostStatus(client, bool:ghost)
{
	if(ghost){	
		SetEntProp(client, Prop_Send, "m_isGhost", 1, 1);
	}else{
		SetEntProp(client, Prop_Send, "m_isGhost", 0, 1);
	}
}
stock SetPlayerIsAlive(client, bool:alive)
{
	new offset = FindSendPropInfo("CTransitioningPlayer", "m_isAlive");
	if (alive) SetEntData(client, offset, 1, 1, true);
	else SetEntData(client, offset, 0, 1, true);
}
stock SetPlayerLifeState(client, bool:ready)
{
	if (ready) SetEntProp(client, Prop_Data, "m_lifeState", 1, 1);
	else SetEntProp(client, Prop_Data, "m_lifeState", 0, 1);
}
stock RGB_TO_INT(red, green, blue) 
{
	return (blue * 65536) + (green * 256) + red;
}
stock GetEntityRenderColor(client)
{
	if (client > 0)
	{
		new offset = GetEntSendPropOffs(client, "m_clrRender");
		new r = GetEntData(client, offset, 1);
		new g = GetEntData(client, offset+1, 1);
		new b = GetEntData(client, offset+2, 1);
		decl String:rgb[10];
		Format(rgb, sizeof(rgb), "%i%i%i", r, g, b);
		new color = StringToInt(rgb);
		return color;
	}
	return 0;	
}
stock GetEntityGlowColor(client)
{
	if (client > 0)
	{
		new offset = GetEntSendPropOffs(client, "m_Glow");
		new r = GetEntData(client, offset+16, 1);
		new g = GetEntData(client, offset+17, 1);
		new b = GetEntData(client, offset+18, 1);
		decl String:rgb[10];
		Format(rgb, sizeof(rgb), "%i%i%i", r, g, b);
		new color = StringToInt(rgb);
		return color;
	}
	return 0;	
}
stock ResetInfectedAbility(client, Float:time)
{
	if (client > 0)
	{
		if (IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 3)
		{
			new ability = GetEntPropEnt(client, Prop_Send, "m_customAbility");
			if (ability > 0)
			{
				SetEntPropFloat(ability, Prop_Send, "m_duration", time);
				SetEntPropFloat(ability, Prop_Send, "m_timestamp", GetGameTime() + time);
			}
		}
	}
}
stock ResetClassAbility(client)
{
	if (IsSpecialInfected(client))
	{
		new class = GetZombieClass(client);
		switch(class)
		{
			case 1: ResetInfectedAbility(client, 15.0);
			case 2: ResetInfectedAbility(client, 20.0);
			case 3: ResetInfectedAbility(client, 8.0);
			case 4: ResetInfectedAbility(client, 20.0);
			case 5: ResetInfectedAbility(client, 30.0);
			case 6: ResetInfectedAbility(client, 12.0);
		}
	}
}
stock bool:IsMeleeEquipped(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl String:classname[16];
		GetClientWeapon(client, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_melee", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsM16Equipped(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl String:classname[16];
		GetClientWeapon(client, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_rifle", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsGLEquipped(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl String:classname[26];
		GetClientWeapon(client, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_grenade_launcher", false))
		{
			return true;
		}
	}
	return false;
}
stock bool:IsRifleEquipped(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl String:classname[24];
		GetClientWeapon(client, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_rifle", false) || StrEqual(classname, "weapon_rifle_desert", false) || StrEqual(classname, "weapon_rifle_ak47", false) || StrEqual(classname, "weapon_rifle_sg552", false))
		{
			return true;
		}
	}
	return false;
}
public Action:SpawnTankTimer(Handle:timer)
{
	if (iNumTanksWave > 0 && bIsFinale)
	{
		new bot = CreateFakeClient("Tank");
		if (bot > 0)
		{
			SpawnInfected(bot, 8, true);
		}
	}
}
stock GetPortPoint()
{
	if (bIsFinale)
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "prop_door_rotating_checkpoint")) != INVALID_ENT_REFERENCE)
		{
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", PortPoint);
		}
	}
}
stock EnableFogRealism()
{
	if (bBloodmoon || bHell || bInferno || bNightmare)
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "env_fog_controller")) != INVALID_ENT_REFERENCE)
		{
			SetEntPropFloat(entity, Prop_Data, "m_fog.start", 242.0);
			SetEntPropFloat(entity, Prop_Data, "m_fog.end", 730.0);
			PrintToServer("fog %i set to 242.0 and 730.0", entity);
			AcceptEntityInput(entity, "StartFogTransition");
			//PrintToChatAll("Fog Entity %i saved under index %i", entity, index);
		}
		SetConVarInt(FindConVar("sv_force_time_of_day"), 3);
		UnlockSRDoor();
	}
	else if (bCowLevel)
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "env_fog_controller")) != INVALID_ENT_REFERENCE)
		{
			SetEntPropFloat(entity, Prop_Data, "m_fog.start", 50.0);
			SetEntPropFloat(entity, Prop_Data, "m_fog.end", 440.0);
			PrintToServer("fog %i set to 50.0 and 440.0", entity);
			AcceptEntityInput(entity, "StartFogTransition");
			//PrintToChatAll("Fog Entity %i saved under index %i", entity, index);
		}
		SetConVarInt(FindConVar("sv_force_time_of_day"), 3);
		UnlockSRDoor();
	}
}
stock DisableFogRealism()
{
	new entity = -1;
	new index = 0;
	while ((entity = FindEntityByClassname(entity, "env_fog_controller")) != INVALID_ENT_REFERENCE)
	{
		SetEntPropFloat(entity, Prop_Data, "m_fog.start", aFogStart[index]);
		SetEntPropFloat(entity, Prop_Data, "m_fog.end", aFogEnd[index]);
		AcceptEntityInput(entity, "StartFogTransition");
		PrintToServer("fog %i set to %f and %f", entity, aFogStart[index], aFogEnd[index]);
		//PrintToChatAll("Fog Entity %i restored under index %i", entity, index);
		index++;
	}
	while ((entity = FindEntityByClassname(entity, "color_correction")) != INVALID_ENT_REFERENCE)
	{
		if (entity == iCCEnt)
		{
			AcceptEntityInput(entity, "Disable");
			SetVariantString("OnUser1 !self:Kill::4.0:-1");
			AcceptEntityInput(entity, "AddOutput");
			AcceptEntityInput(entity, "FireUser1");
		}
	}
	while ((entity = FindEntityByClassname(entity, "fog_volume")) != INVALID_ENT_REFERENCE)
	{
		if (entity == iFogVolEnt)
		{
			AcceptEntityInput(entity, "Disable");
			SetVariantString("OnUser1 !self:Kill::4.0:-1");
			AcceptEntityInput(entity, "AddOutput");
			AcceptEntityInput(entity, "FireUser1");
		}
		else
		{
			new hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
			if (hammerid != 3131004 && hammerid != 800572 && hammerid != 2292555 && hammerid != 1616857 && hammerid != 13058 && 
			hammerid != 2733982)
			{
				AcceptEntityInput(entity, "Enable");
			}
		}
	}
	iCCEnt = 0;
	iFogVolEnt = 0;
	SetConVarInt(FindConVar("sv_force_time_of_day"), timeofday);

	if (bNightmare)
	{
		iGameMode = 10;
	}
	else if (bCowLevel)
	{
		iGameMode = 9;
	}
	else if (bInferno)
	{
		iGameMode = 8;
	}
	else if (bHell)
	{
		iGameMode = 6;
	}
	else if (bBloodmoon)
	{
		iGameMode = 5;
	}
	else
	{
		iGameMode = 0;
	}
}
stock RenableFogRealism()
{
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "color_correction")) != INVALID_ENT_REFERENCE)
	{
		if (entity == iCCEnt)
		{
			AcceptEntityInput(entity, "Disable");
			SetVariantString("OnUser1 !self:Kill::4.0:-1");
			AcceptEntityInput(entity, "AddOutput");
			AcceptEntityInput(entity, "FireUser1");
		}
	}
	while ((entity = FindEntityByClassname(entity, "fog_volume")) != INVALID_ENT_REFERENCE)
	{
		if (entity == iFogVolEnt)
		{
			AcceptEntityInput(entity, "Disable");
			SetVariantString("OnUser1 !self:Kill::4.0:-1");
			AcceptEntityInput(entity, "AddOutput");
			AcceptEntityInput(entity, "FireUser1");
		}
		else
		{
			new hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
			if (hammerid != 3131004 && hammerid != 800572 && hammerid != 2292555 && hammerid != 1616857 && hammerid != 13058 && 
			hammerid != 2733982)
			{
				AcceptEntityInput(entity, "Enable");
			}
		}
	}
	iCCEnt = 0;
	iFogVolEnt = 0;
	if (bNightmare)
	{
		iGameMode = 10;
	}
	else if (bCowLevel)
	{
		iGameMode = 9;
	}
	else if (bInferno)
	{
		iGameMode = 8;
	}
	else if (bHell)
	{
		iGameMode = 6;
	}
	else if (bBloodmoon)
	{
		iGameMode = 5;
	}
	else
	{
		iGameMode = 0;
	}
	if (bBloodmoon || bHell || bInferno || bNightmare)
	{
		while ((entity = FindEntityByClassname(entity, "env_fog_controller")) != INVALID_ENT_REFERENCE)
		{
			SetEntPropFloat(entity, Prop_Data, "m_fog.start", 242.0);
			SetEntPropFloat(entity, Prop_Data, "m_fog.end", 730.0);
			AcceptEntityInput(entity, "StartFogTransition");
			PrintToServer("fog %i set to 242.0 and 730.0", entity);
			//PrintToChatAll("Fog Entity %i saved under index %i", entity, index);
		}
		SetConVarInt(FindConVar("sv_force_time_of_day"), 3);
		UnlockSRDoor();
	}
	else if (bCowLevel)
	{
		while ((entity = FindEntityByClassname(entity, "env_fog_controller")) != INVALID_ENT_REFERENCE)
		{
			SetEntPropFloat(entity, Prop_Data, "m_fog.start", 50.0);
			SetEntPropFloat(entity, Prop_Data, "m_fog.end", 440.0);
			AcceptEntityInput(entity, "StartFogTransition");
			PrintToServer("fog %i set to 50.0 and 440.0", entity);
			//PrintToChatAll("Fog Entity %i saved under index %i", entity, index);
		}
		SetConVarInt(FindConVar("sv_force_time_of_day"), 3);
		UnlockSRDoor();
	}
}
stock CreateColorCorrection(String:FileName[])
{
	decl String:tName[8];
	if (iCCEnt <= 0)
	{
		new colorent = CreateEntityByName("color_correction");
		if (colorent > 32 && IsValidEntity(colorent))
		{
			DispatchKeyValue(colorent, "spawnflags", "2");
			if (bInferno || bNightmare || bCowLevel)
			{
				DispatchKeyValue(colorent, "maxweight", "0.7");
			}
			else if (bBloodmoon)
			{
				DispatchKeyValue(colorent, "maxweight", "0.4");
			}
			else
			{
				DispatchKeyValue(colorent, "maxweight", "0.6");
			}
			DispatchKeyValue(colorent, "fadeInDuration", "4");
			DispatchKeyValue(colorent, "fadeOutDuration", "4");
			DispatchKeyValue(colorent, "maxfalloff", "-1");
			DispatchKeyValue(colorent, "minfalloff", "-1");
			DispatchKeyValue(colorent, "filename", FileName);
			DispatchSpawn(colorent);
			ActivateEntity(colorent);
			AcceptEntityInput(colorent, "Enable");

			Format(tName, sizeof(tName), "CC%i", colorent);
			DispatchKeyValue(colorent, "targetname", tName);
			iCCEnt = colorent;

			new Float:Origin[3] = {0.0, 0.0, 0.0};
			TeleportEntity(colorent, Origin, NULL_VECTOR, NULL_VECTOR);
			//PrintToServer("Color correction %i created", colorent);
		}
	}
	if (iFogVolEnt == 0 || iFogVolEnt == -1)
	{
		new fogent = CreateEntityByName("fog_volume");
		if (fogent != -1)
		{
			DispatchKeyValue(fogent, "ColorCorrectionName", tName);
			DispatchKeyValue(fogent, "spawnflags", "0");

			DispatchSpawn(fogent);
			ActivateEntity(fogent);
			AcceptEntityInput(fogent, "Enable");

			new Float:vMins[3] = {-99999.0, -99999.0, -99999.0};
			new Float:vMaxs[3] = {99999.0, 99999.0, 99999.0};
			new Float:Origin[3] = {0.0, 0.0, 0.0};

			SetEntPropVector(fogent, Prop_Send, "m_vecMins", vMins);
			SetEntPropVector(fogent, Prop_Send, "m_vecMaxs", vMaxs);
			iFogVolEnt = fogent;

			TeleportEntity(fogent, Origin, NULL_VECTOR, NULL_VECTOR);
			//PrintToServer("Fog Volume %i created", fogent);
		}
	}
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "fog_volume")) != INVALID_ENT_REFERENCE)
	{
		if (entity != iFogVolEnt)
		{
			AcceptEntityInput(entity, "Disable");
		}
	}
}

stock CreatePrecipitation()
{
	if (iPrecipitation <= 0)
	{
		new entity = CreateEntityByName("func_precipitation");
		if (entity > 32 && IsValidEntity(entity))
		{
			decl String:sMap[48], Float:vMins[3], Float:vMaxs[3], Float:Origin[3];

			GetCurrentMap(sMap, sizeof(sMap));
			Format(sMap, sizeof(sMap), "maps/%s.bsp", sMap);
			PrecacheModel(sMap, true);

			DispatchKeyValue(entity, "model", sMap);
			DispatchKeyValue(entity, "preciptype", "3"); //1=rain 2=ash 3=snow 4=rain(l4d)

			GetEntPropVector(0, Prop_Data, "m_WorldMaxs", vMaxs);
			GetEntPropVector(0, Prop_Data, "m_WorldMins", vMins);

			SetEntPropVector(entity, Prop_Send, "m_vecMins", vMins);
			SetEntPropVector(entity, Prop_Send, "m_vecMaxs", vMaxs);

			Origin[0] = vMins[0] + vMaxs[0];
			Origin[1] = vMins[1] + vMaxs[1];
			Origin[2] = vMins[2] + vMaxs[2];

			DispatchSpawn(entity);
			ActivateEntity(entity);
			TeleportEntity(entity, Origin, NULL_VECTOR, NULL_VECTOR);
			iPrecipitation = entity;
			//PrintToServer("func_precipitation %i created", entity);
		}
	}
}
stock ExecGameModes()
{
	new blind = GetConVarInt(FindConVar("nb_blind"));
	if (bFreezeAI && blind == 0)
	{
		SetConVarInt(FindConVar("nb_blind"), 1);
	}
	else if (!bFreezeAI && blind == 1)
	{
		SetConVarInt(FindConVar("nb_blind"), 0);
	}
	if (iFogControl == 0)
	{
		new index = 0;
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "env_fog_controller")) != INVALID_ENT_REFERENCE)
		{
			aFogStart[index] = GetEntPropFloat(entity, Prop_Data, "m_fog.start");
			aFogEnd[index] = GetEntPropFloat(entity, Prop_Data, "m_fog.end");
			PrintToServer("fog %i saved at %f and %f", entity, aFogStart[index], aFogEnd[index]);
			index++;
		}
		timeofday = GetConVarInt(FindConVar("sv_force_time_of_day"));
		iFogControl = 1;
	}
	if (bNightmare)
	{
		if (iGameMode != 10)
		{
			if (!bInferno)
			{
				RenableFogRealism();
			}
		}
		if (iFogControl == 1)
		{
			RenableFogRealism();
			iFogControl = 2;
		}
	}
	else if (bCowLevel)
	{
		if (iGameMode != 9)
		{
			RenableFogRealism();
		}
		if (!bNightmare)
		{
			ExecCowLevel();
		}
		if (iFogControl == 1)
		{
			RenableFogRealism();
			iFogControl = 2;
		}
	}
	else if (bInferno)
	{
		if (iGameMode != 8)
		{
			RenableFogRealism();
		}
		if (!bNightmare)
		{
			ExecInferno();
		}
		if (iFogControl == 1)
		{
			RenableFogRealism();
			iFogControl = 2;
		}
	}
	else if (bHell)
	{
		if (iGameMode != 6)
		{
			RenableFogRealism();
		}
		if (!bNightmare)
		{
			ExecHell();
		}
		if (iFogControl == 1)
		{
			RenableFogRealism();
			iFogControl = 2;
		}
	}
	else if (bBloodmoon)
	{
		if (iGameMode != 5)
		{
			RenableFogRealism();
		}
		if (!bNightmare)
		{
			ExecBloodmoon();
		}
		if (iFogControl == 1)
		{
			RenableFogRealism();
			iFogControl = 2;
		}
	}
	else
	{
		if (iGameMode != 0)
		{
			DisableFogRealism();
		}
		if (iFogControl == 1)
		{
			DisableFogRealism();
			iFogControl = 2;
		}
	}
	if (bIsFinale && !bNightmare)
	{
		if (iFinaleStage > 0)
		{
			new numsurvivors = CountSurvivorsAll();
			iFinaleCountdown += 1;
			if (iFinaleCountdown == 30)
			{
				if (bIsGauntletFinale())
				{
					iNumTanksWave += 1;
					CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else if (iFinaleCountdown == 60)
			{
				if (bIsGauntletFinale())
				{
					if (numsurvivors > 4)
					{
						iNumTanksWave += 2;
					}
					else
					{
						iNumTanksWave += 1;
					}
					CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else if (iFinaleCountdown == 90)
			{
				if (bIsGauntletFinale())
				{
					if (numsurvivors > 4)
					{
						iNumTanksWave += 2;
					}
					else
					{
						iNumTanksWave += 1;
					}
					CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else if (iFinaleCountdown == 120)
			{
				iNumTanksWave += 1;
				CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
			}
			else if (iFinaleCountdown == 150)
			{
				if (bIsGauntletFinale())
				{
					if (numsurvivors > 4)
					{
						iNumTanksWave = 3;
					}
					else
					{
						iNumTanksWave += 2;
					}
					CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else if (iFinaleCountdown == 200)
			{
				if (bIsGauntletFinale())
				{
					if (numsurvivors > 4)
					{
						iNumTanksWave += 3;
					}
					else
					{
						iNumTanksWave += 2;
					}
					CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else if (iFinaleCountdown == 240)
			{
				if (numsurvivors > 4)
				{
					iNumTanksWave += 2;
				}
				else
				{
					iNumTanksWave += 1;
				}
				CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
			}
			else if (iFinaleCountdown == 360)
			{
				if (numsurvivors > 8)
				{
					iNumTanksWave += 3;
				}
				else if (numsurvivors > 4)
				{
					iNumTanksWave += 2;
				}
				else
				{
					iNumTanksWave += 1;
				}
				CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
			}
			else if (iFinaleCountdown == 500)
			{
				if (numsurvivors > 8)
				{
					iNumTanksWave += 4;
				}
				else if (numsurvivors > 4)
				{
					iNumTanksWave += 3;
				}
				else
				{
					iNumTanksWave += 2;
				}
				CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
			}
			else if (iFinaleCountdown == 666)
			{
				iRescue = 1;
				L4D2_SendInRescueVehicle();
				iNumTanksWave += 666;
				CreateTimer(0.1, SpawnTankTimer, _, TIMER_FLAG_NO_MAPCHANGE);
				if (iNightmareBegin == 0)
				{
					SetConVarInt(hNightmareBegin, 1);
				}
				iRescue = 0;
			}
			else if (iFinaleCountdown > 666)
			{
				if (iNightmareBegin == 0)
				{
					SetConVarInt(hNightmareBegin, 1);
				}
			}
		}
	}
	ExecNightmare();
}
public Action:L4D2_OnChangeFinaleStage(&finaleType, const String:arg[])
{
	if (finaleType != 1 && finaleType != 7)
	{
		L4D2_ChangeFinaleStage(7, "666");
	}
	return Plugin_Continue;
}
public Action:L4D2_OnSendInRescueVehicle()
{
	PrintToServer("L4D2_OnSendInRescueVehicle entered");
	if (iRescue == 0)
	{
		MsgAdmin("Rescue Called");
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
stock MsgAdmin(String:msg[])
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) && IsAdmin(i))
		{
			PrintToChat(i, msg);
		}
	}
}
stock bool:IsAdmin(client) 
{ 
    	if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, false)) 
    	{ 
        	return true; 
    	} 
    	return false; 
} 
stock ExecBloodmoon()
{
	if (bBloodmoon)
	{
		new random = GetRandomInt(1,20);
		if (random == 1)
		{
			EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
		}
		if (!bIsFinale)
		{
			if (iNumTanks < 1 && iMapTimeTick > 10)
			{
				new bot = CreateFakeClient("Tank");
				if (bot > 0)
				{
					SpawnInfected(bot, 8, true);
				}
			}
		}
		random = GetRandomInt(1,25);
		if (!bFreezeAI && random == 1)
		{
			CreateBreederEvent();
		}
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				DirectorCommand(i, "director_force_panic_event");
				break;
			}
		}
		if (iCCEnt <= 0)
		{
			CreateColorCorrection("materials/correction/ghost.pwl.raw");
		}
		if (iPrecipitation <= 0)
		{
			CreatePrecipitation();
		}
	}	
}
stock ExecHell()
{
	if (bHell)
	{
		new random = GetRandomInt(1,20);
		if (random == 1)
		{
			EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
		}
		if (!bIsFinale)
		{
			if (iNumTanks < 1 && iMapTimeTick > 10)
			{
				new bot = CreateFakeClient("Tank");
				if (bot > 0)
				{
					SpawnInfected(bot, 8, true);
				}
			}
		}
		new witchcount = CountWitches();
		if (witchcount < 33)
		{
			CreateWitchEvent();
			if (witchcount < 20)
			{
				CreateWitchEvent();
			}
		}
		RecycleWitches();
		EnrageWitches();
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				DirectorCommand(i, "director_force_panic_event");
				break;
			}
		}
		if (iCCEnt <= 0)
		{
			CreateColorCorrection("materials/correction/infected.pwl.raw");
		}
	}	
}
stock ExecInferno()
{
	if (bInferno)
	{
		new random = GetRandomInt(1,15);
		if (random == 1)
		{
			EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
		}
		if (!bIsFinale)
		{
			if (iNumTanks < 3 && iMapTimeTick > 10)
			{
				new bot = CreateFakeClient("Tank");
				if (bot > 0)
				{
					SpawnInfected(bot, 8, true);
				}
			}
		}
		random = GetRandomInt(1,60);
		if (!bFreezeAI && random == 1)
		{
			CreateInstaCapperEvent();
		}
		new witchcount = CountWitches();
		if (witchcount < 66)
		{
			CreateWitchEvent();
			if (witchcount < 50)
			{
				CreateWitchEvent();
				if (witchcount < 40)
				{
					CreateWitchEvent();
					if (witchcount < 30)
					{
						CreateWitchEvent();
						if (witchcount < 20)
						{
							CreateWitchEvent();
						}
					}
				}
			}
		}
		RecycleWitches();
		EnrageWitches();
		RemoveZombies();
		for (new j=1; j<=6; j++)
		{
			EnrageWitches();
		}
		InfernoMeteorFall();
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				DirectorCommand(i, "director_force_panic_event");
				break;
			}
		}
		if (iCCEnt <= 0)
		{
			CreateColorCorrection("materials/correction/urban_night_red.pwl.raw");
		}
	}	
}
stock ExecCowLevel()
{
	if (bCowLevel)
	{
		LoadCowSpawns();
		RemoveNonZombies();
		new random = GetRandomInt(1,15);
		if (random == 1)
		{
			EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
		}
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				DirectorCommand(i, "director_force_panic_event");
				break;
			}
		}
		if (iCCEnt <= 0)
		{
			CreateColorCorrection("materials/correction/thirdstrike.pwl.raw");
		}
	}	
}
stock ExecNightmare()
{
	if (bNightmare)
	{
		new random = GetRandomInt(1,15);
		if (random == 1)
		{
			EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
		}
		if (iNumTanks < 3)
		{
			new bot = CreateFakeClient("Tank");
			if (bot > 0)
			{
				SpawnInfected(bot, 8, true);
			}
		}
		new witchcount = CountWitches();
		if (witchcount < 66)
		{
			CreateWitchEvent();
			if (witchcount < 50)
			{
				CreateWitchEvent();
				if (witchcount < 40)
				{
					CreateWitchEvent();
					if (witchcount < 30)
					{
						CreateWitchEvent();
						if (witchcount < 20)
						{
							CreateWitchEvent();
						}
					}
				}
			}
		}
		RecycleWitches();
		//RemoveZombies();
		EnrageAllWitches();
		InfernoMeteorFall();
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				DirectorCommand(i, "director_force_panic_event");
				break;
			}
		}
		if (iCCEnt <= 0)
		{
			CreateColorCorrection("materials/correction/urban_night_red.pwl.raw");
		}
	}
	else if (iNightmareBegin == 1)
	{
		//PrintToChatAll("nightmare begins");
		if (iFinaleStage < 4)
		{
			StartCountdown();
		}
	}
	else
	{
		if (bIsFinale)
		{
			if (iFinaleStage <= 0)
			{
				iCountDownTimer = 30;
				iNightmareTick += 1;
				if (iMapTimeTick >= 30)
				{
					if (iNightmareTick >= iNightmareTime)
					{
						SetConVarInt(hNightmareBegin, 1);
					}
				}
			}
			else
			{
				iCountDownTimer = 60;
			}
			
		}
		else
		{
			iCountDownTimer = 30;
			iNightmareTick += 1;
			if (iMapTimeTick >= 30)
			{
				//PrintToServer("Tick: %i, Time: %i",  iNightmareTick, iNightmareTime);
				if (iNightmareTick >= iNightmareTime)
				{
					SetConVarInt(hNightmareBegin, 1);
				}
			}
		}
	}
}
stock StartCountdown()
{
	if (iFinaleStage < 4)
	{
		new amount;
		if (bIsFinale && iFinaleStage > 0)
		{
			amount = 60;
		}
		else
		{
			amount = 30;
		}
		if (iNightmareTick >= 0 && iNightmareTick < amount)
		{
			if (bIsFinale)
			{
				if (iFinaleStage <= 0)
				{
					PrintHintTextToAll("Entering Nightmare mode in %i seconds. You must start the finale!", iCountDownTimer);
				}
				else
				{
					PrintHintTextToAll("Entering Nightmare mode in %i seconds. Get to the escape vehicle!", iCountDownTimer);
				}
			}
			else
			{
				PrintHintTextToAll("Entering Nightmare mode in %i seconds. Get to the saferoom!", iCountDownTimer);
			}
			switch(iCountDownTimer)
			{
				case 5: EmitSoundToAll("ui/beep22.wav");
				case 10: EmitSoundToAll("ui/beep22.wav");	
				case 15: EmitSoundToAll("ui/beep22.wav");
				case 20: EmitSoundToAll("ui/beep22.wav");
				case 25: EmitSoundToAll("ui/beep22.wav");
				case 30: EmitSoundToAll("ui/beep22.wav");
				case 35: EmitSoundToAll("ui/beep22.wav");
				case 40: EmitSoundToAll("ui/beep22.wav");
				case 45: EmitSoundToAll("ui/beep22.wav");
				case 50: EmitSoundToAll("ui/beep22.wav");
				case 55: EmitSoundToAll("ui/beep22.wav");
				case 60: EmitSoundToAll("ui/beep22.wav");
			}
			iCountDownTimer -= 1;
		}
		else if (iNightmareTick == amount)
		{
			PrintHintTextToAll("Time limit reached. Survivor Perks Disabled.");
			SetConVarBool(hNightmare, true);
		}
		else if (iNightmareTick == (amount + 5))
		{
			PrintHintTextToAll("Nightmare mode enabled, Zombies grow stronger!");
			EmitSoundToAll("npc/mega_mob/mega_mob_incoming.wav");
		}
		iNightmareTick += 1;
	}
}
stock NightmareMinutes()
{
	if (iNightmareBegin == 0)
	{
		new minutes;
		new timeleft = iNightmareTime - iNightmareTick;
		if (timeleft < 0) return 0;
		new count;
		for (count=1; count<=30; count++)
		{
			if (timeleft >= 60)
			{
				timeleft -= 60;
				minutes += 1;
			}
		}
		return minutes;
	}
	return 0;
}
stock NightmareSeconds()
{
	if (iNightmareBegin == 0)
	{
		new seconds;
		new timeleft = iNightmareTime - iNightmareTick;
		if (timeleft < 0) return 0;
		new count;
		for (count=1; count<=30; count++)
		{
			if (timeleft >= 60)
			{
				timeleft -= 60;
			}
		}
		seconds = timeleft;
		return seconds;
	}
	return 0;
}
stock FinaleCountdownMinutes()
{
	if (iNightmareBegin == 0)
	{
		new minutes;
		new timeleft = 666 - iFinaleCountdown;
		if (timeleft < 0) return 0;
		new count;
		for (count=1; count<=30; count++)
		{
			if (timeleft >= 60)
			{
				timeleft -= 60;
				minutes += 1;
			}
		}
		return minutes;
	}
	return 0;
}
stock FinaleCountdownSeconds()
{
	if (iNightmareBegin == 0)
	{
		new seconds;
		new timeleft = 666 - iFinaleCountdown;
		if (timeleft < 0) return 0;
		new count;
		for (count=1; count<=30; count++)
		{
			if (timeleft >= 60)
			{
				timeleft -= 60;
			}
		}
		seconds = timeleft;
		return seconds;
	}
	return 0;
}
public Action:ChoiceDelayTimer(Handle:timer, any:client)
{
	ChoiceDelay[client] = 0;
}
public Action:UseDelayTimer(Handle:timer, any:client)
{
	UseDelay[client] = 0;
}
public Action:DesertCobraTimer(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		new weapon = GetPlayerWeaponSlot(client, 1);
		if (weapon > 0)
		{
			new String:classname[14];
			GetEdictClassname(weapon, classname, sizeof(classname));
			if (StrEqual(classname, "weapon_pistol", false))
			{
				RemovePlayerItem(client, weapon);
				CheatCommand(client, "give", "pistol_magnum");
				PrintToChat(client, "\x04[Desert Cobra]\x01 Equipping Magnum Pistol");
			}
		}
	}
}
stock LoadRescueZone()
{
	if (iRescueZone == 0 && bIsFinale)
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "trigger_multiple")) != INVALID_ENT_REFERENCE)
		{
			new hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
			if (hammerid == 33445566)
			{
				HookSingleEntityOutput(entity, "OnStartTouch", RescueZoneStartTouch, false);
				HookSingleEntityOutput(entity, "OnEndTouch", RescueZoneEndTouch, false);
				iRescueZone = 1;
			}
		}
	}
}
public RescueZoneStartTouch(const String:name[], caller, activator, Float:delay) 
{
	if (IsSurvivor(activator) && IsPlayerAlive(activator))
	{
		WaitRescue[activator] = 1;
		//PrintToChat(activator, "1");
	}
}
public RescueZoneEndTouch(const String:name[], caller, activator, Float:delay) 
{
	if (IsSurvivor(activator) && IsPlayerAlive(activator))
	{
		WaitRescue[activator] = 0;
		//PrintToChat(activator, "0");
	}
}
stock LoadCheckpoints()
{
	if (iCheckpoint == 0)
	{
		decl String:sPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sPath, sizeof(sPath), "%s", CONFIG_CHECKPOINTS);
		if (!FileExists(sPath))
		{
			PrintToServer("Error: Cannot read the config %s", sPath);
			iCheckpoint = 1;
			return;
		}
		// Load config
		new Handle:hFile = CreateKeyValues("bounds");
		if (!FileToKeyValues(hFile, sPath))
		{
			PrintToServer("Error: Cannot read the config %s", sPath);
			CloseHandle(hFile);
			iCheckpoint = 1;
			return;
		}
		// Check for current map in the config
		decl String:sMap[64];
		GetCurrentMap(sMap, 64);
		if (!KvJumpToKey(hFile, sMap))
		{
			PrintToServer("Error: Failed to add map to config");
			CloseHandle(hFile);
			iCheckpoint = 1;
			return;
		}
		// Get the information
		KvGetVector(hFile, "start_loc_a", CPStartLocA);
		KvGetVector(hFile, "start_loc_b", CPStartLocB);
		KvGetVector(hFile, "start_loc_c", CPStartLocC);
		KvGetVector(hFile, "start_loc_d", CPStartLocD);
		KvGetVector(hFile, "end_loc_a", CPEndLocA);
		KvGetVector(hFile, "end_loc_b", CPEndLocB);
		KvGetVector(hFile, "end_loc_c", CPEndLocC);
		KvGetVector(hFile, "end_loc_d", CPEndLocD);
		CPStartRotate = KvGetFloat(hFile, "start_rotate", CPStartRotate);
		CPEndRotate = KvGetFloat(hFile, "end_rotate", CPEndRotate);
		if (CPStartLocA[0] == 0.0 && CPStartLocA[1] == 0.0 && CPStartLocA[2] == 0.0)
		{
			PrintToServer("Error: Positions at 0.0");
		}
		else
		{
			if (CPStartLocC[0] != 0.0 && CPStartLocC[1] != 0.0 && CPStartLocC[2] != 0.0 && CPStartLocD[0] != 0.0 && CPStartLocD[1] != 0.0 && CPStartLocD[2] != 0.0) 
			{ 
				bCPStartHasExtraData = true; 
			}
			if (CPEndLocC[0] != 0.0 && CPEndLocC[1] != 0.0 && CPEndLocC[2] != 0.0 && CPEndLocD[0] != 0.0 && CPEndLocD[1] != 0.0 && CPEndLocD[2] != 0.0) 
			{ 
				bCPEndHasExtraData = true; 
			}
        		if (CPStartRotate != 0.0) 
			{
            			RotatePoint(CPStartLocA, CPStartLocB[0], CPStartLocB[1], CPStartRotate);
            			if (bCPStartHasExtraData) 
				{
                			RotatePoint(CPStartLocA, CPStartLocC[0], CPStartLocC[1], CPStartRotate);
                			RotatePoint(CPStartLocA, CPStartLocD[0], CPStartLocD[1], CPStartRotate);
            			}
       	 		}
        		if (CPEndRotate != 0.0) 
			{
            			RotatePoint(CPEndLocA, CPEndLocB[0], CPEndLocB[1], CPEndRotate);
            			if (bCPEndHasExtraData) 
				{
                			RotatePoint(CPEndLocA, CPEndLocC[0], CPEndLocC[1], CPEndRotate);
                			RotatePoint(CPEndLocA, CPEndLocD[0], CPEndLocD[1], CPEndRotate);
            			}
       	 		}
			PrintToServer("Checkpoint Coordinates loaded!");
		}
		CloseHandle(hFile);
		iCheckpoint = 1;
	}
}
stock RotatePoint(Float:origin[3], &Float:pointX, &Float:pointY, Float:angle)
{
    	new Float: newPoint[2];
    	angle = angle / 57.2957795130823;
    
    	newPoint[0] = (Cosine(angle) * (pointX - origin[0])) - (Sine(angle) * (pointY - origin[1]))   + origin[0];
    	newPoint[1] = (Sine(angle) * (pointX - origin[0]))   + (Cosine(angle) * (pointY - origin[1])) + origin[1];
    
    	pointX = newPoint[0];
    	pointY = newPoint[1];
    
	return;
}
stock bool:IsPlayerInSaferoom(client, option)
{
    	new Float:Origin[3];
	if (client > 0 && IsClientInGame(client))
	{
    		GetClientAbsOrigin(client, Origin);
	}
    	return IsPointInSaferoom(Origin, option);
}
stock bool:IsPointInSaferoom(Float:Origin[3], option)
{
        new Float: xMin, Float: xMax;
        new Float: yMin, Float: yMax;
        new Float: zMin, Float: zMax;

	if (option != 2)
	{
    		if (CPStartRotate != 0.0){RotatePoint(CPStartLocA, Origin[0], Origin[1], CPStartRotate);}
        	if (CPStartLocA[0] < CPStartLocB[0]){xMin = CPStartLocA[0];xMax = CPStartLocB[0];}else{xMin = CPStartLocB[0];xMax = CPStartLocA[0];}
        	if (CPStartLocA[1] < CPStartLocB[1]){yMin = CPStartLocA[1];yMax = CPStartLocB[1];}else{yMin = CPStartLocB[1];yMax = CPStartLocA[1];}
        	if (CPStartLocA[2] < CPStartLocB[2]){zMin = CPStartLocA[2];zMax = CPStartLocB[2];}else{zMin = CPStartLocB[2];zMax = CPStartLocA[2];}
        
       	 	if (Origin[0] >= xMin && Origin[0] <= xMax &&  Origin[1] >= yMin && Origin[1] <= yMax && Origin[2] >= zMin && Origin[2] <= zMax)
		{
			return true;
		}
        	if (bCPStartHasExtraData)
        	{
            		if (CPStartLocC[0] < CPStartLocD[0]){xMin = CPStartLocC[0];xMax = CPStartLocD[0];}else{xMin = CPStartLocD[0];xMax = CPStartLocC[0];}
            		if (CPStartLocC[1] < CPStartLocD[1]){yMin = CPStartLocC[1];yMax = CPStartLocD[1];}else{yMin = CPStartLocD[1];yMax = CPStartLocC[1];}
            		if (CPStartLocC[2] < CPStartLocD[2]){zMin = CPStartLocC[2];zMax = CPStartLocD[2];}else{zMin = CPStartLocD[2];zMax = CPStartLocC[2];}
            		if (Origin[0] >= xMin && Origin[0] <= xMax &&  Origin[1] >= yMin && Origin[1] <= yMax && Origin[2] >= zMin && Origin[2] <= zMax)
			{
				return true;
			}
		}
        }
	if (option != 1)
	{
    		if (CPEndRotate != 0.0){RotatePoint(CPEndLocA, Origin[0], Origin[1], CPEndRotate);}
        	if (CPEndLocA[0] < CPEndLocB[0]){xMin = CPEndLocA[0];xMax = CPEndLocB[0];}else{xMin = CPEndLocB[0];xMax = CPEndLocA[0];}
        	if (CPEndLocA[1] < CPEndLocB[1]){yMin = CPEndLocA[1];yMax = CPEndLocB[1];}else{yMin = CPEndLocB[1];yMax = CPEndLocA[1];}
        	if (CPEndLocA[2] < CPEndLocB[2]){zMin = CPEndLocA[2];zMax = CPEndLocB[2];}else{zMin = CPEndLocB[2];zMax = CPEndLocA[2];}
        	if (Origin[0] >= xMin && Origin[0] <= xMax &&  Origin[1] >= yMin && Origin[1] <= yMax && Origin[2] >= zMin && Origin[2] <= zMax)
		{
			return true;
		}
        	if (bCPEndHasExtraData)
        	{
            		if (CPEndLocC[0] < CPEndLocD[0]){xMin = CPEndLocC[0];xMax = CPEndLocD[0];}else{xMin = CPEndLocD[0];xMax = CPEndLocC[0];}
            		if (CPEndLocC[1] < CPEndLocD[1]){yMin = CPEndLocC[1];yMax = CPEndLocD[1];}else{yMin = CPEndLocD[1];yMax = CPEndLocC[1];}
            		if (CPEndLocC[2] < CPEndLocD[2]){zMin = CPEndLocC[2];zMax = CPEndLocD[2];}else{zMin = CPEndLocD[2];zMax = CPEndLocC[2];}
            		if (Origin[0] >= xMin && Origin[0] <= xMax &&  Origin[1] >= yMin && Origin[1] <= yMax && Origin[2] >= zMin && Origin[2] <= zMax)
			{
				return true;
			}
		}
        }
        return false;
}
stock LoadClipSpawns()
{
	if (iClipBrush == 0 && iFinaleStage > 0)
	{
		decl String:sPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sPath, sizeof(sPath), "%s", CONFIG_CLIP_SPAWNS);
		if (!FileExists(sPath))
		{
			PrintToServer("Error: Cannot read the config %s", sPath);
			iClipBrush = 1;
			return;
		}
		// Load config
		new Handle:hFile = CreateKeyValues("spawns");
		if (!FileToKeyValues(hFile, sPath))
		{
			PrintToServer("Error: Cannot read the config %s", sPath);
			CloseHandle(hFile);
			iClipBrush = 1;
			return;
		}
		// Check for current map in the config
		decl String:sMap[64];
		GetCurrentMap(sMap, 64);
		if (!KvJumpToKey(hFile, sMap))
		{
			PrintToServer("Error: Failed to add map to config");
			CloseHandle(hFile);
			iClipBrush = 1;
			return;
		}
		// Retrieve how many weapons to display
		new iCount = KvGetNum(hFile, "num", 0);
		if (iCount == 0)
		{
			PrintToServer("Error: No num count");
			CloseHandle(hFile);
			iClipBrush = 1;
			return;
		}
		// Get the weapon origins and spawn
		decl String:sTemp[10], Float:vPos[3], Float:vBounds[3];
		new index;
		for (new i=1; i<=iCount; i++)
		{
			index = i;
			IntToString(index, sTemp, sizeof(sTemp));
			if (KvJumpToKey(hFile, sTemp))
			{
				KvGetVector(hFile, "pos", vPos);
				KvGetVector(hFile, "bounds", vBounds);
				if (vPos[0] == 0.0 && vPos[1] == 0.0 && vPos[2] == 0.0)
				{
					LogError("Error: Positions at 0.0");
				}
				else
				{
					vBounds[0] = vBounds[0] / 2;
					vBounds[1] = vBounds[1] / 2;
					vBounds[2] = vBounds[2] / 2;
					CreatePlayerBlocker(vPos, vBounds);
				}
				KvGoBack(hFile);
			}
		}
		CloseHandle(hFile);
		iClipBrush = 1;
	}
	else if (iChapter == 7 && iClipBrush == 1 && iFinaleStage >= 3)
	{
		for (new count=17; count<=18; count++)
		{
			new entity = aClipBrush[count];
			if (IsValidEntity(entity))
			{
				decl String:classname[20];
				GetEdictClassname(entity, classname, sizeof(classname));
				if (StrEqual(classname, "env_player_blocker", false))
				{
					//PrintToChatAll("Removing ent: %i", entity);
					AcceptEntityInput(entity, "Kill");
				}
			}
		}
		iClipBrush = 2;
	}
}
stock CreatePlayerBlocker(Float:vPos[3], Float:vMax[3])
{
	decl Float:vMin[3];
	vMin[0] = 0.0 - vMax[0];
	vMin[1] = 0.0 - vMax[1];
	vMin[2] = 0.0 - vMax[2];
	new entity = CreateEntityByName("env_player_blocker");
	if (IsValidEntity(entity))
	{
		//PrintToChatAll("Creating Blocker");
		DispatchKeyValueVector(entity, "origin", vPos);
		DispatchKeyValue(entity, "initialstate", "1");
		DispatchKeyValue(entity, "BlockType", "1");
		DispatchKeyValueVector(entity, "mins", vMin);
		DispatchKeyValueVector(entity, "maxs", vMax);
		TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(entity);
		ActivateEntity(entity);
		//PrintToChatAll("Spawning ent: %i, Origin: %f %f %f", entity, vPos[0], vPos[1], vPos[2]);
		for (new count=1; count<=32; count++)
		{
			if (aClipBrush[count] <= 0)
			{
				aClipBrush[count] = entity;
				break;
			}
		}
	}
}
stock LoadCowSpawns()
{
	if (iCowLevelSpawns == 0)
	{
		decl String:sPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sPath, sizeof(sPath), "%s", CONFIG_COW_SPAWNS);
		if (!FileExists(sPath))
		{
			PrintToServer("Error: Cannot read the config %s", sPath);
			return;
		}
		// Load config
		new Handle:hFile = CreateKeyValues("spawns");
		if (!FileToKeyValues(hFile, sPath))
		{
			PrintToServer("Error: Cannot read the config %s", sPath);
			CloseHandle(hFile);
			return;
		}
		// Check for current map in the config
		decl String:sMap[64];
		GetCurrentMap(sMap, 64);
		if (!KvJumpToKey(hFile, sMap))
		{
			PrintToServer("Error: Failed to add map to config");
			CloseHandle(hFile);
			return;
		}
		// Retrieve how many weapons to display
		new iCount = KvGetNum(hFile, "num", 0);
		if (iCount == 0)
		{
			PrintToServer("Error: No num count");
			CloseHandle(hFile);
			return;
		}
		// Get the weapon origins and spawn
		decl String:sTemp[10], Float:vPos[3], Float:vAng[3];
		new index;
		for (new i=1; i<=iCount; i++)
		{
			index = i;
			IntToString(index, sTemp, sizeof(sTemp));
			if (KvJumpToKey(hFile, sTemp))
			{
				KvGetVector(hFile, "ang", vAng);
				KvGetVector(hFile, "pos", vPos);
				if (vPos[0] == 0.0 && vPos[1] == 0.0 && vPos[2] == 0.0)
				{
					LogError("Error: Positions at 0.0");
				}
				else
				{
					CreateCow(vPos, vAng);
					PrintToServer("Spawning cow");
				}
				KvGoBack(hFile);
			}
		}
		CloseHandle(hFile);
		iCowLevelSpawns = 1;
	}
}
stock RemoveCowSpawns()
{
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "prop_dynamic")) != INVALID_ENT_REFERENCE)
	{
		decl String:model[48];
		GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
		if (StrEqual(model, MODEL_COWPILE, false) || StrEqual(model, MODEL_COW, false))
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
}
stock CreateCow(Float:vOrigin[3], Float:vAngles[3])
{
	decl String:Model[48];
	new random = GetRandomInt(1,2);
	if (random == 1)
	{
		strcopy(Model, sizeof(Model), MODEL_COWPILE);
	}
	else
	{
		strcopy(Model, sizeof(Model), MODEL_COW);
	}
	new entity = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(entity))
	{
		vOrigin[2] -= 10.0;
		DispatchKeyValue(entity, "model", Model);
		DispatchKeyValue(entity, "solid", "6");
		DispatchSpawn(entity);
		TeleportEntity(entity, vOrigin, vAngles, NULL_VECTOR);
		DispatchSpawn(entity);
	}
}
stock RecycleWitches()
{
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
	{
		new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
		if (ragdoll <= 0)
		{
			new time = GetEntProp(entity, Prop_Send, "m_hEffectEntity");
			SetEntProp(entity, Prop_Send, "m_hEffectEntity", time+1);
			new distance = GetNearestSurvivorDistEnt(entity);
			//PrintToChatAll("witch:%i, distance:%i, time:%i", entity, distance, time);
			if (distance > 1000 && time > 20)
			{	
				//PrintToChatAll("killing witch");
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
}
stock bool:IsWitchAngry(entity)
{
	if (IsWitch(entity))
	{
		new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
		if (ragdoll <= 0)
		{
			new Float:rage = GetEntPropFloat(entity, Prop_Send, "m_rage");
			new Float:wanderrage = GetEntPropFloat(entity, Prop_Send, "m_wanderrage");
			if (rage > 0.0 || wanderrage > 0.0)
			{
				return true;
			}
		}
	}
	return false;
}
stock AngryWitchAmount()
{
	new count = 0;
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
	{
		if (IsWitchAngry(entity))
		{
			count++;
		}
	}
	return count;
}
stock GetNearestSurvivorDistEnt(entity)
{
    	new Float:EntityPos[3], Float:TargetPos[3], Float:nearest = 0.0, Float:distance = 0.0, visible = 0;
	if (IsWitch(entity) || IsInfected(entity))
	{
		GetEntPropVector(entity, Prop_Data, "m_vecOrigin", EntityPos);
		if (EntityPos[0] == 0.0 && EntityPos[1] == 0.0 && EntityPos[2] == 0.0)
		{
			return 0;
		}
		new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
		if (ragdoll != 0)
		{
			return 0;
		}
   		for (new i=1; i<=MaxClients; i++)
    		{
        		if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
			{
				if (IsClientViewing(i, entity))
				{
					visible = 1;
				}
				GetClientAbsOrigin(i, TargetPos);
                        	distance = GetVectorDistance(EntityPos, TargetPos);
                        	if (nearest == 0.0 || nearest > distance)
				{
					nearest = distance;
				}
			}
		} 
    	}
	if (visible == 1)
	{
		return 0;
	}
	else
	{
    		return RoundFloat(nearest);
	}
}
stock CountWitches()
{
	new count;
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
	{
		count++;
	}
	return count;
}
stock RemoveZombies()
{
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(entity, "BecomeRagdoll");
	}
}
stock RemoveNonZombies()
{
	new entity = -1;
	if (!bNightmare)
	{
		while ((entity = FindEntityByClassname(entity, "player")) != INVALID_ENT_REFERENCE)
		{
			if (IsClientInGame(entity) && IsPlayerAlive(entity) && !IsPlayerGhost(entity) && GetClientTeam(entity) == 3)
			{
				if (IsSpecialInfected(entity))
				{
					if (IsFakeClient(entity))
					{
						AcceptEntityInput(entity, "Kill");
					}
					else
					{
						ForcePlayerSuicide(entity);
					}
				}
			}
		}
	}
}
public Action:L4D2_OnWitchAttackUpdate(entity, &victim)
{
	new client = victim&0x7FF;
	if (IsSurvivor(client))
	{
		if ((IsPlayerAlive(client) && IsPlayerIncap(client)) || !IsPlayerAlive(client))
		{
			new target = EntityGetNearestSurvivorDist(entity, false);
			if (target > 0)
			{
				victim = GetEntData(target, L4D2_RefEntityHandle());
				return Plugin_Changed;
			}
			else
			{
				target = EntityGetNearestSurvivorDist(entity, true);
				if (target > 0)
				{
					victim = GetEntData(target, L4D2_RefEntityHandle());
					return Plugin_Changed;
				}
			}
		}
	}
	return Plugin_Continue;
}
public Action:L4D2_OnWitchKillIncapVictim(entity, &victim)
{
	new client = victim&0x7FF;
	new target = EntityGetNearestSurvivorDist(entity, false);
	if (target > 0)
	{
		victim = GetEntData(target, L4D2_RefEntityHandle());
		return Plugin_Changed;
	}
	else
	{
		if (IsSurvivor(client) && !IsPlayerAlive(client))
		{
			target = EntityGetNearestSurvivorDist(entity, true);
			if (target > 0)
			{
				victim = GetEntData(target, L4D2_RefEntityHandle());
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}
stock EnrageWitches()
{
	new count = 0;
	new random = GetRandomInt(2,6);
	new entity = -1;
	new maxangrywitch = 66;
	if (bHell)
	{
		maxangrywitch = CountSurvivorsAliveAll();
	}
	if (maxangrywitch > AngryWitchAmount())
	{
		while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
		{
			new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
				if (owner <= 0 || !IsWitchAngry(entity))
				{
					new target = Pick();
					if (IsSurvivor(target) && IsPlayerAlive(target) && !IsPlayerInSaferoom(target, 0) && WaitRescue[target] == 0)
					{
						L4D2_InfectedHitByVomitJar(entity, target);
						SetEntProp(entity, Prop_Send, "m_iGlowType", 0);
						SetEntProp(entity, Prop_Send, "m_hOwnerEntity", target);
						count++;
						if (count == random)
						{
							break;
						}
					}
				}
			}
		}
	}
}
stock EnrageAllWitches()
{
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
	{
		new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
		if (ragdoll == 0)
		{
			new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			if (owner <= 0 || !IsWitchAngry(entity))
			{
				new target = Pick();
				if (IsSurvivor(target) && IsPlayerAlive(target) && !IsPlayerInSaferoom(target, 0) && WaitRescue[target] == 0)
				{
					L4D2_InfectedHitByVomitJar(entity, target);
					SetEntProp(entity, Prop_Send, "m_iGlowType", 0);
					SetEntProp(entity, Prop_Send, "m_hOwnerEntity", target);
				}
			}
		}
	}
}
stock InfernoMeteorFall()
{
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "tank_rock")) != INVALID_ENT_REFERENCE)
	{
		if (OnGroundUnits(entity) < 200.0)
		{
			ExplodeInfernoMeteor(entity);
		}
	}
	if (GetRandomInt(1,2) == 1)
	{
		new target = Pick();
		if (IsSurvivor(target) && IsPlayerAlive(target) && !IsPlayerInSaferoom(target, 0) && WaitRescue[target] == 0)
		{
			decl Float:pos[3];
			GetClientEyePosition(target, pos);
			decl Float:angle[3], Float:velocity[3], Float:hitpos[3];
			angle[0] = 0.0 + GetRandomFloat(-20.0, 20.0);
			angle[1] = 0.0 + GetRandomFloat(-20.0, 20.0);
			angle[2] = 60.0;
		
			GetVectorAngles(angle, angle);
			GetRayHitPos(pos, angle, hitpos, target, true);
			new Float:dis = GetVectorDistance(pos, hitpos);
			if (GetVectorDistance(pos, hitpos) > 2000.0)
			{
				dis = 1600.0;
			}
			decl Float:t[3];
			MakeVectorFromPoints(pos, hitpos, t);
			NormalizeVector(t, t);
			ScaleVector(t, dis - 40.0);
			AddVectors(pos, t, hitpos);
		
			if (dis > 300.0)
			{
				new ent = CreateEntityByName("tank_rock");
				if (ent > 0)
				{
					DispatchKeyValue(ent, "model", "models/props_debris/concrete_chunk01a.mdl"); 
					DispatchSpawn(ent);  
					decl Float:angle2[3];
					angle2[0] = GetRandomFloat(-180.0, 180.0);
					angle2[1] = GetRandomFloat(-180.0, 180.0);
					angle2[2] = GetRandomFloat(-180.0, 180.0);

					velocity[0] = GetRandomFloat(0.0, 350.0);
					velocity[1] = GetRandomFloat(0.0, 350.0);
					velocity[2] = GetRandomFloat(0.0, 30.0);

					TeleportEntity(ent, hitpos, angle2, velocity);
					ActivateEntity(ent);
	 
					AcceptEntityInput(ent, "Ignite");
					SetVariantString("OnUser1 !self:Kill::7.0:-1");
					AcceptEntityInput(ent, "AddOutput");
					AcceptEntityInput(ent, "FireUser1");
				}
			} 
		}
	}
}
stock ExplodeInfernoMeteor(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		new target;
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsTank(i) || IsSpecialInfected(i))
			{
				target = i;
				break;
			}
		}
		decl String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (!StrEqual(classname, "tank_rock", true))
		{
			return;
		}

		new Float:pos[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);	
		pos[2]+=50.0;
		AcceptEntityInput(entity, "Kill");

		PropaneExplode(target, pos);

		new pointHurt = CreateEntityByName("point_hurt");   
		DispatchKeyValue(pointHurt, "Damage", "40");        
		DispatchKeyValue(pointHurt, "DamageType", "128");  
		DispatchKeyValue(pointHurt, "DamageDelay", "0.0");
		DispatchKeyValueFloat(pointHurt, "DamageRadius", 200.0);  
		DispatchSpawn(pointHurt);
		TeleportEntity(pointHurt, pos, NULL_VECTOR, NULL_VECTOR);
		if (target > 0)
		{
			AcceptEntityInput(pointHurt, "Hurt", target);
		}
		SetVariantString("OnUser1 !self:Kill::0.1:-1");
		AcceptEntityInput(pointHurt, "AddOutput");
		AcceptEntityInput(pointHurt, "FireUser1");
		
		new push = CreateEntityByName("point_push");         
  		DispatchKeyValueFloat (push, "magnitude", 600.0);                     
		DispatchKeyValueFloat (push, "radius", 200.0*1.0);                     
  		SetVariantString("spawnflags 24");                     
		AcceptEntityInput(push, "AddOutput");
 		DispatchSpawn(push);   
		TeleportEntity(push, pos, NULL_VECTOR, NULL_VECTOR);  
 		AcceptEntityInput(push, "Enable", -1, -1);
		SetVariantString("OnUser1 !self:Kill::0.5:-1");
		AcceptEntityInput(push, "AddOutput");
		AcceptEntityInput(push, "FireUser1");
	}
}
stock CustomMapCheck()
{
	new bool:sMatch = false;
	if (bCustomMapsOn)
	{
		for (new count=55; count<=99; count++)
		{
			if (StrEqual(current_map, MapNames[count], false))
			{
				sMatch = true;
			}
		}
		if (!sMatch)
		{
			new map = 0;
			new random = GetRandomInt(1,10);
			switch(random)
			{
				case 1: map = 55;
				case 2: map = 59;
				case 3: map = 62;
				case 4: map = 67;
				case 5: map = 71;
				case 6: map = 75;
				case 7: map = 80;
				case 8: map = 84;
				case 9: map = 89;
				case 10: map = 94;
			}
			ServerCommand("changelevel %s", MapNames[map]);
		}
	}
} 
stock UpdateServerName()
{
	decl String:text[38];
	if (GetConVarInt(FindConVar("hostport")) == 27015)
	{
		Format(text, sizeof(text), "Lethal-Injection L4D2 | %i/%i", CountInGame(), GetConVarInt(FindConVar("sv_maxplayers")));
	}
	else if (GetConVarInt(FindConVar("hostport")) == 27016)
	{
		Format(text, sizeof(text), "Lethal-Injection Custom L4D2 | %i/%i", CountInGame(), GetConVarInt(FindConVar("sv_maxplayers")));
	}
	else
	{
		Format(text, sizeof(text), "Lethal-Injection Laboratory");
	}
	decl String:text2[38];
	GetConVarString(FindConVar("hostname"), text2, sizeof(text2));
	if (!StrEqual(text, text2, false))
	{
		SetConVarString(hHostname, text);
	}
}
stock ForceWeaponDrop(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		decl String:classname[32];
		GetClientWeapon(client, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_melee", false))
		{
			new weaponid = GetPlayerWeaponSlot(client, 1);
			new String:Model[48];
			GetEntPropString(weaponid, Prop_Data, "m_ModelName", Model, sizeof(Model));
			if (StrEqual(Model, MODEL_V_FIREAXE, false)) classname = "weapon_fireaxe";
			else if (StrEqual(Model, MODEL_V_FRYING_PAN, false)) classname = "weapon_frying_pan";
			else if (StrEqual(Model, MODEL_V_MACHETE, false)) classname = "weapon_machete";
			else if (StrEqual(Model, MODEL_V_BAT, false)) classname = "weapon_baseball_bat";
			else if (StrEqual(Model, MODEL_V_CROWBAR, false)) classname = "weapon_crowbar";
			else if (StrEqual(Model, MODEL_V_CRICKET_BAT, false)) classname = "weapon_cricket_bat";
			else if (StrEqual(Model, MODEL_V_TONFA, false)) classname = "weapon_tonfa";
			else if (StrEqual(Model, MODEL_V_KATANA, false)) classname = "weapon_katana";
			else if (StrEqual(Model, MODEL_V_ELECTRIC_GUITAR, false)) classname = "weapon_electric_guitar";
			else if (StrEqual(Model, MODEL_V_KNIFE, false)) classname = "weapon_knife";
			else if (StrEqual(Model, MODEL_V_GOLFCLUB, false)) classname = "weapon_golfclub";		
		}

		new slot = 2;
		for (new index=1; index<=40; index++)
		{
			switch(index)
			{
				case 4: slot = 3;
				case 8: slot = 4;
				case 10: slot = 1;
				case 24: slot = 0;
			}
			if (StrEqual(classname, WeaponClassname[index], false))
			{
				if (index != 10 && index != 11)
				{
					DropSlot(client, index, slot);
					return true;
				}
			}
		}
	}
	return false;
}
public DropSlot(client, index, slot)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (GetPlayerWeaponSlot(client, slot) > 0)
		{
			new weapon = GetPlayerWeaponSlot(client, slot);
			if (index >= 12 && index <= 23)
			{
				CheatCommand(client, "give", "pistol");
			}
			else
			{
				L4D2_WeaponDrop(client, weapon);
			}
			if (index == 5)
			{
				SetEntProp(weapon, Prop_Send, "m_iWorldModelIndex", MODEL_DEFIB);
			}
		}
	}
}
public PerformFade(client, duration, unknown, type1, type2, const Color[4]) 
{
	switch(type1)
	{
		case 1: type1 = FFADE_IN;
		case 2: type1 = FFADE_OUT;
		case 4: type1 = FFADE_MODULATE;
		case 8: type1 = FFADE_STAYOUT;
		case 10: type1 = FFADE_PURGE;
	}
	switch(type2)
	{
		case 1: type2 = FFADE_IN;
		case 2: type2 = FFADE_OUT;
		case 4: type2 = FFADE_MODULATE;
		case 8: type2 = FFADE_STAYOUT;
		case 10: type2 = FFADE_PURGE;
	}
    	new Handle:hFadeClient=StartMessageOne("Fade", client);
    	BfWriteShort(hFadeClient, duration);
    	BfWriteShort(hFadeClient, unknown);
   	BfWriteShort(hFadeClient, (type1|type2));
    	BfWriteByte(hFadeClient, Color[0]);
    	BfWriteByte(hFadeClient, Color[1]);
    	BfWriteByte(hFadeClient, Color[2]);
    	BfWriteByte(hFadeClient, Color[3]);
    	EndMessage();
}
public ScreenShake(target, Float:intensity)
{
	new Handle:msg;
	msg = StartMessageOne("Shake", target);
	
	BfWriteByte(msg, 0);
 	BfWriteFloat(msg, intensity);
 	BfWriteFloat(msg, 10.0);
 	BfWriteFloat(msg, 3.0);
	EndMessage();
}
stock DealDamagePlayer(target, attacker, dmgtype, dmg, String:inflictor[])
{
	if (target > 0 && target <= 32)
	{
		if (IsClientInGame(target) && IsPlayerAlive(target))
		{
   	 		decl String:damage[16], String:type[16];
    			IntToString(dmg, damage, sizeof(damage));
    			IntToString(dmgtype, type, sizeof(type));
			new pointHurt = CreateEntityByName("point_hurt");
			if (pointHurt)
			{
				DispatchKeyValue(target, "targetname", "hurtme");
				DispatchKeyValue(pointHurt, "Damage", damage);
				DispatchKeyValue(pointHurt, "DamageTarget", "hurtme");
				DispatchKeyValue(pointHurt, "DamageType", type);
				DispatchKeyValue(pointHurt, "classname", inflictor);
				DispatchSpawn(pointHurt);
				AcceptEntityInput(pointHurt, "Hurt", (attacker > 0 && IsClientInGame(attacker))?attacker:-1);
				AcceptEntityInput(pointHurt, "Kill");
				DispatchKeyValue(target, "targetname", "donthurtme");
			}
		}
	}
}
stock DealDamageEntity(target, attacker, dmgtype, dmg, String:inflictor[])
{
	if (target > 32)
	{
		if (IsValidEntity(target))
		{
   	 		decl String:damage[16], String:type[16];
    			IntToString(dmg, damage, sizeof(damage));
    			IntToString(dmgtype, type, sizeof(type));
			new pointHurt = CreateEntityByName("point_hurt");
			if (pointHurt)
			{
				if (IsInfected(target) || IsWitch(target))
				{
					new ragdoll = GetEntProp(target, Prop_Data, "m_bClientSideRagdoll");
					if (ragdoll == 0)
					{
						DispatchKeyValue(target, "targetname", "hurtme");
						DispatchKeyValue(pointHurt, "Damage", damage);
						DispatchKeyValue(pointHurt, "DamageTarget", "hurtme");
						DispatchKeyValue(pointHurt, "DamageType", type);
						DispatchKeyValue(pointHurt, "classname", inflictor);
						DispatchSpawn(pointHurt);
						if (IsClientInGame(attacker))
						{
							AcceptEntityInput(pointHurt, "Hurt", attacker);
						}
						DispatchKeyValue(target, "targetname", "donthurtme");
					}
				}
				AcceptEntityInput(pointHurt, "Kill");
			}
		}
	}
}
stock DealDamageEntity2(target, attacker, dmgtype, dmg, String:inflictor[])
{
	if (target > 32)
	{
		if (IsValidEntity(target))
		{
			decl String:damage[16], String:type[16];
    			IntToString(dmg, damage, sizeof(damage));
    			IntToString(dmgtype, type, sizeof(type));
			new pointHurt = CreateEntityByName("point_hurt");
			if (pointHurt)
			{
				if (IsInfected(target) || IsWitch(target))
				{
					new ragdoll = GetEntProp(target, Prop_Data, "m_bClientSideRagdoll");
					if (ragdoll == 0)
					{
						if (IsInfected(target))
						{
							new health = GetEntProp(target, Prop_Data, "m_iHealth");
							if (health <= dmg)
							{
								SetEntProp(target, Prop_Send, "m_iRequestedWound1", GetRandomInt(21,25));
								SetEntProp(target, Prop_Data, "m_bClientSideRagdoll", 1);
							}
						}
						DispatchKeyValue(target, "targetname", "hurtme");
						DispatchKeyValue(pointHurt, "Damage", damage);
						DispatchKeyValue(pointHurt, "DamageTarget", "hurtme");
						DispatchKeyValue(pointHurt, "DamageType", type);
						DispatchKeyValue(pointHurt, "classname", inflictor);
						DispatchSpawn(pointHurt);
						if (IsClientInGame(attacker))
						{
							AcceptEntityInput(pointHurt, "Hurt", attacker);
						}
						DispatchKeyValue(target, "targetname", "donthurtme");
					}
				}
				AcceptEntityInput(pointHurt, "Kill");
			}
		}
	}
}
stock BreakInfectedHold(client)
{
	if (IsSpecialInfected(client))
	{
		new Survivor[4];
		Survivor[0] = GetEntPropEnt(client, Prop_Send, "m_jockeyVictim");
		Survivor[1] = GetEntPropEnt(client, Prop_Send, "m_pummelVictim");
		Survivor[2] = GetEntPropEnt(client, Prop_Send, "m_pounceVictim");
		Survivor[3] = GetEntPropEnt(client, Prop_Send, "m_tongueVictim");
		if (IsSurvivor(Survivor[0]))
		{
			if (GetEntPropEnt(Survivor[0], Prop_Send, "m_jockeyAttacker") == client)
			{
				//L4D2_RideEnd(client);
				DirectorCommand(client, "dismount");
			}
		}
		else if (IsSurvivor(Survivor[1]))
		{
			if (GetEntPropEnt(Survivor[1], Prop_Send, "m_pummelAttacker") == client)
			{
				L4D2_PummelEnd(client);
			}
		}
		else if (IsSurvivor(Survivor[2]))
		{
			if (GetEntPropEnt(Survivor[2], Prop_Send, "m_pounceAttacker") == client)
			{
				L4D2_PounceEnd(client);
			}
		}
		else if (IsSurvivor(Survivor[3]))
		{
			if (GetEntPropEnt(Survivor[3], Prop_Send, "m_tongueOwner") == client)
			{
				L4D2_TongueBreak(client);
			}
		}
	}
}
stock ReturnChapterData()
{
	new campaign = 1;
	for (new count=0; count<=99; count++)
	{
		switch(count)
		{
			case 4: campaign = 2;
			case 9: campaign = 3;
			case 13: campaign = 4;
			case 18: campaign = 5;
			case 23: campaign = 6;
			case 26: campaign = 7;
			case 29: campaign = 8;
			case 34: campaign = 9;
			case 36: campaign = 10;
			case 41: campaign = 11;
			case 46: campaign = 12;
			case 51: campaign = 13;
			case 55: campaign = 14;
			case 59: campaign = 15;
			case 62: campaign = 16;
			case 67: campaign = 17;
			case 71: campaign = 18;
			case 75: campaign = 19;
			case 80: campaign = 20;
			case 84: campaign = 21;
			case 89: campaign = 22;
			case 94: campaign = 23;
		}
		if (StrEqual(current_map, MapNames[count], false))
		{
			iChapter = 0;
			if (IsMissionFinalMap())
			{
				bIsFinale = true;
			}
			else
			{
				bIsFinale = false;
			}
			if ((campaign > 0 && campaign <= 6) || campaign == 13)
			{
				bIsL4D2 = true;
			}
			else
			{
				bIsL4D2 = false;
			}
			switch(campaign)
			{
				case 1:
				{
					iChapter = 1;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 0: iChapterStage = 1;
						case 1: iChapterStage = 2;
						case 2: iChapterStage = 3;
						case 3: iChapterStage = 4;
					}
				}
				case 2:
				{
					iChapter = 2;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 4: iChapterStage = 1;
						case 5: iChapterStage = 2;
						case 6: iChapterStage = 3;
						case 7: iChapterStage = 4;
						case 8: iChapterStage = 5;
					}
				}
				case 3:
				{
					iChapter = 3;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 9: iChapterStage = 1;
						case 10: iChapterStage = 2;
						case 11: iChapterStage = 3;
						case 12: iChapterStage = 4;
					}
				}
				case 4:
				{
					iChapter = 4;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 13: iChapterStage = 1;
						case 14: iChapterStage = 2;
						case 15: iChapterStage = 3;
						case 16: iChapterStage = 4;
						case 17: iChapterStage = 5;
					}
				}
				case 5:
				{
					iChapter = 5;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 18: iChapterStage = 1;
						case 19: iChapterStage = 2;
						case 20: iChapterStage = 3;
						case 21: iChapterStage = 4;
						case 22: iChapterStage = 5;
					}
				}
				case 6:
				{
					iChapter = 6;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 23: iChapterStage = 1;
						case 24: iChapterStage = 2;
						case 25: iChapterStage = 3;
					}
				}
				case 7:
				{
					iChapter = 7;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 26: iChapterStage = 1;
						case 27: iChapterStage = 2;
						case 28: iChapterStage = 3;
					}
				}
				case 8:
				{
					iChapter = 8;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 29: iChapterStage = 1;
						case 30: iChapterStage = 2;
						case 31: iChapterStage = 3;
						case 32: iChapterStage = 4;
						case 33: iChapterStage = 5;
					}
				}
				case 9:
				{
					iChapter = 9;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 34: iChapterStage = 1;
						case 35: iChapterStage = 2;
					}
				}
				case 10:
				{
					iChapter = 10;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 36: iChapterStage = 1;
						case 37: iChapterStage = 2;
						case 38: iChapterStage = 3;
						case 39: iChapterStage = 4;
						case 40: iChapterStage = 5;
					}
				}
				case 11:
				{
					iChapter = 11;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 41: iChapterStage = 1;
						case 42: iChapterStage = 2;
						case 43: iChapterStage = 3;
						case 44: iChapterStage = 4;
						case 45: iChapterStage = 5;
					}
				}
				case 12:
				{
					iChapter = 12;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 46: iChapterStage = 1;
						case 47: iChapterStage = 2;
						case 48: iChapterStage = 3;
						case 49: iChapterStage = 4;
						case 50: iChapterStage = 5;
					}
				}
				case 13:
				{
					iChapter = 13;
					iNMTimeEasy = 570;
					iNMTimeNormal = 510;
					iNMTimeAdvanced = 450;
					iNMTimeExpert = 390;
					switch(count)
					{
						case 51: iChapterStage = 1;
						case 52: iChapterStage = 2;
						case 53: iChapterStage = 3;
						case 54: iChapterStage = 4;
					}
				}
				case 14:
				{
					iChapter = 14;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 55: iChapterStage = 1;
						case 56: iChapterStage = 2;
						case 57: iChapterStage = 3;
						case 58: iChapterStage = 4;
					}
				}
				case 15:
				{
					iChapter = 15;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 59: iChapterStage = 1;
						case 60: iChapterStage = 2;
						case 61: iChapterStage = 3;
					}
				}
				case 16:
				{
					iChapter = 16;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 62: iChapterStage = 1;
						case 63: iChapterStage = 2;
						case 64: iChapterStage = 3;
						case 65: iChapterStage = 4;
						case 66: iChapterStage = 5;
					}
				}
				case 17:
				{
					iChapter = 17;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 67: iChapterStage = 1;
						case 68: iChapterStage = 2;
						case 69: iChapterStage = 3;
						case 70: iChapterStage = 4;
					}
				}
				case 18:
				{
					iChapter = 18;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 71: iChapterStage = 1;
						case 72: iChapterStage = 2;
						case 73: iChapterStage = 3;
						case 74: iChapterStage = 4;
					}
				}
				case 19:
				{
					iChapter = 19;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 75: iChapterStage = 1;
						case 76: iChapterStage = 2;
						case 77: iChapterStage = 3;
						case 78: iChapterStage = 4;
						case 79: iChapterStage = 5;
					}
				}
				case 20:
				{
					iChapter = 20;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 80: iChapterStage = 1;
						case 81: iChapterStage = 2;
						case 82: iChapterStage = 3;
						case 83: iChapterStage = 4;
					}
				}
				case 21:
				{
					iChapter = 21;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 84: iChapterStage = 1;
						case 85: iChapterStage = 2;
						case 86: iChapterStage = 3;
						case 87: iChapterStage = 4;
						case 88: iChapterStage = 5;
					}
				}
				case 22:
				{
					iChapter = 22;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 89: iChapterStage = 1;
						case 90: iChapterStage = 2;
						case 91: iChapterStage = 3;
						case 92: iChapterStage = 4;
						case 93: iChapterStage = 5;
					}
				}
				case 23:
				{
					iChapter = 23;
					iNMTimeEasy = 970;
					iNMTimeNormal = 910;
					iNMTimeAdvanced = 850;
					iNMTimeExpert = 790;
					switch(count)
					{
						case 94: iChapterStage = 1;
						case 95: iChapterStage = 2;
						case 96: iChapterStage = 3;
						case 97: iChapterStage = 4;
						case 98: iChapterStage = 5;
						case 99: iChapterStage = 6;
					}
				}
			}
			return;
		}
		iChapter = 24;
		iNMTimeEasy = 970;
		iNMTimeNormal = 910;
		iNMTimeAdvanced = 850;
		iNMTimeExpert = 790;
	}
}
stock GasCanRandomPlacement()
{
	if (bRoundEnded)
	{
		return;
	}
	new index = 0;
	//PrintToChatAll("creating random gascan:%i...", randomOrigin);
	if (StrEqual(current_map, "c1m4_atrium", false))
	{
		index = GetRandomInt(1,19);
	}
	else if (StrEqual(current_map, "c6m3_port", false))
	{
		index = GetRandomInt(1,16);
	}
	else if (StrEqual(current_map, "p84m4_precinct", false))
	{
		index = GetRandomInt(1,21);
	}
	else if (StrEqual(current_map, "l4d_yama_5", false))
	{
		index = GetRandomInt(1,15);
	}
	if (index <= 0)
	{
		return;
	}
	if (GCOrigin[index][0] != 0.0 && GCOrigin[index][1] != 0.0 && GCOrigin[index][2] != 0.0)
	{
		new gascanscounted = CountGasCans();
		new totalgascans = gascanscounted + iGasCanPoured;
		//PrintToChatAll("Wave:%i, Poured:%i, InGame:%i, Total:%i",ad_wave,gascanspoured,gascanscounted,totalgascans);
		if (iFinaleStage > 0 && totalgascans < 16)
		{
			new entity = CreateEntityByName("weapon_gascan");
			if (IsValidEntity(entity))
			{
				//DispatchKeyValue(entity, "model", MODEL_GASCAN);
				//DispatchKeyValueVector(entity, "Origin", GCOrigin[index]);
				//DispatchKeyValueVector(entity, "Angles", GCAngles[index]);
				DispatchSpawn(entity);
				TeleportEntity(entity, GCOrigin[index], GCAngles[index], NULL_VECTOR);
				//PrintToChatAll("gascan:%i created", randomOrigin);

				SetEntProp(entity, Prop_Send, "m_iGlowType", 3);
				new glowcolor = RGB_TO_INT(255, 255, 255);
				SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
			}
		}
	}
}
stock bool:bIsScavengeFinale()
{
	if (StrEqual(current_map, "c1m4_atrium", false) || StrEqual(current_map, "c6m3_port", false) 
|| StrEqual(current_map, "p84m4_precinct", false) || StrEqual(current_map, "l4d_yama_5", false))
	{
		return true;
	}
	return false;
}
stock bool:bIsGauntletFinale()
{
	if (StrEqual(current_map, "c5m5_bridge", false) || StrEqual(current_map, "c13m4_cutthroatcreek", false))
	{
		return true;
	}
	return false;
}
public Action:RemoveGasCans(Handle:timer)
{
	if (bIsScavengeFinale())
	{
		new index = 1;
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "weapon_gascan")) != INVALID_ENT_REFERENCE)
		{
			AcceptEntityInput(entity, "Kill");
		}
		while ((entity = FindEntityByClassname(entity, "weapon_scavenge_item_spawn")) != INVALID_ENT_REFERENCE)
		{
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", GCOrigin[index]);
			GetEntPropVector(entity, Prop_Send, "m_angRotation", GCAngles[index]);
			AcceptEntityInput(entity, "Kill");
			index += 1;
		}
	}
}
public Action:GasCansDisableGlow(Handle:timer)
{
	if (bIsScavengeFinale())
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "prop_physics")) != INVALID_ENT_REFERENCE)
		{
			decl String:model[32];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, MODEL_GASCAN, false))
			{
				SetEntProp(entity, Prop_Send, "m_iGlowType", 0);
				SetEntProp(entity, Prop_Send, "m_glowColorOverride", 0);
			}
		}
		while ((entity = FindEntityByClassname(entity, "weapon_gascan")) != INVALID_ENT_REFERENCE)
		{
			SetEntProp(entity, Prop_Send, "m_iGlowType", 0);
			SetEntProp(entity, Prop_Send, "m_glowColorOverride", 0);
		}
	}
}
public Action:M60DropTimer(Handle:timer, any:entity)
{
	if (IsValidEntity(entity))
	{
		new String:classname[32];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_rifle_m60", false))
		{
			//PrintToChatAll("m_hOwnerEntity: %i", GetEntProp(entity, Prop_Send, "m_hOwnerEntity"));
			if (GetEntProp(entity, Prop_Send, "m_hOwnerEntity") <= 0)
			{
				//PrintToChatAll("m_iClip1: %i", GetEntProp(entity, Prop_Send, "m_iClip1"));
				if (GetEntProp(entity, Prop_Send, "m_iClip1") == 0)
				{
					SetEntProp(entity, Prop_Send, "m_iClip1", 1);
				}
			}
		}
	}
}
public Action:CreateSpecialInfected(Handle:timer, any:client)
{
	if (IsSpecialInfected(client) && IsFakeClient(client) && !bNightmare)
	{
		if (iCreateInstaCapper > 0)
		{
			iCreateInstaCapper -= 1;
			CreateTimer(0.1, CreateInstaCapper, client, TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (iCreateBreeder > 0)
		{
			iCreateBreeder -= 1;
			CreateTimer(0.1, CreateBreeder, client, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}
public Action:CreateInstaCapper(Handle:timer, any:client)
{
	if (IsSpecialInfected(client) && IsFakeClient(client))
	{
		SetEntProp(client, Prop_Send, "m_iMaxHealth", 1666);
		SetEntProp(client, Prop_Send, "m_iHealth", 1666);
		SetEntProp(client, Prop_Send, "m_iGlowType", 2);
		new glowcolor = RGB_TO_INT(70, 120, 0);
		SetEntProp(client, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.3);
		new class = GetZombieClass(client);
		switch(class)
		{
			case 1: SetClientInfo(client, "name", "Insta-Cap Smoker");
			case 2: SetClientInfo(client, "name", "Insta-Cap Boomer");
			case 3: SetClientInfo(client, "name", "Insta-Cap Hunter");
			case 4: SetClientInfo(client, "name", "Insta-Cap Spitter");
			case 5: SetClientInfo(client, "name", "Insta-Cap Jockey");
			case 6: SetClientInfo(client, "name", "Insta-Cap Charger");
		}
	}
}
public Action:CreateBreeder(Handle:timer, any:client)
{
	if (IsSpecialInfected(client) && IsFakeClient(client))
	{
		SetEntProp(client, Prop_Send, "m_iMaxHealth", 1666);
		SetEntProp(client, Prop_Send, "m_iHealth", 1666);
		SetEntProp(client, Prop_Send, "m_iGlowType", 2);
		new glowcolor = RGB_TO_INT(0, 175, 175);
		SetEntProp(client, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.5);
		new class = GetZombieClass(client);
		switch(class)
		{
			case 1: SetClientInfo(client, "name", "Breeder Smoker");
			case 2: SetClientInfo(client, "name", "Breeder Boomer");
			case 3: SetClientInfo(client, "name", "Breeder Hunter");
			case 4: SetClientInfo(client, "name", "Breeder Spitter");
			case 5: SetClientInfo(client, "name", "Breeder Jockey");
			case 6: SetClientInfo(client, "name", "Breeder Charger");
		}
	}
}
stock CreateEvents()
{
	if (!IsServerProcessing()) return;

	if (bFreezeAI) return;

	if (!bNightmare && !bHell && !bInferno && !bBloodmoon && !bCowLevel && !bIsFinale)
	{
		new ChanceHorde;
		new ChanceSI;
		new ChanceWitch;
		new ChanceTank;
		new ChanceInsta;
		new ChanceBreeder;
		new ChanceUncommon;

		switch(iDifficulty)
		{
			case 1:
			{
				ChanceHorde = 120;
				ChanceUncommon = 1800;
				ChanceWitch = 1800;
				ChanceSI = 2150;
				ChanceTank = 2150;
				ChanceInsta = 2500;
				ChanceBreeder = 2500;
			}
			case 2:
			{
				ChanceHorde = 90;
				ChanceUncommon = 1400;
				ChanceWitch = 1400;
				ChanceSI = 1700;
				ChanceTank = 1700;
				ChanceInsta = 2000;
				ChanceBreeder = 2000;
			}
			case 3:
			{
				ChanceHorde = 60;
				ChanceUncommon = 1000;
				ChanceWitch = 1000;
				ChanceSI = 1250;
				ChanceTank = 1250;
				ChanceInsta = 1500;
				ChanceBreeder = 1500;
			}
			case 4:
			{
				ChanceHorde = 30;
				ChanceUncommon = 600;
				ChanceWitch = 600;
				ChanceSI = 800;
				ChanceTank = 800;
				ChanceInsta = 1000;
				ChanceBreeder = 1000;
			}
		}
		new random = GetRandomInt(1,ChanceHorde);
		if (random == ChanceHorde)
		{
			CreatePanicEvent();
			//PrintToChatAll("Creating Panic Event, %i", ChanceHorde);
			return;
		}
		random = GetRandomInt(1,ChanceUncommon);
		if (random == ChanceUncommon)
		{
			CreateUncommonsEvent();
			//PrintToChatAll("Creating Uncommons Event, %i", ChanceUncommon);
			return;
		}
		random = GetRandomInt(1,ChanceWitch);
		if (random == ChanceWitch)
		{
			CreateWitchEvent();
			//PrintToChatAll("Creating Witch Event, %i", ChanceWitch);
			return;
		}
		random = GetRandomInt(1,ChanceSI);
		if (random == ChanceSI)
		{
			CreateSIEvent();
			//PrintToChatAll("Creating SI Event, %i", ChanceSI);
			return;
		}
		random = GetRandomInt(1,ChanceTank);
		if (random == ChanceTank)
		{
			CreateTankEvent();
			//PrintToChatAll("Creating Tank Event, %i", ChanceTank);
			return;
		}
		random = GetRandomInt(1,ChanceInsta);
		if (random == ChanceInsta)
		{
			CreateInstaCapperEvent();
			//PrintToChatAll("Creating Insta-Cappers Event, %i", ChanceInsta);
			return;
		}
		random = GetRandomInt(1,ChanceBreeder);
		if (random == ChanceBreeder)
		{
			CreateBreederEvent();
			//PrintToChatAll("Creating Breeders Event, %i", ChanceBreeder);
			return;
		}
	}
	else if (!bIsFinale && !bCowLevel && (bNightmare || bHell || bInferno || bBloodmoon))
	{
		new random = GetRandomInt(1,500);
		if (random == 500)
		{
			CreateUncommonsEvent();
			//PrintToChatAll("Creating Uncommons Event, %i", ChanceUncommon);
			return;
		}
		random = GetRandomInt(1,700);
		if (random == 700)
		{
			CreateSIEvent();
			//PrintToChatAll("Creating SI Event, %i", ChanceSI);
			return;
		}
		random = GetRandomInt(1,800);
		if (random == 800)
		{
			CreateInstaCapperEvent();
			//PrintToChatAll("Creating Insta-Cappers Event, %i", ChanceInsta);
			return;
		}
		random = GetRandomInt(1,800);
		if (random == 800)
		{
			CreateBreederEvent();
			//PrintToChatAll("Creating Breeders Event, %i", ChanceBreeder);
			return;
		}
	}	
}
stock CreateUncommon(entity)
{
	if (!IsServerProcessing()) return;

	if (IsInfected(entity))
	{
		if (iZombieType > 0 && iZombieType <= 7 && iZombieAmount > 0)
		{
			new String:Modelname[48];
			switch(iZombieType)
			{
				case 1: Modelname = "models/infected/common_male_roadcrew.mdl";
				case 2: Modelname = "models/infected/common_male_ceda.mdl";
				case 3: Modelname = "models/infected/common_male_riot.mdl";
				case 4: Modelname = "models/infected/common_male_mud.mdl";
				case 5: Modelname = "models/infected/common_male_clown.mdl";
				case 6: Modelname = "models/infected/common_male_jimmy.mdl";
				case 7: Modelname = "models/infected/common_male_fallen_survivor.mdl";
			}
			if (!IsModelPrecached(Modelname))
			{
				PrecacheModel(Modelname, true);
			}
			SetEntityModel(entity, Modelname);
			iZombieAmount -= 1;
			//PrintToChatAll("Created Uncommon");
		}
	}
}
stock CreatePanicEvent()
{
	new anyclient = GetAnyClient();
	if (anyclient > 0)
	{
		DirectorCommand(anyclient, "director_force_panic_event");
	}
}
stock CreateUncommonsEvent()
{
	if (!IsServerProcessing()) return;

	switch(iChapter)
	{
		case 1:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 2:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 5;
			}
		}
		case 3:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 4;
			}
		}
		case 4:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 4;
			}
		}
		case 5:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 3;
			}
		}
		case 6:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 3;
				case 3: iZombieType = 7;
			}
		}
		case 7:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 3;
				case 3: iZombieType = 7;
			}
		}
		case 8:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 3;
			}
		}
		case 9:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 3;
			}
		}
		case 10:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 4;
			}
		}
		case 11:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 3;
			}
		}
		case 12:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 4;
			}
		}
		case 13:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 1;
				case 2: iZombieType = 2;
				case 3: iZombieType = 4;
			}
		}
		case 14:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 15:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 16:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 17:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 18:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 19:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 20:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 21:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 22:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
		case 23:
		{
			new random = GetRandomInt(1,3);
			switch(random)
			{
				case 1: iZombieType = 2;
				case 2: iZombieType = 3;
				case 3: iZombieType = 6;
			}
		}
	}
	iZombieAmount = GetRandomInt(30,45);
}
stock CreateSIEvent()
{
	for (new count=0; count<=4; count++)
	{
		SpawnInfectedBot();
	}
}
stock CreateInstaCapperEvent()
{
	iCreateInstaCapper = 1;
	for (new count=0; count<=1; count++)
	{
		SpawnInfectedBot();
	}
}
stock CreateBreederEvent()
{
	iCreateBreeder = 1;
	for (new count=0; count<=1; count++)
	{
		SpawnInfectedBot();
	}
}
stock CreateWitchEvent()
{
	new bot = CreateFakeClient("Witch");
	if (bot > 0)
	{
		SpawnCommand(bot, "z_spawn_old", "witch auto");
	}
}
stock CreateTankEvent()
{
	if (iNumTanks <= 0)
	{
		new bot = CreateFakeClient("Tank");
		if (bot > 0)
		{
			SpawnInfected(bot, 8, true);
		}
	}
}
stock BreederTimer(client)
{
	if (IsBreeder(client))
	{
		for (new count=1; count<=3; count++)
		{
			new random = GetRandomInt(1,15);
			if (random == 1)
			{
				if (CountTotal() < 29)
				{
					new bot = CreateFakeClient("Smoker");
					if (bot > 0)
					{
						new class = GetZombieClass(client);
						SpawnInfected(bot, class, true);
						new Float:Origin[3], Float:Angles[3];
						GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
						GetEntPropVector(client, Prop_Send, "m_angRotation", Angles);
						TeleportEntity(bot, Origin, Angles, NULL_VECTOR);
					}
				}
			}
		}
	}
}
public Action:VomitJarThinkTimer(Handle:timer, any:Pack)
{
	ResetPack(Pack, false);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new jar = ReadPackCell(Pack);
	new tick = ReadPackCell(Pack);
	new Float:Origin[3];
	Origin[0] = ReadPackFloat(Pack);
	Origin[1] = ReadPackFloat(Pack);
	Origin[2] = ReadPackFloat(Pack);
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (bMenuOn)
	{
		if (tick > 0)
		{
			new entity = -1;
			while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
			{
				decl Float:TOrigin[3];
				GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
                       	 	new Float:distance = GetVectorDistance(Origin, TOrigin);
                        	if (distance <= 125)
				{
					new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
					if (owner <= 0)
					{
						if (IsSurvivor(client) && !IsFakeClient(client))
						{
							SetEntProp(entity, Prop_Send, "m_hOwnerEntity", jar);
							SetEntProp(entity, Prop_Send, "m_iGlowType", 3);
							new glowcolor = RGB_TO_INT(255, 0, 255);
							SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
							if (!bNightmare)
							{
								new earnedxp = 1 * GetXPDiff(0);
								new level = cLevel[client];
								if (level < 50)
								{
									GiveXP(client, earnedxp);
									new messages = cNotifications[client];
									if (messages > 0)
									{
										PrintToChat(client, "\x05[Lethal-Injection]\x01 Lured Zombie To Vomit Jar: \x03%i\x01 XP", earnedxp);
									}
								}
								else
								{
									GiveXP(client, earnedxp);
								}
							}
							break;
						}
					}
				}
			}
			tick = tick - 1;
			new Handle:NewPack = CreateDataPack();
			WritePackCell(NewPack, iRound);
			WritePackCell(NewPack, client);
			WritePackCell(NewPack, jar);
			WritePackCell(NewPack, tick);
			WritePackFloat(NewPack, Origin[0]);
			WritePackFloat(NewPack, Origin[1]);
			WritePackFloat(NewPack, Origin[2]);
			CreateTimer(0.5, VomitJarThinkTimer, NewPack);
		}
		else
		{
			new entity = -1;
			while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
			{
				new owner = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
				if (owner == jar)
				{
					SetEntProp(entity, Prop_Send, "m_hOwnerEntity", -1);
					SetEntProp(entity, Prop_Send, "m_iGlowType", 0);
					SetEntProp(entity, Prop_Send, "m_glowColorOverride", 0);
				}
			}
		}		
	}
}
stock bool:IsClientViewing(client, target)
{
    	// Retrieve view and target eyes position
	new Float:fThreshold = 0.73;
    	decl Float:fViewPos[3];   
	GetClientEyePosition(client, fViewPos);
    	decl Float:fViewAng[3];
	GetClientEyeAngles(client, fViewAng);
    	decl Float:fViewDir[3];
    	decl Float:fTargetPos[3];
	GetEntPropVector(target, Prop_Send, "m_vecOrigin", fTargetPos);
	fTargetPos[2] += 30;
    	decl Float:fTargetDir[3];
    	decl Float:fDistance[3];
    
    	// Calculate view direction
    	fViewAng[0] = fViewAng[2] = 0.0;
    	GetAngleVectors(fViewAng, fViewDir, NULL_VECTOR, NULL_VECTOR);
    
    	// Calculate distance to viewer to see if it can be seen.
    	fDistance[0] = fTargetPos[0]-fViewPos[0];
    	fDistance[1] = fTargetPos[1]-fViewPos[1];
    	fDistance[2] = 0.0;
    
    	// Check dot product. If it's negative, that means the viewer is facing
    	// backwards to the target.
    	NormalizeVector(fDistance, fTargetDir);
    	if (GetVectorDotProduct(fViewDir, fTargetDir) < fThreshold) return false;
    
    	// Now check if there are no obstacles in between through raycasting
    	new Handle:hTrace = TR_TraceRayFilterEx(fViewPos, fTargetPos, MASK_PLAYERSOLID_BRUSHONLY, RayType_EndPoint, ClientViewsFilter);
    	if (TR_DidHit(hTrace)) 
	{
		CloseHandle(hTrace); 
		return false; 
	}
    	CloseHandle(hTrace);
    	return true;
}
public bool:ClientViewsFilter(Entity, Mask, any:Junk)
{
    	if (Entity > 0 && IsValidEntity(Entity)) return false;
    	return true;
}
stock GetPlayerEye(client, Float:pos[3], entity) 
{
	new Float:vAngles[3], Float:vOrigin[3];

	GetClientEyePosition(client,vOrigin);
	GetClientEyeAngles(client, vAngles);

	new Handle:trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer, client);

	if (TR_DidHit(trace)) 
	{
		entity = TR_GetEntityIndex(trace);
		//PrintToChat(client, "%i", entity);
		TR_GetEndPosition(pos, trace);
		CloseHandle(trace);
		return entity;
	}

	CloseHandle(trace);
	return 0;
}
public bool:TraceEntityFilterPlayer(entity, mask, any:data)
{
	return (entity > 0 && entity != data) || !entity;
}
stock bool:IsLaserWeapon(entity)
{
	if (entity > 0 && IsValidEntity(entity))
	{
		new String:classname[32];
		GetEdictClassname(entity, classname, sizeof(classname));
		for (new count=0; count<=11; count++)
		{
			//PrintToChatAll("%s %s", classname, LaserWeapons[count]);
			if (StrEqual(classname, LaserWeapons[count], false))
			{
				return true;
			}
		}
	}
	return false;
}
stock bool:IsLaserViewModel(entity)
{
	if (entity > 0 && IsValidEntity(entity))
	{
		new String:classname[32];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "predicted_viewmodel", false))
		{
			new String:model[64];	
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			for (new count=0; count<=11; count++)
			{
				if (StrEqual(model, WeaponViewModels[count], false))
				{
					return true;
				}
			}
		}
	}
	return false;
}
stock CreateLaser(entity, Float:Position[3])
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String:name[16];
		new endpoint = CreateEntityByName("info_particle_target");
		if (endpoint > 0 && IsValidEntity(endpoint))
		{
			Format(name, sizeof(name), "cptarget%i", endpoint);
			DispatchKeyValue(endpoint, "targetname", name);	
			DispatchKeyValueVector(endpoint, "origin", Position);
			DispatchSpawn(endpoint);
			ActivateEntity(endpoint);
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(endpoint, "AddOutput");
			AcceptEntityInput(endpoint, "FireUser1");
		}
		new particle = CreateEntityByName("info_particle_system");
		if (particle > 0 && IsValidEntity(particle))
		{
			DispatchKeyValue(particle, "effect_name", PARTICLE_LASER);
			DispatchKeyValue(particle, "cpoint1", name);
			//DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);

			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity);
			SetVariantString("muzzle_flash");
			AcceptEntityInput(particle, "SetParentAttachment");

			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
	}
}
public Action:AmmoPackKill(Handle:timer, any:entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[24];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "upgrade_ammo_incendiary", false) || StrEqual(classname, "upgrade_ammo_explosive", false))
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
}
public Action:TransferLaserSight(Handle:timer, any:client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (GetPlayerWeaponSlot(client, 0) > 0)
		{
			new entity = GetPlayerWeaponSlot(client, 0);
			if (entity > 32 && IsValidEntity(entity))
			{
				new upgrade = GetEntProp(entity, Prop_Send, "m_upgradeBitVec");
				if (upgrade != 4 && upgrade != 5 && upgrade != 6)
				{
					SetEntProp(entity, Prop_Send, "m_upgradeBitVec", 4);
					PrintToChat(client, "\x05[Lethal-Injection]\x04 Swapping Laser Sight");
				}
			}
		}
	}
}
public Action:SwitchInfected(Handle:timer, any:client)
{
	if (IsClientInGame(client) && GetClientTeam(client) != 3)
	{
		ChangeClientTeam(client, 3);
	}	
}
public Action:SpawnHunter(Handle:timer, any:client)
{
	if (IsClientInGame(client) && !IsPlayerAlive(client) && GetClientTeam(client) == 3)
	{
		SetEntProp(client, Prop_Send, "m_scrimmageType", 0);
		InfectedForceGhost(client);
	}	
}
////////////////
/// BackPack ///
////////////////
stock StoreItemToBackpack(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		if (BackpackDelay[client] > 0)
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You must wait a second to use this.");
			return;
		}
		new maxslots = 12;
		new usedslots = 0;
		for (new count=1; count<=12; count++)
		{
			if (BackpackItemID[client][count] == 0 && maxslots > usedslots)
			{
				new String:weaponname[32];
				GetClientWeapon(client, weaponname, sizeof(weaponname));
				if (StrEqual(weaponname, "weapon_melee", false))
				{
					new weaponid = GetPlayerWeaponSlot(client, 1);
					new String:Model[48];
					GetEntPropString(weaponid, Prop_Data, "m_ModelName", Model, sizeof(Model));
					if (StrEqual(Model, MODEL_V_FIREAXE, false)) weaponname = "weapon_fireaxe";
					else if (StrEqual(Model, MODEL_V_FRYING_PAN, false)) weaponname = "weapon_frying_pan";
					else if (StrEqual(Model, MODEL_V_MACHETE, false)) weaponname = "weapon_machete";
					else if (StrEqual(Model, MODEL_V_BAT, false)) weaponname = "weapon_baseball_bat";
					else if (StrEqual(Model, MODEL_V_CROWBAR, false)) weaponname = "weapon_crowbar";
					else if (StrEqual(Model, MODEL_V_CRICKET_BAT, false)) weaponname = "weapon_cricket_bat";
					else if (StrEqual(Model, MODEL_V_TONFA, false)) weaponname = "weapon_tonfa";
					else if (StrEqual(Model, MODEL_V_KATANA, false)) weaponname = "weapon_katana";
					else if (StrEqual(Model, MODEL_V_ELECTRIC_GUITAR, false)) weaponname = "weapon_electric_guitar";
					else if (StrEqual(Model, MODEL_V_KNIFE, false)) weaponname = "weapon_knife";
					else if (StrEqual(Model, MODEL_V_GOLFCLUB, false)) weaponname = "weapon_golfclub";		
				}

				new index;
				new level = cLevel[client];
				//Armsdealer
				if (level >= 19)
				{
					index = 40;
				}	
				else
				{
					index = 9;
				}
				new slot = 2;
				for (new id=1; id<=index; id++)
				{
					switch(id)
					{
						case 4: slot = 3;
						case 8:	slot = 4;
						case 10: slot = 1;
						case 24: slot = 0;
					}
					//PrintToChat(client, "Current:%s, ToMatch:%s", weaponname, WeaponClassname[id]);
					if (StrEqual(weaponname, WeaponClassname[id], false))
					{
						if (id == 10 || id == 11)
						{
							PrintToChat(client, "\x05[Lethal-Injection]\x01 You can't store this weapon.");
							return;
						}
						new weaponid = GetPlayerWeaponSlot(client, slot);
						if (slot == 0)
						{
							new offset = GetWeaponAmmoOffset(weaponid);
							BackpackGunInfo[client][count][0] = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset));
							BackpackGunInfo[client][count][1] = offset;
							BackpackGunInfo[client][count][2] = GetEntProp(weaponid, Prop_Send, "m_iClip1");
							BackpackGunInfo[client][count][3] = GetEntProp(weaponid, Prop_Send, "m_upgradeBitVec");
							BackpackGunInfo[client][count][4] = GetEntProp(weaponid, Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
						}
						else if (slot == 1)
						{
							if (StrEqual(weaponname, "weapon_chainsaw", false))
							{
								//PrintToChat(client, "Store->clip: %i", GetEntProp(weaponid, Prop_Send, "m_iClip1"));
								BackpackGunInfo[client][count][0] = 0;
								BackpackGunInfo[client][count][1] = 0;
								BackpackGunInfo[client][count][2] = GetEntProp(weaponid, Prop_Send, "m_iClip1");
								BackpackGunInfo[client][count][3] = 0;
								BackpackGunInfo[client][count][4] = 0;
							}
							else
							{
								BackpackGunInfo[client][count][0] = 0;
								BackpackGunInfo[client][count][1] = 0;
								BackpackGunInfo[client][count][2] = 0;
								BackpackGunInfo[client][count][3] = 0;
								BackpackGunInfo[client][count][4] = 0;
							}
						}
						else
						{
							BackpackGunInfo[client][count][0] = 0;
							BackpackGunInfo[client][count][1] = 0;
							BackpackGunInfo[client][count][2] = 0;
							BackpackGunInfo[client][count][3] = 0;
							BackpackGunInfo[client][count][4] = 0;
						}
						//L4D2_WeaponDrop(client, weaponid);
						//AcceptEntityInput(weaponid, "Kill");
						RemovePlayerItem(client, weaponid);
						if (slot == 1)
						{
							CheatCommand(client, "give", "pistol");
						}
						BackpackItemID[client][count] = id;
						PrintToChat(client, "\x05[Lethal-Injection]\x01 You put the \x04%s\x01 in your backpack.", WeaponItemName[id]);
						return;
					}
				}
				//Armsdealer
				if (level >= 41)
				{
					PrintToChat(client, "\x05[Lethal-Injection]\x01 You can't store this.");
				}
				else
				{
					PrintToChat(client, "\x05[Lethal-Injection]\x01 You can only store throwables and healing items.");
				}
				return;
			}
			else
			{
				usedslots++;
				if (maxslots == usedslots)
				{
					PrintToChat(client, "\x05[Lethal-Injection]\x01 Your Backpack is Full.");
					return;
				}
			}
		}	
	}
}
stock GetUsedBackpackSlots(client)
{
	new usedslots = 0;
	for (new count=1; count<=12; count++)
	{
		if (BackpackItemID[client][count] > 0)
		{
			usedslots++;
		}
	}
	return usedslots;
}
stock GiveBackpackItem(client, slot, String:WeaponClass[], String:WeaponName[])
{
	if (client > 0 && IsClientInGame(client))
	{
		if (BackpackDelay[client] > 0)
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You must wait a second to use this.");
			return;
		}
		new swapped = 0;
		new swappedid, slottype = -1, ammo, offset, clip, upgrade, upgradeammo;
		new String:SwappedClass[32];
		new String:SwappedName[32];
		new String:classname[32];
		new slottypeid = GetSlotType(WeaponClassname[BackpackItemID[client][slot]]);
		new weaponslotid = GetPlayerWeaponSlot(client, slottypeid);
		if (weaponslotid > 0)
		{
			GetEdictClassname(weaponslotid, classname, sizeof(classname));
			if (StrEqual(classname, "weapon_melee", false))
			{
				new weaponid = GetPlayerWeaponSlot(client, 1);
				new String:Model[48];
				GetEntPropString(weaponid, Prop_Data, "m_ModelName", Model, sizeof(Model));
				if (StrEqual(Model, MODEL_V_FIREAXE, false)) classname = "weapon_fireaxe";
				else if (StrEqual(Model, MODEL_V_FRYING_PAN, false)) classname = "weapon_frying_pan";
				else if (StrEqual(Model, MODEL_V_MACHETE, false)) classname = "weapon_machete";
				else if (StrEqual(Model, MODEL_V_BAT, false)) classname = "weapon_baseball_bat";
				else if (StrEqual(Model, MODEL_V_CROWBAR, false)) classname = "weapon_crowbar";
				else if (StrEqual(Model, MODEL_V_CRICKET_BAT, false)) classname = "weapon_cricket_bat";
				else if (StrEqual(Model, MODEL_V_TONFA, false)) classname = "weapon_tonfa";
				else if (StrEqual(Model, MODEL_V_KATANA, false)) classname = "weapon_katana";
				else if (StrEqual(Model, MODEL_V_ELECTRIC_GUITAR, false)) classname = "weapon_electric_guitar";
				else if (StrEqual(Model, MODEL_V_KNIFE, false)) classname = "weapon_knife";
				else if (StrEqual(Model, MODEL_V_GOLFCLUB, false)) classname = "weapon_golfclub";		
			}
		}
		new index;
		new level = cLevel[client];
		//Armsdealer
		if (level >= 19)
		{
			index = 40;
		}
		else
		{
			index = 9;
		}
		for (new id=1; id<=index; id++)
		{
			if (StrEqual(classname, WeaponClassname[id], false) && id != 10 && id != 11)
			{
				slottype = GetSlotType(classname);
				if (slottype >= 0 && GetPlayerWeaponSlot(client, slottype) > 0)
				{
					new weaponid = GetPlayerWeaponSlot(client, slottype);
					if (slottype == 0)
					{
						offset = GetWeaponAmmoOffset(weaponid);
						ammo = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset));
						clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
						upgrade = GetEntProp(weaponid, Prop_Send, "m_upgradeBitVec");
						upgradeammo = GetEntProp(weaponid, Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
					}
					else if (slottype == 1)
					{
						if (StrEqual(classname, "weapon_chainsaw", false))
						{
							clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
							//PrintToChat(client, "Store->clip: %i", clip);
						}
					}
					//L4D2_WeaponDrop(client, weaponid);
					//AcceptEntityInput(weaponid, "Kill");
					RemovePlayerItem(client, weaponid);
					strcopy(SwappedName, sizeof(SwappedName), WeaponItemName[id]);
					strcopy(SwappedClass, sizeof(SwappedClass), WeaponClassname[id]);
					swappedid = id;
					swapped = 1;
					break;
				}
			}	
		}
		new Handle:Pack = CreateDataPack();
		WritePackCell(Pack, iRound);
		WritePackCell(Pack, client);
		WritePackCell(Pack, slot);
		WritePackCell(Pack, slottypeid);
		WritePackCell(Pack, swapped);
		WritePackCell(Pack, swappedid);
		WritePackCell(Pack, ammo);
		WritePackCell(Pack, offset);
		WritePackCell(Pack, clip);
		WritePackCell(Pack, upgrade);
		WritePackCell(Pack, upgradeammo);
		WritePackString(Pack, WeaponClass);
		WritePackString(Pack, WeaponName);
		WritePackString(Pack, SwappedClass);
		WritePackString(Pack, SwappedName);
		CreateTimer(0.1, GiveBackPackItemTimer, Pack);
		BackpackDelay[client] = 1;
	}
}
stock GetSlotType(String:WeaponName[])
{
	new slot = 2;
	for (new id=1; id<=40; id++)
	{
		switch(id)
		{
			case 4: slot = 3;
			case 8:	slot = 4;
			case 10: slot = 1;
			case 24: slot = 0;
		}
		if (StrEqual(WeaponName, WeaponClassname[id], false))
		{
			return slot;
		}
	}
	return 0;	
}
public Action:GiveBackPackItemTimer(Handle:timer, any:Pack)
{
	ResetPack(Pack, false);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new slot = ReadPackCell(Pack);
	new slottype = ReadPackCell(Pack);
	new swapped = ReadPackCell(Pack);
	new swappedid = ReadPackCell(Pack);
	new ammo = ReadPackCell(Pack);
	new offset = ReadPackCell(Pack);
	new clip = ReadPackCell(Pack);
	new upgrade = ReadPackCell(Pack);
	new upgradeammo = ReadPackCell(Pack);
	new String:WeaponClass[32];
	new String:WeaponName[32];
	new String:SwappedClass[32];
	new String:SwappedName[32];
	ReadPackString(Pack, WeaponClass, sizeof(WeaponClass));
	ReadPackString(Pack, WeaponName, sizeof(WeaponName));
	ReadPackString(Pack, SwappedClass, sizeof(SwappedClass));
	ReadPackString(Pack, SwappedName, sizeof(SwappedName));
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	
	if (client > 0 && IsClientInGame(client))
	{
		new String:ItemClassName[32];
		strcopy(ItemClassName, sizeof(ItemClassName), WeaponClass);
		ReplaceString(ItemClassName, sizeof(ItemClassName), "weapon_", "");
		//PrintToChat(client, "giving %s", ItemClassName);
		CheatCommand(client, "give", ItemClassName);
		if (slottype == 0)
		{
			new Handle:NewPack = CreateDataPack();
			WritePackCell(NewPack, iRound);
			WritePackCell(NewPack, client);
			WritePackCell(NewPack, BackpackGunInfo[client][slot][0]);
			WritePackCell(NewPack, BackpackGunInfo[client][slot][1]);
			WritePackCell(NewPack, BackpackGunInfo[client][slot][2]);
			WritePackCell(NewPack, BackpackGunInfo[client][slot][3]);
			WritePackCell(NewPack, BackpackGunInfo[client][slot][4]);
			CreateTimer(0.1, RetrieveBackpackGunInfo, NewPack);
		}
		else if (slottype == 1)
		{
			if (StrEqual(WeaponClass, "weapon_chainsaw", false))
			{
				new Handle:NewPack = CreateDataPack();
				WritePackCell(NewPack, iRound);
				WritePackCell(NewPack, client);
				WritePackCell(NewPack, BackpackGunInfo[client][slot][2]);
				CreateTimer(0.1, RetrieveBackpackChainsawInfo, NewPack);
			}
		}
		if (swapped == 0)
		{
			//PrintToChat(client, "Clear->clip: %i", clip);
			BackpackItemID[client][slot] = 0;
			BackpackGunInfo[client][slot][0] = 0;
			BackpackGunInfo[client][slot][1] = 0;
			BackpackGunInfo[client][slot][2] = 0;
			BackpackGunInfo[client][slot][3] = 0;
			BackpackGunInfo[client][slot][4] = 0;
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You pulled the \x04%s\x01 out of your backpack.", WeaponName);
		}
		else
		{
			BackpackItemID[client][slot] = swappedid;
			if (slottype == 0)
			{
				BackpackGunInfo[client][slot][0] = ammo;
				BackpackGunInfo[client][slot][1] = offset;
				BackpackGunInfo[client][slot][2] = clip;
				BackpackGunInfo[client][slot][3] = upgrade;
				BackpackGunInfo[client][slot][4] = upgradeammo;
			}
			else if (slottype == 1)
			{
				if (StrEqual(SwappedClass, "weapon_chainsaw", false))
				{
					//PrintToChat(client, "Swap->clip: %i", clip);
					BackpackGunInfo[client][slot][0] = 0;
					BackpackGunInfo[client][slot][1] = 0;
					BackpackGunInfo[client][slot][2] = clip;
					BackpackGunInfo[client][slot][3] = 0;
					BackpackGunInfo[client][slot][4] = 0;
				}
				else
				{
					BackpackGunInfo[client][slot][0] = 0;
					BackpackGunInfo[client][slot][1] = 0;
					BackpackGunInfo[client][slot][2] = 0;
					BackpackGunInfo[client][slot][3] = 0;
					BackpackGunInfo[client][slot][4] = 0;
				}
			}
			else
			{
				BackpackGunInfo[client][slot][0] = 0;
				BackpackGunInfo[client][slot][1] = 0;
				BackpackGunInfo[client][slot][2] = 0;
				BackpackGunInfo[client][slot][3] = 0;
				BackpackGunInfo[client][slot][4] = 0;
			}
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You swapped a \x04%s\x01 for a \x04%s\x01 from your backpack.", WeaponName, SwappedName);
		}
	}
}
public Action:RetrieveBackpackGunInfo(Handle:timer, any:Pack)
{
	ResetPack(Pack, false);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new ammo = ReadPackCell(Pack);
	new offset = ReadPackCell(Pack);
	new clip = ReadPackCell(Pack);
	new upgrade = ReadPackCell(Pack);
	new upgradeammo = ReadPackCell(Pack);

	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	
	if (client > 0 && IsClientInGame(client))
	{
		if (GetPlayerWeaponSlot(client, 0) > 0)
		{
			new weaponid = GetPlayerWeaponSlot(client, 0);
			if (weaponid > 0)
			{
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), ammo);
				SetEntProp(weaponid, Prop_Send, "m_iClip1", clip);
				SetEntProp(weaponid, Prop_Send, "m_upgradeBitVec", upgrade);
				SetEntProp(weaponid, Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", upgradeammo);
				SetEntProp(weaponid, Prop_Send, "m_iExtraPrimaryAmmo", upgradeammo);
			}
		}	
	}
}
public Action:RetrieveBackpackChainsawInfo(Handle:timer, any:Pack)
{
	ResetPack(Pack, false);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new clip = ReadPackCell(Pack);

	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	
	if (client > 0 && IsClientInGame(client))
	{
		if (GetPlayerWeaponSlot(client, 1) > 0)
		{
			new weaponid = GetPlayerWeaponSlot(client, 1);
			if (weaponid > 0)
			{
				//PrintToChat(client, "Load->clip: %i", clip);
				SetEntProp(weaponid, Prop_Send, "m_iClip1", clip);
			}
		}	
	}
}
///////////////////////////
/// Spawn Heavy Weapons ///
///////////////////////////
stock SpawnHeavies()
{
	if (iSpawnHeavy > 0) 
	{
		return;
	}
	new random = GetRandomInt(1,6);
	if (random == 1)
	{
		new Handle:IndexArray;
		IndexArray = CreateArray();
		new index = -1;
		while ((index = FindEntityByClassname(index, "weapon_spawn")) != INVALID_ENT_REFERENCE)
		{
			PushArrayCell(IndexArray, index);
		}
		if (GetArraySize(IndexArray) > 0)
		{
			random = GetRandomInt(0,GetArraySize(IndexArray)-1);
		}
		else
		{
			return;
		}
		new Float:Origin[3];
		new entity = GetArrayCell(IndexArray, random);
		CloseHandle(IndexArray);
		if (entity > 32 && IsValidEntity(entity))
		{
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
		}
		Origin[2] = Origin[2] += 35.0;

		decl String:weapon[24];
		new type = GetRandomInt(1,2);
		switch(type)
		{
			case 1: weapon = "weapon_rifle_m60";
			case 2: weapon = "weapon_grenade_launcher";
		}
		if (Origin[0] != 0.0 && Origin[1] != 0.0 && Origin[2] != 0.0)
		{
			entity = CreateEntityByName(weapon);
			if (entity > 0)
			{
				DispatchSpawn(entity);
				TeleportEntity(entity, Origin, NULL_VECTOR, NULL_VECTOR);
				if (type == 2)
				{
					SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 30);
				}
				iSpawnHeavy = entity;
				PrintToServer("SpawnHeavies() Entity:%i, Class:%s, Origin:%f %f %f", entity, weapon, Origin[0], Origin[1], Origin[2]);
			}
		}
	}
	else
	{
		iSpawnHeavy = 999;
		PrintToServer("SpawnHeavies() No Heavy this map");
	}
}
stock QuantifyWeapons()
{
	if (iQuantifyWeapons == 0)
	{
		decl String:classname[32];
		new entcount = GetEntityCount();
		for (new i=33; i<=entcount; i++)
		{
			if (IsValidEntity(i))
			{
				GetEdictClassname(i, classname, sizeof(classname));
				if (StrContains(classname, "weapon_", false) != -1 && StrContains(classname, "spawn", false) != -1 && StrContains(classname, "item", false) == -1 && StrContains(classname, "ammo", false) == -1)
				{
					if (StrContains(classname, "rifle_m60", false) != -1 || StrContains(classname, "grenade_launcher", false) != -1)
					{
						SetEntProp(i, Prop_Data, "m_itemCount", 1);
					}
					else
					{
						new amount = CountConnecting();
						PrintToServer("fixing weapon counts for %s", classname);
						if (amount > 0)
						{
							SetEntProp(i, Prop_Data, "m_itemCount", amount);
						}
						else
						{
							SetEntProp(i, Prop_Data, "m_itemCount", 1);
						}
					}
				}
			}
		}
		iQuantifyWeapons = 1;
	}
}
//=============================
// Character Select Menu
//=============================
public Action:CharMenu(client, args)
{
	if (client > 0 && IsClientInGame(client))
	{
		CharMenuFunc(client);
	}
	return Plugin_Handled;
}
stock CharMenuFunc(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new Handle:menu = CreateMenu(CharMenuHandler);
		SetMenuTitle(menu, "Choose a character");
		if (GetClientTeam(client) == 2)
		{
			if (IsPlayerAlive(client))
			{
				if (!bIsL4D2)
				{
					AddMenuItem(menu, "Bill", "Bill");
					AddMenuItem(menu, "Zoey", "Zoey");
					AddMenuItem(menu, "Louis", "Louis");
					AddMenuItem(menu, "Francis", "Francis");
				}
				else
				{
					AddMenuItem(menu, "Nick", "Nick");
					AddMenuItem(menu, "Rochelle", "Rochelle");
					AddMenuItem(menu, "Coach", "Coach");
					AddMenuItem(menu, "Ellis", "Ellis");
					AddMenuItem(menu, "Zoey", "Zoey");
					AddMenuItem(menu, "Francis", "Francis");
					AddMenuItem(menu, "Louis", "Louis");
					AddMenuItem(menu, "Bill", "Bill");
				}
			}
			else
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You must be alive to use the Character Select Menu!");
				return;
			}
		}
		else
		{
			return;
		}
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
}
public CharMenuHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[10];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		if (StrContains(name, "Nick", false) != -1)
		{
			Character[client] = 1;
			RemoveAttachments(client);
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You are now \x03Nick");
		}
		else if (StrContains(name, "Rochelle", false) != -1)
		{
			Character[client] = 2;
			RemoveAttachments(client);
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You are now \x03Rochelle");
		}
		else if (StrContains(name, "Coach", false) != -1)
		{
			Character[client] = 3;
			RemoveAttachments(client);
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You are now \x03Coach");
		}
		else if (StrContains(name, "Ellis", false) != -1)
		{
			Character[client] = 4;
			RemoveAttachments(client);
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You are now \x03Ellis");
		}
		else if (StrContains(name, "Bill", false) != -1)
		{
			Character[client] = 5;
			RemoveAttachments(client);
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You are now \x03Bill");
		}
		else if (StrContains(name, "Zoey", false) != -1)
		{
			Character[client] = 6;
			RemoveAttachments(client);
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You are now \x03Zoey");
		}
		else if (StrContains(name, "Francis", false) != -1)
		{
			Character[client] = 7;
			RemoveAttachments(client);
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You are now \x03Francis");
		}
		else if (StrContains(name, "Louis", false) != -1)
		{
			Character[client] = 8;
			RemoveAttachments(client);
			CreateTimer(0.1, SetCharacter, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreWeapons, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.2, RestoreAttachments, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You are now \x03Louis");
		}
	}
}
public Action:SetCharacter(Handle:timer, any:client)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		new model = Character[client];
		switch(model)
		{
			case 1:
			{
				SetEntProp(client, Prop_Send, "m_survivorCharacter", 0);
				if (bIsL4D2)
				{
					SetEntityModel(client, MODEL_NICK);
				}
				else
				{
					SetEntityModel(client, MODEL_BILL);
				}
			}
			case 2:
			{
				SetEntProp(client, Prop_Send, "m_survivorCharacter", 1);
				if (bIsL4D2)
				{
					SetEntityModel(client, MODEL_ROCHELLE);
				}
				else
				{
					SetEntityModel(client, MODEL_ZOEY);
				}
			}
			case 3:
			{
				SetEntProp(client, Prop_Send, "m_survivorCharacter", 2);
				if (bIsL4D2)
				{
					SetEntityModel(client, MODEL_COACH);
				}
				else
				{
					SetEntityModel(client, MODEL_FRANCIS);
				}
			}
			case 4:
			{
				SetEntProp(client, Prop_Send, "m_survivorCharacter", 3);
				if (bIsL4D2)
				{
					SetEntityModel(client, MODEL_ELLIS);
				}
				else
				{
					SetEntityModel(client, MODEL_LOUIS);
				}
			}
			case 5:
			{
				if (bIsL4D2)
				{
					SetEntProp(client, Prop_Send, "m_survivorCharacter", 4);
					SetEntityModel(client, MODEL_BILL);
				}
				else
				{
					SetEntProp(client, Prop_Send, "m_survivorCharacter", 0);
					SetEntityModel(client, MODEL_BILL);
				}
			}
			case 6:
			{
				if (bIsL4D2)
				{
					SetEntProp(client, Prop_Send, "m_survivorCharacter", 5);
					SetEntityModel(client, MODEL_ZOEY);
				}
				else
				{
					SetEntProp(client, Prop_Send, "m_survivorCharacter", 1);
					SetEntityModel(client, MODEL_ZOEY);
				}
			}
			case 7:
			{
				if (bIsL4D2)
				{
					//SetEntProp(client, Prop_Send, "m_survivorCharacter", 2);
					//SetEntityModel(client, MODEL_COACH);
					SetEntProp(client, Prop_Send, "m_survivorCharacter", 6);
					SetEntityModel(client, MODEL_FRANCIS);
				}
				else
				{
					SetEntProp(client, Prop_Send, "m_survivorCharacter", 3);
					SetEntityModel(client, MODEL_FRANCIS);
				}
			}
			case 8:
			{
				if (bIsL4D2)
				{
					SetEntProp(client, Prop_Send, "m_survivorCharacter", 7);
					SetEntityModel(client, MODEL_LOUIS);
				}
				else
				{
					SetEntProp(client, Prop_Send, "m_survivorCharacter", 2);
					SetEntityModel(client, MODEL_LOUIS);	
				}
			}
		}	
	}
}
//=============================
// WEAPON SPAWN CONTROL
//=============================
stock RecordWeapons(client)
{
	if (!IsServerProcessing()) return;

	if (IsSurvivor(client) && IsPlayerAlive(client) && !IsPlayerIncap(client) && WeaponsRestored[client] == 1 && IsPlayerSpawned(client))
	{
		for (new slot=0; slot<=4; slot++)
		{
			if (GetPlayerWeaponSlot(client, slot) > 0)
			{
				new weapon = GetPlayerWeaponSlot(client, slot);
				if (weapon > 0)
				{
					new String:classname[32];
					GetEdictClassname(weapon, classname, sizeof(classname));
					if (StrEqual(classname, "weapon_melee", false))
					{
						new String:Model[48];
						GetEntPropString(weapon, Prop_Data, "m_ModelName", Model, sizeof(Model));
						if (StrEqual(Model, MODEL_V_FIREAXE, false)) classname = "weapon_fireaxe";
						else if (StrEqual(Model, MODEL_V_FRYING_PAN, false)) classname = "weapon_frying_pan";
						else if (StrEqual(Model, MODEL_V_MACHETE, false)) classname = "weapon_machete";
						else if (StrEqual(Model, MODEL_V_BAT, false)) classname = "weapon_baseball_bat";
						else if (StrEqual(Model, MODEL_V_CROWBAR, false)) classname = "weapon_crowbar";
						else if (StrEqual(Model, MODEL_V_CRICKET_BAT, false)) classname = "weapon_cricket_bat";
						else if (StrEqual(Model, MODEL_V_TONFA, false)) classname = "weapon_tonfa";
						else if (StrEqual(Model, MODEL_V_KATANA, false)) classname = "weapon_katana";
						else if (StrEqual(Model, MODEL_V_ELECTRIC_GUITAR, false)) classname = "weapon_electric_guitar";
						else if (StrEqual(Model, MODEL_V_KNIFE, false)) classname = "weapon_knife";
						else if (StrEqual(Model, MODEL_V_GOLFCLUB, false)) classname = "weapon_golfclub";
					}
					for (new count=1; count<=40; count++)
					{
						if (StrEqual(classname, WeaponClassname[count], false))
						{
							if (slot == 0)
							{
								new entity = GetPlayerWeaponSlot(client, 0);
								new offset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
								new ammooffset = GetWeaponAmmoOffset(weapon);
								cSlot0Ammo[client] = GetEntData(client, offset+(ammooffset));
								cSlot0AmmoOffset[client] = ammooffset;
								cSlot0Clip[client] = GetEntProp(entity, Prop_Send, "m_iClip1");
								cSlot0Upgrade[client] = GetEntProp(entity, Prop_Send, "m_upgradeBitVec");
								cSlot0UpgradeAmmo[client] = GetEntProp(entity, Prop_Send, "m_nUpgradedPrimaryAmmoLoaded");
							}
							else if (slot == 1)
							{
								new entity = GetPlayerWeaponSlot(client, 1);
								if (StrEqual(classname, "weapon_pistol", false))
								{
									if (GetEntProp(entity, Prop_Send, "m_isDualWielding") > 0)
									{
										cSlot1Dual[client] = 1;
									}
									else
									{
										cSlot1Dual[client] = 0;
									}
								}
								else
								{
									cSlot1Dual[client] = 0;
								}
								cSlot1Clip[client] = GetEntProp(entity, Prop_Send, "m_iClip1");
							}
							ReplaceString(classname, sizeof(classname), "weapon_", "");
							switch(slot)
							{
								case 0: cSlot0Weapon[client] = classname;
								case 1: cSlot1Weapon[client] = classname;
								case 2: cSlot2Weapon[client] = classname;
								case 3: cSlot3Weapon[client] = classname;
								case 4: cSlot4Weapon[client] = classname;
							}
						}
					}
				}
			}
			else
			{
				switch(slot)
				{
					case 0:
					{
						cSlot0AmmoOffset[client] = 0;
						cSlot0Ammo[client] = 0;
						cSlot0Clip[client] = 0;
						cSlot0UpgradeAmmo[client] = 0;
						cSlot0Upgrade[client] = 0;
						cSlot0Weapon[client] = "0";
					}
					case 1:
					{
						cSlot1Clip[client] = 0;
						cSlot1Dual[client] = 0;
						cSlot1Weapon[client] = "0";
					}
					case 2: cSlot2Weapon[client] = "0";
					case 3: cSlot3Weapon[client] = "0";
					case 4: cSlot4Weapon[client] = "0";
				}
			}
			//PrintToChat(client, "%s", cSlot0Weapon[client]);
		}
	}
}
stock GetWeaponAmmoOffset(entity)
{	
	if (entity > 0 && IsValidEntity(entity))
	{
		new String:classname[32];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "weapon_rifle", false) || StrEqual(classname, "weapon_rifle_sg552", false) || StrEqual(classname, "weapon_rifle_desert", false) || StrEqual(classname, "weapon_rifle_ak47", false))
		{
			return 12;
		}
		else if (StrEqual(classname, "weapon_smg", false) || StrEqual(classname, "weapon_smg_silenced", false) || StrEqual(classname, "weapon_smg_mp5", false))
		{
			return 20;
		}
		else if (StrEqual(classname, "weapon_rifle_m60", false))
		{
			return 24;
		}
		else if (StrEqual(classname, "weapon_pumpshotgun", false) || StrEqual(classname, "weapon_shotgun_chrome", false))
		{
			return 28;
		}
		else if (StrEqual(classname, "weapon_autoshotgun", false) || StrEqual(classname, "weapon_shotgun_spas", false))
		{
			return 32;
		}
		else if (StrEqual(classname, "weapon_hunting_rifle", false))
		{
			return 36;
		}
		else if (StrEqual(classname, "weapon_sniper_scout", false) || StrEqual(classname, "weapon_sniper_military", false) || StrEqual(classname, "weapon_sniper_awp", false))
		{
			return 40;
		}
		else if (StrEqual(classname, "weapon_grenade_launcher", false))
		{
			return 68;
		}
	}
	return 0;
}
public Action:RestoreWeapons(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		WeaponsRestored[client] = 0;
		//PrintToChat(client, "Restoring Weapons");
		//PrintToChat(client, "%s", cSlot0Weapon[client]);
		//PrintToChat(client, "%s", cSlot1Weapon[client]);
		//PrintToChat(client, "%s", cSlot2Weapon[client]);
		//PrintToChat(client, "%s", cSlot3Weapon[client]);
		//PrintToChat(client, "%s", cSlot4Weapon[client]);
		if (!StrEqual(cSlot0Weapon[client], "0", false))
		{
			if (GetPlayerWeaponSlot(client, 0) > 0)
			{
				new weapon = GetPlayerWeaponSlot(client, 0);
				if (weapon > 0)
				{
					new String:weaponclass[32];
					Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot0Weapon[client]);
					if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
					{
						AcceptEntityInput(weapon, "Kill");
						CreateTimer(0.1, EquipSlot0Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			else
			{
				new String:weaponclass[32];
				Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot0Weapon[client]);
				if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
				{
					CreateTimer(0.1, EquipSlot0Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		else
		{
			ClearSlot0Offsets(client);
		}
		if (!StrEqual(cSlot1Weapon[client], "0", false))
		{
			if (GetPlayerWeaponSlot(client, 1) > 0)
			{
				new weapon = GetPlayerWeaponSlot(client, 1);
				if (weapon > 0)
				{
					new String:weaponclass[32];
					Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot1Weapon[client]);
					if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
					{
						AcceptEntityInput(weapon, "Kill");
						CreateTimer(0.1, EquipSlot1Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			else
			{
				new String:weaponclass[32];
				Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot1Weapon[client]);
				if (StrEqual(weaponclass, "weapon_", false) || StrEqual(weaponclass, "weapon_0", false))
				{
					cSlot1Weapon[client] = "weapon_pistol";
				}
				CreateTimer(0.1, EquipSlot1Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		else
		{
			ClearSlot1Offsets(client);
		}
		if (!StrEqual(cSlot2Weapon[client], "0", false))
		{
			if (GetPlayerWeaponSlot(client, 2) > 0)
			{
				new weapon = GetPlayerWeaponSlot(client, 2);
				if (weapon > 0)
				{
					new String:weaponclass[32];
					Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot2Weapon[client]);
					if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
					{
						AcceptEntityInput(weapon, "Kill");
						CreateTimer(0.1, EquipSlot2Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			else
			{
				new String:weaponclass[32];
				Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot2Weapon[client]);
				if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
				{
					CreateTimer(0.1, EquipSlot2Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		else
		{
			ClearSlot2Offsets(client);
		}
		if (!StrEqual(cSlot3Weapon[client], "0", false))
		{
			if (GetPlayerWeaponSlot(client, 3) > 0)
			{
				new weapon = GetPlayerWeaponSlot(client, 3);
				if (weapon > 0)
				{
					new String:weaponclass[32];
					Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot3Weapon[client]);
					if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
					{
						AcceptEntityInput(weapon, "Kill");
						CreateTimer(0.1, EquipSlot3Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			else
			{
				new String:weaponclass[32];
				Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot3Weapon[client]);
				if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
				{
					CreateTimer(0.1, EquipSlot3Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		else
		{
			ClearSlot3Offsets(client);
		}
		if (!StrEqual(cSlot4Weapon[client], "0", false))
		{
			if (GetPlayerWeaponSlot(client, 4) > 0)
			{
				new weapon = GetPlayerWeaponSlot(client, 4);
				if (weapon > 0)
				{
					new String:weaponclass[32];
					Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot4Weapon[client]);
					if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
					{
						AcceptEntityInput(weapon, "Kill");
						CreateTimer(0.1, EquipSlot4Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			else
			{
				new String:weaponclass[32];
				Format(weaponclass, sizeof(weaponclass), "weapon_%s", cSlot4Weapon[client]);
				if (!StrEqual(weaponclass, "weapon_", false) && !StrEqual(weaponclass, "weapon_0", false))
				{
					CreateTimer(0.1, EquipSlot4Weapon, client, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		else
		{
			ClearSlot4Offsets(client);
		}
		CreateTimer(0.3, ResetWeaponsRestored, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}
public Action:ResetWeaponsRestored(Handle:timer, any:client)
{
	WeaponsRestored[client] = 1;
}
public Action:EquipSlot0Weapon(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		ClearSlot0Offsets(client);
		CheatCommand(client, "give", cSlot0Weapon[client]);
		CreateTimer(0.1, EquipSlot0Ammo, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}
public Action:EquipSlot0Ammo(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		if (GetPlayerWeaponSlot(client, 0) > 0)
		{
			new entity = GetPlayerWeaponSlot(client, 0);
			new offset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
			new ammo = cSlot0Ammo[client];
			new clip = cSlot0Clip[client];
			if (clip < 0)
			{
				clip = 0;
			}
			new upgrade = cSlot0Upgrade[client];
			new upammo = cSlot0UpgradeAmmo[client];
			new ammooffset = cSlot0AmmoOffset[client];
			if (ammooffset > 0)
			{
				SetEntData(client, offset+(ammooffset), ammo);
			}
			SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", upammo);
			SetEntProp(entity, Prop_Send, "m_iClip1", clip);
			SetEntProp(entity, Prop_Send, "m_upgradeBitVec", upgrade);
			SetEntProp(entity, Prop_Send, "m_nUpgradedPrimaryAmmoLoaded", upammo);
		}
	}
}
public Action:EquipSlot1Weapon(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		ClearSlot1Offsets(client);
		CheatCommand(client, "give", cSlot1Weapon[client]);
		CreateTimer(0.1, EquipSlot1Ammo, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}
public Action:EquipSlot1Ammo(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		if (GetPlayerWeaponSlot(client, 1) > 0)
		{
			new entity = GetPlayerWeaponSlot(client, 1);
			new clip = cSlot1Clip[client];
			if (clip < 0)
			{
				clip = 0;
			}
			SetEntProp(entity, Prop_Send, "m_iClip1", clip);
			new String:classname[32];
			GetEdictClassname(entity, classname, sizeof(classname));
			if (StrEqual(classname, "weapon_pistol", false))
			{
				SetEntProp(entity, Prop_Send, "m_isDualWielding", cSlot1Dual[client]);
			}
		}
	}
}
public Action:EquipSlot2Weapon(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		ClearSlot2Offsets(client);
		CheatCommand(client, "give", cSlot2Weapon[client]);
	}
}
public Action:EquipSlot3Weapon(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		ClearSlot3Offsets(client);
		CheatCommand(client, "give", cSlot3Weapon[client]);
	}
}
public Action:EquipSlot4Weapon(Handle:timer, any:client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		ClearSlot4Offsets(client);
		CheatCommand(client, "give", cSlot4Weapon[client]);
	}
}
stock ClearSlot0Offsets(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new offset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
		SetEntData(client, offset+(12), 0);
		SetEntData(client, offset+(20), 0);
		SetEntData(client, offset+(24), 0);
		SetEntData(client, offset+(28), 0);
		SetEntData(client, offset+(32), 0);
		SetEntData(client, offset+(36), 0);
		SetEntData(client, offset+(40), 0);
		SetEntData(client, offset+(68), 0);
		SetEntData(client, offset+(80), 0);
	}
}
stock ClearSlot1Offsets(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new offset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
		SetEntData(client, offset+(76), 0);
		SetEntData(client, offset+(80), 0);
	}
}
stock ClearSlot2Offsets(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new offset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
		SetEntData(client, offset+(48), 0);
		SetEntData(client, offset+(52), 0);
		SetEntData(client, offset+(56), 0);
		SetEntData(client, offset+(80), 0);
	}
}
stock ClearSlot3Offsets(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new offset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
		SetEntData(client, offset+(64), 0);
		SetEntData(client, offset+(80), 0);
	}
}
stock ClearSlot4Offsets(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new offset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
		SetEntData(client, offset+(60), 0);
		SetEntData(client, offset+(72), 0);
		SetEntData(client, offset+(80), 0);
	}
}
stock CorrectAmmoOffsets(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new weaponid = GetPlayerWeaponSlot(client, 0);
		if (weaponid > 0 && IsValidEntity(weaponid))
		{
			new level = cLevel[client];
			new ammo = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
			new clip = 0;
			new maxclip = 0;
			new maxammo = 0;
			new String:classname[32];
			GetEdictClassname(weaponid, classname, sizeof(classname));
			if (StrEqual(classname, "weapon_rifle", false) || StrEqual(classname, "weapon_rifle_sg552", false))
			{
				maxclip = 50;
				maxammo = 360;
				if (level >= 6)
				{
					maxammo = 410;
				}
				ammo = GetEntData(client, ammo+(12));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_rifle_desert", false))
			{
				maxclip = 60;
				maxammo = 360;
				if (level >= 6)
				{
					maxammo = 420;
				}
				ammo = GetEntData(client, ammo+(12));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_rifle_ak47", false))
			{
				maxclip = 40;
				maxammo = 360;
				if (level >= 6)
				{
					maxammo = 400;
				}
				ammo = GetEntData(client, ammo+(12));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_smg", false) || StrEqual(classname, "weapon_smg_silenced", false) || StrEqual(classname, "weapon_smg_mp5", false))
			{
				maxclip = 50;
				maxammo = 650;
				if (level >= 6)
				{
					maxammo = 700;
				}
				ammo = GetEntData(client, ammo+(20));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_pumpshotgun", false) || StrEqual(classname, "weapon_shotgun_chrome", false))
			{
				maxclip = 8;
				maxammo = 56;
				if (level >= 6)
				{
					maxammo = 64;
				}
				ammo = GetEntData(client, ammo+(28));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_autoshotgun", false) || StrEqual(classname, "weapon_shotgun_spas", false))
			{
				maxclip = 10;
				maxammo = 90;
				if (level >= 6)
				{
					maxammo = 100;
				}
				ammo = GetEntData(client, ammo+(32));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_hunting_rifle", false))
			{
				maxclip = 15;
				maxammo = 150;
				if (level >= 6)
				{
					maxammo = 165;
				}
				ammo = GetEntData(client, ammo+(36));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_sniper_scout", false))
			{
				maxclip = 15;
				maxammo = 180;
				if (level >= 6)
				{
					maxammo = 195;
				}
				ammo = GetEntData(client, ammo+(40));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_sniper_military", false))
			{
				maxclip = 30;
				maxammo = 180;
				if (level >= 6)
				{
					maxammo = 210;
				}
				ammo = GetEntData(client, ammo+(40));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_sniper_awp", false))
			{
				maxclip = 20;
				maxammo = 180;
				if (level >= 6)
				{
					maxammo = 200;
				}
				ammo = GetEntData(client, ammo+(40));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
			else if (StrEqual(classname, "weapon_grenade_launcher", false))
			{
				maxclip = 1;
				maxammo = 30;
				ammo = GetEntData(client, ammo+(68));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
			}
			else if (StrEqual(classname, "weapon_rifle_m60", false))
			{
				maxclip = 150;
				maxammo = 300;
				ammo = GetEntData(client, ammo+(24));
				if (ammo < 0)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 0);
				}
				else if (ammo > maxammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), maxammo);
				}
				clip = GetEntProp(weaponid, Prop_Send, "m_iClip1");
				if (clip < 0)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", 0);
				}
				else if (clip > maxclip)
				{
					SetEntProp(weaponid, Prop_Send, "m_iClip1", maxclip);
				}
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(12), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(20), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(28), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(32), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(36), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(40), 0);
				SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), 0);
			}
		}
	}
}
//=============================
// SERVER JOINER
//=============================
public Action:Command_JoinTeam(client, const String:command[], args)
{
    	return Plugin_Handled;
}
public Action:Join(client,args)
{
	if (client > 0)
	{
		if (IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 1)
		{
			if (PlayerSpawn[client] > 0)
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You went AFK and have to wait to be rescued.");
				ChangeClientTeam(client, 2);
				return Plugin_Handled;
			}
			JoinSurvivors(client);
		}
	}
	return Plugin_Handled;
}
stock BotControl()
{
	if (!IsServerProcessing()) return;

	if (bBotControl)
	{
		new remove;
		new humans = CountHumanSurvivors();
		new bots = CountBotSurvivors();
		if (humans == 0)
		{
			remove = 0;
		}
		else if (humans < 4)
		{
			if ((humans + bots) < 4)
			{
				SpawnBot();
			}
			else if ((humans + bots) > 4)
			{
				remove = (humans + bots) - 4;
			}
		}
		else
		{
			remove = bots;
		}
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && IsFakeClient(i) && GetClientTeam(i) == 2 && remove > 0)
			{
				new String:classname[12];
				GetEntityNetClass(i, classname, sizeof(classname));
    				if (StrEqual(classname, "SurvivorBot", false))
				{
					new userid = GetEntProp(i, Prop_Send, "m_humanSpectatorUserID");
					if (userid <= 0)
					{
						remove -= 1;
						RemoveAllBotWeapons(i);
						KickClient(i);
					}
				}
			}
		}
	}
}
stock RemoveAllBotWeapons(client)
{
	for (new slot=0; slot<=4; slot++)
	{
		if (GetPlayerWeaponSlot(client, slot) > 0)
		{
			new weapon = GetPlayerWeaponSlot(client, slot);
			if (IsValidEntity(weapon))
			{
				AcceptEntityInput(weapon, "Kill");
			}
		}
	}
}
stock SpawnBot()
{
	new target = Pick();
	if (target > 0 && IsClientInGame(target))
	{
		new Float: Origin[3], Float:Angles[3];
		GetClientAbsOrigin(target, Origin);
		GetClientAbsAngles(target, Angles);

		new bot = CreateFakeClient("Nick");
		if (bot > 0)
		{
			ChangeClientTeam(bot, 2);
			if (DispatchKeyValue(bot, "classname", "survivorbot") == true)
			{
				if (DispatchSpawn(bot) == true)
				{
					TeleportEntity(bot, Origin, Angles, NULL_VECTOR);
					KickClient(bot);
				}
			}
		}
	}
}
stock bool:IsNewClient(client, String:steamid[])
{
	if (StrEqual(CurrentClientID[client], steamid, false))
	{
		return false;
	}
	strcopy(CurrentClientID[client], 24, steamid);
	return true;
}
stock NewPlayerJoinGame(client)
{
	if ((IsSurvivor(client) || IsSpectator(client)) && !IsFakeClient(client) && JoinedServer[client] == 1)
	{
		new String:AuthID[24];
		GetClientAuthId(client, AuthId_Steam2, AuthID, sizeof(AuthID));
		for (new i=1; i<=MaxClients; i++)
		{
			if (StrEqual(AuthID, DisconnectPlayer[i], false))
			{
				ArtilleryAmmo[client] = DisconnectPlayerAmmo[i][0];
				IonCannonAmmo[client] = DisconnectPlayerAmmo[i][1];
				NukeAmmo[client] = DisconnectPlayerAmmo[i][2];

				strcopy(DisconnectPlayer[i], 24, "");
				DisconnectPlayerAmmo[i][0] = 0;
				DisconnectPlayerAmmo[i][1] = 0;
				DisconnectPlayerAmmo[i][2] = 0;

				GetClientAuthId(client, AuthId_Steam2, DisconnectPlayer[client], 24);
				DisconnectPlayerAmmo[client][0] = ArtilleryAmmo[client];
				DisconnectPlayerAmmo[client][1] = IonCannonAmmo[client];
				DisconnectPlayerAmmo[client][2] = NukeAmmo[client];
			}
		}
		new team = GetClientTeam(client);
		switch(team)
		{
			case 1:
			{
				JoinSurvivors(client);
				JoinedServer[client] = 0;
			}
			case 2: JoinedServer[client] = 0;
		}
	}
}
stock JoinSurvivors(client)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client))
	{
		new target = PickAnyOther(client);
		if (target > 0 && IsClientInGame(target))
		{
			new bool:IsDead = false;
			new String:AuthID[24];
			GetClientAuthId(client, AuthId_Steam2, AuthID, sizeof(AuthID));
			for (new i=1; i<=MaxClients; i++)
			{
				if (StrEqual(AuthID, DeadPlayer[i], false))
				{
					IsDead = true;
					break;
				}
			}
			if (IsDead)
			{
				ChangeClientTeam(client, 2);
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You have already died and must wait for a rescue.");
			}
			else
			{	
				new Float: Origin[3], Float:Angles[3];
				GetClientAbsOrigin(target, Origin);
				GetClientAbsAngles(target, Angles);
				ChangeClientTeam(client, 2);
				L4D2_Respawn(client);
				TeleportEntity(client, Origin, Angles, NULL_VECTOR);
			}
		}
	}
}
//=============================
// UPGRADES
//=============================
//=============================
// Health
//=============================
stock UpdateHealth(client)
{
	new value;
	new level = cLevel[client];
	if (bNightmare)
	{
		value = 100;
	}
	else if (SpeedFreakOn[client] == 1 && !bNightmare)
	{
		value = 50;
	}
	else if (level >= 40)
	{
		value = 500;
	}
	else if (level >= 30)
	{
		value = 400;
	}
	else if (level >= 20)
	{
		value = 300;
	}
	else if (level >= 10)
	{
		value = 200;
	}
	else
	{
		value = 100;
	}
	SetEntProp(client, Prop_Send, "m_iMaxHealth", value);
	new String:AuthID[24];
	GetClientAuthId(client, AuthId_Steam2, AuthID, sizeof(AuthID));
	if (NewClient[client] > 0)
	{
		CheatCommand(client, "give", "health");
		NewClient[client] = 0;
	}
	else if (HealthMap[client] > 0 && !StrEqual(HealthMapName[client], current_map, false))
	{
		if (!IsFakeClient(client) && cID[client] > 0)
		{
			if (iChapterStage == 1)
			{
				CheatCommand(client, "give", "health");
			}
			else
			{
				SetEntProp(client, Prop_Send, "m_iHealth", HealthMap[client]);
			}
			strcopy(HealthMapName[client], 32, "");
			HealthMap[client] = 0;
		}
	}
	else if (DefibHealth[client] > 0)
	{
		SetEntProp(client, Prop_Send, "m_iHealth", DefibHealth[client]);
		DefibHealth[client] = 0;
	}
	else if (SecChance[client] == 1)
	{
		CheatCommand(client, "give", "health");
		SecChance[client] = 2;
	}
	GiveHealth(client, 0, false);
}
stock bool:GiveHealth(client, amount, bool:blackwhite)
{
	new bool:healthchanged = false;
	if (IsSurvivor(client))
	{
		new level = cLevel[client];
		new health = GetEntProp(client, Prop_Send, "m_iHealth");
		new maxhealth = GetEntProp(client, Prop_Send, "m_iMaxHealth");
		new temphealth = L4D2_GetPlayerTempHealth(client);
		new revivecount = L4D2_GetPlayerReviveCount(client);
		new incaphealth = 300;
		new totalhealth = health;
		//PrintToChat(client, "Pre->h:%i, t:%i, m:%i, GH:%i", health, temphealth, maxhealth, amount);
		if (IsPlayerIncap(client))
		{
			//incaphealth
			if (amount > 0)
			{
				totalhealth = totalhealth + amount;
			}
			if (level >= 17)
			{
				incaphealth = 500;
			}
			if (incaphealth == totalhealth)
			{
				healthchanged = false;
			}
			else if (incaphealth > totalhealth)
			{
				SetEntProp(client, Prop_Send, "m_iHealth", totalhealth);
				healthchanged = true;
			}
			else if (maxhealth > incaphealth)
			{
				SetEntProp(client, Prop_Send, "m_iHealth", maxhealth);
				totalhealth = maxhealth;
				healthchanged = true;
			}
		}
		else
		{
			//health
			if (amount > 0)
			{
				totalhealth = totalhealth + amount;
			}
			if ((totalhealth + temphealth) > maxhealth && temphealth > 0)
			{
				L4D2_SetPlayerTempHealth(client, 0);
				SetEntProp(client, Prop_Send, "m_iHealth", maxhealth);
				totalhealth = maxhealth;
				healthchanged = true;
			}
			else if (totalhealth > maxhealth)
			{
				SetEntProp(client, Prop_Send, "m_iHealth", maxhealth);
				totalhealth = maxhealth;
				healthchanged = true;
			}
			else if (maxhealth > (totalhealth + temphealth) && temphealth > 0)
			{
				L4D2_SetPlayerTempHealth(client, 0);
				SetEntProp(client, Prop_Send, "m_iHealth", totalhealth + temphealth);
				healthchanged = true;
			}
			else if ((maxhealth == totalhealth) && (totalhealth != health))
			{
				SetEntProp(client, Prop_Send, "m_iHealth", maxhealth);
				totalhealth = maxhealth;
				healthchanged = true;
			}
			else if (maxhealth == health)
			{
				healthchanged = false;
			}
			else if (maxhealth > totalhealth)
			{
				SetEntProp(client, Prop_Send, "m_iHealth", totalhealth);
				healthchanged = true;
			}
			//blackwhite
			if (blackwhite)
			{
				CheatCommand(client, "give", "health");
				L4D2_SetPlayerReviveCount(client, 0);
				SetEntProp(client, Prop_Send, "m_iMaxHealth", maxhealth);
				SetEntProp(client, Prop_Send, "m_iHealth", totalhealth);
				L4D2_SetPlayerTempHealth(client, 0);
				healthchanged = true;
			}
			else
			{
				if (IsBlackWhite(client))
				{
					if (health >= 40)
					{
						CheatCommand(client, "give", "health");
						L4D2_SetPlayerReviveCount(client, 2);
						SetEntProp(client, Prop_Send, "m_iMaxHealth", maxhealth);
						SetEntProp(client, Prop_Send, "m_iHealth", totalhealth);
						L4D2_SetPlayerTempHealth(client, 0);
						healthchanged = true;
					}
				}
			}
			revivecount = L4D2_GetPlayerReviveCount(client);
			switch(revivecount)
			{
				case 0: aDamageType[client] = 0;
				case 1: aDamageType[client] = 1;
				case 2: aDamageType[client] = 2;
			}
		}
		health = GetEntProp(client, Prop_Send, "m_iHealth");
		maxhealth = GetEntProp(client, Prop_Send, "m_iMaxHealth");
		temphealth = L4D2_GetPlayerTempHealth(client);
		//PrintToChat(client, "Post->h:%i, t:%i, m:%i, GH:%i", health, temphealth, maxhealth, amount);
	}
	return healthchanged;
}
stock L4D2_GetPlayerTempHealth(client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{	
		static Handle:painPillsDecayCvar = INVALID_HANDLE;
		if (painPillsDecayCvar == INVALID_HANDLE)
		{
			painPillsDecayCvar = FindConVar("pain_pills_decay_rate");
			if (painPillsDecayCvar == INVALID_HANDLE)
			{
				return 0;
			}
		}
		new tempHealth = RoundToCeil(GetEntPropFloat(client, Prop_Send, "m_healthBuffer") - ((GetGameTime() - GetEntPropFloat(client, Prop_Send, "m_healthBufferTime")) * GetConVarFloat(painPillsDecayCvar))) - 1;
		if (tempHealth >= 0)
		{
			return tempHealth;
		}
	}
	return 0;
}
stock L4D2_SetPlayerTempHealth(client, tempHealth)
{
    	SetEntPropFloat(client, Prop_Send, "m_healthBuffer", float(tempHealth));
    	SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
}
stock L4D2_GetPlayerReviveCount(client)
{
	return GetEntProp(client, Prop_Send, "m_currentReviveCount");
}
stock L4D2_SetPlayerReviveCount(client, any:count)
{
	return SetEntProp(client, Prop_Send, "m_currentReviveCount", count);
}
//=============================
// Regeneration
//=============================
stock UpdateRegeneration(client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client) && !IsPlayerIncap(client) && !IsPlayerHeld(client) && !IsFakeClient(client) && !bNightmare)
	{
		new level = cLevel[client];
		if (level >= 10)
		{
			new value = 0;
			if (level >= 40) //500
			{
				value = 4;
			}
			else if (level >= 30) //400
			{
				value = 3;
			}
			else if (level >= 20) //300
			{
				value = 2;
			}
			else if (level >= 10) //200
			{
				value = 1;
			}
			GiveHealth(client, value, false);
		}
	}
}
//=============================
// Movement Speed
//=============================
stock UpdateMovementSpeed(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		decl Float:value;
		new flags = GetEntityFlags(client);
		new level = cLevel[client];
		new adrenaline = GetEntProp(client, Prop_Send, "m_bAdrenalineActive");
		if (flags & IN_JUMP)
		{
			if (SpeedFreakOn[client] == 1)
			{
				value = 2.0;
			}
			//acrobatics
			else if (level >= 2 && !bNightmare)
			{
				value = 1.15;
			}
			else
			{
				value = 1.0;
			}
		}
		else if (IsPlayerHeld(client))
		{
			value = 1.0;
		}
		else if (ReduceSpeed75[client] > 0)
		{
			value = 0.75;
		}
		//extreme conditioning
		else if (SpeedFreakOn[client] == 1)
		{
			value = 2.25;
			if (flags & FL_INWATER && adrenaline <= 0)
			{
				value = 2.0;
			}
		}
		else if (level >= 24 && !bNightmare)
		{
			value = 1.25;
			if (flags & FL_INWATER && adrenaline <= 0)
			{
				value = 1.5;
			}
		}
		else
		{
			value = 1.0;
		}
		SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", value);
		//PrintToChat(client, "[Movement Speed] Level: %i, Amount: %f", level, value);
		//PrintToChat(client, "Movement Speed: %f", value);
	}
}
stock AcrobaticsSkill(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		decl Float:value;
		new flags = GetEntityFlags(client);
		new level = cLevel[client];
		if (flags & IN_JUMP)
		{
			if (level >= 2 && !bNightmare)
			{
				value = 0.7;
			}
			else
			{
				value = 1.0;
			}
		}
		else
		{
			value = 1.0;
		}
		SetEntityGravity(client, value);
		//PrintToChat(client, "Gravity: %f", value);
	}
}
//=============================
// Reload Speed
//=============================
stock UpdateReload(client)
{
	decl Float:rate;
	new level = cLevel[client];
	if (level < 13)
	{
		return;
	}
	else if (level >= 13 && !bNightmare)
	{
		rate = 0.5;
		//PrintToChat(client, "[Reload Rate] Level: %i, Amount: %f", level, rate);	
	}

	new weapon = GetEntDataEnt2(client,FindSendPropInfo("CBaseCombatCharacter","m_hActiveWeapon"));
	if (IsValidEntity(weapon)==false) return;

	decl String:classname[32];
	GetEdictClassname(weapon, classname, sizeof(classname));
	if (StrEqual(classname, "weapon_grenade_launcher", false) && HeatSeekerOn[client] == 1)
	{
		rate = 0.25;
		MagStart(weapon, client, rate);
		return;
	}
	else if (StrContains(classname, "shotgun", false) == -1)
	{
		MagStart(weapon, client, rate);
		return;
	}
	else if (StrContains(classname, "autoshotgun", false) != -1)
	{
		new Handle:Pack = CreateDataPack();
		WritePackCell(Pack, iRound);
		WritePackCell(Pack, client);
		WritePackCell(Pack, weapon);
		WritePackFloat(Pack, rate);
		CreateTimer(0.1, AutoshotgunStart, Pack);
		return;
	}
	else if (StrContains(classname, "shotgun_spas", false) != -1)
	{
		new Handle:Pack = CreateDataPack();
		WritePackCell(Pack, iRound);
		WritePackCell(Pack, client);
		WritePackCell(Pack, weapon);
		WritePackFloat(Pack, rate);
		CreateTimer(0.1, SpasShotgunStart, Pack);
		return;
	}
	else if (StrContains(classname, "pumpshotgun", false) != -1
	|| StrContains(classname, "shotgun_chrome", false) != -1)
	{
		new Handle:Pack = CreateDataPack();
		WritePackCell(Pack, iRound);
		WritePackCell(Pack, client);
		WritePackCell(Pack, weapon);
		WritePackFloat(Pack, rate);
		CreateTimer(0.1, PumpshotgunStart, Pack);
		return;
	}
}
stock MagStart(weapon, client, Float:rate)
{
	new Float:flGameTime = GetGameTime();
	new Float:flNextTime_ret = GetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon", "m_flNextPrimaryAttack"));
	new Float:flNextTime_calc = (flNextTime_ret - flGameTime) * rate;

	SetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon", "m_flPlaybackRate"), 1.0/rate, true);
	CreateTimer(flNextTime_calc, MagEnd, weapon, TIMER_FLAG_NO_MAPCHANGE);

	if (rate < 1.0)
	{
		if ((flNextTime_calc - 0.4) > 0)
		{
			new Handle:Pack = CreateDataPack();
			WritePackCell(Pack, iRound);
			WritePackCell(Pack, client);
			new Float:flStartTime_calc = flGameTime - (flNextTime_ret - flGameTime) * (1.0 - rate) ;
			WritePackFloat(Pack, flStartTime_calc);
			CreateTimer(flNextTime_calc - 0.4, MagEnd2, Pack);
		}
	}

	flNextTime_calc += flGameTime;
	SetEntDataFloat(weapon, FindSendPropInfo("CTerrorGun", "m_flTimeWeaponIdle"), flNextTime_calc, true);
	SetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon", "m_flNextPrimaryAttack"), flNextTime_calc, true);
	SetEntDataFloat(client, FindSendPropInfo("CTerrorPlayer", "m_flNextAttack"), flNextTime_calc, true);
}
public Action:AutoshotgunStart(Handle:timer, Handle:Pack)
{
	ResetPack(Pack);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new weapon = ReadPackCell(Pack);
	new Float:rate = ReadPackFloat(Pack);
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	new Handle:NewPack = CreateDataPack();
	WritePackCell(NewPack, iRound);
	WritePackCell(NewPack, client);
	WritePackCell(NewPack, weapon);
	WritePackFloat(NewPack, rate);
	CreateTimer(0.3, ShotgunEnd, NewPack);

	if (client <= 0 || weapon <= 0 || !IsValidEntity(client) || !IsValidEntity(weapon) || !IsClientInGame(client))
	{
		return;
	}
				
	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun", "m_reloadStartDuration"),	0.666666*rate,	true);
	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun", "m_reloadInsertDuration"),	0.4*rate,	true);
	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun", "m_reloadEndDuration"),	0.675*rate,	true);
	SetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon", "m_flPlaybackRate"),   	1.0/rate, 	true);
}
public Action:SpasShotgunStart(Handle:timer, Handle:Pack)
{
	ResetPack(Pack);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new weapon = ReadPackCell(Pack);
	new Float:rate = ReadPackFloat(Pack);
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (client <= 0 || weapon <= 0 || !IsValidEntity(client) || !IsValidEntity(weapon) || !IsClientInGame(client))
	{
		return;
	}
				
	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun","m_reloadStartDuration"),	0.5*rate,	true);
	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun","m_reloadInsertDuration"),	0.375*rate,	true);
	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun","m_reloadEndDuration"),		0.699999*rate,	true);
	SetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon","m_flPlaybackRate"), 	1.0/rate, 	true);

	new Handle:NewPack = CreateDataPack();
	WritePackCell(NewPack, iRound);
	WritePackCell(NewPack, client);
	WritePackCell(NewPack, weapon);
	WritePackFloat(NewPack, rate);
	CreateTimer(0.3, ShotgunEnd, NewPack);
}
public Action:PumpshotgunStart(Handle:timer, Handle:Pack)
{
	ResetPack(Pack);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new weapon = ReadPackCell(Pack);
	new Float:rate = ReadPackFloat(Pack);
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (client <= 0 || weapon <= 0 || !IsValidEntity(client) || !IsValidEntity(weapon) || !IsClientInGame(client))
	{
		return;
	}

	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun", "m_reloadStartDuration"),	0.5*rate,	true);
	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun", "m_reloadInsertDuration"),	0.5*rate,	true);
	SetEntDataFloat(weapon,	FindSendPropInfo("CBaseShotgun", "m_reloadEndDuration"),	0.6*rate,	true);
	SetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon", "m_flPlaybackRate"), 	1.0/rate, 	true);

	new Handle:NewPack = CreateDataPack();
	WritePackCell(NewPack, iRound);
	WritePackCell(NewPack, client);
	WritePackCell(NewPack, weapon);
	CreateTimer(0.3, ShotgunEnd, NewPack);
}
public Action:MagEnd(Handle:timer, any:weapon)
{
	if (weapon <= 0 || IsValidEntity(weapon)==false)
	{
		return;
	}

	SetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon", "m_flPlaybackRate"), 1.0, true);
}
public Action:MagEnd2(Handle:timer, Handle:Pack)
{
	ResetPack(Pack);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new Float:flStartTime_calc = ReadPackFloat(Pack);
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (client <= 0 || !IsValidEntity(client) || !IsClientInGame(client))
	{
		return;
	}

	new viewmodel = GetEntDataEnt2(client, FindSendPropInfo("CTerrorPlayer", "m_hViewModel"));
	SetEntDataFloat(viewmodel, FindSendPropInfo("CTerrorViewModel", "m_flLayerStartTime"), flStartTime_calc, true);
}
public Action:ShotgunEnd(Handle:timer, Handle:Pack)
{
	ResetPack(Pack);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new weapon = ReadPackCell(Pack);
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (client <= 0 || weapon <= 0 || !IsValidEntity(client) || !IsValidEntity(weapon) || !IsClientInGame(client))
	{
		return;
	}
	if (GetEntData(weapon, FindSendPropInfo("CBaseShotgun", "m_reloadState")) == 0)
	{
		SetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon", "m_flPlaybackRate"), 1.0, true);

		new Float:flTime=GetGameTime()+0.2;
		SetEntDataFloat(client,	FindSendPropInfo("CTerrorPlayer", "m_flNextAttack"),		flTime,	true);
		SetEntDataFloat(weapon,	FindSendPropInfo("CTerrorGun", "m_flTimeWeaponIdle"),		flTime,	true);
		SetEntDataFloat(weapon,	FindSendPropInfo("CBaseCombatWeapon", "m_flNextPrimaryAttack"),	flTime,	true);
		return;
	}
	new Handle:NewPack = CreateDataPack();
	WritePackCell(NewPack, iRound);
	WritePackCell(NewPack, client);
	WritePackCell(NewPack, weapon);
	CreateTimer(0.3, ShotgunEnd, NewPack);
}
//=============================
// Ammo Regeneration
//=============================
stock UpdateAmmo(client)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2 && !bNightmare)
	{
		if (GetPlayerWeaponSlot(client, 0) > 0)
		{
			new value;
			new maxammo;
			new String:weapon[32];
			GetEdictClassname(GetPlayerWeaponSlot(client, 0), weapon, sizeof(weapon));
			if (StrEqual(weapon, "weapon_rifle", false) || StrEqual(weapon, "weapon_rifle_sg552", false) || StrEqual(weapon, "weapon_rifle_desert", false) || StrEqual(weapon, "weapon_rifle_ak47", false))
			{
				value = 12;
				maxammo = 360;
			}
			else if (StrEqual(weapon, "weapon_smg", false) || StrEqual(weapon, "weapon_smg_silenced", false) || StrEqual(weapon, "weapon_smg_mp5", false))
			{
				value = 20;
				maxammo = 650;
			}
			else if (StrEqual(weapon, "weapon_pumpshotgun", false) || StrEqual(weapon, "weapon_shotgun_chrome", false))
			{
				value = 28;
				maxammo = 56;
			}
			else if (StrEqual(weapon, "weapon_autoshotgun", false) || StrEqual(weapon, "weapon_shotgun_spas", false))
			{
				value = 32;
				maxammo = 90;
			}
			else if (StrEqual(weapon, "weapon_hunting_rifle", false))
			{
				value = 36;
				maxammo = 150;
			}
			else if (StrEqual(weapon, "weapon_sniper_scout", false) || StrEqual(weapon, "weapon_sniper_military", false) || StrEqual(weapon, "weapon_sniper_awp", false))
			{
				value = 40;
				maxammo = 180;
			}
			if (value > 0)
			{
				new ammo = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(value));
				if (maxammo > ammo)
				{
					SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(value), ammo + 1);
				}
			}
		}
	}
}
//=============================
// Level Perks
//=============================
public Action:SecondChanceTimer(Handle:timer, any:client)
{
	if (!bNightmare && !bRoundEnded)
	{
		if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && !IsPlayerAlive(client) && GetClientTeam(client) == 2 && SecChance[client] == 0)
		{
			new target = PickAnyOtherDist(client);
			if (target > 0 && IsClientInGame(target))
			{
				new Float: Origin[3], Float:Angles[3];
				GetClientAbsOrigin(target, Origin);
				GetClientAbsAngles(target, Angles);

				L4D2_Respawn(client);
				TeleportEntity(client, Origin, Angles, NULL_VECTOR);
			}
			AttachParticle(client, PARTICLE_SECONDCHANCE, 3.0, 0.0, 0.0, 30.0);
			PrintToChat(client, "\x04[Second Chance]\x01 You have been brought back from the dead.");
			SecChance[client] = 1;
			SecChanceTimer[client] = 4;
		}
	}
}
stock SelfRevive(client)
{
	if (client > 0 && IsClientInGame(client) && !bNightmare)
	{
		new level = cLevel[client];
		if (level >= 11)
		{
			new Float:time = GetEngineTime();
			new reviver = GetEntPropEnt(client, Prop_Send, "m_reviveOwner");
			if (IsPlayerIncap(client) && !IsPlayerHeld(client))
			{
				if (ReviveStart[client] == 0 && reviver <= 0)
				{
					PrintToChat(client, "\x04[Self Revive]\x01 Using Skill...");
					CreateReviveProgressBar(client, 2.5);
				}
				else if (ReviveStart[client] == 1 && (time - ReviveStartTime[client]) >= 2.5 && reviver == client)
				{
					if (level >= 4)
					{
						PrintToChat(client, "\x04[Medic]\x01 Receiving Health Bonus");
						L4D2_ReviveSurvivor(client);
						GiveHealth(client, 30, false);
					}
					else
					{
						L4D2_ReviveSurvivor(client);
					}
					KillReviveProgressBar(client);
				}
			}
			else if (ReviveStart[client] == 1 && (reviver == client || reviver <= 0))
			{
				KillReviveProgressBar(client);
			}
		}
	}
}
stock KnifeInfected(client)
{
	if (client > 0 && IsClientInGame(client) && !bNightmare)
	{
		new level = cLevel[client];
		if (level >= 15)
		{
			new random = GetRandomInt(1,level*4);
			new Float:time = GetEngineTime();
			new knife = GetEntPropEnt(client, Prop_Send, "m_useActionOwner");
			new zombie = CheckZombieHold(client);
			if (zombie > 0)
			{
				if (KnifeStart[client] == 0 && knife <= 0)
				{
					PrintToChat(client, "\x04[Knife]\x01 Attempting to Knife your assailant...");
					CreateKnifeProgressBar(client, 1.5, zombie);
				}
				else if (KnifeStart[client] == 1 && (time - KnifeStartTime[client]) >= 1.5 && knife == client)
				{
					if (random >= 10)
					{
						if (0)
						//if (IsSmoker(zombie))
						{
							decl Float:Origin[3], Float:TOrigin[3];
							GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
							GetEntPropVector(zombie, Prop_Send, "m_vecOrigin", TOrigin);
                       					if (GetVectorDistance(Origin, TOrigin) > 125)
							{
								PrintToChat(client, "\x04[Knife]\x01 Cut Smokers Tongue!");
								BreakInfectedHold(zombie);
								ResetClassAbility(zombie);
							}
							else
							{
								PrintToChat(client, "\x04[Knife]\x01 Stabbing Successful! [\x04%i\x01 Damage]", random*2);
								DealDamagePlayer(zombie, client, 128,(random*2), "skill_knife");
							}
						}
						else
						{
							PrintToChat(client, "\x04[Knife]\x01 Stabbing Successful! [\x04%i\x01 Damage]", random*2);
							DealDamagePlayer(zombie, client, 128,(random*2), "skill_knife");
						}
					}
					else
					{
						PrintToChat(client, "\x04[Knife]\x01 You missed.");
					}
					KillKnifeProgressBar(client);
				}
			}
			else if (KnifeStart[client] == 1 && (knife == client || knife <= 0))
			{
				KillKnifeProgressBar(client);
			}
		}
	}
}
stock CreateKnifeProgressBar(client, Float:duration, target)
{
	KnifeStartTime[client] = GetEngineTime();
	SetEntProp(client, Prop_Send, "m_iCurrentUseAction", 10);
	SetEntPropEnt(client, Prop_Send, "m_useActionOwner", client);
	SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
	SetEntPropFloat(client, Prop_Send, "m_flProgressBarDuration", duration);
	KnifeStart[client] = 1;
}
stock KillKnifeProgressBar(client)
{
	KnifeStartTime[client] = 0.0;
	SetEntProp(client, Prop_Send, "m_iCurrentUseAction", 0);
	SetEntPropEnt(client, Prop_Send, "m_useActionOwner", -1);
	SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
	SetEntPropFloat(client, Prop_Send, "m_flProgressBarDuration", 0.0);
	KnifeStart[client] = 0;
}
stock CreateReviveProgressBar(client, Float:duration)
{
	ReviveStartTime[client] = GetEngineTime();
	SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
	SetEntPropFloat(client, Prop_Send, "m_flProgressBarDuration", duration);
	SetEntPropEnt(client, Prop_Send, "m_reviveOwner", client);
	ReviveStart[client] = 1;
}
stock KillReviveProgressBar(client)
{
	ReviveStartTime[client] = 0.0;
	SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime", GetGameTime());
	SetEntPropFloat(client, Prop_Send, "m_flProgressBarDuration", 0.0);
	SetEntPropEnt(client, Prop_Send, "m_reviveOwner", -1);
	ReviveStart[client] = 0;
}
stock DisplayingProgressBar(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl Float:time, Float:duration, Float:currenttime;
		currenttime = GetGameTime();
		time = GetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime");
		duration = GetEntPropFloat(client, Prop_Send, "m_flProgressBarDuration");
		if (currenttime > time && currenttime < (time + duration))
		{
			return true;
		}
	}
	return false;
}
stock HealTarget(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new action = GetEntProp(client, Prop_Send, "m_iCurrentUseAction");
    		if (action == 1)
    		{
        		new target = GetEntPropEnt(client, Prop_Send, "m_useActionTarget");
			if (IsSurvivor(target))
			{
				new maxhealth = GetEntProp(target, Prop_Send, "m_iMaxHealth");
				new health = GetEntProp(target, Prop_Send, "m_iHealth");
				if (maxhealth == health)
				{
					BlockHeal[client] = true;
					BlockHealTime[client] = GetGameTime() + 2.5;
					//PrintToChat(client, "blocking heal");
				}
			}
		}
	}
}
stock FastHealAbility(client)
{
	new level = cLevel[client];
	if (SpeedFreakOn[client] == 1)
	{
		if (flReviveDuration != 1.0)
		{
			SetConVarFloat(FindConVar("survivor_revive_duration"), 1.0);
		}
		if (flHealDuration != 1.0)
		{
			SetConVarFloat(FindConVar("first_aid_kit_use_duration"), 1.0);
		}
		if (flDefibDuration != 1.0)
		{
			SetConVarFloat(FindConVar("defibrillator_use_duration"), 1.0);
		}
	}
	//surgeon
	else if (level >= 22 && !bNightmare)
	{
		if (flReviveDuration != 2.5)
		{
			SetConVarFloat(FindConVar("survivor_revive_duration"), 2.5);
		}
		if (flHealDuration != 2.5)
		{
			SetConVarFloat(FindConVar("first_aid_kit_use_duration"), 2.5);
		}
		if (flDefibDuration != 1.5)
		{
			SetConVarFloat(FindConVar("defibrillator_use_duration"), 1.5);
		}
	}
	else
	{
		if (flReviveDuration != 5.0)
		{
			SetConVarFloat(FindConVar("survivor_revive_duration"), 5.0);
		}
		if (flHealDuration != 5.0)
		{
			SetConVarFloat(FindConVar("first_aid_kit_use_duration"), 5.0);
		}
		if (flDefibDuration != 3.0)
		{
			SetConVarFloat(FindConVar("defibrillator_use_duration"), 3.0);
		}
	}
}
/////////////////
// DEPLOYABLES //
/////////////////
stock SpawnUVLight(client)
{
	decl Float:Origin[3], Float:Angles[3], Float:Direction[3];
	GetClientAbsOrigin(client, Origin);
	GetClientEyeAngles(client, Angles);
	GetAngleVectors(Angles, Direction, NULL_VECTOR, NULL_VECTOR);
	Origin[0] += Direction[0] * 32;
	Origin[1] += Direction[1] * 32;
	Origin[2] += Direction[2] * 1;   
	Angles[0] = 0.0;
	Angles[2] = 0.0;

	new item = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(item))
	{
		DispatchKeyValue(item, "model", "models/props_lighting/light_battery_rigged_01.mdl");
		DispatchKeyValue(item, "solid", "6");
		TeleportEntity(item, Origin, Angles, NULL_VECTOR);
		DispatchSpawn(item);
		AcceptEntityInput(item, "DisableCollision");
		new glowcolor = RGB_TO_INT(255, 255, 255);
		SetEntProp(item, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntProp(item, Prop_Send, "m_iGlowType", 2);
		UVLightModel[client] = item;
	}
	new light = CreateEntityByName("beam_spotlight");
	if (light > 0)
	{
		GetAngleVectors(Angles, Direction, NULL_VECTOR, NULL_VECTOR);
		Origin[0] += Direction[0] * 6;
		Origin[1] += Direction[1] * 6;
		Angles[0] = -90.0;
		Angles[1] = 90.0;
		TeleportEntity(light, Origin, Angles, NULL_VECTOR);
		DispatchKeyValue(light, "spotlightwidth", "102");
		DispatchKeyValue(light, "spotlightlength", "120");
		DispatchKeyValue(light, "spawnflags", "3");
		DispatchKeyValue(light, "rendercolor", "160 145 255");
		DispatchKeyValue(light, "renderamt", "150");
		DispatchKeyValue(light, "maxspeed", "100");
		DispatchKeyValue(light, "HDRColorScale", "0.7");
		DispatchKeyValue(light, "fadescale", "1");
		DispatchKeyValue(light, "fademindist", "-1");
		DispatchSpawn(light);
		UVLightGlow[client] = light;
	}
	if (UVLightTimer[client] <= 0)
	{
		if (UVLightModel[client] > 0 && UVLightGlow[client] > 0)
		{
			UVLightTimer[client] = 300;
		}
		else if (UVLightModel[client] > 0)
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(item, "AddOutput");
			AcceptEntityInput(item, "FireUser1");
			UVLightModel[client] = 0;
		}
		else if (UVLightGlow[client] > 0)
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(light, "AddOutput");
			AcceptEntityInput(light, "FireUser1");
			UVLightGlow[client] = 0;
		}
	}
}
stock UpdateUVLight(client)
{
	new item = UVLightModel[client];
	new light = UVLightGlow[client];
	new timer = UVLightTimer[client];
	new lighton = -1;
	if (light > 0 && IsValidEntity(light))
	{
		new String:classname[16];
		GetEdictClassname(light, classname, sizeof(classname));
		if (StrEqual(classname, "beam_spotlight", false))
		{
			lighton = GetEntProp(light, Prop_Send, "m_bSpotlightOn");
			if (lighton == 1 && timer <= 250)
				AcceptEntityInput(light, "LightOff");
			else if (timer <= 250)
				AcceptEntityInput(light, "LightOn");
		}
	}
	if (item > 0 && IsValidEntity(item))
	{
		decl String:classname[16];
		GetEdictClassname(item, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[50];
			GetEntPropString(item, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_lighting/light_battery_rigged_01.mdl", false))
			{
				if (timer <= 250)
				{
					SetEntProp(item, Prop_Send, "m_bFlashing", 1);
				}
				if (lighton == 1)
				{
					new Float:Origin[3];
					GetEntPropVector(item, Prop_Send, "m_vecOrigin", Origin);
					new entity = -1;
					while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
					{
						decl Float:jOrigin[3];
						GetEntPropVector(entity, Prop_Send, "m_vecOrigin", jOrigin);
                        			new Float:distance = GetVectorDistance(Origin, jOrigin);
                        			if (distance <= 400)
						{
							new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
							if (ragdoll == 0)
							{
								DealDamageEntity(entity, client, 10, 600, "uv_light");
							}
						}
					}
				}	
			}
		}
	}
	UVLightTimer[client] -= 1;
}
stock DestroyUVLight(client)
{
	new item = UVLightModel[client];
	new light = UVLightGlow[client];
	if (item > 0 && IsValidEntity(item))
	{
		new String:classname[16];
		GetEdictClassname(item, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[50];
			GetEntPropString(item, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_lighting/light_battery_rigged_01.mdl", false))
			{
				SetVariantString("OnUser1 !self:Kill::0.1:-1");
				AcceptEntityInput(item, "AddOutput");
				AcceptEntityInput(item, "FireUser1");
				UVLightModel[client] = 0;
			}
		}
	}
	if (light > 0 && IsValidEntity(light))
	{
		new String:classname[16];
		GetEdictClassname(light, classname, sizeof(classname));
		if (StrEqual(classname, "beam_spotlight", false))
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(light, "AddOutput");
			AcceptEntityInput(light, "FireUser1");
			UVLightGlow[client] = 0;
		}
	}
	UVLightTimer[client] -= 1;
}
stock SpawnEmitter(client)
{
	decl Float:Origin[3], Float:Angles[3], Float:Direction[3];
	GetClientAbsOrigin(client, Origin);
	GetClientEyeAngles(client, Angles);
	GetAngleVectors(Angles, Direction, NULL_VECTOR, NULL_VECTOR);
	Origin[0] += Direction[0] * 32;
	Origin[1] += Direction[1] * 32;
	Origin[2] += Direction[2] * 1;   
	Angles[0] = 0.0;
	Angles[2] = 0.0;

	new item = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(item))
	{
		DispatchKeyValue(item, "model", "models/props_interiors/makeshift_stove_battery.mdl");
		DispatchKeyValue(item, "solid", "6");
		TeleportEntity(item, Origin, Angles, NULL_VECTOR);
		DispatchSpawn(item);
		AcceptEntityInput(item, "DisableCollision");
		EmitterBase[client] = item;
	}
	new item2 = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(item2))
	{
		Origin[2] += 15.0;
		DispatchKeyValue(item2, "model", "models/props_fairgrounds/monitor_speaker.mdl");
		DispatchKeyValue(item2, "solid", "6");
		TeleportEntity(item2, Origin, Angles, NULL_VECTOR);
		DispatchSpawn(item2);

		SetVariantString("!activator");
		AcceptEntityInput(item2, "SetParent", item);
		AcceptEntityInput(item2, "DisableCollision");
		new glowcolor = RGB_TO_INT(255, 255, 255);
		SetEntProp(item2, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntProp(item2, Prop_Send, "m_iGlowType", 2);
		EmitterSpeaker[client] = item2;
	}
	if (EmitterTimer[client] <= 0)
	{
		if (EmitterBase[client] > 0 && EmitterSpeaker[client] > 0)
		{
			EmitterTimer[client] = 300;
		}
		else if (EmitterSpeaker[client] > 0)
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(item2, "AddOutput");
			AcceptEntityInput(item2, "FireUser1");
			EmitterSpeaker[client] = 0;
		}
		else if (EmitterBase[client] > 0)
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(item, "AddOutput");
			AcceptEntityInput(item, "FireUser1");
			EmitterBase[client] = 0;
		}
	}
}
stock UpdateEmitter(client)
{
	new speaker = EmitterSpeaker[client];
	new base = EmitterBase[client];
	new timer = EmitterTimer[client];
	if (base > 0 && IsValidEntity(base))
	{
		new String:classname[16];
		GetEdictClassname(base, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[52];
			GetEntPropString(base, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_interiors/makeshift_stove_battery.mdl", false))
			{
				if (timer != 250 && timer != 248 && timer != 246 && timer != 244 && timer != 242)
				{
					EmitSoundToAll("ui/pickup_misc42.wav", base);
					decl Float:Origin[3], Float:zOrigin[3], Float:distance;
					GetEntPropVector(base, Prop_Send, "m_vecOrigin", Origin);
					for (new z=1; z<=MaxClients; z++)
					{
						if (IsSurvivor(z) && IsPlayerAlive(z))
						{
							GetEntPropVector(z, Prop_Send, "m_vecOrigin", zOrigin);
                        				distance = GetVectorDistance(Origin, zOrigin);
                        				if (distance <= 500)
							{
								new attacker = CheckZombieHold(z);
								if (attacker > 0)
								{
									BreakInfectedHold(attacker);
									ResetClassAbility(attacker);

									if (IsSurvivor(client) && !IsFakeClient(client) && !bNightmare)
									{
										DealDamagePlayer(attacker, client, 2, 15, "emitter");

										new earnedxp = 5 * GetXPDiff(0);
										new level = cLevel[client];
										if (level < 50)
										{
											GiveXP(client, earnedxp);
											new messages = cNotifications[client];
											if (messages > 0)
											{
												PrintToChat(client, "\x04[High Frequency Emitter]\x01 Special Infected Stunned: \x03%i\x01 XP", earnedxp);
											}
										}
										else
										{
											GiveXP(client, earnedxp);
										}
									}
								}
							}
						}
						else if (IsSpecialInfected(z) && !IsPlayerGhost(z))
						{
							GetEntPropVector(z, Prop_Send, "m_vecOrigin", zOrigin);
                        				distance = GetVectorDistance(Origin, zOrigin);
                        				if (distance <= 500)
							{
								new victim = CheckZombieHold(z);
								if (victim <= 0)
								{
									L4D_StaggerPlayer(z, client, Origin);
								}
								if (IsSurvivor(client) && !IsFakeClient(client) && !bNightmare)
								{
									DealDamagePlayer(z, client, 2, 15, "emitter");

									new earnedxp = 5 * GetXPDiff(0);
									new level = cLevel[client];
									if (level < 50)
									{
										GiveXP(client, earnedxp);
										new messages = cNotifications[client];
										if (messages > 0)
										{
											PrintToChat(client, "\x04[High Frequency Emitter]\x01 Special Infected Stunned: \x03%i\x01 XP", earnedxp);
										}
									}
									else
									{
										GiveXP(client, earnedxp);
									}
								}
							}
						}
					}
				}	
			}
		}
	}
	if (speaker > 0 && IsValidEntity(speaker))
	{
		new String:classname[16];
		GetEdictClassname(speaker, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[45];
			GetEntPropString(speaker, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_fairgrounds/monitor_speaker.mdl", false))
			{
				if (timer <= 250)
				{
					SetEntProp(speaker, Prop_Send, "m_bFlashing", 1);
				}
			}
		}
	}
	EmitterTimer[client] -= 1;
}
stock DestroyEmitter(client)
{
	new item = EmitterSpeaker[client];
	new item2 = EmitterBase[client];
	if (item > 0 && IsValidEntity(item))
	{
		new String:classname[16];
		GetEdictClassname(item, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[45];
			GetEntPropString(item, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_fairgrounds/monitor_speaker.mdl", false))
			{
				SetVariantString("OnUser1 !self:Kill::0.1:-1");
				AcceptEntityInput(item, "AddOutput");
				AcceptEntityInput(item, "FireUser1");
				EmitterSpeaker[client] = 0;
			}
		}
	}
	if (item2 > 0 && IsValidEntity(item2))
	{
		new String:classname[16];
		GetEdictClassname(item2, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[52];
			GetEntPropString(item2, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_interiors/makeshift_stove_battery.mdl", false))
			{
				SetVariantString("OnUser1 !self:Kill::0.1:-1");
				AcceptEntityInput(item2, "AddOutput");
				AcceptEntityInput(item2, "FireUser1");
				EmitterBase[client] = 0;
			}
		}
	}
	EmitterTimer[client] -= 1;
}
stock SpawnHealingStation(client)
{
	decl Float:Origin[3], Float:Angles[3], Float:Direction[3], Float:minbounds[3], Float:maxbounds[3];
	GetClientAbsOrigin(client, Origin);
	GetClientEyeAngles(client, Angles);
	GetAngleVectors(Angles, Direction, NULL_VECTOR, NULL_VECTOR);
	Origin[0] += Direction[0] * 32;
	Origin[1] += Direction[1] * 32;
	Origin[2] += Direction[2] * 1;   
	Angles[0] = 0.0;
	Angles[2] = 0.0;

	new item = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(item))
	{
		DispatchKeyValue(item, "model", "models/props_unique/hospital/iv_pole.mdl");
		DispatchKeyValue(item, "solid", "6");
		TeleportEntity(item, Origin, Angles, NULL_VECTOR);
		DispatchSpawn(item);
		AcceptEntityInput(item, "DisableCollision");
		HSModel[client] = item;
		GetEntPropVector(item, Prop_Send, "m_vecMins", minbounds);
		GetEntPropVector(item, Prop_Send, "m_vecMaxs", maxbounds);
		//PrintToChat(client, "%f %f %f", minbounds[0], minbounds[1], minbounds[2]);
		//PrintToChat(client, "%f %f %f", maxbounds[0], maxbounds[1], maxbounds[2]);
		new glowcolor = RGB_TO_INT(0, 100, 255);
		SetEntProp(item, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntProp(item, Prop_Send, "m_iGlowType", 2);
	}
	new item2 = CreateEntityByName("func_button_timed");
	if (IsValidEntity(item2))
	{
		DispatchKeyValue(item2, "model", "models/props_unique/hospital/iv_pole.mdl");
		DispatchKeyValue(item2, "solid", "2");
		DispatchKeyValue(item2, "use_string", "USING HEALING STATION");
		DispatchKeyValue(item2, "use_time", "2");
		DispatchKeyValue(item2, "auto_disable", "0");
		DispatchSpawn(item2);
		ActivateEntity(item2);
		TeleportEntity(item2, Origin, Angles, NULL_VECTOR);
		HSTrigger[client] = item2;
		SetEntPropVector(item2, Prop_Send, "m_vecMins", minbounds);
		SetEntPropVector(item2, Prop_Send, "m_vecMaxs", maxbounds);
		new enteffects = GetEntProp(item2, Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(item2, Prop_Send, "m_fEffects", enteffects);
		SDKHook(item2, SDKHook_Use, HSOnPressed);
		SDKHook(item2, SDKHook_Think, HSOnThink);
		HookSingleEntityOutput(item2, "OnTimeUp", HSOnTimeUp, false);
		
	}
	if (HSTimer[client] <= 0)
	{
		if (HSModel[client] > 0 && HSTrigger[client] > 0)
		{
			HSTimer[client] = 300;
		}
		else if (HSModel[client] > 0)
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(item, "AddOutput");
			AcceptEntityInput(item, "FireUser1");
			HSModel[client] = 0;
		}
		else if (HSTrigger[client] > 0)
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(item2, "AddOutput");
			AcceptEntityInput(item2, "FireUser1");
			HSTrigger[client] = 0;
		}
	}
}
stock UpdateHealingStation(client)
{
	new item = HSModel[client];
	new timer = HSTimer[client];
	if (item > 0 && IsValidEntity(item))
	{
		decl String:classname[16];
		GetEdictClassname(item, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[42];
			GetEntPropString(item, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_unique/hospital/iv_pole.mdl", false))
			{
				if (timer <= 250)
				{
					SetEntProp(item, Prop_Send, "m_bFlashing", 1);
				}
			}
		}
	}
	HSTimer[client] -= 1;
}
stock DestroyHealingStation(client)
{
	new item = HSModel[client];
	new item2 = HSTrigger[client];
	if (item > 0 && IsValidEntity(item))
	{
		new String:classname[16];
		GetEdictClassname(item, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[42];
			GetEntPropString(item, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_unique/hospital/iv_pole.mdl", false))
			{
				SetVariantString("OnUser1 !self:Kill::0.1:-1");
				AcceptEntityInput(item, "AddOutput");
				AcceptEntityInput(item, "FireUser1");
				HSModel[client] = 0;
			}
		}
	}
	if (item2 > 0 && IsValidEntity(item2))
	{
		new String:classname[18];
		GetEdictClassname(item2, classname, sizeof(classname));
		if (StrEqual(classname, "func_button_timed", false))
		{
			CreateTimer(0.1, RemoveHS, item2, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.1, ResetHealingStation, client, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	HSTimer[client] -= 1;
}
public Action:RemoveHS(Handle:timer, any:entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[18];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "func_button_timed", false))
		{
			AcceptEntityInput(entity, "Disable");
			AcceptEntityInput(entity, "Kill");
		}
	}	
}
public Action:ResetHealingStation(Handle:timer, any:client)
{
	HSTrigger[client] = 0;
}
public Action:HSOnThink(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[18];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "func_button_timed", false))
		{
			new client = GetEntPropEnt(entity, Prop_Data, "m_hActivator");
			if (client > 0)
			{
				//PrintToChat(client, "pressing");
				for (new i=1; i<=MaxClients; i++)
				{
					if (RBTrigger[i] == entity)
					{
						if (RBTimer[i] <= 241 || bNightmare)
						{
							AcceptEntityInput(entity, "Disable");
							//PrintToChat(i, "timer under 242");
							return Plugin_Handled;
						}	
					}
				}
				if (IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					decl Float:Origin[3], Float:TOrigin[3];
					GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
					GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
					new Float:distance = GetVectorDistance(Origin, TOrigin);
                			if (distance < 125.0)
					{
						return Plugin_Continue;
					}
				}
				//PrintToChatAll("disabling");
				AcceptEntityInput(entity, "Disable");
				SetVariantString("OnUser1 !self:Enable::0.1:-1");
				AcceptEntityInput(entity, "AddOutput");
				AcceptEntityInput(entity, "FireUser1");
			}
		}
	}
	return Plugin_Handled;
}
public Action:HSOnPressed(entity, activator, caller, UseType:type, Float:value)
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (HSTrigger[i] == entity)
		{
			if (HSTimer[i] <= 241 || bNightmare)
			{
				return Plugin_Handled;
			}
		}
	}
	if (IsClientInGame(activator) && GetClientTeam(activator) == 2)
	{
		new maxhealth = GetEntProp(activator, Prop_Data, "m_iMaxHealth");
		new health = GetEntProp(activator, Prop_Data, "m_iHealth");
		if (maxhealth > health)
		{
			return Plugin_Continue;
		}
	}
	return Plugin_Handled;
}
public HSOnTimeUp(const String:name[], caller, activator, Float:delay) 
{
	if (IsClientInGame(activator) && GetClientTeam(activator) == 2)
	{
		CheatCommand(activator, "give", "health");
		L4D2_AdrenalineUsed(activator, 20.0);
		new owner;
		for (new i=1; i<=MaxClients; i++)
		{
			if (HSTrigger[i] == caller)
			{
				owner = i;
			}
		}
		if (IsSurvivor(owner) && !IsFakeClient(owner) && !bNightmare)
		{
			new earnedxp = 15 * GetXPDiff(0);
			new level = cLevel[owner];
			if (level < 50)
			{
				GiveXP(owner, earnedxp);
				PrintToChat(owner, "\x04[Healing Station]\x01 Item Used: \x03%i\x01 XP", earnedxp);
			}
			else
			{
				GiveXP(owner, earnedxp);
			}
		}
	}
}
stock SpawnResurrectionBag(client)
{
	decl Float:Origin[3], Float:Angles[3], Float:minbounds[3], Float:maxbounds[3];
	GetClientAbsOrigin(client, Origin);
	GetClientEyeAngles(client, Angles);
	Angles[0] = 0.0;
	Angles[2] = 0.0;

	new item = CreateEntityByName("prop_dynamic");
	if (item > 32 && IsValidEntity(item))
	{
		DispatchKeyValue(item, "model", "models/props_misc/bodybag_01/bodybag_01.mdl");
		DispatchKeyValue(item, "solid", "6");
		TeleportEntity(item, Origin, Angles, NULL_VECTOR);
		DispatchSpawn(item);
		AcceptEntityInput(item, "DisableCollision");
		RBModel[client] = item;
		GetEntPropVector(item, Prop_Send, "m_vecMins", minbounds);
		GetEntPropVector(item, Prop_Send, "m_vecMaxs", maxbounds);
		//PrintToChat(client, "%f %f %f", minbounds[0], minbounds[1], minbounds[2]);
		//PrintToChat(client, "%f %f %f", maxbounds[0], maxbounds[1], maxbounds[2]);
		new glowcolor = RGB_TO_INT(0, 100, 255);
		SetEntProp(item, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntProp(item, Prop_Send, "m_iGlowType", 2);
	}
	new item2 = CreateEntityByName("func_button_timed");
	if (item2 > 32 && IsValidEntity(item2))
	{
		DispatchKeyValue(item2, "model", "models/props_misc/bodybag_01/bodybag_01.mdl");
		DispatchKeyValue(item2, "solid", "2");
		DispatchKeyValue(item2, "use_string", "USING RESURRECTION BAG");
		DispatchKeyValue(item2, "use_time", "6");
		DispatchKeyValue(item2, "auto_disable", "0");
		DispatchSpawn(item2);
		ActivateEntity(item2);
		TeleportEntity(item2, Origin, Angles, NULL_VECTOR);
		RBTrigger[client] = item2;
		SetEntPropVector(item2, Prop_Send, "m_vecMins", minbounds);
		SetEntPropVector(item2, Prop_Send, "m_vecMaxs", maxbounds);
		new enteffects = GetEntProp(item2, Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(item2, Prop_Send, "m_fEffects", enteffects);
		SDKHook(item2, SDKHook_Use, RBOnPressed);
		SDKHook(item2, SDKHook_Think, RBOnThink);
		HookSingleEntityOutput(item2, "OnTimeUp", RBOnTimeUp, false);
		//PrintToChat(client, "%i", item2);
	}
	if (RBTimer[client] <= 0)
	{
		if (RBModel[client] > 0 && RBTrigger[client] > 0)
		{
			RBTimer[client] = 300;
		}
		else if (RBModel[client] > 0)
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(item, "AddOutput");
			AcceptEntityInput(item, "FireUser1");
			RBModel[client] = 0;
		}
		else if (RBTrigger[client] > 0)
		{
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(item2, "AddOutput");
			AcceptEntityInput(item2, "FireUser1");
			RBTrigger[client] = 0;
		}
	}
}
stock UpdateResurrectionBag(client)
{
	new item = RBModel[client];
	new timer = RBTimer[client];
	if (item > 0 && IsValidEntity(item))
	{
		decl String:classname[16];
		GetEdictClassname(item, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[44];
			GetEntPropString(item, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_misc/bodybag_01/bodybag_01.mdl", false))
			{
				if (timer <= 250)
				{
					SetEntProp(item, Prop_Send, "m_bFlashing", 1);
				}	
			}
		}
	}
	RBTimer[client] -= 1;
}
stock DestroyResurrectionBag(client)
{
	new item = RBModel[client];
	new item2 = RBTrigger[client];
	if (item > 0 && IsValidEntity(item))
	{
		new String:classname[16];
		GetEdictClassname(item, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[44];
			GetEntPropString(item, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_misc/bodybag_01/bodybag_01.mdl", false))
			{
				SetVariantString("OnUser1 !self:Kill::0.1:-1");
				AcceptEntityInput(item, "AddOutput");
				AcceptEntityInput(item, "FireUser1");
				RBModel[client] = 0;
			}
		}
	}
	if (item2 > 0 && IsValidEntity(item2))
	{
		new String:classname[18];
		GetEdictClassname(item2, classname, sizeof(classname));
		if (StrEqual(classname, "func_button_timed", false))
		{
			CreateTimer(0.1, RemoveRB, item2, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.1, ResetResurrectionBag, client, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	RBTimer[client] -= 1;
}
public Action:RemoveRB(Handle:timer, any:entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[18];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "func_button_timed", false))
		{
			AcceptEntityInput(entity, "Disable");
			AcceptEntityInput(entity, "Kill");
		}
	}	
}
public Action:ResetResurrectionBag(Handle:timer, any:client)
{
	RBTrigger[client] = 0;
}
public Action:RBOnThink(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[18];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "func_button_timed", false))
		{
			new client = GetEntPropEnt(entity, Prop_Data, "m_hActivator");
			if (client > 0)
			{
				//PrintToChat(client, "pressing");
				for (new i=1; i<=MaxClients; i++)
				{
					if (RBTrigger[i] == entity)
					{
						if (RBTimer[i] <= 241 || bNightmare)
						{
							AcceptEntityInput(entity, "Disable");
							//PrintToChat(i, "timer under 242");
							return Plugin_Handled;
						}	
					}
				}
				if (IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					decl Float:Origin[3], Float:TOrigin[3];
					GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
					GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
					new Float:distance = GetVectorDistance(Origin, TOrigin);
                			if (distance < 125.0)
					{
						new deadcount;
						for (new i=1; i<=MaxClients; i++)
						{
							if (IsClientInGame(i) && GetClientTeam(i) == 2 && !IsPlayerAlive(i))
							{
								deadcount++;
							}
						}
						if (deadcount > 0)
						{
							return Plugin_Continue;
						}
					}
				}
				//PrintToChatAll("disabling");
				AcceptEntityInput(entity, "Disable");
				SetVariantString("OnUser1 !self:Enable::0.1:-1");
				AcceptEntityInput(entity, "AddOutput");
				AcceptEntityInput(entity, "FireUser1");
			}
		}
	}
	return Plugin_Handled;
}
public Action:RBOnPressed(entity, activator, caller, UseType:type, Float:value)
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (RBTrigger[i] == entity)
		{
			if (RBTimer[i] <= 241 || bNightmare)
			{
				return Plugin_Handled;
			}
		}
	}
	if (IsClientInGame(activator) && GetClientTeam(activator) == 2)
	{
		decl Float:Origin[3], Float:TOrigin[3];
		GetEntPropVector(activator, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
		new Float:distance = GetVectorDistance(Origin, TOrigin);
                if (distance < 125.0)
		{
			new deadcount;
			for (new i=1; i<=MaxClients; i++)
			{
				if (IsClientInGame(i) && GetClientTeam(i) == 2 && !IsPlayerAlive(i))
				{
					deadcount++;
				}
			}
			if (deadcount > 0)
			{
				return Plugin_Continue;
			}
		}
	}
	return Plugin_Handled;
}
public RBOnTimeUp(const String:name[], caller, activator, Float:delay)
{
	if (IsClientInGame(activator) && GetClientTeam(activator) == 2)
	{
		ResurrectDead(caller, activator);
		EmitSoundToAll("ambient/materials/ripped_screen01.wav", caller);
		new owner;
		for (new i=1; i<=MaxClients; i++)
		{
			if (RBTrigger[i] == caller)
			{
				owner = i;
			}
		}
		if (IsSurvivor(owner) && !IsFakeClient(owner) && !bNightmare)
		{
			new earnedxp = 30 * GetXPDiff(0);
			new level = cLevel[owner];
			if (level < 50)
			{
				GiveXP(owner, earnedxp);
				PrintToChat(owner, "\x04[Resurrection Bag]\x01 Item Used: \x03%i\x01 XP", earnedxp);
			}
			else
			{
				GiveXP(owner, earnedxp);
			}
		}
	}
}
stock ResurrectDead(entity, client)
{
	if (entity > 0 && IsValidEntity(entity))
	{
		new String:classname[18];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "func_button_timed", false))
		{
			decl String:model[44];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_misc/bodybag_01/bodybag_01.mdl", false))
			{
				decl Float:Origin[3], Float:Angles[3];
				GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
				GetEntPropVector(entity, Prop_Send, "m_angRotation", Angles);
				new target = PickDeadSurvivor();
				if (target > 0)
				{
					if (IsSurvivor(client) && !IsFakeClient(client))
					{
						L4D2_Respawn(target);
						new level = cLevel[client];
						if (level >= 4)
						{
							DefibHealth[target] = 100;
						}
						else
						{
							DefibHealth[target] = 50;
						}
						TeleportEntity(target, Origin, Angles, NULL_VECTOR);
					}
				}
			}
		}
	}	
}
stock SpawnSentryGun(client)
{
	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		decl Float:Origin[3], Float:Angles[3]; 
		GetClientAbsOrigin(client, Origin);
		GetClientAbsAngles(client, Angles);

		new entity = CreateEntityByName("prop_minigun");
		if (entity > 32)
		{
			DispatchKeyValue(entity, "model", MODEL_50CAL);
			DispatchKeyValueVector(entity, "Origin", Origin);
			DispatchKeyValueVector(entity, "Angles", Angles);
			DispatchSpawn(entity);
			SetEntProp(entity, Prop_Data, "m_CollisionGroup", 1);
			new glowcolor = RGB_TO_INT(255, 255, 255);
			SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
			SetEntProp(entity, Prop_Send, "m_iGlowType", 2);
			SetEntProp(entity, Prop_Send, "m_hOwnerEntity", client);
			Sentry[client] = entity;
			SentryEnemy[client] = 0;
			SentryTime[client][0] = 0.0;
			SentryTime[client][1] = GetEngineTime(); 
			SentryTime[client][2] = 0.0;
			SentryAngles[client][0] = 0.0;
			SentryAngles[client][1] = 0.0;
			SentryTimer[client] = 300;
			SDKHook(entity, SDKHook_Think, SentryGunThink);
		}
	}

}
public SentryGunThink(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_minigun", false))
		{
			new client = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			new Float:time = GetEngineTime();
			new Float:interval = time - SentryTime[client][1];  
			SentryTime[client][1] = time;
			ScanForEnemy(entity, time, interval);
		}
	}
}
stock ReturnZombieName(entity)
{
	if (IsInfected(entity))
	{
		return 111;
	}
	else if (IsWitch(entity))
	{
		return 333;
	}
	else if (IsTank(entity))
	{
		return 444;
	}
	else if (IsSpecialInfected(entity))
	{
		return 222;
	}
	return 0;
}
stock ScanForEnemy(entity, Float:time, Float:interval)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_minigun", false))
		{
			new client = GetEntProp(entity, Prop_Send, "m_hOwnerEntity");
			new Float:GunFireTime = SentryTime[client][0];
			new Float:ScanTime = SentryTime[client][2];

			if (time - ScanTime > 1.0)
			{
				SentryTime[client][2] = time;
			}	
	
			decl Float:Origin[3];
			decl Float:Angles[3];
			decl Float:Direction[3];
			decl Float:TraceOrigin[3];
			decl Float:TraceAngles[3];
	 
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);	
			GetEntPropVector(entity, Prop_Send, "m_angRotation", Angles);
			Origin[2] += 35.0;

			GetAngleVectors(Angles, Direction, NULL_VECTOR, NULL_VECTOR);
			NormalizeVector(Direction, Direction);

			new target = SentryEnemy[client];
			//PrintToChat(client, "%i = SentryEnemy[client]", target);
			target = TargetEnemy(client, entity, target, Origin, TraceOrigin, TraceAngles);
			//PrintToChat(client, "%i = TargetEnemy()", target);
			if (target == 0)
			{
				target = SentryFindEnemy(client, entity, Origin, Angles);
				//PrintToChat(client, "%i = SentryFindEnemy()", target);
				if (target > 0)
				{
					SentryEnemy[client] = target;
				}
				else
				{
					SetEntProp(entity, Prop_Send, "m_firing", 0);
				}
				//PrintToChat(client, "Restarting ScanForEnemy", target);
				return;
			}

			decl Float:enemyDir[3]; 
			decl Float:newGunAngle[3];
			decl Float:targetAngle[3];

			if (target > 0)
			{
				SubtractVectors(TraceOrigin, Origin, enemyDir);				
			}
			else
			{
				enemyDir[0] = Direction[0];
				enemyDir[1] = Direction[1]; 
				enemyDir[2] = 0.0; 
			}
			NormalizeVector(enemyDir, enemyDir);	 
	 		GetVectorAngles(enemyDir, targetAngle);

			new Float:diff0 = AngleDiff(targetAngle[0], Angles[0]);
			new Float:diff1 = AngleDiff(targetAngle[1], Angles[1]);
	
			new Float:turn0 = 45.0*Sign(diff0)*interval;
			new Float:turn1 = 180.0*Sign(diff1)*interval;

			if (FloatAbs(turn0) >= FloatAbs(diff0))
			{
				turn0 = diff0;
			}
			if (FloatAbs(turn1) >= FloatAbs(diff1))
			{
				turn1 = diff1;
			}
	 
			newGunAngle[0] = Angles[0] + turn0;
			newGunAngle[1] = Angles[1] + turn1;
			newGunAngle[2] = 0.0; 
	
			DispatchKeyValueVector(entity, "Angles", newGunAngle);
			GetAngleVectors(newGunAngle, Direction, NULL_VECTOR, NULL_VECTOR);

			//PrintToChat(client, "% > 0 && FloatAbs(diff1) == %f)", target, FloatAbs(diff1));
			if (target > 0 && FloatAbs(diff1) < 10.0)
			{ 
				if (time >= GunFireTime)
				{
					SentryTime[client][0] = time + 0.07;  								
					SentryFire(client, entity, target, Origin, newGunAngle); 
				} 
			}
			if (time < SentryTime[client][0])
			{
				SetEntProp(entity, Prop_Send, "m_firing", 1);	
			}
			else 
			{
				SetEntProp(entity, Prop_Send, "m_firing", 0);
			}
		}	
	}
}
stock SentryFindEnemy(client, entity, Float:Origin[3], Float:Angles[3])
{
	new targetfirst = SentryTargetFirst[client];
	new nevertarget = SentryNeverTarget[client];
	new Float:distance = 0.0;
	new target = -1;
	new zombie = 0, special = 0, tank = 0, witch = 0;
	decl Float:TOrigin[3];
	decl Float:TAngles[3];
	while ((target = FindEntityByClassname(target, "infected")) != INVALID_ENT_REFERENCE)
	{
		if (nevertarget != 1 && nevertarget != 5 && nevertarget != 6)
		{
			new ragdoll = GetEntProp(target, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				new Float:Tdistance = GetVectorDistance(Origin, TOrigin);
				if (Tdistance <= 1500)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					if (TR_DidHit(SentryTrace))
					{
						if (target == TR_GetEntityIndex(SentryTrace))
						{
							if (Tdistance < distance || distance == 0.0)
							{
								if (InSentrySight(target, Origin, Angles))
								{
									zombie = target;
									distance = Tdistance;
								}
							}
						}
					}
					CloseHandle(SentryTrace);
				}
			}
		}
	}
	while ((target = FindEntityByClassname(target, "witch")) != INVALID_ENT_REFERENCE)
	{
		if (nevertarget != 3 && nevertarget != 6 && nevertarget != 7)
		{
			new ragdoll = GetEntProp(target, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				new Float:Tdistance = GetVectorDistance(Origin, TOrigin);
				if (Tdistance <= 1500)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					if (TR_DidHit(SentryTrace))
					{
						if (target == TR_GetEntityIndex(SentryTrace))
						{
							if (Tdistance < distance || distance == 0.0)
							{
								if (InSentrySight(target, Origin, Angles))
								{
									witch = target;
									distance = Tdistance;
								}
							}
						}
					}
					CloseHandle(SentryTrace);
				}
			}
		}
	}
	for (target=1; target<=MaxClients; target++)
	{
		if (IsTank(target) && nevertarget != 4 && nevertarget != 7)
		{
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
			new Float:Tdistance = GetVectorDistance(Origin, TOrigin);
			if (Tdistance <= 1500)
			{
				if (Tdistance < distance || distance == 0.0)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					if (TR_DidHit(SentryTrace))
					{
						if (target == TR_GetEntityIndex(SentryTrace))
						{
							if (Tdistance < distance || distance == 0.0)
							{
								if (InSentrySight(target, Origin, Angles))
								{
									tank = target;
									distance = Tdistance;
								}
							}
						}
					}
					CloseHandle(SentryTrace);
				}
			}
		}
		else if (IsSpecialInfected(target) && nevertarget != 2 && nevertarget != 5)
		{
			new survivor = CheckZombieHold(target);
			if (IsSurvivor(survivor))
			{
				GetEntPropVector(survivor, Prop_Send, "m_vecOrigin", TOrigin);
				new Float:Tdistance = GetVectorDistance(Origin, TOrigin);
				if (Tdistance <= 1500)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					if (TR_DidHit(SentryTrace))
					{
						if (target == TR_GetEntityIndex(SentryTrace))
						{
							if (InSentrySight(target, Origin, Angles))
							{
								special = target;
							}
						}
					}
					CloseHandle(SentryTrace);
				}
			}
			else
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				new Float:Tdistance = GetVectorDistance(Origin, TOrigin);
				if (Tdistance <= 1500)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					if (TR_DidHit(SentryTrace))
					{
						if (target == TR_GetEntityIndex(SentryTrace))
						{
							if (Tdistance < distance || distance == 0.0)
							{
								if (InSentrySight(target, Origin, Angles))
								{
									special = target;
									distance = Tdistance;
								}
							}
						}
					}
					CloseHandle(SentryTrace);
				}
			}
		}
	}
	switch(targetfirst)
	{
		case 0:
		{
			if (zombie > 0)
			{
				return zombie;
			}
			else if (special > 0)
			{
				return special;
			}
			else if (witch > 0)
			{
				return witch;
			}
			else if (tank > 0)
			{
				return tank;
			}
		}
		case 1:
		{
			if (special > 0)
			{
				return special;
			}
			else if (witch > 0)
			{
				return witch;
			}
			else if (tank > 0)
			{
				return tank;
			}
			else if (zombie > 0)
			{
				return zombie;
			}
		}
		case 2:
		{
			if (witch > 0)
			{
				return witch;
			}
			else if (tank > 0)
			{
				return tank;
			}
			else if (zombie > 0)
			{
				return zombie;
			}
			else if (special > 0)
			{
				return special;
			}
		}
		case 3:
		{
			if (tank > 0)
			{
				return tank;
			}
			else if (zombie > 0)
			{
				return zombie;
			}
			else if (special > 0)
			{
				return special;
			}
			else if (witch > 0)
			{
				return witch;
			}
		}
	}
	return 0;
}
stock bool:InSentrySight(target, Float:Origin[3], Float:Angles[3])
{
	if (target > 0 && IsValidEntity(target))
	{
		new Float:Threshold = 0.73;

    		decl Float:Direction[3];
    		decl Float:TOrigin[3]; 
		GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);

		TOrigin[2] += 35.0;
    		decl Float:TDirection[3];
    		decl Float:Distance[3];

    		Angles[0] = Angles[2] = 0.0;
    		GetAngleVectors(Angles, Direction, NULL_VECTOR, NULL_VECTOR);
    
    		Distance[0] = TOrigin[0] - Origin[0];
    		Distance[1] = TOrigin[1] - Origin[1];
    		Distance[2] = 0.0;

    		NormalizeVector(Distance, TDirection);
    		if (GetVectorDotProduct(Direction, TDirection) < Threshold) return false;
    
    		new Handle:hTrace = TR_TraceRayFilterEx(Origin, TOrigin, MASK_PLAYERSOLID_BRUSHONLY, RayType_EndPoint, ClientViewsFilter);
    		if (TR_DidHit(hTrace)) 
		{
			CloseHandle(hTrace); 
			return false; 
		}
    		CloseHandle(hTrace);
    		return true;
	}
	return false; 
}
public bool:TraceRaySentryFilter(entity, mask, any:data)
{
	if (entity != data)
	{
    		if (IsInfected(entity) || IsWitch(entity))
		{
			return true;
		}
		else if (IsTank(entity) || IsSpecialInfected(entity))
		{
			if (IsPlayerAlive(entity) && !IsPlayerGhost(entity))
			{
				return true;
			}
		}
	}
    	return false;
}
stock TargetEnemy(client, entity, target, Float:Origin[3], Float:TOrigin[3], Float:TAngles[3])
{
	if (target <= 0) return 0;

	new nevertarget = SentryNeverTarget[client];
	if (IsTank(target))
	{
		if (nevertarget != 4 && nevertarget != 7)
		{
			if (IsPlayerAlive(target) && !IsPlayerGhost(target))
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				if (GetVectorDistance(Origin, TOrigin) <= 1500)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					new targettrace = 0;
					if (TR_DidHit(SentryTrace))
					{		 
						TR_GetEndPosition(TOrigin, SentryTrace);
						targettrace = TR_GetEntityIndex(SentryTrace);
					}
					CloseHandle(SentryTrace);
					return targettrace;
				}
			}
		} 
	}
	else if (IsSpecialInfected(target))
	{
		if (nevertarget != 2 && nevertarget != 5)
		{
			if (IsPlayerAlive(target) && !IsPlayerGhost(target))
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				if (GetVectorDistance(Origin, TOrigin) <= 1500)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					new targettrace = 0;
					if (TR_DidHit(SentryTrace))
					{		 
						TR_GetEndPosition(TOrigin, SentryTrace);
						targettrace = TR_GetEntityIndex(SentryTrace);
					}
					CloseHandle(SentryTrace);
					return targettrace;
				}
			}
		} 
	}
	else if (IsInfected(target))
	{
		if (nevertarget != 1 && nevertarget != 5 && nevertarget != 6)
		{
			new ragdoll = GetEntProp(target, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				if (GetVectorDistance(Origin, TOrigin) <= 1500)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					new targettrace = 0;
					if (TR_DidHit(SentryTrace))
					{		 
						TR_GetEndPosition(TOrigin, SentryTrace);
						targettrace = TR_GetEntityIndex(SentryTrace);
					}
					CloseHandle(SentryTrace);
					return targettrace;
				}
			}
		} 
	}
	else if (IsWitch(target))
	{
		if (nevertarget != 3 && nevertarget != 6 && nevertarget != 7)
		{
			new ragdoll = GetEntProp(target, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				if (GetVectorDistance(Origin, TOrigin) <= 1500)
				{
					TOrigin[2] += 35.0; 
					SubtractVectors(TOrigin, Origin, TAngles);
					GetVectorAngles(TAngles, TAngles);
					new Handle:SentryTrace = TR_TraceRayFilterEx(Origin, TAngles, MASK_SHOT, RayType_Infinite, TraceRaySentryFilter, entity);
					new targettrace = 0;
					if (TR_DidHit(SentryTrace))
					{		 
						TR_GetEndPosition(TOrigin, SentryTrace);
						targettrace = TR_GetEntityIndex(SentryTrace);
					}
					CloseHandle(SentryTrace);
					return targettrace;
				}
			}
		} 
	}
	return 0;
}
Float:AngleDiff(Float:TOrigin, Float:Origin)
{
	new Float:Direction = 0.0;
	if (TOrigin >= Origin)
	{
		Direction = TOrigin - Origin;
		if (Direction >= 180.0) Direction = Direction - 360.0;
	}
	else
	{
		Direction = TOrigin - Origin;
		if (Direction <= -180.0) Direction = Direction + 360.0;
	}
	return Direction;
}
Float:Sign(Float:v)
{
	if (v == 0.0) return 0.0;
	else if (v > 0.0) return 1.0;
	else return -1.0;
}
stock SentryFire(client, entity, target, Float:Origin[3],  Float:Angles[3])
{ 
	decl Float:temp[3];
	decl Float:ang[3];
	GetAngleVectors(Angles, temp, NULL_VECTOR,NULL_VECTOR); 
	NormalizeVector(temp, temp); 
	 
	new Float:acc = 0.020;
	temp[0] += GetRandomFloat(-1.0, 1.0) * acc;
	temp[1] += GetRandomFloat(-1.0, 1.0) * acc;
	temp[2] += GetRandomFloat(-1.0, 1.0) * acc;
	GetVectorAngles(temp, ang);
	
	if (target > 0)
	{
		if (IsValidClient(target))
		{
			if (IsSpecialInfected(target) || IsTank(target))
			{
				if (!IsPlayerGhost(target))
				{
					ShowSentryMuzzleFlash(entity, ang);
					EmitSoundToAll(SOUND_50CAL_FIRE, entity);
					CreateTracerParticles(entity, target);
					AttachParticle(target, PARTICLE_BLOOD, 0.1, 0.0, 0.0, 30.0);
					EmitSoundToAll(SOUND_IMPACT, target);
					DealDamagePlayer(target, client, 2, 30, "sentry_gun");
				}
			}
		
		}
		else if (IsValidEntity(target))
		{
			if (IsInfected(target) || IsWitch(target))
			{
				new ragdoll = GetEntProp(target, Prop_Data, "m_bClientSideRagdoll");
				if (ragdoll == 0)
				{
					ShowSentryMuzzleFlash(entity, ang);
					EmitSoundToAll(SOUND_50CAL_FIRE, entity);
					CreateTracerParticles(entity, target);
					AttachParticle(target, PARTICLE_BLOOD, 0.1, 0.0, 0.0, 30.0);
					EmitSoundToAll(SOUND_IMPACT, target);
					DealDamageEntity2(target, client, 2, 30, "sentry_gun");
				}
			}	
		}
	}
}
stock ShowSentryMuzzleFlash(entity, Float:angle[3])
{  
	if (entity > 32 && IsValidEntity(entity))
	{
		new particle = CreateEntityByName("info_particle_system");
		if (particle > 0 && IsValidEntity(particle))
		{
			DispatchKeyValue(particle, "effect_name", PARTICLE_50CAL_FLASH);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			TeleportEntity(particle, NULL_VECTOR, angle, NULL_VECTOR);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity);
			SetVariantString("muzzle_flash");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
	}
}
stock UpdateSentryGun(client)
{
	new entity = Sentry[client];
	if (SentryTimer[client] <= 250)
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			new String:classname[16];
			GetEdictClassname(entity, classname, sizeof(classname));
			if (StrEqual(classname, "prop_minigun", false))
			{
				SetEntProp(entity, Prop_Send, "m_bFlashing", 1);
			}
		}
	}
	SentryTimer[client] -= 1;
}
stock DestroySentryGun(client)
{
	new entity = Sentry[client];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_minigun", false))
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
	SentryTimer[client] -= 1;
}
stock SpawnDefenseGrid(client)
{
	decl Float:Origin[3], Float:Angles[3], Float:Direction[3], Float:minbounds[3], Float:maxbounds[3];
	GetClientAbsOrigin(client, Origin);
	GetClientEyeAngles(client, Angles);
	GetAngleVectors(Angles, Direction, NULL_VECTOR, NULL_VECTOR);
	Origin[0] += Direction[0] * 32;
	Origin[1] += Direction[1] * 32;
	Origin[2] += Direction[2] * 1;   
	Angles[0] = 0.0;
	Angles[2] = 0.0;

	new entity = CreateEntityByName("prop_dynamic_override");
	if (entity > 32 && IsValidEntity(entity))
	{
		DispatchKeyValue(entity, "model", "models/props_interiors/makeshift_stove_battery.mdl");
		DispatchKeyValueVector(entity, "Origin", Origin);
		DispatchSpawn(entity);
		AcceptEntityInput(entity, "DisableCollision");
		AcceptEntityInput(entity, "DisableShadow");
		//SetEntProp(entity, Prop_Data, "m_iEFlags", 0);
		DefenseGridEnt[client][0] = entity;
		DefenseGridTimer[client] = 300;
		
		entity = CreateEntityByName("prop_dynamic_override");
		if (entity > 32 && IsValidEntity(entity))
		{
			DispatchKeyValue(entity, "model", MODEL_DEFENSEGRID);
			DispatchKeyValueVector(entity, "Origin", Origin);
			DispatchSpawn(entity);
			AcceptEntityInput(entity, "DisableCollision");
			AcceptEntityInput(entity, "DisableShadow");
			//SetEntProp(entity, Prop_Data, "m_iEFlags", 0);
			new glowcolor = RGB_TO_INT(255, 255, 255);
			SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
			SetEntProp(entity, Prop_Send, "m_iGlowType", 2);
			new Float:TOrigin[3] = {-2.0, -6.5, 17.0};
			TOrigin[0] = Origin[0] + TOrigin[0];
			TOrigin[1] = Origin[1] + TOrigin[1];
			TOrigin[2] = Origin[2] + TOrigin[2];
			TeleportEntity(entity, TOrigin, NULL_VECTOR, NULL_VECTOR);
			DefenseGridEnt[client][1] = entity;

			entity = CreateEntityByName("prop_dynamic_override");
			if (entity > 32 && IsValidEntity(entity))
			{
				DispatchKeyValue(entity, "model", "models/props_unique/airport/atlas_break_ball.mdl");
				DispatchKeyValueVector(entity, "Origin", Origin);
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 2.5);
				DispatchSpawn(entity);
				AcceptEntityInput(entity, "DisableCollision");
				AcceptEntityInput(entity, "DisableShadow");
				//SetEntProp(entity, Prop_Data, "m_iEFlags", 0);
				SetEntityRenderMode(entity, RenderMode:3);
      	 			SetEntityRenderColor(entity, 255, 100, 200, 100);
				TOrigin[2] -= 400.0;
				TeleportEntity(entity, TOrigin, NULL_VECTOR, NULL_VECTOR);
				DefenseGridEnt[client][2] = entity;

				entity = CreateEntityByName("filter_activator_team");
				if (entity != -1 && IsValidEntity(entity))
				{
					decl String:name[10];
					Format(name, sizeof(name), "filter%i", entity);
					DispatchKeyValueVector(entity, "Origin", Origin);
					DispatchKeyValue(entity, "filterteam", "3");
					DispatchKeyValue(entity, "targetname", name);
					DispatchSpawn(entity);
					DefenseGridEnt[client][3] = entity;

					minbounds[0] = -55.0;
					minbounds[1] = -55.0;
					minbounds[2] = 0.0;
					maxbounds[0] = 55.0;
					maxbounds[1] = 55.0;
					maxbounds[2] = 155.0;

					entity = CreateEntityByName("trigger_push");
					if (entity > 32 && IsValidEntity(entity))
					{
						DispatchKeyValue(entity, "model", "models/props_unique/airport/atlas_break_ball.mdl");
						DispatchKeyValueVector(entity, "Origin", Origin);
						DispatchKeyValue(entity, "spawnflags", "3");
						DispatchKeyValue(entity, "speed", "500");
						DispatchKeyValue(entity, "pushdir", "0 45 0");
						DispatchKeyValue(entity, "filtername", name);
						DispatchSpawn(entity);
						ActivateEntity(entity);
						SetEntPropVector(entity, Prop_Send, "m_vecMins", minbounds);
						SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxbounds);
						//PrintToChat(client, "%f %f %f", minbounds[0], minbounds[1], minbounds[2]);
						//PrintToChat(client, "%f %f %f", maxbounds[0], maxbounds[1], maxbounds[2]);
						new enteffects = GetEntProp(entity, Prop_Send, "m_fEffects");
						enteffects |= 32;
						SetEntProp(entity, Prop_Send, "m_fEffects", enteffects);
						SetEntProp(entity, Prop_Send, "m_nSolidType", 2);
						SDKHook(entity, SDKHook_StartTouch, HookShieldTouch);
						TOrigin[0] = Origin[0] + 55.0;
						TOrigin[1] = Origin[1] + 55.0;
						TOrigin[2] = Origin[2];
						TeleportEntity(entity, TOrigin, NULL_VECTOR, NULL_VECTOR);
						DefenseGridEnt[client][4] = entity;

						entity = CreateEntityByName("trigger_push");
						if (entity > 32 && IsValidEntity(entity))
						{
							DispatchKeyValue(entity, "model", "models/props_unique/airport/atlas_break_ball.mdl");
							DispatchKeyValueVector(entity, "Origin", Origin);
							DispatchKeyValue(entity, "spawnflags", "3");
							DispatchKeyValue(entity, "speed", "500");
							DispatchKeyValue(entity, "pushdir", "0 -45 0");
							DispatchKeyValue(entity, "filtername", name);
							DispatchSpawn(entity);
							ActivateEntity(entity);
							SetEntPropVector(entity, Prop_Send, "m_vecMins", minbounds);
							SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxbounds);
							SetEntProp(entity, Prop_Send, "m_fEffects", enteffects);
							SetEntProp(entity, Prop_Send, "m_nSolidType", 2);
							SDKHook(entity, SDKHook_StartTouch, HookShieldTouch);
							TOrigin[0] = Origin[0] + 55.0;
							TOrigin[1] = Origin[1] - 55.0;
							TOrigin[2] = Origin[2];
							TeleportEntity(entity, TOrigin, NULL_VECTOR, NULL_VECTOR);
							DefenseGridEnt[client][5] = entity;

							entity = CreateEntityByName("trigger_push");
							if (entity > 32 && IsValidEntity(entity))
							{
								DispatchKeyValue(entity, "model", "models/props_unique/airport/atlas_break_ball.mdl");
								DispatchKeyValueVector(entity, "Origin", Origin);
								DispatchKeyValue(entity, "spawnflags", "3");
								DispatchKeyValue(entity, "speed", "500");
								DispatchKeyValue(entity, "pushdir", "0 135 0");
								DispatchKeyValue(entity, "filtername", name);
								DispatchSpawn(entity);
								ActivateEntity(entity);
								SetEntPropVector(entity, Prop_Send, "m_vecMins", minbounds);
								SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxbounds);
								SetEntProp(entity, Prop_Send, "m_fEffects", enteffects);
								SetEntProp(entity, Prop_Send, "m_nSolidType", 2);
								SDKHook(entity, SDKHook_StartTouch, HookShieldTouch);
								TOrigin[0] = Origin[0] - 55.0;
								TOrigin[1] = Origin[1] + 55.0;
								TOrigin[2] = Origin[2];
								TeleportEntity(entity, TOrigin, NULL_VECTOR, NULL_VECTOR);
								DefenseGridEnt[client][6] = entity;

								entity = CreateEntityByName("trigger_push");
								if (entity > 32 && IsValidEntity(entity))
								{
									DispatchKeyValue(entity, "model", "models/props_unique/airport/atlas_break_ball.mdl");
									DispatchKeyValueVector(entity, "Origin", Origin);
									DispatchKeyValue(entity, "spawnflags", "3");
									DispatchKeyValue(entity, "speed", "500");
									DispatchKeyValue(entity, "pushdir", "0 -135 0");
									DispatchKeyValue(entity, "filtername", name);
									DispatchSpawn(entity);
									ActivateEntity(entity);
									SetEntPropVector(entity, Prop_Send, "m_vecMins", minbounds);
									SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxbounds);
									SetEntProp(entity, Prop_Send, "m_fEffects", enteffects);
									SetEntProp(entity, Prop_Send, "m_nSolidType", 2);
									SDKHook(entity, SDKHook_StartTouch, HookShieldTouch);
									TOrigin[0] = Origin[0] - 55.0;
									TOrigin[1] = Origin[1] - 55.0;
									TOrigin[2] = Origin[2];
									TeleportEntity(entity, TOrigin, NULL_VECTOR, NULL_VECTOR);
									DefenseGridEnt[client][7] = entity;
								}
							}
						}
					}
				}
			}
		}
	}
}
public Action:HookShieldTouch(caller, activator)
{
	if (activator != -1 && IsValidEntity(activator))
	{
		new type = 0;
		if (IsSurvivor(activator))
		{
			new attacker = CheckZombieHold(activator);
			if (attacker > 0)
			{
				BreakInfectedHold(attacker);
				ResetClassAbility(attacker);
				type = 1;	
			}
		}
		else if (IsSpecialInfected(activator))
		{
			type = 1;
		}
		else if (IsTank(activator))
		{
			type = 2;
		}
		decl String:classname[18];
		GetEdictClassname(activator, classname, sizeof(classname));
		if (StrEqual(classname, "spitter_projectile", false))
		{
			AcceptEntityInput(activator, "Kill");
			type = 3;
		}
		else if (StrEqual(classname, "tank_rock", false))
		{
			AcceptEntityInput(activator, "Kill");
			type = 4;
		}
		else if (StrEqual(classname, "infected", false))
		{
			if (IsUncommon(activator))
			{
				type = 5;
			}
			else
			{
				type = 6;
			}
			AcceptEntityInput(activator, "BecomeRagdoll");
		}
		else if (StrEqual(classname, "witch", false))
		{
			new color = GetEntProp(activator, Prop_Send, "m_hOwnerEntity");
			if (color == 255200255)
			{
				type = 7;
			}
			else
			{
				type = 8;
			}
			AcceptEntityInput(activator, "BecomeRagdoll");
		}
		if (type > 0)
		{
			new owner;
			for (new i=1; i<=MaxClients; i++)
			{
				for (new j=4; j<=7; j++)
				{
					if (DefenseGridEnt[i][j] == caller)
					{
						owner = i;
					}
				}
			}
			if (IsSurvivor(owner) && !IsFakeClient(owner) && !bNightmare)
			{
				new level = cLevel[owner];
				if (level < 50)
				{
					new messages = cNotifications[owner];
					switch(type)
					{
						case 1:
						{
							new earnedxp = 2 * GetXPDiff(0);
							GiveXP(owner, earnedxp);
							if (messages > 0)
							{
								PrintToChat(owner, "\x04[Defense Grid]\x01 Special Infected Blocked: \x03%i\x01 XP", earnedxp);
							}
						}
						case 2:
						{
							new earnedxp = 3 * GetXPDiff(0);
							GiveXP(owner, earnedxp);
							if (messages > 0)
							{
								PrintToChat(owner, "\x04[Defense Grid]\x01 Tank Blocked: \x03%i\x01 XP", earnedxp);
							}
						}
						case 3:
						{
							new earnedxp = 1 * GetXPDiff(0);
							GiveXP(owner, earnedxp);
							if (messages > 0)
							{
								PrintToChat(owner, "\x04[Defense Grid]\x01 Spitter Projectile Blocked: \x03%i\x01 XP", earnedxp);
							}
						}
						case 4:
						{
							new earnedxp = 1 * GetXPDiff(0);
							GiveXP(owner, earnedxp);
							if (messages > 0)
							{
								PrintToChat(owner, "\x04[Defense Grid]\x01 Tank Rock Blocked: \x03%i\x01 XP", earnedxp);
							}
						}
						case 5:
						{
							new earnedxp = 2 * GetXPDiff(1);
							GiveXP(owner, earnedxp);
							if (messages > 0)
							{
								PrintToChat(owner, "\x04[Defense Grid]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
							}
						}
						case 6:
						{
							new earnedxp = 1 * GetXPDiff(1);
							GiveXP(owner, earnedxp);
							if (messages > 0)
							{
								PrintToChat(owner, "\x04[Defense Grid]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
							}
						}
						case 7:
						{
							new earnedxp = 10 * GetXPDiff(1);
							GiveXP(owner, earnedxp);
							if (messages > 0)
							{
								PrintToChat(owner, "\x04[Defense Grid]\x01 Lesser Witch Killed: \x03%i\x01 XP", earnedxp);
							}
						}
						case 8:
						{
							new earnedxp = 25 * GetXPDiff(1);
							GiveXP(owner, earnedxp);
							if (messages > 0)
							{
								PrintToChat(owner, "\x04[Defense Grid]\x01 Witch Killed: \x03%i\x01 XP", earnedxp);
							}
						}
					}
				}
				else
				{
					switch(type)
					{
						case 1:
						{
							new earnedxp = 2 * GetXPDiff(0);
							GiveXP(owner, earnedxp);
						}
						case 2:
						{
							new earnedxp = 3 * GetXPDiff(0);
							GiveXP(owner, earnedxp);
						}
						case 3:
						{
							new earnedxp = 1 * GetXPDiff(0);
							GiveXP(owner, earnedxp);
						}
						case 4:
						{
							new earnedxp = 1 * GetXPDiff(0);
							GiveXP(owner, earnedxp);
						}
						case 5:
						{
							new earnedxp = 2 * GetXPDiff(1);
							GiveXP(owner, earnedxp);
						}
						case 6:
						{
							new earnedxp = 1 * GetXPDiff(1);
							GiveXP(owner, earnedxp);
						}
						case 7:
						{
							new earnedxp = 10 * GetXPDiff(1);
							GiveXP(owner, earnedxp);
						}
						case 8:
						{
							new earnedxp = 25 * GetXPDiff(1);
							GiveXP(owner, earnedxp);
						}
					}
				}
			}
		}
	}
}
stock UpdateDefenseGrid(client)
{
	new entity = DefenseGridEnt[client][1];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[36];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, MODEL_DEFENSEGRID, false))
			{
				if (DefenseGridTimer[client] <= 280)
				{
					SetEntProp(entity, Prop_Send, "m_bFlashing", 1);
				}
				ExecuteDefenseGrid(client);
				CreateTimer(0.3, DefenseGridExecTimer, client, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(0.5, DefenseGridExecTimer, client, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(0.7, DefenseGridExecTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	DefenseGridTimer[client] -= 1;
}
public Action:DefenseGridExecTimer(Handle:timer, any:client)
{
	ExecuteDefenseGrid(client);
}
stock ExecuteDefenseGrid(client)
{
	new entity = DefenseGridEnt[client][1];
	if (entity > 32 && IsValidEntity(entity))
	{
		AttachParticle(entity, PARTICLE_DEFENSEGRID_GLOW, 0.5, 0.0, 0.0, 12.0);
		CreateDefenseGridBoltParticle(entity);
	}
}
stock CreateDefenseGridBoltParticle(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String:name[8];
		decl Float:Origin[3], Float:TOrigin[3], Float:Angles[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
		
		Angles[0] = GetRandomFloat(-360.0, 360.0);
		Angles[1] = GetRandomFloat(-360.0, 360.0);
		Angles[2] = 0.0;
		GetAngleVectors(Angles, TOrigin, NULL_VECTOR, NULL_VECTOR);
 
		NormalizeVector(TOrigin, TOrigin);
		ScaleVector(TOrigin, 110.0);
		AddVectors(Origin, TOrigin, TOrigin);

		new endpoint = CreateEntityByName("info_particle_target");
		if (endpoint > 0 && IsValidEntity(endpoint))
		{
			Format(name, sizeof(name), "bt%i", endpoint);
			DispatchKeyValue(endpoint, "targetname", name);
			DispatchKeyValueVector(endpoint, "origin", TOrigin);	
			DispatchSpawn(endpoint);
			ActivateEntity(endpoint);
			SetVariantString("OnUser1 !self:Kill::0.4:-1");
			AcceptEntityInput(endpoint, "AddOutput");
			AcceptEntityInput(endpoint, "FireUser1");
		}
		new particle = CreateEntityByName("info_particle_system");
		if (particle > 0 && IsValidEntity(particle))
		{
			DispatchKeyValue(particle, "effect_name", PARTICLE_LS_BOLT);
			DispatchKeyValue(particle, "cpoint1", name);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity);
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.4:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
		}
		new random = GetRandomInt(1,5);
		switch(random)
		{
			case 1: EmitSoundToAll("ambient/energy/zap5.wav", endpoint);
			case 2: EmitSoundToAll("ambient/energy/zap6.wav", endpoint);
			case 3: EmitSoundToAll("ambient/energy/zap7.wav", endpoint);
			case 4: EmitSoundToAll("ambient/energy/zap8.wav", endpoint);
			case 5: EmitSoundToAll("ambient/energy/zap9.wav", endpoint);
		}
	}
}
stock DestroyDefenseGrid(client)
{
	new entity = DefenseGridEnt[client][0];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[52];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_interiors/makeshift_stove_battery.mdl", false))
			{
				DefenseGridEnt[client][0] = 0;
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
	entity = DefenseGridEnt[client][1];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[36];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, MODEL_DEFENSEGRID, false))
			{
				DefenseGridEnt[client][1] = 0;
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
	entity = DefenseGridEnt[client][2];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[50];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_unique/airport/atlas_break_ball.mdl", false))
			{
				DefenseGridEnt[client][2] = 0;
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.0);
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
	entity = DefenseGridEnt[client][3];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[22];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "filter_activator_team", false))
		{
			DefenseGridEnt[client][3] = 0;
			AcceptEntityInput(entity, "Kill");
		}
	}
	entity = DefenseGridEnt[client][4];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[14];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "trigger_push", false))
		{
			DefenseGridEnt[client][4] = 0;
			AcceptEntityInput(entity, "Kill");
		}
	}
	entity = DefenseGridEnt[client][5];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[14];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "trigger_push", false))
		{
			DefenseGridEnt[client][5] = 0;
			AcceptEntityInput(entity, "Kill");
		}
	}
	entity = DefenseGridEnt[client][6];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[14];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "trigger_push", false))
		{
			DefenseGridEnt[client][6] = 0;
			AcceptEntityInput(entity, "Kill");
		}
	}
	entity = DefenseGridEnt[client][7];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[14];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "trigger_push", false))
		{
			DefenseGridEnt[client][7] = 0;
			AcceptEntityInput(entity, "Kill");
		}
	}
	DefenseGridTimer[client] -= 1;
}
stock ShowAngle(color[4], Float:Origin[3], Float:Angles[3])
{
	decl Float:TOrigin[3];
	GetAngleVectors(Angles, TOrigin, NULL_VECTOR, NULL_VECTOR);
 
	NormalizeVector(TOrigin, TOrigin);
	ScaleVector(TOrigin, 200.0);
	AddVectors(Origin, TOrigin, TOrigin);

	TE_SetupBeamPoints(Origin, TOrigin, IonBeamSprite, 0, 0, 0, 3.0, 1.0, 1.0, 1, 0.0, color, 0);
	TE_SendToAll();
}
stock SpawnAmmoPile(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new Float:Origin[3];
		GetClientAbsOrigin(client, Origin);
		new entity = CreateEntityByName("prop_dynamic");
		if (entity > 32)
		{
			DispatchKeyValue(entity, "model", "models/props_unique/spawn_apartment/coffeeammo.mdl");
			DispatchKeyValueVector(entity, "origin", Origin);
			DispatchKeyValue(entity, "solid", "6");
			DispatchSpawn(entity);
			AcceptEntityInput(entity, "DisableCollision");
			new glowcolor = RGB_TO_INT(0, 100, 255);
			SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
			SetEntProp(entity, Prop_Send, "m_iGlowType", 2);
			AmmoPile[client] = entity;
			AmmoTimer[client] += 300;
		}
	}
}
stock GetNearestAimAmmo(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new Float:distance = 0.0;
		decl Float:Origin[3], Float:Angles[3], Float:TOrigin[3], Float:Direction[3], Float:EndPos[3];
		GetClientEyePosition(client, Origin);
		GetClientEyeAngles(client, Angles);
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "prop_dynamic")) != INVALID_ENT_REFERENCE)
		{
			decl String:model[52];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_unique/spawn_apartment/coffeeammo.mdl", false))
			{
				GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
				distance = GetVectorDistance(Origin, TOrigin);
                       		if (distance <= 125.0)
				{
					GetAngleVectors(Angles, Direction, NULL_VECTOR, NULL_VECTOR);
					ScaleVector(Direction, distance);
					AddVectors(Origin, Direction, EndPos);
					distance = GetVectorDistance(TOrigin, EndPos);
                        		if (distance <= 25.0)
					{
						return entity;
					}
				}	
			}
		}
	}
	return 0;
}
stock UseSpawnAmmoPile(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (UseDelay[client] == 0)
		{
			new entity = GetNearestAimAmmo(client);
			if (entity > 32 && IsValidEntity(entity))
			{
				new String:classname[28];
				GetEdictClassname(entity, classname, sizeof(classname));
				//PrintToChat(client, "%s", classname);
				if (StrEqual(classname, "prop_dynamic", false))
				{
					decl String:model[52];
					GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
					//PrintToChat(client, "%s", model);
					if (StrEqual(model, "models/props_unique/spawn_apartment/coffeeammo.mdl", false))
					{
						if (CannonAmmo[client] < 500)
						{
							CannonAmmo[client] = 500;
							new level = cLevel[client];
							if (level >= 45)
							{
								PrintToChat(client, "\x04[Shoulder Cannon]\x01 Ammo Refilled.");
							}
						}
						new owner = 0;
						for (new i=1; i<=MaxClients; i++)
						{
							if (AmmoPile[i] == entity)
							{
								owner = i;
							}
						}
						if (GetPlayerWeaponSlot(client, 0) > 0)
						{
							new level = cLevel[client];
							new bool:packrat = false;
							new maxammo = 0;
							new weapon = GetPlayerWeaponSlot(client, 0);
							new offset = GetWeaponAmmoOffset(weapon);
							GetEdictClassname(weapon, classname, sizeof(classname));
							if (StrEqual(classname, "weapon_rifle", false) || StrEqual(classname, "weapon_rifle_sg552", false))
							{
								maxammo = 360;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 410;
								}
							}
							else if (StrEqual(classname, "weapon_rifle_desert", false))
							{
								maxammo = 360;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 420;
								}
							}
							else if (StrEqual(classname, "weapon_rifle_ak47", false))
							{
								maxammo = 360;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 400;
								}
							}
							else if (StrEqual(classname, "weapon_smg", false) || StrEqual(classname, "weapon_smg_silenced", false) || StrEqual(classname, "weapon_smg_mp5", false))
							{
								maxammo = 650;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 700;
								}
							}
							else if (StrEqual(classname, "weapon_pumpshotgun", false) || StrEqual(classname, "weapon_shotgun_chrome", false))
							{
								maxammo = 56;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 64;
								}
							}
							else if (StrEqual(classname, "weapon_autoshotgun", false) || StrEqual(classname, "weapon_shotgun_spas", false))
							{
								maxammo = 90;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 100;
								}
							}
							else if (StrEqual(classname, "weapon_hunting_rifle", false))
							{
								maxammo = 150;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 165;
								}
							}
							else if (StrEqual(classname, "weapon_sniper_scout", false))
							{
								maxammo = 180;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 195;
								}
							}
							else if (StrEqual(classname, "weapon_sniper_military", false))
							{
								maxammo = 180;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 210;
								}
							}
							else if (StrEqual(classname, "weapon_sniper_awp", false))
							{
								maxammo = 180;
								//pack rat
								if (level >= 6)
								{
									packrat = true;
									maxammo = 200;
								}
							}
							if (offset != 24 && offset != 68 && offset > 0)
							{
								new ammo = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset));
								//PrintToChat(client, "ammo:%i, maxammo:%i, offset:%i", ammo, maxammo, offset);
								if (maxammo > ammo)
								{
									SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(offset), maxammo);
									if (packrat)
									{
										PrintToChat(client, "\x04[Pack Rat]\x01 Storing Extra Ammo");
									}
									UseDelay[client] = 1;
									CreateTimer(4.0, UseDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
									if (IsSurvivor(owner) && !IsFakeClient(owner) && !bNightmare)
									{
										new earnedxp = 5 * GetXPDiff(0);
										level = cLevel[owner];
										if (level < 50)
										{
											GiveXP(client, earnedxp);
											PrintToChat(owner, "\x04[Ammo Pile]\x01 Item Used: \x03%i\x01 XP", earnedxp);
										}
										else
										{
											GiveXP(client, earnedxp);
										}
									}
								}
							}
							else
							{
								//size matters
								level = cLevel[client];
								if (level >= 29)
								{
									if (StrEqual(classname, "weapon_rifle_m60", false))
									{
										maxammo = 150;
										new ammo = GetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1");
										if (maxammo > ammo)
										{
											PrintToChat(client, "\x04[Size Matters]\x01 Heavy Weapon Ammo Collected.");
											SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1", maxammo);
											UseDelay[client] = 1;
											CreateTimer(4.0, UseDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
											if (IsSurvivor(owner) && !IsFakeClient(owner) && !bNightmare)
											{
												new earnedxp = 5 * GetXPDiff(0);
												level = cLevel[owner];
												if (level < 50)
												{
													GiveXP(client, earnedxp);
													PrintToChat(owner, "\x04[Ammo Pile]\x01 Item Used: \x03%i\x01 XP", earnedxp);
												}
												else
												{
													GiveXP(client, earnedxp);
												}
											}
										}
										//commando
										level = cLevel[client];
										if (level >= 41)
										{
											ammo = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24));
											if (ammo < 300)
											{
												SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(24), 300);
												PrintToChat(client, "\x04[Commando]\x01 Using Extended Cartridge Capacity");
											}
											if (UseDelay[client] == 0)
											{
												UseDelay[client] = 1;
												CreateTimer(4.0, UseDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
												if (IsSurvivor(owner) && !IsFakeClient(owner) && !bNightmare)
												{
													new earnedxp = 5 * GetXPDiff(0);
													level = cLevel[owner];
													if (level < 50)
													{
														GiveXP(client, earnedxp);
														PrintToChat(owner, "\x04[Ammo Pile]\x01 Item Used: \x03%i\x01 XP", earnedxp);
													}
													else
													{
														GiveXP(client, earnedxp);
													}
												}
											}
										}
									}
									else if (StrEqual(classname, "weapon_grenade_launcher", false))
									{
										maxammo = 30;
										new ammo = GetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68));
										if (maxammo > ammo)
										{
											PrintToChat(client, "\x04[Size Matters]\x01 Heavy Weapon Ammo Collected");
											SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iAmmo")+(68), maxammo);
											UseDelay[client] = 1;
											CreateTimer(4.0, UseDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
											if (IsSurvivor(owner) && !IsFakeClient(owner) && !bNightmare)
											{
												new earnedxp = 5 * GetXPDiff(0);
												level = cLevel[owner];
												if (level < 50)
												{
													GiveXP(owner, earnedxp);
													PrintToChat(owner, "\x04[Ammo Pile]\x01 Item Used: \x03%i\x01 XP", earnedxp);
												}
												else
												{
													GiveXP(owner, earnedxp);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
stock UpdateAmmoPile(client)
{
	new entity = AmmoPile[client];
	if (AmmoTimer[client] <= 250)
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			new String:classname[16];
			GetEdictClassname(entity, classname, sizeof(classname));
			if (StrEqual(classname, "prop_dynamic", false))
			{
				decl String:model[52];
				GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
				if (StrEqual(model, "models/props_unique/spawn_apartment/coffeeammo.mdl", false))
				{
					SetEntProp(entity, Prop_Send, "m_bFlashing", 1);
				}
			}
		}
	}
	AmmoTimer[client] -= 1;
}
stock DestroyAmmoPile(client)
{
	new entity = AmmoPile[client];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[52];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/props_unique/spawn_apartment/coffeeammo.mdl", false))
			{
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
	AmmoTimer[client] -= 1;
}
///////////////
// Abilities //
///////////////
stock Recall(client)
{
	if (Teleporter[client] > 0)
	{
		new target = Teleporter[client];
		if (target > 0 && IsClientInGame(target) && GetClientTeam(target) == 2)
		{
			new Float:Origin[3];
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", Origin);
			SetEntityMoveType(client, MOVETYPE_VPHYSICS);
			TeleportEntity(client, Origin, NULL_VECTOR, NULL_VECTOR);
			EmitSoundToAll("weapons/fx/nearmiss/bulletltor13.wav", client);
			SetEntityMoveType(client, MOVETYPE_WALK);
			AttachParticle(target, PARTICLE_NIGHTCRAWLER, 0.5, 0.0, 0.0, 0.0);
		}	
	}
}
stock PickNextTeleTarget(client)
{
	if (Teleporter[client] > 0)
	{
		new target = Teleporter[client];
    		for (new i=1; i<=MaxClients; i++)
    		{
        		if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && client != i)
			{
				if (target < i)
				{
					return i;
				}
			}
    		}	
	}
    	for (new i=1; i<=MaxClients; i++)
    	{
        	if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && client != i)
		{
			return i;
		}
    	}
	return 0;
}
stock TeleportTech(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		if (!IsCarryVictim(client))
		{
			if (IsPlayerHeld(client))
			{
				new zombie = CheckZombieHold(client);
				if (zombie > 0)
				{
					BreakInfectedHold(zombie);
					ResetClassAbility(zombie);
					if (IsPlayerIncap(client))
					{
						L4D2_ReviveSurvivor(client);
					}
					Recall(client);
					ChoiceDelay[client] = 1;
					CreateTimer(0.3, ChoiceDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else if (IsPlayerIncap(client))
			{
				L4D2_ReviveSurvivor(client);
				Recall(client);
				ChoiceDelay[client] = 1;
				CreateTimer(0.3, ChoiceDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				Recall(client);
				ChoiceDelay[client] = 1;
				CreateTimer(0.3, ChoiceDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}
stock BerserkerSwingSpeed(client)
{
	if (client > 0)
	{
		new level = cLevel[client];
		new ability = BerserkerOn[client];
		if (IsClientInGame(client) && level >= 5 && ability == 1 && !bNightmare)
		{
			if (GetPlayerWeaponSlot(client, 1) > 0)
			{
				new weapon = GetPlayerWeaponSlot(client, 1);
				if (IsValidEntity(weapon))
				{
					new Float:m_flNextPrimaryAttack = GetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack");
					new Float:m_flNextSecondaryAttack = GetEntPropFloat(weapon, Prop_Send, "m_flNextSecondaryAttack");
					new Float:m_flCycle = GetEntPropFloat(weapon, Prop_Send, "m_flCycle");
					if (m_flCycle == 0.000000)
					{
						SetEntPropFloat(weapon, Prop_Send, "m_flPlaybackRate", 1.6);
						SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", m_flNextPrimaryAttack - 0.30);
						SetEntPropFloat(weapon, Prop_Send, "m_flNextSecondaryAttack", m_flNextSecondaryAttack - 0.30);
					}
				}
			}
		}
	}
}
stock AbilityShout(client)
{
	if (client > 0)
	{
		if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
		{
			decl String:model[40];
			GetClientModel(client, model, sizeof(model));
			if (StrContains(model, "teenangst", false) != -1)
			{
				new random = GetRandomInt(1,4);
				switch(random)
				{
					case 1: EmitSoundToAll("player/survivor/voice/teengirl/taunt28.wav", client);
					case 2: EmitSoundToAll("player/survivor/voice/teengirl/taunt29.wav", client);
					case 3: EmitSoundToAll("player/survivor/voice/teengirl/taunt35.wav", client);
					case 4: EmitSoundToAll("player/survivor/voice/teengirl/taunt39.wav", client);
				}
			}
			else if (StrContains(model, "biker", false) != -1)
			{
				new random = GetRandomInt(1,4);
				switch(random)
				{
					case 1: EmitSoundToAll("player/survivor/voice/biker/taunt01.wav", client);
					case 2: EmitSoundToAll("player/survivor/voice/biker/taunt02.wav", client);
					case 3: EmitSoundToAll("player/survivor/voice/biker/taunt03.wav", client);
					case 4: EmitSoundToAll("player/survivor/voice/biker/taunt05.wav", client);
				}
			}
			else if (StrContains(model, "namvet", false) != -1)
			{
				new random = GetRandomInt(1,3);
				switch(random)
				{
					case 1: EmitSoundToAll("player/survivor/voice/namvet/taunt07.wav", client);
					case 2: EmitSoundToAll("player/survivor/voice/namvet/taunt08.wav", client);
					case 3: EmitSoundToAll("player/survivor/voice/namvet/taunt09.wav", client);
				}
			}
			else if (StrContains(model, "manager", false) != -1)
			{
				new random = GetRandomInt(1,4);
				switch(random)
				{
					case 1: EmitSoundToAll("player/survivor/voice/manager/taunt01.wav", client);
					case 2: EmitSoundToAll("player/survivor/voice/manager/taunt02.wav", client);
					case 3: EmitSoundToAll("player/survivor/voice/manager/taunt03.wav", client);
					case 4: EmitSoundToAll("player/survivor/voice/manager/taunt04.wav", client);
				}
			}
			else if (StrContains(model, "coach", false) != -1)
			{
				new random = GetRandomInt(1,4);
				switch(random)
				{
					case 1: EmitSoundToAll("player/survivor/voice/coach/taunt01.wav", client);
					case 2: EmitSoundToAll("player/survivor/voice/coach/taunt02.wav", client);
					case 3: EmitSoundToAll("player/survivor/voice/coach/taunt03.wav", client);
					case 4: EmitSoundToAll("player/survivor/voice/coach/taunt04.wav", client);
				}
			}
			else if (StrContains(model, "gambler", false) != -1)
			{
				new random = GetRandomInt(1,4);
				switch(random)
				{
					case 1: EmitSoundToAll("player/survivor/voice/gambler/taunt01.wav", client);
					case 2: EmitSoundToAll("player/survivor/voice/gambler/taunt04.wav", client);
					case 3: EmitSoundToAll("player/survivor/voice/gambler/taunt07.wav", client);
					case 4: EmitSoundToAll("player/survivor/voice/gambler/taunt08.wav", client);
				}
			}
			else if (StrContains(model, "producer", false) != -1)
			{
				new random = GetRandomInt(1,4);
				switch(random)
				{
					case 1: EmitSoundToAll("player/survivor/voice/producer/taunt01.wav", client);
					case 2: EmitSoundToAll("player/survivor/voice/producer/taunt02.wav", client);
					case 3: EmitSoundToAll("player/survivor/voice/producer/taunt04.wav", client);
					case 4: EmitSoundToAll("player/survivor/voice/producer/taunt06.wav", client);
				}
			}
			else if (StrContains(model, "mechanic", false) != -1)
			{
				new random = GetRandomInt(1,4);
				switch(random)
				{
					case 1: EmitSoundToAll("player/survivor/voice/mechanic/taunt02.wav", client);
					case 2: EmitSoundToAll("player/survivor/voice/mechanic/taunt05.wav", client);
					case 3: EmitSoundToAll("player/survivor/voice/mechanic/taunt07.wav", client);
					case 4: EmitSoundToAll("player/survivor/voice/mechanic/taunt08.wav", client);
				}
			}
		}	
	}
}
stock DisableAbilities(client)
{
	if (AbilityActive(client))
	{
		DestroyHealingAura(client);
		DestroySoulShield(client);
		DestroyLifeStealer(client);
		DestroyBerserker(client);
		DestroyNightCrawler(client);
		DestroyRapidFire(client);
		DestroyFlameShield(client);
		DestroyInstaGib(client);
		DestroyPolyMorph(client);
		DestroyDetectGZ(client);
		DestroyAcidBath(client);
		DestroyChainsawMass(client);
		DestroyHeatSeeker(client);
		DestroySpeedFreak(client);
	}
}
stock DisableAbilitiesAll()
{
	for (new client=1; client<=MaxClients; client++)
	{
		if (AbilityActive(client))
		{
			DestroyHealingAura(client);
			DestroySoulShield(client);
			DestroyLifeStealer(client);
			DestroyBerserker(client);
			DestroyNightCrawler(client);
			DestroyRapidFire(client);
			DestroyFlameShield(client);
			DestroyInstaGib(client);
			DestroyPolyMorph(client);
			DestroyDetectGZ(client);
			DestroyAcidBath(client);
			DestroyChainsawMass(client);
			DestroyHeatSeeker(client);
			DestroySpeedFreak(client);
		}
	}
}
stock bool:AbilityActive(client)
{
	if (HealingAuraOn[client] == 1 ||
	SoulShieldOn[client] == 1 ||
	LifeStealerOn[client] == 1 ||
	BerserkerOn[client] == 1 ||
	NightCrawlerOn[client] == 1 ||
	RapidFireOn[client] == 1 ||
	FlameShieldOn[client] == 1 ||
	InstaGibOn[client] == 1 ||
	PolyMorphOn[client] == 1 ||
	DetectGZOn[client] == 1 ||
	AcidBathOn[client] == 1 ||
	ChainsawMassOn[client] == 1 ||
	HeatSeekerOn[client] == 1 ||
	SpeedFreakOn[client] == 1)
	{
		return true;
	}
	return false;
}
public Action:NightVisionTimer(Handle:timer, any:client)
{
	if (client > 0 && IsClientInGame(client))
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
	}
}
stock AbilityDetectGZ(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		DetectGZOn[client] = 1;
		DetectGZTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateDetectGZ(client)
{
	new timer = DetectGZTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (DetectGZOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	DetectGZTimer[client] -= 1;
}
stock DestroyDetectGZ(client)
{
	if (DetectGZOn[client] == 1)
	{
		KillAllClones();
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Detect Zombie Deactivated");
		}
		DetectGZOn[client] = 0;
	}
	DetectGZTimer[client] -= 1;
}
stock CreateClone(client)
{
	if (ZombieClone[client] <= 0)
	{
		if (IsSpecialInfected(client) || IsTank(client))
		{
    			decl Float:Origin[3];
    			decl Float:Angles[3];
    			GetClientAbsOrigin(client, Origin);
    			GetClientEyeAngles(client, Angles);
    			decl String:Model[46]; 
    			GetEntPropString(client, Prop_Data, "m_ModelName", Model, sizeof(Model)); 

    			new entity = CreateEntityByName("prop_dynamic_override");
    			SetEntityModel(entity, Model);
			DispatchSpawn(entity);
    			TeleportEntity(entity,  Origin, Angles, NULL_VECTOR);
			AcceptEntityInput(entity, "DisableCollision");
			AcceptEntityInput(entity, "DisableShadow");
			SetEntProp(entity, Prop_Data, "m_iEFlags", 0);

			SetEntityRenderMode(entity, RenderMode:3);
      	 		SetEntityRenderColor(entity, 255, 255, 255, 0);

			new glowcolor = RGB_TO_INT(250, 250, 0);
			SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
			SetEntProp(entity, Prop_Send, "m_iGlowType", 3);

    			//SetEntPropFloat(entity, Prop_Send, "m_fadeMinDist", GetEntPropFloat(client, Prop_Send, "m_fadeMinDist"));
    			//SetEntPropFloat(entity, Prop_Send, "m_fadeMaxDist", GetEntPropFloat(client, Prop_Send, "m_fadeMaxDist"));

			SDKHook(entity, SDKHook_SetTransmit, Transmit_Clone);

			ZombieClone[client] = entity;
			//PrintToChatAll("Creating Clone: %i", ZombieClone[client]);
		}
	}
	else
	{
		if (IsSpecialInfected(client) || IsTank(client))
		{
			CloneMovement(client);
			return;
		}
		KillClone(client);
	}
}
public Action:Transmit_Clone(entity, client)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		if (IsSurvivor(client))
		{
			if (DetectGZOn[client] == 1)
			{
				return Plugin_Continue;
			}
		}
	}
	return Plugin_Handled;
}
stock CloneMovement(client)
{
	new entity = ZombieClone[client];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[28];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
        		SetEntProp(entity, Prop_Send, "m_nSequence", GetEntProp(client, Prop_Send, "m_nSequence"));
        		SetEntPropFloat(entity, Prop_Send, "m_flCycle", GetEntPropFloat(client, Prop_Send, "m_flCycle"));
        		SetEntPropFloat(entity, Prop_Send, "m_flPlaybackRate", GetEntPropFloat(client, Prop_Send, "m_flPlaybackRate"));

        		decl Float:Origin[3];
       	 		decl Float:Angles[3];
        		GetClientAbsOrigin(client, Origin);
        		GetClientAbsAngles(client, Angles);
        		TeleportEntity(entity, Origin, Angles, NULL_VECTOR);

        		for (new i=0; i<24; i++)
        		{
            			SetEntPropFloat(entity, Prop_Send, "m_flPoseParameter", GetEntPropFloat(client, Prop_Send, "m_flPoseParameter", i), i);
        		}
    		}
	}
}
stock KillClone(client)
{
	new entity = ZombieClone[client];
	if (entity > 32 && IsValidEntity(entity))
	{
		new String:classname[28];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
        		SetEntProp(entity, Prop_Send, "m_nSequence", 0);
        		SetEntPropFloat(entity, Prop_Send, "m_flCycle", 0.0);
        		SetEntPropFloat(entity, Prop_Send, "m_flPlaybackRate", 0.0);
			SetEntProp(entity, Prop_Send, "m_glowColorOverride", 0);
			SetEntProp(entity, Prop_Send, "m_iGlowType", 0);
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(entity, "AddOutput");
			ZombieClone[client] = 0;
		}
        }
}
stock KillAllClones()
{
	for (new i=1; i<=MaxClients; i++)
	{
		new entity = ZombieClone[i];
		if (entity > 32 && IsValidEntity(entity))
		{
			new String:classname[28];
			GetEdictClassname(entity, classname, sizeof(classname));
			if (StrEqual(classname, "prop_dynamic", false))
			{
        			SetEntProp(entity, Prop_Send, "m_nSequence", 0);
        			SetEntPropFloat(entity, Prop_Send, "m_flCycle", 0.0);
        			SetEntPropFloat(entity, Prop_Send, "m_flPlaybackRate", 0.0);
				SetEntProp(entity, Prop_Send, "m_glowColorOverride", 0);
				SetEntProp(entity, Prop_Send, "m_iGlowType", 0);
				//SetVariantString("OnUser1 !self:Kill::0.1:-1");
				//AcceptEntityInput(entity, "AddOutput");
				AcceptEntityInput(entity, "Kill");
				ZombieClone[i] = 0;
			}
        	}
	}
}
stock AbilityAcidBath(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		AcidBathOn[client] = 1;
		AcidBathTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateAcidBath(client)
{
	new timer = AcidBathTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (AcidBathOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	AcidBathTimer[client] -= 1;
}
stock DestroyAcidBath(client)
{
	if (AcidBathOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Acid Bath Deactivated");
		}
		AcidBathOn[client] = 0;
	}
	AcidBathTimer[client] -= 1;
}
stock AbilityChainsawMass(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		ChainsawMassOn[client] = 1;
		ChainsawMassTimer[client] = 300;
		CheatCommand(client, "give", "chainsaw");
		AbilityShout(client);
	}
}
stock UpdateChainsawMass(client)
{
	new timer = ChainsawMassTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (ChainsawMassOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	ChainsawMassTimer[client] -= 1;
}
stock DestroyChainsawMass(client)
{
	if (ChainsawMassOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Chainsaw Massacre Deactivated");
		}
		ChainsawMassOn[client] = 0;
	}
	ChainsawMassTimer[client] -= 1;
}
stock AbilityHeatSeeker(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		HeatSeekerOn[client] = 1;
		HeatSeekerTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateHeatSeeker(client)
{
	new timer = HeatSeekerTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (HeatSeekerOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	HeatSeekerTimer[client] -= 1;
}
stock DestroyHeatSeeker(client)
{
	if (HeatSeekerOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Heat Seeker Deactivated");
		}
		HeatSeekerOn[client] = 0;
	}
	HeatSeekerTimer[client] -= 1;
}
public Action:HeatSeekerProjTimer(Handle:timer, any:projEnt)
{
	if (IsValidEntity(projEnt))
	{
		new String:classname[30];
		GetEdictClassname(projEnt, classname, sizeof(classname));
		if (StrEqual(classname, "grenade_launcher_projectile", false))
		{
			new client = GetEntPropEnt(projEnt, Prop_Send, "m_hThrower");
			if (IsSurvivor(client))
			{
				if (HeatSeekerOn[client] == 1)
				{
					new Float:Origin[3], Float:CheckOrigin[3], Float:TOrigin[3];
					new Float:InfectedOrigin[3], Float:WitchOrigin[3], Float:SpecialOrigin[3], Float:TankOrigin[3];
					new Float:infecteddistance = 0.0, Float:infectedstoreddist = 0.0;
					new Float:witchdistance = 0.0, Float:witchstoreddist = 0.0;
					new Float:specialdistance = 0.0, Float:specialstoreddist = 0.0;
					new Float:tankdistance = 0.0, Float:tankstoreddist = 0.0;
					new tank, special, infected, witch, target;
					GetEntPropVector(projEnt, Prop_Send, "m_vecOrigin", Origin);

					new entity = -1;
					while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
					{
						new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
						if (ragdoll == 0)
						{
							GetEntPropVector(entity, Prop_Send, "m_vecOrigin", CheckOrigin);
                       					infecteddistance = GetVectorDistance(Origin, CheckOrigin);
							if (infectedstoreddist == 0.0 || infectedstoreddist > infecteddistance)
							{
								if (InLineOfSight(projEnt, entity, Origin, CheckOrigin))
								{
									infectedstoreddist = infecteddistance;
									infected = entity;
									GetEntPropVector(entity, Prop_Send, "m_vecOrigin", InfectedOrigin);
								}
							}
						}
					}
					while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
					{
						new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
						if (ragdoll == 0)
						{
							GetEntPropVector(entity, Prop_Send, "m_vecOrigin", CheckOrigin);
                       					witchdistance = GetVectorDistance(Origin, CheckOrigin);
							if (witchstoreddist == 0.0 || witchstoreddist > witchdistance)
							{
								if (InLineOfSight(projEnt, entity, Origin, CheckOrigin))
								{
									witchstoreddist = witchdistance;
									witch = entity;
									GetEntPropVector(entity, Prop_Send, "m_vecOrigin", WitchOrigin);
								}
							}
						}
					}
					while ((entity = FindEntityByClassname(entity, "player")) != INVALID_ENT_REFERENCE)
					{
						if (IsSpecialInfected(entity))
						{
							GetEntPropVector(entity, Prop_Send, "m_vecOrigin", CheckOrigin);
                       					specialdistance = GetVectorDistance(Origin, CheckOrigin);
							if (specialstoreddist == 0.0 || specialstoreddist > specialdistance)
							{
								if (InLineOfSight(projEnt, entity, Origin, CheckOrigin))
								{
									specialstoreddist = specialdistance;
									special = entity;
									GetEntPropVector(entity, Prop_Send, "m_vecOrigin", SpecialOrigin);
								}
							}
						}
						else if (IsTank(entity))
						{
							GetEntPropVector(entity, Prop_Send, "m_vecOrigin", CheckOrigin);
                       					tankdistance = GetVectorDistance(Origin, CheckOrigin);
							if (tankstoreddist == 0.0 || tankstoreddist > tankdistance)
							{
								if (InLineOfSight(projEnt, entity, Origin, CheckOrigin))
								{
									tankstoreddist = tankdistance;
									tank = entity;
									GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TankOrigin);
								}
							}
						}
					}
					new selectedtarget = HeatSeekerTarget[client];
					switch(selectedtarget)
					{
						case 0:
						{
							if (infected > 0)
							{
								if (infectedstoreddist > witchstoreddist)
								{
									if (witch > 0)
									{
										target = witch;
									}
									else
									{
										target = infected;
									}
								}
								else
								{
									target = infected;
								}
							}
							else if (witch > 0)
							{
								if (infectedstoreddist < witchstoreddist)
								{
									if (infected > 0)
									{
										target = infected;
									}
									else
									{
										target = witch;
									}
								}
								else
								{
									target = witch;
								}
							}
							else if (special > 0)
							{
								target = special;
							}
							else if (tank > 0)
							{
								target = tank;
							}
						}
						case 1:
						{
							if (special > 0)
							{
								target = special;
							}
							else if (infected > 0)
							{
								if (infectedstoreddist > witchstoreddist)
								{
									if (witch > 0)
									{
										target = witch;
									}
									else
									{
										target = infected;
									}
								}
								else
								{
									target = infected;
								}
							}
							else if (witch > 0)
							{
								if (infectedstoreddist < witchstoreddist)
								{
									if (infected > 0)
									{
										target = infected;
									}
									else
									{
										target = witch;
									}
								}
								else
								{
									target = witch;
								}
							}
							else if (tank > 0)
							{
								target = tank;
							}
						}
						case 2:
						{
							if (tank > 0)
							{
								target = tank;
							}
							else if (infected > 0)
							{
								if (infectedstoreddist > witchstoreddist)
								{
									if (witch > 0)
									{
										target = witch;
									}
									else
									{
										target = infected;
									}
								}
								else
								{
									target = infected;
								}
							}
							else if (witch > 0)
							{
								if (infectedstoreddist < witchstoreddist)
								{
									if (infected > 0)
									{
										target = infected;
									}
									else
									{
										target = witch;
									}
								}
								else
								{
									target = witch;
								}
							}
							else if (special > 0)
							{
								target = special;
							}
						}
					}
					if (target > 0)
					{
						if (IsInfected(target))
						{
							TOrigin = InfectedOrigin;
						}
						else if (IsWitch(target))
						{
							TOrigin = WitchOrigin;
						}
						else if (IsSpecialInfected(target))
						{
							TOrigin = SpecialOrigin;
						}
						else if (IsTank(target))
						{
							TOrigin = TankOrigin;
						}
						TOrigin[2] += 40.0;
						decl Float:Velocity[3];
						MakeVectorFromPoints(Origin, TOrigin, Velocity);
						GetVectorAngles(Velocity, Velocity);
						GetAngleVectors(Velocity, Velocity, NULL_VECTOR, NULL_VECTOR);
						NormalizeVector(Velocity, Velocity);
						ScaleVector(Velocity, 800.0);
						TeleportEntity(projEnt, NULL_VECTOR, NULL_VECTOR, Velocity);
					}
				}
			}
		}
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
stock HeatSeekerSelectTarget(client)
{
	new target = HeatSeekerTarget[client];
	switch(target)
	{
		case 0:
		{
			HeatSeekerTarget[client] = 1;
			PrintToChat(client, "\x04[Heat Seeker]\x01 targeting Special Infected");
		}
		case 1:
		{
			HeatSeekerTarget[client] = 2;
			PrintToChat(client, "\x04[Heat Seeker]\x01 targeting Tanks");
		}
		case 2:
		{
			HeatSeekerTarget[client] = 0;
			PrintToChat(client, "\x04[Heat Seeker]\x01 targeting Infected/Witches");
		}
	}
}
stock bool:InLineOfSight(entity, target, Float:Origin[3], Float:TOrigin[3])
{
	TOrigin[2] += 40.0;

	new Handle:LineTrace = TR_TraceRayFilterEx(Origin, TOrigin, MASK_SOLID_BRUSHONLY, RayType_EndPoint, TraceRayProjFilter, entity);
	if (TR_DidHit(LineTrace))
	{
		new trace = TR_GetEntityIndex(LineTrace);
		if (trace == target)
		{
			CloseHandle(LineTrace);
			return true;
		}
	}
	CloseHandle(LineTrace);
	return false;
}
public bool:TraceRayProjFilter(entity, mask, any:data)
{
    	if (entity == data)
	{
		return false;
	}
    	return true;
}
stock bool:IsGrenadeProjectile(entity)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		decl String: classname[30];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "grenade_launcher_projectile", false))
		{
			return true;
		}
	}
	return false;
}
stock AbilitySpeedFreak(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);

		new health = GetEntProp(client, Prop_Send, "m_iHealth");
		SetEntProp(client, Prop_Send, "m_iMaxHealth", 50);
		if (health > 50)
		{
			SetEntProp(client, Prop_Send, "m_iHealth", 50);
		}

		SpeedFreakOn[client] = 1;
		SpeedFreakTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateSpeedFreak(client)
{
	new timer = SpeedFreakTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (SpeedFreakOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	SpeedFreakTimer[client] -= 1;
}
stock DestroySpeedFreak(client)
{
	if (SpeedFreakOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Speed Freak Deactivated");
		}
		SpeedFreakOn[client] = 0;
	}
	SpeedFreakTimer[client] -= 1;
}
stock AbilityHealingAura(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		HealingAuraOn[client] = 1;
		HealingAuraTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateHealingAura(client)
{
	new timer = HealingAuraTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (HealingAuraOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	HealingAuraTimer[client] -= 1;
}
stock DestroyHealingAura(client)
{
	if (HealingAuraOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Healing Aura Deactivated");
			HealingAuraEffects(client, 0, 0);
		}
		HealingAuraOn[client] = 0;
	}
	HealingAuraTimer[client] -= 1;
}
stock HealingAuraEffects(client, alpha, glowtype)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		new glowcolor = RGB_TO_INT(0, alpha, 0);
		SetEntProp(client, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntProp(client, Prop_Send, "m_iGlowType", glowtype);
		if (glowtype == 3)
		{
			SetEntProp(client, Prop_Send, "m_bFlashing", 1);
		}
		else
		{
			SetEntProp(client, Prop_Send, "m_bFlashing", 0);
		}
	}
}
stock HealingAuraHealer()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (HealingAuraOn[i] == 1)
		{
			HealingAuraHeal(i, 5, i);
		}
		else if (HealingAuraTarget[i] > 0)
		{
			new healer = HealingAuraPlayer[i];
			new heal = HealingAuraTarget[i];
			HealingAuraHeal(i, heal, healer);
		}
	}
}
stock HealingAuraController()
{
	new i = 0;
	new count = 0;
	for (i=1; i<=MaxClients; i++)
	{
		if (HealingAuraOn[i] == 1)
		{
			count++;
		}
		if (HealingAuraTarget[i] > 0)
		{
			HealingAuraPlayer[i] = 0;
			HealingAuraTarget[i] = 0;
			if (IsSurvivor(i) && IsPlayerAlive(i))
			{
				HealingAuraEffects(i, 0, 0);
			}
		}
	}
	if (count == 0)
	{
		return;
	}
	new target = 0;
	new Float:distance = 0.0;
        new Float:Origin[3], Float:TOrigin[3];
	for (i=1; i<=MaxClients; i++)
	{
		if (IsSurvivor(i) && IsPlayerAlive(i))
		{
			if (HealingAuraOn[i] == 0)
			{
				GetEntPropVector(i, Prop_Send, "m_vecOrigin", TOrigin);
				for (new j=1; j<=MaxClients; j++)
				{
					if (HealingAuraOn[j] == 1)
					{
						GetEntPropVector(j, Prop_Send, "m_vecOrigin", Origin);
						if (GetVectorDistance(Origin, TOrigin) < distance || distance == 0.0)
						{
							distance = GetVectorDistance(Origin, TOrigin);
							target = j;
						}
					}
				}
				if (target > 0)
				{
					if (distance < 100)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 1;
						HealingAuraEffects(i, 250, 2);
					}
					else if (distance < 150)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 1;
						HealingAuraEffects(i, 225, 2);
					}
					else if (distance < 200)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 2;
						HealingAuraEffects(i, 200, 2);
					}
					else if (distance < 250)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 2;
						HealingAuraEffects(i, 175, 2);
					}
					else if (distance < 300)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 3;
						HealingAuraEffects(i, 150, 2);
					}
					else if (distance < 350)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 3;
						HealingAuraEffects(i, 125, 2);
					}
					else if (distance < 400)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 4;
						HealingAuraEffects(i, 100, 2);
					}
					else if (distance < 450)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 4;
						HealingAuraEffects(i, 75, 2);
					}
					else if (distance < 500)
					{
						HealingAuraPlayer[i] = target;
						HealingAuraTarget[i] = 5;
						HealingAuraEffects(i, 50, 2);
					}
					distance = 0.0;
					target = 0;
				}
			}
			else
			{
				HealingAuraEffects(i, 255, 3);
			}
		}
	}
}
stock HealingAuraHeal(client, hlevel, healer)
{
	new damage = 0;
	switch(hlevel)
	{
		case 1: damage = 3;
		case 2: damage = 6;
		case 3: damage = 9;
		case 4: damage = 12;
		case 5: damage = 15;
	}
	HealSurvivor(client, damage, healer);
}
stock HealSurvivor(client, amount, healer)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		if (IsPlayerIncap(client) && !IsHanging(client) && CheckZombieHold(client) == 0)
		{
			if (!GiveHealth(client, amount, false))
			{
				if (IsSurvivor(healer) && !IsFakeClient(healer) && healer != client)
				{
					new earnedxp = 15 * GetXPDiff(0);
					new lvl = cLevel[healer];
					if (lvl < 50)
					{
						GiveXP(healer, earnedxp);
						PrintToChat(healer, "\x05[Lethal-Injection]\x01 Revived Teammate: \x03%i\x01 XP", earnedxp);
					}
				}
				L4D2_ReviveSurvivor(client);
			}
		}
		else if (CheckZombieHold(client) == 0)
		{
			GiveHealth(client, amount, false);
		}
	}
}
stock AbilitySoulShield(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		SoulShieldOn[client] = 1;
		SoulShieldTimer[client] = 300;
		CreateSoulShield(client);
		AbilityShout(client);
	}
}
stock CreateSoulShield(client)
{
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		decl Float:Origin[3], Float:Angles[3];
		GetClientAbsOrigin(client, Origin);
		Angles[0] = 0.0;
		Angles[1] = 0.0;
		Angles[2] = 0.0;
	
		new light = CreateEntityByName("beam_spotlight");
		if (light > 0)
		{
			Angles[0] = -90.0;
			TeleportEntity(light, Origin, Angles, NULL_VECTOR);
			DispatchKeyValue(light, "spotlightwidth", "60");
			DispatchKeyValue(light, "spotlightlength", "50");
			DispatchKeyValue(light, "spawnflags", "3");
			DispatchKeyValue(light, "rendercolor", "255 215 0");
			DispatchKeyValue(light, "renderamt", "100");
			DispatchKeyValue(light, "maxspeed", "100");
			DispatchKeyValue(light, "HDRColorScale", "0.7");
			DispatchKeyValue(light, "fadescale", "1");
			DispatchKeyValue(light, "fademindist", "-1");
			DispatchSpawn(light);
			SetVariantString("!activator");
			AcceptEntityInput(light, "SetParent", client);
			SoulShieldGlow[client][0] = light;
			SDKHook(light, SDKHook_SetTransmit, Transmit_SoulShield);
		}

		new light2 = CreateEntityByName("beam_spotlight");
		if (light2 > 0)
		{
			Origin[2] = Origin[2] + 70.0;
			Angles[0] = 90.0;
			TeleportEntity(light2, Origin, Angles, NULL_VECTOR);
			DispatchKeyValue(light2, "spotlightwidth", "60");
			DispatchKeyValue(light2, "spotlightlength", "50");
			DispatchKeyValue(light2, "spawnflags", "3");
			DispatchKeyValue(light2, "rendercolor", "255 215 0");
			DispatchKeyValue(light2, "renderamt", "100");
			DispatchKeyValue(light2, "maxspeed", "100");
			DispatchKeyValue(light2, "HDRColorScale", "0.7");
			DispatchKeyValue(light2, "fadescale", "1");
			DispatchKeyValue(light2, "fademindist", "-1");
			DispatchSpawn(light2);
			SetVariantString("!activator");
			AcceptEntityInput(light2, "SetParent", client);
			SoulShieldGlow[client][1] = light2;
			SDKHook(light2, SDKHook_SetTransmit, Transmit_SoulShield);
		}
		SetEntityRenderMode(client, RenderMode:3);
      	 	SetEntityRenderColor(client, 255, 215, 0, 255);
	}
}
public Action:Transmit_SoulShield(entity, client)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		if (client > 0 && IsClientInGame(client) && !IsFakeClient(client))
		{
			if (entity == SoulShieldGlow[client][0] || entity == SoulShieldGlow[client][1])
			{
				new String:classname[16];
				GetEdictClassname(entity, classname, sizeof(classname));
				if (StrEqual(classname, "beam_spotlight", false))
				{
					return Plugin_Handled;
				}
			}
		}
	}
	return Plugin_Continue;
}
stock UpdateSoulShield(client)
{
	new timer = SoulShieldTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (SoulShieldOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	SoulShieldTimer[client] -= 1;
}
stock DestroySoulShield(client)
{
	if (SoulShieldOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Soulshield Deactivated");

			new entity = SoulShieldGlow[client][0];
			if (entity > 32 && IsValidEntity(entity))
			{
				new String:classname[16];
				GetEdictClassname(entity, classname, sizeof(classname));
				if (StrEqual(classname, "beam_spotlight", false))
				{
					AcceptEntityInput(entity, "Kill");
					SoulShieldGlow[client][0] = 0;
				}
			}
			entity = SoulShieldGlow[client][1];
			if (entity > 32 && IsValidEntity(entity))
			{
				new String:classname[16];
				GetEdictClassname(entity, classname, sizeof(classname));
				if (StrEqual(classname, "beam_spotlight", false))
				{
					AcceptEntityInput(entity, "Kill");
					SoulShieldGlow[client][1] = 0;
				}
			}
			SetEntityRenderMode(client, RenderMode:3);
      	 		SetEntityRenderColor(client, 255, 255, 255, 255);
		}
		SoulShieldOn[client] = 0;
	}
	SoulShieldTimer[client] -= 1;
}
stock AbilityLifeStealer(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		LifeStealerOn[client] = 1;
		LifeStealerTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateLifeStealer(client)
{
	new timer = LifeStealerTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (LifeStealerOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	LifeStealerTimer[client] -= 1;
}
stock DestroyLifeStealer(client)
{
	if (LifeStealerOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Lifestealer Deactivated");
		}
		LifeStealerOn[client] = 0;
	}
	LifeStealerTimer[client] -= 1;
}
stock StealLife(client, damage)
{
	new level = cLevel[client];
	if (damage > 0)
	{
		new scale = 0;
		new dmgscale = 0;
		for (dmgscale=1; dmgscale<=50; dmgscale++)
		{
			if (damage < (dmgscale*10))
			{
				scale = dmgscale;
				break;
			}
		}
		if (level <= 5)
		{
			damage = 5;
		}
		else
		{
			damage = level / 5;
		}
		damage = damage * scale;
	}
	else
	{
		return;
	}
	if (IsSurvivor(client) && IsPlayerAlive(client))
	{
		if (IsPlayerIncap(client))
		{
			if (!GiveHealth(client, damage, false))
			{
				L4D2_ReviveSurvivor(client);
			}
		}
		else
		{
			GiveHealth(client, damage, false);
		}
	}	
}
stock LifeStealerEffectsPlayer(client)
{
	if (IsSpecialInfected(client) || IsTank(client))
	{
		new color = GetEntityGlowColor(client);
		if (color != 10200)
		{
			new glowcolor = RGB_TO_INT(102, 0, 0);
			SetEntProp(client, Prop_Send, "m_glowColorOverride", glowcolor);
			SetEntProp(client, Prop_Send, "m_iGlowType", 3);
			CreateTimer(0.5, LSEffectsPlayerTimer, client, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}
public Action:LSEffectsPlayerTimer(Handle:timer, any:client)
{
	if (IsSpecialInfected(client) || IsTank(client))
	{
		new glowcolor = RGB_TO_INT(255, 255, 255);
		SetEntProp(client, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntProp(client, Prop_Send, "m_iGlowType", 0);
	}
}
stock LifeStealerEffectsEntity(entity)
{
	if (IsInfected(entity) || IsWitch(entity))
	{
		new color = GetEntityGlowColor(entity);
		if (color != 10200)
		{
			new glowcolor = RGB_TO_INT(102, 0, 0);
			SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
			SetEntProp(entity, Prop_Send, "m_iGlowType", 3);
			CreateTimer(0.5, LSEffectsEntityTimer, entity, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}
public Action:LSEffectsEntityTimer(Handle:timer, any:entity)
{
	if (IsInfected(entity) || IsWitch(entity))
	{
		new glowcolor = RGB_TO_INT(255, 255, 255);
		SetEntProp(entity, Prop_Send, "m_glowColorOverride", glowcolor);
		SetEntProp(entity, Prop_Send, "m_iGlowType", 0);
	}
}
stock AbilityBerserker(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		BerserkerOn[client] = 1;
		BerserkerTimer[client] = 300;
		AbilityShout(client);
		L4D2_AdrenalineUsed(client, 60.0);
	}
}
stock UpdateBerserker(client)
{
	new timer = BerserkerTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (BerserkerOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	BerserkerTimer[client] -= 1;
}
stock DestroyBerserker(client)
{
	if (BerserkerOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Berserker Deactivated");
		}
		BerserkerOn[client] = 0;
	}
	BerserkerTimer[client] -= 1;
}
CreateBerserkerEffect(Float:Origin[3], Float:Angles[3])
{
	Origin[2] += 35.0;
 	new particle = CreateEntityByName("info_particle_system");
	if (particle > 0 && IsValidEntity(particle))
	{
		DispatchKeyValue(particle, "effect_name", PARTICLE_BERSERKER);
		DispatchKeyValueVector(particle, "origin", Origin);
		DispatchKeyValueVector(particle, "angles", Angles);
		DispatchSpawn(particle);
		ActivateEntity(particle); 
		AcceptEntityInput(particle, "start");
		SetVariantString("OnUser1 !self:Kill::0.1:-1");
		AcceptEntityInput(particle, "AddOutput");
		AcceptEntityInput(particle, "FireUser1");	
	}
}
stock AbilityNightCrawler(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		NightCrawlerOn[client] = 1;
		NightCrawlerTimer[client] = 300;
		AbilityShout(client);

		SetEntityRenderMode(client, RenderMode:3);
      	 	SetEntityRenderColor(client, 0, 0, 255, 255);
	}
}
stock UpdateNightCrawler(client)
{
	new timer = NightCrawlerTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (NightCrawlerOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	NightCrawlerTimer[client] -= 1;
}
stock DestroyNightCrawler(client)
{
	if (NightCrawlerOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Nightcrawler Deactivated");

			SetEntityRenderMode(client, RenderMode:3);
      	 		SetEntityRenderColor(client, 255, 255, 255, 255);
		}
		NightCrawlerOn[client] = 0;
	}
	NightCrawlerTimer[client] -= 1;
}
stock AbilityRapidFire(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		RapidFireOn[client] = 1;
		RapidFireTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateRapidFire(client)
{
	new timer = RapidFireTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (RapidFireOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	RapidFireTimer[client] -= 1;
}
stock DestroyRapidFire(client)
{
	if (RapidFireOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Rapid Fire Deactivated");
		}
		RapidFireOn[client] = 0;
	}
	RapidFireTimer[client] -= 1;
}
stock RFGunSpeed(client)
{
	if (RapidFireOn[client] == 1 && !bNightmare)
	{
		if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
		{
			if (GetPlayerWeaponSlot(client, 0) > 0)
			{
				new weapon = GetPlayerWeaponSlot(client, 0);
				if (IsValidEntity(weapon))
				{
					new Float:m_flNextPrimaryAttack = GetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack");
					new Float:m_flNextSecondaryAttack = GetEntPropFloat(weapon, Prop_Send, "m_flNextSecondaryAttack");
					new Float:m_flCycle = GetEntPropFloat(weapon, Prop_Send, "m_flCycle");
					new m_bInReload = GetEntProp(weapon, Prop_Send, "m_bInReload");
					if (m_bInReload < 1)
					{
						new clip = GetEntProp(weapon, Prop_Send, "m_iClip1");
						if (clip <= 50)
						{
							SetEntProp(weapon, Prop_Send, "m_iClip1", clip+1);
						}
						if (m_flCycle == 0.000000)
						{
							SetEntPropFloat(weapon, Prop_Send, "m_flPlaybackRate", 1.3);
							SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", m_flNextPrimaryAttack - 0.15);
							SetEntPropFloat(weapon, Prop_Send, "m_flNextSecondaryAttack", m_flNextSecondaryAttack - 0.15);
						}
					}
				}
			}
		}
	}
}
stock AbilityFlameShield(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		FlameShieldOn[client] = 1;
		FlameShieldTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateFlameShield(client)
{
	new timer = FlameShieldTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (FlameShieldOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
			IgniteEntity(client, 1.0);
			FlameShieldEffects(client);
			if (IsPlayerHeld(client))
			{
				new zombie = CheckZombieHold(client);
				if (IsSmoker(zombie))
				{
					DealDamagePlayer(zombie, client, 10, 1, "point_hurt");
				}
			}
			FlameShieldHurt(client);
			CreateTimer(0.3, FlameShieldHurtTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(0.6, FlameShieldHurtTimer, client, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	FlameShieldTimer[client] -= 1;
}
stock FlameShieldEffects(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		decl Float:Origin[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);

   		new particle = CreateEntityByName("info_particle_system");
    		if (particle > 0 && IsValidEntity(particle))
    		{
			DispatchKeyValue(particle, "effect_name", PARTICLE_FLAMESHIELD);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);

			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", client);
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::1.0:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
		}
	}
}
stock DestroyFlameShield(client)
{
	if (FlameShieldOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Flameshield Deactivated");
		}
		FlameShieldOn[client] = 0;
	}
	FlameShieldTimer[client] -= 1;
}
stock FlameShieldHurt(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		decl Float:Origin[3], Float:TOrigin[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
		new target = -1;
		while ((target = FindEntityByClassname(target, "infected")) != INVALID_ENT_REFERENCE)
		{
			new ragdoll = GetEntProp(target, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				if (GetVectorDistance(Origin, TOrigin) <= 125)
				{
					DealDamageEntity(target, client, 10, 1, "point_hurt");
				}
			}
		}
		while ((target = FindEntityByClassname(target, "player")) != INVALID_ENT_REFERENCE)
		{
			if (target > 0 && IsClientInGame(target) && IsPlayerAlive(target) && !IsPlayerGhost(target) && GetClientTeam(target) == 3)
			{
				GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
				if (GetVectorDistance(Origin, TOrigin) <= 125)
				{
					DealDamagePlayer(target, client, 10, 1, "point_hurt");
				}
			}
		}
	}
}
public Action:FlameShieldHurtTimer(Handle:timer, any:client)
{
	FlameShieldHurt(client);
}
stock AbilityInstaGib(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		InstaGibOn[client] = 1;
		InstaGibTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdateInstaGib(client)
{
	new timer = InstaGibTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (InstaGibOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	InstaGibTimer[client] -= 1;
}
stock DestroyInstaGib(client)
{
	if (InstaGibOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Instagib Deactivated");
		}
		InstaGibOn[client] = 0;
	}
	InstaGibTimer[client] -= 1;
}
stock AbilityPolyMorph(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
		PolyMorphOn[client] = 1;
		PolyMorphTimer[client] = 300;
		AbilityShout(client);
	}
}
stock UpdatePolyMorph(client)
{
	new timer = PolyMorphTimer[client];
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (PolyMorphOn[client] == 1)
		{
			if (timer <= 250)
			{
				SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
				CreateTimer(0.5, NightVisionTimer, client, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	PolyMorphTimer[client] -= 1;
}
stock DestroyPolyMorph(client)
{
	if (PolyMorphOn[client] == 1)
	{
		if (client > 0 && IsClientInGame(client))
		{
			SetEntProp(client, Prop_Send, "m_bNightVisionOn", 0);
			PrintToChat(client, "\x04[Ability]\x01 Polymorph Deactivated");
		}
		PolyMorphOn[client] = 0;
	}
	PolyMorphTimer[client] -= 1;
}
stock PolyMorphTarget(entity, client)
{
	if (IsInfected(entity) && !bNightmare)
	{
		decl Float:Origin[3], Float:Angles[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(entity, Prop_Send, "m_angRotation", Angles);
		AttachParticleLoc(Origin, PARTICLE_POLYMORPH, 0.5);
		EmitSoundToAll("npc/infected/gore/bullets/bullet_impact_04.wav", entity);
		CreatePolyMorphItem(client, Origin, Angles);
		AcceptEntityInput(entity, "Kill");
		if (IsSurvivor(client) && !IsFakeClient(client))
		{
			new messages = cNotifications[client];
			new level = cLevel[client];
			if (level < 50)
			{
				if (IsUncommon(entity))
				{
					new earnedxp = 2 * GetXPDiff(1);
					GiveXP(client, earnedxp);
					if (messages > 0)
					{
						PrintToChat(client, "\x05[Lethal-Injection]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
					}
				}
				else
				{
					new earnedxp = 1 * GetXPDiff(1);
					GiveXP(client, earnedxp);
					if (messages > 0)
					{
						PrintToChat(client, "\x05[Lethal-Injection]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
					}
				}
			}
			else
			{
				if (IsUncommon(entity))
				{
					new earnedxp = 2 * GetXPDiff(1);
					GiveXP(client, earnedxp);
				}
				else
				{
					new earnedxp = 1 * GetXPDiff(1);
					GiveXP(client, earnedxp);
				}
			}
		}
	}
}
stock CreatePolyMorphItem(client, Float:Origin[3], Float:Angles[3])
{
	new random = GetRandomInt(1,100);
	if (random == 1)
	{
		if (iFinaleStage > 0)
		{
			iNumTanksWave += 1;
		}
		new bot = CreateFakeClient("Tank");
		if (bot > 0)
		{
			Origin[2] -= 30.0;
			TeleportEntity(bot, Origin, Angles, NULL_VECTOR);
			SpawnInfected(bot, 8, false);
		}
	}
	else if (random == 2)
	{
		if (client > 0 && IsClientInGame(client))
		{
			new witch = CreateEntityByName("witch");
			DispatchSpawn(witch);
			ActivateEntity(witch);
			TeleportEntity(witch, Origin, Angles, NULL_VECTOR);
			L4D2_InfectedHitByVomitJar(witch, client);
			SetEntProp(witch, Prop_Send, "m_iGlowType", 0);
			SetEntProp(witch, Prop_Send, "m_hOwnerEntity", client);
		}
	}
	else if (random == 3)
	{
		random = GetRandomInt(1,2);
		if (random == 1)
		{
			random = 39;
		}
		else
		{
			random = 40;
		}
		new String:classname[32];
		Format(classname, sizeof(classname), "%s", WeaponClassname[random]);
		new entity = CreateEntityByName(classname);
		if (entity > 0 && IsValidEntity(entity))
		{
			DispatchSpawn(entity);
			ActivateEntity(entity);
			if (StrEqual(classname, "weapon_grenade_launcher", false))
			{
				SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 30);
			}
			Origin[2] += 40.0;
			TeleportEntity(entity, Origin, Angles, NULL_VECTOR);

			new Handle:Pack = CreateDataPack();
			WritePackCell(Pack, iRound);
			WritePackCell(Pack, entity);
			WritePackString(Pack, classname);
			CreateTimer(20.0, RemovePolyMorphItem, Pack);
		}
	}
	else
	{
		new weapon1 = GetRandomInt(1,9);
		new weapon2 = 12;
		new weapon3 = GetRandomInt(24,38);
		new weapon4 = GetRandomInt(41,46);
		new weapon5 = 47;
		random = GetRandomInt(1,5);
		switch(random)
		{
			case 1: random = weapon1;
			case 2: random = weapon2;
			case 3: random = weapon3;
			case 4: random = weapon4;
			case 5: random = weapon5;
		}
		new String:modelname[42];
		new String:classname[32];
		Format(classname, sizeof(classname), "%s", WeaponClassname[random]);
		if (StrEqual(classname, "weapon_gascan", false))
		{
			Format(classname, sizeof(classname), "prop_physics");
			Format(modelname, sizeof(modelname), "%s", MODEL_GASCAN);	
		}
		else if (StrEqual(classname, "weapon_propanetank", false))
		{
			Format(classname, sizeof(classname), "prop_physics");
			Format(modelname, sizeof(modelname), "%s", MODEL_PROPANE);	
		}
		else if (StrEqual(classname, "weapon_oxygentank", false))
		{
			Format(classname, sizeof(classname), "prop_physics");
			Format(modelname, sizeof(modelname), "%s", MODEL_OXYGEN);	
		}
		else if (StrEqual(classname, "weapon_fireworkcrate", false))
		{
			Format(classname, sizeof(classname), "prop_physics");
			Format(modelname, sizeof(modelname), "%s", MODEL_FIREWORKS);	
		}
		new entity = CreateEntityByName(classname);
		if (entity > 0 && IsValidEntity(entity))
		{
			if (StrEqual(classname, "weapon_melee", false))
			{
				new random2 = GetRandomInt(1,11);
				switch(random2)
				{
					case 1:
					{
						DispatchKeyValue(entity, "model", MODEL_V_FIREAXE);
						DispatchKeyValue(entity, "melee_script_name", "fireaxe")
;
					}
					case 2:
					{
						DispatchKeyValue(entity, "model", MODEL_V_FRYING_PAN);
						DispatchKeyValue(entity, "melee_script_name", "frying_pan")
;
					}
					case 3:
					{
						DispatchKeyValue(entity, "model", MODEL_V_MACHETE);
						DispatchKeyValue(entity, "melee_script_name", "machete")
;
					}
					case 4:
					{
						DispatchKeyValue(entity, "model", MODEL_V_BAT);
						DispatchKeyValue(entity, "melee_script_name", "baseball_bat")
;
					}
					case 5:
					{
						DispatchKeyValue(entity, "model", MODEL_V_CROWBAR);
						DispatchKeyValue(entity, "melee_script_name", "crowbar")
;
					}
					case 6:
					{
						DispatchKeyValue(entity, "model", MODEL_V_CRICKET_BAT);
						DispatchKeyValue(entity, "melee_script_name", "cricket_bat")
;
					}
					case 7:
					{
						DispatchKeyValue(entity, "model", MODEL_V_TONFA);
						DispatchKeyValue(entity, "melee_script_name", "tonfa")
;
					}
					case 8:
					{
						DispatchKeyValue(entity, "model", MODEL_V_KATANA);
						DispatchKeyValue(entity, "melee_script_name", "katana")
;
					}
					case 9:
					{
						DispatchKeyValue(entity, "model", MODEL_V_ELECTRIC_GUITAR);
						DispatchKeyValue(entity, "melee_script_name", "electric_guitar")
;
					}
					case 10:
					{
						DispatchKeyValue(entity, "model", MODEL_V_KNIFE);
						DispatchKeyValue(entity, "melee_script_name", "knife")
;
					}
					case 11:
					{
						DispatchKeyValue(entity, "model", MODEL_V_GOLFCLUB);
						DispatchKeyValue(entity, "melee_script_name", "golfclub")
;
					}
				}
			}
			else if (StrEqual(classname, "prop_physics", false))
			{
				DispatchKeyValue(entity, "model", modelname);
			}
			DispatchSpawn(entity);
			ActivateEntity(entity);
			if (StrEqual(classname, "weapon_rifle", false) || StrEqual(classname, "weapon_rifle_sg552", false) || StrEqual(classname, "weapon_rifle_ak47", false) || StrEqual(classname, "weapon_rifle_desert", false))
			{
				SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 360);
			}
			else if (StrEqual(classname, "weapon_smg", false) || StrEqual(classname, "weapon_smg_silenced", false) || StrEqual(classname, "weapon_smg_mp5", false))
			{
				SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 650);
			}		
			else if (StrEqual(classname, "weapon_pumpshotgun", false) || StrEqual(classname, "weapon_shotgun_chrome", false))
			{
				SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 56);
			}
			else if (StrEqual(classname, "weapon_autoshotgun", false) || StrEqual(classname, "weapon_shotgun_spas", false))
			{
				SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 90);
			}
			else if (StrEqual(classname, "weapon_hunting_rifle", false))
			{
				SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 150);
			}
			else if (StrEqual(classname, "weapon_sniper_scout", false) || StrEqual(classname, "weapon_sniper_military", false) || StrEqual(classname, "weapon_sniper_awp", false))
			{
				SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 40);
			}
			else if (!StrEqual(classname, "prop_physics", false))
			{
				SetEntProp(entity, Prop_Send, "m_iExtraPrimaryAmmo", 0);
			}
			Origin[2] += 40.0;
			TeleportEntity(entity, Origin, Angles, NULL_VECTOR);

			new Handle:Pack = CreateDataPack();
			WritePackCell(Pack, iRound);
			WritePackCell(Pack, entity);
			WritePackString(Pack, classname);
			CreateTimer(20.0, RemovePolyMorphItem, Pack);
		}
	}
}
public Action:RemovePolyMorphItem(Handle:timer, any:Pack)
{
	ResetPack(Pack, false);
	new round = ReadPackCell(Pack);
	new entity = ReadPackCell(Pack);
	new String:classname[32];
	ReadPackString(Pack, classname, sizeof(classname));
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (entity > 0 && IsValidEntity(entity))
	{
		decl String:itemclass[32];
		GetEdictClassname(entity, itemclass, sizeof(itemclass));
		if (StrEqual(itemclass, classname, false))
		{
			if (!StrEqual(classname, "prop_physics", false))
			{
				new owner = GetEntPropEnt(entity, Prop_Send, "m_hOwner");
				if (owner <= 0)
				{
					AcceptEntityInput(entity, "Kill");
				}
			}
			else
			{
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
}
stock ForceSpawnInfected(String:classname[], Float:Origin[3], Float:Angles[3])
{
	new entity = CreateEntityByName("info_zombie_spawn");
	if (entity > 0 && IsValidEntity(entity))
	{
		DispatchKeyValue(entity, "population", classname);
		DispatchKeyValueVector(entity, "origin", Origin);
		DispatchKeyValueVector(entity, "angles", Angles)
;
		DispatchSpawn(entity);
		AcceptEntityInput(entity, "SpawnZombie");
		AcceptEntityInput(entity, "Kill");
	}
}
//=============================
// Bombardments
//=============================
stock BombardmentsInAction()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (ArtilleryTimer[i] > 0)
		{
			return ArtilleryTimer[i];
		}
		if (IonCannonTimer[i] > 0)
		{
			return IonCannonTimer[i];
		}
		if (NukeTimer[i] > 0)
		{
			return NukeTimer[i];
		}
	}
	return 0;
}
stock CreateArtyFlare(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl Float:Origin[3], Float:Angles[3];
		GetClientAbsOrigin(client, Origin);
		GetClientAbsAngles(client, Angles);

		// Flare model
		new entity = CreateEntityByName("prop_dynamic");
		SetEntityModel(entity, MODEL_FLARE);
		DispatchSpawn(entity);
		TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
		if (entity > 32)
		{
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", ArtilleryOrigin[client]);
			ArtyFlareEnts[client][1] = entity;
			//sound
			EmitSoundToAll(SOUND_CRACKLE, entity, SNDCHAN_AUTO, SNDLEVEL_DISHWASHER, SND_SHOULDPAUSE, SNDVOL_NORMAL, SNDPITCH_HIGH, -1, NULL_VECTOR, NULL_VECTOR);

			// Light
			entity = CreateEntityByName("point_spotlight");
			DispatchKeyValue(entity, "rendercolor", "200 20 15");
			DispatchKeyValue(entity, "rendermode", "9");
			DispatchKeyValue(entity, "spotlightwidth", "1");
			DispatchKeyValue(entity, "spotlightlength", "3");
			DispatchKeyValue(entity, "renderamt", "255");
			DispatchKeyValue(entity, "spawnflags", "1");
			DispatchSpawn(entity);
			AcceptEntityInput(entity, "TurnOn");
			DispatchKeyValue(entity, "angles", "90 0 0");
			TeleportEntity(entity, Origin, NULL_VECTOR, NULL_VECTOR);
			if (entity > 32)
			{
				ArtyFlareEnts[client][2] = entity;
				// Position particles / smoke
				decl Float:FlareAngle;
				if (FlareAngle == 0.0) 
				{
					FlareAngle = GetRandomFloat(1.0, 360.0);
				}
				Angles[1] = FlareAngle;
				Angles[0] = -80.0;
				Origin[0] += (1.0 * (Cosine(DegToRad(Angles[1]))));
				Origin[1] += (1.5 * (Sine(DegToRad(Angles[1]))));
				Origin[2] += 1.0;

				// Flare particles
				entity = DisplayParticle(PARTICLE_FLARE, Origin, Angles);
				if (entity > 32)
				{
					ArtyFlareEnts[client][3] = entity;
					// Fuse particles
					entity = DisplayParticle(PARTICLE_FUSE, Origin, Angles);
					if (entity > 32)
					{
						ArtyFlareEnts[client][4] = entity;
						//steam
						entity = CreateEntityByName("env_steam");
						DispatchKeyValue(entity, "SpawnFlags", "1");
						DispatchKeyValue(entity, "rendercolor", "200 20 15");
						DispatchKeyValue(entity, "SpreadSpeed", "1");
						DispatchKeyValue(entity, "Speed", "15");
						DispatchKeyValue(entity, "StartSize", "1");
						DispatchKeyValue(entity, "EndSize", "3");
						DispatchKeyValue(entity, "Rate", "10");
						DispatchKeyValue(entity, "JetLength", "100");
						DispatchKeyValue(entity, "renderamt", "60");
						DispatchKeyValue(entity, "InitialState", "1");
						DispatchSpawn(entity);
						AcceptEntityInput(entity, "TurnOn");
						TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
						if (entity > 32)
						{
							ArtyFlareEnts[client][5] = entity;
						}
					}
				}
			}
		}
	}
}
stock FindFloorPos(Float:pos[3])
{
    	FindFloordirection[0] = 89.0; //thats right you'd think its a z value - this will point you down

    	new Handle:FindFloortrace = TR_TraceRayEx(pos, FindFloordirection, MASK_PLAYERSOLID_BRUSHONLY, RayType_Infinite); 
   	if (TR_DidHit(FindFloortrace)) 
    	{ 
        	TR_GetEndPosition(FindFloorfloor, FindFloortrace);
    	}
	CloseHandle(FindFloortrace);

    	FindFloordirection[0] = -89.0; //this will point you up

    	new Handle:FindCeilingtrace = TR_TraceRayEx(pos, FindFloordirection, MASK_PLAYERSOLID_BRUSHONLY, RayType_Infinite); 
   	if (TR_DidHit(FindCeilingtrace)) 
    	{ 
        	TR_GetEndPosition(FindFloorceiling, FindCeilingtrace);
    	}
	CloseHandle(FindCeilingtrace);

    	//I find the height below to prevent players from becoming stuck 
    	if (FindFloorceiling[2] < 0 && FindFloorfloor[2] < 0) 
    	{ 
        	FindFloortotalHeight = FloatAbs(FindFloorceiling[2]) - FloatAbs(FindFloorfloor[2]); 
    	} 
    	else if (FindFloorceiling[2] > 0 && FindFloorfloor[2] > 0) 
    	{ 
        	FindFloortotalHeight = FindFloorceiling[2] - FindFloorfloor[2]; 
    	} 
    	else 
    	{ 
        	FindFloortotalHeight = FloatAbs(FindFloorceiling[2]) + FloatAbs(FindFloorfloor[2]); 
    	}
    	if (FloatAbs(FindFloortotalHeight) > 75.0) 
    	{ 
        	pos[2] = FindFloorfloor[2] + 20; //once again keep those players out of the dirt 
    	}
}
public Action:ExplodeArtillery(Handle:timer, any:client)
{
	if (client > 0 && IsClientInGame(client))
	{
		if (ArtilleryOrigin[client][0] != 0.0 && ArtilleryOrigin[client][1] != 0.0 && ArtilleryOrigin[client][2] != 0.0)
		{
			decl Float:Origin[3];
			Origin[0] = ArtilleryOrigin[client][0];
			Origin[1] = ArtilleryOrigin[client][1];
			Origin[2] = ArtilleryOrigin[client][2];

			new Float:min, Float:max, Float:negmin, Float:negmax;
			new random = GetRandomInt(1,100);
			if (random <= 25 && random > 0)
			{
				min = 10.0;
				max = 250.0;
				negmin = -10.0;
				negmax = -250.0;	
			}
			else if (random <= 50 && random > 25)
			{
				min = 10.0;
				max = 500.0;
				negmin = -10.0;
				negmax = -500.0;	
			}
			else if (random <= 75 && random > 50)
			{
				min = 10.0;
				max = 750.0;
				negmin = -10.0;
				negmax = -750.0;	
			}
			else if (random <= 100 && random > 75)
			{
				min = 10.0;
				max = 1000.0;
				negmin = -10.0;
				negmax = -1000.0;
			}
			if (random > 10)
			{
				new x = GetRandomInt(1,2);
				if (x == 1)
				{
					Origin[0] = Origin[0] += GetRandomFloat(min, max);
				}
				else
				{
					Origin[0] = Origin[0] += GetRandomFloat(negmin, negmax);
				}
				new y = GetRandomInt(1,2);
				if (y == 1)
				{
					Origin[1] = Origin[1] += GetRandomFloat(min, max);
				}
				else
				{
					Origin[1] = Origin[1] += GetRandomFloat(negmin, negmax);
				}
				FindFloorPos(Origin);
				Origin[2] = FindFloorfloor[2];
			}
			PropaneExplode(client, Origin);
			ArtilleryDamage(client, Origin);
		}
	}
}
stock ArtilleryDamage(client, Float:Origin[3])
{
	new entity = -1;
	while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
	{
		new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
		if (ragdoll == 0)
		{
			decl Float:TOrigin[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
			new Float:distance = GetVectorDistance(Origin, TOrigin);
                	if (distance <= 300)
			{
				DealDamageEntity(entity, client, 134217792, 300, "artillery_blast");
			}	
		}
	}
	while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
	{
		new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
		if (ragdoll == 0)
		{
			decl Float:TOrigin[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
			new Float:distance = GetVectorDistance(Origin, TOrigin);
                	if (distance <= 300)
			{
				DealDamageEntity(entity, client, 134217792, 300, "artillery_blast");
			}
		}
	}
	while ((entity = FindEntityByClassname(entity, "player")) != INVALID_ENT_REFERENCE)
	{
		if (IsClientInGame(entity) && IsPlayerAlive(entity) && !IsPlayerGhost(entity) && GetClientTeam(entity) == 3)
		{
			decl Float:TOrigin[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
			new Float:distance = GetVectorDistance(Origin, TOrigin);
                	if (distance <= 300)
			{
				DealDamagePlayer(entity, client, 134217792, 300, "artillery_blast");
			}
		}
	}
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) && IsPlayerAlive(i) && (GetClientTeam(i) == 2 || !IsPlayerGhost(i) && GetClientTeam(i) == 3))
		{
			decl Float:TOrigin[3];
			GetEntPropVector(i, Prop_Send, "m_vecOrigin", TOrigin);
                	new Float:distance = GetVectorDistance(Origin, TOrigin);
			if (distance <= 300)
			{
				ScreenShake(i, 1.0);
			}
		}
	}
}
public Action:TimerArtillerySound(Handle:timer, any:client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new entity = ArtyFlareEnts[client][1];
		if (entity > 32 && IsValidEntity(entity))
		{
			EmitSoundToAll(SOUND_ARTILLERY, entity);
		}
	}
}
stock StartArtillery(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		GetClientAuthId(client, AuthId_Steam2, DisconnectPlayer[client], 24);
		DisconnectPlayerAmmo[client][0] = 1;
		ArtilleryAmmo[client] = 1;
		ArtilleryTimer[client] = 20;
		CreateArtyFlare(client);
		CreateTimer(4.0, TimerArtillerySound, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}
stock UpdateArtillery(client)
{
	new timer = ArtilleryTimer[client];
	if (client > 0 && IsClientInGame(client))
	{
		if (timer >= 0 && !bNightmare)
		{
			if (ArtilleryOrigin[client][0] != 0.0 && ArtilleryOrigin[client][1] != 0.0 && ArtilleryOrigin[client][2] != 0.0)
			{
				if (timer <= 15)
				{
					CreateTimer(0.1, ExplodeArtillery, client, TIMER_FLAG_NO_MAPCHANGE);
				}
				if (timer <= 14)
				{
					CreateTimer(0.6, ExplodeArtillery, client, TIMER_FLAG_NO_MAPCHANGE);
				}
				if (timer <= 13)
				{
					CreateTimer(0.3, ExplodeArtillery, client, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(0.9, ExplodeArtillery, client, TIMER_FLAG_NO_MAPCHANGE);
				}
				if (timer <= 12)
				{
					new random = GetRandomInt(1,10);
					if (random > 7)
					{
						CreateTimer(0.5, ExplodeArtillery, client, TIMER_FLAG_NO_MAPCHANGE);
					}
					if (random > 4)
					{
						CreateTimer(0.7, ExplodeArtillery, client, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}
	ArtilleryTimer[client] -= 1;
	if (ArtilleryTimer[client] == 0)
	{
		DestroyArtillery(client);
	}
}
stock DestroyArtillery(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new entity = ArtyFlareEnts[client][1];
		if (entity > 32 && IsValidEntity(entity))
		{
			StopSound(entity, SNDCHAN_AUTO, SOUND_CRACKLE);
			AcceptEntityInput(entity, "Kill");
			ArtyFlareEnts[client][1] = 0;
		}
		entity = ArtyFlareEnts[client][2];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "LightOff");
			AcceptEntityInput(entity, "Kill");
			ArtyFlareEnts[client][2] = 0;
		}
		entity = ArtyFlareEnts[client][3];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "Kill");
			ArtyFlareEnts[client][3] = 0;
		}
		entity = ArtyFlareEnts[client][4];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "Kill");
			ArtyFlareEnts[client][4] = 0;
		}
		entity = ArtyFlareEnts[client][5];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "TurnOff");
			SetVariantString("OnUser1 !self:Kill::10.0:-1");
			AcceptEntityInput(entity, "AddOutput");
			AcceptEntityInput(entity, "FireUser1");
			ArtyFlareEnts[client][5] = 0;
		}
		ArtilleryOrigin[client][0] = 0.0;
		ArtilleryOrigin[client][1] = 0.0;
		ArtilleryOrigin[client][2] = 0.0;
	}
}
stock CreateIonFlare(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl Float:Origin[3], Float:Angles[3];
		GetClientAbsOrigin(client, Origin);
		GetClientAbsAngles(client, Angles);

		// Flare model
		new entity = CreateEntityByName("prop_dynamic");
		SetEntityModel(entity, MODEL_FLARE);
		DispatchSpawn(entity);
		TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
		if (entity > 32)
		{
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", IonCannonOrigin[client]);
			IonFlareEnts[client][1] = entity;
			//sound
			EmitSoundToAll(SOUND_CRACKLE, entity, SNDCHAN_AUTO, SNDLEVEL_DISHWASHER, SND_SHOULDPAUSE, SNDVOL_NORMAL, SNDPITCH_HIGH, -1, NULL_VECTOR, NULL_VECTOR);

			// Light
			entity = CreateEntityByName("point_spotlight");
			DispatchKeyValue(entity, "rendercolor", "200 20 15");
			DispatchKeyValue(entity, "rendermode", "9");
			DispatchKeyValue(entity, "spotlightwidth", "1");
			DispatchKeyValue(entity, "spotlightlength", "3");
			DispatchKeyValue(entity, "renderamt", "255");
			DispatchKeyValue(entity, "spawnflags", "1");
			DispatchSpawn(entity);
			AcceptEntityInput(entity, "TurnOn");
			DispatchKeyValue(entity, "angles", "90 0 0");
			TeleportEntity(entity, Origin, NULL_VECTOR, NULL_VECTOR);
			if (entity > 32)
			{
				IonFlareEnts[client][2] = entity;
				// Position particles / smoke
				decl Float:FlareAngle;
				if (FlareAngle == 0.0) 
				{
					FlareAngle = GetRandomFloat(1.0, 360.0);
				}
				Angles[1] = FlareAngle;
				Angles[0] = -80.0;
				Origin[0] += (1.0 * (Cosine(DegToRad(Angles[1]))));
				Origin[1] += (1.5 * (Sine(DegToRad(Angles[1]))));
				Origin[2] += 1.0;

				// Flare particles
				entity = DisplayParticle(PARTICLE_FLARE, Origin, Angles);
				if (entity > 32)
				{
					IonFlareEnts[client][3] = entity;
					// Fuse particles
					entity = DisplayParticle(PARTICLE_FUSE, Origin, Angles);
					if (entity > 32)
					{
						IonFlareEnts[client][4] = entity;
						//steam
						entity = CreateEntityByName("env_steam");
						DispatchKeyValue(entity, "SpawnFlags", "1");
						DispatchKeyValue(entity, "rendercolor", "200 20 15");
						DispatchKeyValue(entity, "SpreadSpeed", "1");
						DispatchKeyValue(entity, "Speed", "15");
						DispatchKeyValue(entity, "StartSize", "1");
						DispatchKeyValue(entity, "EndSize", "3");
						DispatchKeyValue(entity, "Rate", "10");
						DispatchKeyValue(entity, "JetLength", "100");
						DispatchKeyValue(entity, "renderamt", "60");
						DispatchKeyValue(entity, "InitialState", "1");
						DispatchSpawn(entity);
						AcceptEntityInput(entity, "TurnOn");
						TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
						if (entity > 32)
						{
							IonFlareEnts[client][5] = entity;
						}
					}
				}
			}
		}
	}
}
stock SmashIonFlare(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new entity = IonFlareEnts[client][1];
		if (entity > 32 && IsValidEntity(entity))
		{
			StopSound(entity, SNDCHAN_AUTO, SOUND_CRACKLE);
			SetEntityRenderMode(entity, RenderMode:3);
      	 		SetEntityRenderColor(entity, 100, 100, 100, 0);
			EmitSoundToAll(SOUND_IONCANNON, entity, SNDCHAN_AUTO, SNDLEVEL_HELICOPTER, SND_SHOULDPAUSE, SNDVOL_NORMAL, 100, -1, NULL_VECTOR, NULL_VECTOR);
		}
		entity = IonFlareEnts[client][2];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "LightOff");
			AcceptEntityInput(entity, "Kill");
			IonFlareEnts[client][2] = 0;
		}
		entity = IonFlareEnts[client][3];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "Kill");
			IonFlareEnts[client][3] = 0;
		}
		entity = IonFlareEnts[client][4];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "Kill");
			IonFlareEnts[client][4] = 0;
		}
		entity = IonFlareEnts[client][5];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "TurnOff");
			SetVariantString("OnUser1 !self:Kill::10.0:-1");
			AcceptEntityInput(entity, "AddOutput");
			AcceptEntityInput(entity, "FireUser1");
			IonFlareEnts[client][5] = 0;
		}
	}
}
stock DestroyIonFlare(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new entity = IonFlareEnts[client][1];
		if (entity > 32 && IsValidEntity(entity))
		{
			StopSound(entity, SNDCHAN_AUTO, SOUND_IONCANNON);
			AcceptEntityInput(entity, "Kill");
			IonFlareEnts[client][1] = 0;
		}
		IonCannonOrigin[client][0] = 0.0;
		IonCannonOrigin[client][1] = 0.0;
		IonCannonOrigin[client][2] = 0.0;
	}
}
stock UpdateIonCannon(client)
{
	IonCannonTimer[client] -= 1;
	if (IonCannonTimer[client] == 0)
	{
		DestroyIonFlare(client);
	}
}
stock StartIonCannon(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		CreateTimer(5.0, Timer_StartIonCannon, client, TIMER_FLAG_NO_MAPCHANGE);

		GetClientAuthId(client, AuthId_Steam2, DisconnectPlayer[client], 24);
		DisconnectPlayerAmmo[client][1] = 1;
		IonCannonAmmo[client] = 1;
		IonCannonTimer[client] = 20;
		CreateIonFlare(client);
	}
}
public Action:Timer_StartIonCannon(Handle:timer, any:client)
{
	// 1st
	IonBeamOrigin[client][0][0] = IonCannonOrigin[client][0] + 200.0;
	IonBeamOrigin[client][0][1] = IonCannonOrigin[client][1] + 150.0;
	IonBeamOrigin[client][0][2] = IonCannonOrigin[client][2];
	IonBeamDegrees[client][0] = 0.0;
	
	// 2nd
	IonBeamOrigin[client][1][0] = IonCannonOrigin[client][0] + 200.0;
	IonBeamOrigin[client][1][1] = IonCannonOrigin[client][1] - 150.0;
	IonBeamOrigin[client][1][2] = IonCannonOrigin[client][2];
	IonBeamDegrees[client][1] = 45.0;
	
	// 3rd
	IonBeamOrigin[client][2][0] = IonCannonOrigin[client][0] - 200.0;
	IonBeamOrigin[client][2][1] = IonCannonOrigin[client][1] - 150.0;
	IonBeamOrigin[client][2][2] = IonCannonOrigin[client][2];
	IonBeamDegrees[client][2] = 90.0;
	
	// 4th
	IonBeamOrigin[client][3][0] = IonCannonOrigin[client][0] - 200.0;
	IonBeamOrigin[client][3][1] = IonCannonOrigin[client][1] + 150.0;
	IonBeamOrigin[client][3][2] = IonCannonOrigin[client][2];
	IonBeamDegrees[client][3] = 135.0;
	
	// 5th
	IonBeamOrigin[client][4][0] = IonCannonOrigin[client][0] + 150.0;
	IonBeamOrigin[client][4][1] = IonCannonOrigin[client][1] + 200.0;
	IonBeamOrigin[client][4][2] = IonCannonOrigin[client][2];
	IonBeamDegrees[client][4] = 180.0;
	
	// 6th
	IonBeamOrigin[client][5][0] = IonCannonOrigin[client][0] + 150.0;
	IonBeamOrigin[client][5][1] = IonCannonOrigin[client][1] - 200.0;
	IonBeamOrigin[client][5][2] = IonCannonOrigin[client][2];
	IonBeamDegrees[client][5] = 225.0;

	FindFloorPos(IonCannonOrigin[client]);
	
	new Float:SkyOrigin[3];
	SkyOrigin[0] = FindFloorceiling[0];
	SkyOrigin[1] = FindFloorceiling[1];
	SkyOrigin[2] = FindFloorceiling[2];
	
	new Float:fTime = 0.0;
	new Handle:hDataPack[6];
	for(new i=0; i<6; i++)
	{
		fTime += 0.3;
		hDataPack[i] = CreateDataPack();
		WritePackCell(hDataPack[i], iRound);
		WritePackCell(hDataPack[i], i);
		WritePackCell(hDataPack[i], client);
		WritePackFloat(hDataPack[i], SkyOrigin[2]);
		ResetPack(hDataPack[i]);
		CreateTimer(fTime, Timer_CreateIonBeam, hDataPack[i]);
	}
	CreateTimer(2.4, Timer_CreateIonRing, client, TIMER_FLAG_NO_MAPCHANGE);
	new Handle:Pack = CreateDataPack();
	WritePackCell(Pack, iRound);
	WritePackCell(Pack, client);
	WritePackFloat(Pack, SkyOrigin[0]);
	WritePackFloat(Pack, SkyOrigin[1]);
	WritePackFloat(Pack, SkyOrigin[2]);
	ResetPack(Pack);
	CreateTimer(3.0, Timer_CreateIonBlast, Pack);
}
public Action:Timer_CreateIonBeam(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new i = ReadPackCell(data);
	new client = ReadPackCell(data);
	new Float:SkyOrigin = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return Plugin_Stop;
	}

	if (IonCannonTimer[client] > 0 && !bNightmare)
	{
		new Float:fRandomZ = (GetURandomFloat() * (SkyOrigin  - 300.0)) + 300.0;
		//new Float:fRandomZ = Math_GetRandomFloat(300.0, SkyOrigin);
	
		new Float:fBeamOrigin[3];
		fBeamOrigin[0] = IonBeamOrigin[client][i][0];
		fBeamOrigin[1] = IonBeamOrigin[client][i][1];
		fBeamOrigin[2] = IonBeamOrigin[client][i][2] + fRandomZ;
	
		new Handle:hDataPack = CreateDataPack();
		WritePackCell(hDataPack, round);
		WritePackCell(hDataPack, i);
		WritePackCell(hDataPack, client);
		WritePackFloat(hDataPack, SkyOrigin);
		ResetPack(hDataPack);
		ShowBeam(hDataPack);
	}
	return Plugin_Stop;
}

stock ShowBeam(Handle:data)
{
	new round = ReadPackCell(data);
	new i = ReadPackCell(data);
	new client = ReadPackCell(data);
	new Float:SkyOrigin = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (IonCannonTimer[client] > 0 && !bNightmare)
	{
		new Float:fStart[3];
		fStart[0] = IonBeamOrigin[client][i][0];
		fStart[1] = IonBeamOrigin[client][i][1];
		fStart[2] = SkyOrigin;
	
		TE_SetupBeamPoints(fStart, IonBeamOrigin[client][i], IonBeamSprite, IonHaloSprite, 0, 0, 0.08, 25.0, 25.0, 0, 0.0, {160, 145, 255, 155}, 20);
		TE_SendToAll();
	
		new Handle:hDataPack = CreateDataPack();
		WritePackCell(hDataPack, round);
		WritePackCell(hDataPack, i);
		WritePackCell(hDataPack, client);
		WritePackFloat(hDataPack, SkyOrigin);
		ResetPack(hDataPack);
		CreateTimer(0.1, Timer_OnShowBeam, hDataPack);
	}
}

public Action:Timer_OnShowBeam(Handle:timer, any:data)
{
	ShowBeam(data);
}
public Action:Timer_OnLaserRotate(Handle:timer, any:client)
{
	if (IonCannonTimer[client] > 0 && !bNightmare)
	{
		new Float:BeamDistance = 250.0;
		for (new i=0; i<6; i++)
		{
			IonBeamDegrees[client][i] += 0.1; //g_fBeamRotationSpeed[client]
			if(IonBeamDegrees[client][i] > 360.0)
			{
				IonBeamDegrees[client][i] -= 360.0;
			}
		
			// Calculate the next origin
			IonBeamOrigin[client][i][0] = IonCannonOrigin[client][0] + Sine(IonBeamDegrees[client][i]) * BeamDistance;
			IonBeamOrigin[client][i][1] = IonCannonOrigin[client][1] + Cosine(IonBeamDegrees[client][i]) * BeamDistance;
			IonBeamOrigin[client][i][2] = IonCannonOrigin[client][2] + 0.0;
		}
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:Timer_CreateIonRing(Handle:timer, any:client)
{
	new Float:fBeamHigh[3];
	fBeamHigh[0] = IonCannonOrigin[client][0];
	fBeamHigh[1] = IonCannonOrigin[client][1];
	fBeamHigh[2] = IonCannonOrigin[client][2]+20.0;

	CreateTimer(0.1, Timer_OnLaserRotate, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.5, Timer_IonRing, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}
public Action:Timer_IonRing(Handle:timer, any:client)
{
	if (IonCannonTimer[client] > 0 && !bNightmare)
	{
		new Float:fBeamHigh[3];
		fBeamHigh[0] = IonCannonOrigin[client][0];
		fBeamHigh[1] = IonCannonOrigin[client][1];
		fBeamHigh[2] = IonCannonOrigin[client][2]+20.0;

		TE_SetupBeamRingPoint(fBeamHigh, 450.0, 600.0, IonBeamSprite, IonHaloSprite, 0, 30, 0.5, 30.0, 2.0, {160, 145, 255, 155}, 0, 0);
		TE_SetupBeamRingPoint(fBeamHigh, 450.0, 600.0, IonBeamSprite, IonHaloSprite, 0, 30, 0.5, 30.0, 2.0, {160, 145, 255, 155}, 10, 0);
		TE_SetupBeamRingPoint(fBeamHigh, 450.0, 600.0, IonBeamSprite, IonHaloSprite, 0, 30, 0.5, 30.0, 2.0, {160, 145, 255, 155}, 20, 0);
		TE_SetupBeamRingPoint(fBeamHigh, 450.0, 600.0, IonBeamSprite, IonHaloSprite, 0, 30, 0.5, 30.0, 2.0, {160, 145, 255, 155}, 30, 0);
		TE_SendToAll();	

		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:Timer_CreateIonBlast(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	decl Float:SkyOrigin[3];
	SkyOrigin[0] = ReadPackFloat(data);
	SkyOrigin[1] = ReadPackFloat(data);
	SkyOrigin[2] = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	SmashIonFlare(client);

	TE_SetupBeamPoints(SkyOrigin, IonCannonOrigin[client], IonBeamSprite, IonHaloSprite, 0, 10, 10.0, 400.0, 450.0, 10, 4.0, {160, 145, 255, 155}, 0);
	TE_SetupBeamPoints(SkyOrigin, IonCannonOrigin[client], IonBeamSprite, IonHaloSprite, 0, 10, 10.0, 400.0, 450.0, 10, 4.0, {160, 145, 255, 155}, 0);
	TE_SendToAll();
	
	TE_SetupBeamPoints(SkyOrigin, IonCannonOrigin[client], IonBeamSprite, IonHaloSprite, 0, 30, 10.0, 450.0, 550.0, 10, 5.0, {160, 145, 255, 155}, 20);
	TE_SetupBeamPoints(SkyOrigin, IonCannonOrigin[client], IonBeamSprite, IonHaloSprite, 0, 30, 10.0, 450.0, 550.0, 10, 5.0, {160, 145, 255, 155}, 20);
	TE_SendToAll();

	CreateTimer(0.3, Timer_IonEffects, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	new Handle:Pack = CreateDataPack();
	WritePackCell(Pack, round);
	WritePackCell(Pack, client);
	WritePackFloat(Pack, SkyOrigin[0]);
	WritePackFloat(Pack, SkyOrigin[1]);
	WritePackFloat(Pack, SkyOrigin[2]);
	ResetPack(Pack);
	CreateTimer(0.5, Timer_IonCenterBeam, Pack);
	CreateTimer(6.0, Timer_IonFire, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	new Float:fBeamHigh[3];
	fBeamHigh[0] = IonCannonOrigin[client][0];
	fBeamHigh[1] = IonCannonOrigin[client][1];
	fBeamHigh[2] = IonCannonOrigin[client][2]+20.0;

	for(new i=0;i<=300;i+=30)
	{
		TE_SetupBeamRingPoint(fBeamHigh, 0.0, 2000.0, IonBeamSprite, IonHaloSprite, 0, 30, 10.0, 75.0, 5.0, {160, 145, 255, 155}, 300-i, 0);
		TE_SendToAll();
	}
	GasCanExplode(client, IonCannonOrigin[client]);
	PropaneExplode(client, IonCannonOrigin[client]);
}
public Action:Timer_IonFire(Handle:timer, any:client)
{
	if (IonCannonTimer[client] > 0 && !bNightmare)
	{
		GasCanExplode(client, IonCannonOrigin[client]);
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
public Action:Timer_IonCenterBeam(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	decl Float:SkyOrigin[3];
	SkyOrigin[0] = ReadPackFloat(data);
	SkyOrigin[1] = ReadPackFloat(data);
	SkyOrigin[2] = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (IonCannonTimer[client] > 0 && !bNightmare)
	{
		TE_SetupBeamPoints(SkyOrigin, IonCannonOrigin[client], IonBeamSprite, IonHaloSprite, 0, 10, 0.5, 400.0, 450.0, 10, 4.0, {160, 145, 255, 155}, 75);
		TE_SetupBeamPoints(SkyOrigin, IonCannonOrigin[client], IonBeamSprite, IonHaloSprite, 0, 10, 0.5, 400.0, 450.0, 10, 4.0, {160, 145, 255, 155}, 75);
		TE_SendToAll();
	
		TE_SetupBeamPoints(SkyOrigin, IonCannonOrigin[client], IonBeamSprite, IonHaloSprite, 0, 30, 0.5, 450.0, 550.0, 10, 5.0, {160, 145, 255, 155}, 100);
		TE_SetupBeamPoints(SkyOrigin, IonCannonOrigin[client], IonBeamSprite, IonHaloSprite, 0, 30, 0.5, 450.0, 550.0, 10, 5.0, {160, 145, 255, 155}, 100);
		TE_SendToAll();

		new Handle:hDataPack = CreateDataPack();
		WritePackCell(hDataPack, round);
		WritePackCell(hDataPack, client);
		WritePackFloat(hDataPack, SkyOrigin[0]);
		WritePackFloat(hDataPack, SkyOrigin[1]);
		WritePackFloat(hDataPack, SkyOrigin[2]);
		ResetPack(hDataPack);
		CreateTimer(0.5, Timer_IonCenterBeam, hDataPack);
	}
}
public Action:Timer_IonEffects(Handle:timer, any:client)
{
	if (IonCannonTimer[client] > 0 && !bNightmare)
	{
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
		{
			new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				DealDamageEntity(entity, client, 10, 200, "ion_cannon");
			}
		}
		while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
		{
			new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				DealDamageEntity(entity, client, 10, 200, "ion_cannon");
			}
		}
		while ((entity = FindEntityByClassname(entity, "player")) != INVALID_ENT_REFERENCE)
		{
			if (IsClientInGame(entity) && IsPlayerAlive(entity) && !IsPlayerGhost(entity) && GetClientTeam(entity) == 3)
			{
				DealDamagePlayer(entity, client, 10, 200, "ion_cannon");
			}
		}
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && IsPlayerAlive(i) && (GetClientTeam(i) == 2 || !IsPlayerGhost(i) && GetClientTeam(i) == 3))
			{
				decl Float:Origin[3];
				GetEntPropVector(i, Prop_Send, "m_vecOrigin", Origin);
                		new Float:distance = GetVectorDistance(IonCannonOrigin[client], Origin);
				if (distance <= 1000)
				{
					ScreenShake(i, 5.0);
				}
				else if (distance <= 2000)
				{
					ScreenShake(i, 3.0);
				}
				else if (distance <= 3000)
				{
					ScreenShake(i, 1.0);
				}
			}
		}
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
stock StartNuke(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		CreateTimer(5.0, Timer_StartNuke, client, TIMER_FLAG_NO_MAPCHANGE);

		GetClientAuthId(client, AuthId_Steam2, DisconnectPlayer[client], 24);
		DisconnectPlayerAmmo[client][2] = 1;
		NukeAmmo[client] = 1;
		NukeTimer[client] = 20;
		CreateNukeFlare(client);
	}
}
stock CreateNukeFlare(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl Float:Origin[3], Float:Angles[3];
		GetClientAbsOrigin(client, Origin);
		GetClientAbsAngles(client, Angles);

		// Flare model
		new entity = CreateEntityByName("prop_dynamic");
		SetEntityModel(entity, MODEL_FLARE);
		DispatchSpawn(entity);
		TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
		if (entity > 32)
		{
			NukeFlareEnts[client][1] = entity;
			//sound
			EmitSoundToAll(SOUND_CRACKLE, entity, SNDCHAN_AUTO, SNDLEVEL_DISHWASHER, SND_SHOULDPAUSE, SNDVOL_NORMAL, SNDPITCH_HIGH, -1, NULL_VECTOR, NULL_VECTOR);

			// Light
			entity = CreateEntityByName("point_spotlight");
			DispatchKeyValue(entity, "rendercolor", "200 20 15");
			DispatchKeyValue(entity, "rendermode", "9");
			DispatchKeyValue(entity, "spotlightwidth", "1");
			DispatchKeyValue(entity, "spotlightlength", "3");
			DispatchKeyValue(entity, "renderamt", "255");
			DispatchKeyValue(entity, "spawnflags", "1");
			DispatchSpawn(entity);
			AcceptEntityInput(entity, "TurnOn");
			DispatchKeyValue(entity, "angles", "90 0 0");
			TeleportEntity(entity, Origin, NULL_VECTOR, NULL_VECTOR);
			if (entity > 32)
			{
				NukeFlareEnts[client][2] = entity;
				// Position particles / smoke
				decl Float:FlareAngle;
				if (FlareAngle == 0.0) 
				{
					FlareAngle = GetRandomFloat(1.0, 360.0);
				}
				Angles[1] = FlareAngle;
				Angles[0] = -80.0;
				Origin[0] += (1.0 * (Cosine(DegToRad(Angles[1]))));
				Origin[1] += (1.5 * (Sine(DegToRad(Angles[1]))));
				Origin[2] += 1.0;

				// Flare particles
				entity = DisplayParticle(PARTICLE_FLARE, Origin, Angles);
				if (entity > 32)
				{
					NukeFlareEnts[client][3] = entity;
					// Fuse particles
					entity = DisplayParticle(PARTICLE_FUSE, Origin, Angles);
					if (entity > 32)
					{
						NukeFlareEnts[client][4] = entity;
						//steam
						entity = CreateEntityByName("env_steam");
						DispatchKeyValue(entity, "SpawnFlags", "1");
						DispatchKeyValue(entity, "rendercolor", "200 20 15");
						DispatchKeyValue(entity, "SpreadSpeed", "1");
						DispatchKeyValue(entity, "Speed", "15");
						DispatchKeyValue(entity, "StartSize", "1");
						DispatchKeyValue(entity, "EndSize", "3");
						DispatchKeyValue(entity, "Rate", "10");
						DispatchKeyValue(entity, "JetLength", "100");
						DispatchKeyValue(entity, "renderamt", "60");
						DispatchKeyValue(entity, "InitialState", "1");
						DispatchSpawn(entity);
						AcceptEntityInput(entity, "TurnOn");
						TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
						if (entity > 32)
						{
							NukeFlareEnts[client][5] = entity;
						}
					}
				}
			}
		}
	}
}
stock SmashNukeFlare(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new entity = NukeFlareEnts[client][1];
		if (entity > 32 && IsValidEntity(entity))
		{
			StopSound(entity, SNDCHAN_AUTO, SOUND_CRACKLE);
			SetEntityRenderMode(entity, RenderMode:3);
      	 		SetEntityRenderColor(entity, 100, 100, 100, 0);
			EmitSoundToAll(SOUND_NUKEEXPLODE, entity, SNDCHAN_AUTO, SNDLEVEL_GUNFIRE, SND_SHOULDPAUSE, SNDVOL_NORMAL, 100, -1, NULL_VECTOR, NULL_VECTOR);
			//EmitSoundToAll(SOUND_NUKERUMBLE, entity, SNDCHAN_AUTO, SNDLEVEL_GUNFIRE, SND_SHOULDPAUSE, SNDVOL_NORMAL, 100, -1, NULL_VECTOR, NULL_VECTOR);
		}
		entity = NukeFlareEnts[client][2];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "LightOff");
			AcceptEntityInput(entity, "Kill");
			NukeFlareEnts[client][2] = 0;
		}
		entity = NukeFlareEnts[client][3];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "Kill");
			NukeFlareEnts[client][3] = 0;
		}
		entity = NukeFlareEnts[client][4];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "Kill");
			NukeFlareEnts[client][4] = 0;
		}
		entity = NukeFlareEnts[client][5];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "TurnOff");
			SetVariantString("OnUser1 !self:Kill::10.0:-1");
			AcceptEntityInput(entity, "AddOutput");
			AcceptEntityInput(entity, "FireUser1");
			NukeFlareEnts[client][5] = 0;
		}
	}
}
stock DestroyNukeFlare(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new entity = NukeFlareEnts[client][1];
		if (entity > 32 && IsValidEntity(entity))
		{
			AcceptEntityInput(entity, "Kill");
			NukeFlareEnts[client][1] = 0;
		}
	}
}
stock UpdateNuke(client)
{
	NukeTimer[client] -= 1;
	new timer = NukeTimer[client];
	if (timer == 0)
	{
		DestroyNukeFlare(client);
	}
	else if (timer == 18)
	{
		FakeClientCommand(client, "say_team 4...");
	}
	else if (timer == 17)
	{
		FakeClientCommand(client, "say_team 3...");
	}
	else if (timer == 16)
	{
		FakeClientCommand(client, "say_team 2...");
	}
	else if (timer == 15)
	{
		FakeClientCommand(client, "say_team 1...");
	}
}
public Action:Timer_StartNuke(Handle:timer, any:client)
{
	new entity = NukeFlareEnts[client][1];
	if (entity > 32 && IsValidEntity(entity))
	{
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				PerformFade(i, 1000, 500, 10, 1, {255, 255, 255, 235});
			}
		}
		new Float:Origin[3];
		GetEntPropVector(entity, Prop_Data, "m_vecOrigin", Origin);
		FindFloorPos(Origin);
	
		new Float:SkyOrigin = FindFloorceiling[2];
		new Float:Subtraction = SkyOrigin - Origin[2];

		SmashNukeFlare(client);
		AttachParticle(entity, PARTICLE_NUKEHIT, 3.0, 0.0, 0.0, 0.0);

		new Handle:WavePack = CreateDataPack();
		WritePackCell(WavePack, iRound);
		WritePackCell(WavePack, client);
		WritePackCell(WavePack, entity);
		ResetPack(WavePack);
		CreateTimer(0.1, Timer_NukeWave, WavePack);

		new Handle:SmokePack = CreateDataPack();
		WritePackCell(SmokePack, iRound);
		WritePackCell(SmokePack, client);
		WritePackCell(SmokePack, entity);
		WritePackFloat(SmokePack, Subtraction);
		ResetPack(SmokePack);
		CreateTimer(0.1, Timer_NukeSmoke, SmokePack);

		new Handle:FireAPack = CreateDataPack();
		WritePackCell(FireAPack, iRound);
		WritePackCell(FireAPack, client);
		WritePackCell(FireAPack, entity);
		WritePackFloat(FireAPack, Subtraction);
		ResetPack(FireAPack);
		CreateTimer(0.1, Timer_NukeFireA, FireAPack);

		new Handle:FireBPack = CreateDataPack();
		WritePackCell(FireBPack, iRound);
		WritePackCell(FireBPack, client);
		WritePackCell(FireBPack, entity);
		WritePackFloat(FireBPack, Subtraction);
		ResetPack(FireBPack);
		CreateTimer(0.2, Timer_NukeFireB, FireBPack);

		new Handle:FireCPack = CreateDataPack();
		WritePackCell(FireCPack, iRound);
		WritePackCell(FireCPack, client);
		WritePackCell(FireCPack, entity);
		WritePackFloat(FireCPack, Subtraction);
		ResetPack(FireCPack);
		CreateTimer(0.3, Timer_NukeFireC, FireCPack);

		new Handle:DebrisPack = CreateDataPack();
		WritePackCell(DebrisPack, iRound);
		WritePackCell(DebrisPack, client);
		WritePackCell(DebrisPack, entity);
		WritePackFloat(DebrisPack, Origin[2]);
		WritePackFloat(DebrisPack, SkyOrigin);
		ResetPack(DebrisPack);
		CreateTimer(0.5, Timer_NukeDebris, DebrisPack);

		CreateTimer(0.3, Timer_NukeEffects, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		GasCanExplode(client, Origin);
	}
}
public Action:Timer_NukeWave(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	new entity = ReadPackCell(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			AttachParticle(entity, PARTICLE_NUKEWAVE, 0.2, 0.0, 0.0, 0.0);
			new Handle:WavePack = CreateDataPack();
			WritePackCell(WavePack, round);
			WritePackCell(WavePack, client);
			WritePackCell(WavePack, entity);
			ResetPack(WavePack);
			CreateTimer(0.2, Timer_NukeWave, WavePack);
		}
	}
}
public Action:Timer_NukeDebris(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	new entity = ReadPackCell(data);
	new Float:GroundOrigin = ReadPackFloat(data);
	new Float:SkyOrigin = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			new Float:Origin[3], Float:RandomLocation[3];
			GetEntPropVector(entity, Prop_Data, "m_vecOrigin", Origin);
			if (GetRandomInt(1,3) == 1)
			{
				if (GetRandomInt(1,2) == 1)
				{
					AttachParticle(entity, PARTICLE_NUKEDEBRISA, 2.0, GetRandomFloat(-15.0, 15.0), GetRandomFloat(-15.0, 15.0), 0.0);
				}
				else
				{
					new Float:Angles[3];
					GetEntPropVector(entity, Prop_Data, "m_angRotation", Angles);
					Angles[1] = GetRandomFloat(0.0, 360.0);
					TeleportEntity(entity, NULL_VECTOR, Angles, NULL_VECTOR);
					AttachParticle(entity, PARTICLE_NUKEDEBRISB, 2.0, GetRandomFloat(-15.0, 15.0), GetRandomFloat(-15.0, 15.0), 0.0);
				}
				GasCanExplode(client, Origin);
				RandomLocation[0] = GetRandomFloat(Origin[0] - 25.0, Origin[0] + 25.0);
				RandomLocation[1] = GetRandomFloat(Origin[1] - 25.0, Origin[1] + 25.0);
				RandomLocation[2] = GetRandomFloat(GroundOrigin, SkyOrigin);
				PropaneExplode(client, RandomLocation);
			}
			else
			{
				RandomLocation[0] = GetRandomFloat(Origin[0] - 25.0, Origin[0] + 25.0);
				RandomLocation[1] = GetRandomFloat(Origin[1] - 25.0, Origin[1] + 25.0);
				RandomLocation[2] = GetRandomFloat(GroundOrigin, SkyOrigin);
				PropaneExplode(client, RandomLocation);
				RandomLocation[0] = GetRandomFloat(Origin[0] - 25.0, Origin[0] + 25.0);
				RandomLocation[1] = GetRandomFloat(Origin[1] - 25.0, Origin[1] + 25.0);
				RandomLocation[2] = GetRandomFloat(GroundOrigin, SkyOrigin);
				new Handle:PropanePack = CreateDataPack();
				WritePackCell(PropanePack, round);
				WritePackCell(PropanePack, client);
				WritePackFloat(PropanePack, RandomLocation[0]);
				WritePackFloat(PropanePack, RandomLocation[1]);
				WritePackFloat(PropanePack, RandomLocation[2]);
				ResetPack(PropanePack);
				CreateTimer(1.0, Timer_PropaneExplode, PropanePack);
			}
			new Handle:DebrisPack = CreateDataPack();
			WritePackCell(DebrisPack, round);
			WritePackCell(DebrisPack, client);
			WritePackCell(DebrisPack, entity);
			WritePackFloat(DebrisPack, GroundOrigin);
			WritePackFloat(DebrisPack, SkyOrigin);
			ResetPack(DebrisPack);
			CreateTimer(2.0, Timer_NukeDebris, DebrisPack);
		}
	}
}
public Action:Timer_NukeSmoke(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	new entity = ReadPackCell(data);
	new Float:Subtraction = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			AttachParticle(entity, PARTICLE_NUKESMOKEA, 0.5, 0.0, 0.0, Subtraction);
			if (GetRandomInt(1,2) == 1)
			{
				AttachParticle(entity, PARTICLE_NUKESMOKEB, 0.5, 0.0, 0.0, Subtraction);
			}
			for (new i=1; i<=6; i++)
			{
				if (i == 1)
				{
					AttachParticle(entity, PARTICLE_NUKESMOKEA, 0.5, 500.0, 250.0, Subtraction);
				}
				else if (i == 2)
				{
					AttachParticle(entity, PARTICLE_NUKESMOKEA, 0.5, 500.0, -250.0, Subtraction);
				}
				else if (i == 3)
				{
					AttachParticle(entity, PARTICLE_NUKESMOKEA, 0.5, -500.0, -250.0, Subtraction);
				}
				else if (i == 4)
				{
					AttachParticle(entity, PARTICLE_NUKESMOKEA, 0.5, -500.0, 250.0, Subtraction);
				}
				else if (i == 5)
				{
					AttachParticle(entity, PARTICLE_NUKESMOKEA, 0.5, 0.0, 500.0, Subtraction);
				}
				else if (i == 6)
				{
					AttachParticle(entity, PARTICLE_NUKESMOKEA, 0.5, 0.0, -500.0, Subtraction);
				}
			}
			new Handle:SmokePack = CreateDataPack();
			WritePackCell(SmokePack, round);
			WritePackCell(SmokePack, client);
			WritePackCell(SmokePack, entity);
			WritePackFloat(SmokePack, Subtraction);
			ResetPack(SmokePack);
			CreateTimer(0.5, Timer_NukeSmoke, SmokePack);
		}
	}
}
public Action:Timer_NukeFireA(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	new entity = ReadPackCell(data);
	new Float:Subtraction = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			AttachParticle(entity, PARTICLE_NUKEFIREA, 0.5, 0.0, 0.0, 0.0);
			new Float:value = 100.0;
			for (new i=1; i<=20; i++)
			{
				if (Subtraction >= value)
				{
					AttachParticle(entity, PARTICLE_NUKEFIREA, 0.5, 0.0, 0.0, value);
					value += 100.0;
				}
			}
			new Handle:FireAPack = CreateDataPack();
			WritePackCell(FireAPack, round);
			WritePackCell(FireAPack, client);
			WritePackCell(FireAPack, entity);
			WritePackFloat(FireAPack, Subtraction);
			ResetPack(FireAPack);
			CreateTimer(0.5, Timer_NukeFireA, FireAPack);
		}
	}
}
public Action:Timer_NukeFireB(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	new entity = ReadPackCell(data);
	new Float:Subtraction = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			new Float:value = 0.0;
			for (new i=1; i<=20; i++)
			{
				if (Subtraction >= value)
				{
					if (GetRandomInt(1,2) == 1)
					{
						AttachParticle(entity, PARTICLE_NUKEFIREB, 0.5, GetRandomFloat(-25.0, 25.0), GetRandomFloat(-25.0, 25.0), value);
/*
						if (GetRandomInt(1,2) == 1)
						{
							AttachParticle(entity, PARTICLE_NUKECHUNKA, 0.5, GetRandomFloat(-25.0, 25.0), GetRandomFloat(-25.0, 25.0), value);
						}
*/
					}
					value += 100.0;
				}
			}
			new Handle:FireBPack = CreateDataPack();
			WritePackCell(FireBPack, round);
			WritePackCell(FireBPack, client);
			WritePackCell(FireBPack, entity);
			WritePackFloat(FireBPack, Subtraction);
			ResetPack(FireBPack);
			CreateTimer(0.5, Timer_NukeFireB, FireBPack);
		}
	}
}
public Action:Timer_NukeFireC(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	new entity = ReadPackCell(data);
	new Float:Subtraction = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			new Float:value = 0.0;
			for (new i=1; i<=20; i++)
			{
				if (Subtraction >= value)
				{
					if (GetRandomInt(1,2) == 1)
					{
						AttachParticle(entity, PARTICLE_NUKEFIREC, 0.5, GetRandomFloat(-25.0, 25.0), GetRandomFloat(-25.0, 25.0), value);
/*
						if (GetRandomInt(1,2) == 1)
						{
							AttachParticle(entity, PARTICLE_NUKECHUNKB, 0.5, GetRandomFloat(-25.0, 25.0), GetRandomFloat(-25.0, 25.0), value);
						}
*/
					}
					value += 100.0;
				}
			}
			new Handle:FireCPack = CreateDataPack();
			WritePackCell(FireCPack, round);
			WritePackCell(FireCPack, client);
			WritePackCell(FireCPack, entity);
			WritePackFloat(FireCPack, Subtraction);
			ResetPack(FireCPack);
			CreateTimer(0.5, Timer_NukeFireC, FireCPack);
		}
	}
}
public Action:Timer_NukeEffects(Handle:timer, any:client)
{
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		decl Float:Origin[3], Float:TOrigin[3], Float:distance;
		new entity = NukeFlareEnts[client][1];
		if (entity > 32 && IsValidEntity(entity))
		{
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
			for (new i=1; i<=MaxClients; i++)
			{
				if (IsClientInGame(i) && IsPlayerAlive(i) && (GetClientTeam(i) == 2 || !IsPlayerGhost(i) && GetClientTeam(i) == 3))
				{
					GetEntPropVector(i, Prop_Send, "m_vecOrigin", TOrigin);
                			distance = GetVectorDistance(TOrigin, Origin);
					if (distance <= 1000)
					{
						ScreenShake(i, 7.0);
					}
					else if (distance <= 2000)
					{
						ScreenShake(i, 5.0);
					}
					else if (distance <= 3000)
					{
						ScreenShake(i, 3.0);
					}
				}
			}
		}
		entity = -1;
		while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
		{
			new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				DealDamageEntity(entity, client, 10, 10, "nuke_bomb");
				DealDamageEntity(entity, client, 134217792, 290, "nuke_bomb");
			}
		}
		while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
		{
			new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
			if (ragdoll == 0)
			{
				DealDamageEntity(entity, client, 10, 10, "nuke_bomb");
				DealDamageEntity(entity, client, 134217792, 290, "nuke_bomb");
			}
		}
		while ((entity = FindEntityByClassname(entity, "player")) != INVALID_ENT_REFERENCE)
		{
			if (IsClientInGame(entity) && IsPlayerAlive(entity) && !IsPlayerGhost(entity) && GetClientTeam(entity) == 3)
			{
				DealDamagePlayer(entity, client, 10, 10, "nuke_bomb");
				DealDamagePlayer(entity, client, 134217792, 290, "nuke_bomb");
			}
		}
		NukeFireBombs(client);
		return Plugin_Continue;
	}
	return Plugin_Stop;
}
stock NukeFireBombs(client)
{
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		new entity = NukeFlareEnts[client][1];
		if (entity > 32 && IsValidEntity(entity))
		{
			decl Float:Origin[3];
			GetEntPropVector(entity, Prop_Data, "m_vecOrigin", Origin);

			new Float:min, Float:max, Float:negmin, Float:negmax;
			min = 10.0;
			max = 1000.0;
			negmin = -10.0;
			negmax = -1000.0;
			
			new x = GetRandomInt(1,2);
			if (x == 1)
			{
				Origin[0] = Origin[0] += GetRandomFloat(min, max);
			}
			else
			{
				Origin[0] = Origin[0] += GetRandomFloat(negmin, negmax);
			}
			new y = GetRandomInt(1,2);
			if (y == 1)
			{
				Origin[1] = Origin[1] += GetRandomFloat(min, max);
			}
			else
			{
				Origin[1] = Origin[1] += GetRandomFloat(negmin, negmax);
			}
			FindFloorPos(Origin);
			Origin[2] = FindFloorfloor[2];
			GasCanExplode(client, Origin);
		}
	}
}
stock GasCanExplode(client, Float:Origin[3])
{
	new gascan = CreateEntityByName("prop_physics");
	if (gascan > 32 && IsValidEntity(gascan))
	{
		DispatchKeyValue(gascan, "model", MODEL_GASCAN); 
		DispatchSpawn(gascan);
		if (IsValidClient(client))
		{
			SetEntPropEnt(gascan, Prop_Data, "m_hLastAttacker", client);
		}
		TeleportEntity(gascan, Origin, NULL_VECTOR, NULL_VECTOR);
		ActivateEntity(gascan);
		AcceptEntityInput(gascan, "Break");
	}
}
public Action:Timer_PropaneExplode(Handle:timer, any:data)
{
	new round = ReadPackCell(data);
	new client = ReadPackCell(data);
	decl Float:Location[3];
	Location[0] = ReadPackFloat(data);
	Location[1] = ReadPackFloat(data);
	Location[2] = ReadPackFloat(data);
	CloseHandle(data);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}
	if (NukeTimer[client] > 0 && !bNightmare)
	{
		PropaneExplode(client, Location);
	}
}
stock PropaneExplode(client, Float:Origin[3])
{
	new propane = CreateEntityByName("prop_physics");
	if (propane > 32 && IsValidEntity(propane))
	{
		DispatchKeyValue(propane, "model", MODEL_PROPANE); 
		DispatchSpawn(propane);
		if (IsValidClient(client))
		{
			SetEntPropEnt(propane, Prop_Data, "m_hLastAttacker", client);
		}
		TeleportEntity(propane, Origin, NULL_VECTOR, NULL_VECTOR);
		ActivateEntity(propane);
		AcceptEntityInput(propane, "Break");
	}
}
//=============================
// Specials
//=============================
stock RemoveAttachments(client)
{
	RemoveShoulderCannon(client);
	RemoveJetPack(client);
	RemoveHat(client);
}
stock RemoveAttachmentsAll()
{
	for (new client=1; client<=MaxClients; client++)
	{
		RemoveShoulderCannon(client);
		RemoveJetPack(client);
		RemoveHat(client);
	}
}
public Action:RestoreAttachments(Handle:timer, any:client)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (!bNightmare)
		{
			new level = cLevel[client];
			if (level >= 45)
			{
				if (CannonEquip[client] == 1)
				{
					EquipShoulderCannon(client);
				}
			}
			if (level >= 49)
			{
				if (JetPackEquip[client] == 1)
				{
					EquipJetPack(client);
				}
			}
			if (level >= 50)
			{
				if (HatEquip[client] == 1)
				{
					EquipHat(client);
				}
			}
		}
	}
}
stock bool:HasCannon(client)
{
	new entity = CannonEnt[client];
	if (entity > 0 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[34];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, MODEL_M60, false))
			{
				return true;
			}
		}
	}
	return false;
}
stock EquipShoulderCannon(client)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (CannonEnt[client] <= 0)
		{
			if (CannonRate[client] < 0.05)
			{
				CannonRate[client] = 0.15;	
			}
			new entity = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(entity))
			{
				DispatchKeyValue(entity, "model", MODEL_M60);
				DispatchSpawn(entity);
				SetVariantString("!activator");
				AcceptEntityInput(entity, "SetParent", client);
				SetVariantString("eyes");
				AcceptEntityInput(entity, "SetParentAttachment");
				AcceptEntityInput(entity, "DisableCollision");
				AcceptEntityInput(entity, "DisableShadow");
				SetEntProp(entity, Prop_Data, "m_iEFlags", 0);
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 0.43);
				CannonEnt[client] = entity;
				new Float:Origin[3] = {-5.0, -5.0, -6.0};
				new Float:Angles[3] = {-15.0, 0.0, 90.0};
				TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
				RunRepeater(iRound, client, entity);
				SDKHook(entity, SDKHook_SetTransmit, Transmit_ShoulderCannon);
			}
		}
	}
}
stock RemoveShoulderCannon(client)
{
	new entity = CannonEnt[client];
	if (entity > 0 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[34];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, MODEL_M60, false))
			{
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.0);
				AcceptEntityInput(entity, "Kill");
				CannonEnt[client] = 0;
			}
		}
	}
}
stock RunRepeater(round, client, entity)
{
	new Handle:Pack = CreateDataPack();
	WritePackCell(Pack, round);
	WritePackCell(Pack, client);
	WritePackCell(Pack, entity);
	CreateTimer(CannonRate[client], CannonRepeater, Pack, TIMER_FLAG_NO_MAPCHANGE);
}
public Action:CannonRepeater(Handle:timer, any:Pack)
{
	ResetPack(Pack, false);
	new round = ReadPackCell(Pack);
	new client = ReadPackCell(Pack);
	new cannon = ReadPackCell(Pack);
	CloseHandle(Pack);

	if (iRound != round || !IsServerProcessing())
	{
		return;
	}

	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client))
	{
		if (cannon > 0 && IsValidEntity(cannon) && cannon == CannonEnt[client])
		{
			new String:classname[16];
			GetEdictClassname(cannon, classname, sizeof(classname));
			if (StrEqual(classname, "prop_dynamic", false))
			{
				decl String:model[34];
				GetEntPropString(cannon, Prop_Data, "m_ModelName", model, sizeof(model));
				if (StrEqual(model, MODEL_M60, false))
				{
					new targetfirst = CannonTargetFirst[client];
					new nevertarget = CannonNeverTarget[client];
					if (CannonOn[client] == 1 || IsPlayerIncap(client) || IsPlayerHeld(client))
					{
						RunRepeater(round, client, cannon);
						return;
					}
					new ammo = CannonAmmo[client];
					new Float:Origin[3], Float:TOrigin[3], Float:storeddist = 0.0, Float:distance = 0.0, zombie = 0, special = 0, tank = 0, witch = 0;
					if (ammo > 0)
					{
						new entity = -1;
						while ((entity = FindEntityByClassname(entity, "infected")) != INVALID_ENT_REFERENCE)
						{
							if (nevertarget != 1 && nevertarget != 5 && nevertarget != 6)
							{
								new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
								if (ragdoll == 0)
								{
									GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
									GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
                       							distance = GetVectorDistance(Origin, TOrigin);
									if (distance < 600)
									{
										if (storeddist == 0.0 || storeddist > distance)
										{
											if (IsClientViewing(client, entity))	
											{
												storeddist = distance;
												zombie = entity;
											}
										}
									}
								}
							}
						}
						while ((entity = FindEntityByClassname(entity, "witch")) != INVALID_ENT_REFERENCE)
						{
							if (nevertarget != 3 && nevertarget != 6 && nevertarget != 7)
							{
								new ragdoll = GetEntProp(entity, Prop_Data, "m_bClientSideRagdoll");
								if (ragdoll == 0)
								{
									GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
									GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
                       							distance = GetVectorDistance(Origin, TOrigin);
									if (distance < 600)
									{
										if (storeddist == 0.0 || storeddist > distance)
										{
											if (IsClientViewing(client, entity))	
											{
												storeddist = distance;
												witch = entity;
											}
										}
									}
								}
							}
						}
						while ((entity = FindEntityByClassname(entity, "player")) != INVALID_ENT_REFERENCE)
						{
							if (IsClientInGame(entity) && IsPlayerAlive(entity) && !IsPlayerGhost(entity) && GetClientTeam(entity) == 3)
							{
								if (IsTank(entity) && nevertarget != 4 && nevertarget != 7)
								{
									GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
									GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
                       							distance = GetVectorDistance(Origin, TOrigin);
									if (distance < 600)
									{
										if (storeddist == 0.0 || storeddist > distance)
										{
											if (IsClientViewing(client, entity))	
											{
												storeddist = distance;
												tank = entity;
											}
										}
									}
								}
								else if (IsSpecialInfected(entity) && nevertarget != 2 && nevertarget != 5)
								{
									GetEntPropVector(client, Prop_Send, "m_vecOrigin", Origin);
									GetEntPropVector(entity, Prop_Send, "m_vecOrigin", TOrigin);
                       							distance = GetVectorDistance(Origin, TOrigin);
									if (distance < 600)
									{
										if (storeddist == 0.0 || storeddist > distance)
										{
											if (IsClientViewing(client, entity))	
											{
												storeddist = distance;
												special = entity;
											}
										}
									}
								}
							}
						}
						switch(targetfirst)
						{
							case 0:
							{
								if (zombie > 0)
								{
									DestroyTarget(client, zombie, 2);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (special > 0)
								{
									DestroyTarget(client, special, 1);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (witch > 0)
								{
									DestroyTarget(client, witch, 2);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (tank > 0)
								{
									DestroyTarget(client, tank, 1);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else
								{
									RunRepeater(round, client, cannon);
									return;
								}
							}
							case 1:
							{
								if (special > 0)
								{
									DestroyTarget(client, special, 1);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (witch > 0)
								{
									DestroyTarget(client, witch, 2);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (tank > 0)
								{
									DestroyTarget(client, tank, 1);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (zombie > 0)
								{
									DestroyTarget(client, zombie, 2);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else
								{
									RunRepeater(round, client, cannon);
									return;
								}
							}
							case 2:
							{
								if (witch > 0)
								{
									DestroyTarget(client, witch, 2);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (tank > 0)
								{
									DestroyTarget(client, tank, 1);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (zombie > 0)
								{
									DestroyTarget(client, zombie, 2);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (special > 0)
								{
									DestroyTarget(client, special, 1);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else
								{
									RunRepeater(round, client, cannon);
									return;
								}
							}
							case 3:
							{
								if (tank > 0)
								{
									DestroyTarget(client, tank, 1);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (zombie > 0)
								{
									DestroyTarget(client, zombie, 2);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (special > 0)
								{
									DestroyTarget(client, special, 1);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else if (witch > 0)
								{
									DestroyTarget(client, witch, 2);
									CannonAmmo[client] -= 1;
									RunRepeater(round, client, cannon);
									return;
								}
								else
								{
									RunRepeater(round, client, cannon);
									return;
								}
							}
						}
					}
					else if (ammo == 0)
					{
						CannonAmmo[client] = -1;
						PrintToChat(client, "\x04[Shoulder Cannon]\x01 Out of Ammo.");
						RunRepeater(round, client, cannon);
						return;
					}
					else if (ammo < 0)
					{
						RunRepeater(round, client, cannon);
						return;
					}
				}
			}
		}
	}
}
stock DestroyTarget(client, target, entitytype)
{
	new cannon = CannonEnt[client];
	if (cannon > 0 && IsValidEntity(cannon))
	{
		ShowMuzzleFlash(cannon, PARTICLE_RIFLE_FLASH);
		AttachParticle(target, PARTICLE_BLOOD, 0.1, 0.0, 0.0, 30.0);
		CreateTracerParticles(cannon, target);
		EmitSoundToAll(SOUND_M60_FIRE, client);
		switch(entitytype)
		{
			case 1: DealDamagePlayer(target, client, 2, 12, "shoulder_cannon");
			case 2: DealDamageEntity2(target, client, 2, 12, "shoulder_cannon");
		}
	}
}
stock CreateTracerParticles(entity, target)
{
	if (entity > 32 && IsValidEntity(entity) && target > 0 && IsValidEntity(target))
	{
		decl String:name[8];
		decl Float:Origin[3], Float:TOrigin[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
		GetEntPropVector(target, Prop_Send, "m_vecOrigin", TOrigin);
		TOrigin[2] += 30.0;
		new endpoint = CreateEntityByName("info_particle_target");
		if (endpoint > 0 && IsValidEntity(endpoint))
		{
			Format(name, sizeof(name), "cpt%i", endpoint);
			DispatchKeyValue(endpoint, "targetname", name);	
			DispatchKeyValueVector(endpoint, "origin", TOrigin);
			DispatchSpawn(endpoint);
			ActivateEntity(endpoint);
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(endpoint, "AddOutput");
			AcceptEntityInput(endpoint, "FireUser1");
		}
		new particle = CreateEntityByName("info_particle_system");
		if (particle > 0 && IsValidEntity(particle))
		{
			DispatchKeyValue(particle, "effect_name", PARTICLE_50CAL_TRACER);
			DispatchKeyValue(particle, "cpoint1", name);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity);
			SetVariantString("muzzle_flash");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
	}
}
stock ShowMuzzleFlash(target, const String:ParticleName[])
{
	if (target > 0 && IsValidEntity(target))
	{
   		new particle = CreateEntityByName("info_particle_system");
    		if (particle > 0 && IsValidEntity(particle))
    		{
        		new Float:Origin[3], Float:Angles[3];
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", Origin);
			DispatchKeyValue(particle, "effect_name", ParticleName);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchKeyValueVector(particle, "angles", Angles);
			DispatchSpawn(particle);
			ActivateEntity(particle);

			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", target);
			SetVariantString("muzzle_flash");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			GetEntPropVector(particle, Prop_Send, "m_angRotation", Angles);
			Angles[0] -= 90.0;
			TeleportEntity(particle, NULL_VECTOR, Angles, NULL_VECTOR);
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
    	}
}
stock bool:HasJetPack(client)
{
	new count = 0;
	decl String:model[38];
	decl String:classname[16];
	new entity = JetPackAEnt[client];
	if (entity > 0 && IsValidEntity(entity))
	{
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/missiles/f18_agm65maverick.mdl", false))
			{
				count++;
			}
		}
	}
	entity = JetPackBEnt[client];
	if (entity > 0 && IsValidEntity(entity))
	{
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/missiles/f18_agm65maverick.mdl", false))
			{
				count++;
			}
		}
	}
	if (count >= 2)
	{
		return true;
	}
	return false;
}
stock EquipJetPack(client)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (JetPackAEnt[client] <= 0)
		{
			new entity = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(entity))
			{
				DispatchKeyValue(entity, "model", MODEL_MISSILE);
				DispatchSpawn(entity);
				SetVariantString("!activator");
				AcceptEntityInput(entity, "SetParent", client);
				SetVariantString("medkit");
				AcceptEntityInput(entity, "SetParentAttachment");
				AcceptEntityInput(entity, "DisableCollision");
				AcceptEntityInput(entity, "DisableShadow");
				SetEntProp(entity, Prop_Data, "m_iEFlags", 0);
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 0.15);
				SetEntityRenderColor(entity, 0, 0, 0, 255);
				JetPackAEnt[client] = entity;
				new Float:Origin[3] = {-2.0, 15.0, 4.0};
				new Float:Angles[3] = {0.0, -80.0, 20.0};
				TeleportEntity(entity, Origin, Angles, NULL_VECTOR);
				SDKHook(entity, SDKHook_SetTransmit, Transmit_JetPackA);
			}
		}
		if (JetPackBEnt[client] <= 0)
		{
			new entity2 = CreateEntityByName("prop_dynamic_override");
			if (IsValidEntity(entity2))
			{
				DispatchKeyValue(entity2, "model", MODEL_MISSILE);
				DispatchSpawn(entity2);
				SetVariantString("!activator");
				AcceptEntityInput(entity2, "SetParent", client);
				SetVariantString("medkit");
				AcceptEntityInput(entity2, "SetParentAttachment");
				AcceptEntityInput(entity2, "DisableCollision");
				AcceptEntityInput(entity2, "DisableShadow");
				SetEntProp(entity2, Prop_Data, "m_iEFlags", 0);
				SetEntPropFloat(entity2, Prop_Data, "m_flModelScale", 0.15);
				SetEntityRenderColor(entity2, 0, 0, 0, 255);
				JetPackBEnt[client] = entity2;
				new Float:Origin[3] = {-2.0, 15.0, -4.0};
				new Float:Angles[3] = {0.0, -80.0, 20.0};
				TeleportEntity(entity2, Origin, Angles, NULL_VECTOR);
				SDKHook(entity2, SDKHook_SetTransmit, Transmit_JetPackB);
			}
		}
		if (bIsFinale && iFinaleStage > 0 && !bNightmare)
		{
			JetPackOn[client] = 1;
		}
	}
}
stock JetPackBoost(client, entity, entity2)
{
	if (entity > 32 && IsValidEntity(entity))
	{
   		new particle = CreateEntityByName("info_particle_system");
    		if (particle > 32 && IsValidEntity(particle))
    		{
        		new Float:Origin[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
			DispatchKeyValue(particle, "effect_name", PARTICLE_JETFIRE);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity);
			SetVariantString("tail");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
   		particle = CreateEntityByName("info_particle_system");
    		if (particle > 32 && IsValidEntity(particle))
    		{
        		new Float:Origin[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
			DispatchKeyValue(particle, "effect_name", PARTICLE_JETSMOKE);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity);
			SetVariantString("tail");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
    	}
	if (entity2 > 32 && IsValidEntity(entity2))
	{
   		new particle = CreateEntityByName("info_particle_system");
    		if (particle > 32 && IsValidEntity(particle))
    		{
        		new Float:Origin[3];
			GetEntPropVector(entity2, Prop_Send, "m_vecOrigin", Origin);
			DispatchKeyValue(particle, "effect_name", PARTICLE_JETFIRE);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity2);
			SetVariantString("tail");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
   		particle = CreateEntityByName("info_particle_system");
    		if (particle > 32 && IsValidEntity(particle))
    		{
        		new Float:Origin[3];
			GetEntPropVector(entity2, Prop_Send, "m_vecOrigin", Origin);
			DispatchKeyValue(particle, "effect_name", PARTICLE_JETSMOKE);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity2);
			SetVariantString("tail");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.1:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
    	}
}
stock JetPackParticles(client, entity, entity2)
{
	if (entity > 32 && IsValidEntity(entity))
	{
   		new particle = CreateEntityByName("info_particle_system");
    		if (particle > 32 && IsValidEntity(particle))
    		{
        		new Float:Origin[3];
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
			DispatchKeyValue(particle, "effect_name", PARTICLE_JETIDLE);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity);
			SetVariantString("tail");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.5:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
    	}
	if (entity2 > 32 && IsValidEntity(entity2))
	{
   		new particle = CreateEntityByName("info_particle_system");
    		if (particle > 32 && IsValidEntity(particle))
    		{
        		new Float:Origin[3];
			GetEntPropVector(entity2, Prop_Send, "m_vecOrigin", Origin);
			DispatchKeyValue(particle, "effect_name", PARTICLE_JETIDLE);
			DispatchKeyValueVector(particle, "origin", Origin);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", entity2);
			SetVariantString("tail");
			AcceptEntityInput(particle, "SetParentAttachment");
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			SetVariantString("OnUser1 !self:Kill::0.5:-1");
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
			AcceptEntityInput(particle, "ClearParent");
		}
    	}
}
stock JetPackEffects(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		new level = cLevel[client];
		if (level >= 49 && !bNightmare)
		{
			new entity = JetPackAEnt[client];
			new entity2 = JetPackBEnt[client];
			if (JetPackActive(client))
			{
				DisplayJetPackFuel(client);
				if (JetPackFlight[client] == true)
				{
					JetPackBoost(client, entity, entity2);
					JetPackParticleTimer[client] += 1;
					if (JetPackParticleTimer[client] >= 5)
					{
						if (entity > 32 && IsValidEntity(entity))
						{
							StopSound(entity, SNDCHAN_AUTO, SOUND_JETPACKIDLE);
							EmitSoundToAll(SOUND_JETPACKFIRE, entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_SHOULDPAUSE, SNDVOL_NORMAL, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
						}
						JetPackParticleTimer[client] = 0;
					}
				}
				else 
				{
					JetPackParticleTimer[client] += 1;
					if (JetPackParticleTimer[client] >= 5)
					{
						if (entity > 32 && IsValidEntity(entity))
						{
							StopSound(entity, SNDCHAN_AUTO, SOUND_JETPACKFIRE);
							EmitSoundToAll(SOUND_JETPACKIDLE, entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_SHOULDPAUSE, SNDVOL_NORMAL, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
						}
						JetPackParticles(client, entity, entity2);
						JetPackParticleTimer[client] = 0;
					}
				}
			}
			else
			{
				if (entity > 32 && IsValidEntity(entity))
				{
					StopSound(entity, SNDCHAN_AUTO, SOUND_JETPACKIDLE);
					StopSound(entity, SNDCHAN_AUTO, SOUND_JETPACKFIRE);
				}
			}
		}
	}
}
stock DisplayJetPackFuel(client)
{
	new fuel = JetPackFuel[client];
	if (fuel >= 0)
	{
		if (fuel >= 480)
			PrintCenterText(client, "[][][][][][][][][][][][]");
		else if (fuel >= 460)
			PrintCenterText(client, "[][][][][][][][][][][][");
		else if (fuel >= 440)
			PrintCenterText(client, "[][][][][][][][][][][]");
		else if (fuel >= 420)
			PrintCenterText(client, "[][][][][][][][][][][");
		else if (fuel >= 400)
			PrintCenterText(client, "[][][][][][][][][][]");
		else if (fuel >= 380)
			PrintCenterText(client, "[][][][][][][][][][");
		else if (fuel >= 360)
			PrintCenterText(client, "[][][][][][][][][]");
		else if (fuel >= 340)
			PrintCenterText(client, "[][][][][][][][][");
		else if (fuel >= 320)
			PrintCenterText(client, "[][][][][][][][]");
		else if (fuel >= 300)
			PrintCenterText(client, "[][][][][][][][");
		else if (fuel >= 280)
			PrintCenterText(client, "[][][][][][][]");
		else if (fuel >= 260)
			PrintCenterText(client, "[][][][][][][");
		else if (fuel >= 240)
			PrintCenterText(client, "[][][][][][]");
		else if (fuel >= 220)
			PrintCenterText(client, "[][][][][][");
		else if (fuel >= 200)
			PrintCenterText(client, "[][][][][]");
		else if (fuel >= 180)
			PrintCenterText(client, "[][][][][");
		else if (fuel >= 160)
			PrintCenterText(client, "[][][][]");
		else if (fuel >= 140)
			PrintCenterText(client, "[][][][");
		else if (fuel >= 120)
			PrintCenterText(client, "[][][]");
		else if (fuel >= 100)
			PrintCenterText(client, "[][][");
		else if (fuel >= 80)
			PrintCenterText(client, "[][]");
		else if (fuel >= 60)
			PrintCenterText(client, "[][");
		else if (fuel >= 40)
			PrintCenterText(client, "[]");
		else if (fuel >= 20)
			PrintCenterText(client, "[");
		else if (fuel <= 0)
			PrintCenterText(client, "");
	}
}
stock RemoveJetPack(client)
{
	decl String:model[38];
	decl String:classname[16];
	new entity = JetPackAEnt[client];
	if (entity > 0 && IsValidEntity(entity))
	{
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/missiles/f18_agm65maverick.mdl", false))
			{
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.0);
				AcceptEntityInput(entity, "Kill");
				JetPackAEnt[client] = 0;
			}
		}
	}
	entity = JetPackBEnt[client];
	if (entity > 0 && IsValidEntity(entity))
	{
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			if (StrEqual(model, "models/missiles/f18_agm65maverick.mdl", false))
			{
				SetEntPropFloat(entity, Prop_Data, "m_flModelScale", 1.0);
				AcceptEntityInput(entity, "Kill");
				JetPackBEnt[client] = 0;
			}
		}
	}
	JetPackFlight[client] = false;
	GroundJetPack(client);
}
stock JetPackControl(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && !IsFakeClient(client) && GetClientTeam(client) == 2)
	{
		new level = cLevel[client];
		if (level >= 49 && !bNightmare)
		{
			new buttons = GetClientButtons(client);
			if (buttons & IN_JUMP)
			{
				JetPackAscend[client] = true;
				if (JetPackActive(client) && JetPackFlight[client] == false)
				{
					if (JetPackJump[client] == 0)
					{
						JetPackJump[client] = 1;
					}
					else if (JetPackJump[client] == 2)
					{
						JetPackJump[client] = 3;
					}
					//PrintToChat(client, "JetPackJump: %i", JetPackJump[client]);
				}
			}
			else
			{
				JetPackAscend[client] = false;
				if (JetPackActive(client) && JetPackFlight[client] == false)
				{
					if (JetPackJump[client] == 1)
					{
						JetPackJump[client] = 2;
					}
					//PrintToChat(client, "JetPackJump: %i", JetPackJump[client]);
				}
			}
			if (buttons & IN_DUCK)
			{
				JetPackDescend[client] = true;
			}
			else
			{
				JetPackDescend[client] = false;
			}

			if (JetPackActive(client) && !IsPlayerIncap(client) && !IsPlayerHeld(client) && JetPackDisrupt[client] <= 0)
			{
				//PrintToChat(client, "jetpack active");
				new onground = GetEntPropEnt(client, Prop_Send, "m_hGroundEntity");
				if (onground != 0) //in air
				{
					if (JetPackJump[client] == 3)
					{	
						if (JetPackFuel[client] > 0)
						{
							JetPackFlight[client] = true;
							if (JetPackFuel[client] > 0)
							{
								JetPackFuel[client] -= 1;
							}
							if (JetPackAscend[client] == false && JetPackDescend[client] == false)
							{
								ControlJetPack(client, 0.0, false);
							}
							else if (JetPackAscend[client] == true && JetPackDescend[client] == false)
							{
								ControlJetPack(client, 200.0, false);
							}
							else if (JetPackAscend[client] == false && JetPackDescend[client] == true)
							{
								ControlJetPack(client, -200.0, false);
							}
							else if (JetPackAscend[client] == true && JetPackDescend[client] == true)
							{
								ControlJetPack(client, 0.0, true);
							}
						}
						else
						{
							JetPackFlight[client] = false;
							if (JetPackFuel[client] == 0)
							{
								PrintToChat(client, "\x04[Jetpack]\x01 Out of fuel.");
								JetPackFuel[client] = -1;
							}
							GroundJetPack(client);
							JetPackIdle[client] = 0;
							JetPackIdleOrigin[client][0] = 0.0;
							JetPackIdleOrigin[client][1] = 0.0;
							JetPackIdleOrigin[client][2] = 0.0;
						}
					}
					else
					{
						JetPackFlight[client] = false;
						GroundJetPack(client);
						JetPackIdle[client] = 0;
						JetPackIdleOrigin[client][0] = 0.0;
						JetPackIdleOrigin[client][1] = 0.0;
						JetPackIdleOrigin[client][2] = 0.0;
					}
				}
				else // on ground
				{
					JetPackFlight[client] = false;
					if (JetPackFuel[client] < 480)
					{
						JetPackFuel[client] += 1;
					}
					GroundJetPack(client);
					JetPackJump[client] = 0;
					JetPackIdle[client] = 0;
					JetPackIdleOrigin[client][0] = 0.0;
					JetPackIdleOrigin[client][1] = 0.0;
					JetPackIdleOrigin[client][2] = 0.0;
				}
				//PrintToChat(client, "ground:%i, jump:%i", onground, JetPackJump[client]);
			}	
			else if (JetPackFlight[client] == true)
			{
				//PrintToChat(client, "jetpack inactive");
				JetPackFlight[client] = false;
				GroundJetPack(client);
				JetPackJump[client] = 0;
				JetPackIdle[client] = 0;
				JetPackIdleOrigin[client][0] = 0.0;
				JetPackIdleOrigin[client][1] = 0.0;
				JetPackIdleOrigin[client][2] = 0.0;
			}
		}
	}
	else
	{
		JetPackFlight[client] = false;
		GroundJetPack(client);
		JetPackJump[client] = 0;
		JetPackIdle[client] = 0;
		JetPackIdleOrigin[client][0] = 0.0;
		JetPackIdleOrigin[client][1] = 0.0;
		JetPackIdleOrigin[client][2] = 0.0;
	}
}
stock bool:JetPackActive(client)
{
	if (HasJetPack(client) && JetPackOn[client] == 1)
	{
		return true;
	}
	return false;
}
stock ControlJetPack(client, Float:vVel, bool:IsBraking)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && !IsFakeClient(client) && GetClientTeam(client) == 2)
	{
		SetEntityMoveType(client, MOVETYPE_FLY);

		if (JetPackDisrupt[client] <= 0)
		{
			new Float:fScaleSpeed = 200.0;
			new Float:fMaxSpeedLimit = 250.0;
			new Float:fAngle = 999.0;
			new Float:Velocity[3], Float:Angles[3];
			GetClientAbsAngles(client, Angles);
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", Velocity);
			Velocity[2] = vVel;
			new buttons = GetClientButtons(client);
			if (!IsBraking)
			{
				switch(buttons)
				{
					case (IN_FORWARD): fAngle = 0.0;
					case (IN_BACK): fAngle = -180.0;
					case (IN_MOVELEFT): fAngle = 90.0;
					case (IN_MOVERIGHT): fAngle = -90.0;
					case (IN_FORWARD|IN_MOVELEFT): fAngle = 45.0;
					case (IN_FORWARD|IN_MOVERIGHT): fAngle = -45.0;
					case (IN_BACK|IN_MOVELEFT): fAngle = 135.0;
					case (IN_BACK|IN_MOVERIGHT): fAngle = -135.0;
				}
				if (fAngle != 999.0)
				{
					Angles[1] += fAngle;
					GetAngleVectors(Angles, Angles, NULL_VECTOR, NULL_VECTOR);
					ScaleVector(Angles, fScaleSpeed);
					Velocity[0] = Angles[0];
					Velocity[1] = Angles[1];
					JetPackIdle[client] = 0;
					JetPackIdleOrigin[client][0] = 0.0;
					JetPackIdleOrigin[client][1] = 0.0;
					JetPackIdleOrigin[client][2] = 0.0;
				}
				if (vVel != 0.0 && JetPackIdle[client] > 0)
				{
					new Float:Origin[3];
					GetEntPropVector(client, Prop_Data, "m_vecOrigin", Origin);
					new Float:distance = GetVectorDistance(Origin, JetPackIdleOrigin[client]);
					if (distance > 50.0)
					{
						JetPackIdle[client] = 0;
						JetPackIdleOrigin[client][0] = 0.0;
						JetPackIdleOrigin[client][1] = 0.0;
						JetPackIdleOrigin[client][2] = 0.0;
					}
				}
			}
			else if (JetPackIdleOrigin[client][0] == 0.0 && JetPackIdleOrigin[client][1] == 0.0 && JetPackIdleOrigin[client][2] == 0.0)
			{
				GetEntPropVector(client, Prop_Data, "m_vecOrigin", JetPackIdleOrigin[client]);
				Velocity[0] = 0.0;
				Velocity[1] = 0.0;
				Velocity[2] = 0.0;
				JetPackIdle[client] = 1;
			}
			if (JetPackIdle[client] > 0)
			{
				new Float:Origin[3], Float:Direction[3];
				GetEntPropVector(client, Prop_Data, "m_vecOrigin", Origin);
				SubtractVectors(JetPackIdleOrigin[client], Origin, Direction);
				GetVectorAngles(Direction, Direction);
				new Float:distance = GetVectorDistance(Origin, JetPackIdleOrigin[client]);
				//PrintToChat(client, "JetPackIdle: %i, distance: %f", JetPackIdle[client], distance);
				if (distance > 60.0)
				{
					GetAngleVectors(Direction, Direction, NULL_VECTOR, NULL_VECTOR);
					ScaleVector(Direction, 25.0);
					Velocity[0] = Direction[0];
					Velocity[1] = Direction[1];
					Velocity[2] = Direction[2];
				}
				else if (distance <= 1.0)
				{
					Velocity[0] = PickRandomFloat(-25.0, 25.0);
					Velocity[1] = PickRandomFloat(-25.0, 25.0);
					Velocity[2] = PickRandomFloat(-25.0, 25.0);
				}	
			}
			if (Velocity[0] > fMaxSpeedLimit)
			{
				Velocity[0] = fMaxSpeedLimit;
			}
			else if (Velocity[0] < -fMaxSpeedLimit)
			{
				Velocity[0] = -fMaxSpeedLimit;
			}
			if (Velocity[1] > fMaxSpeedLimit)
			{
				Velocity[1] = fMaxSpeedLimit;
			}
			else if (Velocity[1] < -fMaxSpeedLimit)
			{
				Velocity[1] = -fMaxSpeedLimit;
			}
			if (Velocity[2] > fMaxSpeedLimit)
			{
				Velocity[2] = fMaxSpeedLimit;
			}
			else if (Velocity[2] < -fMaxSpeedLimit)
			{
				Velocity[2] = -fMaxSpeedLimit;
			}
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, Velocity);
		}
		else
		{
			JetPackIdle[client] = 0;
			JetPackIdleOrigin[client][0] = 0.0;
			JetPackIdleOrigin[client][1] = 0.0;
			JetPackIdleOrigin[client][2] = 0.0;
		}
	}
}
Float:PickRandomFloat(Float:value1, Float:value2)
{
	if (GetRandomInt(1,2) == 1)
	{
		return value1;
	}
	return value2;
}
stock GroundJetPack(client)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (GetEntityMoveType(client) != MOVETYPE_LADDER)
		{
			SetEntityMoveType(client, MOVETYPE_WALK);
		}
	}
}
stock bool:HasHat(client)
{
	new entity = HatEnt[client];
	if (entity > 0 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[58];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			for (new i=0; i<=35; i++)
			{
				if (StrEqual(model, HatFileName[i], false))
				{
					return true;
				}
			}
		}
	}
	return false;
}
stock EquipHat(client)
{
	if (client > 0 && IsClientInGame(client))
	{
		if (HatIndex[client] > 0)
		{
			new index = HatIndex[client] - 1;
			CreateHat(client, index);
		}
	}
}
stock CreateHat(client, index)
{
	if (client > 0 && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		RemoveHat(client);
		new entity = CreateEntityByName("prop_dynamic_override");
		if (IsValidEntity(entity))
		{
			DispatchKeyValue(entity, "model", HatFileName[index]);
			DispatchSpawn(entity);
			SetVariantString("!activator");
			AcceptEntityInput(entity, "SetParent", client);
			SetVariantString("eyes");
			AcceptEntityInput(entity, "SetParentAttachment");
			AcceptEntityInput(entity, "DisableCollision");
			AcceptEntityInput(entity, "DisableShadow");
			SetEntProp(entity, Prop_Data, "m_iEFlags", 0);
			TeleportEntity(entity, HatOrigin[index], HatAngles[index], NULL_VECTOR);
			HatEnt[client] = entity;
			HatIndex[client] = index+1;
			SDKHook(entity, SDKHook_SetTransmit, Transmit_Hat);
		}
	}
}
public Action:Transmit_ShoulderCannon(entity, client)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		if (client > 0 && IsClientInGame(client) && !IsFakeClient(client))
		{
			if (entity == CannonEnt[client])
			{
				new String:classname[16];
				GetEdictClassname(entity, classname, sizeof(classname));
				if (StrEqual(classname, "prop_dynamic", false))
				{
					decl String:model[34];
					GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
					if (StrEqual(model, MODEL_M60, false))
					{
						return Plugin_Handled;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
public Action:Transmit_JetPackA(entity, client)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		if (client > 0 && IsClientInGame(client) && !IsFakeClient(client))
		{
			if (entity == JetPackAEnt[client])
			{
				new String:classname[16];
				GetEdictClassname(entity, classname, sizeof(classname));
				if (StrEqual(classname, "prop_dynamic", false))
				{
					decl String:model[38];
					GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
					if (StrEqual(model, MODEL_MISSILE, false))
					{
						return Plugin_Handled;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
public Action:Transmit_JetPackB(entity, client)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		if (client > 0 && IsClientInGame(client) && !IsFakeClient(client))
		{
			if (entity == JetPackBEnt[client])
			{
				new String:classname[16];
				GetEdictClassname(entity, classname, sizeof(classname));
				if (StrEqual(classname, "prop_dynamic", false))
				{
					decl String:model[38];
					GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
					if (StrEqual(model, MODEL_MISSILE, false))
					{
						return Plugin_Handled;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
public Action:Transmit_Hat(entity, client)
{
	if (entity > 32 && IsValidEntity(entity))
	{
		if (client > 0 && IsClientInGame(client) && !IsFakeClient(client))
		{
			if (entity == HatEnt[client])
			{
				new String:classname[16];
				GetEdictClassname(entity, classname, sizeof(classname));
				if (StrEqual(classname, "prop_dynamic", false))
				{
					decl String:model[58];
					GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
					for (new i=0; i<=35; i++)
					{
						if (StrEqual(model, HatFileName[i], false))
						{
							return Plugin_Handled;
						}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
stock RemoveHat(client)
{
	new entity = HatEnt[client];
	if (entity > 0 && IsValidEntity(entity))
	{
		new String:classname[16];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_dynamic", false))
		{
			decl String:model[58];
			GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
			for (new i=0; i<=35; i++)
			{
				if (StrEqual(model, HatFileName[i], false))
				{
					AcceptEntityInput(entity, "Kill");
					HatEnt[client] = 0;
				}
			}
		}
	}
}
stock ExternalView(client, Float:time)
{
	EventView(client, false);

	if (hViewTimer[client] != INVALID_HANDLE)
	{
		CloseHandle(hViewTimer[client]);	
	}

	hViewTimer[client] = CreateTimer(1.5, TimerEventView, client);

	if (client > 0 && IsClientInGame(client))
	{
		SetEntPropFloat(client, Prop_Send, "m_TimeForceExternalView", GetGameTime() + time);
	}
}
public Action:TimerEventView(Handle:timer, any:client)
{
	EventView(client, true);
	hViewTimer[client] = INVALID_HANDLE;
}
stock EventView(client, bool:first)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (first)
		{
			new entity = HatEnt[client];
			if (entity > 32 && IsValidEntity(entity))
			{
				SDKHook(entity, SDKHook_SetTransmit, Transmit_Hat);
			}
			entity = JetPackAEnt[client];
			if (entity > 32 && IsValidEntity(entity))
			{
				SDKHook(entity, SDKHook_SetTransmit, Transmit_JetPackA);
			}
			entity = JetPackBEnt[client];
			if (entity > 32 && IsValidEntity(entity))
			{
				SDKHook(entity, SDKHook_SetTransmit, Transmit_JetPackB);
			}
			entity = CannonEnt[client];
			if (entity > 32 && IsValidEntity(entity))
			{
				SDKHook(entity, SDKHook_SetTransmit, Transmit_ShoulderCannon);
			}
		}
		else
		{
			new entity = HatEnt[client];
			if (entity > 32 && IsValidEntity(entity))
			{
				SDKUnhook(entity, SDKHook_SetTransmit, Transmit_Hat);
			}
			entity = JetPackAEnt[client];
			if (entity > 32 && IsValidEntity(entity))
			{
				SDKUnhook(entity, SDKHook_SetTransmit, Transmit_JetPackA);
			}
			entity = JetPackBEnt[client];
			if (entity > 32 && IsValidEntity(entity))
			{
				SDKUnhook(entity, SDKHook_SetTransmit, Transmit_JetPackB);
			}
			entity = CannonEnt[client];
			if (entity > 32 && IsValidEntity(entity))
			{
				SDKUnhook(entity, SDKHook_SetTransmit, Transmit_ShoulderCannon);
			}
		}
	}
}
public Event_First1(Handle:event, const String:name[], bool:dontBroadcast)
{
	EventView(GetClientOfUserId(GetEventInt(event, "userid")), true);
	EventView(GetClientOfUserId(GetEventInt(event, "subject")), true);
}

public Event_Third1(Handle:event, const String:name[], bool:dontBroadcast)
{
	EventView(GetClientOfUserId(GetEventInt(event, "userid")), false);
}
public Event_First(Handle:event, const String:name[], bool:dontBroadcast)
{
	EventView(GetClientOfUserId(GetEventInt(event, "victim")), true);
}
public Event_Third(Handle:event, const String:name[], bool:dontBroadcast)
{
	EventView(GetClientOfUserId(GetEventInt(event, "victim")), false);
}
stock CheckpointReached()
{
	if (!bIsFinale && !bNightmare && iNightmareBegin == 0)
	{
		new count;
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
			{
				if (IsPlayerInSaferoom(i, 2))
				{
					count++;
				}
			}
		}
		if (count > 0 && count >= (RoundFloat(CountSurvivorsAliveAll() / 1.3)))
		{
			SetConVarInt(hNightmareBegin, 1);
		}
	}
}
//=============================
// Saferoom Door Control
//=============================
stock IdentifySRDoor()
{
	PrintToServer("Identify SR Door");
	if (bDoorsOn)
	{
		PrintToServer("Doors on");
		new entity = -1;
		while ((entity = FindEntityByClassname(entity, "prop_door_rotating_checkpoint")) != INVALID_ENT_REFERENCE)
		{
			if (iChapter >= 14)
			{
				return;
			}
			if (GetEntProp(entity, Prop_Data, "m_hasUnlockSequence") == 0)
			{
				iSRDoor = entity;
				if (GetEntProp(entity, Prop_Data, "m_eDoorState") == 2)
				{
					AcceptEntityInput(entity, "Close");
					SetVariantString("spawnflags 40960");
    					AcceptEntityInput(entity, "AddOutput");
					iSRLocked = 1;
				}
				else if (GetEntProp(entity, Prop_Data, "m_eDoorState") == 0)
				{
					SetVariantString("spawnflags 40960");
    					AcceptEntityInput(entity, "AddOutput");
					iSRLocked = 1;
				}
			}
			else
			{
				iSRDoorStart = entity;
			}	
		}
	}
}
stock SRDoorOpen()
{
	if (bDoorsOn)
	{
		iSRDoorTick += 1;
		if (iSRDoorTick >= 5)
		{
			if (iSRDoor > 0 && iSRLocked > 0)
			{
				new entity = iSRDoor;
				if (IsValidEntity(entity))
				{
					new String:entname[30];
					GetEdictClassname(entity, entname, sizeof(entname));
					if (StrEqual(entname, "prop_door_rotating_checkpoint", false))
					{
						new count;
						for (new i=1; i<=MaxClients; i++)
						{
							if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
							{
								decl Float:PlayerPos[3], Float:DoorPos[3];
								GetEntPropVector(i, Prop_Send, "m_vecOrigin", PlayerPos);
								GetEntPropVector(entity, Prop_Send, "m_vecOrigin", DoorPos);
								new Float:distance = GetVectorDistance(PlayerPos, DoorPos);
								if (distance <= 1000.0)
								{
									count++;
								}
							}
						}
						if ((count > 0 && count >= (CountSurvivorsAliveAll() / 2)) || bNightmare)
						{
							if (GetEntProp(entity, Prop_Data, "m_eDoorState") == 0)
							{
    								AcceptEntityInput(entity, "Open");
								iSRLocked = 0;
							}
						}
					}	
				}
			}
			iSRDoorTick = 0;
		}
	}
}
stock GetFakeClientAimTarget(client)
{
	decl Float:Origin[3], Float:Angles[3];
	GetClientEyePosition(client, Origin);
	GetClientEyeAngles(client, Angles);

	new Handle:LineTrace = TR_TraceRayFilterEx(Origin, Angles, MASK_SOLID_BRUSHONLY, RayType_Infinite, TraceRayAimFilter, client);
	if (TR_DidHit(LineTrace))
	{
		new trace = TR_GetEntityIndex(LineTrace);
		CloseHandle(LineTrace);
		return trace;
	}
	CloseHandle(LineTrace);
	return 0;
}
public bool:TraceRayAimFilter(entity, mask, any:data)
{
    	if (entity == data)
	{
		return false;
	}
    	return true;
}
stock OperateDoor(client)
{
	if (bDoorsOn)
	{
		new entity = 0;
		entity = GetClientAimTarget(client, false);
		if (entity > 32 && IsValidEntity(entity))
		{
			new String:classname[30];
			GetEdictClassname(entity, classname, sizeof(classname));
			if (StrEqual(classname, "prop_door_rotating_checkpoint", false))
			{
				if (entity == iSRDoor)
				{
					decl Float:PlayerPos[3], Float:DoorPos[3];
					GetEntPropVector(client, Prop_Send, "m_vecOrigin", PlayerPos);
					GetEntPropVector(entity, Prop_Send, "m_vecOrigin", DoorPos);
					new Float:distance = GetVectorDistance(PlayerPos, DoorPos);
					if (distance <= 120.0)
					{
						if (IsPlayerInSaferoom(client, 2) && !IsPlayerIncap(client) && iSRLocked == 0 && iSRDoorFix == 0 && iSRDoorDelay == 0)
						{	
							AcceptEntityInput(entity, "Close");
							iSRDoorDelay = 1;
							CreateTimer(0.1, SRDoorDelayTimer, _, TIMER_FLAG_NO_MAPCHANGE);
						}
						else if (!IsPlayerInSaferoom(client, 2) && !IsPlayerIncap(client) && iSRLocked == 0 && iSRDoorDelay == 0)
						{
    							AcceptEntityInput(entity, "Open");
							iSRDoorDelay = 1;
							iSRDoorFix = 1;
							CreateTimer(0.1, SRDoorDelayTimer, _, TIMER_FLAG_NO_MAPCHANGE);
							CreateTimer(2.0, SRDoorFixTimer, _, TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
			}
		}
	}
}
public Action:SRDoorDelayTimer(Handle:timer)
{
	iSRDoorDelay = 0;
}
public Action:SRDoorFixTimer(Handle:timer)
{
	iSRDoorFix = 0;
}
stock UnlockSRDoor()
{
	new entity = iSRDoorStart;
	if (entity > 32 && IsValidEntity(entity) && (bNightmare || bHell || bInferno || bBloodmoon || bCowLevel))
	{
		new String:classname[30];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "prop_door_rotating_checkpoint", false))
		{
			new locked = GetEntProp(entity, Prop_Send, "m_bLocked");
			if (locked > 0)
			{
				AcceptEntityInput(entity, "Unlock");
				SetEntProp(entity, Prop_Send, "m_nSequence", 1);
			}
		}
	}
}
//=============================
// Hooks
//=============================
public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if (bMenuOn)
	{
		if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client))
		{
			new String:name[24];
			GetClientWeapon(client, name, sizeof(name));
			if (GetClientTeam(client) == 2)
			{
				if (buttons & IN_ATTACK)
				{
					if (StrEqual(name, "weapon_melee", false))
					{
						BerserkerSwingSpeed(client);
					}
					else if (StrEqual(name, "weapon_first_aid_kit", false))
					{
						if (BlockHeal[client] == true)
						{
							new Float:time = GetGameTime();
							if (time >= BlockHealTime[client])
							{
								BlockHeal[client] = false;
								FastHealAbility(client);
								HealTarget(client);
							}
							else
							{
								buttons ^= IN_ATTACK;
							}
						}
						else
						{
							FastHealAbility(client);
							HealTarget(client);
						}	
					}
					else if (StrEqual(name, "weapon_defibrillator", false))
					{
						FastHealAbility(client);
					}
					else if (StrEqual(name, "weapon_rifle", false))
					{
						RFGunSpeed(client);
					}
				}
				if (buttons & IN_ATTACK2)
				{
					if (StrEqual(name, "weapon_melee", false))
					{
						SetEntProp(client, Prop_Send, "m_iShovePenalty", 0, 1);
					}
					else if (StrEqual(name, "weapon_first_aid_kit", false))
					{
						if (BlockHeal[client] == true)
						{
							new Float:time = GetGameTime();
							if (time >= BlockHealTime[client])
							{
								BlockHeal[client] = false;
								FastHealAbility(client);
								HealTarget(client);
							}
							else
							{
								buttons ^= IN_ATTACK2;
							}
						}
						else
						{
							FastHealAbility(client);
							HealTarget(client);
						}
					}
				}
				if (buttons & IN_USE)
				{
					FastHealAbility(client);
					OperateDoor(client);
					SelfRevive(client);
					KnifeInfected(client);
					UseSpawnAmmoPile(client);
				}
				else
				{
					new reviver = GetEntPropEnt(client, Prop_Send, "m_reviveOwner");
					if (ReviveStart[client] == 1 && (reviver == client || reviver <= 0))
					{
						KillReviveProgressBar(client);
					}
					new knife = GetEntPropEnt(client, Prop_Send, "m_useActionOwner");
					if (KnifeStart[client] == 1 && (knife == client || knife <= 0))
					{
						KillKnifeProgressBar(client);
					}
				}
				if (buttons & IN_SPEED)
				{
					if (NightCrawlerOn[client] == 1 && ChoiceDelay[client] == 0)
					{
						new target = PickNextTeleTarget(client);
						if (target > 0)
						{
							Teleporter[client] = target;
							TeleportTech(client);
							ChoiceDelay[client] = 1;
							CreateTimer(0.3, ChoiceDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
						}
						else
						{
							PrintToChat(client, "\x05[Lethal-Injection]\x01 No target for teleport.");
							ChoiceDelay[client] = 1;
							CreateTimer(0.3, ChoiceDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
						}
					}
					else if (HeatSeekerOn[client] == 1 && ChoiceDelay[client] == 0)
					{
						HeatSeekerSelectTarget(client);
						ChoiceDelay[client] = 1;
						CreateTimer(0.3, ChoiceDelayTimer, client, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			else
			{
				CreateClone(client);
			}
		}
	}
	return Plugin_Continue;	
}
public OnEntityCreated(entity, const String:classname[])
{
	if (bMenuOn)
	{
		if (StrEqual(classname, "infected", false))
		{
			CreateUncommon(entity);
			SDKHook(entity, SDKHook_OnTakeDamage, OnEntityTakeDamage);
		}
		else if (StrEqual(classname, "tank_rock", false))
		{
			CreateTimer(0.1, RockThrowTimer, _, TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (StrEqual(classname, "witch", false))
		{
			SDKHook(entity, SDKHook_OnTakeDamage, OnEntityTakeDamage);
		}
		else if (StrEqual(classname, "weapon_ammo_spawn", false))
		{
			SDKHook(entity, SDKHook_Use, OnEntityUseAmmo);
		}
		else if (StrEqual(classname, "upgrade_ammo_explosive", false))
		{
			SDKHook(entity, SDKHook_Use, OnEntityUsePack);
			CreateTimer(120.0, AmmoPackKill, entity, TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (StrEqual(classname, "upgrade_ammo_incendiary", false))
		{
			SDKHook(entity, SDKHook_Use, OnEntityUsePack);
			CreateTimer(120.0, AmmoPackKill, entity, TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (StrEqual(classname, "upgrade_laser_sight", false))
		{
			SDKHook(entity, SDKHook_Use, OnEntityUsePack);
		}
		else if (StrEqual(classname, "prop_minigun", false))
		{
			SDKHook(entity, SDKHook_Use, OnMiniGunUse);
		}
		else if (StrEqual(classname, "prop_door_rotating_checkpoint", false))
		{
			SDKHook(entity, SDKHook_Touch, OnDoorTouch);
		}
		else if (StrEqual(classname, "weapon_gascan", false))
		{
			SDKHook(entity, SDKHook_OnTakeDamage, OnEntityTakeDamage);
		}
		else if (StrEqual(classname, "grenade_launcher_projectile", false))
		{
			CreateTimer(0.1, HeatSeekerProjTimer, entity, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}
public OnEntityDestroyed(entity)
{
	if (!IsServerProcessing()) return;

	if (bMenuOn)
	{
		if (IsValidEntity(entity) && IsValidEdict(entity))
		{
			new String:classname[10];
			GetEdictClassname(entity, classname, sizeof(classname));
			if (StrEqual(classname, "tank_rock", false))
			{
				new color = GetEntityRenderColor(entity);
				switch(color)
				{
					//Fire
					case 12800:
					{
						for (new i=1; i<=MaxClients; i++)
						{
							if (IsTank(i) && GetEntityRenderColor(i) == 12800)
							{
								new Float:Origin[3];
								GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
								Origin[2] += 10.0;

								GasCanExplode(i, Origin);
								return;
							}
						}
					}
					//Spitter
					case 12115128:
					{
						for (new i=1; i<=MaxClients; i++)
						{
							if (IsTank(i) && GetEntityRenderColor(i) == 12115128)
							{
								new Float:Origin[3];
								GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
								Origin[2] += 10.0;

								new ent = CreateEntityByName("spitter_projectile");
								if (IsValidEntity(ent))
								{
									DispatchSpawn(ent);
									SetEntPropFloat(ent, Prop_Send, "m_DmgRadius", 1024.0);
									SetEntProp(ent, Prop_Send, "m_bIsLive", 1 );
									SetEntPropEnt(ent, Prop_Send, "m_hThrower", i);
									TeleportEntity(ent, Origin, NULL_VECTOR, NULL_VECTOR);
									L4D2_SpitBurst(ent);
								}
								return;
							}
						}
					}
				}
			}
			else if (StrEqual(classname, "vomitjar_projectile", false))
			{
				new thrower = GetEntPropEnt(entity, Prop_Data, "m_hThrower");
				if (thrower > 0)
				{
					new Float:Origin[3];
					GetEntPropVector(entity, Prop_Send, "m_vecOrigin", Origin);
					new Handle:Pack = CreateDataPack();
					WritePackCell(Pack, iRound);
					WritePackCell(Pack, thrower);
					WritePackCell(Pack, entity);
					WritePackCell(Pack, 36);
					WritePackFloat(Pack, Origin[0]);
					WritePackFloat(Pack, Origin[1]);
					WritePackFloat(Pack, Origin[2]);
					CreateTimer(0.5, VomitJarThinkTimer, Pack);
				}
			}
		}
	}
}
public Action:L4D2_OnInfectedAttackUpdate(entity, &victim)
{
	if (bFreezeAI)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
public Action:L4D2_OnStagger(target, source)
{
	if (IsSurvivor(target) && IsWitch(source))
	{
		//hardened stance
		new level = cLevel[target];
		if (level >= 35)
		{
			//PrintToChat(target, "Blocking stagger from witch entity:%i", source);
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}
public Action:OnMiniGunUse(entity, activator, caller, UseType:type, Float:value)
{
	if (activator > 0 && IsClientInGame(activator))
	{
		for (new i=1; i<=MaxClients; i++)
		{
			if (Sentry[i] == entity)
			{
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}
public Action:OnEntityUsePack(entity, activator, caller, UseType:type, Float:value)
{
	if (activator > 0 && IsClientInGame(activator))
	{
		new String:classname[24];
		GetEdictClassname(entity, classname, sizeof(classname));
		if (StrEqual(classname, "upgrade_ammo_explosive", false))
		{
			if (GetPlayerWeaponSlot(activator, 0) > 0)
			{
				new weapon = GetPlayerWeaponSlot(activator, 0);
				new UpgradeBit = GetEntProp(weapon, Prop_Send, "m_upgradeBitVec");
				if (UpgradeBit != 2 && UpgradeBit != 6)
				{
					CheatCommand(activator, "upgrade_add", "EXPLOSIVE_AMMO");
				}
			}	
		}
		else if (StrEqual(classname, "upgrade_ammo_incendiary", false))
		{
			if (GetPlayerWeaponSlot(activator, 0) > 0)
			{
				new weapon = GetPlayerWeaponSlot(activator, 0);
				new UpgradeBit = GetEntProp(weapon, Prop_Send, "m_upgradeBitVec");
				if (UpgradeBit != 1 && UpgradeBit != 5)
				{
					CheatCommand(activator, "upgrade_add", "INCENDIARY_AMMO");
				}
			}	
		}
		else if (StrEqual(classname, "upgrade_laser_sight", false))
		{
			if (GetPlayerWeaponSlot(activator, 0) > 0)
			{
				new weapon = GetPlayerWeaponSlot(activator, 0);
				new UpgradeBit = GetEntProp(weapon, Prop_Send, "m_upgradeBitVec");
				if (UpgradeBit != 4 && UpgradeBit != 5 && UpgradeBit != 6)
				{
					CheatCommand(activator, "upgrade_add", "LASER_SIGHT");
				}
			}	
		}
	}
	return Plugin_Handled;
}
public Action:OnEntityUseAmmo(entity, activator, caller, UseType:type, Float:value)
{
	if (activator > 0 && IsClientInGame(activator))
	{
		CannonAmmo[activator] = 500;
		new level = cLevel[activator];
		if (level >= 45)
		{
			PrintToChat(activator, "\x04[Shoulder Cannon]\x01 Ammo Refilled");
		}
	}
}
public Action:OnWeaponDrop(client, weapon)
{
	if (client > 0 && IsClientInGame(client) && weapon > 32 && IsValidEntity(weapon))
	{
		if (GetClientTeam(client) == 2)
		{
			if (IsMedKit(weapon))
			{
				new action = GetEntProp(client, Prop_Send, "m_iCurrentUseAction");
    				if (action == 1)
    				{
        				new target = GetEntPropEnt(client, Prop_Send, "m_useActionTarget");
					if (IsSurvivor(target))
					{
						SavedHealth[target] = GetEntProp(target, Prop_Send, "m_iHealth");
					}
				}
			}
			if (WeaponsRestored[client] == 0)
			{
				AcceptEntityInput(weapon, "Kill");
			}
			else
			{
				new health = GetEntProp(client, Prop_Send, "m_iHealth");
				if (health > 0)
				{
					if (GetPlayerWeaponSlot(client, 0) > 0)
					{
						new entity = GetPlayerWeaponSlot(client, 0);
						if (weapon == entity)
						{
							new upgrade = GetEntProp(weapon, Prop_Send, "m_upgradeBitVec");
							if (upgrade > 0)
							{
								SetEntProp(weapon, Prop_Send, "m_upgradeBitVec", 0);
								if (upgrade == 4 || upgrade == 5 || upgrade == 6)
								{
									CreateTimer(0.1, TransferLaserSight, client, TIMER_FLAG_NO_MAPCHANGE);
								}
							}
						}
					}
				}
				else
				{
					AcceptEntityInput(weapon, "Kill");
				}
			}
		}
	}
}
public Action:OnDoorTouch(entity, attacker)
{
	if (entity > 32 && IsValidEntity(entity) && iSRDoorStart == entity && (bNightmare || bHell || bInferno || bBloodmoon || bCowLevel))
	{
		if (IsWitch(attacker) || IsSpecialInfected(attacker) || IsTank(attacker))
		{
    			AcceptEntityInput(entity, "Unlock");
    			AcceptEntityInput(entity, "Open");
    			AcceptEntityInput(entity, "Break");
		}
	}
	return Plugin_Continue;
}
public Action:OnEntityTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype, &weapon, Float:damageForce[3], Float:damagePosition[3], damagecustom)
{
	if (damage > 0.0 && victim > 32 && IsValidEntity(victim))
	{
		decl String:inflictorname[28];
		decl String:weaponname[28];
		if (weapon > 0)
		{
			GetEdictClassname(weapon, weaponname, sizeof(weaponname));
		}
		if (inflictor > 0)
		{
			GetEdictClassname(inflictor, inflictorname, sizeof(inflictorname));
		}
		//PrintToChatAll("%i %i %i %f %i %i",victim,attacker,inflictor,damage,damagetype,weapon);
		if (IsSurvivor(attacker) && !IsFakeClient(attacker))
		{
			if (IsWitch(victim) || IsInfected(victim))
			{
				if (bFreezeAI == true)
				{
					bFreezeAI = false;
				}
				if (StrEqual(inflictorname, "uv_light", false) || StrEqual(inflictorname, "sentry_gun", false) || StrEqual(inflictorname, "shoulder_cannon", false) || 
				StrEqual(inflictorname, "artillery_blast", false) || StrEqual(inflictorname, "ion_cannon", false) || StrEqual(inflictorname, "nuke_bomb", false))
				{
					return Plugin_Continue;
				}
				//PrintToChat(attacker, "%i", damagetype);
				new level = cLevel[attacker];
				//Melee Damage 100HP
				if (weapon > 32 && IsValidEntity(weapon))
				{
					if (StrEqual(weaponname, "weapon_melee", false)) 
					{
						//PrintToChat(attacker, "master of arms");
						if (level >= 32 && !bNightmare) //Master at Arms
						{
							damage = 200.0;
						}
						else
						{
							damage = 100.0;
						}
					}
				}
				//Abilities
				//Berserker
				if (BerserkerOn[attacker] == 1 && !bNightmare)
				{
					if (weapon > 32 && IsValidEntity(weapon))
					{
						if (StrEqual(weaponname, "weapon_melee", false))
						{
							//PrintToChat(attacker, "berserker");
							damage = damage * 2.0;
							decl Float:Origin[3], Float:Angles[3];
							GetEntPropVector(victim, Prop_Send, "m_vecOrigin", Origin);
							GetEntPropVector(victim, Prop_Send, "m_angRotation", Angles);
							CreateBerserkerEffect(Origin, Angles);
							DealDamageEntity(victim, attacker, 128, RoundFloat(damage), "point_hurt");
						}
					}
				}
				//Lifestealer
				else if (LifeStealerOn[attacker] == 1 && !bNightmare)
				{
					if ((weapon > 32 && IsValidEntity(weapon)) || StrEqual(inflictorname, "grenade_launcher_projectile", false))
					{
						StealLife(attacker, RoundFloat(damage));
						LifeStealerEffectsEntity(victim);
					}
				}
				//Rapid Fire
				else if (RapidFireOn[attacker] == 1 && !bNightmare)
				{
					if (weapon > 32 && IsValidEntity(weapon))
					{
						if (StrEqual(weaponname, "weapon_rifle", false))
						{
							//PrintToChat(attacker, "rapid fire");
							AttachParticle(victim, PARTICLE_SPARKSA, 0.1, 0.0, 0.0, 30.0);
						}
					}
				}
				//Polymorph
				else if (PolyMorphOn[attacker] == 1 && !bNightmare)
				{
					if (IsInfected(victim) && weapon > 32 && IsValidEntity(weapon))
					{
						if (IsEntityEquippedWeapon(attacker, weapon))
						{
							damage = 0.0;
							PolyMorphTarget(victim, attacker);
							return Plugin_Changed;
						}
					}
				}
				//Instagib
				else if (InstaGibOn[attacker] == 1 && !bNightmare)
				{
					if (weapon > 32 && IsValidEntity(weapon))
					{
						if (IsEntityEquippedWeapon(attacker, weapon))
						{
							//PrintToChat(attacker, "insta-gib");
							decl Float:Origin[3];
							GetEntPropVector(victim, Prop_Send, "m_vecOrigin", Origin);
							if (IsUncommon(victim))
							{
								new earnedxp = 2 * GetXPDiff(1);
								if (level < 50)
								{
									GiveXP(attacker, earnedxp);
									new messages = cNotifications[attacker];
									if (messages > 0)
									{
										PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Uncommon Zombie Killed: \x03%i\x01 XP", earnedxp);
									}
								}
								else
								{
									GiveXP(attacker, earnedxp);
								}
							}
							else if (IsInfected(victim))
							{
								new earnedxp = 1 * GetXPDiff(1);
								if (level < 50)
								{
									GiveXP(attacker, earnedxp);
									new messages = cNotifications[attacker];
									if (messages > 0)
									{
										PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Zombie Killed: \x03%i\x01 XP", earnedxp);
									}
								}
								else
								{
									GiveXP(attacker, earnedxp);
								}
							}
							else if (IsWitch(victim))
							{
								new color = GetEntProp(victim, Prop_Send, "m_hOwnerEntity");
								if (color == 255200255)
								{
									new earnedxp = 10 * GetXPDiff(1);
									if (level < 50)
									{
										GiveXP(attacker, earnedxp);
										PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Lesser Witch Killed: \x03%i\x01 XP", earnedxp);
									}
									else
									{
										GiveXP(attacker, earnedxp);
									}
								}
								else
								{
									new earnedxp = 25 * GetXPDiff(1);
									if (level < 50)
									{
										GiveXP(attacker, earnedxp);
										PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Witch Killed: \x03%i\x01 XP", earnedxp);
									}
									else
									{
										GiveXP(attacker, earnedxp);
									}
								}
							}
							AttachParticleLoc(Origin, PARTICLE_EXPLODE, 0.1);
							new random = GetRandomInt(1,3);
							switch(random)
							{
								case 1: EmitSoundToAll("player/boomer/explode/explo_medium_09.wav", victim);
								case 2: EmitSoundToAll("player/boomer/explode/explo_medium_10.wav", victim);
								case 3: EmitSoundToAll("player/boomer/explode/explo_medium_14.wav", victim);
							}
							AcceptEntityInput(victim, "Kill");
							return Plugin_Handled;
						}
					}
				}
				if (damagetype != 8 && damagetype != 2056 && damagetype != 268435464)
				{
					if (weapon > 32 && IsValidEntity(weapon))
					{
						if (IsEntityEquippedWeapon(attacker, weapon))
						{
							//Crit Chance
							if (level >= 38 && !bNightmare)
							{
								new value = 10;
								new random = GetRandomInt(1, 100);
								if (value >= random)
								{
									//PrintToChat(attacker, "crit");
									new Float:newdamage = damage * GetRandomFloat(1.5,3.0);
									damage = newdamage;
									damagetype = 134217792;
									if (IsInfected(victim))
									{
										new ragdoll = GetEntProp(victim, Prop_Data, "m_bClientSideRagdoll");
										if (ragdoll == 0)
										{
											SetEntProp(victim, Prop_Send, "m_iRequestedWound1", GetRandomInt(21,25));
											AcceptEntityInput(victim, "BecomeRagdoll");
										}
									}
									AttachParticle(victim, PARTICLE_SPARKSB, 0.8, 0.0, 0.0, 30.0);
									if (CritMessages[attacker] == 0)
									{
										PrintToChat(attacker, "\x01[\x04Critical Hit!\x01] [\x04%i\x01 Damage]", RoundFloat(newdamage));
									}
									return Plugin_Changed;
								}
							}
						}
					}
				}
			}
			else if (IsGasCan(victim))
			{
				//SetEntPropEnt(victim, Prop_Data, "m_hLastAttacker", attacker);
				//AcceptEntityInput(victim, "break");
				//PrintToChatAll("%i %i %f %i %i",attacker,inflictor,damage,damagetype,weapon);
				if (IsSurvivor(attacker))
				{
					if (weapon == -1 && inflictor > 32)
					{
						weapon = inflictor;
						inflictor = attacker;
					}
				}
			}
		}
		else if (IsWitch(victim) && IsWitch(attacker))
		{
			return Plugin_Handled;
		}
		else if (IsGasCan(victim) && IsWitch(attacker))
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Changed;
}
stock bool:IsEntityEquippedWeapon(client, entity)
{
	if (IsSurvivor(client))
	{
		if (entity > 32 && IsValidEntity(entity))
		{
			for (new i=0; i<=4; i++)
			{
				new weapon = GetPlayerWeaponSlot(client, i);
				if (weapon > 32 && IsValidEntity(weapon))
				{
					if (weapon == entity)
					{
						return true;
					}
				}
			}
		}
	}
	return false;
}
public Action:OnPlayerTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype, &weapon, Float:damageForce[3], Float:damagePosition[3], damagecustom)
{
	if (damage > 0.0)
	{
		decl String:inflictorname[28];
		decl String:weaponname[28];
		if (weapon > 0)
		{
			GetEdictClassname(weapon, weaponname, sizeof(weaponname));
		}
		if (inflictor > 0)
		{
			GetEdictClassname(inflictor, inflictorname, sizeof(inflictorname));
		}
		if (IsSurvivor(victim))
		{
			if (iFinaleWin == 1)
			{
				//PrintToServer("Prevented Damage to %i", victim);
				return Plugin_Handled;
			}
			if (SecChanceTimer[victim] > 0)
			{
				return Plugin_Handled;
			}
			if (SoulShieldOn[victim] == 1)
			{
				new level = cLevel[victim];
				if (level >= 37 && !bNightmare)
				{
					if (IsInfected(attacker) || IsWitch(attacker))
					{
						return Plugin_Handled;
					}
					else if (IsValidClient(attacker) && GetClientTeam(attacker) == 3)
					{
						return Plugin_Handled;
					}
				}
			}
			else if (AcidBathOn[victim] == 1)
			{
				if (damagetype == 263168 || damagetype == 265216) //acid
				{
					new level = cLevel[victim];
					if (level >= 9 && !bNightmare)
					{
						HealSurvivor(victim, RoundToFloor(damage), victim);
						return Plugin_Handled;
					}
				}
			}
			else if (FlameShieldOn[victim] == 1)
			{
				if (damagetype == 8 || damagetype == 2056 || damagetype == 268435464 || damagetype == 134217792) //fire
				{
					new level = cLevel[victim];
					if (level >= 16 && !bNightmare)
					{
						return Plugin_Handled;
					}
				}
			}
			//PrintToChat(victim, "%i, %i, %s, %f, %i, %i",attacker,inflictor,inflictorname,damage,damagetype,weapon);
			//PrintToChatAll("%i, %i, %i, %f, %i",victim,attacker,inflictor,damage,damagetype,weapon);
			if (attacker == 0)
			{
				if (damage > 2.0 && damagetype == 32)
				{
					new level = cLevel[victim];
					if (level >= 2 && !bNightmare)
					{
						damage = damage / 2.0;
						PrintToChat(victim, "\x04[Acrobatics]\x01 Fall Damage Reduced by \x03%i\x01 Hitpoints.", RoundFloat(damage));
					}
				}
				else if (damagetype == 8 || damagetype == 2056 || damagetype == 268435464 || damagetype == 134217792)
				{
					if (damage < 100.0)
					{
						return Plugin_Handled;
					}
				}
			}
			else if (IsWorldFire(attacker))
			{
				if (damagetype == 8 || damagetype == 2056 || damagetype == 268435464 || damagetype == 134217792 || damagetype == 64 || damagetype == 1)
				{
					if (damage < 100.0)
					{
						return Plugin_Handled;
					}
				}
			}
			else if (IsInfected(attacker))
			{
				switch(iDifficulty)
				{
					case 1: damage = 1.0;
					case 2: damage = 5.0;
					case 3: damage = 10.0;
					case 4:
					{
						if (bNightmare)
						{
							damage = 30.0;
						}
						else if (bHell || bInferno || bBloodmoon)
						{
							damage = 25.0;
						}
						else if (bCowLevel)
						{
							damage = 5.0;
						}
						else
						{
							damage = 20.0;
						}
					}
				}
			}
			else if (IsWitch(attacker))
			{
				if (GetEntProp(attacker, Prop_Send, "m_hOwnerEntity") == 255200255)
				{
					damage = 10.0;
				}
				else
				{
					switch(iDifficulty)
					{
						case 1: damage = 25.0;
						case 2: damage = 35.0;
						case 3: damage = 45.0;
						case 4:
						{
							if (bNightmare)
							{
								damage = 500.0;
							}
							else if (bCowLevel)
							{
								damage = 50.0;
							}
							else if (bInferno)
							{
								damage = 50.0;
							}
							else if (bHell)
							{
								damage = 50.0;
							}
							else if (bBloodmoon)
							{
								damage = 50.0;
							}
							else
							{
								damage = 50.0;
							}
						}
					}
				}
			}
			else if (IsValidClient(attacker))
			{
				//PrintToChat(victim, "%i, %i, %s, %f, %i, %i",attacker,inflictor,inflictorname,damage,damagetype,weapon);
				//PrintToChat(attacker, "%i, %i, %f, %i, %i",victim,inflictor,damage,damagetype,weapon);
				if (GetClientTeam(attacker) == 1 || GetClientTeam(attacker) == 2)
				{
					return Plugin_Handled;
				}
				else if (GetClientTeam(attacker) == 3)
				{
					if (IsTank(attacker))
					{
						//PrintToChat(victim, "%i, %i, %f, %i, %i",attacker,inflictor,damage,damagetype,weapon);
						if (StrEqual(inflictorname, "weapon_tank_claw", false) || StrEqual(inflictorname, "tank_rock", false))
						{
							JetPackDisrupt[victim] = 1;
						}
						new color = GetEntityRenderColor(attacker);
						switch(color)
						{
							//Fire Tank
							case 12800:
							{
								if (StrEqual(inflictorname, "weapon_tank_claw", false) || StrEqual(inflictorname, "tank_rock", false))
								{
									SkillFlameClaw(victim);
								}
							}
							//Gravity Tank
							case 333435:
							{
								if (StrEqual(inflictorname, "weapon_tank_claw", false))
								{
									SkillGravityClaw(victim);
								}
							}
							//Ice Tank
							case 0100170:
							{
								new flags = GetEntityFlags(victim);
								if (flags & FL_ONGROUND)
								{
									new random = GetRandomInt(1,3);
									if (random == 1)
									{
										SkillIceClaw(victim, attacker);
									}
								}
							}
							//Cobalt Tank
							case 0105255:
							{
								if (StrEqual(inflictorname, "weapon_tank_claw", false))
								{
									TankAbility[attacker] = 0;
								}
							}
							//Smasher Tank
							case 7080100:
							{
								if (StrEqual(inflictorname, "weapon_tank_claw", false))
								{
									new random = GetRandomInt(1,2);
									if (random == 1)
									{
										SkillSmashClawKill(victim, attacker);
									}
									else
									{
										SkillSmashClaw(victim);
									}
								}
							}
							//Shock Tank
							case 100165255:
							{
								if (StrEqual(inflictorname, "weapon_tank_claw", false))
								{
									SkillElecClaw(victim, attacker);
								}
							}
							//Warp Tank
							case 130130255:
							{
								if (StrEqual(inflictorname, "weapon_tank_claw", false))
								{
									new dmg = RoundFloat(damage / 2);
									DealDamagePlayer(victim, attacker, 128, dmg, "point_hurt");
								}
							}
							//Demon Tank
							case 255150100:
							{
								if (StrEqual(inflictorname, "weapon_tank_claw", false))
								{
									SkillSmashClawKill(victim, attacker);
									//TankAbility[attacker] += 1;
									//DemonTankLevelUp(attacker);
								}
							}
						}
						//PrintToChatAll("Inflictor: %s", inflictorname);
						if (!StrEqual(inflictorname, "inferno", false) && !StrEqual(inflictorname, "pipe_bomb_project", false) && !StrEqual(inflictorname, "insect_swarm", false) && !StrEqual(inflictorname, "point_hurt", false))
						{
							switch(iDifficulty)
							{
								case 1: damage = 25.0;
								case 2: damage = 50.0;
								case 3: damage = 75.0;
								case 4:
								{
									if (bNightmare)
									{
										damage = 200.0;
									}
									else if (bCowLevel)
									{
										damage = 50.0;
									}
									else if (bInferno)
									{
										damage = 150.0;
									}
									else if (bHell || bBloodmoon)
									{
										damage = 100.0;
									}
									else
									{
										damage = 100.0;
									}
								}
							}
						}
					}
					else if (IsSpecialInfected(attacker))
					{
						if (IsPlayerIncap(victim))
						{
							BreakInfectedHold(attacker);
							ResetClassAbility(attacker);
						}
						//PrintToChat(victim, "%i, %i, %f, %i, %i",attacker,inflictor,damage,damagetype,weapon);
						if (damagetype == 263168 || damagetype == 265216) //acid
						{
							if (IsInstaCapper(attacker))
							{
								if (!IsPlayerIncap(victim))
								{
									damage = 600.0;
								}
							}
						}
						else if (damagetype != 263168 && damagetype != 265216) //not acid
						{
							if (IsInstaCapper(attacker))
							{
								if (IsPlayerHeld(victim) && !IsPlayerIncap(victim) && CheckZombieHold(victim) == attacker)
								{
									if (!StrEqual(inflictorname, "inferno", false) && !StrEqual(inflictorname, "pipe_bomb_project", false))
									{
										damage = 600.0;
									}
								}
								else
								{
									if (!StrEqual(inflictorname, "inferno", false) && !StrEqual(inflictorname, "pipe_bomb_project", false) && !StrEqual(inflictorname, "point_hurt", false))
									{
										switch(iDifficulty)
										{
											case 1: damage = 25.0;
											case 2: damage = 50.0;
											case 3: damage = 75.0;
											case 4:
											{
												if (bNightmare)
												{
													damage = 200.0;
												}
												else if (bCowLevel)
												{
													damage = 50.0;
												}
												else if (bInferno)
												{
													damage = 100.0;
												}
												else if (bHell || bBloodmoon)
												{
													damage = 100.0;
												}
												else
												{
													damage = 100.0;
												}
											}
										}
									}
								}
							}
							else
							{
								if (IsPlayerIncap(victim) || IsPlayerHeld(victim))
								{
									//PrintToChatAll("Inflictor: %s", inflictorname);
									if (!StrEqual(inflictorname, "pipe_bomb_project", false) && !StrEqual(inflictorname, "point_hurt", false))
									{
										switch(iDifficulty)
										{
											case 1: damage = 15.0;
											case 2: damage = 20.0;
											case 3: damage = 25.0;
											case 4:
											{
												if (bNightmare)
												{
													damage = 50.0;
												}
												else if (bCowLevel)
												{
													damage = 20.0;
												}
												else if (bInferno)
												{
													damage = 45.0;
												}
												else if (bHell || bBloodmoon)
												{
													damage = 35.0;
												}
												else
												{
													damage = 30.0;
												}
											}
										}
									}
								}
								else
								{
									if (!StrEqual(inflictorname, "pipe_bomb_project", false) && !StrEqual(inflictorname, "point_hurt", false))
									{
										switch(iDifficulty)
										{
											case 1: damage = 5.0;
											case 2: damage = 10.0;
											case 3: damage = 15.0;
											case 4:
											{
												if (bNightmare)
												{
													damage = 40.0;
												}
												else if (bCowLevel)
												{
													damage = 10.0;
												}
												else if (bInferno)
												{
													damage = 30.0;
												}
												else if (bHell || bBloodmoon)
												{
													damage = 25.0;
												}
												else
												{
													damage = 20.0;
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		else if (IsValidClient(victim) && GetClientTeam(victim) == 3)
		{
			if (IsSurvivor(attacker) && !IsFakeClient(attacker))
			{
				if (bFreezeAI == true)
				{
					bFreezeAI = false;
				}
			}
			if (IsTank(victim))
			{
				//PrintToChatAll("Damage:%f, Type:%i",damage, damagetype);
				//PrintToChatAll("%i, %i, %i, %f, %i, %i",attacker, victim,inflictor,damage,damagetype,weapon);
				new color = GetEntityRenderColor(victim);
				if (color != 255255255 && color != 7080100)
				{
					if (damagetype == 8 || damagetype == 2056 || damagetype == 268435464)
					{
						return Plugin_Handled;
					}
				}
				if (StrEqual(inflictorname, "sentry_gun", false) || StrEqual(inflictorname, "shoulder_cannon", false) || 
				StrEqual(inflictorname, "artillery_blast", false) || StrEqual(inflictorname, "ion_cannon", false) || StrEqual(inflictorname, "nuke_bomb", false))
				{
					return Plugin_Continue;
				}
			}
			else if (IsSpecialInfected(victim))
			{
				if (StrEqual(inflictorname, "emitter", false) || StrEqual(inflictorname, "sentry_gun", false) || StrEqual(inflictorname, "shoulder_cannon", false) || 
				StrEqual(inflictorname, "artillery_blast", false) || StrEqual(inflictorname, "ion_cannon", false) || StrEqual(inflictorname, "nuke_bomb", false))
				{
					return Plugin_Continue;
				}
			}
			if (IsSurvivor(attacker))
			{
				if (IsTank(victim))
				{
					//PrintToChat(attacker, "%i, %i, %f, %i, %i",victim,inflictor,damage,damagetype,weapon);
					new color = GetEntityRenderColor(victim);
					switch(color)
					{
						//Meteor Tank
						case 1002525:
						{
							if (weapon > 32 && IsValidEntity(weapon))
							{
								if (StrEqual(weaponname, "weapon_melee", false))
								{
									new random = GetRandomInt(1,2);
									if (random == 1)
									{
										if (TankAbility[victim] == 0)
										{
											StartMeteorFall(victim);
										}
									}
								}
							}
						}
						//Hulk Tank
						case 100255200:
						{
							if (GetEntityGlowColor(victim) == 02550)
							{
								HealTank(victim, RoundToFloor(damage));
								return Plugin_Handled;
							}
						}
						//Shield Tank
						case 135205255:
						{
							if (damagetype == 134217792 || damagetype == 33554432 || damagetype == 16777280 ||
							damagetype == -1602224062 || damagetype == -2139094974 || damagetype == -2122317758)
							{
								ShieldState[victim] = 8;
								if (ShieldsUp[victim] == 1)
								{
									DeactivateShield(victim, 8.0);
								}
							}
							else
							{
								if (ShieldsUp[victim] == 1)
								{
									return Plugin_Handled;
								}
							}
						}
					}
				}
				new level = cLevel[attacker];
				if (weapon > 32 && IsValidEntity(weapon))
				{
					if (StrEqual(weaponname, "weapon_melee", false)) 
					{
						//PrintToChat(attacker, "master at arms");
						if (level >= 32 && !bNightmare) //Master at Arms
						{
							damage = 200.0;
						}
						else
						{
							damage = 100.0;
						}
					}
				}
				if (BerserkerOn[attacker] == 1 && !bNightmare)
				{
					if (weapon > 32 && IsValidEntity(weapon))
					{
						if (StrEqual(weaponname, "weapon_melee", false))
						{
							//PrintToChat(attacker, "berserker");
							damage = damage * 2.0;
							decl Float:Origin[3], Float:Angles[3];
							GetEntPropVector(victim, Prop_Send, "m_vecOrigin", Origin);
							GetEntPropVector(victim, Prop_Send, "m_angRotation", Angles);
							CreateBerserkerEffect(Origin, Angles);
							DealDamagePlayer(victim, attacker, 128, RoundFloat(damage), "point_hurt");
						}
					}
				}
				else if (LifeStealerOn[attacker] == 1 && !bNightmare)
				{
					if ((weapon > 32 && IsValidEntity(weapon)) || StrEqual(inflictorname, "grenade_launcher_projectile", false))
					{
						StealLife(attacker, RoundFloat(damage));
						if (!IsInstaCapper(victim) && !IsBreeder(victim))
						{
							LifeStealerEffectsPlayer(victim);
						}
					}
					else if (StrEqual(inflictorname, "skill_knife", false))
					{
						StealLife(attacker, RoundFloat(damage));
						if (!IsInstaCapper(victim) && !IsBreeder(victim))
						{
							LifeStealerEffectsPlayer(victim);
						}
						return Plugin_Continue;
					}
				}
				else if (RapidFireOn[attacker] == 1 && !bNightmare)
				{
					if (weapon > 32 && IsValidEntity(weapon))
					{
						if (StrEqual(weaponname, "weapon_rifle", false))
						{
							//PrintToChat(attacker, "rapid fire");
							AttachParticle(victim, PARTICLE_SPARKSA, 0.1, 0.0, 0.0, 30.0);
						}
					}
				}
				else if (InstaGibOn[attacker] == 1 && !IsFakeClient(attacker) && !bNightmare)
				{
					if (weapon > 32 && IsValidEntity(weapon))
					{
						if (IsEntityEquippedWeapon(attacker, weapon))
						{
							//PrintToChat(attacker, "insta-gib");
							decl Float:Origin[3];
							GetEntPropVector(victim, Prop_Send, "m_vecOrigin", Origin);
							AttachParticleLoc(Origin, PARTICLE_EXPLODE, 0.1);
							new random = GetRandomInt(1,3);
							switch(random)
							{
								case 1: EmitSoundToAll("player/boomer/explode/explo_medium_09.wav", victim);
								case 2: EmitSoundToAll("player/boomer/explode/explo_medium_10.wav", victim);
								case 3: EmitSoundToAll("player/boomer/explode/explo_medium_14.wav", victim);
							}
							if (GetClientHealth(victim) <= RoundFloat(damage*4))
							{
								if (IsTank(victim))
								{
									new type = 0;
									new color = GetEntityRenderColor(victim);
									switch(color)
									{
										case 7595105: type = 1;
										case 7080100: type = 2;
										case 130130255: type = 3;
										case 1002525: type = 4;
										case 12115128: type = 5;
										case 100255200: type = 6;
										case 12800: type = 7;
										case 0100170: type = 8;
										case 2552000: type = 9;
										case 100100100: type = 10;
										case 100165255: type = 11;
										case 255200255: type = 12;
										case 135205255: type = 13;
										case 0105255: type = 14;
										case 2002550: type = 15;
										case 333435: type = 16;
										case 255255255: type = 255;
										case 255150100: type = 666;
									}
									ExecTankDeath(victim, type);
								}
								else if (IsFakeClient(victim))
								{
									new color = GetEntityGlowColor(victim);
									if (color == 701200)
									{
										new earnedxp = 100 * GetXPDiff(1);
										if (level < 50)
										{
											GiveXP(attacker, earnedxp);
											PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Insta-Capper Killed: \x03%i\x01 XP", earnedxp);
										}
										else
										{
											GiveXP(attacker, earnedxp);
										}
									}
									else if (color == 0175175)
									{
										new earnedxp = 100 * GetXPDiff(1);
										if (level < 50)
										{
											GiveXP(attacker, earnedxp);
											PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Breeder Killed: \x03%i\x01 XP", earnedxp);
										}
										else
										{
											GiveXP(attacker, earnedxp);
										}
									}
									else
									{
										new earnedxp = 10 * GetXPDiff(1);
										if (level < 50)
										{
											GiveXP(attacker, earnedxp);
											PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Special Infected Killed: \x03%i\x01 XP", earnedxp);
										}
										else
										{
											GiveXP(attacker, earnedxp);
										}
									}
									AcceptEntityInput(victim, "Kill");
								}
								else
								{
									new earnedxp = 10 * GetXPDiff(1);
									if (level < 50)
									{
										GiveXP(attacker, earnedxp);
										PrintToChat(attacker, "\x05[Lethal-Injection]\x01 Special Infected Killed: \x03%i\x01 XP", earnedxp);
									}
									else
									{
										GiveXP(attacker, earnedxp);
									}
									ForcePlayerSuicide(victim);
								}
							}
							else
							{
								damage = damage * 4;
								damagetype = 134217792;
							}
							return Plugin_Changed;
						}
					}
				}
				if (damagetype != 8 && damagetype != 2056 && damagetype != 268435464 && damagetype != 134217792)
				{
					if (weapon > 32 && IsValidEntity(weapon))
					{
						if (IsEntityEquippedWeapon(attacker, weapon))
						{
							//Crit Chance
							if (level >= 38 && !bNightmare)
							{
								new value = 10;
								new random = GetRandomInt(1, 100);
								if (value >= random)
								{
									if (IsTank(victim) && ShieldsUp[victim] == 0)
									{
										//PrintToChat(attacker, "crit");
										new Float:newdamage = damage * GetRandomFloat(1.5,3.0);
										damage = newdamage;
										damagetype = -2139094974;
										AttachParticle(victim, PARTICLE_SPARKSB, 0.8, 0.0, 0.0, 30.0);
										if (CritMessages[attacker] == 0)
										{
											PrintToChat(attacker, "\x01[\x04Critical Hit!\x01] [\x04%i\x01 Damage]", RoundFloat(newdamage));
										}
										return Plugin_Changed;
									}
									else if (IsSpecialInfected(victim))
									{
										new Float:newdamage = damage * GetRandomFloat(1.5,3.0);
										damage = newdamage;
										damagetype = 134217792;
										AttachParticle(victim, PARTICLE_SPARKSB, 0.8, 0.0, 0.0, 30.0);
										if (CritMessages[attacker] == 0)
										{
											PrintToChat(attacker, "\x01[\x04Critical Hit!\x01] [\x04%i\x01 Damage]", RoundFloat(newdamage));
										}
										return Plugin_Changed;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return Plugin_Changed;
}
//=============================
//	PARTICLE SYSTEM
//=============================
stock CreateParticle(target, const String:ParticleName[], Float:time, Float:origin)
{
	if (target > 0 && IsValidEntity(target))
	{
   		new particle = CreateEntityByName("info_particle_system");
    		if (IsValidEntity(particle))
    		{
			new String:text[28];
        		new Float:pos[3];
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", pos);
			pos[2] += origin;
			TeleportEntity(particle, pos, NULL_VECTOR, NULL_VECTOR);
			DispatchKeyValue(particle, "effect_name", ParticleName);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			AcceptEntityInput(particle, "start");
			Format(text, sizeof(text), "OnUser1 !self:Kill::%f:-1", time);
			SetVariantString(text);
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
		}
    	}
}
stock AttachParticle(target, const String:ParticleName[], Float:time, Float:x, Float:y, Float:z)
{
	if (target > 0 && IsValidEntity(target))
	{
   		new particle = CreateEntityByName("info_particle_system");
    		if (IsValidEntity(particle))
    		{
			new String:text[28];
        		new Float:Origin[3];
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", Origin);
			Origin[0] += x;
			Origin[1] += y;
			Origin[2] += z;
			TeleportEntity(particle, Origin, NULL_VECTOR, NULL_VECTOR);

			DispatchKeyValue(particle, "effect_name", ParticleName);
			DispatchSpawn(particle);
			ActivateEntity(particle);
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", target);
			AcceptEntityInput(particle, "Enable");
			AcceptEntityInput(particle, "start");
			Format(text, sizeof(text), "OnUser1 !self:Kill::%f:-1", time);
			SetVariantString(text);
			AcceptEntityInput(particle, "AddOutput");
			AcceptEntityInput(particle, "FireUser1");
		}
    	}
}
stock AttachParticleLoc(Float:Origin[3], const String:ParticleName[], Float:time)
{
	new particle = CreateEntityByName("info_particle_system");
    	if (IsValidEntity(particle))
    	{
		TeleportEntity(particle, Origin, NULL_VECTOR, NULL_VECTOR);
		new String:text[28];
		DispatchKeyValue(particle, "effect_name", ParticleName);
		DispatchSpawn(particle);
		ActivateEntity(particle);
		AcceptEntityInput(particle, "Enable");
		AcceptEntityInput(particle, "start");
		Format(text, sizeof(text), "OnUser1 !self:Kill::%f:-1", time);
		SetVariantString(text);
		AcceptEntityInput(particle, "AddOutput");
		AcceptEntityInput(particle, "FireUser1");
    	}
}
stock DisplayParticle(const String:ParticleName[], const Float:vPos[3], const Float:vAng[3])
{
	new entity = CreateEntityByName("info_particle_system");
	if (entity > 32 && IsValidEntity(entity))
	{
		DispatchKeyValue(entity, "effect_name", ParticleName);
		DispatchSpawn(entity);
		ActivateEntity(entity);
		AcceptEntityInput(entity, "start");
		TeleportEntity(entity, vPos, vAng, NULL_VECTOR);
		return entity;
	}
	return 0;
}
stock PrecacheParticle(const String:ParticleName[])
{
	new particle = CreateEntityByName("info_particle_system");
	if (IsValidEntity(particle))
	{
		DispatchKeyValue(particle, "effect_name", ParticleName);
		DispatchSpawn(particle);
		ActivateEntity(particle);
		AcceptEntityInput(particle, "start");
		SetVariantString("OnUser1 !self:Kill::0.1:-1");
		AcceptEntityInput(particle, "AddOutput");
		AcceptEntityInput(particle, "FireUser1");
	}  
}
//=============================
//	COMMANDS
//=============================
stock CheatCommand(client, const String:command[], const String:arguments[])
{
	//PrintToChat(client, "%s", arguments);
	new flags = GetCommandFlags(command);
	SetCommandFlags(command, flags & ~FCVAR_CHEAT);
	FakeClientCommand(client, "%s %s", command, arguments);
	SetCommandFlags(command, flags | FCVAR_CHEAT);
}
stock SpawnCommand(client, String:command[], String:arguments[] = "")
{
	ChangeClientTeam(client,3);
	new flags = GetCommandFlags(command);
	SetCommandFlags(command, flags & ~FCVAR_CHEAT);
	FakeClientCommand(client, "%s %s", command, arguments);
	SetCommandFlags(command, flags);
	if (IsFakeClient(client))
	{
		KickClient(client);
	}
}
stock DirectorCommand(client, String:command[])
{
	new flags = GetCommandFlags(command);
	SetCommandFlags(command, flags & ~FCVAR_CHEAT);
	FakeClientCommand(client, "%s", command);
	SetCommandFlags(command, flags | FCVAR_CHEAT);
}
public Action:TestMenu(client, args)
{
	if (IsSurvivor(client))
	{
		new zombie = CheckZombieHold(client);
		if (zombie > 0)
		{
			BreakInfectedHold(zombie);
			ResetClassAbility(zombie);
		}
	}
	return Plugin_Handled;
}
public Action:TestMenu2(client, args)
{
	return Plugin_Handled;
}
public Action:TestMenu3(client, args)
{
	return Plugin_Handled;
}
public Action:TestMenu4(client, args)
{
	return Plugin_Handled;
}
public Action:TestMenu5(client, args)
{
	return Plugin_Handled;
}
public Action:Command_Nightmare(client, args)
{
	if (bMenuOn)
	{
		SetConVarInt(hNightmareBegin, 1);
	}
	return Plugin_Handled;
}
public Action:Command_Bloodmoon(client, args)
{
	if (bMenuOn)
	{
		if (bBloodmoon)
		{
			SetConVarBool(hBloodmoon, false);
		}
		else
		{
			SetConVarBool(hBloodmoon, true);
		}
	}
	return Plugin_Handled;
}
public Action:Command_Hell(client, args)
{
	if (bMenuOn)
	{
		if (bHell)
		{
			SetConVarBool(hHell, false);
		}
		else
		{
			SetConVarBool(hHell, true);
		}
	}
	return Plugin_Handled;
}
public Action:Command_Inferno(client, args)
{
	if (bMenuOn)
	{
		if (bInferno)
		{
			SetConVarBool(hInferno, false);
		}
		else
		{
			SetConVarBool(hInferno, true);
		}
	}
	return Plugin_Handled;
}
public Action:Command_SendInRescueVehicle(client, args)
{
	iRescue = 1;
	ReplyToCommand(client, "Attempting to call CDirectorScriptedEventManager::SendInRescueVehicle(void)");
	L4D2_SendInRescueVehicle();
	return Plugin_Handled;
}
public Action:Command_SetVoting(client, args)
{
	if (args < 2 || args > 2)
	{
		ReplyToCommand(client, "[Lethal-Injection] Usage: sm_clientsetvoting <#userid|name> [level]");
		return Plugin_Handled;
	}

	decl String:arg[MAX_NAME_LENGTH], String:arg2[8];
	GetCmdArg(1, arg, sizeof(arg));
	GetCmdArg(2, arg2, sizeof(arg2));
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[33], target_count, bool:tn_is_ml;

	new targetid = StringToInt(arg);
	if (targetid > 0 && targetid <=MaxClients && IsClientInGame(targetid))
	{
		new level = StringToInt(arg2);
		if (level < 0 || level > 1)
		{
			ReplyToCommand(client, "[Lethal-Injection] Invalid Argument Input: level");
			return Plugin_Handled;
		}
		if (level == 0)
		{
			cVoteAccess[targetid] = level;
			cVoteAccess_accum[targetid] = -1;
		}
		else
		{
			cVoteAccess[targetid] = level;
			cVoteAccess_accum[targetid] = level;
		}
		ReplyToCommand(client, "[Lethal-Injection] [Player]: %N voting level set to %i", targetid, level);
		if (ReadWriteDelay[targetid] == 0)
		{
			new String:steamid[24];
			GetClientAuthId(targetid, AuthId_Steam2, steamid, sizeof(steamid));
			ReadWriteDelay[targetid] = 1;
			ReadWriteDB(steamid, targetid, cExp_accum[targetid], cLevel_accum[targetid], cVoteAccess_accum[targetid], cLevelReset[targetid]);
		}
		return Plugin_Handled;
	}
	new targetclient;
	if ((target_count = ProcessTargetString(
		arg,
		client,
		target_list,
		33,
		COMMAND_FILTER_CONNECTED,
		target_name,
		sizeof(target_name),
		tn_is_ml)) > 0)
	{
		for (new i=0 ; i < target_count ; i++)
		{
			targetclient = target_list[i];
			new level = StringToInt(arg2);
			if (level < 0 || level > 1)
			{
				ReplyToCommand(client, "[Lethal-Injection] Invalid Argument Input: level");
				return Plugin_Handled;
			}
			if (level == 0)
			{
				cVoteAccess[targetclient] = level;
				cVoteAccess_accum[targetclient] = -1;
			}
			else
			{
				cVoteAccess[targetclient] = level;
				cVoteAccess_accum[targetclient] = level;
			}
			PrintToChat(client, "\x05[Lethal-Injection]\x01 [Player]: \x04%N\x01 voting level set to \x03%i", targetclient, level);
			if (ReadWriteDelay[targetclient] == 0)
			{
				new String:steamid[24];
				GetClientAuthId(targetclient, AuthId_Steam2, steamid, sizeof(steamid));
				ReadWriteDelay[targetclient] = 1;
				ReadWriteDB(steamid, targetclient, cExp_accum[targetclient], cLevel_accum[targetclient], cVoteAccess_accum[targetclient], cLevelReset[targetclient]);
			}
		}
	}
	else
	{
		ReplyToTargetError(client, target_count);
	}
	return Plugin_Handled;
}
public Action:KillSelf(client, args)
{
	if (client > 0)
	{
		if (GetClientTeam(client) == 3 && IsPlayerAlive(client) && !IsPlayerGhost(client))
		{
			ForcePlayerSuicide(client);
		}
	}
	return Plugin_Handled;
}
public Action:ShowInfo(client, args)
{
	if (bMenuOn)
	{
		ShowInfoFunc(client);
	}
	return Plugin_Handled;
}
public Action:ShowTeams(client, args)
{
	if (bMenuOn)
	{
		ShowTeamsFunc(client);
	}
	return Plugin_Handled;
}
public Action:ShowMenu(client, args)
{
	if (bMenuOn)
	{
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
		{
			PMFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:StoreItem(client, args)
{
	if (bMenuOn)
	{
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
		{
			if (IsPlayerAlive(client))
			{
				if (bNightmare)
				{
					PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
				}
				else
				{
					StoreItemToBackpack(client);
				}
			}
			else
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You must be alive to use this!");
			}
		}
	}
	return Plugin_Handled;
}
public Action:BackpackMenu(client, args)
{
	if (bMenuOn)
	{
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
		{
			if (IsPlayerAlive(client))
			{
				if (bNightmare)
				{
					PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
				}
				else
				{
					BackpackMenuFunc(client);
				}
			}
			else
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You must be alive to use this!");
			}
		}
	}
	return Plugin_Handled;
}
public Action:WeaponDrop(client, args)
{
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == 2)
	{
		if (WeaponDropDelay[client] <= 0)
		{
			decl String:classname[32];
			GetClientWeapon(client, classname, sizeof(classname));
			if (StrEqual(classname, "weapon_melee", false))
			{
				new weaponid = GetPlayerWeaponSlot(client, 1);
				new String:Model[48];
				GetEntPropString(weaponid, Prop_Data, "m_ModelName", Model, sizeof(Model));
				if (StrEqual(Model, MODEL_V_FIREAXE, false)) classname = "weapon_fireaxe";
				else if (StrEqual(Model, MODEL_V_FRYING_PAN, false)) classname = "weapon_frying_pan";
				else if (StrEqual(Model, MODEL_V_MACHETE, false)) classname = "weapon_machete";
				else if (StrEqual(Model, MODEL_V_BAT, false)) classname = "weapon_baseball_bat";
				else if (StrEqual(Model, MODEL_V_CROWBAR, false)) classname = "weapon_crowbar";
				else if (StrEqual(Model, MODEL_V_CRICKET_BAT, false)) classname = "weapon_cricket_bat";
				else if (StrEqual(Model, MODEL_V_TONFA, false)) classname = "weapon_tonfa";
				else if (StrEqual(Model, MODEL_V_KATANA, false)) classname = "weapon_katana";
				else if (StrEqual(Model, MODEL_V_ELECTRIC_GUITAR, false)) classname = "weapon_electric_guitar";
				else if (StrEqual(Model, MODEL_V_KNIFE, false)) classname = "weapon_knife";
				else if (StrEqual(Model, MODEL_V_GOLFCLUB, false)) classname = "weapon_golfclub";		
			}
			new slot = 2;
			for (new index=1; index<=40; index++)
			{
				switch(index)
				{
					case 4: slot = 3;
					case 8: slot = 4;
					case 10: slot = 1;
					case 24: slot = 0;
				}
				if (StrEqual(classname, WeaponClassname[index], false))
				{
					if (slot == 1)
					{
						if (index != 10 && index != 11)
						{
							CheatCommand(client, "give", "pistol");
							WeaponDropDelay[client] = 30;
						}
						else
						{
							PrintToChat(client, "\x05[Lethal-Injection]\x01 You can't drop this weapon.");
						}
					}
					else
					{
						DropSlot(client, index, slot);
						WeaponDropDelay[client] = 30;
					}
				}
			}
		}
		else
		{
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You can use this again in %i seconds.", WeaponDropDelay[client]);
		}
	}
	return Plugin_Handled;
}
public Action:DeployablesMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 1)
		{
			if (bNightmare)
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
			}
			else
			{
				DeployablesMenuFunc(client);
			}
		}
	}
	return Plugin_Handled;
}
public Action:AbilitiesMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 3)
		{
			if (bNightmare)
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
			}
			else
			{
				AbilitiesMenuFunc(client);
			}
		}
	}
	return Plugin_Handled;
}
public Action:BombardmentsMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 36)
		{
			if (bNightmare)
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
			}
			else
			{
				BombardmentsMenuFunc(client);
			}
		}
	}
	return Plugin_Handled;
}
public Action:SpecialsMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 45)
		{
			SpecialsMenuFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:ShoulderCannonMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 45)
		{
			if (bNightmare)
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
			}
			else
			{
				ShoulderCannonMenuFunc(client);
			}
		}
	}
	return Plugin_Handled;
}
public Action:JetPackMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 49)
		{
			if (bNightmare)
			{
				PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
			}
			else
			{
				JetPackMenuFunc(client);
			}
		}
	}
	return Plugin_Handled;
}
public Action:JetPackHelpMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 49)
		{
			JetPackHelpMenuFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:HatsMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 50)
		{
			HatsMenuFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:ChooseHatMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 50)
		{
			ChooseHatMenuFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:SentryControlMenu(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 28)
		{
			SentryCtrlMenuFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:InfoSkills(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 2)
		{
			InfoSkillsFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:InfoDeployables(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 1)
		{
			InfoDeployablesFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:InfoAbilities(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 3)
		{
			InfoAbilitiesFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:InfoBombardments(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 36)
		{
			InfoBombardmentsFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:InfoSpecials(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level >= 45)
		{
			InfoSpecialsFunc(client);
		}
	}
	return Plugin_Handled;
}
public Action:ResetLevel(client, args)
{
	if (bMenuOn)
	{
		new level = cLevel[client];
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && level == 50)
		{
			ResetLevelFunc(client);
		}
	}
	return Plugin_Handled;
}
stock NotificationsMenu(client)
{
	if (bMenuOn)
	{
		if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
		{
			NotificationsMenuFunc(client);
		}
	}
}
//=============================
// MENUS
//=============================
public Action:ShowInfoFunc(client)
{
	if (client > 0)
	{
		decl String:text[48];
		decl String:GameDifficulty[10];
		decl String:GameMode[10];
       	 	switch(iDifficulty)
		{
			case 1: GameDifficulty = "Easy";
			case 2: GameDifficulty = "Normal";
			case 3: GameDifficulty = "Advanced";
			case 4: GameDifficulty = "Expert";
		}
		GetConVarString(FindConVar("mp_gamemode"), GameMode, sizeof(GameMode));
		if (StrEqual(GameMode, "coop", false))
		{
			GameMode = "Coop";
		}
		else if (StrEqual(GameMode, "realism", false))
		{
			GameMode = "Realism";
		}
		else if (StrEqual(GameMode, "survival", false))
		{
			GameMode = "Survival";
		}
		else if (StrEqual(GameMode, "versus", false))
		{
			GameMode = "Versus";
		}
		else if (StrEqual(GameMode, "scavenge", false))
		{
			GameMode = "Scavenge";
		}
		new Handle:BuyPanel = CreatePanel();
		Format(text, sizeof(text), "Lethal-Injection L4D2 | %i/%i", CountInGame(), GetConVarInt(FindConVar("sv_maxplayers")));
		SetPanelTitle(BuyPanel, text);
		DrawPanelText(BuyPanel, "====================");
		Format(text, sizeof(text), "Gamemode: %s", GameMode);
		DrawPanelText(BuyPanel, text);
		if (bNightmare)
			Format(text, sizeof(text), "Difficulty: %s, (Nightmare)", GameDifficulty);
		else if (bCowLevel)
			Format(text, sizeof(text), "Difficulty: %s, (Secret Cow Level)", GameDifficulty);
		else if (bInferno)
			Format(text, sizeof(text), "Difficulty: %s, (Inferno)", GameDifficulty);
		else if (bHell)
			Format(text, sizeof(text), "Difficulty: %s, (Hell)", GameDifficulty);
		else if (bBloodmoon)
			Format(text, sizeof(text), "Difficulty: %s, (Bloodmoon)", GameDifficulty);
		else
			Format(text, sizeof(text), "Difficulty: %s", GameDifficulty);
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Map: %s", current_map);
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Number of deaths: %i", iNumDeaths);
		DrawPanelText(BuyPanel, text);
		if (iDifficulty != 1)
		{
			Format(text, sizeof(text), "Number of defeats: %i", iNumDefeats);
			DrawPanelText(BuyPanel, text);
			if (iDifficulty == 4)
			{
				if (!bHell && !bInferno && !bBloodmoon && !bCowLevel)
				{
					Format(text, sizeof(text), "Wins Required for Hell: %i", 3 - iDiffWins);
					DrawPanelText(BuyPanel, text);
				}
				else if (bBloodmoon)
				{
					Format(text, sizeof(text), "Win Bloodmoon to unlock Hell");
					DrawPanelText(BuyPanel, text);
				}
				else if (bHell)
				{
					Format(text, sizeof(text), "Wins Required for Inferno: %i", 3 - iDiffWins);
					DrawPanelText(BuyPanel, text);
				}
			}
		}
		if (NightmareSeconds() < 10 && iFinaleStage <= 0)
		{
			Format(text, sizeof(text), "Nightmare Countdown: %i:0%i", NightmareMinutes(), NightmareSeconds());
			DrawPanelText(BuyPanel, text);
		}
		else if (iFinaleStage <= 0)
		{
			Format(text, sizeof(text), "Nightmare Countdown: %i:%i", NightmareMinutes(), NightmareSeconds());
			DrawPanelText(BuyPanel, text);
		}
		else if (FinaleCountdownSeconds() < 10 && bIsFinale && iFinaleStage > 0)
		{
			Format(text, sizeof(text), "Nightmare Countdown: %i:0%i", FinaleCountdownMinutes(), FinaleCountdownSeconds());
			DrawPanelText(BuyPanel, text);
		}
		else if (bIsFinale && iFinaleStage > 0)
		{
			Format(text, sizeof(text), "Nightmare Countdown: %i:%i", FinaleCountdownMinutes(), FinaleCountdownSeconds());
			DrawPanelText(BuyPanel, text);
		}
		DrawPanelText(BuyPanel, "====================");
		Format(text, sizeof(text), "Tank HP: %i", GetConVarInt(FindConVar("z_tank_health")));
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Witch HP: %i", GetConVarInt(FindConVar("z_witch_health")));
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Zombie HP: %i", GetConVarInt(FindConVar("z_health")));
		DrawPanelText(BuyPanel, text);
		DrawPanelText(BuyPanel, "====================");
		Format(text, sizeof(text), "Smoker HP: %i", GetConVarInt(FindConVar("z_gas_health")));
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Boomer HP: %i", GetConVarInt(FindConVar("z_exploding_health")));
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Hunter HP: %i", GetConVarInt(FindConVar("z_hunter_health")));
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Spitter HP: %i", GetConVarInt(FindConVar("z_spitter_health")));
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Jockey HP: %i", GetConVarInt(FindConVar("z_jockey_health")));
		DrawPanelText(BuyPanel, text);
		Format(text, sizeof(text), "Charger HP: %i", GetConVarInt(FindConVar("z_charger_health")));
		DrawPanelText(BuyPanel, text);
		DrawPanelText(BuyPanel, "====================");
		DrawPanelText(BuyPanel, "Press 0 to exit");
		SendPanelToClient(BuyPanel, client, InfoPanelHandler, 20);
		CloseHandle(BuyPanel);
	}
	return Plugin_Handled;
}
public InfoPanelHandler(Handle:BuyPanel, MenuAction:action, param1, param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(BuyPanel);
	}
}
public Action:ShowTeamsFunc(client)
{
	if (client > 0)
	{
		new count;
		decl String:status[1];
		decl String:text[48];
		new Handle:BuyPanel = CreatePanel();
		SetPanelTitle(BuyPanel, "Team Menu");
		DrawPanelText(BuyPanel, " \n");
		DrawPanelText(BuyPanel, "Spectators");
		count = 1;
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && GetClientTeam(i) == 1)
			{
				Format(text, sizeof(text), "->%i. %N", count, i);
				DrawPanelText(BuyPanel, text);
				count++;
			}
		}
		DrawPanelText(BuyPanel, " \n");
		DrawPanelText(BuyPanel, "Survivors");
		count = 1;
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && GetClientTeam(i) == 2)
			{
				if (IsPlayerAlive(i))
				{
					if (IsPlayerIncap(i))
					{
						status = "I";
					}
					else
					{
						status = "A";
					}
				}
				else
				{
					status = "D";
				}
				new level = cLevel[i];
				if (cVoteAccess[i] == 1)
				{
					Format(text, sizeof(text), "->%i. %N [%i*][%s]", count, i, level, status);
				}
				else
				{
					Format(text, sizeof(text), "->%i. %N [%i][%s]", count, i, level, status);
				}
				DrawPanelText(BuyPanel, text);
				count++;
			}
		}
		DrawPanelText(BuyPanel, " \n");
		DrawPanelText(BuyPanel, "Infected");
		count = 1;
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && GetClientTeam(i) == 3)
			{
				Format(text, sizeof(text), "->%i. %N", count, i);
				DrawPanelText(BuyPanel, text);
				count++;
			}
		}
		DrawPanelText(BuyPanel, " \n");
		Format(text, sizeof(text), "Connected: %i/%i", CountInGame(), GetConVarInt(FindConVar("sv_maxplayers")));
		DrawPanelText(BuyPanel, text);
		DrawPanelText(BuyPanel, " \n");
		DrawPanelText(BuyPanel, "Press 0 to exit");
		SendPanelToClient(BuyPanel, client, TeamPanelHandler, 40);
		CloseHandle(BuyPanel);
	}
	return Plugin_Handled;
}
public TeamPanelHandler(Handle:BuyPanel, MenuAction:action, param1, param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(BuyPanel);
	}
}
public Action:PMFunc(client)
{
	if (client > 0)
	{
		decl String:name[32];
		decl String:text[128];
		new level = cLevel[client];
		new Handle:menu = CreateMenu(PMH);
		Format(text, sizeof(text), "Survivor Menu\n====================\nPlayer: %N\nLevel: %i\nXP: [%i/%i]\n====================", client, level, cExp[client], cExpToLevel[client]);
		SetMenuTitle(menu, text);
		Format(name, sizeof(name), "Store Item");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Backpack Menu");
		AddMenuItem(menu, name, name);
		if (level >= 1)
		{
			Format(name, sizeof(name), "Deployables Menu");
			AddMenuItem(menu, name, name);
		}
		if (level >= 3)
		{
			Format(name, sizeof(name), "Abilities Menu");
			AddMenuItem(menu, name, name);
		}
		if (level >= 36)
		{
			Format(name, sizeof(name), "Bombardments Menu");
			AddMenuItem(menu, name, name);
		}
		if (level >= 45)
		{
			Format(name, sizeof(name), "Specials Menu");
			AddMenuItem(menu, name, name);
		}
		if (level >= 28)
		{
			Format(name, sizeof(name), "Sentry Control Menu");
			AddMenuItem(menu, name, name);
		}
		Format(name, sizeof(name), "Notifications Menu");
		AddMenuItem(menu, name, name);
		if (level >= 1)
		{
			Format(name, sizeof(name), "Deployables Information");
			AddMenuItem(menu, name, name);
		}
		if (level >= 2)
		{
			Format(name, sizeof(name), "Skills Information");
			AddMenuItem(menu, name, name);
		}
		if (level >= 3)
		{
			Format(name, sizeof(name), "Abilities Information");
			AddMenuItem(menu, name, name);
		}
		if (level >= 36)
		{
			Format(name, sizeof(name), "Bombardments Information");
			AddMenuItem(menu, name, name);
		}
		if (level >= 45)
		{
			Format(name, sizeof(name), "Specials Information");
			AddMenuItem(menu, name, name);
		}
		if (level == 50)
		{
			Format(name, sizeof(name), "Reset Level");
			AddMenuItem(menu, name, name);
		}
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public PMH(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[32];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		if (StrContains(name, "Store Item", false) != -1)
		{
			FakeClientCommand(client, "store");
		}
		else if (StrContains(name, "Backpack Menu", false) != -1)
		{
			FakeClientCommand(client, "backpack");
		}
		else if (StrContains(name, "Deployables Menu", false) != -1)
		{
			FakeClientCommand(client, "deployables");
		}
		else if (StrContains(name, "Sentry Control Menu", false) != -1)
		{
			FakeClientCommand(client, "sentrycontrol");
		}
		else if (StrContains(name, "Abilities Menu", false) != -1)
		{
			FakeClientCommand(client, "abilities");
		}
		else if (StrContains(name, "Bombardments Menu", false) != -1)
		{
			FakeClientCommand(client, "bombardments");
		}
		else if (StrContains(name, "Specials Menu", false) != -1)
		{
			FakeClientCommand(client, "specials");
		}
		else if (StrContains(name, "Notifications Menu", false) != -1)
		{
			NotificationsMenu(client);
		}
		else if (StrContains(name, "Skills Information", false) != -1)
		{
			FakeClientCommand(client, "infoskills");
		}
		else if (StrContains(name, "Deployables Information", false) != -1)
		{
			FakeClientCommand(client, "infodeployables");
		}
		else if (StrContains(name, "Abilities Information", false) != -1)
		{
			FakeClientCommand(client, "infoabilities");
		}
		else if (StrContains(name, "Bombardments Information", false) != -1)
		{
			FakeClientCommand(client, "infobombardments");
		}
		else if (StrContains(name, "Specials Information", false) != -1)
		{
			FakeClientCommand(client, "infospecials");
		}
		else if (StrContains(name, "Reset Level", false) != -1)
		{
			FakeClientCommand(client, "resetlevel");
		}
	}
}
public Action:BackpackMenuFunc(client)
{
	if (client > 0)
	{
		decl String:name[48];
		decl String:identifier[4];
		decl String:text[80];
		new usedslots = GetUsedBackpackSlots(client);
		new maxslots = 12;
		new Handle:menu = CreateMenu(BackpackMenuHandler);
		Format(text, sizeof(text), "Backpack Menu\n====================\nSlots Used [%i/%i]\n====================", usedslots, maxslots);
		SetMenuTitle(menu, text);
		new itemcount;
		for (new count=1; count<=12; count++)
		{
			new item = BackpackItemID[client][count];
			if (item > 0 && itemcount < maxslots)
			{
				if (BackpackGunInfo[client][count][2] > 0)
				{
					if (BackpackGunInfo[client][count][0] > 0)
					{
						Format(name, sizeof(name), "%s (%i/%i)", WeaponItemName[item], BackpackGunInfo[client][count][2], BackpackGunInfo[client][count][0]);
						Format(identifier, sizeof(identifier), "%i", count);
						AddMenuItem(menu, identifier, name);
						itemcount++;
					}
					else
					{
						Format(name, sizeof(name), "%s (%i)", WeaponItemName[item], BackpackGunInfo[client][count][2]);
						Format(identifier, sizeof(identifier), "%i", count);
						AddMenuItem(menu, identifier, name);
						itemcount++;
					}
				}
				else
				{
					Format(name, sizeof(name), "%s", WeaponItemName[item]);
					Format(identifier, sizeof(identifier), "%i", count);
					AddMenuItem(menu, identifier, name);
					itemcount++;
				}
			}
		}
		if (itemcount == 0)
		{
			AddMenuItem(menu, "0", "EMPTY", ITEMDRAW_DISABLED);
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public BackpackMenuHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[48];
	decl String:info[4];
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	new slot = StringToInt(info);
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		new pos = FindCharInString(name, '(', true);  
		if (pos != -1)
		{
    			Format(name, pos, "%s", name);
			//PrintToChat(client, "%s, %i", name, pos);
		}
		if (!bNightmare)
		{
			if (!DisplayingProgressBar(client))
			{
				new index;
				//arms dealer
				new level = cLevel[client];
				if (level >= 19)
				{
					index = 40;
				}
				else
				{
					index = 9;
				}
				for (new count=1; count<=index; count++)
				{
					if (StrEqual(name, WeaponItemName[count], false))
					{
						if (BackpackDelay[client] > 0)
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You must wait a second to use this again.");
							return;
						}
						GiveBackpackItem(client, slot, WeaponClassname[count], WeaponItemName[count]);
						return;
					}
				}
			}
			else
			{
				PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot interrupt your current action!");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:DeployablesMenuFunc(client)
{
	if (client > 0)
	{
		new timer;
		decl String:name[32];
		decl String:text[40];
		new level = cLevel[client];
		new Handle:menu = CreateMenu(DeployablesHandler);
		Format(text, sizeof(text), "Deployables Menu\n====================");
		SetMenuTitle(menu, text);
		if (level >= 1)
		{
			timer = AmmoTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Ammo Pile [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Ammo Pile [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 7)
		{
			timer = UVLightTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "UV Light [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "UV Light [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 14)
		{
			timer = EmitterTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "High Frequency Emitter [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "High Frequency Emitter [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 21)
		{
			timer = HSTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Healing Station [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Healing Station [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 28)
		{
			timer = SentryTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Sentry Gun [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Sentry Gun [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 34)
		{
			timer = RBTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Resurrection Bag [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Resurrection Bag [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 42)
		{
			timer = DefenseGridTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Defense Grid [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Defense Grid [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public DeployablesHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[32];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (IsPlayerAlive(client))
			{
				if (!IsPlayerIncap(client) && !IsPlayerHeld(client))
				{
					if (StrContains(name, "Ammo Pile", false) != -1)
					{
						if (AmmoTimer[client] <= 0)
						{
							new flags = GetEntityFlags(client);
							if (flags & FL_ONGROUND)
							{
								SpawnAmmoPile(client);
								PrintToChat(client, "\x04[Deployables]\x01 Deploying Ammo Pile");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to spawn an Ammo Pile.");
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", AmmoTimer[client]);
						}
					}
					else if (StrContains(name, "UV Light", false) != -1)
					{
						if (UVLightTimer[client] <= 0)
						{
							new flags = GetEntityFlags(client);
							if (flags & FL_ONGROUND)
							{
								SpawnUVLight(client);
								PrintToChat(client, "\x04[Deployables]\x01 Deploying UV Light");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to spawn a UV Light.");
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", UVLightTimer[client]);
						}
					}
					else if (StrContains(name, "High Frequency Emitter", false) != -1)
					{
						if (EmitterTimer[client] <= 0)
						{
							new flags = GetEntityFlags(client);
							if (flags & FL_ONGROUND)
							{
								SpawnEmitter(client);
								PrintToChat(client, "\x04[Deployables]\x01 Deploying High Frequency Emitter");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to spawn a High Frequency Emitter.");
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", EmitterTimer[client]);
						}
					}
					else if (StrContains(name, "Healing Station", false) != -1)
					{
						if (HSTimer[client] <= 0)
						{
							new flags = GetEntityFlags(client);
							if (flags & FL_ONGROUND)
							{
								SpawnHealingStation(client);
								PrintToChat(client, "\x04[Deployables]\x01 Deploying Healing Station");
							}	
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to spawn a Healing Station.");
							}	
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", HSTimer[client]);
						}
					}
					else if (StrContains(name, "Sentry Gun", false) != -1)
					{
						if (SentryTimer[client] <= 0)
						{
							new flags = GetEntityFlags(client);
							if (flags & FL_ONGROUND)
							{
								SpawnSentryGun(client);
								PrintToChat(client, "\x04[Deployables]\x01 Deploying Sentry Gun");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to spawn a Sentry Gun.");
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", SentryTimer[client]);
						}
					}
					else if (StrContains(name, "Resurrection Bag", false) != -1)
					{
						if (RBTimer[client] <= 0)
						{
							new flags = GetEntityFlags(client);
							if (flags & FL_ONGROUND)
							{
								SpawnResurrectionBag(client);
								PrintToChat(client, "\x04[Deployables]\x01 Deploying Resurrection Bag");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to spawn a Resurrection Bag.");
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", RBTimer[client]);
						}
					}
					else if (StrContains(name, "Defense Grid", false) != -1)
					{
						if (DefenseGridTimer[client] <= 0)
						{
							new flags = GetEntityFlags(client);
							if (flags & FL_ONGROUND)
							{
								SpawnDefenseGrid(client);
								PrintToChat(client, "\x04[Deployables]\x01 Deploying Defense Grid");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to spawn a Defense Grid.");
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", DefenseGridTimer[client]);
						}
					}
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You are incapacitated and unable to deploy this.");
				}
			}
			else
			{
				PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be alive to deploy this!");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:AbilitiesMenuFunc(client)
{
	if (client > 0)
	{
		new timer;
		decl String:name[28];
		decl String:text[38];
		new level = cLevel[client];
		new Handle:menu = CreateMenu(AbilitiesHandler);
		Format(text, sizeof(text), "Abilities Menu\n====================");
		SetMenuTitle(menu, text);
		if (level >= 3)
		{
			timer = DetectGZTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Detect Zombie [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Detect Zombie [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 5)
		{
			timer = BerserkerTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Berserker [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Berserker [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 9)
		{
			timer = AcidBathTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Acid Bath [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Acid Bath [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 12)
		{
			timer = LifeStealerTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Lifestealer [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Lifestealer [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 16)
		{
			timer = FlameShieldTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Flameshield [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Flameshield [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 18)
		{
			timer = NightCrawlerTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Nightcrawler [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Nightcrawler [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 23)
		{
			timer = RapidFireTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Rapid Fire [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Rapid Fire [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 25)
		{
			timer = ChainsawMassTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Chainsaw Massacre [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Chainsaw Massacre [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 27)
		{
			timer = HeatSeekerTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Heat Seeker [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Heat Seeker [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 31)
		{
			timer = SpeedFreakTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Speed Freak [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Speed Freak [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 33)
		{
			timer = HealingAuraTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Healing Aura [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Healing Aura [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 37)
		{
			timer = SoulShieldTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Soulshield [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Soulshield [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 39)
		{
			timer = PolyMorphTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Polymorph [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Polymorph [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 46)
		{
			timer = InstaGibTimer[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Instagib [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Instagib [%is]", timer);
				AddMenuItem(menu, name, name);
			}
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public AbilitiesHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[24];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (IsPlayerAlive(client))
			{
				if (!IsPlayerIncap(client) && !IsPlayerHeld(client))
				{
					if (!AbilityActive(client))
					{
						if (StrContains(name, "Detect Zombie", false) != -1)
						{
							if (DetectGZTimer[client] <= 0)
							{
								AbilityDetectGZ(client);
								PrintToChat(client, "\x04[Ability]\x01 Detect Zombie Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", DetectGZTimer[client]);
							}
						}
						else if (StrContains(name, "Berserker", false) != -1)
						{
							if (BerserkerTimer[client] <= 0)
							{
								if (IsMeleeEquipped(client))
								{
									AbilityBerserker(client);
									PrintToChat(client, "\x04[Ability]\x01 Berserker Activated");
								}
								else
								{
									PrintToChat(client,"\x05[Lethal-Injection]\x01 You must have a melee weapon equipped to use this.");
								}
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", BerserkerTimer[client]);
							}
						}
						else if (StrContains(name, "Acid Bath", false) != -1)
						{
							if (AcidBathTimer[client] <= 0)
							{
								AbilityAcidBath(client);
								PrintToChat(client, "\x04[Ability]\x01 Acid Bath Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", AcidBathTimer[client]);
							}
						}
						else if (StrContains(name, "Lifestealer", false) != -1)
						{
							if (LifeStealerTimer[client] <= 0)
							{
								AbilityLifeStealer(client);
								PrintToChat(client, "\x04[Ability]\x01 Lifestealer Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", LifeStealerTimer[client]);
							}
						}
						else if (StrContains(name, "Flameshield", false) != -1)
						{
							if (FlameShieldTimer[client] <= 0)
							{
								AbilityFlameShield(client);
								PrintToChat(client, "\x04[Ability]\x01 Flameshield Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", FlameShieldTimer[client]);
							}
						}
						else if (StrContains(name, "Nightcrawler", false) != -1)
						{
							if (NightCrawlerTimer[client] <= 0)
							{
								AbilityNightCrawler(client);
								PrintToChat(client, "\x04[Ability]\x01 Nightcrawler Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", NightCrawlerTimer[client]);
							}
						}
						else if (StrContains(name, "Rapid Fire", false) != -1)
						{
							if (RapidFireTimer[client] <= 0)
							{
								if (IsM16Equipped(client))
								{
									AbilityRapidFire(client);
									PrintToChat(client, "\x04[Ability]\x01 Rapid Fire Activated");
								}
								else
								{
									PrintToChat(client,"\x05[Lethal-Injection]\x01 You must have an M16 Assault Rifle equipped to use this.");
								}
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", RapidFireTimer[client]);
							}
						}
						else if (StrContains(name, "Chainsaw Massacre", false) != -1)
						{
							if (ChainsawMassTimer[client] <= 0)
							{
								AbilityChainsawMass(client);
								PrintToChat(client, "\x04[Ability]\x01 Chainsaw Massacre Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", ChainsawMassTimer[client]);
							}
						}
						else if (StrContains(name, "Heat Seeker", false) != -1)
						{
							if (HeatSeekerTimer[client] <= 0)
							{
								if (IsGLEquipped(client))
								{
									AbilityHeatSeeker(client);
									PrintToChat(client, "\x04[Ability]\x01 Heat Seeker Activated");
								}
								else
								{
									PrintToChat(client,"\x05[Lethal-Injection]\x01 You must have a Grenade Launcher equipped to use this.");
								}
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", HeatSeekerTimer[client]);
							}
						}
						else if (StrContains(name, "Speed Freak", false) != -1)
						{
							if (SpeedFreakTimer[client] <= 0)
							{
								AbilitySpeedFreak(client);
								PrintToChat(client, "\x04[Ability]\x01 Speed Freak Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", SpeedFreakTimer[client]);
							}
						}
						else if (StrContains(name, "Healing Aura", false) != -1)
						{
							if (HealingAuraTimer[client] <= 0)
							{
								AbilityHealingAura(client);
								PrintToChat(client, "\x04[Ability]\x01 Healing Aura Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", HealingAuraTimer[client]);
							}
						}
						else if (StrContains(name, "Soulshield", false) != -1)
						{
							if (SoulShieldTimer[client] <= 0)
							{
								AbilitySoulShield(client);
								PrintToChat(client, "\x04[Ability]\x01 Soulshield Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", SoulShieldTimer[client]);
							}
						}
						else if (StrContains(name, "Polymorph", false) != -1)
						{
							if (PolyMorphTimer[client] <= 0)
							{
								AbilityPolyMorph(client);
								PrintToChat(client, "\x04[Ability]\x01 Polymorph Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", PolyMorphTimer[client]);
							}
						}
						else if (StrContains(name, "Instagib", false) != -1)
						{
							if (InstaGibTimer[client] <= 0)
							{
								AbilityInstaGib(client);
								PrintToChat(client, "\x04[Ability]\x01 Instagib Activated");
							}
							else
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You have to wait %i seconds to use this again.", InstaGibTimer[client]);
							}
						}
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use more than one ability at a time!");
					}
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You are incapacitated and unable to use this.");
				}
			}
			else
			{
				PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be alive to use this!");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:BombardmentsMenuFunc(client)
{
	if (client > 0)
	{
		new timer;
		decl String:name[26];
		decl String:text[40];
		new level = cLevel[client];
		new Handle:menu = CreateMenu(BombardmentsHandler);
		Format(text, sizeof(text), "Bombardments Menu\n====================");
		SetMenuTitle(menu, text);
		if (level >= 36)
		{
			timer = ArtilleryAmmo[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Artillery Barrage [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Artillery Barrage [Used]");
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 43)
		{
			timer = IonCannonAmmo[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Ion Cannon [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Ion Cannon [Used]");
				AddMenuItem(menu, name, name);
			}
		}
		if (level >= 48)
		{
			timer = NukeAmmo[client];
			if (timer <= 0)
			{
				Format(name, sizeof(name), "Nuclear Strike [Ready]");
				AddMenuItem(menu, name, name);
			}
			else
			{
				Format(name, sizeof(name), "Nuclear Strike [Used]");
				AddMenuItem(menu, name, name);
			}
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public BombardmentsHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[26];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (IsPlayerAlive(client))
			{
				if (!IsPlayerIncap(client) && !IsPlayerHeld(client))
				{
					if (StrContains(name, "Artillery Barrage", false) != -1)
					{
						if (ArtilleryAmmo[client] <= 0)
						{
							if (DisableBombardments == true)
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't use this during the credits.");
							}
							else
							{
								new bombtime = BombardmentsInAction();
								if (bombtime == 0)
								{
									new flags = GetEntityFlags(client);
									if (flags & FL_ONGROUND)
									{
										StartArtillery(client);
										PrintToChat(client, "\x04[Bombardments]\x01 Calling Artillery Barrage.");
										FakeClientCommand(client, "say_team Artillery has been called, take cover!");
									}
									else
									{
										PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to call an Artillery Barrage.");
									}
								}
								else
								{
									PrintToChat(client,"\x05[Lethal-Injection]\x01 There is a bombardment currently active. You have to wait %i seconds until it is finished.", bombtime);
								}
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You can only use this once per campaign.");
						}
					}
					else if (StrContains(name, "Ion Cannon", false) != -1)
					{
						if (IonCannonAmmo[client] <= 0)
						{
							if (DisableBombardments == true)
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't use this during the credits.");
							}
							else
							{
								new bombtime = BombardmentsInAction();
								if (bombtime == 0)
								{
									new flags = GetEntityFlags(client);
									if (flags & FL_ONGROUND)
									{
										StartIonCannon(client);
										PrintToChat(client, "\x04[Bombardments]\x01 Communicating with Ion Cannon Satellite...");
										FakeClientCommand(client, "say_team Ion Cannon Satellite Link Established, Firing Sequence Initiated!");
									}
									else
									{
										PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to signal an Ion Cannon.");
									}
								}
								else
								{
									PrintToChat(client,"\x05[Lethal-Injection]\x01 There is a bombardment currently active. You have to wait %i seconds until it is finished.", bombtime);
								}
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You can only use this once per campaign.");
						}
					}
					else if (StrContains(name, "Nuclear Strike", false) != -1)
					{
						if (NukeAmmo[client] <= 0)
						{
							if (DisableBombardments == true)
							{
								PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't use this during the credits.");
							}
							else
							{
								new bombtime = BombardmentsInAction();
								if (bombtime == 0)
								{
									new flags = GetEntityFlags(client);
									if (flags & FL_ONGROUND)
									{
										StartNuke(client);
										PrintToChat(client, "\x04[Bombardments]\x01 Entering Nuclear Strike Launch Code...");
										FakeClientCommand(client, "say_team Nuclear Strike in 5...");
									}
									else
									{
										PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be on the ground to launch a Nuclear Strike.");
									}	
								}
								else
								{
									PrintToChat(client,"\x05[Lethal-Injection]\x01 There is a bombardment currently active. You have to wait %i seconds until it is finished.", bombtime);
								}
							}
						}
						else
						{
							PrintToChat(client,"\x05[Lethal-Injection]\x01 You can only use this once per campaign.");
						}
					}
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You are incapacitated and unable to use this.");
				}
			}
			else
			{
				PrintToChat(client,"\x05[Lethal-Injection]\x01 You must be alive to use this!");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:SpecialsMenuFunc(client)
{
	if (client > 0)
	{
		decl String:name[22];
		decl String:text[36];
		new level = cLevel[client];
		new Handle:menu = CreateMenu(SpecialsHandler);
		Format(text, sizeof(text), "Specials Menu\n====================");
		SetMenuTitle(menu, text);
		if (level >= 45)
		{
			Format(name, sizeof(name), "Shoulder Cannon Menu");
			AddMenuItem(menu, name, name);
		}
		if (level >= 49)
		{
			Format(name, sizeof(name), "Jetpack Menu");
			AddMenuItem(menu, name, name);
		}
		if (level >= 50)
		{
			Format(name, sizeof(name), "Hats Menu");
			AddMenuItem(menu, name, name);
		}
		Format(name, sizeof(name), "View Attachments");
		AddMenuItem(menu, name, name);
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public SpecialsHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[22];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (StrEqual(name, "Shoulder Cannon Menu", false))
			{
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "Jetpack Menu", false))
			{
				FakeClientCommand(client, "jetpack");
			}
			else if (StrEqual(name, "Hats Menu", false))
			{
				FakeClientCommand(client, "hats");
			}
			else if (StrEqual(name, "View Attachments", false))
			{
				ExternalView(client, 1.3);
				FakeClientCommand(client, "specials");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:ShoulderCannonMenuFunc(client)
{
	if (client > 0)
	{
		decl String:name[34];
		decl String:text[84];
		new cannon = HasCannon(client);
		new enabled = CannonOn[client];
		new equip = CannonEquip[client];
		new nevertarget = CannonNeverTarget[client];
		new targetfirst = CannonTargetFirst[client];
		new Float:cRate = CannonRate[client];
		new Handle:menu = CreateMenu(SCMHandler);
		Format(text, sizeof(text), "Shoulder Cannon Menu\n====================\nAmmo Count: %i\n====================", CannonAmmo[client]);
		SetMenuTitle(menu, text);
		switch(cannon)
		{
			case 0:
			{
				Format(name, sizeof(name), "[ ] Equip Shoulder Cannon");
				AddMenuItem(menu, name, name);
			}
			case 1:
			{
				Format(name, sizeof(name), "[X] Equip Shoulder Cannon");
				AddMenuItem(menu, name, name);
				switch(equip)
				{
					case 0:
					{
						Format(name, sizeof(name), "[ ] Auto Equip Cannon");
						AddMenuItem(menu, name, name);
					}
					case 1:
					{
						Format(name, sizeof(name), "[X] Auto Equip Cannon");
						AddMenuItem(menu, name, name);
					}
				}
				switch(enabled)
				{
					case 0:
					{
						Format(name, sizeof(name), "[ ] Disable Cannon");
						AddMenuItem(menu, name, name);
					}
					case 1:
					{
						Format(name, sizeof(name), "[X] Disable Cannon");
						AddMenuItem(menu, name, name);
					}
				}
				switch(nevertarget)
				{
					case 0:
					{
						Format(name, sizeof(name), "[None] Never Target");
						AddMenuItem(menu, name, name);
					}
					case 1:
					{
						Format(name, sizeof(name), "[Commons] Never Target");
						AddMenuItem(menu, name, name);
					}
					case 2:
					{
						Format(name, sizeof(name), "[Specials] Never Target");
						AddMenuItem(menu, name, name);
					}
					case 3:
					{
						Format(name, sizeof(name), "[Witches] Never Target");
						AddMenuItem(menu, name, name);
					}
					case 4:
					{
						Format(name, sizeof(name), "[Tanks] Never Target");
						AddMenuItem(menu, name, name);
					}
					case 5:
					{
						Format(name, sizeof(name), "[Commons/Specials] Never Target");
						AddMenuItem(menu, name, name);
					}
					case 6:
					{
						Format(name, sizeof(name), "[Commons/Witches] Never Target");
						AddMenuItem(menu, name, name);
					}
					case 7:
					{
						Format(name, sizeof(name), "[Witches/Tanks] Never Target");
						AddMenuItem(menu, name, name);
					}
				}
				switch(targetfirst)
				{
					case 0:
					{
						Format(name, sizeof(name), "[Commons] Target First");
						AddMenuItem(menu, name, name);
					}
					case 1:
					{
						Format(name, sizeof(name), "[Specials] Target First");
						AddMenuItem(menu, name, name);
					}
					case 2:
					{
						Format(name, sizeof(name), "[Witches] Target First");
						AddMenuItem(menu, name, name);
					}
					case 3:
					{
						Format(name, sizeof(name), "[Tanks] Target First");
						AddMenuItem(menu, name, name);
					}
				}
				//PrintToChat(client, "%f", cRate);
				if (cRate == 0.05)
				{
					Format(name, sizeof(name), "[+0.05] Fastest Fire Rate");
					AddMenuItem(menu, name, name);
				}
				else if (cRate == 0.10)
				{
					Format(name, sizeof(name), "[+0.10] Faster Fire Rate");
					AddMenuItem(menu, name, name);
				}
				else if (cRate == 0.15)
				{
					Format(name, sizeof(name), "[+0.15] Default Fire Rate");
					AddMenuItem(menu, name, name);
				}
				else if (cRate == 0.20)
				{
					Format(name, sizeof(name), "[+0.20] Slower Fire Rate");
					AddMenuItem(menu, name, name);
				}
				else if (cRate == 0.25)
				{
					Format(name, sizeof(name), "[+0.25] Slowest Fire Rate");
					AddMenuItem(menu, name, name);
				}
			}
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public SCMHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[34];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "specials");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (StrEqual(name, "[ ] Equip Shoulder Cannon", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						EquipShoulderCannon(client);
						ExternalView(client, 1.3);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't equip this while you are dead.");
					}
					FakeClientCommand(client, "shouldercannon");
				}
			}
			else if (StrEqual(name, "[X] Equip Shoulder Cannon", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						RemoveShoulderCannon(client);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't unequip this while you are dead.");
					}
					FakeClientCommand(client, "shouldercannon");
				}
			}
			else if (StrEqual(name, "[ ] Auto Equip Cannon", false))
			{
				CannonEquip[client] = 1;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[X] Auto Equip Cannon", false))
			{
				CannonEquip[client] = 0;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[ ] Disable Cannon", false))
			{
				CannonOn[client] = 1;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[X] Disable Cannon", false))
			{
				CannonOn[client] = 0;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[None] Never Target", false))
			{
				CannonNeverTarget[client] = 1;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Commons] Never Target", false))
			{
				CannonNeverTarget[client] = 2;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Specials] Never Target", false))
			{
				CannonNeverTarget[client] = 3;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Witches] Never Target", false))
			{
				CannonNeverTarget[client] = 4;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Tanks] Never Target", false))
			{
				CannonNeverTarget[client] = 5;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Commons/Specials] Never Target", false))
			{
				CannonNeverTarget[client] = 6;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Commons/Witches] Never Target", false))
			{
				CannonNeverTarget[client] = 7;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Witches/Tanks] Never Target", false))
			{
				CannonNeverTarget[client] = 0;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Commons] Target First", false))
			{
				CannonTargetFirst[client] = 1;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Specials] Target First", false))
			{
				CannonTargetFirst[client] = 2;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Witches] Target First", false))
			{
				CannonTargetFirst[client] = 3;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[Tanks] Target First", false))
			{
				CannonTargetFirst[client] = 0;
				FakeClientCommand(client, "shouldercannon");
			}
			else if (StrEqual(name, "[+0.05] Fastest Fire Rate", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						CannonRate[client] = 0.25;
						RemoveShoulderCannon(client);
						EquipShoulderCannon(client);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't adjust this while you are dead.");
					}
					FakeClientCommand(client, "shouldercannon");
				}
			}
			else if (StrEqual(name, "[+0.10] Faster Fire Rate", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						CannonRate[client] = 0.05;
						RemoveShoulderCannon(client);
						EquipShoulderCannon(client);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't adjust this while you are dead.");
					}
					FakeClientCommand(client, "shouldercannon");
				}
			}
			else if (StrEqual(name, "[+0.15] Default Fire Rate", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						CannonRate[client] = 0.10;
						RemoveShoulderCannon(client);
						EquipShoulderCannon(client);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't adjust this while you are dead.");
					}
					FakeClientCommand(client, "shouldercannon");
				}
			}
			else if (StrEqual(name, "[+0.20] Slower Fire Rate", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						CannonRate[client] = 0.15;
						RemoveShoulderCannon(client);
						EquipShoulderCannon(client);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't adjust this while you are dead.");
					}
					FakeClientCommand(client, "shouldercannon");
				}
			}
			else if (StrEqual(name, "[+0.25] Slowest Fire Rate", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						CannonRate[client] = 0.20;
						RemoveShoulderCannon(client);
						EquipShoulderCannon(client);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't adjust this while you are dead.");
					}
					FakeClientCommand(client, "shouldercannon");
				}
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:JetPackMenuFunc(client)
{
	if (client > 0)
	{
		decl String:name[24];
		decl String:text[36];
		new jetpack = HasJetPack(client);
		new equip = JetPackEquip[client];
		new Handle:menu = CreateMenu(JetPackHandler);
		Format(text, sizeof(text), "Jetpack Menu\n====================");
		SetMenuTitle(menu, text);
		switch(jetpack)
		{
			case 0:
			{
				Format(name, sizeof(name), "[ ] Equip Jetpack");
				AddMenuItem(menu, name, name);
			}
			case 1:
			{
				Format(name, sizeof(name), "[X] Equip Jetpack");
				AddMenuItem(menu, name, name);
				switch(equip)
				{
					case 0:
					{
						Format(name, sizeof(name), "[ ] Auto Equip Jetpack");
						AddMenuItem(menu, name, name);
					}
					case 1:
					{
						Format(name, sizeof(name), "[X] Auto Equip Jetpack");
						AddMenuItem(menu, name, name);
					}
				}
			}
		}
		Format(name, sizeof(name), "Jetpack Help Menu");
		AddMenuItem(menu, name, name);
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public JetPackHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[24];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "specials");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (StrEqual(name, "[ ] Equip Jetpack", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						EquipJetPack(client);
						ExternalView(client, 1.3);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't equip this while you are dead.");
					}
					FakeClientCommand(client, "jetpack");
				}
			}
			else if (StrEqual(name, "[X] Equip Jetpack", false))
			{
				if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2)
				{
					if (IsPlayerAlive(client))
					{
						RemoveJetPack(client);
					}
					else
					{
						PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't unequip this while you are dead.");
					}
					FakeClientCommand(client, "jetpack");
				}
			}
			else if (StrEqual(name, "[ ] Auto Equip Jetpack", false))
			{
				JetPackEquip[client] = 1;
				FakeClientCommand(client, "jetpack");
			}
			else if (StrEqual(name, "[X] Auto Equip Jetpack", false))
			{
				JetPackEquip[client] = 0;
				FakeClientCommand(client, "jetpack");
			}
			else if (StrEqual(name, "Jetpack Help Menu", false))
			{
				FakeClientCommand(client, "jetpackhelp");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
stock JetPackHelpMenuFunc(client)
{
	if (client > 0)
	{
		new Handle:BuyPanel = CreatePanel();
		SetPanelTitle(BuyPanel, "Jetpack Help Menu");
		DrawPanelText(BuyPanel, "====================");
		DrawPanelText(BuyPanel, "To enable the Jetpack, you must be in a finale event. (Radio Activated)");
		DrawPanelText(BuyPanel, "To fire the rockets, move forward, press jump and hold while in mid air.");
		DrawPanelText(BuyPanel, "To ascend, hold secondary attack. To descend, hold duck.");
		DrawPanelText(BuyPanel, "The Jetpack uses fuel to keep you airbourne. There is a fuel meter display mid-screen.");
		DrawPanelText(BuyPanel, "To recharge the fuel, you have to be on the ground. The fuel will gradually recharge.");
		DrawPanelText(BuyPanel, "====================");
		DrawPanelItem(BuyPanel, "Back");
		SendPanelToClient(BuyPanel, client, JetPackHelpMenuHandler, 40);
		CloseHandle(BuyPanel);
	}
}
public JetPackHelpMenuHandler(Handle:BuyPanel, MenuAction:action, param1, param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(BuyPanel);
	}
    	else if (action == MenuAction_Select) 
	{
		switch(param2)
        	{
            		case 1: //back
            		{
				FakeClientCommand(param1, "jetpack");
			}
		}
	}
}
public Action:HatsMenuFunc(client)
{
	if (client > 0)
	{
		decl String:name[20];
		decl String:text[32];
		new hat = HasHat(client);
		new equip = HatEquip[client];
		new Handle:menu = CreateMenu(HatsHandler);
		Format(text, sizeof(text), "Hats Menu\n====================");
		SetMenuTitle(menu, text);
		Format(name, sizeof(name), "Choose Hat");
		AddMenuItem(menu, name, name);
		switch(hat)
		{
			case 0:
			{
				Format(name, sizeof(name), "[ ] Equip Hat");
				AddMenuItem(menu, name, name);
			}
			case 1:
			{
				Format(name, sizeof(name), "[X] Equip Hat");
				AddMenuItem(menu, name, name);
				switch(equip)
				{
					case 0:
					{
						Format(name, sizeof(name), "[ ] Auto Equip Hat");
						AddMenuItem(menu, name, name);
					}
					case 1:
					{
						Format(name, sizeof(name), "[X] Auto Equip Hat");
						AddMenuItem(menu, name, name);
					}
				}
			}
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public HatsHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[20];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "specials");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (StrEqual(name, "Choose Hat", false))
			{
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "[ ] Equip Hat", false))
			{
				if (IsPlayerAlive(client))
				{
					EquipHat(client);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't equip this while you are dead.");
				}
				FakeClientCommand(client, "hats");
			}
			else if (StrEqual(name, "[X] Equip Hat", false))
			{
				if (IsPlayerAlive(client))
				{
					RemoveHat(client);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't unequip this while you are dead.");
				}
				FakeClientCommand(client, "hats");
			}
			else if (StrEqual(name, "[ ] Auto Equip Hat", false))
			{
				HatEquip[client] = 1;
				FakeClientCommand(client, "hats");
			}
			else if (StrEqual(name, "[X] Auto Equip Hat", false))
			{
				HatEquip[client] = 0;
				FakeClientCommand(client, "hats");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:ChooseHatMenuFunc(client)
{
	if (client > 0)
	{
		decl String:name[20];
		decl String:text[38];
		new Handle:menu = CreateMenu(ChooseHatHandler);
		Format(text, sizeof(text), "Choose Hat Menu\n====================");
		SetMenuTitle(menu, text);
		Format(name, sizeof(name), "Hand Gib");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Boomer Head");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Head Gib");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Circular Saw");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Red Emergency Light");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Alligator");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Mr Mustachio");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Traffic Cone");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Teddy Bear");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Toilet Seat");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Water bottle");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Dock Pylon");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Life Ring");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Construction Light");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Speech Quote");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Smoker Tongue");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Ceiling Fan Blades");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "F-18 Jet Plane");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Civilian Radio");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Riot Faceplate");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Styrofoam Cups");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Television");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Lantern");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Exit Sign");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Garden Hose");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Pink Flamingo");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Money Pile");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Elephant");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Giraffe");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Popcorn Box");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Snake");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Toaster");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Doll");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Hub Cap");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Mannequin Hand");
		AddMenuItem(menu, name, name);
		Format(name, sizeof(name), "Desk Lamp");
		AddMenuItem(menu, name, name);
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public ChooseHatHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[20];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "hats");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (StrEqual(name, "Hand Gib", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 0);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Boomer Head", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 1);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Head Gib", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 2);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Circular Saw", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 3);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Red Emergency Light", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 4);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Alligator", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 5);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Mr Mustachio", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 6);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Traffic Cone", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 7);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Teddy Bear", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 8);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Toilet Seat", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 9);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Water bottle", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 10);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Dock Pylon", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 11);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Life Ring", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 12);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Construction Light", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 13);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Speech Quote", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 14);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Smoker Tongue", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 15);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Ceiling Fan Blades", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 16);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "F-18 Jet Plane", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 17);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Civilian Radio", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 18);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Riot Faceplate", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 19);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Styrofoam Cups", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 20);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Television", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 21);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Lantern", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 22);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Exit Sign", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 23);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Garden Hose", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 24);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Pink Flamingo", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 25);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Money Pile", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 26);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Elephant", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 27);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Giraffe", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 28);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Popcorn Box", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 29);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Snake", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 30);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Toaster", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 31);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Doll", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 32);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Hub Cap", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 33);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Mannequin Hand", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 34);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
			else if (StrEqual(name, "Desk Lamp", false))
			{
				if (IsPlayerAlive(client))
				{
					CreateHat(client, 35);
					ExternalView(client, 1.3);
				}
				else
				{
					PrintToChat(client,"\x05[Lethal-Injection]\x01 You can't create a hat while you are dead.");
				}
				FakeClientCommand(client, "choosehat");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:SentryCtrlMenuFunc(client)
{
	if (client > 0)
	{
		decl String:name[34];
		decl String:text[84];
		new nevertarget = SentryNeverTarget[client];
		new targetfirst = SentryTargetFirst[client];
		new Handle:menu = CreateMenu(SentryCtrlMHandler);
		Format(text, sizeof(text), "Sentry Control Menu\n====================");
		SetMenuTitle(menu, text);
		switch(nevertarget)
		{
			case 0:
			{
				Format(name, sizeof(name), "[None] Never Target");
				AddMenuItem(menu, name, name);
			}
			case 1:
			{
				Format(name, sizeof(name), "[Commons] Never Target");
				AddMenuItem(menu, name, name);
			}
			case 2:
			{
				Format(name, sizeof(name), "[Specials] Never Target");
				AddMenuItem(menu, name, name);
			}
			case 3:
			{
				Format(name, sizeof(name), "[Witches] Never Target");
				AddMenuItem(menu, name, name);
			}
			case 4:
			{
				Format(name, sizeof(name), "[Tanks] Never Target");
				AddMenuItem(menu, name, name);
			}
			case 5:
			{
				Format(name, sizeof(name), "[Commons/Specials] Never Target");
				AddMenuItem(menu, name, name);
			}
			case 6:
			{
				Format(name, sizeof(name), "[Commons/Witches] Never Target");
				AddMenuItem(menu, name, name);
			}
			case 7:
			{
				Format(name, sizeof(name), "[Witches/Tanks] Never Target");
				AddMenuItem(menu, name, name);
			}
		}
		switch(targetfirst)
		{
			case 0:
			{
				Format(name, sizeof(name), "[Commons] Target First");
				AddMenuItem(menu, name, name);
			}
			case 1:
			{
				Format(name, sizeof(name), "[Specials] Target First");
				AddMenuItem(menu, name, name);
			}
			case 2:
			{
				Format(name, sizeof(name), "[Witches] Target First");
				AddMenuItem(menu, name, name);
			}
			case 3:
			{
				Format(name, sizeof(name), "[Tanks] Target First");
				AddMenuItem(menu, name, name);
			}
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public SentryCtrlMHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[34];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (!bNightmare)
		{
			if (StrEqual(name, "[None] Never Target", false))
			{
				SentryNeverTarget[client] = 1;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Commons] Never Target", false))
			{
				SentryNeverTarget[client] = 2;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Specials] Never Target", false))
			{
				SentryNeverTarget[client] = 3;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Witches] Never Target", false))
			{
				SentryNeverTarget[client] = 4;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Tanks] Never Target", false))
			{
				SentryNeverTarget[client] = 5;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Commons/Specials] Never Target", false))
			{
				SentryNeverTarget[client] = 6;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Commons/Witches] Never Target", false))
			{
				SentryNeverTarget[client] = 7;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Witches/Tanks] Never Target", false))
			{
				SentryNeverTarget[client] = 0;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Commons] Target First", false))
			{
				SentryTargetFirst[client] = 1;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Specials] Target First", false))
			{
				SentryTargetFirst[client] = 2;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Witches] Target First", false))
			{
				SentryTargetFirst[client] = 3;
				FakeClientCommand(client, "sentrycontrol");
			}
			else if (StrEqual(name, "[Tanks] Target First", false))
			{
				SentryTargetFirst[client] = 0;
				FakeClientCommand(client, "sentrycontrol");
			}
		}
		else
		{
			PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot use this in Nightmare mode!");
		}
	}
}
public Action:InfoSkillsFunc(client)
{
	if (client > 0)
	{
		new level = cLevel[client];
		new Handle:menu = CreateMenu(InfoSkillsHandler);
		SetMenuTitle(menu, "Skills Information");
		if (level >= 2)
		{
			AddMenuItem(menu, "1", "Acrobatics");
		}
		if (level >= 4)
		{
			AddMenuItem(menu, "1", "Medic");
		}
		if (level >= 6)
		{
			AddMenuItem(menu, "1", "Pack Rat");
		}
		if (level >= 8)
		{
			AddMenuItem(menu, "1", "Desert Cobra");
		}
		if (level >= 10)
		{
			AddMenuItem(menu, "1", "Gene Mutations");
		}
		if (level >= 11)
		{
			AddMenuItem(menu, "1", "Self Revive");
		}
		if (level >= 13)
		{
			AddMenuItem(menu, "1", "Sleight of Hand");
		}
		if (level >= 15)
		{
			AddMenuItem(menu, "1", "Knife");
		}
		if (level >= 17)
		{
			AddMenuItem(menu, "1", "Hard to Kill");
		}
		if (level >= 19)
		{
			AddMenuItem(menu, "1", "Arms Dealer");
		}
		if (level >= 20)
		{
			AddMenuItem(menu, "1", "Gene Mutations II");
		}
		if (level >= 22)
		{
			AddMenuItem(menu, "1", "Surgeon");
		}
		if (level >= 24)
		{
			AddMenuItem(menu, "1", "Extreme Conditioning");
		}
		if (level >= 26)
		{
			AddMenuItem(menu, "1", "BullsEye");
		}
		if (level >= 29)
		{
			AddMenuItem(menu, "1", "Size Matters");
		}
		if (level >= 30)
		{
			AddMenuItem(menu, "1", "Gene Mutations III");
		}
		if (level >= 32)
		{
			AddMenuItem(menu, "1", "Master at Arms");
		}
		if (level >= 35)
		{
			AddMenuItem(menu, "1", "Hardened Stance");
		}
		if (level >= 38)
		{
			AddMenuItem(menu, "1", "Critical Hit!");
		}
		if (level >= 40)
		{
			AddMenuItem(menu, "1", "Gene Mutations IV");
		}
		if (level >= 41)
		{
			AddMenuItem(menu, "1", "Commando");
		}
		if (level >= 44)
		{
			AddMenuItem(menu, "1", "Second Chance");
		}
		if (level >= 47)
		{
			AddMenuItem(menu, "1", "Laser Rounds");
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public InfoSkillsHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:info[1];
	decl String:name[24];
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (StrEqual(name, "Acrobatics", false))
		{
			InfoSubmenu(client, 1);
		}
		else if (StrEqual(name, "Medic", false))
		{
			InfoSubmenu(client, 2);
		}
		else if (StrEqual(name, "Pack Rat", false))
		{
			InfoSubmenu(client, 3);
		}
		else if (StrEqual(name, "Desert Cobra", false))
		{
			InfoSubmenu(client, 4);
		}
		else if (StrEqual(name, "Gene Mutations", false))
		{
			InfoSubmenu(client, 5);
		}
		else if (StrEqual(name, "Self Revive", false))
		{
			InfoSubmenu(client, 6);
		}
		else if (StrEqual(name, "Sleight of Hand", false))
		{
			InfoSubmenu(client, 7);
		}
		else if (StrEqual(name, "Knife", false))
		{
			InfoSubmenu(client, 8);
		}
		else if (StrEqual(name, "Hard to Kill", false))
		{
			InfoSubmenu(client, 9);
		}
		else if (StrEqual(name, "Arms Dealer", false))
		{
			InfoSubmenu(client, 10);
		}
		else if (StrEqual(name, "Gene Mutations II", false))
		{
			InfoSubmenu(client, 11);
		}
		else if (StrEqual(name, "Surgeon", false))
		{
			InfoSubmenu(client, 12);
		}
		else if (StrEqual(name, "Extreme Conditioning", false))
		{
			InfoSubmenu(client, 13);
		}
		else if (StrEqual(name, "BullsEye", false))
		{
			InfoSubmenu(client, 14);
		}
		else if (StrEqual(name, "Size Matters", false))
		{
			InfoSubmenu(client, 15);
		}
		else if (StrEqual(name, "Gene Mutations III", false))
		{
			InfoSubmenu(client, 16);
		}
		else if (StrEqual(name, "Master at Arms", false))
		{
			InfoSubmenu(client, 17);
		}
		else if (StrEqual(name, "Hardened Stance", false))
		{
			InfoSubmenu(client, 18);
		}
		else if (StrEqual(name, "Critical Hit!", false))
		{
			InfoSubmenu(client, 19);
		}
		else if (StrEqual(name, "Gene Mutations IV", false))
		{
			InfoSubmenu(client, 20);
		}
		else if (StrEqual(name, "Commando", false))
		{
			InfoSubmenu(client, 21);
		}
		else if (StrEqual(name, "Second Chance", false))
		{
			InfoSubmenu(client, 22);
		}
		else if (StrEqual(name, "Laser Rounds", false))
		{
			InfoSubmenu(client, 23);
		}
	}
}
public Action:InfoDeployablesFunc(client)
{
	if (client > 0)
	{
		new level = cLevel[client];
		new Handle:menu = CreateMenu(InfoDeployablesHandler);
		SetMenuTitle(menu, "Deployables Information");
		if (level >= 1)
		{
			AddMenuItem(menu, "2", "Ammo Pile");
		}
		if (level >= 7)
		{
			AddMenuItem(menu, "2", "UV Light");
		}
		if (level >= 14)
		{
			AddMenuItem(menu, "2", "High Frequency Emitter");
		}
		if (level >= 21)
		{
			AddMenuItem(menu, "2", "Healing Station");
		}
		if (level >= 28)
		{
			AddMenuItem(menu, "2", "Sentry Gun");
		}
		if (level >= 34)
		{
			AddMenuItem(menu, "2", "Resurrection Bag");
		}
		if (level >= 42)
		{
			AddMenuItem(menu, "2", "Defense Grid");
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public InfoDeployablesHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:info[1];
	decl String:name[24];
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (StrEqual(name, "Ammo Pile", false))
		{
			InfoSubmenu(client, 24);
		}
		else if (StrEqual(name, "UV Light", false))
		{
			InfoSubmenu(client, 25);
		}
		else if (StrEqual(name, "High Frequency Emitter", false))
		{
			InfoSubmenu(client, 26);
		}
		else if (StrEqual(name, "Healing Station", false))
		{
			InfoSubmenu(client, 27);
		}
		else if (StrEqual(name, "Sentry Gun", false))
		{
			InfoSubmenu(client, 28);
		}
		else if (StrEqual(name, "Resurrection Bag", false))
		{
			InfoSubmenu(client, 29);
		}
		else if (StrEqual(name, "Defense Grid", false))
		{
			InfoSubmenu(client, 30);
		}
	}
}
public Action:InfoAbilitiesFunc(client)
{
	if (client > 0)
	{
		new level = cLevel[client];
		new Handle:menu = CreateMenu(InfoAbilitiesHandler);
		SetMenuTitle(menu, "Abilities Information");
		if (level >= 3)
		{
			AddMenuItem(menu, "3", "Detect Zombie");
		}
		if (level >= 5)
		{
			AddMenuItem(menu, "3", "Berserker");
		}
		if (level >= 9)
		{
			AddMenuItem(menu, "3", "Acid Bath");
		}
		if (level >= 12)
		{
			AddMenuItem(menu, "3", "Lifestealer");
		}
		if (level >= 16)
		{
			AddMenuItem(menu, "3", "Flameshield");
		}
		if (level >= 18)
		{
			AddMenuItem(menu, "3", "Nightcrawler");
		}
		if (level >= 23)
		{
			AddMenuItem(menu, "3", "Rapid Fire");
		}
		if (level >= 25)
		{
			AddMenuItem(menu, "3", "Chainsaw Massacre");
		}
		if (level >= 27)
		{
			AddMenuItem(menu, "3", "Heat Seeker");
		}
		if (level >= 31)
		{
			AddMenuItem(menu, "3", "Speed Freak");
		}
		if (level >= 33)
		{
			AddMenuItem(menu, "3", "Healing Aura");
		}
		if (level >= 37)
		{
			AddMenuItem(menu, "3", "Soulshield");
		}
		if (level >= 39)
		{
			AddMenuItem(menu, "3", "Polymorph");
		}
		if (level >= 46)
		{
			AddMenuItem(menu, "3", "Instagib");
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public InfoAbilitiesHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:info[1];
	decl String:name[18];
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (StrEqual(name, "Detect Zombie", false))
		{
			InfoSubmenu(client, 31);
		}
		else if (StrEqual(name, "Berserker", false))
		{
			InfoSubmenu(client, 32);
		}
		else if (StrEqual(name, "Acid Bath", false))
		{
			InfoSubmenu(client, 33);
		}
		else if (StrEqual(name, "Lifestealer", false))
		{
			InfoSubmenu(client, 34);
		}
		else if (StrEqual(name, "Flameshield", false))
		{
			InfoSubmenu(client, 35);
		}
		else if (StrEqual(name, "Nightcrawler", false))
		{
			InfoSubmenu(client, 36);
		}
		else if (StrEqual(name, "Rapid Fire", false))
		{
			InfoSubmenu(client, 37);
		}
		else if (StrEqual(name, "Chainsaw Massacre", false))
		{
			InfoSubmenu(client, 38);
		}
		else if (StrEqual(name, "Heat Seeker", false))
		{
			InfoSubmenu(client, 39);
		}
		else if (StrEqual(name, "Speed Freak", false))
		{
			InfoSubmenu(client, 40);
		}
		else if (StrEqual(name, "Healing Aura", false))
		{
			InfoSubmenu(client, 41);
		}
		else if (StrEqual(name, "Soulshield", false))
		{
			InfoSubmenu(client, 42);
		}
		else if (StrEqual(name, "Polymorph", false))
		{
			InfoSubmenu(client, 43);
		}
		else if (StrEqual(name, "Instagib", false))
		{
			InfoSubmenu(client, 44);
		}
	}
}
public Action:InfoBombardmentsFunc(client)
{
	if (client > 0)
	{
		new level = cLevel[client];
		new Handle:menu = CreateMenu(InfoBombardmentsHandler);
		SetMenuTitle(menu, "Bombardments Information");
		if (level >= 36)
		{
			AddMenuItem(menu, "4", "Artillery Barrage");
		}
		if (level >= 43)
		{
			AddMenuItem(menu, "4", "Ion Cannon");
		}
		if (level >= 48)
		{
			AddMenuItem(menu, "4", "Nuclear Strike");
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public InfoBombardmentsHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:info[1];
	decl String:name[18];
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (StrEqual(name, "Artillery Barrage", false))
		{
			InfoSubmenu(client, 45);
		}
		else if (StrEqual(name, "Ion Cannon", false))
		{
			InfoSubmenu(client, 46);
		}
		else if (StrEqual(name, "Nuclear Strike", false))
		{
			InfoSubmenu(client, 47);
		}
	}
}
public Action:InfoSpecialsFunc(client)
{
	if (client > 0)
	{
		new level = cLevel[client];
		new Handle:menu = CreateMenu(InfoSpecialsHandler);
		SetMenuTitle(menu, "Specials Information");
		if (level >= 45)
		{
			AddMenuItem(menu, "5", "Shoulder Cannon");
		}
		if (level >= 49)
		{
			AddMenuItem(menu, "5", "Jetpack");
		}
		if (level >= 50)
		{
			AddMenuItem(menu, "5", "Hats");
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public InfoSpecialsHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:info[1];
	decl String:name[16];
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (StrEqual(name, "Shoulder Cannon", false))
		{
			InfoSubmenu(client, 48);
		}
		else if (StrEqual(name, "Jetpack", false))
		{
			InfoSubmenu(client, 49);
		}
		else if (StrEqual(name, "Hats", false))
		{
			InfoSubmenu(client, 50);
		}
	}
}
public Action:ResetLevelFunc(client)
{
	if (client > 0)
	{
		new level = cLevel[client];
		new Handle:menu = CreateMenu(ResetLevelHandler);
		SetMenuTitle(menu, "Reset Level");
		if (level == 50)
		{
			AddMenuItem(menu, "6", "Reset Level to 0");
			AddMenuItem(menu, "6", "Reset Level to 10");
			AddMenuItem(menu, "6", "Reset Level to 20");
			AddMenuItem(menu, "6", "Reset Level to 30");
			AddMenuItem(menu, "6", "Reset Level to 40");
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public ResetLevelHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:info[1];
	decl String:name[18];
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (StrEqual(name, "Reset Level to 0", false))
		{
			ResetLvlConfirm(client, 0);
		}
		else if (StrEqual(name, "Reset Level to 10", false))
		{
			ResetLvlConfirm(client, 10);
		}
		else if (StrEqual(name, "Reset Level to 20", false))
		{
			ResetLvlConfirm(client, 20);
		}
		else if (StrEqual(name, "Reset Level to 30", false))
		{
			ResetLvlConfirm(client, 30);
		}
		else if (StrEqual(name, "Reset Level to 40", false))
		{
			ResetLvlConfirm(client, 40);
		}
	}
}
public Action:ResetLvlConfirm(client, lvlchoosen)
{
	if (client > 0)
	{
		new level = cLevel[client];
		new Handle:menu = CreateMenu(ResetLvlConfirmHandler);
		SetMenuTitle(menu, "Reset Level Confirmation");
		if (level == 50)
		{
			if (lvlchoosen == 0)
			{
				AddMenuItem(menu, "Reset 0", "Level 0 Selected. No going back! Are you sure?");
			}
			else if (lvlchoosen == 10)
			{
				AddMenuItem(menu, "Reset 10", "Level 10 Selected. No going back! Are you sure?");
			}
			else if (lvlchoosen == 20)
			{
				AddMenuItem(menu, "Reset 20", "Level 20 Selected. No going back! Are you sure?");
			}
			else if (lvlchoosen == 30)
			{
				AddMenuItem(menu, "Reset 30", "Level 30 Selected. No going back! Are you sure?");
			}
			else if (lvlchoosen == 40)
			{
				AddMenuItem(menu, "Reset 40", "Level 40 Selected. No going back! Are you sure?");
			}
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;	
}
public ResetLvlConfirmHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:info[10];
	decl String:name[48];
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "resetlevel");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (StrEqual(info, "Reset 0", false))
		{
			ResetLevelDB(client, 0);
		}
		else if (StrEqual(info, "Reset 10", false))
		{
			ResetLevelDB(client, 10);
		}
		else if (StrEqual(info, "Reset 20", false))
		{
			ResetLevelDB(client, 20);
		}
		else if (StrEqual(info, "Reset 30", false))
		{
			ResetLevelDB(client, 30);
		}
		else if (StrEqual(info, "Reset 40", false))
		{
			ResetLevelDB(client, 40);
		}
	}
}
stock ResetLevelDB(client, level)
{
	if (IsValidClient(client))
	{
		switch(level)
		{
			case 0: cLevelReset[client] = 1;
			case 10: cLevelReset[client] = 2;
			case 20: cLevelReset[client] = 3;
			case 30: cLevelReset[client] = 4;
			case 40: cLevelReset[client] = 5;
		}
		if (ReadWriteDelay[client] == 0)
		{
			new String:steamid[24];
			GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
			ReadWriteDelay[client] = 1;
			ReadWriteDB(steamid, client, cExp_accum[client], cLevel_accum[client], cVoteAccess_accum[client], cLevelReset[client]);
		}
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && i != client)
			{
				PrintToChat(i, "\x04[LEVEL-DOWN]\x01 Player \x04%N\x01 has reset their level to \x03%i\x01!", client, level);
			}
		}
		PrintToChat(client, "\x04[LEVEL-DOWN]\x01 You have reset your level to \x03%i\x01!", level);
	}
}
stock InfoSubmenu(client, index)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl String:text[300];
		decl String:name[12];
		decl String:menuname[26];
		new Handle:BuyPanel = CreatePanel();
		if (index >= 1 && index <= 23)
		{
			name = "Skill";
			menuname = "Skills Information";
		}
		else if (index >= 24 && index <= 30)
		{
			name = "Deployable";
			menuname = "Deployables Information";
		}
		else if (index >= 31 && index <= 44)
		{
			name = "Ability";
			menuname = "Abilities Information";
		}
		else if (index >= 45 && index <= 47)
		{
			name = "Bombardment";
			menuname = "Bombardments Information";
		}
		else if (index >= 48 && index <= 50)
		{
			name = "Special";
			menuname = "Specials Information";
		}
		SetPanelTitle(BuyPanel, menuname);
		DrawPanelText(BuyPanel, "====================");
		Format(text, sizeof(text), "%s: %s", name, InfoName[index]);
		DrawPanelText(BuyPanel, text);
		DrawPanelText(BuyPanel, "====================");
		Format(text, sizeof(text), "%s", InfoDesc[index]);
		DrawPanelText(BuyPanel, text);
		DrawPanelText(BuyPanel, "====================");
		DrawPanelItem(BuyPanel, "Back");
		if (index >= 1 && index <= 23)
		{
			SendPanelToClient(BuyPanel, client, InfoSubmenuHandler1, 40);
		}
		else if (index >= 24 && index <= 30)
		{
			SendPanelToClient(BuyPanel, client, InfoSubmenuHandler2, 40);
		}
		else if (index >= 31 && index <= 44)
		{
			SendPanelToClient(BuyPanel, client, InfoSubmenuHandler3, 40);
		}
		else if (index >= 45 && index <= 47)
		{
			SendPanelToClient(BuyPanel, client, InfoSubmenuHandler4, 40);
		}
		else if (index >= 48 && index <= 50)
		{
			SendPanelToClient(BuyPanel, client, InfoSubmenuHandler5, 40);
		}
		CloseHandle(BuyPanel);
	}
}
public InfoSubmenuHandler1(Handle:menu, MenuAction:action, client, param1)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		FakeClientCommand(client, "infoskills");
	}
}
public InfoSubmenuHandler2(Handle:menu, MenuAction:action, client, param1)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		FakeClientCommand(client, "infodeployables");
	}
}
public InfoSubmenuHandler3(Handle:menu, MenuAction:action, client, param1)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		FakeClientCommand(client, "infoabilities");
	}
}
public InfoSubmenuHandler4(Handle:menu, MenuAction:action, client, param1)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		FakeClientCommand(client, "infobombardments");
	}
}
public InfoSubmenuHandler5(Handle:menu, MenuAction:action, client, param1)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		FakeClientCommand(client, "infospecials");
	}
}
stock NotificationsMenuFunc(client)
{
	if (client > 0)
	{
		decl String:name[34];
		decl String:text[44];
		new messages = cNotifications[client];
		new critmsgs = CritMessages[client];
		new Handle:menu = CreateMenu(NotificationsHandler);
		Format(text, sizeof(text), "XP Notifications Menu\n====================");
		SetMenuTitle(menu, text);
		if (messages == 0)
		{
			Format(name, sizeof(name), "[ ] Display All XP Messages");
			AddMenuItem(menu, name, name);
		}
		else
		{
			Format(name, sizeof(name), "[X] Display All XP Messages");
			AddMenuItem(menu, name, name);
		}
		if (critmsgs == 0)
		{
			Format(name, sizeof(name), "[X] Display Critical Hit Messages");
			AddMenuItem(menu, name, name);
		}
		else
		{
			Format(name, sizeof(name), "[ ] Display Critical Hit Messages");
			AddMenuItem(menu, name, name);
		}
		SetMenuExitBackButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
}
public NotificationsHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:name[34];
	GetMenuItem(menu, param1, name, sizeof(name), _, name, sizeof(name));
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		if (param1 == MenuCancel_ExitBack)
		{
			FakeClientCommand(client, "menu");
		}
	}
	else if (action == MenuAction_Select)
	{
		if (StrEqual(name, "[ ] Display All XP Messages", false))
		{
			cNotifications[client] = 1;
			NotificationsMenu(client);
		}
		else if (StrEqual(name, "[X] Display All XP Messages", false))
		{
			cNotifications[client] = 0;
			NotificationsMenu(client);
		}
		else if (StrEqual(name, "[X] Display Critical Hit Messages", false))
		{
			CritMessages[client] = 1;
			NotificationsMenu(client);
		}
		else if (StrEqual(name, "[ ] Display Critical Hit Messages", false))
		{
			CritMessages[client] = 0;
			NotificationsMenu(client);
		}
	}
}
//=============================
// VOTING
//=============================
public HasVoteAccess(client, String:voteName[32])
{
	if (client == 0)
	{
		return true;
	}
	else if (strcmp(voteName,"ChangeDifficulty",false) == 0) 
	{
		if (GetUserFlagBits(client) == 0 && cVoteAccess[client] <= 0)
		{
			return false;
		}
	}
	else if (strcmp(voteName,"ChangeMission",false) == 0) 
	{
		if (GetUserFlagBits(client) == 0 && cVoteAccess[client] <= 0)
		{
			return false;
		}
	}
	else if (strcmp(voteName,"RestartGame",false) == 0) 
	{
		if (GetUserFlagBits(client) == 0 && cVoteAccess[client] <= 0)
		{
			return false;
		}
	}
	else if (strcmp(voteName,"Kick",false) == 0) 
	{
		if (GetUserFlagBits(client) == 0 && cVoteAccess[client] <= 0)
		{
			return false;
		}
	}
	else
	{
		if (GetUserFlagBits(client) == 0)
		{
			return false;
		}
	}
	return true;
}
public IsValidVote(String:voteName[])
{
	if ((strcmp(voteName,"Kick",false) == 0) ||
		(strcmp(voteName,"ReturnToLobby",false) == 0) ||
		(strcmp(voteName,"ChangeDifficulty",false) == 0) ||
		(strcmp(voteName,"ChangeMission",false) == 0) ||
		(strcmp(voteName,"RestartGame",false) == 0))
	{
		return true;
	}	
	return false;	
}
public Action:VoteHandler(client, args)
{
	decl String:voteName[32];
	decl String:initiatorName[MAX_NAME_LENGTH];
	GetClientName(client, initiatorName, sizeof(initiatorName));
	GetCmdArg(1,voteName,sizeof(voteName));
	if (GetUserFlagBits(client) == 0 && GetClientTeam(client) == 3)
	{
		PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot start a vote as an infected.");
		return Plugin_Handled;
	}
	if (bVoteInProgress)
	{
		PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot start a vote until the current vote ends.");
		return Plugin_Handled;
	}
	if (!IsValidVote(voteName))
	{
	       	PrintToChat(client,"\x05[Lethal-Injection]\x01 Invalid vote type: %s",voteName);
	       	return Plugin_Handled;
	}
	if (bCowLevel && StrEqual(voteName, "ChangeDifficulty", false))
	{
	       	PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot change the difficulty in the Secret Cow Level!");
	       	return Plugin_Handled;
	}
	else if (bInferno && StrEqual(voteName, "ChangeDifficulty", false))
	{
	       	PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot change the difficulty in Inferno!");
	       	return Plugin_Handled;
	}
	else if (bHell && StrEqual(voteName, "ChangeDifficulty", false))
	{
	       	PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot change the difficulty in Hell!");
	       	return Plugin_Handled;
	}
	else if (bBloodmoon && StrEqual(voteName, "ChangeDifficulty", false))
	{
	       	PrintToChat(client,"\x05[Lethal-Injection]\x01 You cannot change the difficulty in Bloodmoon!");
	       	return Plugin_Handled;
	}
	if (HasVoteAccess(client, voteName))
	{
		if (StrEqual(voteName, "ChangeMission", false))
		{
			bVoteChangeMission = true;
		}
		else if (StrEqual(voteName, "ChangeDifficulty", false))
		{
			bVoteDiffOverride = true;
		}
		else if (StrEqual(voteName, "RestartGame", false))
		{
			bVoteRestartGame = true;
		}
		return Plugin_Continue;		
	}
	else
	{
		PrintToChatAll("\x05[Lethal-Injection]\x01 %N tried to start a %s vote but does not have access", client, voteName);
		return Plugin_Handled;
	}
}
public Action:KickvoteMenu(client, args)
{
	if (client > 0 && IsClientInGame(client))
	{
		decl String:name[32];
		decl String:identifier[32];
		if (GetUserFlagBits(client) == 0 && cVoteAccess[client] <= 0)
		{
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You do not have access to vote kicking.");
			return Plugin_Handled;
		}
		if (bVoteInProgress)
		{
			PrintToChat(client, "\x05[Lethal-Injection]\x01 You cannot start a vote until the current vote ends.");
			return Plugin_Handled;
		}
		new Handle:menu = CreateMenu(KickMenuHandler);
		SetMenuTitle(menu, "Vote kick which player?");
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && client != i && GetUserFlagBits(i) == 0 && !IsFakeClient(i))
			{
				GetClientName(i, name, sizeof(name));
				Format(identifier, sizeof(identifier), "%i", i);
				AddMenuItem(menu, identifier, name);
			}
		}
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, client, 40);
	}
	return Plugin_Handled;
}
public KickMenuHandler(Handle:menu, MenuAction:action, client, param1)
{
	decl String:info[32];
	decl String:name[32];
	new target;
		
	GetMenuItem(menu, param1, info, sizeof(info), _, name, sizeof(name));
	target = StringToInt(info);
	
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Select)
	{
		if (target > 0 && IsClientInGame(target))
		{
			FakeClientCommand(client, "callvote kick %i", GetClientUserId(target));
		}
		else
		{
			PrintToChat(client, "\x05[Lethal-Injection]\x01 Player is no longer available.");
		}
	}
}
public Action:VetoHandler(client, args)
{
	if (!bVoteInProgress) 
	{
		PrintToChat(client, "\x05[Lethal-Injection]\x01 No current vote to veto.");
	}
	else
	{
		Veto();
		PrintToChatAll("\x05[Lethal-Injection]\x01 %N has vetoed this vote.", client);
	}
	return Plugin_Handled;
}
public Veto()
{
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			FakeClientCommandEx(i,"Vote No");
		}
	}
}
public Action:PassVoteHandler(client, args)
{
	if (!bVoteInProgress) 
	{
		PrintToChat(client, "\x05[Lethal-Injection]\x01 No current vote to pass.");
	}
	else
	{
		PassVote();
		PrintToChatAll("\x05[Lethal-Injection]\x01 %N has passed this vote.", client);
	}
	return Plugin_Handled;
}
public PassVote()
{
	for (new i=1;i<=MaxClients;i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			FakeClientCommandEx(i, "Vote Yes");
		}
	}
}
//=============================
//	DATABASE
//=============================
public ConnectDB()
{
	new String:confname[16];
	GetConVarString(hDataBaseName, confname, sizeof(confname));
  	if (SQL_CheckConfig(confname))
  	{
    		new String:error[64];
    		hDataBase = SQL_Connect(confname, true, error, sizeof(error));

	  	if (hDataBase == INVALID_HANDLE)
		{
	    		LogError("Failed to connect to database: %s", error);
		}
	  	else
		{
			InitDB();
		}
  	}
  	else
	{
    		LogError("Database.cfg missing '%s' entry!", confname);
	}
}
public InitDB()
{
  	new String:error[64], String:query[256];
	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s%s",
		"CREATE TABLE IF NOT EXISTS `level50_db` (",
		" `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,",
		" `steamid` VARCHAR(32) NOT NULL,",
		" `exp` INT NOT NULL,",
		" `level` TINYINT NOT NULL,",
		" `vote` TINYINT NOT NULL,",
		" INDEX (`id`),",
		" INDEX (`steamid`))",
		" DEFAULT CHARSET=utf8",
		";"
	);
  	if (!SQL_FastQuery(hDataBase, query))
  	{
    		if (SQL_GetError(hDataBase, error, sizeof(error)))
		{
      			LogError("Failed to create table: %s", error);
		}
    		else
		{
      			LogError("Failed to create table: unknown");
		}
  	}
}
public ReadWriteDB(String:steamid[], client, accumxp, accumlevel, accumvote, lvlreset)
{
	if (hDataBase == INVALID_HANDLE)
	{
		ReadWriteDelay[client] = 0;
		return;
	}
	if (strlen(steamid) > 5)
	{
		new String:query[90];
  		Format(query, sizeof(query), "SELECT id, exp, level, vote FROM level50_db WHERE steamid = '%s'", steamid);

		new Handle:Pack = CreateDataPack();
		WritePackString(Pack, steamid);
		WritePackCell(Pack, client);
		WritePackCell(Pack, accumxp);
		WritePackCell(Pack, accumlevel);
		WritePackCell(Pack, accumvote);
		WritePackCell(Pack, lvlreset);

  		SQL_TQuery(hDataBase, SQLReadWriteDB, query, Pack);
	}
	else
	{
		ReadWriteDelay[client] = 0;
	}
}
public SQLReadWriteDB(Handle:owner, Handle:hndl, const String:error[], any:Pack)
{
	ResetPack(Pack, false);
	decl String:steamid[24];
	ReadPackString(Pack, steamid, sizeof(steamid));
	new client = ReadPackCell(Pack);
	new accumxp = ReadPackCell(Pack);
	new accumlevel = ReadPackCell(Pack);
	new accumvote = ReadPackCell(Pack);
	new lvlreset = ReadPackCell(Pack);
	CloseHandle(Pack);

	if (hndl == INVALID_HANDLE)
	{
		ReadWriteDelay[client] = 0;
		return;
	}
	if (strlen(steamid) > 5)
	{
		new id = 0;
		new xp = 0;
		new level = 0;
		new vote = 0;
		new xptolevel = 0;

		if (SQL_FetchRow(hndl))
		{
			id = SQL_FetchInt(hndl, 0);
			xp = SQL_FetchInt(hndl, 1);
			level = SQL_FetchInt(hndl, 2);
			vote = SQL_FetchInt(hndl, 3);
		}
		if (lvlreset > 0)
		{
			new lvlchoosen = lvlreset;
			switch(lvlchoosen)
			{
				case 1: level = 0;
				case 2: level = 10;
				case 3: level = 20;
				case 4: level = 30;
				case 5: level = 40;
			}
			accumlevel = 0;
			xp = 0;
			accumxp = 0;
			lvlreset = 0;
		}
		else
		{
			new levelupxp = 0;
			xp += accumxp;
			accumxp = 0;
			xptolevel = ExpToLevel(level);
			for (new index=1; index<=10; index++)
			{
				if (level < 50 && xp >= xptolevel)
				{
					levelupxp = xp - xptolevel;
					xp = levelupxp;
					accumlevel += (level + 1);
					if (accumlevel > 0 && (accumlevel > level))
					{
						if (client > 0 && IsClientInGame(client))
						{
							EmitSoundToAll("ui/critical_event_1.wav", client);
							DisplayLevelUp(client, accumlevel);
						}
						level = accumlevel;
						accumlevel = 0;
						levelupxp = 0;
						xptolevel = ExpToLevel(level);
					}
					else if (level == 50)
					{
						xp = 0;
						levelupxp = 0;
						xptolevel = ExpToLevel(level);
					}
				}
			}
			if (accumvote > 0)
			{
				vote = accumvote;
				accumvote = 0;
			}
			else if (accumvote == -1)
			{
				vote = 0;
				accumvote = 0;
			}
		}
		new String:query[128];
		if (SQL_GetRowCount(hndl) > 0)
		{
	  		Format(query, sizeof(query), "UPDATE level50_db SET exp = '%i', level = '%i', vote = '%i' WHERE steamid = '%s'", xp, level, vote, steamid);
		}
		else
		{
	  		Format(query, sizeof(query), "INSERT INTO level50_db (exp, level, vote, steamid) VALUES ('%i', '%i', '%i', '%s')", xp, level, vote, steamid);
		}

		new Handle:NewPack = CreateDataPack();
		WritePackCell(NewPack, id);
		WritePackString(NewPack, steamid);
		WritePackCell(NewPack, client);
		WritePackCell(NewPack, xp);
		WritePackCell(NewPack, level);
		WritePackCell(NewPack, vote);
		SQL_TQuery(hDataBase, SQLReadWriteFinalize, query, NewPack);
	}
	else
	{
		ReadWriteDelay[client] = 0;
	}
	CloseHandle(hndl);
}
public SQLReadWriteFinalize(Handle:owner, Handle:hndl, const String:error[], any:Pack)
{
	if (!IsServerProcessing())
	{
		CloseHandle(Pack);
		CloseHandle(hndl);
	}

	ResetPack(Pack, false);
	new id = ReadPackCell(Pack);
	decl String:steamid[24];
	ReadPackString(Pack, steamid, sizeof(steamid));
	new client = ReadPackCell(Pack);
	new xp = ReadPackCell(Pack);
	new level = ReadPackCell(Pack);
	new vote = ReadPackCell(Pack);
	CloseHandle(Pack);

	if (hndl == INVALID_HANDLE)
	{
		ReadWriteDelay[client] = 0;
		return;
	}
	if (strlen(steamid) > 5)
	{
		if (client > 0 && IsClientConnected(client))
		{
			new String:checksteamid[24];
			GetClientAuthId(client, AuthId_Steam2, checksteamid, sizeof(checksteamid));
			if (StrEqual(steamid, checksteamid, false))
			{
				cID[client] = id;
				cLevel[client] = level;
				cLevel_accum[client] = 0;
				cExp[client] = xp;
				cExp_accum[client] = 0;
				cVoteAccess[client] = vote;
				cVoteAccess_accum[client] = 0;
				cLevelReset[client] = 0;
				cExpToLevel[client] = ExpToLevel(level);
			}
		}
	}
	ReadWriteDelay[client] = 0;
	CloseHandle(hndl);
}
//=============================
// GAMEFRAME
//=============================
public OnGameFrame()
{
	if (!IsServerProcessing()) return;

	if (bMenuOn)
	{
		FrameUpdateClients();
	}
}
//=============================
// TIMER 0.1
//=============================
public Action:TimerUpdate01(Handle:timer)
{
	if (!IsServerProcessing()) return Plugin_Continue;

	if (bMenuOn)
	{
		HealingAuraController();
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2 && PlayerSpawn[i] == 2)
			{
				UpdateHealth(i);
				if (!IsFakeClient(i))
				{
					JetPackEffects(i);
					if (bHealthDisplay && iNumTanks > 0)
					{
						new entity = GetClientAimTarget(i, true);
						if (IsTank(entity))
						{
							new health = GetClientHealth(entity);
							if (health > 0)
							{
								PrintHintText(i, "%N (%i HP)", entity, health);
							}
						}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
//=============================
// TIMER 1.0
//=============================
public Action:TimerUpdate1(Handle:timer)
{
	if (!IsServerProcessing())
	{
		return Plugin_Continue;
	}

	if (bMenuOn)
	{
		iMapTimeTick += 1;

		CustomMapCheck();
		UpdateServerName();
		SpawnHeavies();
		GasCanPlacementTimer();
		TankController();
		SpawnInfectedInterval();
		TimerUpdateClients();
		LoadClipSpawns();
		LoadCheckpoints();
		LoadRescueZone();
		ExecGameModes();
		SRDoorOpen();
		CheckpointReached();
		Announce();
		CreateEvents();
		BotControl();
		HealingAuraHealer();
		QuantifyWeapons();
	}

	return Plugin_Continue;
}
