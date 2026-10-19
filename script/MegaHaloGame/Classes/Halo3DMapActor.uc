class Halo3DMapActor extends Actor
	placeable;

var export editinline DynamicLightEnvironmentComponent LightEnvironment;
var export editinline StaticMeshComponent MapMesh;
var export editinline StaticMeshComponent ScreenMesh;
var export editinline SceneCapture2DComponent SceneCapture;

function InitScreen()
{
	local Vector ScreenLocation;
	local Rotator ScreenRotation;

	ScreenLocation.X = Location.X + 350.0000000;
	ScreenLocation.Y = Location.Y;
	ScreenLocation.Z = Location.Z - 350.0000000;
	ScreenRotation.Yaw = int(float(90) * 182.0444031);
	ScreenRotation.Pitch = 0;
	ScreenRotation.Roll = int(float(-60) * 182.0444031);
	ScreenMesh.SetAbsolute(true, true, true);
	ScreenMesh.SetTranslation(ScreenLocation);
	ScreenMesh.SetRotation(ScreenRotation);
	//return;	
}

function InitMap()
{
	MapMesh.SetAbsolute(true, true, true);
	MapMesh.SetTranslation(Location);
	//return;	
}

function InitSceneCapture()
{
	SceneCapture.AddComponent(ScreenMesh, ScreenMesh.GetRotation());
	SceneCapture.AddComponent(MapMesh, MapMesh.GetRotation());
	InitRenderTarget();
	InitView();
	//return;	
}

function InitRenderTarget()
{
	local LinearColor ClearColor;
	local TextureRenderTarget2D RenderTarget;

	ClearColor.R = float(SceneCapture.ClearColor.R) / 255.0000000;
	ClearColor.G = float(SceneCapture.ClearColor.G) / 255.0000000;
	ClearColor.B = float(SceneCapture.ClearColor.B) / 255.0000000;
	ClearColor.A = float(SceneCapture.ClearColor.A) / 255.0000000;
	RenderTarget = Class'Engine.TextureRenderTarget2D'.static.Create(1280, 720, 2, ClearColor, false);
	SceneCapture.SetCaptureParameters(RenderTarget);
	//return;	
}

function InitView()
{
	local Vector CaptureLocation;
	local Rotator CaptureRotation;

	CaptureLocation.X = Location.X - 350.0000000;
	CaptureLocation.Y = Location.Y;
	CaptureLocation.Z = Location.Z + 500.0000000;
	CaptureRotation.Yaw = 0;
	CaptureRotation.Pitch = int(float(-60) * 182.0444031);
	CaptureRotation.Roll = 0;
	SceneCapture.SetView(CaptureLocation, CaptureRotation);
	//return;	
}

function RotateMap(float DeltaTime)
{
	local Rotator MapRotation;

	MapRotation = MapMesh.GetRotation();
	MapRotation.Yaw += int((30.0000000 * DeltaTime) * 182.0444031);
	MapRotation.Pitch = 0;
	MapRotation.Roll = 0;
	MapMesh.SetRotation(MapRotation);
	//return;	
}

auto state Rotate
{
	ignores EndState;

	event BeginState(name PreviousStateName)
	{
		InitScreen();
		InitMap();
		InitSceneCapture();
		//return;		
	}

	event Tick(float DeltaTime)
	{
		RotateMap(DeltaTime);
		super(Actor).Tick(DeltaTime);
		//return;		
	}
	stop;	
}

defaultproperties
{
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__Halo3DMapActor.Light'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Light'
	begin object name="Light" class=Engine.DynamicLightEnvironmentComponent
		bCastShadows=false
		bDynamic=false
	end object
	LightEnvironment=Light
	// Reference: StaticMeshComponent'MegaHaloGame.Default__Halo3DMapActor.Map'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Map'
	begin object name="Map" class=Engine.StaticMeshComponent
		StaticMesh=StaticMesh'Shared_UI_Holograms.Mesh.Terrain_Generic_001'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__Halo3DMapActor.Light'
		MaxDrawDistance=7000.0000000
		CachedMaxDrawDistance=7000.0000000
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
		CollideActors=false
	end object
	MapMesh=Map
	// Reference: StaticMeshComponent'MegaHaloGame.Default__Halo3DMapActor.Screen'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Screen'
	begin object name="Screen" class=Engine.StaticMeshComponent
		StaticMesh=StaticMesh'TestGFxMat.objectiveMap_screen'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__Halo3DMapActor.Light'
		MaxDrawDistance=7000.0000000
		CachedMaxDrawDistance=7000.0000000
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
		CollideActors=false
	end object
	ScreenMesh=Screen
	// Reference: SceneCapture2DComponent'MegaHaloGame.Default__Halo3DMapActor.Capture'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Capture'
	begin object name="Capture" class=Engine.SceneCapture2DComponent
		NearPlane=10.0000000
		FarPlane=0.0000000
		bUpdateMatrices=false
		bAlwaysCapture=true
		bCaptureMainScene=false
		ViewMode=SceneCapView_Unlit
	end object
	SceneCapture=Capture
	Components[0]=Light
	Components[1]=Map
	Components[2]=Screen
	Components[3]=Capture
	CollisionType=COLLIDE_CustomDefault
	bAlwaysTick=true
	RotationRate=(Pitch=0,Yaw=10000,Roll=0)
}