class TrainingPackScrN extends Mutator
    config(TrainingPackScrN);

// Necessary variables for commands (cheats) to work. At least KFGameType must exist.
var KFGameType KFGT;
var ScrnGameType ScrnGT;
var ScrnBalance ScrnMut;

// These variables track whether or not cheats were used during game/wave
var bool bUsedCheats;
var bool bUsedCheatsThisWave;
// Default value for MaxZombiesOnce
var int defMaxZombiesOnce;
// Should we draw head hit-boxes?
var bool bShowHitboxesClient;
var bool bShowHitboxesServer;
enum EHitboxSize{
    HBSIZE_EASY,    // Only different from 'HBSIZE_NORMAL' in case when NicePack is active, - then it uses 'extOnlineHeadshotScale'
    HBSIZE_NORMAL,  // This adds 'OnlineHeadshotScale' scaling
    HBSIZE_HARD     // No online head hit-box scaling
};
var EHitboxSize HBoxSize;
// AMount of segments in head hit-box
var int HeadSegmentAmount;
// Disables zed-time
var bool bNoDrama;
// Amount of faked players and the means of achieving them
var int fakedPlayers;
var bool bForceVanillaFaked;
// Track whether we were in a trader time a moment before
var bool wasTraderTime;
// Enables health settings override if they're lower than health for current player amount
var bool bForceLowerHealthBound;
// Levels of health of particular zeds
var int TrashHeadHealth;
var int TrashBodyHealth;
var int HugeHeadHealth;
var int HugeBodyHealth;
var int BossHealth;
var bool bChangeHealth;
enum EZedPart{
    ZEDPART_HEAD,
    ZEDPART_BODY,
    ZEDPART_ALL
};
// If this flag is 'false' -- mutator will try to avoid setting final wave, choosing wave before it instead
var bool bActiveFinalWave;
// Value that will be used as a user's preset
var float altSpeed;
// A normal speed for the game that we'll try to enforce; set by a 'SLOMO' command
var float normalSpeed;
// Due to possible spam, allows to disable messages about game speed change
var bool bQuietSlomo;
// Variables that allow for delayed wave change
var bool bSetNextWave;
var int nextWave;
// Variables, indicating that we need to skip wave/trader
var bool bSkipWave;
var bool bSkipTrader;
// This variable indicates whether or not trader skip should be quick
var bool bQuickSkip;
// Cheat types
enum ECheatType{
    CHEAT_SLOMO,
    CHEAT_LEVEL,
    CHEAT_DOSH,
    CHEAT_WEAPON,
    CHEAT_AMMO,
    CHEAT_REFRESH,
    CHEAT_ARMOR,
    CHEAT_SKIP,
    CHEAT_WAVE,
    CHEAT_KILL,
    CHEAT_PAUSE,
    CHEAT_SETTIME,
    CHEAT_SPAWNRATE,
    CHEAT_WAVESIZE,
    CHEAT_GOD,
    CHEAT_DEMIGOD,
    CHEAT_SAFE,
    CHEAT_BARS,
    CHEAT_SPAWNDOORS,
    CHEAT_WELDDOORS,
    CHEAT_GODDOORS,
    CHEAT_ZEDHEALTH,
    CHEAT_ZEDTYPE,
    CHEAT_SYRINGE,
    CHEAT_GODAMMO,
    CHEAT_AUTOMAG,
    CHEAT_SCARCEZEDS,
    CHEAT_HEADBOXES
};
// Cheat counts (2 for each cheat: in a whole game and in a current wave)
var array<int> globalCheats;
var array<int> waveCheats;
// Other cheat-related variables
var bool bLockCheats;
var array<String> cheatsDescription;
// Remembers if and at what time trader time paused
var int pausedTraderTime;
var bool bTraderPaused;
var bool bTraderAutoPause;
// Remembers default spawn rate and the one chosen by player (negative, if default)
var float defaultSpawnRate;
var float currentSpawnRate;
// Are we in a god/demigod mode
var bool bGodMode;
var bool bDemiGodMode;
//Is constant ammo/magazines regeneration activated?
var bool bGodAmmo;
var bool bGodAmmoFillMags;
// SafeGuard-related variables
var bool bSafeGuard;
var float SafeGuardKillRadius;
var float SafeGuardInvincibilityTime;
var float SafeGuardInvincibilityCountDown;
var string SafeGuardArmor;
var int SafeGuardRescueAmount;
var int SafeGuardWaveRescueAmount;
var bool bSafeGuardRestoreKilled;
var bool bSafeGuardFillAmmo;
var bool bSafeGuardFillMags;
enum ESGReaction{
    REACTION_NONE,
    REACTION_KILL,
    REACTION_TRADE,
    REACTION_RESTART
};
var ESGReaction SafeGuardReaction;
// Was our interaction for healthbars added?
var bool bInteractionAdded;
// Should we show zed's healthbars?
var bool bShowBars;
// Store doors and whether they were found already
var transient array<KFUseTrigger> DoorKeys;
var bool bDoorsFound;
// Are zeds ignoring doors?
var bool bDoorsIgnored;

// Reference to some class, either through alias or directly through name
struct ClassRef{
    // Does it set though alias?
    var bool bRefByAlias;
    // Alias reference parameters
    var String alias;
    var String aliasGroup;
    // Direct reference parameter
    var String className;
};

// Struct that describes one rule for modifying zed's health
struct HealthRule{
    // Reference to class of zed to which we want to apply our rule
    var ClassRef zed;
    // Parameters that set new head and body health levels for given zed; -1 means that this rule should modify a value
    var int headHealth;
    var int bodyHealth;
};
var array<HealthRule> healthRules;

// Enum, structs and variables to manage weapon aliases
enum EAliasType{
    ALIAS_WEAPON,
    ALIAS_ZED,
    ALIAS_ALL
};
struct IDRecord{
    var String GroupName;
    var String ID;
};
struct AliasRecord{
    var EAliasType Type;
    var array<IDRecord> IDs;
    var array<String> Aliases;
};
var array<AliasRecord> AliasDatabase;
var array<String> groupOrder;           // Defines id groups priorities; when given several IDs (class names) for an alias we use that to decide what to use
var config String groupPriority;        // Setting, from which we read priorities
var config String vanillaGroupPriority; // Same, but in case ScrN game type wasn't detected
var config array<String> weaponAliases; // Config with weapons' aliases
var config array<String> zedAliases;    // Config with zed's aliases
var config bool bOnlyPlayers;           // Option that allows restricting access to commands only to actual players

// Default squad array
var bool                            bDefInitCopied;         // Did we already fill 'defInitSquads' variable?
var bool                            bNeedToBackupInitList;  // 'True' if player has already attempted to replace init squads when they were still empty; this check is most likely not needed
var array<KFGameType.MSquadsList>   defInitSquads;          // Default normal initial squads

// Struct that describes one rule for modifying zed type
struct ReplacementRule{
    // Ignore 'oldZed' reference, - this rule says we must replace ALL zeds with a 'newZed'
    var bool bReplaceAll;
    // Reference to class of zed which we want to replace
    var ClassRef oldZed;
    // Reference to class of zed which we want to be a replacement
    var ClassRef newZed;
};
var array<ReplacementRule> replacementRules;

// Formatting options
var config int maxLineLength;   // Length of the output line
var config bool bEnableColour;

replication{
    reliable if(Role == ROLE_Authority)
        bUsedCheats, bShowBars, bShowHitboxesClient, bShowHitboxesServer, HeadSegmentAmount, HBoxSize;
}
function PostBeginPlay(){
    local int i;
    Super.PostBeginPlay();
    // Find game types and game replication info
    KFGT = KFGameType(Level.Game);
    if(KFGT == none){
        Log("ERROR: Wrong GameType (requires at least KFGameType)", Class.Outer.Name);
        Destroy();
        return;
    }
    // Record default amount for maximal zombies on map
    defMaxZombiesOnce = Max(KFGT.MaxZombiesOnce, 32);
    // Detect other game types
    ScrnGT = ScrnGameType(Level.Game);
    if(ScrnGT != none)
        ScrnMut = ScrnGT.ScrnBalanceMut;

    // Add this mutator into our custom game type
    if(TrainVanillaGT(KFGT) != none)
        TrainVanillaGT(KFGT).Mut = Self;
    else if(TrainScrnGT(KFGT) != none)
        TrainScrnGT(KFGT).Mut = Self;
    else
        Log("ERROR: Loaded gametype isn't one of the TrainingPack's game types. Some features will not function correctly.", Class.Outer.Name);

    // Setup cheats descriptions and flags
    cheatsDescription[ECheatType.CHEAT_SLOMO] = "slower time";
    cheatsDescription[ECheatType.CHEAT_LEVEL] = "high levels";
    cheatsDescription[ECheatType.CHEAT_DOSH] = "free dosh";
    cheatsDescription[ECheatType.CHEAT_WEAPON] = "free weapons";
    cheatsDescription[ECheatType.CHEAT_AMMO] = "free ammo";
    cheatsDescription[ECheatType.CHEAT_REFRESH] = "full health";
    cheatsDescription[ECheatType.CHEAT_ARMOR] = "free armour change";
    cheatsDescription[ECheatType.CHEAT_SKIP] = "ditch the wave";
    cheatsDescription[ECheatType.CHEAT_WAVE] = "set wave";
    cheatsDescription[ECheatType.CHEAT_KILL] = "kill zeds";
    cheatsDescription[ECheatType.CHEAT_PAUSE] = "pause game";
    cheatsDescription[ECheatType.CHEAT_SETTIME] = "extend trader time";
    cheatsDescription[ECheatType.CHEAT_SPAWNRATE] = "zeds spawn slower";
    cheatsDescription[ECheatType.CHEAT_WAVESIZE] = "adjust wave size";
    cheatsDescription[ECheatType.CHEAT_GOD] = "god mode";
    cheatsDescription[ECheatType.CHEAT_DEMIGOD] = "demi-god mode";
    cheatsDescription[ECheatType.CHEAT_SAFE] = "safe guard";
    cheatsDescription[ECheatType.CHEAT_BARS] = "see health";
    cheatsDescription[ECheatType.CHEAT_SPAWNDOORS] = "spawn doors";
    cheatsDescription[ECheatType.CHEAT_WELDDOORS] = "lock doors";
    cheatsDescription[ECheatType.CHEAT_GODDOORS] = "zeds ignore doors";
    cheatsDescription[ECheatType.CHEAT_ZEDHEALTH] = "zeds have low health";
    cheatsDescription[ECheatType.CHEAT_ZEDTYPE] = "zeds' types changed";
    cheatsDescription[ECheatType.CHEAT_SYRINGE] = "better syringe";
    cheatsDescription[ECheatType.CHEAT_GODAMMO] = "eternal ammo";
    cheatsDescription[ECheatType.CHEAT_AUTOMAG] = "quick mag refill";
    cheatsDescription[ECheatType.CHEAT_SCARCEZEDS] = "small zeds numbers";
    cheatsDescription[ECheatType.CHEAT_HEADBOXES] = "see heads";
    for(i = 0;i < cheatsDescription.Length;i ++){
        globalCheats[i] = 0;
        waveCheats[i] = 0;
    }

    loadAliases();
    SetTimer(5.0, True);
}

simulated function Timer(){
    local KFMonster M;
    local Controller cIt;
    local PlayerController pcIt;
    local KFUseTrigger KFTrig;
    // Update timer tick rate
    SetTimer(0.1, True);
    // Setup faked players
    if(ScrnMut != none && !bForceVanillaFaked){
        ScrnMut.FakedPlayers = FakedPlayers + 1;
        if(PlayersAmount() > 0)
            KFGT.NumPlayers = 1;
        else
            KFGT.NumPlayers = 0;
    }
    else{
        if(PlayersAmount() > 0)
            KFGT.NumPlayers = FakedPlayers + 1;
        else
            KFGT.NumPlayers = 0;
    }
    // Give god's ammo
    if(bGodAmmo){
        for(cIt = Level.ControllerList;cIt != None;cIt = cIt.NextController){
            pcIt = PlayerController(cIt);
            if(pcIt != none && cIt.bIsPlayer && cIt.Pawn != None && cIt.Pawn.Health > 0){
                GiveAmmo(pcIt, true);
                if(bGodAmmoFillMags)
                    FillupMagazines(pcIt, true);
            }
        }
    }
    // Disable zed time if necessary
    if(bNoDrama || (KFGT.ZedTimeSlomoScale > normalSpeed)){
        KFGT.LastZedTimeEvent = Level.TimeSeconds;
    }
    // Manage trader pause
    if(bTraderPaused)
        KFGT.WaveCountDown = pausedTraderTime;
    // Do some initialization (find doors, spawn rate)
    if(!bDoorsFound){
        defaultSpawnRate = KFGT.KFLRules.WaveSpawnPeriod;
        foreach DynamicActors(class'KFUseTrigger', KFTrig)
            DoorKeys[DoorKeys.Length] = KFTrig;
        bDoorsFound = true;
    }
    // Track events and more
    if(KFGT.IsInState('MatchInProgress')){
        if(KFGT.bTradingDoorsOpen){         // Trader now
            // Trader skip
            if(bSkipTrader){
                if(bQuickSkip){
                    if(KFGT.WaveCountDown > 1){
                        KFGT.WaveCountDown = 1;
                        KFGameReplicationInfo(KFGT.GameReplicationInfo).MaxMonstersOn = false;
                        if(InvasionGameReplicationInfo(KFGT.GameReplicationInfo) != none)
                            InvasionGameReplicationInfo(KFGT.GameReplicationInfo).WaveNumber = KFGT.WaveNum;
                    }
                }
                else if(KFGT.WaveCountDown > 6)
                    KFGT.WaveCountDown = 6;
            }
            // Trader start event
            if(!wasTraderTime){
                wasTraderTime = true;
                TraderStart();
            }
        }
        if(!KFGT.bTradingDoorsOpen){
            // Wave skip
            if(bSkipWave){
                foreach DynamicActors(class'KFMonster', M)
                    M.KilledBy(M);
                KFGT.TotalMaxMonsters = 0;
                KFGameReplicationInfo(KFGT.GameReplicationInfo).MaxMonsters = 0;
            }
            // Wave start event
            if(wasTraderTime){              // Wave now
                wasTraderTime = false;
                WaveStart();
            }
        }
    }
}

