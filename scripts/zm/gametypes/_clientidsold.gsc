#using scripts\codescripts\struct;
#using scripts\zm\_zm_mod;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\zm\gametypes\_hud_message;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\zm\zmSaveData;
#using scripts\zm\_zm_powerups;


#insert scripts\shared\shared.gsh;

REGISTER_SYSTEM( "clientids", &__init__, undefined )
    
function __init__()
{
	//zm_mod::init();
	//SetDvar("developer", 2);
    callback::on_start_gametype( &init );
    callback::on_connect( &on_player_connect );
    callback::on_spawned( &on_player_spawned );
}

/*
	  __  __          _____ _   _   ______ _    _ _   _  _____ _______ _____ ____  _   _  _____ 
	 |  \/  |   /\   |_   _| \ | | |  ____| |  | | \ | |/ ____|__   __|_   _/ __ \| \ | |/ ____|
	 | \  / |  /  \    | | |  \| | | |__  | |  | |  \| | |       | |    | || |  | |  \| | (___  
	 | |\/| | / /\ \   | | | . ` | |  __| | |  | | . ` | |       | |    | || |  | | . ` |\___ \ 
	 | |  | |/ ____ \ _| |_| |\  | | |    | |__| | |\  | |____   | |   _| || |__| | |\  |____) |
	 |_|  |_/_/    \_\_____|_| \_| |_|     \____/|_| \_|\_____|  |_|  |_____\____/|_| \_|_____/
*/

function init()
{
	level.game_began = false;
    level.clientid = 0;
    level.menu_initialized = 0;
	level.page_offset = [];
	level.menu_controls_menu = -3;
	level.menu_sliderOffsetAlign = -100;
	level.evanescence_y_offset = 25;
	
}



function on_player_connect()
{
    self.clientid = matchRecordNewPlayer( self );
    if ( !isdefined( self.clientid ) || self.clientid == -1 )
    {
        self.clientid = level.clientid;
        level.clientid++;   
    }
}

function on_player_spawned()
{
	if(!level.game_began) {
    	if( self isHost() )
    	{
    		level thread load_tf_options();
			
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
                self thread CONTINUE_ROUND();
                wait .1;
            }
            if(self ActionSlotTwoButtonPressed())
            {
                //self thread spawnPowerUpDebug();
                wait .1;
            }
            if(self ActionSlotThreeButtonPressed())
            {
                //self thread CLOSE_MENU();
                wait .1;
            }
            if(self ActionSlotFourButtonPressed())
            {
                //self thread CLOSE_MENU();
                wait .1;    
            }
        }
        wait .0025;
    }
}

function spawnPowerUpDebug() {
	//IPrintLn("TEST");
	//self PlayLocalSound( "zombie_money_vox" );
	//zm_powerups::special_powerup_drop(self.origin);
}

function CONTINUE_ROUND() {
	level endon("game_ended");
    level notify("continue_round");
}




/*
		  _    _ _______ _____ _      _____ _________     __
		 | |  | |__   __|_   _| |    |_   _|__   __\ \   / /
		 | |  | |  | |    | | | |      | |    | |   \ \_/ / 
		 | |  | |  | |    | | | |      | |    | |    \   /  
		 | |__| |  | |   _| |_| |____ _| |_   | |     | |   
		  \____/   |_|  |_____|______|_____|  |_|     |_|   
*/

function getName()
{
	nT=getSubStr(self.name,0,self.name.size);
	for(i=0;i<nT.size;i++)
	{
		if(nT[i]=="]")
			break;
	}
	if(nT.size!=i)
		nT=getSubStr(nT,i+1,nT.size);
	return nT;
}

function getPlayerFromName( name )
{
	foreach(player in level.players)
	{
		if(player GetName() == name)
		return player;
	}
	return undefined;
}

function get_base_name( weaponname )
{
	split = strtok( weaponname, "_" );
	if( split[0] == "knife" )
	{
		if( split[1] == "_mp" )
			return weaponname;
		return split[0] + "_" + split[1] + "_mp";
	}
	if ( split.size > 1 )
	{
		return split[ 0 ] + "_mp";
	}
	return weaponname;
}

function get_attachments( weaponname )
{
	split = strtok( weaponname, "_" );
	if( split.size < 3 )
		return "NONE";
	if( split[0] == "knife" )
		return "NONE";
	value = "";
	for( i = 1; i < (split.size - 2); i++ )
		value += split[i] + "_";
	value += split[ split.size - 2 ];
	return value;
}

/*
		  _    _ _    _ _____    ______ _    _ _   _  _____ _______ _____ ____  _   _  _____ 
		 | |  | | |  | |  __ \  |  ____| |  | | \ | |/ ____|__   __|_   _/ __ \| \ | |/ ____|
		 | |__| | |  | | |  | | | |__  | |  | |  \| | |       | |    | || |  | |  \| | (___  
		 |  __  | |  | | |  | | |  __| | |  | | . ` | |       | |    | || |  | | . ` |\___ \ 
		 | |  | | |__| | |__| | | |    | |__| | |\  | |____   | |   _| || |__| | |\  |____) |
		 |_|  |_|\____/|_____/  |_|     \____/|_| \_|\_____|  |_|  |_____\____/|_| \_|_____/ 
*/

function createShader(shader, align, relative, x, y, width, height, color, alpha, sort)
{
    ele = newClientHudElem(self);
    ele.elemtype = "icon";
    ele.color = color;
    ele.alpha = alpha;
    ele.sort = sort;
    ele.children = [];
    ele setShader(shader, width, height);
    ele hud::setParent(level.uiParent);
	ele hud::setPoint( align, relative, x, y);
	ele.hideWhenInMenu = true;
	ele.archived = false;
    return ele;
}

function drawText(text, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort)
{
	ele = self hud::createFontString(font, fontScale);
	ele hud::setParent(level.uiParent);
    ele hud::setPoint( align, relative, x, y);
	ele.sort = sort;
	ele.alpha = alpha;
	ele setSafeText(text);
	if(text == "SInitialization")
		ele.foreground = true;
	ele.hideWhenInMenu = true;
	ele.archived = false;
	return ele;
}

function setSafeText(text)
{
	/*
	if( !isinarray(level.uniquestrings, text ) )
	{
		level.uniquestrings =  array::add  (level.uniquestrings, text, 0 );
		level notify("textset");
	}
	*/
	self setText(text);
}

/*
		  __  __ ______ _   _ _    _    ____  _____ _______ _____ ____  _   _  _____ 
		 |  \/  |  ____| \ | | |  | |  / __ \|  __ \__   __|_   _/ __ \| \ | |/ ____|
		 | \  / | |__  |  \| | |  | | | |  | | |__) | | |    | || |  | |  \| | (___  
		 | |\/| |  __| | . ` | |  | | | |  | |  ___/  | |    | || |  | | . ` |\___ \ 
		 | |  | | |____| |\  | |__| | | |__| | |      | |   _| || |__| | |\  |____) |
		 |_|  |_|______|_| \_|\____/   \____/|_|      |_|  |_____\____/|_| \_|_____/ 
*/

