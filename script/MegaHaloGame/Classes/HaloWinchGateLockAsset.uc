class HaloWinchGateLockAsset extends KAssetSpawnable;

var float ExpirationTime;
var export editinline ParticleSystemComponent ParticleSystemComponent;

state Dropping
{
	event BeginState(name PreviousStateName)
	{
		ParticleSystemComponent.ActivateSystem();
		//return;		
	}

	event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
	{
		GotoState('Dying');
		//return;		
	}

	event EndState(name NextStateName)
	{
		ParticleSystemComponent.DeactivateSystem();
		//return;		
	}
	stop;	
}

state Dying
{
	event BeginState(name PreviousStateName)
	{
		local int I;
		local Texture ColorMap, NormalMap;
		local MaterialInterface BaseMaterial;
		local MaterialInstanceTimeVarying MITV;

		I = 0;
		J0x0B:

		// End:0x1DD [Loop If]
		if(I < SkeletalMeshComponent.GetNumElements())
		{
			BaseMaterial = SkeletalMeshComponent.GetMaterial(I);
			BaseMaterial.GetTextureParameterValue('CLR_Texture', ColorMap);
			BaseMaterial.GetTextureParameterValue('NRM_Texture', NormalMap);
			MITV = new (SkeletalMeshComponent) Class'Engine.MaterialInstanceTimeVarying';
			MITV.SetParent(MaterialInstanceTimeVarying'Shared_Destruction_Materials.Materials.Master.Destruct_BlokDestroy_MITV');
			MITV.SetDuration(ExpirationTime);
			MITV.SetTextureParameterValue('CLR_Texture', ColorMap);
			MITV.SetTextureParameterValue('NRM_Texture', NormalMap);
			SkeletalMeshComponent.SetMaterial(I, MITV);
			I++;
			// [Loop Continue]
			goto J0x0B;
		}
		LifeSpan = ExpirationTime;
		//return;		
	}
	stop;	
}

defaultproperties
{
	ExpirationTime=5.0000000
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloWinchGateLockAsset.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	ParticleSystemComponent=ParticleSystemComponent0
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWinchGateLockAsset.KAssetSkelMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'KAssetSkelMeshComponent'
	// Archetype: SkeletalMeshComponent'Engine.Default__KAssetSpawnable.KAssetSkelMeshComponent'
	begin object name="KAssetSkelMeshComponent"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloWinchGateLockAsset.MyLightEnvironment'
		bNotifyRigidBodyCollision=true
		ScriptRigidBodyCollisionThreshold=0.1000000
	end object
	SkeletalMeshComponent=KAssetSkelMeshComponent
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloWinchGateLockAsset.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__KAssetSpawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	Components[0]=MyLightEnvironment
	Components[1]=KAssetSkelMeshComponent
	Components[2]=ParticleSystemComponent0
	CollisionComponent=KAssetSkelMeshComponent
}