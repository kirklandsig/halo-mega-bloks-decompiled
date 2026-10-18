class HaloConstructionLight extends Actor
	notplaceable;

var Vector Direction;
var export editinline DirectionalLightComponent LightingComponent;

simulated event PostBeginPlay()
{
	SetDirection(Direction);
	//return;	
}

simulated function SetDirection(Vector Dir)
{
	local Vector orientDir;
	local Rotator orientRot;

	orientDir = Normal(Dir);
	orientRot = Rotator(orientDir);
	SetRotation(orientRot);
	Direction = orientDir;
	ReattachComponent(LightingComponent);
	//return;	
}

defaultproperties
{
	Direction=(X=-1.0000000,Y=0.5000000,Z=0.5000000)
	// Reference: DirectionalLightComponent'MegaHaloGame.Default__HaloConstructionLight.LightingComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'LightingComponent0'
	begin object name="LightingComponent0" class=Engine.DirectionalLightComponent
		UseDirectLightMap=true
		bCanAffectDynamicPrimitivesOutsideDynamicChannel=true
		LightingChannels=(BSP=false,Static=false,Dynamic=false,CompositeDynamic=false,Unnamed_2=true)
	end object
	LightingComponent=LightingComponent0
	Components[0]=LightingComponent0
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}