///Functions:
///			CreateMain( title )																								--This is the main menu
///			AddOption( "Title", ::Function, arg1, arg2, arg3, arg4, arg5 );													--This is to add a option to the menu
///			AddPlayerOption("Title", ::Function, arg1, arg2, arg3, arg4);													--This is to add a player option to the menu. The player will call the function instead of you!
///			AddSliderInt( "Title", defaultValue, minvalue, maxvalue, Increment, ::Onchanged, arg2, arg3, arg4, arg5);		--This is to add a slider to your menu. OnChanged is passed the new value in parameter 1 (Example: OnChanged( newvalue, other params... ) )
///			AddSliderBool("Title", ::OnChanged, arg1, arg2, arg3, arg4, arg5 );												--This is to add a slider to your menu. OnChanged must return true or false!
///			AddSliderList("Title", strings[], ::OnChanged, arg2, arg3, arg4, arg5 );										--This is to add a slider to your menu. OnChanged is passed the new string as parameter 1
///			SetCVar("Variable");																							--This is to set a variable in your menu
///			GetCVar("Variable");																							--This is to get a variable's value from your menu
///			GetCBool("Variable");																							--This will get a boolean variable from your variable list
///			Toggle("Variable");																								--This will toggle a variable in your menu and return the result
///			AddSubMenu( "Title", AccessLevel );																				--This is to add a submenu
///			EndSubMenu(); 																									--This is to close off the current submenu. You must call this each time you exit a sub menu
///			AddPlayersMenu( title, access )																					--This is a special function to add a players menu to your menu
///			AddPlayerSliderInt( "Title", defaultValue, minvalue, maxvalue, Increment, ::Onchanged, arg2, arg3, arg4, arg5);	--This is to add a slider to your menu. OnChanged is passed the new value in parameter 2 (Example: OnChanged( player, newvalue, other params... ) )
///			AddPlayerSliderBool("Title", ::OnChanged, arg1, arg2, arg3, arg4, arg5 );										--This is to add a slider to your menu. OnChanged must return true or false!
///			AddPlayerSliderList("Title", strings[], ::OnChanged, arg2, arg3, arg4, arg5 );									--This is to add a slider to your menu. OnChanged is passed the new string as parameter 2
///			EndPlayersMenu();																								--This is a special function to end your players menu
///
///			Note: Pages are automatically added for you. No need to worry about scroll.	
///			Note: Do not use any sliders in the main menu. They will not load properly.
///			Warning: Do not reference level.Evanescence.options or level.Evanescence. You will freeze. Use the provided functions instead.
function MakeOptions()
{
	CreateMain( "TFs Zombie Options" );
		AddSubMenu("Game Options", 1);
			AddSliderList("Starting Points", strtok("0,500 (Default),1000,3000,5000",","), &StartingPoints);
			AddSliderBool("Start Out with Max Ammo", &MaxAmmoEnable);
			AddSliderList("Hits Until Downed", strtok("1 Hit,2 Hits,3 Hits (Default),4 Hits,5 Hits",","), &HigherPlayerHealth);
			AddSliderBool("Remove Perk Limit", &RemovePerkLimit);
			AddSliderList("Amount of Powerups per Round", strtok("None,Less,Default,More,Insane", ","), &MorePowerUps);
			AddSliderBool("4 Gun Mulekick", &BiggerMuleKick);
			AddSliderList("More Cash Per Kill", strtok("OFF,+10,+20,+30,+40,+50,+60,+70,+80,+90,+100",","), &MoreCash);
			AddSliderBool("Weaker Zombies on Higher Rounds", &WeakerZombs);
		    //AddSliderBool("Less Zombies on Higher Rounds", &LessZombs);
			
			
			
			
		EndSubMenu();
		AddSubMenu( "Roamer Options", 1 );
			AddSliderBool("Roamer Mod", &RoamerModToggle);
			AddSliderList("Time Between Rounds", strtok("Inf,30Sec,1Min,2Min,5Min",","), &RoamerTime);
			
			//AddSliderInt( "SPEED SCALE", 1, 0, undefined, 1, &SetSelfSpeed);
			//AddSliderBool("BIND NO CLIP", &EnigmaBool, 8);
			//AddSliderBool("INVISIBILITY", &EnigmaBool, 5);
			//AddSliderBool("ALL PERKS", &EnigmaBool, 6);
			//AddSliderBool("THIRD PERSON", &EnigmaBool, 7);
		EndSubMenu();
		AddSubMenu( "Zombie Counter Options" );
			AddSliderBool("Zombie Counter", &ZCounterToggle);
		EndSubMenu();
		//AddPlayersMenu("PLAYERS MENU", 3);
		//	AddPlayerSliderBool("GODMODE", &GodModeToggle);
		//	AddSubMenu("VERIFICATION", 3);
		//		AddPlayerOption("UNVERIFY", &SetAccess, 0);
		//		AddPlayerOption("VERIFIED", &SetAccess, 1);
		//		AddPlayerOption("ELEVATED", &SetAccess, 2);
		//		AddPlayerOption("COHOST", &SetAccess, 3);
		//	EndSubMenu();
		//EndPlayersMenu();
		//AddOption("Reset All To Default", &ResetValues);
		AddOption("Close Menu & Start Game", &CloseMenu);
}

function WelcomeMessage()
{
	self iprintlnbold( "WELCOME TO THE MENU!" );
	self iprintln("Welcome. Press [{+actionslot 1}] to open the menu!");
}

function ControlMonitor()
{
	self endon("disconnect");
	self endon("VerificationChange");
	Menu = self GetMenu();
	Buttons = ArrayCopy(Menu.preferences.controlscheme);
	CLOSED = -1;
	MAIN = 0;
	oldmenu = -1;
	self freezecontrols( false );
	if(self isHost()) {
		Menu.currentmenu = MAIN;
		self UpdateMenu( true );
	}
	
	while( 1 )
	{
		if( !isAlive( self ) )
		{
			oldmenu = Menu.currentmenu;
			Menu.currentmenu = CLOSED;
			self UpdateMenu();
			while( !isAlive( self ) )
				wait 1;
			if( oldmenu != CLOSED )
			{
				Menu.currentmenu = oldmenu;
				self UpdateMenu( true );
			}
		}
		//open menu with action key 1
		if( self ActionSlotOneButtonPressed() && Menu.currentmenu == CLOSED)
		{
			//Menu.currentmenu = MAIN;
			//self UpdateMenu( true );
			//while( self IsButtonPressed( Buttons[0] ) )
			//	wait .05;
		}

		else if( self IsButtonPressed( Buttons[5] ) && Menu.currentmenu == MAIN )
		{
			//self PlayLocalSound("uin_main_exit");
			//Menu.currentmenu = CLOSED;
			//UpdateMenu();
			//zm_mod::apply_choices();
			//level notify("menu_closed");
			//while( self IsButtonPressed( Buttons[5] ) )
			//	wait .05;
		}
		else if( self IsButtonPressed( Buttons[5] ) && Menu.currentmenu != CLOSED )
		{
			self PlayLocalSound("uin_main_exit");//TODO
			Menu.currentmenu = level.Evanescence.options[ Menu.currentmenu ].parentmenu;
			UpdateMenu();
			while( self IsButtonPressed( Buttons[5] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[7] ) )
		{
			UpdateMenu();
			if( Menu.text.size > 1 )
			{
				Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
				self PlayLocalSound("cac_grid_nav");
				if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] notify("Deselected");
				}
				if( Menu.CurrentMenu != level.si_players_menu )
				{
					if( Menu.cursors[ Menu.CurrentMenu ] < 1 )
					{
						Menu.cursors[ Menu.CurrentMenu ] = ( level.Evanescence.options[ Menu.CurrentMenu ].options.size - 1 );		
					}
					else
						Menu.cursors[ Menu.CurrentMenu ]--;
				}
				else
				{
					if( Menu.cursors[ Menu.CurrentMenu ] < 1 )
					{
						Menu.cursors[ Menu.CurrentMenu ] = ( level.players.size - 1 );		
					}
					else
						Menu.cursors[ Menu.CurrentMenu ]--;
				}
				Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
				if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] thread SelectedOption( self );
				}
			}
			while( self IsButtonPressed( Buttons[7] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[6] ) && Menu.currentmenu != CLOSED )
		{
			UpdateMenu();
			if( Menu.text.size > 1 )
			{
				self PlayLocalSound("cac_grid_nav");
				if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] notify("Deselected");
				}
				Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
				if( Menu.CurrentMenu != level.si_players_menu )
				{
					if( Menu.cursors[ Menu.CurrentMenu ] >= ( level.Evanescence.options[ Menu.CurrentMenu ].options.size - 1 ) )
					{
						Menu.cursors[ Menu.CurrentMenu ] = 0;		
					}
					else
						Menu.cursors[ Menu.CurrentMenu ]++;
				}
				else
				{
					if( Menu.cursors[ Menu.CurrentMenu ] >= ( level.players.size - 1 ) )
					{
						Menu.cursors[ Menu.CurrentMenu ] = 0;		
					}
					else
						Menu.cursors[ Menu.CurrentMenu ]++;
				}
				Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
				if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] thread SelectedOption( self );
				}
			}
			while( self IsButtonPressed( Buttons[6] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[4] ) && Menu.currentmenu != CLOSED)
		{
			if( !isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) ) {
				self thread PerformOption();
			} else {
				self thread Slider( 1 );
			}

			//IPrintLn("Current Menu: " + Menu.currentmenu + "Option: " + Menu.cursors[ Menu.currentMenu ]);
			while( self IsButtonPressed( Buttons[4] ) )
				wait .05;
		}
		//else if( self IsButtonPressed( Buttons[2] ) && Menu.currentmenu != CLOSED)
		//{
		//	self thread Slider( -1 );
		//	while( self IsButtonPressed( Buttons[2] ) )
		//		wait .05;
		//}
		else if( self IsButtonPressed( Buttons[2] ) && Menu.currentmenu != CLOSED)
		{
			NextPage();
			while( self IsButtonPressed( Buttons[2] ) )
				wait .05;
		}
		else if( self IsButtonPressed( Buttons[3] ) && Menu.currentmenu != CLOSED)
		{
			PreviousPage();
			while( self IsButtonPressed( Buttons[3] ) )
				wait .05;
		}
		//else if( self IsButtonPressed( Buttons[4] ) && Menu.currentmenu != CLOSED)
		//{
		//	self thread Slider( 1 );
		//	while( self IsButtonPressed( Buttons[4] ) )
		//		wait .05;	
		//}
		wait .05;
	}
	CloseMenu();
}


