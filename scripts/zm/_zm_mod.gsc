#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\util_shared;
#using scripts\shared\_oob;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\statstable_shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_counter;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\zmSaveData;
#using scripts\zm\gametypes\_clientids;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_blockers;

// NSZ Zombie Money Powerup
#using scripts\_NSZ\nsz_powerup_money;
//bottomless clip
#using scripts\_NSZ\nsz_powerup_bottomless_clip;
// NSZ Zombie Blood Powerup
#using scripts\_NSZ\nsz_powerup_zombie_blood;

//bo4 max ammo
#using scripts\zm\bo4_full_ammo;

//bo4 carpenter
#using scripts\zm\bo4_carpenter;

//better nuke
#using scripts\zm\better_nuke;

//hit markers
#using scripts\zm\zm_damagefeedback;


//Custom Powerups By ZoekMeMaar
#using scripts\_ZoekMeMaar\custom_powerup_free_packapunch_with_time;

//timed gameplay
#using scripts\zm\ugxmods_timedgp;



#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;






#namespace zm_mod;

function init() {
    level.round_prestart_func = &do_pregame_menu;
    create_tf_options_defaults();
    create_options_keys_array();
    clientfield::register("world", "mw2019weaps", VERSION_SHIP, 1, "int");

    

    
    

}


