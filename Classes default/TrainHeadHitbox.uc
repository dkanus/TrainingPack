// Code is... borrowed from SkellTestMap's mutator
class TrainHeadHitbox extends Actor
    dependson(TrainingPack);

var TrainingPack Mut;
var KFMonster Zed;
var Vector HeadLocation;
var float headScale;
var Vector HeadLocationClient;
var float headScaleClient;

replication{
    reliable if(Role == ROLE_Authority && Mut != None && (Mut.bShowHitboxesServer || Mut.bShowHitboxesClient))
        HeadLocation, headScale;
    reliable if(Role == ROLE_Authority)
        Zed, Mut;
}

simulated function RegisterMutator(TrainingPack TPMut){
	Mut = TPMut;
}

simulated event PostBeginPlay() {
    Super.PostBeginPlay();

    if(Role == ROLE_Authority && Owner != none){
        SetLocation(Owner.Location);
        SetPhysics(PHYS_None);
        SetBase(Owner);
        Zed = KFMonster(Owner);
    }
}

simulated event Tick(float deltaTime){
    local Coords C;
    local bool bAltHeadLoc;
    local NiceMonster niceZed;

    Super.Tick(deltaTime);
    if(Zed == None || Zed.bDecapitated || Zed.HeadBone == '' || Zed.health <= 0){
        Destroy();
        return;
    }
    if(Mut == none)
        return;
    // Client hit-boxes
    if(Role < ROLE_Authority && Mut.bShowHitboxesClient){
        niceZed = NiceMonster(Zed);
        headScaleClient = Zed.headRadius * Zed.headScale;
        if(niceZed != none && Mut.HBoxSize == HBSIZE_EASY)
            headScaleClient *= niceZed.extOnlineHeadshotScale;
        else if(Mut.HBoxSize != HBSIZE_HARD)
            headScaleClient *= Zed.onlineHeadshotScale;
        C = Zed.GetBoneCoords(Zed.HeadBone);
        HeadLocationClient = C.Origin + (Zed.headHeight * Zed.headScale * C.XAxis);
    }
    // Server hit-boxes
    if(Role == ROLE_Authority && Mut.bShowHitboxesServer){
        if(Level.NetMode == NM_DedicatedServer && Zed.Physics == PHYS_Walking && !Zed.IsAnimating(0) && !Zed.IsAnimating(1) && !Zed.bIsCrouched)
            bAltHeadLoc = true;

        headScale = Zed.headRadius * Zed.headScale;
        if(bAltHeadLoc){
            HeadLocation = Zed.Location + (Zed.OnlineHeadshotOffset >> Zed.Rotation);
            if(Level.NetMode == NM_DedicatedServer && Mut.HBoxSize != HBSIZE_HARD)
                headScale *= Zed.onlineHeadshotScale;
        }
        else{
            C = Zed.GetBoneCoords(Zed.HeadBone);
            HeadLocation = C.Origin + (Zed.headHeight * Zed.headScale * C.XAxis);
        }
    }
}

defaultproperties
{
     bHidden=True
     bSkipActorPropertyReplication=True
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=2.000000
}
