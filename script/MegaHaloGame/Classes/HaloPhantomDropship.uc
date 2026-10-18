class HaloPhantomDropship extends SkeletalMeshActor;

var float VelocityDivider;
var name EngineBone;
var name ExhaustBone;

simulated function StartDropshipSound()
{
	local Vector frontLoc, rearLoc;

	SetSwitch('Vehicle_Type', 'COV_Phantom');
	SetSwitch('Local_Player', 'No');
	SetRTPCValue('Thrust', 0.0000000);
	// End:0x9D
	if(EngineBone != 'None')
	{
		frontLoc = SkeletalMeshComponent.GetBoneLocation(EngineBone);		
	}
	else
	{
		WarnInternal("No engine bone set to play engine sound for " $ string(self));
		frontLoc = Location;
	}
	// End:0x132
	if(ExhaustBone != 'None')
	{
		rearLoc = SkeletalMeshComponent.GetBoneLocation(ExhaustBone);		
	}
	else
	{
		WarnInternal("No exhaust bone set to play exhaust sound for " $ string(self));
		rearLoc = Location;
	}
	PlayAkEvent(AkEvent'Vehicles.Play_Engine',,,, frontLoc);
	PlayAkEvent(AkEvent'Vehicles.Play_Exhaust',,,, rearLoc);
	//return;	
}

simulated function StopDropshipSound()
{
	PlayAkEvent(AkEvent'Vehicles.Stop_Engine');
	PlayAkEvent(AkEvent'Vehicles.Stop_Exhaust');
	//return;	
}

simulated event Tick(float DeltaTime)
{
	local int Speed;

	// End:0x35
	if(bHidden)
	{
		// End:0x32
		if(LatentActions.Length != 0)
		{
			SetHidden(false);
			StartDropshipSound();
		}		
	}
	else
	{
		// End:0x5D
		if(LatentActions.Length == 0)
		{
			SetHidden(true);
			StopDropshipSound();			
		}
		else
		{
			Speed = int(VSize(Velocity) / VelocityDivider);
			Speed = Max(Min(Speed, 100), 0);
			SetRTPCValue('Thrust', float(Speed));
		}
	}
	super(Actor).Tick(DeltaTime);
	//return;	
}

defaultproperties
{
	VelocityDivider=60.0000000
	EngineBone="Phantom__bone"
	ExhaustBone="Phantom__bone"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloPhantomDropship.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'Engine.Default__SkeletalMeshActor.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloPhantomDropship.SkeletalMeshComponent0.AnimNodeSeq0'
		// Archetype: AnimNodeSequence'Engine.Default__SkeletalMeshActor.AnimNodeSeq0'
		begin object name="AnimNodeSeq0"
		end object
		Animations=AnimNodeSeq0
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPhantomDropship.MyLightEnvironment'
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPhantomDropship.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__SkeletalMeshActor.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: AudioComponent'MegaHaloGame.Default__HaloPhantomDropship.FaceAudioComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FaceAudioComponent'
	// Archetype: AudioComponent'Engine.Default__SkeletalMeshActor.FaceAudioComponent'
	begin object name="FaceAudioComponent"
	end object
	FacialAudioComp=FaceAudioComponent
	Components[0]=MyLightEnvironment
	Components[1]=SkeletalMeshComponent0
	Components[2]=FaceAudioComponent
	bHidden=true
	CollisionComponent=SkeletalMeshComponent0
}