class UTMusicManager extends Info
	config(Game);

enum EMusicState
{
	MST_Ambient,                    // 0
	MST_Tension,                    // 1
	MST_Suspense,                   // 2
	MST_Action,                     // 3
	MST_Victory,                    // 4
	MST_MAX                         // 5
};

var float MusicStartTime;
var int LastBeat;
var private float CurrTempo;
var private float CurrFadeFactor;
var UTPlayerController PlayerOwner;
var globalconfig float MusicVolume;
var float LastActionEventTime;
var bool bPendingAction;
var config float StingerVolumeMultiplier;
var UTMusicManager.EMusicState CurrentState;
var int PendingEvent;
var float PendingEventPlayTime;
var float PendingEventDelay;
var export editinline AudioComponent CurrentTrack;
var export editinline AudioComponent MusicTracks[6];

event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	SetTimer(1.0000000, false, 'StartMusic');
	//return;	
}

function StartMusic()
{
	local UTMapInfo UMI;

	UMI = UTMapInfo(WorldInfo.GetMapInfo());
	// End:0x29A
	if((UMI != none) && UMI.MapMusicInfo != none)
	{
		MusicTracks[5] = CreateNewTrack(UMI.MapMusicInfo.MapMusic.Intro.TheCue);
		CurrentTrack = MusicTracks[5];
		LastBeat = 0;
		CurrentState = 0;
		// End:0x196
		if(MusicTracks[5] != none)
		{
			MusicTracks[5].VolumeMultiplier = MusicVolume;
			MusicTracks[5].__OnAudioFinished__Delegate = IntroFinished;
			MusicTracks[5].Play();
		}
		MusicStartTime = WorldInfo.TimeSeconds;
		PlayerOwner = UTPlayerController(Owner);
		CurrTempo = UMI.MapMusicInfo.MapMusic.Tempo;
		CurrFadeFactor = MusicVolume / float(UMI.MapMusicInfo.MapMusic.Intro.CrossfadeToMeNumMeasuresDuration);
	}
	//return;	
}

function IntroFinished(AudioComponent AC)
{
	local UTMapInfo UMI;

	// End:0x25F
	if(((AC == MusicTracks[5]) && CurrentTrack == AC) && int(CurrentState) == int(0))
	{
		UMI = UTMapInfo(WorldInfo.GetMapInfo());
		// End:0x8C
		if(UMI == none)
		{
			return;
		}
		MusicTracks[0] = CreateNewTrack(UMI.MapMusicInfo.MapMusic.Ambient.TheCue);
		// End:0x25F
		if(MusicTracks[0] != none)
		{
			MusicTracks[0].VolumeMultiplier = MusicVolume;
			MusicTracks[0].Play();
			CurrentTrack = MusicTracks[0];
			MusicStartTime = WorldInfo.TimeSeconds;
			CurrTempo = UMI.MapMusicInfo.MapMusic.Tempo;
			CurrFadeFactor = MusicVolume / float(UMI.MapMusicInfo.MapMusic.Ambient.CrossfadeToMeNumMeasuresDuration);
			LastBeat = 0;
		}
	}
	//return;	
}

function AudioComponent CreateNewTrack(SoundCue MusicCue)
{
	local editinline AudioComponent AC;

	AC = CreateAudioComponent(MusicCue, false, true);
	// End:0x73
	if(AC != none)
	{
		AC.bAllowSpatialization = false;
		AC.bShouldRemainActiveIfDropped = true;
	}
	return AC;
	//return ReturnValue;	
}

function MusicEvent(int NewEventIndex)
{
	// End:0x32
	if(PendingEvent > 0)
	{
		// End:0x28
		if(PendingEvent > NewEventIndex)
		{
			return;
		}
		ProcessMusicEvent();
	}
	PendingEvent = NewEventIndex;
	PendingEventPlayTime = WorldInfo.TimeSeconds + PendingEventDelay;
	// End:0x12A
	if((((((PendingEvent != 2) && PendingEvent != 3) && PendingEvent != 4) && PendingEvent != 5) && PendingEvent != 7) && PendingEvent < 13)
	{
		// End:0x102
		if(int(CurrentState) != int(3))
		{
			bPendingAction = true;
		}
		LastActionEventTime = WorldInfo.TimeSeconds;
	}
	//return;	
}

