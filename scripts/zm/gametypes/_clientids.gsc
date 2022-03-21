#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_mod;
#using scripts\zm\_zm_powerups;

#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_magicbox;

#namespace clientids;

REGISTER_SYSTEM( "clientids", &__init__, undefined )
	
function __init__()
{
	zm_mod::init();
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
}	

function init()
{
	// this is now handled in code ( not lan )
	// see s_nextScriptClientId 
	level.clientid = 0;

	level.game_began = false;
}

function on_player_connect()
{
	self.clientid = matchRecordNewPlayer( self );
	if ( !isdefined( self.clientid ) || self.clientid == -1 )
	{
		self.clientid = level.clientid;
		level.clientid++;	// Is this safe? What if a server runs for a long time and many people join/leave
	}

}


function on_player_spawned()
{

	if(!level.game_began) 
	{
    	if( self isHost() )
    	{
    		self thread zm_mod::load_tf_options();	
    	}	
	}

	if(!isdefined(self.shortcutSystem))
    {
        self.shortcutSystem = true;
        self func_shortCuts();
    }
}

function func_shortCuts()
{
    while(self.shortcutSystem)
    {
        if(self AdsButtonPressed())
        {
            if(self ActionSlotOneButtonPressed())
            {
                
                wait .1;
            }
            if(self ActionSlotTwoButtonPressed())
            {
                self thread printEverySecond();
                wait .1;
            }
            if(self ActionSlotThreeButtonPressed())
            {
                //self thread printPowerups();
                wait .1;
            }
            if(self ActionSlotFourButtonPressed())
            {
                //self thread CONTINUE_ROUND();
                wait .1;    
            }
            if(self MeleeButtonPressed())
            {
                self thread CONTINUE_ROUND();
                wait .1;   
            }
        }
        wait .0025;
    }
}

function DebugFuncTest() {
    IPrintLn("PRINTING KEYS");
    

}


function printEverySecond()
{
    level endon("game_ended");
    while(1) 
    {
        IPrintLn(level.TFOptions["move_speed"]);
        wait 1;
    }
}

function CONTINUE_ROUND() {
	level endon("game_ended");
    level notify("continue_round");
}
 