/*
		  __  __   ______   _   _   _    _     ______   _    _   _   _    _____   _______   _____    ____    _   _    _____ 
		 |  \/  | |  ____| | \ | | | |  | |   |  ____| | |  | | | \ | |  / ____| |__   __| |_   _|  / __ \  | \ | |  / ____|
		 | \  / | | |__    |  \| | | |  | |   | |__    | |  | | |  \| | | |         | |      | |   | |  | | |  \| | | (___  
		 | |\/| | |  __|   | . ` | | |  | |   |  __|   | |  | | | . ` | | |         | |      | |   | |  | | | . ` |  \___ \ 
		 | |  | | | |____  | |\  | | |__| |   | |      | |__| | | |\  | | |____     | |     _| |_  | |__| | | |\  |  ____) |
		 |_|  |_| |______| |_| \_|  \____/    |_|       \____/  |_| \_|  \_____|    |_|    |_____|  \____/  |_| \_| |_____/ 

*/







/*
	  __  __   ______   _   _   _    _      _____   _______   _____    _    _    _____   _______   _    _   _____    ______ 
	 |  \/  | |  ____| | \ | | | |  | |    / ____| |__   __| |  __ \  | |  | |  / ____| |__   __| | |  | | |  __ \  |  ____|
	 | \  / | | |__    |  \| | | |  | |   | (___      | |    | |__) | | |  | | | |         | |    | |  | | | |__) | | |__   
	 | |\/| | |  __|   | . ` | | |  | |    \___ \     | |    |  _  /  | |  | | | |         | |    | |  | | |  _  /  |  __|  
	 | |  | | | |____  | |\  | | |__| |    ____) |    | |    | | \ \  | |__| | | |____     | |    | |__| | | | \ \  | |____ 
	 |_|  |_| |______| |_| \_|  \____/    |_____/     |_|    |_|  \_\  \____/   \_____|    |_|     \____/  |_|  \_\ |______|
*/

function InitializeMenu()
{
	level.MAX_VERIFICATION = 4;
	level.menuHudCounts = [];
	level.Evanescence = spawnstruct();
	level.Evanescence.Options = [];
	level.Evanescence.Menus = [];
	level.Evanescence.ClientVariables = [];
	level.si_current_menu = 0;
	level.si_next_menu = 0;
	level.si_players_menu = -2;
	level.si_previous_menus = [];
	MakeOptions();
	GetHost() CreateMenu( 4 );
	VerifyDvarListedPlayers();
	level.menu_initialized = 1;
}

function GetHost()
{
	foreach( player in level.players )
		if( player isHost() )
			return player;
}

function VerificationMonitor()
{
	self endon("spawned_player");
	self waittill("VerificationChange", verification);
	self DeleteMenu();
	if( verification > 0 )
	{
		self CreateMenu( verification );
		self LoadMenu();
	}
	self thread VerificationMonitor();
}

function LoadMenu()
{
	if( GetAccess() < 1 )
		return;
	self thread WelcomeMessage();
	self thread ControlMonitor();
}

function DeleteMenu()
{
	Menu = self GetMenu();
	Menu.Title destroy();
	Menu.bg Destroy();
	foreach( elem in Menu.text )
		elem Destroy();
	foreach( elem in Menu.sliders )
		elem destroy();
	Menu Delete();
	self setBlur( 0, .1);
}

function GetMenu()
{
	return level.Evanescence.Menus[ self GetName() ];
}

function GetAccess()
{
	if( !isDefined(GetMenu()) )
		return 0;
	return GetMenu().access;
}

function CreateDefaultMenu()
{
	struct = spawnstruct();
	struct.access = 1;
	struct.cursors = [];
	struct.currentmenu = -1;
	struct.selectedplayer = undefined;
	struct.preferences = spawnstruct();
	struct.preferences.bg = (0,0,0);
	struct.preferences.highlight = (1,.5,0);
	struct.preferences.text = (1,1,1);
	struct.preferences.title = (1,1,1);
	struct.preferences.freezecontrols = true;
	struct.preferences.controlscheme = [];
	struct.preferences.controlscheme = strtok("[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}]",",");
	struct = LoadUserPreferences( self GetName(), struct );
	struct.bg = self createShader("white", "CENTER", "CENTER", 0, 0, 1920, 1920, struct.preferences.bg, 0, 0);
	struct.text = [];
	struct.sliders = [];
	return struct;
}

function LoadUserPreferences( playername, struct )
{
	if( !isDefined( GetDvarString( playername + "EPreferences" ) ) || GetDvarString( playername + "EPreferences" ) == "" )
	{
		SetDvar( playername + "EPreferences", "0,0,0;255,128,0;255,255,255;255,255,255;1;[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}]" ); //Default Prefs
		return struct;
	}
	dvar = GetDvarString( playername + "EPreferences" );
	prefs = [];
	bg = [];
	highlight = [];
	text = [];
	title = [];
	prefs = strtok( dvar, ";" );
	bg = strtok( prefs[0], "," );
	struct.preferences.bg = [];
	struct.preferences.bg = ( (Int( bg[0] ) / 255.0), ( Int( bg[1] ) / 255.0 ), ( Int( bg[2] ) / 255.0 ) );
	highlight = strtok( prefs[1], "," );
	struct.preferences.highlight = [];
	struct.preferences.highlight = ( (Int( highlight[0] ) / 255.0), ( Int( highlight[1] ) / 255.0 ), ( Int( highlight[2] ) / 255.0 ) );
	text = strtok( prefs[2], "," );
	struct.preferences.text = [];
	struct.preferences.text = ( (Int( text[0] ) / 255.0), ( Int( text[1] ) / 255.0 ), ( Int( text[2] ) / 255.0 ) );
	title = strtok( prefs[3], "," );
	struct.preferences.title = [];
	struct.preferences.title = ( (Int( title[0] ) / 255.0), ( Int( title[1] ) / 255.0 ), ( Int( title[2] ) / 255.0 ) );
	struct.preferences.freezecontrols = Int( prefs[4] );
	struct.preferences.controlscheme = [];
	struct.preferences.controlscheme = strtok( prefs[5], "," );
	return struct;
}

function SetUserPreferences( playername, prefindex, value )
{
	if( !isDefined( GetDvarString( playername + "EPreferences" ) ) || GetDvarString( playername + "EPreferences" ) == "" )
	{
		SetDvar( playername + "EPreferences", "0,0,0;255,128,0;255,255,255;255,255,255;1;[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}]" ); //Default Prefs to be safe
	}
	dvar = GetDvarString( playername + "EPreferences" );
	prefs = [];
	prefs = strtok( dvar, ";" );
	prefs[ prefindex ] = value;
	dvar = "";
	for( i = 0; i < prefs.size - 1; i++ )
		dvar += prefs[i] + ";";
	dvar += prefs[ prefs.size - 1 ];
	SetDvar( playername + "EPreferences", dvar );
}

function CreateMenu( verification )
{
	level.Evanescence.Menus[ self GetName() ] = self CreateDefaultMenu();
	level.Evanescence.Menus[ self GetName() ].access = verification;
}

function CloseMenu()
{
	Menu = self GetMenu();
	Menu.currentmenu = -1;
	UpdateMenu();
	zm_mod::apply_choices();
	level notify("menu_closed");
	level.game_began = true;
	DeleteMenu();

}

function AddOption(title, function_name, arg1 = undefined, arg2 = undefined, arg3 = undefined, arg4 = undefined, arg5 = undefined)
{
	level.menuHudCounts[ level.si_current_menu ]++;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function_name = function_name;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = arg1;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
}

