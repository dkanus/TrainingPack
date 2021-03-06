class TrainVanillaGT extends KFGameType;

var TrainingPackScrN Mut;

// Prevent damage
function int ReduceDamage(int Damage, Pawn injured, Pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType){
    local int actualDamage, damageAfterAbsord;
    local int oldShieldStrength, oldSmallShieldStrength, reducedShieldStrength;
    local KFHumanPawn PlayerPawn;
    // Get actual damage
    actualDamage = Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType);
    // If we aren't a player - we don't need to do anything
    PlayerPawn = KFHumanPawn(Injured);
    if(PlayerPawn == none)
        return actualDamage;
    // Take into account armor absorption
    if(DamageType.default.bArmorStops && actualDamage > 0){
        oldShieldStrength = PlayerPawn.ShieldStrength;
        oldSmallShieldStrength = PlayerPawn.SmallShieldStrength;
        damageAfterAbsord = PlayerPawn.ShieldAbsorb(actualDamage);
        reducedShieldStrength = PlayerPawn.ShieldStrength;
        PlayerPawn.ShieldStrength = oldShieldStrength;
        PlayerPawn.SmallShieldStrength = oldSmallShieldStrength;
    }
    else
        damageAfterAbsord = actualDamage;
    // Perform necessary actions
    if(actualDamage > 0 && Mut != none && (Mut.bGodMode || Mut.SafeGuardInvincibilityCountDown > 0.0) && !Mut.bLockCheats)
        return 0;
    if(damageAfterAbsord > 0 && Mut != none){
        if(damageAfterAbsord >= PlayerPawn.Health){
            if(Mut.bDemiGodMode && !Mut.bLockCheats){
                PlayerPawn.Health = 1;
                PlayerPawn.ShieldStrength = reducedShieldStrength;  // Reduce armor somewhat
                return 0;
            }
            if(Mut.bSafeGuard && !Mut.bLockCheats){
                Mut.Rescue(PlayerPawn, instigatedBy);
                return 0;
            }
        }
    }
    return actualDamage;
}
// Change zed-time
event Tick(float DeltaTime){
    local float TrueTimeFactor;
    local float NormalGameSpeed;
    local Controller C;
    if(Mut != none)
        NormalGameSpeed = Mut.normalSpeed;
    else
        NormalGameSpeed = 1.0;
    if(bZEDTimeActive){
        TrueTimeFactor = 1.1/Level.TimeDilation;
        CurrentZEDTimeDuration -= DeltaTime * TrueTimeFactor;

        if(CurrentZEDTimeDuration < (ZEDTimeDuration * 0.166) && CurrentZEDTimeDuration > 0){
            if(!bSpeedingBackUp){
                bSpeedingBackUp = true;

                for(C = Level.ControllerList;C != none;C = C.NextController)
                    if(KFPlayerController(C)!= none)
                        KFPlayerController(C).ClientExitZedTime();
            }
            SetGameSpeed(Lerp((CurrentZEDTimeDuration / (ZEDTimeDuration*0.166)), NormalGameSpeed, ZedTimeSlomoScale));
        }

        if(CurrentZEDTimeDuration <= 0){
            bZEDTimeActive = false;
            bSpeedingBackUp = false;
            SetGameSpeed(NormalGameSpeed);
            ZedTimeExtensionsUsed = 0;
        }
    }
}
// Replace zeds
function AddSpecialSquadFromCollection(){
    local string classString;
    local class<KFMonster> MC;
    local array< class<KFMonster> > TempSquads;
    local int i, j;
    local bool bCheckPassed;

    if(Mut.replacementRules.Length > 0){
        for(i = 0;i < MonsterCollection.default.SpecialSquads[WaveNum].ZedClass.Length;i ++){
            // Is class even specified
            classString = MonsterCollection.default.SpecialSquads[WaveNum].ZedClass[i];
            if(classString == "")
                continue;

            // Zed replacement
            for(j = 0;j < Mut.replacementRules.Length;j ++){
                bCheckPassed = false;
                if(Mut.replacementRules[j].oldZed.bRefByAlias && Mut.replacementRules[j].oldZed.aliasGroup != "")
                    // If player has specified a concrete alias group - use it
                    bCheckPassed = Mut.CheckClass(classString, Mut.replacementRules[j].oldZed, false);
                else
                    // Otherwise do whatever
                    bCheckPassed = Mut.CheckClass(classString, Mut.replacementRules[j].oldZed, true);
                if(bCheckPassed || Mut.replacementRules[j].bReplaceAll){
                    if(Mut.replacementRules[j].newZed.bRefByAlias)
                        classString = Mut.tryGetAlias(Mut.replacementRules[j].newZed.alias, Mut.replacementRules[j].newZed.aliasGroup, ALIAS_ZED);
                    else
                        classString = Mut.replacementRules[j].newZed.className;
                }
            }

            // Can we spawn this class?
            MC = class<KFMonster>(DynamicLoadObject(classString, class'Class'));
            if(MC == none)
                continue;

            // Add it to spawn list
            for(j = 0;j < MonsterCollection.default.SpecialSquads[WaveNum].NumZeds[i];j ++)
                TempSquads[TempSquads.Length] = MC;
        }
        bUsedSpecialSquad = true;
        NextSpawnSquad = TempSquads;
    }
    else
        Super.AddSpecialSquadFromCollection();  // Don't alter anything if aren't asked
}

defaultproperties
{
}