simulated function Tick(float Delta){
    local PlayerController PC;
    local KFHumanPawn kfPawn;
    local TrainInteraction TInt;
    if(SafeGuardInvincibilityCountDown > 0.0){
        SafeGuardInvincibilityCountDown -= Delta;
        if(SafeGuardInvincibilityCountDown <= 0.0)
            foreach DynamicActors(class'KFHumanPawn', kfPawn)
                CleanupPlayer(kfPawn);
    }
    if(!bInteractionAdded){
        PC = Level.GetLocalPlayerController();
        if(PC != none){
            TInt = TrainInteraction(PC.Player.InteractionMaster.AddInteraction("TrainingPackScrN.TrainInteraction", PC.Player));
            TInt.RegisterMutator(Self);
            bInteractionAdded = true;
        }
    }
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant){
    local TrainHeadHitbox NewHitbox;
    local KFMonster monster;
    local bool isBoss;
    local int alivePlayersCount;

    monster = KFMonster(Other);
    isBoss = (ZombieBoss(Other) != none);
    // Add head hit-box
    if(Role == ROLE_Authority && monster != none){
        NewHitbox = Spawn(class'TrainingPackScrN.TrainHeadHitbox', monster);
        if(NewHitbox != None)
            NewHitbox.RegisterMutator(Self);
    }
    // Health alteration code
    if(bChangeHealth && monster != none){
        alivePlayersCount = AlivePlayersAmount();
        monster.Health *= ScaleZedHealth(monster, monster.PlayerCountHealthScale, monster.default.Health, alivePlayersCount, false, isBoss) / monster.NumPlayersHealthModifer();
        monster.HealthMax = monster.Health;
        monster.HeadHealth *= ScaleZedHealth(monster, monster.PlayerNumHeadHealthScale, monster.default.HeadHealth, alivePlayersCount, true, isBoss) / monster.NumPlayersHeadHealthModifer();
        //BroadcastToAll(String(alivePlayersCount)@String(monster.Health)@String(monster.HeadHealth));

        monster.MeleeDamage /= 0.75;
        monster.ScreamDamage /= 0.75;

        monster.SpinDamConst /= 0.75;
        monster.SpinDamRand /= 0.75;
    }
    return true;
}