function AddPlayerOption( title, function_name, arg1 = undefined, arg2 = undefined, arg3 = undefined, arg4 = undefined )
{
	AddOption(title, &playerwrapperfunction, function_name, arg1, arg2, arg3, arg4);
}

function PlayerWrapperFunction( function_name, arg1 = undefined, arg2 = undefined, arg3 = undefined, arg4 = undefined )
{
	Menu = self getMenu();
	Menu.selectedplayer thread [[ function_name ]]( arg1, arg2, arg3, arg4 );
}

function AddSubMenu(title, access)
{
	level.menuHudCounts[ level.si_current_menu ]++;
	CheckHuds();
	level.si_previous_menus[level.si_previous_menus.size] = level.si_current_menu;
	parentmenu = level.Evanescence.options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function_name = &submenu;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	level.si_next_menu++;
	parentmenu.options[parentmenu.options.size - 1].arg1 = level.si_next_menu;
	parentmenu.options[parentmenu.options.size - 1].arg2 = access;
	struct = spawnstruct();
	struct.options = [];
	struct.pages = [];
	struct.title = title;
	struct.parentmenu = level.si_current_menu; 
	level.Evanescence.options[level.si_next_menu] = struct;
	level.si_current_menu = level.si_next_menu;
	level.menuHudCounts[ level.si_current_menu ] = 0;
}

function CyclePage()
{
	parentmenu = level.Evanescence.options[level.si_current_menu];
	parentmenu.pages[parentmenu.pages.size] = spawnstruct();
	parentmenu.pages[parentmenu.pages.size - 1].title = parentmenu.title;
	parentmenu.pages[parentmenu.pages.size - 1].pageprevious = level.si_current_menu;
	parentmenu.pages[parentmenu.pages.size - 1].function_name = &pagenext;
	level.si_next_menu++;
	parentmenu.pages[parentmenu.pages.size - 1].arg1 = level.si_next_menu;
	parentmenu.pages[parentmenu.pages.size - 1].arg2 = parentmenu.access;
	struct = spawnstruct();
	struct.options = [];
	struct.pages = [];
	struct.isPage = 1;
	struct.title = parentmenu.title;
	struct.pageprevious = level.si_current_menu;
	struct.parentmenu = parentmenu.parentmenu; 
	level.Evanescence.options[level.si_next_menu] = struct;
	level.si_current_menu = level.si_next_menu;
	level.menuHudCounts[ level.si_current_menu ] = 0;
}

function submenu( child , access)
{
	Menu = self GetMenu();
	if(Menu.access < access)
	{
		self PlayLocalSound("uin_cmn_deny");//TODO
		return;
	}
	Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
	self PlayLocalSound("cac_grid_equip_item");
	Menu.currentMenu = child;
	if(Menu.currentMenu == level.si_players_menu)
		Menu.selectedPlayer = level.players[ Menu.cursors[ Menu.currentmenu ] ];
	Menu.cursors[ Menu.CurrentMenu ] = 0;
	UpdateMenu();
}

function PageNext( child, access )
{
	Menu = self GetMenu();
	Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
	self PlayLocalSound("cac_grid_equip_item");
	Menu.currentMenu = child;
	Menu.cursors[ Menu.CurrentMenu ] = 0;
	//Slide anim
	foreach( slider in Menu.sliders )
	{
		slider moveovertime( .15 );
		slider.x -= 720;
	}
	foreach( text in Menu.text )
	{
		text moveovertime( .15 );
		text.x -= 720;
	}
	wait .15;
	foreach( slider in Menu.sliders )
		slider destroy();
	foreach( text in Menu.text )
		text destroy();
	Menu.text = [];
	Menu.sliders = [];
	self UpdateMenu( 0, 1, 720 );	
}

function AddPlayersMenu( title, access )
{
	AddSubMenu( title, access );
	level.si_players_menu = level.si_current_menu;
	for(i=0;i<17;i++)
	{
		AddSubMenu("Undefined", access);
		EndPlayersSubMenu();
	}
	AddSubMenu("PLAYER", access);
}

function CreateMain( title )
{
	struct = spawnstruct();
	struct.options = [];
	struct.title = title;
	struct.parentmenu = -1;
	struct.pages = [];
	level.menuHudCounts[0] = 0;
	level.Evanescence.options[0] = struct;
}

function EndPlayersMenu()
{
	EndSubMenu();
	EndSubMenu();
}

function EndPlayersSubMenu()
{
	level.si_next_menu--;
	EndSubMenu();
}

function EndSubMenu()
{
	if(level.si_previous_menus.size < 1)
		return;
	level.si_current_menu = level.si_previous_menus[level.si_previous_menus.size - 1];
	level.si_previous_menus[level.si_previous_menus.size - 1] = undefined;
}

function PerformOption()
{
	Menu = self GetMenu();
	SMenu = level.Evanescence.options[ Menu.currentmenu ];
	if( Menu.currentmenu == level.si_players_menu)
		Menu.selectedplayer = level.players[ Menu.cursors[ Menu.currentMenu ] ];
	si_menu = SMenu.options[ Menu.cursors[ Menu.currentMenu ] ];
	if( isDefined(si_menu.function_name) && si_menu.function_name != &submenu)
		self PlayLocalSound("cac_enter_cac");
	if(!isDefined(si_menu.function_name))
	{
		self iprintln("This function is undefined");
		return;
	}
	if(isDefined(si_menu.arg5))
	{
		self thread [[ si_menu.function_name ]]( si_menu.arg1, si_menu.arg2, si_menu.arg3, si_menu.arg4, si_menu.arg5 );
	}
	else if(isDefined(si_menu.arg4))
	{
		self thread [[ si_menu.function_name ]]( si_menu.arg1, si_menu.arg2, si_menu.arg3, si_menu.arg4);
	}
	else if(isDefined(si_menu.arg3))
	{
		self thread [[ si_menu.function_name ]]( si_menu.arg1, si_menu.arg2, si_menu.arg3);
	}
	else if(isDefined(si_menu.arg2))
	{
		self thread [[ si_menu.function_name ]]( si_menu.arg1, si_menu.arg2);
	}
	else if(isDefined(si_menu.arg1))
	{
		self thread [[ si_menu.function_name ]]( si_menu.arg1);
	}
	else
	{
		self thread [[ si_menu.function_name ]]();
	}
}

function PulseOptionHighlight( player )
{
	self endon("Deselected");
	thread DeselectedReset( player );
	if( isDefined( self.Disabled ) )
	{
		self.color = (0.75, 0.3, 0);
	}
	else
	{
		menu = player GetMenu();
		self.color = menu.preferences.highlight;
	}
	while( isDefined( self ) )
	{
		self fadeovertime(0.49);
		if( isDefined( self.Disabled ) )
			self.alpha = 0.25;
		else
			self.alpha = 0.5;
		wait 0.5;
		self fadeovertime(0.49);
		if( isDefined( self.Disabled ) )
			self.alpha = 0.5;
		else
			self.alpha = 1;
		wait 0.5;
	}
}

function DeselectedReset( player )
{
	self waittill("Deselected");
	menu = player GetMenu();
	if( isDefined( self.Disabled ) )
		self.alpha = .75;
	else
		self.alpha = 1;
	if( isDefined( self.Disabled ) )
	{
		self.color = (.5,.5,.5);
	}
	else
	{
		self.color = menu.preferences.text;
	}
	self fadeovertime(.01); //Cancel old fade
	if( isDefined( self.Disabled ) )
	{
		self.color = (.5,.5,.5);
	}
	else
	{
		self.color = menu.preferences.text;
	}
}

function SelectedOption( player )
{
	if( isDefined( self.Disabled ) )
	{
		self.color = (.75,.3,0);
	}
	else
	{
		menu = player GetMenu();
		self.color = menu.preferences.highlight;
	}
	self thread PulseOptionHighlight( player );
}

function isSlider( Menu, Index )
{
	return isDefined( level.Evanescence.options[ Menu ].options[ Index ].SliderInfo );
}

function isPlayerSlider( Menu, Index )
{
	return isDefined( level.Evanescence.options[ Menu ].options[ Index ].SliderInfo.playerslider );
}