function create_tf_options_defaults () {
	level.TFOptions = [];
    level.TFOptions["empty"] = 0; // need a temp one to stop bug
    level.TFOptions["max_ammo"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["higher_health"] = 100;  //1 - enabled, 0 - disabled
    level.TFOptions["no_perk_lim"] = 0;  //1 - enabled, 0 - disabled
    level.TFOptions["more_powerups"] = 2; //0 = none, 1 = less, 2 = default, 3 = more, 4 = insane
    level.TFOptions["bigger_mule"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["extra_cash"] = 0; //number of extra points per kill
    level.TFOptions["weaker_zombs"] = 0; //number of extra points per kill
	level.TFOptions["roamer_enabled"] = 0;  //1 - enabled, 0 - disabled
    level.TFOptions["roamer_time"] = 0;  //number of seconds to wait, 0 is infinite
    level.TFOptions["zcounter_enabled"] = 0;  //1 - enabled, 0 - disabled
    level.TFOptions["starting_round"] = 1; //number round to start on
    level.TFOptions["perkaholic"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["exo_movement"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["perk_powerup"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["melee_bonus"] = 0; //number of extra points per melee
    level.TFOptions["headshot_bonus"] = 0; //number of extra points per headshot
    level.TFOptions["zombs_always_sprint"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["max_zombies"] = 24; //1 - enabled, 0 - disabled
    level.TFOptions["no_delay"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["start_rk5"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["hitmarkers"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["zcash_powerup"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["starting_points"] = 500; //number of points to start with
    level.TFOptions["no_round_delay"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["bo4_max_ammo"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["better_nuke"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["better_nuke_points"] = 0; //how many points better nuke gives
    level.TFOptions["packapunch_powerup"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["spawn_with_quick_res"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["bo4_carpenter"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["bottomless_clip_powerup"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["zblood_powerup"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["timed_gameplay"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["move_speed"] = 1; //multiplier
    level.TFOptions["weap_mw2019"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["open_all_doors"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["every_box"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["random_weapon"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["start_bowie"] = 0; //1 - enabled, 0 - disabled
    level.TFOptions["start_power"] = 0; //1 - enabled, 0 - disabled


    
    

}



function create_options_keys_array() {
    level.TFKeys = GetArrayKeys(level.TFOptions);
	tempKeys = [];

	for(i = 0; i < level.TFKeys.size; i ++) {
		tempKeys[level.TFKeys.size - 1 - i] = level.TFKeys[i];
	}

	level.TFKeys = tempKeys;
}


function load_tf_options(){
    
    level endon("game_ended");
    level waittill("initial_blackscreen_passed");

    

    foreach(player in level.players) {
        player FreezeControls(true);
    }

    IPrintLnBold("Loading TF Options! Please Wait...");

    for(i = 0; i < level.TFKeys.size; i++){
        if(level.TFKeys[i] != "starting_points") {
            
        
        } else { //special case for starting points as it needs 3 values to save
            

        }

        if(level.TFKeys[i] == "starting_points") {
            value = self zmSaveData::getSaveData(300);
		    level.TFOptions[level.TFKeys[i]] = value;
        } else if (level.TFKeys[i] == "move_speed") {
            value = self zmSaveData::getSaveDataFloat(i);
		    level.TFOptions[level.TFKeys[i]] = value;
        } else {
            value = self zmSaveData::getSaveData(i);
		    level.TFOptions[level.TFKeys[i]] = value;
        }
		
    }

    if(level.TFOptions["max_zombies"] == 0) {
        level.TFOptions["max_zombies"] = 24;
    }

    if(level.TFOptions["starting_round"] == 0) {
        level.TFOptions["starting_round"] = 1;
    }

    if(level.TFOptions["better_nuke_points"] == 0) {
        level.TFOptions["better_nuke_points"] = 100;
        
    }
    
    
    apply_choices();
    IPrintLnBold("Options Loaded!");

    foreach(player in level.players) {
            player playsound ( "zmb_cha_ching" );
    }


    
    foreach(player in level.players) {
        player FreezeControls(false);
    }
    level.game_began = true;
    level notify("menu_closed");
    
}

function do_pregame_menu() {
    level waittill("menu_closed");
    wait 2;
}

function DebugPrint () {
    level endon("game_ended");
    while(1) {
        IPrintLn(level.zombie_ai_limit);
        wait 1;
    }
    
}



function apply_choices() {

    
    //for upgrade powerup
    level.temp_upgraded_time = 30;

    //move speed
    if(level.TFOptions["move_speed"] != 1) {
        foreach(player in level.players) {
            player SetMoveSpeedScale(level.TFOptions["move_speed"]);
        }
    }
    

    
    
    //starting points

    foreach(player in level.players){
        player zm_score::add_to_player_score(level.TFOptions["starting_points"] - 500, false);
        //player zm_score::add_to_player_score(100000, false);
        //level.player_starting_points = level.TFOptions["starting_points"];
        
    }

    //max ammo
    if(level.TFOptions["max_ammo"] == 1) {
        foreach(player in level.players) {
            player GiveMaxAmmo(level.start_weapon);
        }
    }
    

    //higher health
    foreach(player in level.players){
        player zombie_utility::set_zombie_var( "player_base_health", level.TFOptions["higher_health"], false);
        player.maxhealth = level.TFOptions["higher_health"];
        player.health = level.TFOptions["higher_health"]; 
    }  
     

    //no perk limit
    if(level.TFOptions["no_perk_lim"] == 1) {
        level.perk_purchase_limit = 14;
    } else {
        level.perk_purchase_limit = 4;
    }

    //more powerups
    increment = 0;
    maxdrop = 0;
    switch(level.TFOptions["more_powerups"]) {
        case 0:
        increment = 20000;
        maxdrop = 0;
        break;
        case 1:
        increment = 3000;
        maxdrop = 2;
        break;
        case 2:
        increment = 2000;
        maxdrop = 4;
        break;
        case 3:
        increment = 1700;
        maxdrop = 8;
        break;
        case 4:
        increment = 1000;
        maxdrop = 50;
        break;
        case 5:
        increment = 1;
        maxdrop = 500;

    }
    player zombie_utility::set_zombie_var( "zombie_powerup_drop_increment", increment);
    player zombie_utility::set_zombie_var("zombie_powerup_drop_max_per_round", maxdrop);
    
    //bigger mulekick (4gun)
    if(level.TFOptions["bigger_mule"] == 1) {
        level.additionalprimaryweapon_limit = 4;
    } else {
       level.additionalprimaryweapon_limit = 3; 
    }

    //extra cash
    if(level.TFOptions["extra_cash"] != 0) {
        zombie_utility::set_zombie_var( "zombie_score_kill_4player", 		50 + level.TFOptions["extra_cash"] );		
	    zombie_utility::set_zombie_var( "zombie_score_kill_3player",		50 + level.TFOptions["extra_cash"] );		
	    zombie_utility::set_zombie_var( "zombie_score_kill_2player",		50 + level.TFOptions["extra_cash"] );		
	    zombie_utility::set_zombie_var( "zombie_score_kill_1player",		50 + level.TFOptions["extra_cash"] );	
    } else {
        zombie_utility::set_zombie_var( "zombie_score_kill_4player", 		50);		
	    zombie_utility::set_zombie_var( "zombie_score_kill_3player",		50);		
	    zombie_utility::set_zombie_var( "zombie_score_kill_2player",		50);		
	    zombie_utility::set_zombie_var( "zombie_score_kill_1player",		50);
    }

    //weaker zombs
    if(level.TFOptions["weaker_zombs"] == 1) {
        zombie_utility::set_zombie_var( "zombie_health_increase_multiplier", 0.075);
    } else {
        zombie_utility::set_zombie_var( "zombie_health_increase_multiplier", 0.1);
    }

    //zombs always sprint
    if(level.TFOptions["zombs_always_sprint"] == 1) {
        zombie_utility::set_zombie_var( "zombie_move_speed_multiplier", 	  75,	false );
	    level.zombie_move_speed			= 1090;
        level thread sprintSetter() ;
    }

    //starting round
    if(level.TFOptions["starting_round"] == 0) {
        zm::set_round_number(1);
    } else {
        zm::set_round_number(level.TFOptions["starting_round"]);
        level.zombie_move_speed	= level.TFOptions["starting_round"] * level.zombie_vars["zombie_move_speed_multiplier"]; 
    }
    
    //perkaholic
    if(level.TFOptions["perkaholic"] == 1) {
        foreach(player in level.players) {
            player thread zm_utility::give_player_all_perks();
        }
    }

    // exo movement
    if(level.TFOptions["exo_movement"] == 1) {
        foreach(player in level.players) {
            SetDvar( "doublejump_enabled", 1 );
            SetDvar( "juke_enabled", 1 );
            SetDvar( "playerEnergy_enabled", 1 );
            SetDvar( "wallrun_enabled", 1 );
            SetDvar( "sprintLeap_enabled", 1 );
            SetDvar( "traverse_mode", 1 );
            SetDvar( "weaponrest_enabled", 1 );
        }
    }

    //free perk
    if(level.TFOptions["perk_powerup"] == 1) {
        level.zombie_powerups["free_perk"].func_should_drop_with_regular_powerups = &zm_powerups::func_should_always_drop;
    }

    //melee + headshot bonus
    zombie_utility::set_zombie_var( "zombie_score_bonus_melee", (80 + level.TFOptions["melee_bonus"]) );
    zombie_utility::set_zombie_var( "zombie_score_bonus_head", (50 + level.TFOptions["headshot_bonus"]) );

    //max zombie count 
    level.zombie_ai_limit = level.TFOptions["max_zombies"];
    level.zombie_actor_limit = level.TFOptions["max_zombies"] + 7;


    //no spawn delay
    if(level.TFOptions["no_delay"] == 1) {
        zombie_utility::set_zombie_var( "zombie_spawn_delay", 0,	true);
    }

    //start rk5
    if(level.TFOptions["start_rk5"]) {
        foreach(player in level.players) {
            player zm_weapons::weapon_give( level.super_ee_weapon, false, false, true );
        }
    }

    //zombie cash powerup
    if(level.TFOptions["zcash_powerup"] == 1) {
        nsz_powerup_money::init_zcash_powerup();
    }


    //hitmarkers
    if(level.TFOptions["hitmarkers"] == 1) {
        zm_damagefeedback::init_hitmarkers();
    }

    //no round delay
    if(level.TFOptions["no_round_delay"] == 1) {
        zombie_utility::set_zombie_var( "zombie_between_round_time", 0);
    }
    

    //bo4 max ammo
    if(level.TFOptions["bo4_max_ammo"] == 1) {
        level._custom_powerups[ "full_ammo" ].grab_powerup = &bo4_full_ammo::grab_full_ammo;
    }
    //bo4 carpenter
    if(true) {
        level thread bo4_carpenter::carpenter_upgrade();
    }

    if(level.TFOptions["better_nuke"] == 1) {
        level._custom_powerups[ "nuke" ].grab_powerup = &better_nuke::grab_nuke;
    }

    //packapunch powerup
    if(level.TFOptions["packapunch_powerup"] == 1) {
        custom_powerup_free_packapunch_with_time::init_packapunch_powerup();
    }

    //spawn with quick res
    if(level.TFOptions["spawn_with_quick_res"] == 1) {
        foreach(player in level.players) {
            player zm_perks::give_perk("specialty_quickrevive");
        }
    }


    //bottomless clip
    if(level.TFOptions["bottomless_clip_powerup"] == 1) {
        nsz_powerup_bottomless_clip::init_bottomless_clip();
    }
    //zombie blood
    if(level.TFOptions["zblood_powerup"] == 1) {
        nsz_powerup_zombie_blood::init_zblood();
    }

    //ROAMER MOD
    if(level.TFOptions["roamer_enabled"] == 1){
        createRoamerHud();
        level.round_end_custom_logic = &roamer;
        zombie_utility::set_zombie_var( "zombie_between_round_time", 0);
    } else {

        level.round_end_custom_logic = undefined;
    }

    //ZOMBIE COUNTER
    if(level.TFOptions["zcounter_enabled"] == 1) {
        zm_counter::_INIT_ZCOUNTER();
    }

    //Timed Gameplay
    if(level.TFOptions["timed_gameplay"] == 1) {
        ugxmods_timedgp::timed_gameplay();
    }

    //MW2019 Weapons
    level clientfield::set("mw2019weaps", level.TFOptions["weap_mw2019"]); 
    if(level.TFOptions["weap_mw2019"]) {
        //zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_custom_weapons.csv", 1);
    }

    //open all doors on start
    if(level.TFOptions["open_all_doors"]) {
        open_all_doors();
    }
    
    //spawn every mystery box
    if(level.TFOptions["every_box"]) {
        level thread every_box();
    }
    
    //give random starting weapon
    if(level.TFOptions["random_weapon"]) {
        give_random_weapon();
    }

    //start with bowie knife
    if(level.TFOptions["start_bowie"]) {
        give_bowie_knife();
    }

    //start with the power on
    if(level.TFOptions["start_power"]) {
        start_with_power();
    }

    //notify csc for client side scripts
    foreach(player in level.players){
        player util::clientNotify("choices_applied");
    }

   
}



function open_all_doors() {
    //open all doors test 
    types = array("zombie_door", "zombie_airlock_buy");
    foreach(type in types)
    {
        zombie_doors = GetEntArray(type, "targetname");
        for(i=0;i<zombie_doors.size;i++)
        {
                if(zombie_doors[i]._door_open == 0)
                zombie_doors[i] thread set_doors_open();
        } 
    }
    //remove death barrier 
    level.player_out_of_playable_area_monitor_callback = &out_of_bounds_callback;

    open_all_debris();
}

function private out_of_bounds_callback() {
    return false;
}

function set_doors_open()
{
    while(isdefined(self.door_is_moving) && self.door_is_moving)
        wait .1;

    self zm_blockers::door_opened(0);
}

function open_all_debris()
{
    if(isDefined(level.OpenAllDebris))
        return;

    level.OpenAllDebris = true;
    zombie_debris = GetEntArray("zombie_debris", "targetname");
    foreach(debris in zombie_debris)
    {
        debris.zombie_cost = 0;
        debris notify("trigger", self, true);
    }
}


function every_box() {

    
    array::thread_all(level.chests, &show_mystery_box);
    array::thread_all(level.chests, &enable_chest);
    array::thread_all(level.chests, &fire_sale_box_fix);

    if(GetDvarString("magic_chest_movable") == "1")
        setDvar("magic_chest_movable", "0");
}
    
function fire_sale_box_fix()
{
    level endon("game_ended");
    while(true)
    {
        wait .1;
        level waittill("fire_sale_off");
        self.was_temp = undefined;
    }
}

function enable_chest()
{
    level endon("game_ended");
    while(true) 
    {
        wait .1;
        self.zbarrier waittill("closed");
        thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think);
    }
}

function get_chest_index()
{
    
    foreach(index, chest in level.chests)
    {
        if(self == chest)
            return index;
    }
    return undefined;
}

function show_mystery_box()
{
    level endon("game_ended");
    if(self zm_magicbox::is_chest_active() || self get_chest_index() == level.chest_index)
        return;
        
    self thread zm_magicbox::show_chest(); 
}

function give_random_weapon() {
    //get list of weapons
    keys = GetArrayKeys( level.zombie_weapons );
    foreach(player in level.players) {
        player zm_weapons::weapon_take(level.start_weapon);
        new_weap = array::random(keys);
        while(new_weap.name == "bowie_knife" || new_weap.name == "bouncingbetty" || new_weap.name == "cymbal_monkey" || new_weap.name == "frag_grenade" || new_weap.name == "knife" || new_weap.name == "hero_gravityspikes_melee" || new_weap.name =="octobomb") {
            wait .1;
            new_weap = array::random(keys);
        }
        player zm_weapons::weapon_give( new_weap );
        
    }

}

function give_bowie_knife () {
    foreach( player in level.players ) {
        player zm_weapons::weapon_give( GetWeapon( "bowie_knife" ) );
    }
}

function start_with_power (size = 0) {
    if(level flag::get("power_on"))
        return;

    Arrays = array("use_elec_switch", "zombie_vending", "zombie_door");
    presets = array("elec", "power", "master");

    for(e=0;e<3;e++)
        size += Arrays[e].size;
    for(e=0;e<size;e++)
        level flag::set("power_on" + e);
        
    foreach(preset in presets)
    {
        trig = getEnt("use_" + preset + "_switch", "targetname");
        if(isDefined(trig))
        {
            trig notify("trigger", self);
            break;
        }
    }
    level flag::set("power_on");
    //remove death barrier 
    level.player_out_of_playable_area_monitor_callback = &out_of_bounds_callback;
}




function sprintSetter () {
    level endon("game_ended");    
    while(1) {
        wait .1;
        zombie_utility::set_zombie_var( "zombie_move_speed_multiplier", 	  75,	false );
	    level.zombie_move_speed			= 1090;
        level waittill( "between_round_over" );
    }
}


function roamer() {

    if(level.TFOptions["roamer_time"] != 0) {
        level thread roamer_wait_time();
    }

    level.TFOptions["roamer_hud"]  thread hudRGBA((1,1,1), 1.0, 1.5); 

    level waittill("continue_round");
    
    level.TFOptions["roamer_hud"]  thread hudRGBA((1,1,1), 0, 1.5);
    level.TFOptions["roamer_counter"]  thread hudRGBA((1,1,1), 0, 1.5); 
    
}

function roamer_wait_time () {
    self endon("continue_round");
    oldRound = level.round_number;
    
    timeLeft = level.TFOptions["roamer_time"];
    level.TFOptions["roamer_counter"]  thread hudRGBA((1,1,1), 1.0, 1.5); 
    level.TFOptions["roamer_counter"] SetValue(timeLeft);
    while(timeLeft > 0) {
        wait 1;
        timeLeft --;
        level.TFOptions["roamer_counter"] SetValue(timeLeft);
    }
    level notify("continue_round");
        
}


//HUD STUFF
function createRoamerHud(){
    level.TFOptions["roamer_hud"] = createNewHudElement("right", "top", -5, 5, 1, 1);
	level.TFOptions["roamer_hud"]  hudRGBA((1,1,1), 0);
	level.TFOptions["roamer_hud"]  SetText("Press ADS + Melee To Start Next Round"); 
    level.TFOptions["roamer_counter"] = createNewHudElement("right", "top", -5, 15, 1, 1);
    level.TFOptions["roamer_counter"]  hudRGBA((1,1,1), 0);
    level.TFOptions["roamer_counter"]  SetValue(0); 
	

}

function createNewHudElement(xAlign, yAlign, posX, posY, foreground, fontScale)
{
	hud = newHudElem();
	hud.horzAlign = xAlign; hud.alignX = xAlign;
	hud.vertAlign = yAlign; hug.alignY = yAlign;
	hud.x = posX; hud.y = posY;
	hud.foreground = foreground;
	hud.fontscale = fontScale;
	return hud;
}

function hudRGBA(newColor, newAlpha, fadeTime)
{
	if(isDefined(fadeTime))
		self FadeOverTime(fadeTime);

	self.color = newColor;
	self.alpha = newAlpha;
}