function Mutate(string MutateString, PlayerController KFController){
    local int i;
    local KFHumanPawn PlayerPawn;
    local float weldStr;
    // Tokens from 'MutateString'
    local array<String> wordsArray;
    local String command, mod;
    // Array with command modifiers.
    // Always contains at least 10 elements, that may be empty strings if there wasn't enough modifiers.
    // Done for safe access without the need to check for bounds.
    local array<String> modArray;
    local String rescueLine, sgModeLine, gameTypeLine;
    local EZedPart zedPart; // change health for that part
    local int ArgumentShift;
    // Variable for healthrule/replacementrule construction
    local ClassRef reference;
    local HealthRule newHealthRule;
    local ReplacementRule newReplRule;
    // Transform our command into array for convenience
    wordsArray = SplitString(MutateString, " ");
    // Exit if command is empty
    if(wordsArray.Length == 0)
        return;
    // Fancier access
    command = wordsArray[0];
    if(wordsArray.Length > 1)
        mod = wordsArray[1];
    else
        mod = "";
    i = 0;
    while(i + 1 < wordsArray.Length || i < 10){
        if(i + 1 < wordsArray.Length)
            modArray[i] = wordsArray[i+1];
        else
            modArray[i] = "";
        i ++;
    }
    // Only players should be able to use commands
    if(bOnlyPlayers && (!KFController.bIsPlayer || KFController.Pawn == none || KFController.Pawn.Health <= 0))
        command = "";
    // Command parsing
    if(command ~= "PREFS"){
        // Regular solo or faked? Which method for faked? Is final wave ommited?
        if(FakedPlayers > 0){
            gameTypeLine = "Faked players:%y"@String(FakedPlayers)@"(+1)%w";
            if(ScrnGT != none && bForceVanillaFaked)
                gameTypeLine = gameTypeLine @ "via vanilla method";
        }
        else
            gameTypeLine = "Regular solo game";
        if(!bActiveFinalWave)
            gameTypeLine = gameTypeLine @ "/ final wave %romitted%w!";
        SendMessage(gameTypeLine, KFController);
        if(replacementRules.Length > 0){
            if(replacementRules.Length == 1)
                SendMessage("%y"$String(replacementRules.Length)@"%wzed replacement rule active", KFController);
            else
                SendMessage("%y"$String(replacementRules.Length)@"%wzed replacement rules active", KFController);
        }
        if(bGodMode)
            SendMessage("God mode %ractive", KFController);
        else if(bDemiGodMode)
            SendMessage("Demigod mode %ractive", KFController);
        if(bSafeGuard){
            if(SafeGuardRescueAmount <= 0)
                rescueLine = "";
            else if(SafeGuardRescueAmount == 1){
                if(SafeGuardWaveRescueAmount == 0)
                    rescueLine = "rescued once, ";
                else
                    rescueLine = "rescued once (this wave), ";
            }
            else{
                if(SafeGuardWaveRescueAmount <= 0)
                    rescueLine = "rescued"@String(SafeGuardRescueAmount)@"times (none this wave), ";
                else if(SafeGuardWaveRescueAmount == 1)
                    rescueLine = "rescued"@String(SafeGuardRescueAmount)@"times (once this wave), ";
                else
                    rescueLine = "rescued"@String(SafeGuardRescueAmount)@"times ("$String(SafeGuardWaveRescueAmount)@"times this wave), ";
            }
            if(SafeGuardReaction == REACTION_NONE)
                sgModeLine = "";
            else if(SafeGuardReaction == REACTION_KILL){
                sgModeLine = ", nearby zeds will be %rkilled%w upon rescue";
                if(bSafeGuardRestoreKilled)
                    sgModeLine $= ", %gwill %wcompensate for SafeGuard-killed zeds";
                else
                    sgModeLine $= ", %pwon't %wcompensate for SafeGuard-killed zeds";
                sgModeLine $= ", %bkill radius:%w"@String(SafeGuardKillRadius);
            }
            else if(SafeGuardReaction == REACTION_TRADE)
                sgModeLine = ", trader will start upon rescue";
            else if(SafeGuardReaction == REACTION_RESTART)
                sgModeLine = ", wave will restart upon rescue";
            if(bSafeGuardFillAmmo)
                sgModeLine $= ", ammo will be refilled";
            if(bSafeGuardFillMags)
                sgModeLine $= ", magazines will be filled";
            SendMessage("%bSafeGuard v4.0%w is %rrunning %w["$rescueLine$"%barmor type:%w"@SafeGuardArmor$sgModeLine$"]", KFController);
        }
        if(bUsedCheatsThisWave)
            SendMessage("%rCheated %wthis wave"@CheatList(true), KFController);
        if(bUsedCheats)
            SendMessage("%rCheated %wthis game"@CheatList(false), KFController);
        if(bShowBars)
            SendMessage("Enemy's health is %rvisible", KFController);
        if(bShowHitboxesClient || bShowHitboxesServer){
            if(bShowHitboxesServer)
                SendMessage("Server-side hit-boxes are %rdisplayed", KFController);
            if(bShowHitboxesClient)
                SendMessage("Client-side hit-boxes are %rdisplayed", KFController);
            if(HBoxSize == HBSIZE_HARD)
                BroadcastToAll("  No online scaling applied to zeds' hit-boxes.");
            else
                BroadcastToAll("  Normal online scaling applied to zeds' hit-boxes.");
        }
        if(bNoDrama)
            SendMessage("Zed-time %pdisabled", KFController);
        else
            SendMessage("Zed-time %genabled", KFController);
        if(normalSpeed < 1.0)
            SendMessage("Game speed:%r"@String(normalSpeed), KFController);
        else
            SendMessage("Game speed:%g"@String(normalSpeed), KFController);
        if(KFGT.MaxZombiesOnce < defMaxZombiesOnce)
            BroadcastToAll("Max zombies:%r"@String(KFGT.MaxZombiesOnce)$"%w, default:%y"@String(defMaxZombiesOnce));
        else
            BroadcastToAll("Max zombies:%g"@String(KFGT.MaxZombiesOnce)$"%w, default:%y"@String(defMaxZombiesOnce));
        if(currentSpawnRate >= 0){
            if(currentSpawnRate < defaultSpawnRate)
                SendMessage("Zed spawn rate:%r"@String(currentSpawnRate)$"%w, default rate:%y"@String(defaultSpawnRate), KFController);
            else
                SendMessage("Zed spawn rate:%g"@String(currentSpawnRate)$"%w, default rate:%y"@String(defaultSpawnRate), KFController);
        }
        else{
            if(KFGT.KFLRules.WaveSpawnPeriod < defaultSpawnRate)
                SendMessage("Zed spawn rate:%r"@String(KFGT.KFLRules.WaveSpawnPeriod)$"%w, default rate:"@String(defaultSpawnRate), KFController);
            else
                SendMessage("Zed spawn rate:%g"@String(KFGT.KFLRules.WaveSpawnPeriod)$"%w, default rate:"@String(defaultSpawnRate), KFController);
        }

        // Huge block for displaying zeds' health
        if(bChangeHealth){
            if(TrashHeadHealth == HugeHeadHealth && TrashBodyHealth == HugeBodyHealth){
                if(TrashHeadHealth == TrashBodyHealth)
                    SendMessage("Zeds' health level:"@String(TrashHeadHealth), KFController);
                else
                    SendMessage("Zeds' health level:"@String(TrashHeadHealth)@"head /"@String(TrashBodyHealth)@"body", KFController);
            }
            else{
                if(TrashHeadHealth == TrashBodyHealth)
                    SendMessage("Trash zeds' health level:"@String(TrashHeadHealth), KFController);
                else
                    SendMessage("Trash zeds' health level:"@String(TrashHeadHealth)@"head /"@String(TrashBodyHealth)@"body", KFController);
                if(HugeHeadHealth == HugeBodyHealth)
                    SendMessage("Huge zeds' health level:"@String(HugeHeadHealth), KFController);
                else
                    SendMessage("Huge zeds' health level:"@String(HugeHeadHealth)@"head /"@String(HugeBodyHealth)@"body", KFController);
            }
            SendMessage("Patriarch's health level:"@String(BossHealth), KFController);
            if(healthRules.Length > 0){
                if(healthRules.Length == 1)
                    SendMessage("%y+"@String(healthRules.Length)@"%whealth rule active", KFController);
                else
                    SendMessage("%y+"@String(healthRules.Length)@"%whealth rules active", KFController);
            }
            if(bForceLowerHealthBound)
                SendMessage("Forced health lower bound %genabled", KFController);
            else
                SendMessage("Forced health lower bound %rdisabled", KFController);
        }
        else
            SendMessage("Zeds' health alteration currently %rdisabled", KFController);

        if(ScrnMut != none){
            if(ScrnMut.MinLevel > 6)
                SendMessage("Minimal level:%r"@String(ScrnMut.MinLevel), KFController);
            else
                SendMessage("Minimal level:%g"@String(ScrnMut.MinLevel), KFController);
            if(ScrnMut.MaxLevel > 6)
                SendMessage("Maximal level:%r"@String(ScrnMut.MaxLevel), KFController);
            else
                SendMessage("Maximal level:%g"@String(ScrnMut.MaxLevel), KFController);
        }
    }
    else if(command ~= "FORMAT"){
        if(mod ~= "LINELEN" || mod ~= "LINELENGTH")
            SetMaxLineLength(Int(modArray[1]));
        else if(mod ~= "COLOR" || mod ~= "COLOUR"){
            if(modArray[1] ~= "ON")
                EnableColour(true);
            if(modArray[1] ~= "OFF")
                EnableColour(false);
        }
        else if(mod ~= "STATUS" || mod ~= "PREFS"){
            SendMessage("Current max line length is"@String(maxLineLength), KFController);
            if(bEnableColour)
                SendMessage("Colour output is currently %genabled", KFController);
            else
                SendMessage("Colour output is currently disabled", KFController);
        }
    }
    else if(command ~= "DRAMA"){
        if(mod ~= "ON")
            NoDrama(false);
        if(mod ~= "OFF")
            NoDrama(true);
    }
    else if(command ~= "CLEAN"){
        Clean();
    }
    else if(command ~= "FAKED"){
        if(modArray[1] ~= "VANILLA")
            SetFakedPlayers(Int(mod), true);
        else
            SetFakedPlayers(Int(mod), false);
    }
    else if(command ~= "MAXLEVEL"){
        SetMaxLevel(Int(mod), KFController);
    }
    else if(command ~= "MINLEVEL"){
        SetMinLevel(Int(mod), KFController);
    }
    else if(command ~= "HEALTH"){
        if(mod ~= "ON"){
            EnableHealthChange(true);
        }
        else if(mod ~= "OFF"){
            EnableHealthChange(false);
        }
        else{
            ArgumentShift = 0;    // this variable contains an information of whether or not we should shift to next modifier for health value
            // Find out which body part we want to modify
            if(mod ~= "HEAD" || modArray[1] ~= "HEAD"){
                zedPart = ZEDPART_HEAD;
                ArgumentShift = 1;
            }
            else if(mod ~= "BODY" || modArray[1] ~= "BODY"){
                zedPart = ZEDPART_BODY;
                ArgumentShift = 1;
            }
            else{
                zedPart = ZEDPART_ALL;
            }
            // Modify it
            if(mod ~= "BOSS"){
                if(modArray[1] ~= "HEAD" || modArray[1] ~= "BODY")
                    SetBossHealth(Int(modArray[2]));
                else
                    SetBossHealth(Int(modArray[1]));
            }
            else if(mod ~= "HUGE" || mod ~= "BIG"){
                SetHugeHealth(Int(modArray[1 + ArgumentShift]), zedPart);
            }
            else if(mod ~= "TRASH" || mod ~= "SMALL"){
                SetTrashHealth(Int(modArray[1 + ArgumentShift]), zedPart);
            }
            else{
                SetZedHealth(Int(modArray[0 + ArgumentShift]), zedPart);
            }
        }
    }
    else if(command ~= "FORCEHEALTH"){
        if(mod ~= "ON"){
            SetForceHealth(true);
        }
        if(mod ~= "OFF"){
            SetForceHealth(false);
        }
    }
    else if(command ~= "HEALTHRULES"){
        if(mod ~= "CLEAR"){
            healthRules.Length = 0;
        }
        else if(mod ~= "LIST"){
            if(healthRules.Length > 0)
                for(i = 0;i < healthRules.Length;i ++)
                    DisplayHealthRule("%y"$String(i+1)$". %w", healthRules[i], KFController);
            else
                SendMessage("There are no health rules!", KFController);
        }
        else if (mod ~= "REMOVE"){
            i = Int(modArray[1]) - 1;
            healthRules.Remove(i, 1);
            BroadcastToAll("Health rule number"@String(i+1)@"was removed");
        }
        else if(mod ~= "ADD"){
            ArgumentShift = 1;
            // -- ClassRef construction
            // Player gave us a class
            if(InStr(modArray[ArgumentShift], ".") > 0){
                reference = RefToClassName(modArray[ArgumentShift ++]);
            }
            // Player gave us an alias
            else{
                // There's only 4 valid possibilities
                // If it's an invalid input -> expect bullshit, I don't care about finesse at the moment
                // There's only 2 more modifiers => alias specified without group and no body part was listed
                if(modArray[2] != "" && modArray[3] == ""){
                    reference = RefToAlias(modArray[1], "");
                    ArgumentShift = 2; // Body part check should start here
                }
                // There's 4 or more modifiers => alias specified with group and body part was listed
                else if(modArray[4] != ""){
                    reference = RefToAlias(modArray[2], modArray[1]);
                    ArgumentShift = 3; // Body part check should start here
                }
                // There's 3 modifiers => case1: alias specified without group, but body part was listed
                else if(modArray[3] != "" && modArray[4] == "" && (modArray[2] ~= "HEAD" || modArray[2] ~= "BODY")){
                    reference = RefToAlias(modArray[1], "");
                    ArgumentShift = 2; // Body part check should start here
                }
                // There's 3 modifiers => case2: alias specified with group, but no body part was listed; the fallback case
                else{
                    reference = RefToAlias(modArray[2], modArray[1]);
                    ArgumentShift = 3; // Body part check should start here
                }
            }
            // -- HealthRule construction
            newHealthRule.zed = reference;
            newHealthRule.headHealth = 0;
            newHealthRule.bodyHealth = 0;
            // We begin at 'ArgumentShift' point
            // Check if body part was specified
            if(modArray[ArgumentShift] ~= "HEAD" || modArray[ArgumentShift] ~= "BODY"){
                if(modArray[ArgumentShift] ~= "HEAD")
                    newHealthRule.headHealth = Int(modArray[ArgumentShift + 1]);
                else
                    newHealthRule.bodyHealth = Int(modArray[ArgumentShift + 1]);
            }
            else{
                newHealthRule.headHealth = Int(modArray[ArgumentShift]);
                newHealthRule.bodyHealth = Int(modArray[ArgumentShift]);
            }
            healthRules[healthRules.Length] = newHealthRule;
        }
    }
    else if(command ~= "ZEDRULES" || command ~= "REPLACERULES" || command ~= "REPLACEMENTRULES"){
        if(mod ~= "CLEAR"){
            replacementRules.Length = 0;
            ApplyReplacementRules();
        }
        else if(mod ~= "LIST"){
            if(replacementRules.Length > 0)
                for(i = 0;i < replacementRules.Length;i ++)
                    DisplayReplacementRule("%y"$String(i+1)$". %w", replacementRules[i], KFController);
            else
                SendMessage("There are no zed rules!", KFController);
        }
        else if (mod ~= "REMOVE"){
            i = Int(modArray[1]) - 1;
            replacementRules.Remove(i, 1);
            ApplyReplacementRules();
            BroadcastToAll("Zed rule number"@String(i+1)@"was removed");
        }
        else if(mod ~= "ADD" || mod ~= "REPLACE"){
            newReplRule.bReplaceAll = false;
            if(modArray[1] ~= "ALL"){
                ArgumentShift = 3;
                newReplRule.bReplaceAll = true;
            }
            else if(InStr(modArray[1], ".") > 0){
                ArgumentShift = 3;
                reference = RefToClassName(modArray[1]);
            }
            else{
                // If second argument is "WITH" keyword, then alias was specified without a group
                if(modArray[2] ~= "WITH"){
                    ArgumentShift = 3;
                    reference = RefToAlias(modArray[1], "");
                }
                // Otherwise assume that it was specified with group
                else{
                    ArgumentShift = 4;
                    reference = RefToAlias(modArray[2], modArray[1]);
                }
            }
            newReplRule.oldZed = reference;
            if(InStr(modArray[ArgumentShift], ".") > 0){
                reference = RefToClassName(modArray[ArgumentShift]);
            }
            else{
                // Alias was specified without a group
                if(modArray[ArgumentShift + 1] == ""){
                    reference = RefToAlias(modArray[ArgumentShift], "");
                }
                // Alias was specified with group
                else{
                    reference = RefToAlias(modArray[ArgumentShift + 1], modArray[ArgumentShift]);
                }
            }
            newReplRule.newZed = reference;
            AddReplacementRule(newReplRule);
            ApplyReplacementRules();
        }
    }
    else if(command ~= "LOCK"){
        if(mod ~= "OFF")
            LockCheats(false);
        else
            LockCheats(true);
    }
    else if(command ~= "ALTSPEED"){
        if(mod ~= "SHOW" || mod ~= "GET"){
            if(altSpeed < 1.0)
                SendMessage("Alternative speed:%r"@String(altSpeed), KFController);
            else
                SendMessage("Alternative speed:%g"@String(altSpeed), KFController);
        }
        else
            SetAltSpeed(Float(mod));
    }
    else if(command ~= "SLOMO"){
        if(mod ~= "ALT")
            SetSpeed(-1.0);
        else
            SetSpeed(Float(mod));
    }
    else if(command ~= "SLOMOMSG"){
        if(mod ~= "ON")
            DisableSlomoMsg(false);
        if(mod ~= "OFF")
            DisableSlomoMsg(true);
    }
    else if(command ~= "MAXZEDS"){
        if(mod ~= "" || mod ~= "DEFAULT"){
            SetMaxZombies(defMaxZombiesOnce);
        }
        else{
            SetMaxZombies(Int(mod));
        }
    }
    else if(command ~= "DOSH"){
        GiveDosh(Int(mod), KFController);
    }
    else if(command ~= "GIVE"){
        if(modArray[1] != ""){
            modArray[1] = tryGetAlias(modArray[1], mod, ALIAS_WEAPON);
            GiveStuff(modArray[1], KFController);
        }
        else{
            mod = tryGetAlias(mod, "", ALIAS_WEAPON);
            GiveStuff(mod, KFController);
        }
    }
    else if(command ~= "AMMO"){
            if(mod ~= "FILL")
                FillupMagazines(KFController);
            else
                GiveAmmo(KFController);
    }
    else if(command ~= "ARMOR"){
        PlayerPawn = KFHumanPawn(KFController.Pawn);
        if(PlayerPawn != none)
            GiveArmor(mod, PlayerPawn, false);
    }
    else if(command ~= "SKIP"){
        if(mod ~= "QUICK" || mod ~= "NOW")
            Skip(true, false);
        else
            Skip(false, false);
    }
    else if(command ~= "FINALWAVE"){
        if(mod ~= "ON" || mod ~= "ENABLE")
            ActivateFinalWave(true);
        else if(mod ~= "OFF" || mod ~= "DISABLE")
            ActivateFinalWave(false);
    }
    else if(command ~= "WAVE"){
        ChooseWave(Int(mod));
    }
    else if(command ~= "WAVESIZE"){
        SetWaveSize(Int(mod));
    }
    else if(command ~= "RESTART"){
        RestartWave();
    }
    else if(command ~= "KILL"){
        if(mod == "" && mod != "ALL")
            KillAll();
        else if(mod != ""){
            if(InStr(mod, ".") > 0){
                reference = RefToClassName(mod);
            }
            else if(modArray[1] != ""){
                reference = RefToAlias(modArray[1], mod);
            }
            else{
                reference = RefToAlias(mod, "");
            }
            KillAllType(reference);
        }
    }
    else if(command ~= "REFRESH"){
        PlayerPawn = KFHumanPawn(KFController.Pawn);
        if(PlayerPawn != none)
            Refresh(PlayerPawn, false);
    }
    else if(command ~= "PAUSE"){
        Pause(KFController);
    }
    else if(command ~= "TRADETIME"){
        if(mod ~= "AUTOPAUSE"){
            if(modArray[1] ~= "ON")
                TradeAutoPause(true, KFController);
            else if(modArray[1] ~= "OFF")
                TradeAutoPause(false, KFController);
        }
        else if(mod ~= "PAUSE")
            TradeTime(-1, KFController);
        else
            TradeTime(Int(mod), KFController);
    }
    else if(command ~= "SPAWNRATE"){
        if(mod ~= "DEFAULT")
            SetSpawnRate(-1.0);
        else
            SetSpawnRate(Float(mod));
    }
    else if(command ~= "GOD" || command ~= "GODMODE"){
        if(mod ~= "ON")
            GodMode(true);
        else if(mod ~= "OFF")
            GodMode(false);
    }
    else if(command ~= "DGOD" || command ~= "DEMIGOD" || command ~= "DEMIGODMODE"){
        if(mod ~= "ON")
            DemiGodMode(true);
        else if(mod ~= "OFF")
            DemiGodMode(false);
    }
    else if(command ~= "GODAMMO"){
        if(mod ~= "ON")
            GodAmmo(true);
        else if(mod ~= "OFF")
            GodAmmo(false);
        else if(mod ~= "MAGS"){
            if(modArray[1] ~= "ON")
                GodAmmoMags(true);
            else if(modArray[1] ~= "OFF")
                GodAmmoMags(false);
        }
    }
    else if(command ~= "SAFEGUARD"){
        if(mod ~= "ON"){
            SafeGuard(true);
        }
        else if(mod ~= "OFF"){
            SafeGuard(false);
        }
        else if(mod ~= "RADIUS"){
            if(modArray[1] ~= "DEFAULT")
                SetSafeGuardKillRadius(1000.0);
            else
                SetSafeGuardKillRadius(Float(modArray[1]));
        }
        else if(mod ~= "ARMOR"){
            SetSafeGuardArmorType(modArray[1]);
        }
        else if(mod ~= "RESTOREZEDS"){
            if(modArray[1] ~= "ON")
                ShouldSafeGuardRestoreZeds(true);
            if(modArray[1] ~= "OFF")
                ShouldSafeGuardRestoreZeds(false);
        }
        else if(mod ~= "AUTOAMMO"){
            if(modArray[1] ~= "ON")
                ShouldSafeGuardRestoreAmmo(true);
            if(modArray[1] ~= "OFF")
                ShouldSafeGuardRestoreAmmo(false);
        }
        else if(mod ~= "AUTOMAGS"){
            if(modArray[1] ~= "ON")
                ShouldSafeGuardFillMags(true);
            if(modArray[1] ~= "OFF")
                ShouldSafeGuardFillMags(false);
        }
        else if(mod ~= "REACTION"){
            if(modArray[1] ~= "NONE")
                SetSafeGuardReaction(REACTION_NONE);
            else if(modArray[1] ~= "KILL" || modArray[1] ~= "WIPE")
                SetSafeGuardReaction(REACTION_KILL);
            else if(modArray[1] ~= "TRADE")
                SetSafeGuardReaction(REACTION_TRADE);
            else if(modArray[1] ~= "RESTART")
                SetSafeGuardReaction(REACTION_RESTART);
        }
        else if(mod ~= "GODTIME"){
            SetSafeGuardInvincibleTime(Float(modArray[1]));
        }
    }
    else if(command ~= "BARS"){
        if(mod ~= "ON"){
            ShowBars(true);
        }
        else if(mod ~= "OFF"){
            ShowBars(false);
        }
    }
    else if(command ~= "HITBOXES"){
        if(mod ~= "ON"){
            ShowServerHeadHitboxes(true);
        }
        else if(mod ~= "OFF"){
            ShowServerHeadHitboxes(false);
        }
        else if(mod ~= "SERVER"){
            if(modArray[1] ~= "ON"){
                ShowServerHeadHitboxes(true);
            }
            else if(modArray[1] ~= "OFF"){
                ShowServerHeadHitboxes(false);
            }
        }
        else if(mod ~= "CLIENT"){
            if(modArray[1] ~= "ON"){
                ShowClientHeadHitboxes(true);
            }
            else if(modArray[1] ~= "OFF"){
                ShowClientHeadHitboxes(false);
            }
        }
        else if(mod ~= "SCALE"){
            if(modArray[1] ~= "EASY" || modArray[1] ~= "EZ" || modArray[1] ~= "EXTENDED" || modArray[1] ~= "EXT"){
                SetHitBoxSize(HBSIZE_EASY);
            }
            else if(modArray[1] ~= "NORMAL" || modArray[1] ~= "REGULAR" || modArray[1] ~= "VANILLA"){
                SetHitBoxSize(HBSIZE_NORMAL);
            }
            else if(modArray[1] ~= "REAL" || modArray[1] ~= "HARD"){
                SetHitBoxSize(HBSIZE_HARD);
            }
        }
        else if(mod ~= "SEGMENTS"){
            SetHitBoxSegments(Int(modArray[1]));
        }
    }
    else if(command ~= "SPAWNDOORS"){
        SpawnDoors();
    }
    else if(command ~= "WELD"){
        if(modArray[1] ~= "")
            weldStr = 100.0;
        else
            weldStr = Float(modArray[1]);
        if(mod ~= "ALL")
            WeldDoors(weldStr, false);
        if(mod ~= "LOCKED")
            WeldDoors(weldStr, true);
    }
    else if(command ~= "BLOCKDOORS"){
        if(mod ~= "ON")
            IgnoreDoors(true);
        if(mod ~= "OFF")
            IgnoreDoors(false);
    }
    else if(command ~= "HELP"){
        class'TrainingPackScrN.Helper'.static.TellAbout(mod, KFController, Self);
    }
    Super.Mutate(MutateString, KFController);
}