function bool AlreadyInActionMusic()
{
	return int(CurrentState) == int(3);
	//return ReturnValue;	
}

function ProcessMusicEvent()
{
	local UTMapInfo UMI;
	local SoundCue EventCue;
	local editinline AudioComponent EventTrack;

	// End:0x39
	if(bPendingAction)
	{
		// End:0x2D
		if(int(CurrentState) != int(3))
		{
			ChangeTrack(3);
		}
		bPendingAction = false;
	}
	UMI = UTMapInfo(WorldInfo.GetMapInfo());
	// End:0x7C
	if(UMI == none)
	{
		return;
	}
	switch(PendingEvent)
	{
		// End:0xE6
		case 1:
			EventCue = UMI.MapMusicInfo.MapStingers.Kill;
			// End:0x5B9
			break;
		// End:0x13E
		case 2:
			EventCue = UMI.MapMusicInfo.MapStingers.Died;
			// End:0x5B9
			break;
		// End:0x196
		case 3:
			EventCue = UMI.MapMusicInfo.MapStingers.ReturnFlag;
			// End:0x5B9
			break;
		// End:0x1EE
		case 4:
			EventCue = UMI.MapMusicInfo.MapStingers.EnemyGrabFlag;
			// End:0x5B9
			break;
		// End:0x246
		case 5:
			EventCue = UMI.MapMusicInfo.MapStingers.FlagReturned;
			// End:0x5B9
			break;
		// End:0x29E
		case 6:
			EventCue = UMI.MapMusicInfo.MapStingers.MajorKill;
			// End:0x5B9
			break;
		// End:0x2F6
		case 7:
			EventCue = UMI.MapMusicInfo.MapStingers.GrabFlag;
			// End:0x5B9
			break;
		// End:0x34E
		case 8:
			EventCue = UMI.MapMusicInfo.MapStingers.FirstKillingSpree;
			// End:0x5B9
			break;
		// End:0x3A6
		case 9:
			EventCue = UMI.MapMusicInfo.MapStingers.DoubleKill;
			// End:0x5B9
			break;
		// End:0x3FE
		case 10:
			EventCue = UMI.MapMusicInfo.MapStingers.LongKillingSpree;
			// End:0x5B9
			break;
		// End:0x456
		case 11:
			EventCue = UMI.MapMusicInfo.MapStingers.MultiKill;
			// End:0x5B9
			break;
		// End:0x4AE
		case 12:
			EventCue = UMI.MapMusicInfo.MapStingers.MonsterKill;
			// End:0x5B9
			break;
		// End:0x506
		case 13:
			EventCue = UMI.MapMusicInfo.MapStingers.ScoreLosing;
			// End:0x5B9
			break;
		// End:0x55E
		case 14:
			EventCue = UMI.MapMusicInfo.MapStingers.ScoreTie;
			// End:0x5B9
			break;
		// End:0x5B6
		case 15:
			EventCue = UMI.MapMusicInfo.MapStingers.ScoreWinning;
			// End:0x5B9
			break;
		// End:0xFFFF
		default:
			break;
	}
	EventTrack = CreateNewTrack(EventCue);
	// End:0x64D
	if(EventTrack != none)
	{
		EventTrack.bAutoDestroy = true;
		EventTrack.VolumeMultiplier = StingerVolumeMultiplier;
		EventTrack.Play();
	}
	//return;	
}

