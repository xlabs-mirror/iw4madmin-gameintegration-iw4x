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
    command.eventKey = "FPSCommand";

    // name of the command (cannot conflict with existing command names)
    command.name = "fps";
    
    // short version of the command (cannot conflcit with existing command aliases)
    command.alias = "";

    // description of what the command does
    command.description = "Toggles FPS Boost";
    
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
    ToggleFPSBoost(self);
}

ApplyFPSBoost(player, value)
{
    if (value == 1) {
        player SetClientDvar("r_fullbright", 1);
        player SetClientDvar("r_fog", 0);
        player SetClientDvar("r_detailMap", 0);
    } else {
        player SetClientDvar("r_fullbright", 0);
        player SetClientDvar("r_fog", 1);
        player SetClientDvar("r_detailMap", 1);
    }
}

ToggleFPSBoost(player)
{
    if (player.pers["fpsBooster"]) {
        ApplyFPSBoost(player, 0);
        player.pers["fpsBooster"] = false;
        player iPrintlnBold("^7FPS Booster ^1Disabled");
        scripts\_integration_base::LogDebug( "Disabled FPS Booster for " + self.name);
    } else {
        ApplyFPSBoost(player, 1);
        player.pers["fpsBooster"] = true;
        player iPrintlnBold("^7FPS Booster ^1Enabled");
        scripts\_integration_base::LogDebug( "Enabled FPS Booster for " + self.name);
    }
}

onPlayerConnect()
{
	while(true)
	{
		level waittill( "connected", player);
		player thread onPlayerGiveloadout();
	}
}

onPlayerGiveloadout()
{
	self endon("disconnect");

	self.pers["fpsBooster"] = false;
	while(true)
	{
		self waittill("giveLoadout");
		ApplyFPSBoost(self, self.pers["fpsBooster"]);
	}
}