// Event functions
// Called when new wave begins
function WaveStart(){
    if(bSkipTrader)
        BroadcastToAll("Trader time was %gomitted%w!");
    bSkipTrader = false;
    ForgiveWaveCheats();
    SafeGuardWaveRescueAmount = 0;
    // Make sure we don't go to the final wave
    // Update spawn rate
    if(currentSpawnRate >= 0)
        KFGT.KFLRules.WaveSpawnPeriod = currentSpawnRate;
    // This function will try to backup what's needed and then will reapply all the rules
    if(bNeedToBackupInitList)
        ApplyReplacementRules();
    // As a result of using commands this variable can get fucked up
    InvasionGameReplicationInfo(KFGT.GameReplicationInfo).WaveNumber = KFGT.WaveNum;
}
// Called when trader time begins
function TraderStart(){
    if(bSkipWave)
        BroadcastToAll("Wave was %rannihilated%w!");
    bSkipWave = false;
    if(bTraderAutoPause && !bTraderPaused)
        TradeTime(-1, none);
    if(bSetNextWave)
        KFGT.WaveNum = nextWave;
    else if(!bActiveFinalWave && !bLockCheats && KFGT.WaveNum == KFGT.FinalWave){
        KFGT.WaveNum = KFGT.FinalWave - 1;
        Cheated(CHEAT_WAVE);
    }
    bSetNextWave = false;
}

// Command functions
// Sets new maximal output line length
function SetMaxLineLength(int newMaxLength){
    if(newMaxLength > 10){
        maxLineLength = newMaxLength;
        BroadcastToAll("New output line length is set to%y"@String(newMaxLength));
    }
    else
        BroadcastToAll("Given length is too small");
}
// Enables/disables colour in the console output
function EnableColour(bool bEnable){
    if(bEnable != bEnableColour){
        bEnableColour = bEnable;
        if(bEnable)
            BroadcastToAll("Colour in console output is enabled");
        else
            BroadcastToAll("Colour in console output is disabled");
    }
}
// Function that stops current playing zed-time. Not a cheat.
function StopZedTime(){
    KFGT.bZEDTimeActive = false;
    KFGT.bSpeedingBackUp = false;
    KFGT.ZedTimeExtensionsUsed = 0;
    KFGT.LastZedTimeEvent = Level.TimeSeconds;
    KFGT.SetGameSpeed(normalSpeed);
}
// Enables/disables zed-time. Not a cheat.
function NoDrama(bool newNoDrama){
    if(bNoDrama != newNoDrama){
        if(newNoDrama){
            bNoDrama = true;
            StopZedTime();
            BroadcastToAll("Zed-time disabled");
        }
        else{
            bNoDrama = false;
            BroadcastToAll("Zed-time enabled");
        }
    }
}
// Changes amount of faked players. Not a cheat.
function SetFakedPlayers(int newFakedPlayers, bool bNewForce){
    newFakedPlayers = Max(0, newFakedPlayers);
    if(fakedPlayers != newFakedPlayers || (bForceVanillaFaked != bNewForce && ScrnGT != none)){
        fakedPlayers = newFakedPlayers;
        bForceVanillaFaked = bNewForce;
        if(bNewForce && ScrnGT != none)
            BroadcastToAll("Faked players set to%y"@String(FakedPlayers)@"(+1)%w via vanilla method");
        else
            BroadcastToAll("Faked players set to%y"@String(FakedPlayers)@"(+1)");
    }
}
// Alters flag that decides idicates or not we should scale zeds' health below current amount of players. Not a cheat.
function SetForceHealth(bool newForceHealth){
    if(bForceLowerHealthBound != newForceHealth){
        if(newForceHealth)
            BroadcastToAll("Zed health will now be set to be at least on the level corresponding to current amount of alive players");
        else
            BroadcastToAll("Zed health will now be set according to settings, regardless amount of alive players");
    }
    bForceLowerHealthBound = newForceHealth;
}
// Scrn-only. Changes minimal level. Drags up maximum level if needed. Not a cheat if < 7.
function SetMinLevel(int newMinimum, PlayerController PC){
    local String colorCode;
    if(ScrnMut == none){
        SendMessage("This command available only in scrn-mode!", PC);
        return;
    }
    if(newMinimum > 6 && ScrnMut.MinLevel < 7 && ScrnMut.MaxLevel < 7){
        if(bLockCheats)
            return;
        Cheated(CHEAT_LEVEL);
    }
    if(ScrnMut.MaxLevel < newMinimum)
        SetMaxLevel(NewMinimum, PC);
    ScrnMut.MinLevel = newMinimum;
    ScrnMut.default.MinLevel = newMinimum;
    ScrnMut.SrvMinLevel = newMinimum;
    if(newMinimum > 6)
        colorCode = "%r";
    else
        colorCode = "%g";
    BroadcastToAll("Minimal level set to"@colorCode$String(newMinimum));
}
// Scrn-only. Changes maximum level. Drags down minimal level if needed. Not a cheat if < 7.
function SetMaxLevel(int newMaximum, PlayerController PC){
    local String colorCode;
    if(ScrnMut == none){
        SendMessage("This command available only in scrn-mode!", PC);
        return;
    }
    if(newMaximum > 6 && ScrnMut.MinLevel < 7 && ScrnMut.MaxLevel < 7){
        if(bLockCheats)
            return;
        Cheated(CHEAT_LEVEL);
    }
    if(ScrnMut.MinLevel > newMaximum)
        SetMinLevel(newMaximum, PC);
    ScrnMut.MaxLevel = newMaximum;
    ScrnMut.default.MaxLevel = newMaximum;
    ScrnMut.SrvMaxLevel = newMaximum;
    if(newMaximum > 6)
        colorCode = "%r";
    else
        colorCode = "%g";
    BroadcastToAll("Maximum level set to"@colorCode$String(newMaximum));
}
// Function that allows to switch health scaling on and off. Not a cheat.
function EnableHealthChange(bool bEnable){
    if(bChangeHealth != bEnable){
        bChangeHealth = bEnable;
        if(bEnable)
            BroadcastToAll("Health scaling for zeds was %genabled");
        else
            BroadcastToAll("Health scaling for zeds was %rdisabled");
    }
}
// Changes health level of trash zeds (below 1000 base hp). Not a cheat.
function SetTrashHealth(int level, EZedPart part){
    level = Max(1, level);
    EnableHealthChange(true);
    if(part == ZEDPART_HEAD || part == ZEDPART_ALL)
        TrashHeadHealth = level;
    if(part == ZEDPART_BODY || part == ZEDPART_ALL)
        TrashBodyHealth = level;
    switch(part){
    case ZEDPART_HEAD:
        BroadcastToAll("Trash zeds' head health set to"@String(level));
        break;
    case ZEDPART_BODY:
        BroadcastToAll("Trash zeds' body health set to"@String(level));
        break;
    default:
        BroadcastToAll("Trash zeds' health set to"@String(level));
    }
}
// Changes health level of huge zeds (at least 1000 base hp). Not a cheat.
function SetHugeHealth(int level, EZedPart part){
    level = Max(1, level);
    EnableHealthChange(true);
    if(part == ZEDPART_HEAD || part == ZEDPART_ALL)
        HugeHeadHealth = level;
    if(part == ZEDPART_BODY || part == ZEDPART_ALL)
        HugeBodyHealth = level;
    switch(part){
    case ZEDPART_HEAD:
        BroadcastToAll("Huge zeds' head health set to"@String(level));
        break;
    case ZEDPART_BODY:
        BroadcastToAll("Huge zeds' body health set to"@String(level));
        break;
    default:
        BroadcastToAll("Huge zeds' health set to"@String(level));
    }
}
// Changes health level of boss zeds. Not a cheat.
function SetBossHealth(int level){
    level = Max(1, level);
    EnableHealthChange(true);
    BossHealth = level;
    BroadcastToAll("Boss' health set to"@String(level));
}
// Changes health level of all zeds. Not a cheat.
function SetZedHealth(int level, EZedPart part){
    level = Max(1, level);
    EnableHealthChange(true);
    if(part == ZEDPART_HEAD || part == ZEDPART_ALL){
        TrashHeadHealth = level;
        HugeHeadHealth = level;
    }
    if(part == ZEDPART_BODY || part == ZEDPART_ALL){
        TrashBodyHealth = level;
        HugeBodyHealth = level;
    }
    switch(part){
    case ZEDPART_HEAD:
        BroadcastToAll("Zeds' head health set to"@String(level));
        break;
    case ZEDPART_BODY:
        BroadcastToAll("Zeds' body health set to"@String(level));
        break;
    default:
        BroadcastToAll("Zeds' health set to"@String(level));
    }
}
// Changes value for alternative speed. Not a cheat.
function SetAltSpeed(float speed){
    speed = FMax(0.1, speed);
    altSpeed = speed;
    BroadcastToAll("Alternative speed is now set to%y" @ String(altSpeed));
}
// Changes game speed. Negative values as an argument means that we want to set speed to 'altSpeed' value. Not a cheat if >= 1.0
function SetSpeed(float speed){
    local bool bAltSpeed;
    local String colorCode;
    bAltSpeed = false;
    if(speed < 0){
        bAltSpeed = true;
        speed = altSpeed;
    }
    else
        speed = FMax(0.1, speed);
    if(speed < 1.0){
        if(bLockCheats){
            speed = 1.0;
            colorCode = "%g";
        }
        else{
            Cheated(CHEAT_SLOMO);
            colorCode = "%r";
        }
    }
    else
        colorCode = "%g";
    normalSpeed = speed;
    StopZedTime();
    KFGT.SetGameSpeed(speed);
    if(!bQuietSlomo){
        if(bAltSpeed)
            BroadcastToAll("Game speed changed to alternative speed:" @ colorCode $ String(speed));
        else
            BroadcastToAll("Game speed changed to" @ colorCode $ String(speed));
    }
}
// Disables messages about changing game's speed. Not a cheat.
function DisableSlomoMsg(bool disable){
    if(bQuietSlomo != disable){
        bQuietSlomo = disable;
        if(bQuietSlomo)
            BroadcastToAll("Messages about game' speed change %rwon't %wbe broadcasted anymore");
        else
            BroadcastToAll("Messages about game' speed %gwill %wbe broadcasted from now on");
    }
}
// Gives dosh to the player. Cheat if > 0.
function GiveDosh(int doshAmount, PlayerController PC){
    local String colorCode;
    if(doshAmount > 0){
        if(bLockCheats){
            colorCode = "%g";
            doshAmount = 0;
        }
        else{
            Cheated(CHEAT_DOSH);
            colorCode = "%r";
        }
    }
    else
        colorCode = "%g";
    if(PC.PlayerReplicationInfo.Score + doshAmount < 0)
        doshAmount = -PC.PlayerReplicationInfo.Score;
    PC.PlayerReplicationInfo.Score += doshAmount;
    SendMessage("You've "$colorCode$"gotten%w"@String(doshAmount)@"%gdo$h%w!", PC);
}
// Gives player a weapon with given in-game name. Not a cheat if weapon name is bollocks.
function GiveStuff(String name, PlayerController PC){
    local Inventory I;
    if(bLockCheats)
        return;
    I = PC.Spawn(class<Inventory>(DynamicLoadObject(name, Class'Class')));
    if (I != none){
        Cheated(CHEAT_WEAPON);
        KFGT.WeaponSpawned(I);
        KFWeapon(I).UpdateMagCapacity(PC.PlayerReplicationInfo);
        KFWeapon(I).FillToInitialAmmo();
        I.GiveTo(PC.Pawn);
        SendMessage("You've %rgotten%w"@KFWeapon(I).ItemName$"!", PC);
    }
}
// Gives player full ammo. A cheat (unless bSuppressCheat is set to 'true').
function GiveAmmo(PlayerController PC, optional bool bSuppressCheat){
    local Inventory Inv;
    local KFHumanPawn PlayerPawn;
    local KFAmmunition AmmoToUpdate;
    local KFPlayerReplicationInfo KFPRI;
    local class<KFVeterancyTypes> PlayerVeterancy;
    PlayerPawn = KFHumanPawn(PC.Pawn);
    if((bLockCheats && !bSuppressCheat)|| PlayerPawn == none)
        return;
    if(!bSuppressCheat)
        Cheated(CHEAT_AMMO);
    KFPRI = KFPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo);
    if(KFPRI != none)
        PlayerVeterancy = KFPRI.ClientVeteranSkill;
    for(Inv = PlayerPawn.Inventory; Inv != None; Inv = Inv.Inventory){
        AmmoToUpdate = KFAmmunition(Inv);
        if(AmmoToUpdate != None && AmmoToUpdate.AmmoAmount < AmmoToUpdate.MaxAmmo){
            if(PlayerVeterancy != none){
                AmmoToUpdate.MaxAmmo = AmmoToUpdate.default.MaxAmmo;
                AmmoToUpdate.MaxAmmo = float(AmmoToUpdate.MaxAmmo) * PlayerVeterancy.static.AddExtraAmmoFor(KFPRI, AmmoToUpdate.class);
            }
            AmmoToUpdate.AmmoAmount = AmmoToUpdate.MaxAmmo;
        }
    }
}
// Fills-up player's weapons' magazines. A cheat (unless bSuppressCheat is set to 'true').
function FillupMagazines(PlayerController PC, optional bool bSuppressCheat){
    local Inventory Inv;
    local KFHumanPawn PlayerPawn;
    local KFWeapon WeaponToFill;
    PlayerPawn = KFHumanPawn(PC.Pawn);
    if((bLockCheats && !bSuppressCheat) || PlayerPawn == none)
        return;
    if(!bSuppressCheat)
        Cheated(CHEAT_AUTOMAG);
    for(Inv = PlayerPawn.Inventory; Inv != none; Inv = Inv.Inventory){
        WeaponToFill = KFWeapon(Inv);
        if(WeaponToFill != none){
            WeaponToFill.MagAmmoRemaining = WeaponToFill.MagCapacity;
        }
    }
}
// Gives player required armor. A cheat if he can get it (also, zeroing armor doesn't count as cheat on vanilla).
// Doesn't count as separate cheat if it's caused by a safe guard.
function GiveArmor(string armorType, KFHumanPawn PlayerPawn, bool bSafeGuardGift){
    local ScrnHumanPawn ScrnPawn;
    local class<ScrnVestPickup> VestClass;
    ScrnPawn = ScrnHumanPawn(PlayerPawn);
    VestClass = GetArmorClass(armorType, PlayerPawn);
    if(bLockCheats && !bSafeGuardGift)
        return;
    if(ScrnPawn != none){
        if(ScrnPawn.CanUseVestClass(VestClass)){
            if(!bSafeGuardGift)
                Cheated(CHEAT_ARMOR);
            ScrnPawn.SetVestClass(VestClass);
            ScrnPawn.ShieldStrength = VestClass.default.ShieldCapacity;
        }
    }
    else{
        if(VestClass == Class'ScrnBalanceSrv.ScrnNoVestPickup')
            PlayerPawn.ShieldStrength = 0;
        else{
            if(!bSafeGuardGift)
                Cheated(CHEAT_ARMOR);
            PlayerPawn.ShieldStrength = 100;
        }
    }
}
// Skips trader time/wave.
// 'bQuickFlag' is only meaningful when player skips trader and indicates that we must skip it fast, without waiting last 5 seconds
// 'bAlsoTrader' is only meaningful when player skips wave and indicates that we must also skip the following trader
// Not a cheat if skips trader. 
function Skip(bool bQuickFlag, bool bAlsoTrader){
    local bool bIsWave;
    bQuickSkip = bQuickFlag;
    bIsWave = KFGT.bWaveInProgress || KFGT.bWaveBossInProgress;
    if(!bIsWave){
        bTraderPaused = false;
        if(bQuickFlag || KFGT.WaveCountDown > 6){
            bSkipTrader = true;
            bQuickSkip = bQuickFlag;
        }
    }
    else if(!bLockCheats){
        Cheated(CHEAT_SKIP);
        bSkipWave = true;
        if(bAlsoTrader)
            bSkipTrader = true;
    }
}
// Function that restarts current wave. A cheat.
function RestartWave(){
    ChooseWave(KFGT.WaveNum + 1);
    Skip(true, true);
}
    