function Tick(float DeltaTime)
{
	local float NumBeats;
	local int I;
	local UTMusicManager.EMusicState NewState;

	// End:0x9B
	if((CurrentTrack != none) && CurrentTrack.VolumeMultiplier < MusicVolume)
	{
		CurrentTrack.VolumeMultiplier = FMin(MusicVolume, CurrentTrack.VolumeMultiplier + (CurrFadeFactor * DeltaTime));
	}
	I = 0;
	J0xA6:

	// End:0x224 [Loop If]
	if(I < 6)
	{
		// End:0x216
		if(((MusicTracks[I] != none) && MusicTracks[I] != CurrentTrack) && MusicTracks[I].VolumeMultiplier > 0.0000000)
		{
			MusicTracks[I].VolumeMultiplier = MusicTracks[I].VolumeMultiplier - (CurrFadeFactor * DeltaTime);
			// End:0x216
			if(MusicTracks[I].VolumeMultiplier <= 0.0000000)
			{
				MusicTracks[I].VolumeMultiplier = 0.0000000;
				MusicTracks[I].Stop();
			}
		}
		I++;
		// [Loop Continue]
		goto J0xA6;
	}
	NumBeats = ((WorldInfo.TimeSeconds - MusicStartTime) * CurrTempo) / float(60);
	// End:0x288
	if((NumBeats - float(LastBeat)) < float(1))
	{
		return;
	}
	LastBeat = int(NumBeats);
	// End:0x2B2
	if((LastBeat % 2) != 0)
	{
		return;
	}
	// End:0x306
	if((PendingEvent > 0) && WorldInfo.TimeSeconds > PendingEventPlayTime)
	{
		ProcessMusicEvent();
		PendingEvent = 0;
		return;
	}
	// End:0x493
	if(PlayerOwner.Pawn != none)
	{
		// End:0x3DC
		if((PlayerOwner.Pawn.Weapon != none) && PlayerOwner.Pawn.Weapon.IsFiring())
		{
			LastActionEventTime = WorldInfo.TimeSeconds;			
		}
		else
		{
			// End:0x493
			if((UTPawn(PlayerOwner.Pawn) != none) && UTPawn(PlayerOwner.Pawn).InCombat())
			{
				LastActionEventTime = WorldInfo.TimeSeconds;
				// End:0x493
				if(int(CurrentState) != int(3))
				{
					ChangeTrack(3);
				}
			}
		}
	}
	// End:0x705
	if((int(CurrentState) != int(3)) || (WorldInfo.TimeSeconds - LastActionEventTime) > float(8))
	{
		// End:0x559
		if((UTPawn(PlayerOwner.Pawn) != none) && UTPawn(PlayerOwner.Pawn).PoweredUp())
		{
			NewState = 4;			
		}
		else
		{
			// End:0x6CB
			if(UTGameReplicationInfo(WorldInfo.GRI).FlagsAreHome()!)
			{
				// End:0x5EA
				if(UTPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bHasFlag)
				{
					NewState = 4;					
				}
				else
				{
					// End:0x6BC
					if((PlayerOwner.PlayerReplicationInfo.Team != none) && UTGameReplicationInfo(WorldInfo.GRI).FlagIsHome(PlayerOwner.PlayerReplicationInfo.Team.TeamIndex))
					{
						NewState = 2;						
					}
					else
					{
						NewState = 1;
					}
				}				
			}
			else
			{
				NewState = 0;
			}
		}
		// End:0x705
		if(int(NewState) != int(CurrentState))
		{
			ChangeTrack(NewState);
		}
	}
	//return;	
}

