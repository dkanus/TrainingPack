class TrainInteraction extends Interaction;

var TrainingPack Mut;

simulated function RegisterMutator(TrainingPack TPMut) {
	Mut = TPMut;
}

event NotifyLevelChange(){
    Master.RemoveInteraction(self);
}

function PostRender(Canvas C){
    local HUDKillingFloor HUDKF;
    local KFMonster KFM;
    local TrainHeadHitbox THB;
    if(Mut == none)
        return;
    HUDKF = HUDKillingFloor(C.ViewPort.Actor.myHUD);
    HUDKF.ClearStayingDebugLines();
    // Draw red square (temp solution)
    if(Mut.bUsedCheats){
        C.SetDrawColor(255, 0, 0);
        C.SetPos(C.ClipX * 0.09, C.ClipY * 0.89375);
        C.DrawRect(Texture'Engine.WhiteSquareTexture', C.ClipX * 0.02, C.ClipX * 0.02);
    }
    // Health-bars
    if(Mut.bShowBars){
        foreach C.ViewPort.Actor.DynamicActors(class'KFMonster', KFM)
            if(KFM.Health > 0)
                HUDKF.DrawHealthBar(C, KFM, KFM.Health, KFM.HealthMax, 50.0);
    }
    // Head hit-boxes
    if(Mut.bShowHitboxesClient || Mut.bShowHitboxesServer)
        foreach C.ViewPort.Actor.DynamicActors(class'TrainHeadHitbox', THB){
            if(Mut.bShowHitboxesServer)
                HUDKF.DrawStayingDebugSphere(THB.HeadLocation, THB.headScale, Mut.HeadSegmentAmount, 255, 0, 0);
            if(Mut.bShowHitboxesClient)
                HUDKF.DrawStayingDebugSphere(THB.HeadLocationClient, THB.headScaleClient, Mut.HeadSegmentAmount, 0, 255, 0);
        }
}

defaultproperties
{
     bVisible=True
}
