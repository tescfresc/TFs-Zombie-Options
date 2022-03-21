#using scripts\zm\_zm_weapons;
#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_mod;

function main () {

    level clientfield::register("world", "mw2019weaps", VERSION_SHIP, 1, "int", &tempCallback, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    self waittill("choices_applied");
    applyChoices();


}

function applyChoices() {

    //mw2019
    if(level clientfield::get("mw2019weaps") == 1) {
        //zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_custom_weapons.csv", 1);
    }

}

function tempCallback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump) {
    
}