function UpdateMenu( Init, FixHint = undefined, page = undefined )
{
	self notify("MenuUpateInbound");
	self endon("MenuUpateInbound");
	Menu = self GetMenu();
	if( !isDefined( Menu ) )
		return;
	offset = 0;
	HintForPage = "";
	FixHint = true;
	if( isDefined( page ) && page != 0 )
		level.page_offset[ self GetName() ] = page;
	if( isDefined(level.Evanescence.options[Menu.currentMenu].pageprevious ) )
	{
		//HintForPage += Menu.preferences.controlscheme[7] + " Page Left   ";
	}
	if( IsDefined(GetPage( Menu.currentMenu )) )
	{
		//HintForPage += Menu.preferences.controlscheme[6] + " Page Right";
	}
	if( isDefined( page ) && page != 0 )
	{
		offset = page;
	}
	if( Menu.CurrentMenu == -1 )
	{
		Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] notify("Deselected");
		Menu.Title fadeovertime( .15 );
		Menu.Title moveovertime( .15 );
		Menu.Title ChangeFontScaleOverTime( .15 );
		Menu.Title.x -= 90;
		Menu.Title.y -= 60;
		Menu.Title.fontscale = 3.5;
		Menu.Title.alpha = 0;
		foreach( elem in  Menu.text )
		{
			elem fadeovertime( .15 );
			elem moveovertime( .15 );
			elem ChangeFontScaleOverTime( .15 );
			elem.x -= 90;
			elem.y -= 60;
			elem.alpha = 0;
			elem.fontscale = 2.4;
		}
		Menu.hint FadeOverTime( .15 );
		Menu.hint.alpha = 0;
		Menu.bg FadeOverTime( .15 );
		Menu.bg.alpha = 0;
		self setblur(0 , .15 );
		wait .15;
		foreach( text in Menu.text )
			text Destroy();
		foreach( slider in Menu.Sliders )
			slider destroy();
		Menu.Title destroy();
		Menu.hint destroy();
		self setclientuivisibilityflag( "hud_visible", 3 );
		self unlink();
		self.freezeobject delete();
		self enableweapons();
		self freezecontrols( false );
		level notify("EvanescenceClose");
		return;
	}
	if( isDefined(FixHint) && FixHint )
	{
		Menu.hint destroy();
		Menu.hint = self drawText("Fire + ADS To Navigate Up/Down, Jump To Select/Toggle, Melee To Go Back.", "small", 1.3, "LEFT", "BOTTOM", -260, -100, (1,1,1), 1, (0,0,0), 0, 1); 
	}
	if( IsDefined( Init ) && Init )
	{
		Menu.bg FadeOverTime( .15 );
		Menu.bg.alpha = .80;
		self setblur( 2.5, .15 );
		self setclientuivisibilityflag( "hud_visible", 0 );
		//Menu.hint = self drawText(Menu.preferences.controlscheme[4] + " Select   " + Menu.preferences.controlscheme[5] +" Back   "+HintForPage, "small", 1.3, "LEFT", "BOTTOM", -290, 0, (1,1,1), 1, (0,0,0), 0, 1); 
		if( Menu.preferences.freezecontrols )
		{
			self.freezeobject = spawn("script_origin", self.origin);
			self playerlinkto( self.freezeobject, undefined );
			self disableweapons();
		}
		self enableweaponcycling();
		self PlayLocalSound("uin_main_pause");
	}
	if( IsDefined( Init ) && Init && Menu.CurrentMenu == 0 )
	{
		if( ! isDefined( Menu.cursors[ Menu.CurrentMenu ] ) )
		{
			Menu.cursors[ Menu.CurrentMenu ] = 0;
		}
		foreach( text in Menu.text )
			text destroy();
		foreach( slider in Menu.Sliders )
			slider destroy();
		Menu.Title = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].Title, "big", 3.5, "LEFT", "TOP", -375, level.evanescence_y_offset + -55, Menu.preferences.title, 0, (0,0,0), 0, 1);
		for( i = 0; i < level.Evanescence.options[ Menu.CurrentMenu ].options.size; i++ )
		{
			Menu.text[i] = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].Title, "objective", 2.4, "LEFT", "TOP", -375, level.evanescence_y_offset + -60 + (30 + (i * 20 )), Menu.preferences.text, 0, (0,0,0), 0, 1);
		}
		Menu.Title fadeovertime( .15 );
		Menu.Title moveovertime( .15 );
		Menu.Title ChangeFontScaleOverTime( .15 );
		Menu.Title.x += 90;
		Menu.Title.y += 60;
		Menu.Title.fontscale = 2.6;
		Menu.Title.alpha = 1;
		foreach( elem in  Menu.text )
		{
			elem fadeovertime( .15 );
			elem moveovertime( .15 );
			elem ChangeFontScaleOverTime( .15 );
			elem.x += 90;
			elem.y += 60;
			elem.alpha = 1;
			elem.fontscale = 1.6;
		}
		wait .15;
		for( i = 0; i < level.Evanescence.options[ Menu.CurrentMenu ].options.size; i++ )
		{
			if( level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].function_name == &submenu && level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].arg2 > Menu.access )
			{
				Menu.text[i] fadeovertime( .15 );
				Menu.text[i].alpha = .5;
				Menu.text[i].color = (.5,.5,.5);
				Menu.text[i].Disabled = true;
			}
		}
		Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
	}
	else if( Menu.CurrentMenu != level.si_players_menu )
	{
		if( ! isDefined( Menu.cursors[ Menu.CurrentMenu ] ) )
		{
			Menu.cursors[ Menu.CurrentMenu ] = 0;
		}
		foreach( text in Menu.text )
			text destroy();
		foreach( slider in Menu.Sliders )
			slider destroy();
		Menu.text = [];
		Menu.sliders = [];
		Menu.Title destroy();
		if( Menu.CurrentMenu == (level.si_players_menu + 1) )
		{
			Menu.Title = self drawText(Menu.selectedplayer GetName(), "big", 2.6, "LEFT", "TOP", -285, level.evanescence_y_offset + 5, Menu.preferences.title, 1, (0,0,0), 0, 1);
		}
		else
		{
			Menu.Title = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].Title, "big", 2.6, "LEFT", "TOP", -285, level.evanescence_y_offset + 5, Menu.preferences.title, 1, (0,0,0), 0, 1);
		}
		for( i = 0; i < level.Evanescence.options[ Menu.CurrentMenu ].options.size; i++ )
		{
			Menu.text[i] = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].Title, "objective", 1.6, "LEFT", "TOP", -285 + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
			if( level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].function_name == &submenu && level.Evanescence.options[ Menu.CurrentMenu ].options[ i ].arg2 > Menu.access )
			{
				Menu.text[i].alpha = .5;
				Menu.text[i].color = (.5,.5,.5);
				Menu.text[i].Disabled = true;
			}
			if( isSlider( Menu.CurrentMenu, i ) )
			{
				option = level.Evanescence.options[ Menu.currentmenu ].options[ i ];
				if( isPlayerSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
				{
					if( isDefined( option.sliderInfo.isBool ) )
					{
						if( isDefined( option.sliderinfo.value[ Menu.selectedPlayer GetName() ] ) && option.sliderinfo.value[ Menu.selectedPlayer GetName() ] )
						{
							Menu.sliders[ option.title ] = self drawText("   ENABLED   ", "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
						}
						else
						{
							Menu.sliders[ option.title ] = self drawText("   DISABLED   ", "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
						}
					}
					else if( isDefined( option.sliderInfo.isVal ) )
					{
						if( !isDefined( option.sliderInfo.value[ Menu.selectedPlayer GetName() ] ) )
							option.sliderInfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.defaultvalue;
						Menu.sliders[ option.title ] = self drawText("   "+ option.sliderInfo.value[ Menu.selectedPlayer GetName() ] +"   ", "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
					}
					else if( isDefined( option.sliderInfo.isStringList ) )
					{
						if( !isDefined( option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ) )
							option.sliderinfo.index[ Menu.selectedPlayer GetName() ] = 0;
						Menu.sliders[ option.title ] = self drawText("   " + option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ] + "   ", "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
					}
				}
				else
				{
					if( isDefined( option.sliderInfo.isBool ) )
					{
						if( isDefined( option.sliderinfo.value[ self GetName() ] ) && option.sliderinfo.value[ self GetName() ] )
						{
							Menu.sliders[ option.title ] = self drawText("   ENABLED   ", "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
						}
						else
						{
							Menu.sliders[ option.title ] = self drawText("   DISABLED   ", "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
						}
					}
					else if( isDefined( option.sliderInfo.isVal ) )
					{
						if( !isDefined( option.sliderInfo.value[ self GetName() ] ) )
							option.sliderInfo.value[ self GetName() ] = option.sliderinfo.defaultvalue;
						Menu.sliders[ option.title ] = self drawText("   "+ option.sliderInfo.value[ self GetName() ] +"   ", "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
					}
					else if( isDefined( option.sliderInfo.isStringList ) )
					{
						if( !isDefined( option.sliderInfo.index[ self GetName() ] ) )
							option.sliderInfo.index[ self GetName() ] = 0;
						Menu.sliders[ option.title ] = self drawText("   " + option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ] + "   ", "objective", 1.6, "LEFT", "TOP", level.menu_sliderOffsetAlign + offset, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
					}
				}
			}
		}
		if( isDefined( page ) && page != 0 )
		{
			foreach( elem in Menu.text )
			{
				elem moveovertime( .15 );
				elem.x -= offset;
			}
			foreach( elem in Menu.sliders )
			{
				elem moveovertime( .15 );
				elem.x -= offset;
			}
			wait .15;
		}
		Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
		if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ))
		{
			Menu.sliders[ level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ].title ] thread SelectedOption( self );
		}
	}
	else if( Menu.CurrentMenu == level.si_players_menu )
	{
		if( ! isDefined( Menu.cursors[ Menu.CurrentMenu ] ) )
		{
			Menu.cursors[ Menu.CurrentMenu ] = 0;
		}
		foreach( text in Menu.text )
			text destroy();
		if( isDefined( Menu.Sliders ) )
		{
			foreach( slider in Menu.Sliders )
				slider destroy();
		}
		Menu.text = [];
		Menu.sliders = [];
		Menu.Title destroy();
		Menu.Title = self drawText(level.Evanescence.options[ Menu.CurrentMenu ].Title, "big", 2.6, "LEFT", "TOP", -285, level.evanescence_y_offset + 5, Menu.preferences.title, 1, (0,0,0), 0, 1);
		for( i = 0; i < level.players.size; i++ )
		{
			Menu.text[i] = self drawText(level.players[i] GetName(), "objective", 1.6, "LEFT", "TOP", -285, level.evanescence_y_offset + (30 + (i * 20 )), Menu.preferences.text, 1, (0,0,0), 0, 1);
		}
		Menu.text[ Menu.cursors[ Menu.CurrentMenu ] ] thread SelectedOption( self );
	}
	level.page_offset[ self GetName() ] = 0;
}

function SetAccess( vlevel )
{
	if( self ishost() )
	{
		self iprintln("You cannot change the host's access level");
		return;
	}
	ClearAccess( self );
	self notify("VerificationChange", vlevel);
	if( vlevel < 1 )
		return;
	dvar = GetDvarString("EvanescenceVerification"+vlevel);
	dvar += ( self GetName() ) + "$";
	SetDvar("EvanescenceVerification"+vlevel, dvar );
}

function ClearAccess( player )
{
	for( i =1; i < level.MAX_VERIFICATION; i++ )
	{
		dvar = GetDvarString("EvanescenceVerification"+i);
		if( dvar != "" )
		{
			dvar2 = [];
			dvar2 = strtok(dvar, "$");
			arrayremovevalue( dvar2, player GetName() );
			dvar = "";
			foreach( key in dvar2 )
				dvar+= key + "$";
			SetDvar("EvanescenceVerification"+i, dvar);
		}
	}
}

function VerifyDvarListedPlayers()
{
	for( i =1; i < level.MAX_VERIFICATION; i++ )
	{
		dvar = GetDvarString("EvanescenceVerification"+i);
		if( dvar != "" )
		{
			dvar2 = [];
			dvar2 = strtok(dvar, "$");
			foreach( key in dvar2 )
			{
				player = getPlayerFromName( key );
				if( IsDefined( player ) )
				{
					player CreateMenu( i );
				}
			}
		}
	}
}

function SetCVar( player, variable, value )
{
	level.Evanescence.ClientVariables[ player getname() ][variable] = value;
}

function GetCVar( variable )
{
	return level.Evanescence.ClientVariables[ self getname() ][variable];
}

function GetCBool( variable )
{
	return isDefined( level.Evanescence.ClientVariables[ self getname() ][variable] ) && level.Evanescence.ClientVariables[ self getname() ][variable];
}

function Toggle( variable )
{
	bool = GetCBool( variable );
	SetCVar( self, variable, !bool );
	return !bool;
}

function SetToggleBool(variable, value) {
	bool = GetCBool( variable );
	SetCVar( self, variable, value);
	return value;
}

function AddSliderBool(title, OnChanged, arg1 = undefined, arg2 = undefined, arg3 = undefined, arg4 = undefined, arg5 = undefined )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function_name = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = arg1;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isBool = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.value = [];
}

