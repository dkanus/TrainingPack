class Helper extends Info;

static function TellAbout(String arg, PlayerController KFController, TrainingPackVanilla TrainMut){
    if(arg == ""){
        TrainMut.SendMessage("Type %b'mutate help list'%w to get list of available commands." @
            "All commands should be entered after %b'mutate'%w keyword. Commands are case-insensitive.", KFController);
        TrainMut.SendMessage("Symbol %y'#'%w means that you need to put an integer number in it's place, %y'#f'%w is the same for floating-point number," @
            "%b'#s'%w is for string.", KFController);
        TrainMut.SendMessage("Parameters listed between %b'{ }'%w are optional.", KFController);
    }
    else if(arg ~= "LIST"){
        TrainMut.SendMessage("- %r[CHEAT]%w prefix means that using corresponding command can be considered a cheat in some situations."@
            "Omit it when trying to get help entry for a command.", KFController);
        TrainMut.SendMessage("- Please view help entry specific for a command to get more information.", KFController);
        TrainMut.SendMessage("- List of commands:", KFController);
        TrainMut.SendMessage("%bFORMAT:%w manages console output settings.", KFController);
        TrainMut.SendMessage("%bPREFS:%w outputs info about current settings.", KFController);
        TrainMut.SendMessage("%bDRAMA:%w enables/disables zed time.", KFController);
        TrainMut.SendMessage("%bFAKED:%w sets amount of faked players.", KFController);
        TrainMut.SendMessage("%bSLOMOMSG:%w  enables/disables messages about manual change of game's speed.", KFController);
        TrainMut.SendMessage("%bPAUSE:%w toggles game pause.", KFController);
        TrainMut.SendMessage("%bHEALTH:%w changes health level of zeds.", KFController);
        TrainMut.SendMessage("%bHEALTHRULES:%w manages rules for changing health level of certain zed type.", KFController);
        TrainMut.SendMessage("%bCLEAN:%w removes trash and various leftovers from the map.", KFController);
        TrainMut.SendMessage("%bALTSPEED:%w changes a preset value that can be used with %b'SLOMO'%w command.", KFController);
        TrainMut.SendMessage("%bLOCK:%w locks the use of cheat commands.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b ZEDRULES:%w manages rules for replacing one zed types with the others.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b FORCEHEALTH:%w toggles forcing zed's health to be at least on the level with current amount of alive players.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b SLOMO:%w sets speed of the game.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b MAXZEDS:%w sets how many zeds can spawn at once on the map.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b DOSH:%w gives money to the player.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b AMMO:%w replenishes ammunition of the player or fills-up magazines of his weapons.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b ARMOR:%w gives player armor.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b GIVE:%w gives player specified weapon.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b SKIP:%w skips the rest of a wave or trader time.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b WAVE:%w changes next wave.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b WAVESIZE:%w sets amount of zeds in a wave.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b RESTART:%w restarts a wave.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b KILL:%w kills every (optionally only of certain type) zed on a map.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b REFRESH:%w restores health.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b TRADETIME:%w allows to either change a trade counter's value or stop it's countdown.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b SPAWNRATE:%w sets zed spawn rate.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b GOD:%w enables/disables god mode.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b DGOD:%w enables/disables demi-god mode.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b GODAMMO:%w enables/disables automatic ammo replenishment.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b SAFEGUARD:%w enables/disables safeguard and manages it\'s settings.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b BARS:%w enables/disables health bars for zeds.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b HITBOXES:%w enables/disables head hit-boxes for zeds.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b SPAWNDOORS:%w re-spawns destroyed doors.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b WELD:%w welds doors to a given strength.", KFController);
        TrainMut.SendMessage("%r[CHEAT]%b BLOCKDOORS:%w prevents zeds from breaking/attacking welded doors.", KFController);
        TrainMut.SendMessage("- List of other help entries:", KFController);
        TrainMut.SendMessage("%bALIAS:%w alternative name for in-game object, that's more comfortable for human use.", KFController);
    }
    else if(arg ~= "FORMAT"){
        TrainMut.SendMessage("%bFORMAT %bPREFS%w/(%bLINELEN %y#%w)/%bCOLOR%w(%bON%w/%bOFF%w)", KFController);
        TrainMut.SendMessage("    This command manages console output settings. Not a cheat.", KFController);
        TrainMut.SendMessage("    %bPREFS%w show current output settings.", KFController);
        TrainMut.SendMessage("    %bLINELEN%w changes current maximum line length.", KFController);
        TrainMut.SendMessage("    %bCOLOR%w toggles coloured output on and off.", KFController);
    }
    else if(arg ~= "PREFS"){
        TrainMut.SendMessage("%bPREFS", KFController);
        TrainMut.SendMessage("    This command outputs info about current settings. Not a cheat.", KFController);
    }
    else if(arg ~= "DRAMA"){
        TrainMut.SendMessage("%bDRAMA ON%w/%bOFF", KFController);
        TrainMut.SendMessage("    This command enables/disables zed time. Not a cheat.", KFController);
    }
    else if(arg ~= "FAKED"){
        TrainMut.SendMessage("%bFAKED %y#", KFController);
        TrainMut.SendMessage("    This command sets amount of faked players. Not a cheat.", KFController);
    }
    else if(arg ~= "SLOMOMSG"){
        TrainMut.SendMessage("%bSLOMOMSG ON%w/%bOFF", KFController);
        TrainMut.SendMessage("    This command enables/disables messages about manual change of game's speed. Not a cheat.", KFController);
    }
    else if(arg ~= "PAUSE"){
        TrainMut.SendMessage("%bPAUSE", KFController);
        TrainMut.SendMessage("    This command toggles game pause. Not a cheat.", KFController);
    }
    else if(arg ~= "HEALTH"){
        TrainMut.SendMessage("%bHEALTH %w(%b{HUGE%w/%bBIG%w/%bTRASH%w/%bSMALL%w/%bBOSS} {HEAD%w/%bBODY} %y#%w) / (%bON%w/%bOFF%w)", KFController);
        TrainMut.SendMessage("    This command changes health level of zeds. Not a cheat.", KFController);
        TrainMut.SendMessage("    Numeric parameter represents amount of players for which health should be scaled.", KFController);
        TrainMut.SendMessage("    If %b'HUGE'%w or %b'BIG'%w modifiers are specified," @
            "then health level change will only affect specimens with base health above or equal to %y1000%w" @
            "(the only such vanilla zeds are %bscrake%w and %bfleshpound%w).", KFController);
        TrainMut.SendMessage("    If %b'TRASH'%w or %b'SMALL'%w modifiers are specified," @
            "then health level change will only affect specimens with base health less than %y1000%w.", KFController);
        TrainMut.SendMessage("    Adding %b'HEAD'%w or %b'BODY'%w modifiers means" @
            "that you only want to change health in head or body respectively.", KFController);
        TrainMut.SendMessage("    To change the patriarch's health level, use %b'BOSS'%w modifier." @
            "In this case %b'HEAD'%w or %b'BODY'%w modifiers won't have any effect.", KFController);
        TrainMut.SendMessage("    By default zeds' health levels won't scale below current amount of players. This behavior can be changed via %b'FORCEHEALTH'%w command.", KFController);
        TrainMut.SendMessage("    %b'ON'%w/%b'OFF'%w switches activates/deactivates health change for zeds." @
            "Deactivation means that settings set by this or %b'HEALTHRULES'%w commands won't have any effect.", KFController);
        TrainMut.SendMessage("    Any correct use of %b'HEALTH'%w command also activates health changes.", KFController);
    }
    else if(arg ~= "HEALTHRULES"){
        TrainMut.SendMessage("%bHEALTHRULES CLEAR%w/%bLIST%w/(%bREMOVE #%w)/%bADD%w(%b{#s} #s {#s} %y#%w)", KFController);
        TrainMut.SendMessage("    This command manages rules for changing health level of certain zed type. Not a cheat.", KFController);
        TrainMut.SendMessage("    Health settings made by %b'HEALTH'%w command will be overridden by health rules" @
            "that specify head or/and body health levels for a given zed type.", KFController);
        TrainMut.SendMessage("    Zed can be specified either by %balias%w (see %b'HELP ALIAS'%w) or it's class.", KFController);
        TrainMut.SendMessage("    If there's several rules created for one zed - the latest of them will take effect.", KFController);
        TrainMut.SendMessage("    %b'CLEAR'%w will erase all the existing rules.", KFController);
        TrainMut.SendMessage("    %b'LIST'%w will display all the currently active rules.", KFController);
        TrainMut.SendMessage("    %b'REMOVE'%w will remove a single rule with a given number (numbers of rules can be seen by using %b'LIST'%w command)", KFController);
        TrainMut.SendMessage("    %b'ADD'%w will add a new rule. For that you first must specify a zed with either" @
            "a class name in format %b'PACKAGE.CLASSNAME'%w or an %balias%w in format %b'{ALIASGROUP} ALIAS'%w;" @
            "then, optionally, you can specify either %b'HEAD'%w or %b'BODY'%w (see %b'HELP HEALTH'%w for more details);" @
            "and, finally, you need to specify desired health level.", KFController);
        TrainMut.SendMessage("    Note: By default zeds' health levels won't scale below current amount of players. This behavior can be changed via %b'FORCEHEALTH'%w command.", KFController);
        TrainMut.SendMessage("    Note 2: even though command requires to specify package name for zed's class," @
            "it won't be actually used because reasons. So you can use any non-empty word for it: like %b'whatever.ZombieHusk_STANDARD'%w.", KFController);
        TrainMut.SendMessage("    Note 3: patriarch's health cannot be changed by this command.", KFController);
        TrainMut.SendMessage("    Note 4: health rules can be deactivated by using %b'HEALTH OFF'%w command.", KFController);
    }
    else if(arg ~= "CLEAN"){
        TrainMut.SendMessage("%bCLEAN", KFController);
        TrainMut.SendMessage("    This command removes trash and various leftovers from the map. Not a cheat.", KFController);
    }
    else if(arg ~= "ALTSPEED"){
        TrainMut.SendMessage("%bALTSPEED %y#f%w/%bSHOW%w/%bGET", KFController);
        TrainMut.SendMessage("    This command changes a preset value that can be used with %b'SLOMO'%w command.", KFController);
        TrainMut.SendMessage("    If either %b'SHOW'%w or %b'GET'%w modifier was used instead of numeric value, - command will display the current value of the preset.", KFController);
        TrainMut.SendMessage("    Command is never considered a cheat by itself.", KFController);
    }
    else if(arg ~= "LOCK"){
        TrainMut.SendMessage("%bLOCK ON%w/%bOFF", KFController);
        TrainMut.SendMessage("    This command locks the use of cheat commands. Not a cheat.", KFController);
        TrainMut.SendMessage("    When lock is on, - all cheat commands are silently ignored.", KFController);
    }
    else if(arg ~= "ZEDRULES" || arg ~= "REPLACERULES" || arg ~= "REPLACEMENTRULES"){
        TrainMut.SendMessage("%bZEDRULES%w/%bREPLACERULES%w/%bREPLACEMENTRULES CLEAR%w/%bLIST%w/(%bREMOVE #%w)/(%bADD%w/%b'REPLACE'%w) (%b{#s} #s with {#s} #s%w)", KFController);
        TrainMut.SendMessage("    This command manages rules for changing replacing certain zed types with others.", KFController);
        TrainMut.SendMessage("    Zed can be specified either by %balias%w (see %b'HELP ALIAS'%w) or it's class.", KFController);
        TrainMut.SendMessage("    Rules will be applied in order they were inserted." @
            "If you add rule to replace zed type A with type B and then B with C, - effectively type A will be replaced with C.", KFController);
        TrainMut.SendMessage("    %b'CLEAR'%w will erase all the existing rules.", KFController);
        TrainMut.SendMessage("    %b'LIST'%w will display all the currently active rules.", KFController);
        TrainMut.SendMessage("    %b'REMOVE'%w will remove a single rule with a given number (numbers of rules can be seen by using %b'LIST'%w command)", KFController);
        TrainMut.SendMessage("    %b'ADD'%w/%b'REPLACE'%w will add a new rule. For that you first must specify zed type you want to replace with either" @
            "a class name in format %b'PACKAGE.CLASSNAME'%w or an %balias%w in format %b'{ALIASGROUP} ALIAS'%w;" @
            "and then, after keyword %b'WITH'%w, new zed type should be specified, again, by either class or alias.", KFController);
        TrainMut.SendMessage("    Note - even though command requires to specify package name for zed's class," @
            "it won't be actually used because reasons. So you can use any non-empty word for it: like %b'whatever.ZombieHusk_STANDARD'%w.", KFController);
        TrainMut.SendMessage("    Note 2 - patriarch cannot be replaced by this command.", KFController);
        TrainMut.SendMessage("    Using this command to add rules is always considered a cheat.", KFController);
    }
    else if(arg ~= "FORCEHEALTH"){
        TrainMut.SendMessage("%bFORCEHEALTH ON%w/%bOFF", KFController);
        TrainMut.SendMessage("    This command allows for forcing zed's health to be at least on the level with current amount of alive players," @
            "regardless of the settings made by %b'HEALTH'%w or %b'bHEALTHRULES'%w commands.", KFController);
        TrainMut.SendMessage("    Disabling forcing (%b'OFF'%w) leads to adding a cheat each time a zed," @
            "with health less than it should have had for current amount of alive players, spawns.", KFController);
    }
    else if(arg ~= "SLOMO"){
        TrainMut.SendMessage("%bSLOMO %y#f%w/%bALT", KFController);
        TrainMut.SendMessage("    This command sets speed of the game. %y1.0%w is normal speed.", KFController);
        TrainMut.SendMessage("    If %b'ALT'%w modifier was used instead of numeric value, - command will change speed to preset made by %b'ALTSPEED'%w command", KFController);
        TrainMut.SendMessage("    Not considered a cheat if you set speed above %y1.0%w.", KFController);
    }
    else if(arg ~= "MAXZEDS"){
        TrainMut.SendMessage("%MAXZEDS %y#%w/%bDEFAULT", KFController);
        TrainMut.SendMessage("    This command sets how many zeds can spawn at once on the map (at least 5).", KFController);
        TrainMut.SendMessage("    %b'DEFAULT'%w modifier restores initial value (prior any changes).", KFController);
        TrainMut.SendMessage("    Changes will take effect after new wave starts.", KFController);
        TrainMut.SendMessage("    Not considered a cheat if you set amount above or equal default one.", KFController);
    }
    else if(arg ~= "DOSH"){
        TrainMut.SendMessage("%bDOSH %y#", KFController);
        TrainMut.SendMessage("    This command gives money to the player. Amount can be negative.", KFController);
        TrainMut.SendMessage("    Considered a cheat if it's is greater than %y0%w.", KFController);
    }
    else if(arg ~= "AMMO"){
        TrainMut.SendMessage("%bAMMO {FILL}", KFController);
        TrainMut.SendMessage("    This command replenishes ammunition of the player unless %b'FILL'%w keyword was specified," @
            "in which case command fills-up magazines of all player's weapons.", KFController);
        TrainMut.SendMessage("    Always considered a cheat.", KFController);
    }
    else if(arg ~= "ARMOR"){
        TrainMut.SendMessage("%bARMOR {NONE%w/%bLIGHT%w/%bCOWBOY%w/%bHEAVY%w/%bHORZINE%w/%bCURRENT}", KFController);
        TrainMut.SendMessage("    This command gives player armor of given type.", KFController);
        TrainMut.SendMessage("    %b'light'%w and %b'cowboy'%w gives you armoured jacked. %b'heavy'%w and %b'horzine'%w - horzine armor.", KFController);
        TrainMut.SendMessage("    %b'current'%w would replenish current armor type and %b'none'%w would remove any armor player had.", KFController);
        TrainMut.SendMessage("    To get a regular armor just omit any of these modifiers or enter anything else, like %b'normal'%w.", KFController);
        TrainMut.SendMessage("    On vanilla (when %pScrN Balance%w game type isn't detected) all types," @
            "except for %b'none'%w, count as a regular armor.", KFController);
        TrainMut.SendMessage("    A cheat if player actually gets it (also, zeroing armor doesn't count as cheat on vanilla).", KFController);
    }
    else if(arg ~= "GIVE"){
        TrainMut.SendMessage("%bGIVE {#s} #s", KFController);
        TrainMut.SendMessage("    This command gives player specified weapon. You can enter either name of it's class or it's alias.", KFController);
        TrainMut.SendMessage("    If two string parameters have been specified, - then first one is group name for an alias.", KFController);
        TrainMut.SendMessage("    Considered a cheat if weapons has actually spawned.", KFController);
        TrainMut.SendMessage("    %b'mutate help alias'%w for more info.", KFController);
    }
    else if(arg ~= "SKIP"){
        TrainMut.SendMessage("%bSKIP {QUICK%w/%bNOW}", KFController);
        TrainMut.SendMessage("    This command skips wave or a trader (leaving player with last 5 seconds of count-down).", KFController);
        TrainMut.SendMessage("    If %b'QUICK'%w or %b'NOW'%w modifier was used during trader time, - last 5 seconds of trader will be omitted.", KFController);
        TrainMut.SendMessage("    Not a cheat if skips a trader.", KFController);
    }
    else if(arg ~= "FINALWAVE"){
        TrainMut.SendMessage("%bFINALWAVE ON%w/%bOFF#", KFController);
        TrainMut.SendMessage("    This command disables the final wave and forces the wave before it instead.", KFController);
        TrainMut.SendMessage("    Cheat is triggered each time final wave is set to be avoided (happens either at the start of a trader or a wave).", KFController);
    }
    else if(arg ~= "WAVE"){
        TrainMut.SendMessage("%bWAVE %y#", KFController);
        TrainMut.SendMessage("    This command changes next wave. 1st wave is 1. Will clamp given number between 1 and boss wave.", KFController);
        TrainMut.SendMessage("    %b'FINALWAVE'%w can prevent patriarch's wave from starting even if you've chosen it.", KFController);
        TrainMut.SendMessage("    Not a cheat if sets the next wave to be the same.", KFController);
    }
    else if(arg ~= "WAVESIZE"){
        TrainMut.SendMessage("%bWAVESIZE %y#", KFController);
        TrainMut.SendMessage("    This command sets amount of zeds in a wave. Can't be lower than amount of zeds that has already spawned.", KFController);
        TrainMut.SendMessage("    Always a cheat.", KFController);
    }
    else if(arg ~= "RESTART"){
        TrainMut.SendMessage("%bWAVESIZE %y#", KFController);
        TrainMut.SendMessage("    This command restarts a wave. A cheat.", KFController);
    }
    else if(arg ~= "KILL"){
        TrainMut.SendMessage("%bKILL { {#s} #s }", KFController);
        TrainMut.SendMessage("    Without any parameters this command kills every zed on a map.", KFController);
        TrainMut.SendMessage("    Alternatively you can specify either a class name (in format %b'PACKAGE.CLASSNAME'%w) or an %balias%w (in format %b'{ALIASGROUP} ALIAS'%w)" @
            "of a zed type you want to wipe off the map.", KFController);
        TrainMut.SendMessage("    Not a cheat if there's nothing to kill.", KFController);
    }
    else if(arg ~= "REFRESH"){
        TrainMut.SendMessage("%bREFRESH", KFController);
        TrainMut.SendMessage("    This command restores health.", KFController);
        TrainMut.SendMessage("    Not a cheat if player is already healthy.", KFController);
    }
    else if(arg ~= "TRADETIME"){
        TrainMut.SendMessage("%bTRADETIME %y#%w/%bPAUSE%w/%bAUTOPAUSE", KFController);
        TrainMut.SendMessage("    This command allows to either change a trade counter's value or stop it's countdown.", KFController);
        TrainMut.SendMessage("    If integer value was used as a parameter - command sets that to be new value of a trade time counter.", KFController);
        TrainMut.SendMessage("    If %b'PAUSE'%w was used, - it toggles pause on trade time counter."@
            "Doesn't set an actual game pause.", KFController);
        TrainMut.SendMessage("    If %b'AUTOPAUSE'%w was used, - trade time will be paused at the start of each wave.", KFController);
        TrainMut.SendMessage("    Does nothing if last %y5%w seconds of trade time began.", KFController);
        TrainMut.SendMessage("    Counts as cheat each time trade time is extended or paused (%b'AUTOPAUSE'%w can cause several cheat notices).", KFController);
    }
    else if(arg ~= "SPAWNRATE"){
        TrainMut.SendMessage("%bSPAWNRATE %y#f", KFController);
        TrainMut.SendMessage("    This command sets zed spawn rate." @
            "Using %b'default'%w instead of numeric parameter restores initial spawn rate.", KFController);
        TrainMut.SendMessage("    Not a cheat if new rate is lower than default one.", KFController);
    }
    else if(arg ~= "GOD" || arg ~= "GODMODE"){
        TrainMut.SendMessage("(%bGOD%w/%bGODMODE) (ON%w/%bOFF)", KFController);
        TrainMut.SendMessage("    This command enables/disables invincibility mode. A cheat to enable.", KFController);
    }
    else if(arg ~= "DGOD" || arg ~= "DEMIGOD" || arg ~= "DEMIGODMODE"){
        TrainMut.SendMessage("(%bDGOD%w/%bDEMIGOD%w/%bDEMIGODMODE%w) (%bON%w/%bOFF)", KFController);
        TrainMut.SendMessage("    This command enables/disables demi-god mode.", KFController);
        TrainMut.SendMessage("    You aren't invincible, unlike in a god mode, but you will always survive deadly attacks with 1 HP.", KFController);
        TrainMut.SendMessage("    A cheat to enable.", KFController);
    }
    else if(arg ~= "GODAMMO"){
        TrainMut.SendMessage("%bGODAMMO ON%w/%bOFF%w/(%bMAGS ON%w/%bOFF%w)", KFController);
        TrainMut.SendMessage("    This command enables/disables automatic ammo replenishment.", KFController);
        TrainMut.SendMessage("    %b'MAGS'%w option allows to enable/disable automatic magazine fill-up.", KFController);
        TrainMut.SendMessage("    A cheat to enable.", KFController);
    }
    else if(arg ~= "SAFEGUARD"){
        TrainMut.SendMessage("%bSAFEGUARD ON%w / %bOFF%w / (%bARMOR #s%w) / (%bREACTION NONE%w/%bKILL%w/%bTRADE%w/%bRESTART%w) / (%bAUTOAMMO ON%w/%bOFF%w) / (%bAUTOMAGS ON%w/%bOFF%w)" @
            "/ (%bRESTOREZEDS ON%w/%bOFF%w)%w) / (%bRADIUS %y#f%w)", KFController);
        TrainMut.SendMessage("    This command enables/disables SafeGuard and manages it's settings.", KFController);
        TrainMut.SendMessage("    SafeGuard tracks your health and replenishes it (and armor) the moment you should\'ve been killed.", KFController);
        TrainMut.SendMessage("    Upon such rescue it can perform some additional actin (kill nearby zeds by default).", KFController);
        TrainMut.SendMessage("    %bON%w/%bOFF%w switches enable or disable SafeGuard. Enabling it is considered cheating," @
            "but actions of SafeGuard themselves aren't.", KFController);
        TrainMut.SendMessage("    %bARMOR #s%w sets the type of armor (%b'mutate help armor'%w for more info)" @
            "that SafeGuard should restore upon your rescue.", KFController);
        TrainMut.SendMessage("    %bREACTION NONE%w/%bKILL%w/%bTRADE%w/%bRESTART%w sets which action SafeGuard should perform by default:", KFController);
        TrainMut.SendMessage("      %b'NONE'%w means SafeGuard won't do anything else,", KFController);
        TrainMut.SendMessage("      %b'KILL'%w means SafeGuard will kill all zeds near player (except for boss),", KFController);
        TrainMut.SendMessage("      %b'TRADE'%w means SafeGuard will force end to wave and trader time to start,", KFController);
        TrainMut.SendMessage("      %b'RESTART'%w means SafeGuard will restart current wave.", KFController);
        TrainMut.SendMessage("    %b'bAUTOAMMO'%w and %b'bAUTOMAGS'%w commands allow to enable, respectively," @
            "automatic ammo / magazines refill for all player's weapons upon rescue.", KFController);
        TrainMut.SendMessage("    %bRESTOREZEDS ON%w/%bOFF%w sets whether SafeGuard should add number of killed zeds back to the wave counter" @
            "(adds by default, only relevant when %b'KILL'%w reaction is active).", KFController);
        TrainMut.SendMessage("    %bRADIUS %y#f%w sets at what distance SafeGuard should kill zeds around you (only relevant when %b'KILL'%w reaction is active)." @
            "%b'default'%w instead of numeric parameter restores initial value %y1000%w.", KFController);
        TrainMut.SendMessage("    %bGODTIME %y#f%w sets how much time player should spend invincible after the rescue.", KFController);
    }
    else if(arg ~= "BARS"){
        TrainMut.SendMessage("%bBARS ON%w/%bOFF", KFController);
        TrainMut.SendMessage("    This command enables/disables visible health bars for zeds. Always a cheat.", KFController);
    }
    else if(arg ~= "HITBOXES"){
        TrainMut.SendMessage("%bHITBOXES ON%w/%bOFF%w/(%bSERVER%w/%bCLIENT ON%w/%bOFF%w)/(%bSCALE EASY%w/%bNORMAL%w/%bHARD)/(SEGMENTS %y#%w)", KFController);
        TrainMut.SendMessage("    This command enables/disables head hit-boxes for zeds.", KFController);
        TrainMut.SendMessage("    You can specify if you want to show/hide server- or client-side hit-boxes by using %b'SERVER'%w and %b'CLIENT'%w respectively.", KFController);
        TrainMut.SendMessage("    If that specifier is omitted and only %b'ON'%w or %b'OFF'%w keyword is used, server-side hit-boxes will be displayed/hidden.", KFController);
        TrainMut.SendMessage("    %b'SCALE'%w option allows to set size of displayed hit-boxes:", KFController);
        TrainMut.SendMessage("      %b'HARD'%w means that none of the additional online scaling will be applied,", KFController);
        TrainMut.SendMessage("      %b'NORMAL'%w means regular online headshot scaling will be applied (but only in cases when it's used in real hit-shot detection),", KFController);
        TrainMut.SendMessage("      %b'EASY'%w is only different from 'HBSIZE_NORMAL' in case when NicePack is active (and for zeds from that mutator), -" @
            "then extended online scaling is applied.", KFController);
        TrainMut.SendMessage("    %b'SEGMENTS'%w allows to specify level of detalization of hit-box spheres; any natural number between 5 and 30 can be use.", KFController);
        TrainMut.SendMessage("    Activating hit-boxes is considered a cheat", KFController);
    }
    else if(arg ~= "SPAWNDOORS"){
        TrainMut.SendMessage("%bSPAWNDOORS", KFController);
        TrainMut.SendMessage("    This command re-spawns destroyed doors.", KFController);
        TrainMut.SendMessage("    Not a cheat if no door was respawned.", KFController);
    }
    else if(arg ~= "WELD"){
        TrainMut.SendMessage("%bWELD ALL%w/%bLOCKED %y#f", KFController);
        TrainMut.SendMessage("    This command welds doors to a given strength (%y100%%w if value is omitted).", KFController);
        TrainMut.SendMessage("    Welds every door if %b'all'%w and only already welded ones if %b'locked'%w.", KFController);
        TrainMut.SendMessage("    Always a cheat.", KFController);
    }
    else if(arg ~= "BLOCKDOORS"){
        TrainMut.SendMessage("%bBLOCKDOORS ON%w/%bOFF", KFController);
        TrainMut.SendMessage("    This command prevents zeds from breaking/attacking welded doors.", KFController);
        TrainMut.SendMessage("    A cheat to enable.", KFController);
    }
    else if(arg ~= "ALIAS" || arg ~= "ALIASES"){
        TrainMut.SendMessage("%bAliases%w are alternative names for in-game objects that are comfortable for human use.", KFController);
        TrainMut.SendMessage("Several objects can correspond to one %balias%w," @
            "but then each of them must be mark to belong in a certain %bgroup%w.", KFController);
        TrainMut.SendMessage("That was made to allow using several versions of the same gun by the same name.", KFController);
        TrainMut.SendMessage("For example, by %b'ebr'%w one can mean a vanilla version," @
            "%pScrN Balance%w version or a version from %pNicePack%w.", KFController);
        TrainMut.SendMessage("Because of that, in commands such as %b'give'%w, there's often an optional parameter for an %balias group%w," @
            "that allows to specify a certain version: %b'give vanilla ebr'%w/%b'give scrn ebr'%w/%b'give nice ebr'", KFController);
        TrainMut.SendMessage("Also, several %baliases%w can point to the same set of objects.", KFController);
        TrainMut.SendMessage("%bAliases%w are defined in server config file. If you wish to add some new ones - contact server administrator.", KFController);
    }
}

defaultproperties
{
}
