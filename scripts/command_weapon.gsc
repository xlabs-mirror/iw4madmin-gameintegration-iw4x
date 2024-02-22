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
    command.eventKey = "GetWeaponCommand";

    // name of the command (cannot conflict with existing command names)
    command.name = "weapon";
    
    // short version of the command (cannot conflcit with existing command aliases)
    command.alias = "end";

    // description of what the command does
    command.description = "Gives you the specified weapon";
    
    // minimum permision required to execute
    // valid values: User, Trusted, Moderator, Administrator, SeniorAdmin, Owner
    command.minPermission = "Administrator";

    // games the command is supported on
    // separate with comma or don't define for all
    // valid values: IW3, IW4, IW5, IW6, T4, T5, T6, T7, SHG1, CSGO, H1
    command.supportedGames = "IW4";

    // indicates if a target player must be provided to execvute on
    command.requiresTarget = false;

    // code to run when the command is executed
    command.handler = ::GetWeaponCommandCallback;
    
    // register the command with integration to be send to iw4madmin
    scripts\_integration_shared::RegisterScriptCommandObject( command );
}

GetWeaponCommandCallback( event )
{
    weapon_name = event.data["args"];
    if ( !IsAlive( self ) )
    {
        return "You must be alive to use this command";
    }
    scripts\_integration_base::LogDebug( "Giving weapon " + weapon_name );    
    self IPrintLnBold( "You have been given " + weapon_name );
    self GiveWeapon( weapon_name );
    self SwitchToWeapon( weapon_name );
}