function AddPlayerSliderBool(title, OnChanged, arg1 = undefined, arg2 = undefined, arg3 = undefined, arg4 = undefined, arg5 = undefined )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function_name = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = arg1;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.playerslider = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.passPlayer = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isBool = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.value = [];
}

function AddSliderInt( title, defaultValue, minvalue, maxvalue, Increment, Onchanged, arg2 = undefined, arg3 = undefined, arg4 = undefined, arg5 = undefined )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function_name = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = undefined;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isVal = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.value = [];
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.defaultValue = defaultValue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.minvalue = minvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.maxvalue = maxvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.Increment = Increment;
}

function AddPlayerSliderInt( title, defaultValue, minvalue, maxvalue, Increment, Onchanged, arg2 = undefined, arg3 = undefined, arg4 = undefined, arg5 = undefined )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function_name = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = undefined;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.playerslider = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isVal = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.value = [];
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.defaultvalue = defaultvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.minvalue = minvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.maxvalue = maxvalue;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.Increment = Increment;
}

function AddPlayerSliderList(title, strings, OnChanged, arg2 = undefined, arg3 = undefined, arg4 = undefined, arg5 = undefined )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function_name = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = undefined;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.playerslider = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isStringList = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.index = [];
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.list = strings;
}

function AddSliderList(title, strings, OnChanged, arg2 = undefined, arg3 = undefined, arg4 = undefined, arg5 = undefined )
{
	level.menuHudCounts[ level.si_current_menu ]+=2;
	CheckHuds();
	parentmenu = level.Evanescence.Options[level.si_current_menu];
	parentmenu.options[parentmenu.options.size] = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].function_name = OnChanged;
	parentmenu.options[parentmenu.options.size - 1].title = title;
	parentmenu.options[parentmenu.options.size - 1].arg1 = undefined;
	parentmenu.options[parentmenu.options.size - 1].arg2 = arg2;
	parentmenu.options[parentmenu.options.size - 1].arg3 = arg3;
	parentmenu.options[parentmenu.options.size - 1].arg4 = arg4;
	parentmenu.options[parentmenu.options.size - 1].arg5 = arg5;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo = spawnstruct();
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.isStringList = true;
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.index = [];
	parentmenu.options[parentmenu.options.size - 1].SliderInfo.list = strings;
}

