Init()
{
    // this gives the game interface time to setup
    waittillframeend;
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
    command.eventKey = "ForceEndCommand";

    // name of the command (cannot conflict with existing command names)
    command.name = "forceend";
    
    // short version of the command (cannot conflcit with existing command aliases)
    command.alias = "end";

    // description of what the command does
    command.description = "Force ends the current match";
    
    // minimum permision required to execute
    // valid values: User, Trusted, Moderator, Administrator, SeniorAdmin, Owner
    command.minPermission = "Moderator";

    // games the command is supported on
    // separate with comma or don't define for all
    // valid values: IW3, IW4, IW5, IW6, T4, T5, T6, T7, SHG1, CSGO, H1
    command.supportedGames = "IW4";

    // indicates if a target player must be provided to execvute on
    command.requiresTarget = false;

    // code to run when the command is executed
    command.handler = ::ForceEndCommandCallback;
    
    // register the command with integration to be send to iw4madmin
    scripts\_integration_shared::RegisterScriptCommandObject( command );
}

ForceEndCommandCallback( event )
{
    scripts\_integration_base::LogDebug( "Force ending match..." );
    level thread maps\mp\gametypes\_gamelogic::forceEnd();
}