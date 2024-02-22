Init()
{
    // this gives the game interface time to setup
    waittillframeend;
    level thread onPlayerConnect();
    thread ModuleSetup();
}

ModuleSetup()
{
    // waiting until the game specific functions are ready
    level waittill( level.notifyTypes.gameFunctionsInitialized );

    RegisterCustomCommands();
}

RegisterCustomCommands()
{
    command = SpawnStruct();
    
    // unique key for each command (how iw4madmin identifies the command)
    command.eventKey = "LaserCommand";

    // name of the command (cannot conflict with existing command names)
    command.name = "laser";
    
    // short version of the command (cannot conflcit with existing command aliases)
    command.alias = "";

    // description of what the command does
    command.description = "Toggles Laser Sight";
    
    // minimum permision required to execute
    // valid values: User, Trusted, Moderator, Administrator, SeniorAdmin, Owner
    command.minPermission = "User";

    // games the command is supported on
    // separate with comma or don't define for all
    // valid values: IW3, IW4, IW5, IW6, T4, T5, T6, T7, SHG1, CSGO, H1
    command.supportedGames = "IW4";

    // indicates if a target player must be provided to execvute on
    command.requiresTarget = false;

    // code to run when the command is executed
    command.handler = ::FPSBoostCommandCallback;
    
    // register the command with integration to be send to iw4madmin
    scripts\_integration_shared::RegisterScriptCommandObject( command );
}

FPSBoostCommandCallback( event )
{
    ToggleLaser(self);
}

ApplyLaser(player, value)
{
    player setClientDvar( "laserLight", value );
    player setClientDvar( "cg_laserlight", value );
    player setClientDvar( "laserLightWithoutNightvision", value );
    player setClientDvar( "laserForceOn", value );
}

ToggleLaser(player)
{
    if (player.pers["laserSight"]) {
        ApplyLaser(player, 0);
        player.pers["laserSight"] = false;
        player iPrintlnBold("^7FPS Booster ^1Disabled");
    } else {
        ApplyLaser(player, 1);
        player.pers["laserSight"] = true;
        player iPrintlnBold("^7FPS Booster ^1Enabled");
    }
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player);
		player thread onPlayerGiveloadout();
	}
}

onPlayerGiveloadout()
{
	self endon("disconnect");

	self.pers["laserSight"] = false;
	for(;;)
	{
		self waittill("giveLoadout");
		ApplyLaser(self, self.pers["laserSight"]);
	}
}