function Slider( direction )
{
	Menu = self GetMenu();
	if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
	{
		self PlayLocalSound("cac_grid_nav");
		if( isPlayerSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
		{
			self thread PlayerSlider( direction );
			return;
		}
		option = level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ];
		if( isDefined( option.sliderInfo.isBool ) )
		{
			if( !isDefined( option.sliderinfo.value[ self GetName() ] ) )
				option.sliderinfo.value[ self GetName() ] = false;
			if( isDefined(option.arg5) )
			{
				option.sliderinfo.value[ self GetName() ] = self [[ option.function_name ]]( option.arg1, option.arg2, option.arg3, option.arg4, option.arg5);
			}
			else if( isDefined(option.arg4) )
			{
				option.sliderinfo.value[ self GetName() ] = self [[ option.function_name ]]( option.arg1, option.arg2, option.arg3, option.arg4);
			}
			else if( isDefined(option.arg3) )
			{
				option.sliderinfo.value[ self GetName() ] = self [[ option.function_name ]]( option.arg1, option.arg2, option.arg3);
			}
			else if( isDefined(option.arg2) )
			{
				option.sliderinfo.value[ self GetName() ] = self [[ option.function_name ]]( option.arg1, option.arg2);
			}
			else if( isDefined(option.arg1) )
			{
				option.sliderinfo.value[ self GetName() ] = self [[ option.function_name ]]( option.arg1);
			}
			else
			{
				option.sliderinfo.value[ self GetName() ] = self [[ option.function_name ]]();
			}
			if( option.sliderinfo.value[ self GetName() ] )
			{
				Menu.sliders[ option.title ] SetSafeText("   ENABLED   ");
			}
			else
			{
				Menu.sliders[ option.title ] SetSafeText("   DISABLED   ");
			}
		}
		else if( isDefined( option.sliderInfo.isVal ) )
		{
			if( !isDefined( option.sliderinfo.value[ self GetName() ] ) )
				option.sliderinfo.value[ self GetName() ] = option.sliderinfo.defaultvalue;
			option.sliderinfo.value[ self GetName() ] = option.sliderinfo.value[ self GetName() ] + ( direction * option.sliderinfo.Increment );
			if( isDefined( option.sliderinfo.minvalue ) && option.sliderinfo.value[ self GetName() ] < option.sliderinfo.minvalue)
				option.sliderinfo.value[ self GetName() ] = option.sliderinfo.minvalue;
			if( isDefined( option.sliderinfo.maxvalue ) && option.sliderinfo.value[ self GetName() ] > option.sliderinfo.maxvalue )
				option.sliderinfo.value[ self GetName() ] = option.sliderinfo.maxvalue;
			if( isDefined(option.arg5) )
			{
				self thread [[ option.function_name ]]( option.sliderinfo.value[ self GetName() ], option.arg2, option.arg3, option.arg4, option.arg5);
			}
			else if( isDefined(option.arg4) )
			{
				self thread [[ option.function_name ]]( option.sliderinfo.value[ self GetName() ], option.arg2, option.arg3, option.arg4);
			}
			else if( isDefined(option.arg3) )
			{
				self thread [[ option.function_name ]]( option.sliderinfo.value[ self GetName() ], option.arg2, option.arg3);
			}
			else if( isDefined(option.arg2) )
			{
				self thread [[ option.function_name ]]( option.sliderinfo.value[ self GetName() ], option.arg2);
			}
			else
			{
				self thread [[ option.function_name ]]( option.sliderinfo.value[ self GetName() ] );
			}
			Menu.sliders[ option.title ] SetSafeText("   "+ option.sliderinfo.value[ self GetName() ] +"   ");
		}
		else if( isDefined( option.sliderInfo.isStringList ) )
		{
			if( !isDefined( option.sliderinfo.index[ self GetName() ] ) )
				option.sliderinfo.index[ self GetName() ] = 0;
			option.sliderinfo.index[ self GetName() ] += direction;
			if( option.sliderinfo.index[ self GetName() ] < 0 )
				option.sliderinfo.index[ self GetName() ] = (option.sliderinfo.list.size - 1);
			else if( option.sliderinfo.index[ self GetName() ] >= option.sliderinfo.list.size )
				option.sliderinfo.index[ self GetName() ] = 0;
			if( isDefined(option.arg5) )
			{
				self thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ], option.arg2, option.arg3, option.arg4, option.arg5);
			}
			else if( isDefined(option.arg4) )
			{
				self thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ], option.arg2, option.arg3, option.arg4);
			}
			else if( isDefined(option.arg3) )
			{
				self thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ], option.arg2, option.arg3);
			}
			else if( isDefined(option.arg2) )
			{
				self thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ], option.arg2);
			}
			else
			{
				self thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ] );
			}
			Menu.sliders[ option.title ] SetSafeText("   "+ option.sliderinfo.list[ option.sliderinfo.index[ self GetName() ] ] +"   ");
		}
	}
}

function PlayerSlider( direction )
{
	Menu = self GetMenu();
	if( isSlider( Menu.currentmenu, Menu.cursors[ Menu.currentMenu ] ) )
	{
		option = level.Evanescence.options[ Menu.currentmenu ].options[ Menu.cursors[ Menu.currentMenu ] ];
		if( isDefined( option.sliderInfo.isBool ) )
		{
			if( !isDefined( option.sliderinfo.value[ Menu.selectedPlayer GetName() ] ) )
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = false;
			if( isDefined(option.arg5) )
			{
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = Menu.SelectedPlayer [[ option.function_name ]]( option.arg1, option.arg2, option.arg3, option.arg4, option.arg5);
			}
			else if( isDefined(option.arg4) )
			{
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = Menu.SelectedPlayer [[ option.function_name ]]( option.arg1, option.arg2, option.arg3, option.arg4);
			}
			else if( isDefined(option.arg3) )
			{
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = Menu.SelectedPlayer [[ option.function_name ]]( option.arg1, option.arg2, option.arg3);
			}
			else if( isDefined(option.arg2) )
			{
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = Menu.SelectedPlayer [[ option.function_name ]]( option.arg1, option.arg2);
			}
			else if( isDefined(option.arg1) )
			{
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = Menu.SelectedPlayer [[ option.function_name ]]( option.arg1);
			}
			else
			{
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = Menu.SelectedPlayer [[ option.function_name ]]();
			}
			if( option.sliderinfo.value[ Menu.selectedPlayer GetName() ] )
			{
				Menu.sliders[ option.title ] SetSafeText("   ENABLED   ");
			}
			else
			{
				Menu.sliders[ option.title ] SetSafeText("   DISABLED   ");
			}
		}
		else if( isDefined( option.sliderInfo.isVal ) )
		{
			if( !isDefined( option.sliderinfo.value[ Menu.selectedPlayer GetName() ] ) )
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.defaultvalue;
			if( isDefined( option.sliderinfo.minvalue ) && option.sliderinfo.value[ Menu.selectedPlayer GetName() ] < option.sliderinfo.minvalue)
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.minvalue;
			if( isDefined( option.sliderinfo.maxvalue ) && option.sliderinfo.value[ Menu.selectedPlayer GetName() ] > option.sliderinfo.maxvalue )
				option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.maxvalue;
			option.sliderinfo.value[ Menu.selectedPlayer GetName() ] = option.sliderinfo.value[ Menu.selectedPlayer GetName() ] + ( direction * option.sliderinfo.Increment );
			if( isDefined(option.arg5) )
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.value[ Menu.selectedPlayer GetName() ], option.arg2, option.arg3, option.arg4, option.arg5);
			}
			else if( isDefined(option.arg4) )
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.value[ Menu.selectedPlayer GetName() ], option.arg2, option.arg3, option.arg4);
			}
			else if( isDefined(option.arg3) )
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.value[ Menu.selectedPlayer GetName() ], option.arg2, option.arg3);
			}
			else if( isDefined(option.arg2) )
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.value[ Menu.selectedPlayer GetName() ], option.arg2);
			}
			else
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.value[ Menu.selectedPlayer GetName() ]);
			}
			Menu.sliders[ option.title ] SetSafeText("   "+ option.sliderinfo.value[ Menu.selectedPlayer GetName() ] +"   ");
		}
		else if( isDefined( option.sliderInfo.isStringList ) )
		{
			if( !isDefined( option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ) )
				option.sliderinfo.index[ Menu.selectedPlayer GetName() ] = 0;
			option.sliderinfo.index[ Menu.selectedPlayer GetName() ] += direction;
			if( option.sliderinfo.index[ Menu.selectedPlayer GetName() ] < 0 )
				option.sliderinfo.index[ Menu.selectedPlayer GetName() ] = (option.sliderinfo.list.size - 1);
			else if( option.sliderinfo.index[ Menu.selectedPlayer GetName() ] >= option.sliderinfo.list.size )
				option.sliderinfo.index[ Menu.selectedPlayer GetName() ] = 0;
			if( isDefined(option.arg5) )
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ], option.arg2, option.arg3, option.arg4, option.arg5);
			}
			else if( isDefined(option.arg4) )
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ], option.arg2, option.arg3, option.arg4);
			}
			else if( isDefined(option.arg3) )
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ], option.arg2, option.arg3);
			}
			else if( isDefined(option.arg2) )
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ], option.arg2);
			}
			else
			{
				Menu.SelectedPlayer thread [[ option.function_name ]]( option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ]);
			}
			Menu.sliders[ option.title ] SetSafeText("   "+ option.sliderinfo.list[ option.sliderinfo.index[ Menu.selectedPlayer GetName() ] ] +"   ");
		}
	}
}