function ChangeTrack(UTMusicManager.EMusicState NewState)
{
	local UTMapInfo UMI;
	local editinline AudioComponent NewTrack;

	// End:0x1D
	if(int(CurrentState) == int(NewState))
	{
		return;
	}
	CurrentState = NewState;
	UMI = UTMapInfo(WorldInfo.GetMapInfo());
	// End:0x73
	if(UMI == none)
	{
		return;
	}
	switch(NewState)
	{
		// End:0x288
		case 0:
			// End:0x1B0
			if(MusicTracks[0] == none)
			{
				// End:0x141
				if((CurrentTrack != none) && CurrentTrack.SoundCue == UMI.MapMusicInfo.MapMusic.Ambient.TheCue)
				{
					MusicTracks[0] = CurrentTrack;					
				}
				else
				{
					MusicTracks[0] = CreateNewTrack(UMI.MapMusicInfo.MapMusic.Ambient.TheCue);
				}
			}
			NewTrack = MusicTracks[0];
			CurrTempo = UMI.MapMusicInfo.MapMusic.Tempo;
			CurrFadeFactor = MusicVolume / float(UMI.MapMusicInfo.MapMusic.Ambient.CrossfadeToMeNumMeasuresDuration);
			// End:0xA9F
			break;
		// End:0x48A
		case 1:
			// End:0x3B2
			if(MusicTracks[1] == none)
			{
				// End:0x343
				if((CurrentTrack != none) && CurrentTrack.SoundCue == UMI.MapMusicInfo.MapMusic.Tension.TheCue)
				{
					MusicTracks[1] = CurrentTrack;					
				}
				else
				{
					MusicTracks[1] = CreateNewTrack(UMI.MapMusicInfo.MapMusic.Tension.TheCue);
				}
			}
			NewTrack = MusicTracks[1];
			CurrTempo = UMI.MapMusicInfo.MapMusic.Tempo;
			CurrFadeFactor = MusicVolume / float(UMI.MapMusicInfo.MapMusic.Tension.CrossfadeToMeNumMeasuresDuration);
			// End:0xA9F
			break;
		// End:0x690
		case 2:
			// End:0x5B7
			if(MusicTracks[2] == none)
			{
				// End:0x547
				if((CurrentTrack != none) && CurrentTrack.SoundCue == UMI.MapMusicInfo.MapMusic.Suspense.TheCue)
				{
					MusicTracks[2] = CurrentTrack;					
				}
				else
				{
					MusicTracks[2] = CreateNewTrack(UMI.MapMusicInfo.MapMusic.Suspense.TheCue);
				}
			}
			NewTrack = MusicTracks[2];
			CurrTempo = UMI.MapMusicInfo.MapMusic.Tempo;
			CurrFadeFactor = MusicVolume / float(UMI.MapMusicInfo.MapMusic.Suspense.CrossfadeToMeNumMeasuresDuration);
			// End:0xA9F
			break;
		// End:0x896
		case 3:
			// End:0x7BD
			if(MusicTracks[3] == none)
			{
				// End:0x74D
				if((CurrentTrack != none) && CurrentTrack.SoundCue == UMI.MapMusicInfo.MapMusic.Action.TheCue)
				{
					MusicTracks[3] = CurrentTrack;					
				}
				else
				{
					MusicTracks[3] = CreateNewTrack(UMI.MapMusicInfo.MapMusic.Action.TheCue);
				}
			}
			NewTrack = MusicTracks[3];
			CurrTempo = UMI.MapMusicInfo.MapMusic.Tempo;
			CurrFadeFactor = MusicVolume / float(UMI.MapMusicInfo.MapMusic.Action.CrossfadeToMeNumMeasuresDuration);
			// End:0xA9F
			break;
		// End:0xA9C
		case 4:
			// End:0x9C3
			if(MusicTracks[4] == none)
			{
				// End:0x953
				if((CurrentTrack != none) && CurrentTrack.SoundCue == UMI.MapMusicInfo.MapMusic.Victory.TheCue)
				{
					MusicTracks[4] = CurrentTrack;					
				}
				else
				{
					MusicTracks[4] = CreateNewTrack(UMI.MapMusicInfo.MapMusic.Victory.TheCue);
				}
			}
			NewTrack = MusicTracks[4];
			CurrTempo = UMI.MapMusicInfo.MapMusic.Tempo;
			CurrFadeFactor = MusicVolume / float(UMI.MapMusicInfo.MapMusic.Victory.CrossfadeToMeNumMeasuresDuration);
			// End:0xA9F
			break;
		// End:0xFFFF
		default:
			break;
	}
	// End:0xAED
	if(((CurrentTrack == NewTrack) && CurrentTrack != none) && CurrentTrack.bWasPlaying)
	{
		return;
	}
	CurrentTrack = NewTrack;
	MusicStartTime = WorldInfo.TimeSeconds;
	LastBeat = 0;
	// End:0xB85
	if(CurrentTrack != none)
	{
		CurrentTrack.VolumeMultiplier = 0.0000000;
		CurrentTrack.Play();
	}
	//return;	
}

defaultproperties
{
	MusicVolume=0.3600000
	LastActionEventTime=-1000.0000000
	StingerVolumeMultiplier=1.1000000
	PendingEventDelay=0.1250000
}