// Activates/deactivates final wave. Not a cheat to use, but it can trigger cheats in future (if final wave is avoided).
function ActivateFinalWave(bool bActivate){
    if(bActiveFinalWave != bActivate){
        bActiveFinalWave = bActivate;
        if(bActivate)
            BroadcastToAll("Final wave was %gactivated%w!");
        else{
            if(KFGT.bTradingDoorsOpen && !bLockCheats && KFGT.WaveNum == KFGT.FinalWave){
                KFGT.WaveNum = KFGT.FinalWave - 1;
                Cheated(CHEAT_WAVE);
            }
            BroadcastToAll("Final wave was %gdeactivated%w!");
        }
    }
}
// Sets next wave. Not a cheat if doesn't really sets next wave to be the same.
function ChooseWave(int newWave){
    local int currentWave;
    local String colorCode;
    // Convert currentWave to a better human-perceived wave number
    currentWave = KFGT.WaveNum + 1;
    // Report cheats
    if(
        // Reason to call cheats №1: it's trader time and we change following ('currentWave') wave to something else ('newWave')
        (newWave != currentWave && KFGT.bTradingDoorsOpen)
        // Reason to call cheats №2: it's a wave, we haven't commanded to change wave yet ('!bSetNextWave') and we change following/next wave ('currentWave + 1') to something else ('newWave')
        || (newWave != currentWave + 1 && !bSetNextWave && !KFGT.bTradingDoorsOpen)
        // Reason to call cheats №3: it's a wave, we've commanded to change wave ('bSetNextWave') and we change following/next wave ('nextWave + 1' as numeration starts from 0 for that variable)
        // to something else ('newWave')
        || (newWave != nextWave + 1 && bSetNextWave && !KFGT.bTradingDoorsOpen)
    ){
        if(bLockCheats)
            return;
        Cheated(CHEAT_WAVE);
        colorCode = "%r";
    }
    else
        colorCode = "%g";
    BroadcastToAll("Next wave is "$colorCode$"changed%w to"@String(newWave));
    newWave = Clamp(newWave - 1, 0, KFGT.FinalWave);
    if(KFGT.bTradingDoorsOpen)
        KFGT.WaveNum = newWave;
    else{
        bSetNextWave = true;
        nextWave = newWave;
    }
}
// Kills all zeds. Not a cheat if there's nothing to kill.
function KillAll(){
    local KFMonster M;
    local bool calledCheat;
    if(bLockCheats)
        return;
    calledCheat = false;
    foreach DynamicActors(class'KFMonster', M){
        M.KilledBy(M);
        if(!calledCheat){
            Cheated(CHEAT_KILL);
            calledCheat = true;
        }
    }
    if(calledCheat)
        BroadcastToAll("Horde was %rwiped out");
}
// Kills all zeds of given type. Not a cheat if there's nothing to kill.
function KillAllType(ClassRef reference){
    local KFMonster M;
    local bool bCheckAll;
    local bool bCalledCheat;
    if(bLockCheats)
        return;
    bCalledCheat = false;
    bCheckAll = reference.aliasGroup == "" || !reference.bRefByAlias;
    foreach DynamicActors(class'KFMonster', M){
        if(!CheckClass(String(M), reference, bCheckAll))
            continue;
        M.KilledBy(M);
        if(!bCalledCheat){
            Cheated(CHEAT_KILL);
            bCalledCheat = true;
        }
    }
    if(bCalledCheat)
        BroadcastToAll("Horde was %rwiped out");
}
// Function that removes unwanted trash from level. Not a cheat.
function Clean(){
    local Pawn TrashPawn;
    local KFWeaponPickup TrashPickup;
    local Projectile TrashProjectile;
    local BossHPNeedle TrashNeedle;
    
    foreach DynamicActors(class'Pawn', TrashPawn)
        if(TrashPawn.Controller == None)
            TrashPawn.Destroy();
    
    foreach DynamicActors(class'KFWeaponPickup', TrashPickup)
        if(KFHumanPawn(TrashPickup.Owner) == None)
            TrashPickup.Destroy();
        
    foreach DynamicActors(class'Projectile', TrashProjectile)
        TrashProjectile.Destroy();
    
    foreach DynamicActors(class'BossHPNeedle', TrashNeedle)
        TrashNeedle.Destroy();
    
    BroadcastToAll("Level was cleaned!");
}
// Restores player's health. Not a cheat if player is already healthy.
// Doesn't count as separate cheat if it's caused by a safe guard.
function Refresh(KFHumanPawn PlayerPawn, bool bSafeGuardRestore){
    if(PlayerPawn.Health < 100 && !bSafeGuardRestore){
        if(bLockCheats)
            return;
        Cheated(CHEAT_REFRESH);
    }
    PlayerPawn.Health = 100;
}
// Toggles a pause. Not a cheat.
function Pause(PlayerController PC){
    if(Level.Pauser ==  none)
        Level.Pauser = PC.PlayerReplicationInfo;
    else
        Level.Pauser = none;
}
// Checks if game is paused. Not a cheat, but causes cheats to be called at the start of each wave.
function bool IsPaused(){
    return (Level.Pauser != none);
}
function TradeAutoPause(bool bActivate, PlayerController PC){
    if(bTraderAutoPause != bActivate){
        bTraderAutoPause = bActivate;
        if(bActivate)
            SendMessage("Trade time will automatically be paused at the end of every wave!", PC);
        else
            SendMessage("Trade time won't automatically be paused at the end of every wave anymore!", PC);
    }
}
// Set trade time (toggles pause if negative). Does nothing if last 5 seconds began. Not a cheat if player doesn't pause and reduces trade time.
function TradeTime(int newTradeTime, PlayerController PC){
    if(!KFGT.bTradingDoorsOpen || !KFGT.IsInState('MatchInProgress')){
        SendMessage("Trader isn't even open yet!", PC);
        return;
    }
    if(KFGT.WaveCountDown < 6){
        SendMessage("Too late! Trader is closing already, so get the fudge out.", PC);
        return;
    }
    if(newTradeTime > 0){
        newTradeTime = Max(10, newTradeTime) + 1;
        if(KFGT.WaveCountDown <= newTradeTime){
            if(bLockCheats)
                return;
            Cheated(CHEAT_SETTIME);
        }
        if(bTraderPaused)
            pausedTraderTime = newTradeTime;
        KFGT.WaveCountDown = newTradeTime;
    }
    else{
        if(!bTraderPaused){
            pausedTraderTime = KFGT.WaveCountDown + 1;
            if(bLockCheats)
                return;
            Cheated(CHEAT_SETTIME);
        }
        bTraderPaused = !bTraderPaused;
    }
}
// Sets zed spawn rate (default if negative). Not a cheat if lower than default.
function SetSpawnRate(float rate){
    local String colorCode;
    currentSpawnRate = rate;
    if(rate < 0){
        rate = defaultSpawnRate;
        currentSpawnRate = -1.0;
    }
    if(rate > defaultSpawnRate){
        if(bLockCheats)
            return;
        Cheated(CHEAT_SPAWNRATE);
        colorCode = "%r";
    }
    else
        colorCode = "%g";
    KFGT.KFLRules.WaveSpawnPeriod = rate;
    BroadcastToAll("Zed spawn rate "$colorCode$"changed%w to"@String(rate)$", default:"@String(defaultSpawnRate));
}
// Sets wave size. A cheat.
function SetWaveSize(int newSize){
    newSize = Max(KFGT.NumMonsters, newSize);
    if(bLockCheats)
        return;
    Cheated(CHEAT_WAVESIZE);
    KFGT.TotalMaxMonsters = newSize - KFGT.NumMonsters;
    KFGameReplicationInfo(KFGT.GameReplicationInfo).MaxMonsters = newSize;
    BroadcastToAll("Wave size was %rchanged%w.");
}
// Changes amounts of zeds in the wave. A cheat if new value is lower than initial one (depends on server settings, but always at least 32).
function SetMaxZombies(int newAmount){
    newAmount = Max(newAmount, 5);
    if(newAmount != KFGT.MaxZombiesOnce){
        if(newAmount < defMaxZombiesOnce){
            if(bLockCheats)
                return;
            Cheated(CHEAT_SCARCEZEDS);
            BroadcastToAll("New max zombies amount:%r"@String(newAmount));
        }
        else
            BroadcastToAll("New max zombies amount:%g"@String(newAmount));
        KFGT.MaxZombiesOnce = newAmount;
    }
}
// Remove bile/burning
function CleanupPlayer(KFHumanPawn PlayerPawn){
    PlayerPawn.bBurnified = false;
    PlayerPawn.BileCount = 0;
    PlayerPawn.BurnDown = 0;
    PlayerPawn.RemoveFlamingEffects();
    PlayerPawn.StopBurnFX();
}
// Restores health, armor and kills everything nearby. Not a cheat, because can only be called when another cheat is active (SafeGuard).
function Rescue(KFHumanPawn PlayerPawn, Pawn Villain){
    local bool notBoss;
    local KFMonster M;
    local int prevZedAmount;
    local PlayerController playerCtrl;
    if(!bSafeGuard)
        return;
    SafeGuardInvincibilityCountDown = SafeGuardInvincibilityTime;
    SafeGuardRescueAmount ++;
    SafeGuardWaveRescueAmount ++;
    prevZedAmount = KFGT.TotalMaxMonsters + KFGT.NumMonsters;

    // Restore health and armor
    Refresh(PlayerPawn, true);
    GiveArmor(SafeGuardArmor, PlayerPawn, true);
    // Remove bile/burning
    CleanupPlayer(PlayerPawn);
    
    // Restore ammo
    playerCtrl = PlayerController(PlayerPawn.Controller);
    if(playerCtrl != none){
        if(bSafeGuardFillAmmo)
            GiveAmmo(playerCtrl);
        if(bSafeGuardFillMags)
            FillupMagazines(playerCtrl);
    }

    // Now make an appropriate reaction
    if(SafeGuardReaction == REACTION_KILL){
        foreach PlayerPawn.RadiusActors(class'KFMonster', M, SafeGuardKillRadius){
            notBoss = (ZombieBoss(M) == none);
            if(notBoss)
                M.KilledBy(M);
        }
        if(bSafeGuardRestoreKilled)
            SetWaveSize(prevZedAmount);
    }
    else if(SafeGuardReaction == REACTION_TRADE){
        if(!KFGT.bTradingDoorsOpen)
            Skip(true, false);
    }
    else if(SafeGuardReaction == REACTION_RESTART)
        RestartWave();

    if(PlayerPawn == Villain)
        BroadcastToAll("%bSafeGuard>%w Saving useless tosser from him/herself... %gCOMPLETE");
    else if(KFMonster(Villain) != none)
        BroadcastToAll("%bSafeGuard>%w Saving useless tosser from%r"@KFMonster(Villain).MenuName$"%w... %gCOMPLETE");
    else
        BroadcastToAll("%bSafeGuard>%w Saving useless tosser from%r"@String(Villain)$"%w... %gCOMPLETE");
    BroadcastToAll("%bSafeGuard>%w SafeGuard suggests %baiming%w next time");
}
// Sets new syringe healing value. A cheat if set higher than what's it supposed to be.
/*function SetSyringeHealBoost(int newAmount){
    local bool amAlone;
    local Syringe healStick;
    newAmount = Max(0, newAmount);
    amAlone = PlayersAmount() + fakedPlayers <= 1;
    if((amAlone && newAmount > 50) || (!amAlone && newAmount > 20)){
        if(bLockCheats)
            return;
        Cheated(CHEAT_SYRINGE);
    }
    foreach DynamicActors(class'Syringe', healStick){
        BroadcastToAll("BIM:"@String(healStick.HealBoostAmount));
        healStick.HealBoostAmount = newAmount;
        BroadcastToAll("BOOM:"@String(newAmount));
    }
}*/
// Enables/disables god mode (disables demi-god mode if activated). A cheat to enable.
function GodMode(bool bActivate){
    if(bGodMode == bActivate || bLockCheats)
        return;
    if(bActivate){
        Cheated(CHEAT_GOD);
        bGodMode = true;
        bDemiGodMode = false;
        BroadcastToAll("God mode %ron%w");
    }
    else{
        bGodMode = false;
        BroadcastToAll("God more %goff%w");
    }
}
// Enables/disables demi-god mode (disables god mode if activated). A cheat to enable.
function DemiGodMode(bool bActivate){
    if(bDemiGodMode == bActivate || bLockCheats)
        return;
    if(bActivate){
        Cheated(CHEAT_DEMIGOD);
        bDemiGodMode = true;
        bGodMode = false;
        BroadcastToAll("Demi-god mode %ron%w");
    }
    else{
        bDemiGodMode = false;
        BroadcastToAll("Demi-god more %goff%w");
    }
}
// Enables/disables god-ammo mode (constantly replenishing ammunition). A cheat to enable.
function GodAmmo(bool bActivate){
    if(bGodAmmo == bActivate || bLockCheats)
        return;
    if(bActivate){
        if(bLockCheats)
            return;
        Cheated(CHEAT_GODAMMO);
        bGodAmmo = true;
        BroadcastToAll("God ammo %ron%w");
    }
    else{
        bGodAmmo = false;
        BroadcastToAll("God more %goff%w");
    }
}
// Enables/disables god-ammo mode (constantly replenishing ammunition). A cheat to enable.
function GodAmmoMags(bool bActivate){
    if(bGodAmmoFillMags == bActivate || bLockCheats)
        return;
    if(bActivate){
        if(bLockCheats)
            return;
        Cheated(CHEAT_GODAMMO);
        bGodAmmoFillMags = true;
        BroadcastToAll("When god ammo is %ractive%w weapon magazines %gwill%w be automatically refilled.");
    }
    else{
        bGodAmmoFillMags = false;
        BroadcastToAll("When god ammo is %ractive%w weapon magazines %pwon't%w be automatically refilled.");
    }
}
// Enables/disables safeguard. A cheat to enable.
function SafeGuard(bool bActivate){
    if(bSafeGuard == bActivate)
        return;
    if(bActivate){
        if(bLockCheats)
            return;
        Cheated(CHEAT_SAFE);
        bSafeGuard = true;
        BroadcastToAll("%bSafeGuard>%w Booting up... %gCOMPLETE");
    }
    else{
        bSafeGuard = false;
        BroadcastToAll("%bSafeGuard>%w Shutting down... %gCOMPLETE");
    }
}
// Changes range around you that safeguard will free of zeds (for REACTION_KILL). Not a cheat.
function SetSafeGuardKillRadius(float newRadius){
    SafeGuardKillRadius = Max(0.0, newRadius);
    BroadcastToAll("%bSafeGuard>%w Kill radius changed to"@String(SafeGuardKillRadius));
}
// Sets the type of armor SafeGuard should replenish. Not a cheat.
function SetSafeGuardArmorType(string armorType){
    SafeGuardArmor = GetProperArmorClass(armorType);
    BroadcastToAll("%bSafeGuard>%w New safe guard armor type is set to"@SafeGuardArmor);
}
// Sets whether or not SafeGuard should restore killed zeds (for REACTION_KILL). Not a cheat.
function ShouldSafeGuardRestoreZeds(bool yes){
    if(bSafeGuardRestoreKilled != yes){
        bSafeGuardRestoreKilled = yes;
        if(bSafeGuardRestoreKilled)
            BroadcastToAll("%bSafeGuard>%w SafeGuard will now restore zeds it killed");
        else
            BroadcastToAll("%bSafeGuard>%w SafeGuard won't restore zeds it killed");
    }
}
// Set whether or not SafeGuard should restore all of the player's ammo. Not a cheat by itself, but can lead to cheats being called.
function ShouldSafeGuardRestoreAmmo(bool yes){
    if(bSafeGuardFillAmmo != yes){
        bSafeGuardFillAmmo = yes;
        if(bSafeGuardFillAmmo)
            BroadcastToAll("%bSafeGuard>%w SafeGuard will restore ammo upon rescue");
        else
            BroadcastToAll("%bSafeGuard>%w SafeGuard won't restore ammo upon rescue");
    }
}
function SetSafeGuardInvincibleTime(float newTime){
    if(newTime != SafeGuardInvincibilityTime && newTime >= 0.0){
        SafeGuardInvincibilityTime = newTime;
        SafeGuardInvincibilityCountDown = FMin(SafeGuardInvincibilityCountDown, newTime);
        BroadcastToAll("%bSafeGuard>%w SafeGuard will now grant you%y"@newTime@"seconds of invincibility upon rescue");
    }
}
// Set whether or not SafeGuard should fill-up player's magazines. Not a cheat by itself, but can lead to cheats being called.
function ShouldSafeGuardFillMags(bool yes){
    if(bSafeGuardFillMags != yes){
        bSafeGuardFillMags = yes;
        if(bSafeGuardFillMags)
            BroadcastToAll("%bSafeGuard>%w SafeGuard will automatically fill-up magazines upon rescue");
        else
            BroadcastToAll("%bSafeGuard>%w SafeGuard won't automatically fill-up magazines upon rescue ");
    }
}
// Changes how SafeGuard will act upon rescue. Not a cheat by itself, but can lead to cheats being called.
function SetSafeGuardReaction(ESGReaction newReaction){
    if(SafeGuardReaction != newReaction){
        SafeGuardReaction = newReaction;
        if(SafeGuardReaction == REACTION_NONE)
            BroadcastToAll("%bSafeGuard>%w Upon rescue SafeGuard will only restore your health and repair your armor");
        else if(SafeGuardReaction == REACTION_KILL)
            BroadcastToAll("%bSafeGuard>%w Upon rescue SafeGuard will kill nearby zeds");
        else if(SafeGuardReaction == REACTION_TRADE)
            BroadcastToAll("%bSafeGuard>%w Upon rescue SafeGuard will force the wave to end");
        else if(SafeGuardReaction == REACTION_RESTART)
            BroadcastToAll("%bSafeGuard>%w Upon rescue SafeGuard will restart current wave");
    }
}
// Shows zeds' health bars. Always a cheat.
function ShowBars(bool bNewShowBars){
    if(bShowBars != bNewShowBars){
        if(bNewShowBars){
            if(bLockCheats)
                return;
            Cheated(CHEAT_BARS);
            BroadcastToAll("Healthbars are %rvisible");
        }
        else
            BroadcastToAll("Healthbars are %ghidden");
        bShowBars = bNewShowBars;
    }
}
// Shows server-side zeds' head hit-boxes. Always a cheat.
function ShowServerHeadHitboxes(bool bNewShowHitboxes){
    if(bShowHitboxesServer != bNewShowHitboxes){
        if(bNewShowHitboxes){
            if(bLockCheats)
                return;
            Cheated(CHEAT_HEADBOXES);
            BroadcastToAll("Head hitboxes (server side) are %rvisible");
        }
        else
            BroadcastToAll("Head hitboxes (server side) are %ghidden");
        bShowHitboxesServer = bNewShowHitboxes;
    }
}
// Shows client-side zeds' head hit-boxes. Always a cheat.
function ShowClientHeadHitboxes(bool bNewShowHitboxes){
    if(bShowHitboxesClient != bNewShowHitboxes){
        if(bNewShowHitboxes){
            if(bLockCheats)
                return;
            Cheated(CHEAT_HEADBOXES);
            BroadcastToAll("Head hitboxes (client side) are %rvisible");
        }
        else
            BroadcastToAll("Head hitboxes (client side) are %ghidden");
        bShowHitboxesClient = bNewShowHitboxes;
    }
}
// Changes displayed size of zeds' head hit-boxes. Not a cheat.
function SetHitBoxSize(EHitboxSize newSize){
    if(newSize != HBoxSize){
        HBoxSize = newSize;
        if(HBoxSize == HBSIZE_HARD)
            BroadcastToAll("No online scaling will be applied to zeds' hit-boxes.");
        else
            BroadcastToAll("Normal online scaling will be applied to zeds' hit-boxes.");
    }
}
// Changes amount of segments in head hit-box (can be between 5 and 30). Not a cheat.
function SetHitBoxSegments(int NewHeadSegmentAmount){
    NewHeadSegmentAmount = Max(NewHeadSegmentAmount, 5);
    NewHeadSegmentAmount = Min(NewHeadSegmentAmount, 30);
    if(HeadSegmentAmount != NewHeadSegmentAmount){
        HeadSegmentAmount = NewHeadSegmentAmount;
        BroadcastToAll("Amount of segments in head hit-boxes has been changed to%y"@String(HeadSegmentAmount));
    }
}
// Spawns destroyed doors. Not a cheat if no door was respawned.
function SpawnDoors(){
    local int i, j;
    local KFUseTrigger key;
    local bool bCheatReported;
    if(bLockCheats)
        return;
    bCheatReported = false;
    if(!bDoorsFound)
        return;
    ClearGlitchedDoors();
    for (i = 0;i < DoorKeys.Length;i ++){
        key = DoorKeys[i];
        for(j = 0;j < key.DoorOwners.Length;j ++)
            if(key.DoorOwners[j].bDoorIsDead){
                if(!bCheatReported){
                    bCheatReported = true;
                    Cheated(CHEAT_SPAWNDOORS);
                }
                key.DoorOwners[j].RespawnDoor();
            }
    }
}
// Welds all doors to a certain percentage. A cheat.
function WeldDoors(float fStrenght, bool bSkipUnsealed){
    local int i, j;
    local KFUseTrigger key;
    local float newWeldValue;
    if(!bDoorsFound || bLockCheats)
        return;
    if(DoorKeys.Length > 0)
        Cheated(CHEAT_WELDDOORS);
    for (i = 0;i < DoorKeys.Length;i ++){
        key = DoorKeys[i];
        if(!bSkipUnsealed || DoorKeys[i].WeldStrength > 0)
            DoorKeys[i].WeldStrength = DoorKeys[i].MaxWeldStrength * fStrenght / 100.0;
        for(j = 0;j < key.DoorOwners.Length;j ++)
            if(!bSkipUnsealed || key.DoorOwners[j].bSealed){
                newWeldValue = key.DoorOwners[j].MaxWeld * fStrenght / 100.0;
                key.DoorOwners[j].SetWeldStrength(newWeldValue);
            }
    }
}
// Makes zeds ignore/attack doors. Not a cheat when removes ignore.
function IgnoreDoors(bool bDoIgnore){
    local int i, j;
    local KFUseTrigger key;
    if(!bDoorsFound || bLockCheats)
        return;
    if(bDoIgnore)
        Cheated(CHEAT_GODDOORS);
    for(i = 0;i < DoorKeys.Length;i ++){
        key = DoorKeys[i];
        for(j = 0;j < key.DoorOwners.Length;j ++){
            if(!bDoIgnore || (bDoIgnore && key.DoorOwners[j].bSealed)){
                key.DoorOwners[j].bZombiesIgnore = bDoIgnore;
                key.DoorOwners[j].bBlockDamagingOfWeld = bDoIgnore;
            }
            if(bDoIgnore && key.DoorOwners[j].bSealed)
                key.DoorOwners[j].DoorPathNode.bBlocked = true;
            else
                key.DoorOwners[j].DoorPathNode.bBlocked = false;
        }
    }
}
// Toggles lock on cheat use. If you enable the lock, then function also makes sure lower health bound for zeds is enabled. Not a cheat.
function LockCheats(bool bNewLockCheats){
    if(bLockCheats == bNewLockCheats)
        return;
    bLockCheats = bNewLockCheats;
    if(bNewLockCheats)
        BroadcastToAll("Cheats are locked");
    else
        BroadcastToAll("Cheats are unlocked");
}
// Adds a replacements rule. Always a cheat (was moved into a separate function to track a cheat).
function AddReplacementRule(ReplacementRule newReplRule){
    if(bLockCheats)
        return;
    Cheated(CHEAT_ZEDTYPE);
    replacementRules[replacementRules.Length] = newReplRule;
}