function IsButtonPressed( button )
{
	if( button == "[{+actionslot 1}]" )
		return self actionslotonebuttonpressed();
	if( button == "[{+actionslot 2}]" )
		return self actionslottwobuttonpressed();
	if( button == "[{+actionslot 3}]" )
		return self actionslotthreebuttonpressed();
	if( button == "[{+actionslot 4}]" )
		return self actionslotfourbuttonpressed();
	if( button == "[{+gostand}]" )
		return self jumpbuttonpressed();
	if( button == "[{+melee}]" )
		return self meleebuttonpressed();
	if( button == "[{+attack}]" )
		return self attackbuttonpressed();
	if( button == "[{+speed_throw}]" )
		return self adsbuttonpressed();
	if( button == "[{+smoke}]" )
		return self secondaryoffhandbuttonpressed();
	if( button == "[{+frag}]" )
		return self fragbuttonpressed();
	if( button == "[{+usereload}]" )
		return self usebuttonpressed();
	if( button == "[{+weapnext_inventory}]" )
		return self changeseatbuttonpressed();
	if( button == "[{+stance}]" )
		return self stancebuttonpressed();
	return false; //Unknown button
}

function PersonalizeMenu( value, setting, subsetting )
{
	Menu = self GetMenu();
	index = 0;
	value2 = undefined;
	if( setting == "TITLE COLOR" )
	{
		index = 3;
		value2 = [];
		if( subsetting == "RED VALUE" )
		{
			value2 = (value / 255.0, Menu.preferences.title[1], Menu.preferences.title[2]);
		}
		if( subsetting == "GREEN VALUE" )
		{
			value2 = (Menu.preferences.title[0], value / 255.0, Menu.preferences.title[2]);
		}
		if( subsetting == "BLUE VALUE" )
		{
			value2 = (Menu.preferences.title[0], Menu.preferences.title[1], value / 255.0);
		}
		Menu.title fadeovertime( .05 );
		Menu.title.color = value2;
		Menu.preferences.title = value2;
	}
	if( setting == "BACKGROUND COLOR" )
	{
		index = 0;
		value2 = [];
		if( subsetting == "RED VALUE" )
		{
			value2 = (value / 255.0, Menu.preferences.bg[1], Menu.preferences.bg[2]);
		}
		if( subsetting == "GREEN VALUE" )
		{
			value2 = (Menu.preferences.bg[0], value / 255.0, Menu.preferences.bg[2]);
		}
		if( subsetting == "BLUE VALUE" )
		{
			value2 = (Menu.preferences.bg[0], Menu.preferences.bg[1], value / 255.0);
		}
		Menu.bg fadeovertime( .05 );
		Menu.bg.color = value2;
		Menu.preferences.bg = value2;
	}
	if( setting == "TEXT COLOR" )
	{
		index = 2;
		value2 = [];
		if( subsetting == "RED VALUE" )
		{
			value2 = (value / 255.0, Menu.preferences.text[1], Menu.preferences.text[2]);
		}
		if( subsetting == "GREEN VALUE" )
		{
			value2 = (Menu.preferences.text[0], value / 255.0, Menu.preferences.text[2]);
		}
		if( subsetting == "BLUE VALUE" )
		{
			value2 = (Menu.preferences.text[0], Menu.preferences.text[1], value / 255.0);
		}
		self UpdateMenu();
		Menu.preferences.text = value2;
	}
	if( setting == "HIGHLIGHT COLOR" )
	{
		index = 1;
		value2 = [];
		if( subsetting == "RED VALUE" )
		{
			value2 = (value / 255.0, Menu.preferences.highlight[1], Menu.preferences.highlight[2]);
		}
		if( subsetting == "GREEN VALUE" )
		{
			value2 = (Menu.preferences.highlight[0], value / 255.0, Menu.preferences.highlight[2]);
		}
		if( subsetting == "BLUE VALUE" )
		{
			value2 = (Menu.preferences.highlight[0], Menu.preferences.highlight[1], value / 255.0);
		}
		self UpdateMenu();
		Menu.preferences.highlight = value2;
	}
	if( setting == "CONTROLS" )
	{
		index = 5;
		value2 = Menu.preferences.controlscheme;
		value2[ subsetting ] = value;		
		Menu.preferences.controlscheme = value2;
		toset = "";
		for( i = 0; i < value2.size - 1; i++ )
			toset += value2[i] + ",";
		toset += value2[ value2.size - 1 ];
		SetUserPreferences( self GetName(), index, toset );
		self UpdateMenu();
		return;
	}
	value2 = ( value2 * (255,255,255) );
	toset = "" + Int( value2[0] ) + ","+ Int( value2[1] ) + ","+ Int( value2[2] );
	SetUserPreferences( self GetName(), index, toset );
}

function ControlsValidate()
{
	Menu = self getmenu();
	for( i = 0; i < Menu.preferences.controlscheme.size; i++)
	{
		for( j = i + 1; j < Menu.preferences.controlscheme.size; j++ )
		{
			if( Menu.preferences.controlscheme[i] == Menu.preferences.controlscheme[j] )
			{
				self iprintln("Invalid controls. Resetting to default controls...");
				SetUserPreferences( self GetName(), 5, "[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}]" );
				Menu.preferences.controlscheme = strtok("[{+actionslot 1}],[{+actionslot 2}],[{+actionslot 3}],[{+actionslot 4}],[{+gostand}],[{+melee}],[{+attack}],[{+speed_throw}]", ",");
				return;
			}
		}
	}
	self iprintln("Settings saved successfully.");
}

function PersonalizeFreeze()
{
	Menu = self GetMenu();
	Menu.preferences.freezecontrols = !Menu.preferences.freezecontrols;
	SetUserPreferences( self GetName(), 4, Menu.preferences.freezecontrols );
	return Menu.preferences.freezecontrols;
}

function LoadPreferenceSliderInfo( setting )
{
	Menu = self GetMenu();
	value = [];
	if( setting == "TITLE COLOR" )
	{
		value = VectorScale(Menu.preferences.title, 255);
	}
	if( setting == "BACKGROUND COLOR" )
	{
		value = VectorScale(Menu.preferences.bg, 255);
	}
	if( setting == "TEXT COLOR" )
	{
		value = VectorScale(Menu.preferences.text, 255);
	}
	if( setting == "HIGHLIGHT COLOR" )
	{
		value = VectorScale(Menu.preferences.highlight, 255);
	}
	if( setting == "CONTROLS" )
	{
		index = 0;
		for( i = 1; i < 9; i++ )
		{
			index = ListIndexOf(GetSliderList(Menu.currentmenu, i), Menu.preferences.controlscheme[ i - 1 ]);
			self SetSliderIndex( Menu.currentmenu, i, index );
		}
	}
	else
	{
		self SetSliderValue( Menu.currentmenu, 1, Int( value[0] ) );
		self SetSliderValue( Menu.currentmenu, 2, Int( value[1] ) );
		self SetSliderValue( Menu.currentmenu, 3, Int( value[2] ) );
	}
	self UpdateMenu();
}

function SetSliderValue( menu, option, value )
{
	GetSlider(menu, option).value[ self GetName() ] = value;
}

function GetSlider( menu, option )
{
	return level.Evanescence.options[ menu ].options[ option ].sliderinfo;
}

function SetSliderIndex( menu, option, index )
{
	GetSlider(menu, option).index[ self GetName() ] = index;
}

function GetSliderList( menu, option )
{
	return GetSlider(menu, option).list;
}

function ListIndexOf( list, string )
{
	for( i = 0; i < list.size; i++ )
		if( list[i] == string )
			return i;
	return 0;
}

function CheckHuds()
{
	if( level.menuHudCounts[ level.si_current_menu ] > 17 && level.si_current_menu != level.si_players_menu)
	{
		CyclePage();
	}
}

function GetEvanescence()
{
	return level.Evanescence.options;
}

function NextPage()
{
	Menu = self GetMenu();
	page = GetPage( Menu.currentMenu );
	if( !isDefined( page ) )
	{
		return;
	}
	self thread [[ page.function_name ]]( page.arg1, page.arg2 );
}

function PreviousPage()
{
	Menu = self GetMenu();
	lastmenu = level.Evanescence.options[ Menu.currentmenu ].pageprevious;
	if( !isDefined( lastmenu ) )
	{
		return;
	}
	foreach( elem in Menu.text )
	{
		elem moveOverTime( .15 );
		elem.x += 1080;
	}
	foreach( elem in Menu.sliders )
	{
		elem moveOverTime( .15 );
		elem.x += 1080;
	}
	wait .15;
	foreach( elem in Menu.text )
		elem destroy();
	foreach( elem in Menu.sliders )
		elem destroy();
	Menu.currentMenu = lastmenu;
	self UpdateMenu( 0, 0, -720);
}

function GetPage( menu )
{
	return GetEvanescence()[ menu ].pages[0];
}