// Utility functions
// Creates empty reference
function ClassRef NullClassRef(){
    local ClassRef reference;
    reference.alias = "";
    reference.aliasGroup = "";
    reference.className = "";
    return reference;
}
// Creates reference to explicitly given class
function ClassRef RefToClassName(String className){
    local ClassRef reference;
    reference.bRefByAlias = false;
    reference.alias = "";
    reference.aliasGroup = "";
    reference.className = className;
    return reference;
}
// Creates reference to a class by alias
function ClassRef RefToAlias(String alias, String aliasGroup){
    local ClassRef reference;
    reference.bRefByAlias = true;
    reference.alias = alias;
    reference.aliasGroup = aliasGroup;
    reference.className = "";
    return reference;
}
// Compares class names and drops package comparison if necessary (package isn't listed in either input strings) of if we were asked to
function bool CompareClassNames(String name1, String name2, bool forceStripPackages){
    local int dot1, dot2;
    dot1 = InStr(name1, ".");
    dot2 = InStr(name2, ".");
    if(forceStripPackages || dot1 >= 0 || dot2 >= 0){
        if(dot1 >= 0 && dot1 < Len(name1))
            name1 = Mid(name1, dot1 + 1);
        if(dot2 >= 0 && dot2 < Len(name2))
            name2 = Mid(name2, dot2 + 1);
    }
    return (name1 ~= name2);
}
// Checks if we point at correct class
// bMultiCheck=true means that if ref is given by alias and group wasn't specified, - we check if object's class corresponds to any class connected with alias
// if obj's class is said to be contained in current map package -- compare only class names, without package prefixes
function bool CheckClass(String objClassName, ClassRef ref, bool bMultiCheck){
    local int i;
    local int dotIndex;
    local bool forceStripPackages;
    local String refClassName;
    local array<IDRecord> records;
    // Find out if object's package is just a map and we should strip it
    dotIndex = InStr(objClassName, ".");
    forceStripPackages = false;
    if(dotIndex > 0){
        if(Left(objClassName, dotIndex) ~= KFGT.GetCurrentMapName(Level))
            forceStripPackages = true;
    }
    // Do the check
    if(ref.bRefByAlias){
        if(bMultiCheck){
            records = tryGetAliasAll(ref.alias, ALIAS_ALL);
            for(i = 0;i < records.Length;i ++)
                if(CompareClassNames(objClassName, records[i].ID, forceStripPackages))
                    return true;
            return false;
        }
        else
            refClassName = tryGetAlias(ref.alias, ref.aliasGroup, ALIAS_ALL);
    }
    else
        refClassName = ref.className;
    return CompareClassNames(objClassName, refClassName, forceStripPackages);
}
// Count players
function int PlayersAmount(){
    local Controller cIt;
    local int playersCount;

    for(cIt = Level.ControllerList;cIt != None;cIt = cIt.NextController)
        if(cIt.bIsPlayer)
            playersCount ++;

    return playersCount;
}
// Count currently alive players
function int AlivePlayersAmount(){
    local Controller cIt;
    local int alivePlayersCount;

    for(cIt = Level.ControllerList;cIt != none;cIt = cIt.NextController)
        if(cIt.bIsPlayer && cIt.Pawn != none && cIt.Pawn.Health > 0)
            alivePlayersCount ++;

    return alivePlayersCount;
}
// Function for string splitting, because why would we have it as a standard function? It would be silly, right?
function array<string> SplitString(string inputString, string div){
    local array<string> parts;
    local bool bEOL;
    local string tempChar;
    local int preCount, curCount, partCount, strLength;
    strLength = Len(inputString);
    if(strLength == 0)
        return parts;
    bEOL = false;
    preCount = 0;
    curCount = 0;
    partCount = 0;

    while(!bEOL)
    {
        tempChar = Mid(inputString, curCount, 1);
        if(tempChar != div)
            curCount ++;
        else
        {
            if(curCount == preCount)
            {
                curCount ++;
                preCount ++;
            }
            else
            {
                parts[partCount] = Mid(inputString, preCount, curCount - preCount);
                partCount ++;
                preCount = curCount + 1;
                curCount = preCount;
            }
        }
        if(curCount == strLength)
        {
            if(preCount != strLength)
                parts[partCount] = Mid(inputString, preCount, curCount);
            bEOL = true;
        }
    }
    return parts;
}
// Function for finding scaling parameter for specimen HP according to settings. Catches cheats, so don't use it just for information.
function float ScaleZedHealth(KFMonster monster, float hpScale, float baseHP, int playerCount, bool isHead, bool boss){
    local int i;
    local int healthLevel;
    local bool checkPassed;
    local bool healthRulesFound;
    // If it's the boss -- we don't need to do anything else
    if(boss){
        healthLevel = BossHealth;
        if(playerCount > healthLevel){
            if(bForceLowerHealthBound || bLockCheats)
                return 1.0 + (playerCount - 1) * hpScale;
            else{
                Cheated(CHEAT_ZEDHEALTH);
                return 1.0 + (BossHealth - 1) * hpScale;
            }
        }
        return 1.0 + (BossHealth - 1) * hpScale;
    }
    // Otherwise try to find health rules
    checkPassed = false;
    healthRulesFound = false;
    for(i = healthRules.Length - 1;i >= 0;i --){
        // If player has specified alias group - do a specific checkPassed
        if(healthRules[i].zed.bRefByAlias && healthRules[i].zed.aliasGroup != "")
            checkPassed = CheckClass(String(monster), healthRules[i].zed, false);
        // Otherwise - check for whatever
        else
            checkPassed = CheckClass(String(monster), healthRules[i].zed, true);
        if(checkPassed){
            if(isHead)
                healthLevel = healthRules[i].headHealth;
            else
                healthLevel = healthRules[i].bodyHealth;
            if(healthLevel > 0){
                healthRulesFound = true;
                break;
            }
        }
    }
    // Just apply general settings if not found
    if(!healthRulesFound){
        if(monster.default.health < 1000){
            if(isHead)
                healthLevel = TrashHeadHealth;
            else
                healthLevel = TrashBodyHealth;
        }
        else{
            if(isHead)
                healthLevel = HugeHeadHealth;
            else
                healthLevel = HugeBodyHealth;
        }
    }
    // Check if health level is too low
    if(playerCount > healthLevel){
        if(bForceLowerHealthBound || bLockCheats)
            healthLevel = playerCount;
        else
            Cheated(CHEAT_ZEDHEALTH);
    }
    // Return correct scale
    return 1.0 + (healthLevel - 1) * hpScale;
}
// Function for remembering about cheats
function Cheated(ECheatType type){
    if(!bUsedCheats)
        BroadcastToAll("Some plonker just cheated! Now the whole game is tainted!");
    bUsedCheats = true;
    bUsedCheatsThisWave = true;
    globalCheats[type] ++;
    waveCheats[type] ++;
}
// Returns list of used cheats
function String CheatList(bool wave){
    local int i;
    local int cheatsAmount;
    local String list;
    list = "(";
    for(i = 0;i < cheatsDescription.Length;i ++){
        if(wave)
            cheatsAmount = waveCheats[i];
        else
            cheatsAmount = globalCheats[i];
        if(cheatsAmount > 0){
            if(list != "(")
                list = list$", ";
            list = list$(cheatsDescription[i])@"["$String(cheatsAmount)$"]";
        }
    }
    if(list == "(")
        return "";
    return list$")";
}
// Function for forgetting about cheats used in last wave
function ForgiveWaveCheats(){
    local int i;
    bUsedCheatsThisWave = false;
    for(i = 0; i < waveCheats.Length;i ++)
        waveCheats[i] = 0;
}
// Removes all partly destroyed doors
function ClearGlitchedDoors(){
    local int i, j;
    local bool bBlowDoors;
    local KFUseTrigger key;
    
    for (i=0; i<DoorKeys.length; i ++){
        key = DoorKeys[i];
        bBlowDoors = false;
        for (j=1; j<key.DoorOwners.Length; ++j){
            // blow all doors if one is blown
            if(key.DoorOwners[j].bDoorIsDead != key.DoorOwners[0].bDoorIsDead){
                bBlowDoors = true;
                break;
            }
        }
        if(bBlowDoors){
            for(j=0; j<key.DoorOwners.Length; ++j){
                if (!key.DoorOwners[j].bDoorIsDead)
                    key.DoorOwners[j].GoBang(none, vect(0,0,0), vect(0,0,0), none);
            }        
        }
    }
}
// Converts give string armor type to one of the base types.
function string GetProperArmorClass(string armorType){
    if(armorType ~= "NONE" || armorType ~= "LIGHT" || armorType ~= "COWBOY" ||
        armorType ~= "HEAVY" || armorType ~= "HORZINE" || armorType ~= "CURRENT" || armorType ~= "NORMAL")
        return armorType;
    else
        return "NORMAL";
}
// Returns armor class based on a given string
function class<ScrnVestPickup> GetArmorClass(string armorType, KFHumanPawn PlayerPawn){
    local ScrnHumanPawn ScrnPawn;
    ScrnPawn = ScrnHumanPawn(PlayerPawn);
    if(armorType ~= "NONE")
        return Class'ScrnBalanceSrv.ScrnNoVestPickup';
    else if(armorType ~= "LIGHT" || armorType ~= "COWBOY")
        return Class'ScrnBalanceSrv.ScrnLightVestPickup';
    else if(armorType ~= "HEAVY" || armorType ~= "HORZINE")
        return Class'ScrnBalanceSrv.ScrnHorzineVestPickup';
    else if(armorType ~= "CURRENT" && ScrnPawn != none)
        return ScrnPawn.GetVestClass();
    else
        return Class'ScrnBalanceSrv.ScrnCombatVestPickup';
}
// Fills up aliasesDatabase array with aliases given from the config
function loadAliases(){
    if(ScrnGT != none)
        groupOrder = SplitString(groupPriority, ":");
    else
        groupOrder = SplitString(vanillaGroupPriority, ":");
    loadAliasesFromArray(zedAliases, ALIAS_ZED);
    loadAliasesFromArray(weaponAliases, ALIAS_WEAPON);
}
// Checks if given group name is already known to us and adds it to the end otherwise
function updateGroupOrder(String newGroup){
    local int i;
    for(i = 0;i < groupOrder.Length;i ++)
        if(groupOrder[i] ~= newGroup)
            return;
    groupOrder[groupOrder.Length] = newGroup;
}
// Fills up aliasesDatabase array with aliases given in provided array and sets them to have a given type
function loadAliasesFromArray(array<String> aliasArray, EAliasType aliasType){
    local int i, j;
    local int leftBracket, rightBracket;
    local AliasRecord rc;
    local IDRecord idRc;
    local array<string> recordParts;
    rc.type = aliasType;
    for(i = 0;i < aliasArray.Length;i ++){
        rc.IDs.Length = 0;
        rc.Aliases.Length = 0;
        recordParts = SplitString(aliasArray[i], ":");
        for(j = 0;j < recordParts.Length;j ++){
            leftBracket = InStr(recordParts[j], "[");
            rightBracket = InStr(recordParts[j], "]");
            // Both brackets present and alias is non-empty? If not that's an alias.
            if(rightBracket - 1 < leftBracket || leftBracket < 0 || rightBracket < 0)
                rc.Aliases[rc.Aliases.Length] = recordParts[j];
            else{
            // If yes, then that's an actual ID
                idRc.GroupName = Mid(recordParts[j], leftBracket + 1, rightBracket - leftBracket - 1);
                idRc.ID = Mid(recordParts[j], rightBracket + 1);
                rc.IDs[rc.IDs.Length] = idRc;
                updateGroupOrder(idRc.GroupName);
            }
        }
        AliasDatabase[AliasDatabase.Length] = rc;
    }
}
// Tries to get all the available ID's for a given alias.
// Returns given empty array if fails.
function array<IDRecord> tryGetAliasAll(string objectName, EAliasType aliasType){
    local int i, j;
    local bool bAliasFound;
    local int aliasNum, recordNum;
    local array<IDRecord> sortedAliasIDs;
    bAliasFound = false;
    for(i = 0;(i < AliasDatabase.Length) && !bAliasFound;i ++)
        for(j = 0;(j < AliasDatabase[i].Aliases.Length) && !bAliasFound;j ++)
            if(objectName ~= AliasDatabase[i].Aliases[j] && (AliasDatabase[i].type == aliasType || aliasType == ALIAS_ALL)){
                bAliasFound = true;
                aliasNum = i;
                break;
            }

    // No records at all? Exit right here
    if(AliasDatabase[aliasNum].IDs.Length == 0)
        return sortedAliasIDs;
    // Now that we found to what record this alias corresponds to, - find appropriate ID
    if(bAliasFound){
        j = 0;
        for(i = 0;i < groupOrder.Length;i ++){
            recordNum = lookupIDRecord(AliasDatabase[aliasNum].IDs, groupOrder[i]);
            if(recordNum >= 0)
                sortedAliasIDs[j ++] = AliasDatabase[aliasNum].IDs[recordNum];
        }
    }
    return sortedAliasIDs;
}
// Tries to convert aliases into object ID's.
// Returns given 'objectName' string if fails.
function string tryGetAlias(string objectName, string groupName, EAliasType aliasType){
    local int i;
    local array<IDRecord> sortedAliasIDs;
    sortedAliasIDs = tryGetAliasAll(objectName, aliasType);
    // No IDs found? Return object's name.
    if(sortedAliasIDs.Length == 0)
        return objectName;
    // Found desired group name? Return it's ID.
    for(i = 0;i < sortedAliasIDs.Length;i ++)
        if(sortedAliasIDs[i].GroupName ~= groupName)
            return sortedAliasIDs[i].ID;
    // Haven't found? Return ID with highest priority.
    return sortedAliasIDs[0].ID;
}
// Searches for id record with given group name; return -1 if can't find one
function int lookupIDRecord(array<IDRecord> records, String groupName){
    local int i;
    for(i = 0;i < records.Length;i ++)
        if(records[i].GroupName ~= groupName)
            return i;
    return -1;
}
// Stolen from ScrNVotingHandlerMut
// Converts formatted string in the form that UnrealEngine understands
static function string ParseFormattedLine(string input)
{
    ReplaceText(input, "%r", chr(27)$chr(200)$chr(1)$chr(1));
    ReplaceText(input, "%g", chr(27)$chr(1)$chr(200)$chr(1));
    ReplaceText(input, "%b", chr(27)$chr(1)$chr(100)$chr(200));
    ReplaceText(input, "%w", chr(27)$chr(200)$chr(200)$chr(200));
    ReplaceText(input, "%y", chr(27)$chr(200)$chr(200)$chr(1));
    ReplaceText(input, "%p", chr(27)$chr(200)$chr(1)$chr(200));
    return input;
}
// Strips string of all the format modifiers
static function string StripFormattedString(string input){
    ReplaceText(input, "%r", "");
    ReplaceText(input, "%g", "");
    ReplaceText(input, "%b", "");
    ReplaceText(input, "%w", "");
    ReplaceText(input, "%y", "");
    ReplaceText(input, "%p", "");
    return input;
}
// Returns length of the string without counting formatting characters
static function int FormattedLen(string input){
    return Len(StripFormattedString(input));
}
// Returns last formatting string modifier
static function string LastModifier(string input){
    local int i;
    local String mod;
    local int inputLength;
    local array<String> letterArray;
    mod = "";
    inputLength = Len(input);
    for(i = 0; i < inputLength;i++)
        letterArray[i] = Mid(input,i,1);
    for(i = 0;i < inputLength;i ++){
        if(letterArray[i] == "%" && i+1 < inputLength)
            if( letterArray[i+1] == "r" || letterArray[i+1] == "g" || letterArray[i+1] == "b" || letterArray[i+1] == "w"
                || letterArray[i+1] == "y" || letterArray[i+1] == "p"){
                mod = "%"$letterArray[i+1];
            }
    }
    return mod;
}
// Finds at what index is the best to move to next line
// Return -1 if there's no need to cut
function int getNewLineCutIndex(String input){
    local int i;
    local int parsedLength;
    local int inputLength;
    local int formatSeqCount;
    local array<String> letterArray;
    // Indices for nearest white-space characters for 'maxLineLength'
    // 'spaceBeforeMaxParsed' is the 'FormattedLen' of string up to 'spaceBeforeMax' character or 'maxLineLength' if there's no white-space characters
    local int spaceBeforeMax, secondLineCandStart, spaceAfterMin;
    if(FormattedLen(input) <= maxLineLength)
        return -1;
    spaceBeforeMax = -1;
    spaceAfterMin = -1;
    inputLength = Len(input);
    formatSeqCount = 0;
    secondLineCandStart = maxLineLength;
    for(i = 0; i < inputLength;i++)
        letterArray[i] = Mid(input,i,1);
    // Find last white-space character before 'maxLineLength' and the first one after; ignore special sequences when computing parsed string length
    // Second condition means that we only care about 'spaceAfterMin' if it can be used to divide next line (when we divide current at 'spaceBeforeMax')
    for(i = 0;i < inputLength && (parsedLength < maxLineLength || parsedLength - secondLineCandStart < maxLineLength);i ++){
        if(letterArray[i] == "%" && i+1 < inputLength)
            if( letterArray[i+1] == "r" || letterArray[i+1] == "g" || letterArray[i+1] == "b" || letterArray[i+1] == "w"
                || letterArray[i+1] == "y" || letterArray[i+1] == "p"){
                i ++;
                if(parsedLength < maxLineLength)
                    formatSeqCount ++;
                parsedLength += 4;
                continue;
            }
        if(parsedLength > 0 && letterArray[i] == " "){
            if(parsedLength < maxLineLength){
                spaceBeforeMax = i;
                secondLineCandStart = parsedLength;
            }
            else{
                spaceAfterMin = i;
                break;
            }
        }
        parsedLength ++;
    }
    // Make a decision based on information we've just gotten
    if( spaceBeforeMax == -1 || (spaceAfterMin == -1 && parsedLength == secondLineCandStart + maxLineLength) )
        return maxLineLength + 2 * formatSeqCount;
    return spaceBeforeMax;
}
// Sends message to a given player, breaking it into several lines, if necessary
function SendMessage(string message, PlayerController KFController){
    local string line;
    local int cutIndex;
    local bool bFirstLine;
    if(KFController == none)
        return;
    bFirstLine = true;
    if(!bEnableColour)
        message = StripFormattedString(message);
    message = "%w"$message;
    do{
        cutIndex = getNewLineCutIndex(message);
        if(cutIndex < 0){
            line = ParseFormattedLine(message);
            message = "";
        }
        else{
            line = Left(message, cutIndex);
            message = LastModifier(line)$Mid(message, cutIndex);
            line = ParseFormattedLine(line);
        }
        if(bFirstLine)
            KFController.ClientMessage(" "@line);
        else
            KFController.ClientMessage(chr(27)$chr(200)$chr(200)$chr(200)$"|"@line);    // 'white |' + 'line'
        bFirstLine = false;
    }until(FormattedLen(message) <= 0);
}
// Function for broadcasting messages to players
function BroadcastToAll(string message){
    local Controller P;
    local PlayerController Player;
    for (P = Level.ControllerList; P != none; P = P.nextController) {
        Player = PlayerController(P);
        if(Player != none)
            SendMessage(message, Player);
    }
}
// Function for displaying HealthRule class in a nice form with a given prefix
function DisplayHealthRule(String prefix, HealthRule rule, PlayerController PC){
    local String output;
    if(rule.headHealth <= 0 && rule.bodyHealth <= 0){
        SendMessage(prefix$"Health rule is empty!", PC);
        return;
    }
    if(rule.zed.bRefByAlias){
        if(rule.zed.aliasGroup != "")
            output = "%b["$rule.zed.aliasGroup$"]"@rule.zed.alias$"%w";
        else
            output = "%b"$rule.zed.alias$"%w";
    }
    else
        output = "Zed with class%b"@rule.zed.className$"%w";
    if(rule.headHealth > 0)
        output @= "must have%y"@String(rule.headHealth)@"%bhead health%w";
    if(rule.bodyHealth > 0){
        if(rule.headHealth > 0)
            output @= "and%y"@String(rule.bodyHealth)@"%bbody health%w";
        else
            output @= "must have%y"@String(rule.bodyHealth)@"%bbody health%w";
    }
    SendMessage(prefix$output, PC);
}
// Function for displaying ReplacementRule class in a nice form with a given prefix
function DisplayReplacementRule(String prefix, ReplacementRule rule, PlayerController PC){
    local String output;
    if(rule.bReplaceAll){
        output = "All zeds";
    }
    else{
        if(rule.oldZed.bRefByAlias){
            if(rule.oldZed.aliasGroup != "")
                output = "%b["$rule.oldZed.aliasGroup$"]"@rule.oldZed.alias$"%w";
            else
                output = "%b"$rule.oldZed.alias$"%w";
        }
        else
            output = "Zed with class%b"@rule.oldZed.className$"%w";
    }
    output @= "must be replaced by";
    if(rule.newZed.bRefByAlias){
        if(rule.newZed.aliasGroup != "")
            output = output@"%b["$rule.newZed.aliasGroup$"]"@rule.newZed.alias$"%w";
        else
            output = output@"%b"$rule.newZed.alias$"%w";
    }
    else
        output = output@"zed with class%b"@rule.newZed.className$"%w";
    SendMessage(prefix$output, PC);
}
// Cleans up game's current init-squads and makes a clean backup.
// Must be called before any modification of 'InitSquads' if you want your changes to be reversible and made on clean squad array
function RefreshZedSquads(){
    if(KFGT.InitSquads.Length > 0){
        bNeedToBackupInitList = false;
        if(!bDefInitCopied){
            // If we didn't even make a copy yet - do it; no need in restoration
            defInitSquads = KFGT.InitSquads;
            bDefInitCopied = true;
        }
        else
            // If we already made a copy - we only need to restore it
            KFGT.InitSquads = defInitSquads;
    }
}
// Restores zed lists to their initial states and then reapplies zed-replacement rules
function ApplyReplacementRules(){
    local int i, j, k;
    local bool bCheckPassed;
    local String newMonsterClassName;
    // Make backups / restore initial squads
    RefreshZedSquads();
    // Clear current spawn array
    KFGT.NextSpawnSquad.Length = 0;
    // No need to apply anything else
    if(replacementRules.Length == 0)
        return;
    // Handle the unlikely case in which 'InitSquads' wasn't initialized yet
    if(!bDefInitCopied){
        bNeedToBackupInitList = true;
        return;
    }
    // Replace zeds in 'InitSquads' array
    for(i = 0;i < KFGT.InitSquads.Length;i ++)
        for(j = 0;j < KFGT.InitSquads[i].MSquad.Length;j ++)
            for(k = 0;k < replacementRules.Length;k ++){
                bCheckPassed = false;
                if(replacementRules[k].oldZed.bRefByAlias && replacementRules[k].oldZed.aliasGroup != "")
                    // If player has specified a concrete alias group - use it
                    bCheckPassed = CheckClass(String(KFGT.InitSquads[i].MSquad[j]), replacementRules[k].oldZed, false);
                else
                    // Otherwise do whatever
                    bCheckPassed = CheckClass(String(KFGT.InitSquads[i].MSquad[j]), replacementRules[k].oldZed, true);
                if(bCheckPassed || replacementRules[k].bReplaceAll){
                    if(replacementRules[k].newZed.bRefByAlias)
                        newMonsterClassName = tryGetAlias(replacementRules[k].newZed.alias, replacementRules[k].newZed.aliasGroup, ALIAS_ZED);
                    else
                        newMonsterClassName = replacementRules[k].newZed.className;
                    KFGT.InitSquads[i].MSquad[j] = Class<KFMonster>(DynamicLoadObject(newMonsterClassName, Class'Class'));
                }
            }
}

defaultproperties
{
     HBoxSize=HBSIZE_NORMAL
     HeadSegmentAmount=10
     bForceLowerHealthBound=True
     TrashHeadHealth=1
     TrashBodyHealth=1
     HugeHeadHealth=1
     HugeBodyHealth=1
     BossHealth=1
     bActiveFinalWave=True
     altSpeed=0.800000
     normalSpeed=1.000000
     currentSpawnRate=-1.000000
     SafeGuardKillRadius=1000.000000
     SafeGuardInvincibilityTime=2.000000
     SafeGuardArmor="NORMAL"
     bSafeGuardRestoreKilled=True
     SafeGuardReaction=REACTION_KILL
     groupPriority="nice:mean:scrn:vanilla"
     vanillaGroupPriority="vanilla:scrn:nice:mean"
     MaxLineLength=100
     bEnableColour=True
     bAddToServerPackages=True
     GroupName="KFTrainingPack"
     FriendlyName="Training Pack"
     Description="Provides a number of commands to make your kf training and testing more comfortable."
     RulesGroup="TrainingPack"
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
