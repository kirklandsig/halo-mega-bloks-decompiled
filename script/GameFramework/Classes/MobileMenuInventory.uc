class MobileMenuInventory extends MobileMenuObject;

struct RenderElementInfo
{
	var bool bIsDragItem;
	var int Index;

	structdefaultproperties
	{
		bIsDragItem=false
		Index=0
	}
};

struct DragElementInfo
{
	var bool bIsDragging;
	var int IndexFrom;
	var bool bIsOver;
	var int IndexOver;
	var bool bCanDropInOver;
	var Vector2D OrigTouch;
	var Vector2D CurTouch;
	var Interaction.ETouchType EventType;

	structdefaultproperties
	{
		bIsDragging=false
		IndexFrom=0
		bIsOver=false
		IndexOver=0
		bCanDropInOver=false
		OrigTouch=(X=0.0000000,Y=0.0000000)
		CurTouch=(X=0.0000000,Y=0.0000000)
		EventType=Touch_Began
	}
};

var array<MobileMenuElement> Slots;
var array<MobileMenuElement> Items;
var float SideLeewayPercent;
var RenderElementInfo CurrentElement;
var DragElementInfo Drag;
var Vector2D ScaleSize;
var bool bRenderDragItem;
//var delegate<OnUpdateItemInSlot> __OnUpdateItemInSlot__Delegate;
//var delegate<DoCanPutItemInSlot> __DoCanPutItemInSlot__Delegate;
//var delegate<OnUpdateDrag> __OnUpdateDrag__Delegate;

delegate OnUpdateItemInSlot(MobileMenuInventory FromInv, int SlotIndex)
{
	//return;	
}

delegate bool DoCanPutItemInSlot(MobileMenuInventory FromInv, MobileMenuElement Item, MobileMenuElement ToSlot, int ToIdx, int FromIdx)
{
	//return ReturnValue;	
}

delegate OnUpdateDrag(const out DragElementInfo Before, const out DragElementInfo After)
{
	//return;	
}

function InitMenuObject(MobilePlayerInput PlayerInput, MobileMenuScene Scene, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{
	local MobileMenuElement Element;

	ScaleSize.X = Width;
	ScaleSize.Y = Height;
	super.InitMenuObject(PlayerInput, Scene, ScreenWidth, ScreenHeight, bIsFirstInitialization);
	ScaleSize.X = Width / ScaleSize.X;
	ScaleSize.Y = Height / ScaleSize.Y;
	// End:0x137
	foreach Slots(Element)
	{
		ScaleSlot(Element);		
	}	
	// End:0x163
	foreach Items(Element)
	{
		ScaleSlot(Element);		
	}	
	Items.Length = Slots.Length;
	//return;	
}

function int AddSlot(MobileMenuElement Slot)
{
	// End:0x53
	if(Slot != none)
	{
		Slots.AddItem(Slot);
		// End:0x45
		if(bHasBeenInitialized)
		{
			ScaleSlot(Slot);
		}
		return Slots.Length - 1;
	}
	return -1;
	//return ReturnValue;	
}

private final function ScaleSlot(MobileMenuElement Slot)
{
	Slot.VpPos.X *= ScaleSize.X;
	Slot.VpPos.Y *= ScaleSize.Y;
	Slot.VpSize.X *= ScaleSize.X;
	Slot.VpSize.Y *= ScaleSize.Y;
	//return;	
}

function bool CanPutItemInSlot(MobileMenuElement Item, MobileMenuElement ToSlot, int ToIdx, optional int FromIdx = -1)
{
	// End:0x44
	if(((Item == none) || FromIdx == ToIdx) || ToIdx < 0)
	{
		return false;
	}
	// End:0x8C
	if(__DoCanPutItemInSlot__Delegate != none)
	{
		return DoCanPutItemInSlot(self, Item, ToSlot, ToIdx, FromIdx);
	}
	return true;
	//return ReturnValue;	
}

event bool OnTouch(Interaction.ETouchType EventType, float TouchX, float TouchY, MobileMenuObject ObjectOver, float DeltaTime)
{
	local DragElementInfo OrigDrag;

	OrigDrag = Drag;
	Drag.EventType = EventType;
	TouchX -= Left;
	TouchY -= Top;
	Drag.CurTouch.X = TouchX;
	Drag.CurTouch.Y = TouchY;
	switch(EventType)
	{
		// End:0x141
		case 0:
			InitDragAt(int(TouchX), int(TouchY));
			// End:0x13F
			if(__OnUpdateDrag__Delegate != none)
			{
				OnUpdateDrag(OrigDrag, Drag);
			}
			return true;
		// End:0x146
		case 1:
		// End:0x30A
		case 2:
			// End:0x190
			if(!Drag.bIsDragging)
			{
				InitDragAt(int(TouchX), int(TouchY));				
			}
			else
			{
				Drag.IndexOver = FindSlotIndexAt(TouchX, TouchY);
				Drag.bIsOver = Drag.IndexOver >= 0;
			}
			Drag.bCanDropInOver = Drag.bIsOver && CanPutItemInSlot(Items[Drag.IndexFrom], Slots[Drag.IndexOver], Drag.IndexOver, Drag.IndexFrom);
			// End:0x308
			if(__OnUpdateDrag__Delegate != none)
			{
				OnUpdateDrag(OrigDrag, Drag);
			}
			return true;
		// End:0x4FA
		case 3:
			// End:0x4F7
			if(Drag.bIsDragging)
			{
				// End:0x3C7
				if(!Drag.bIsOver)
				{
					Drag.IndexOver = FindSlotIndexAt(TouchX, TouchY);
					Drag.bIsOver = Drag.IndexOver >= 0;
				}
				Drag.bCanDropInOver = Drag.bIsOver && CanPutItemInSlot(Items[Drag.IndexFrom], Slots[Drag.IndexOver], Drag.IndexOver, Drag.IndexFrom);
				// End:0x4F7
				if(Drag.bCanDropInOver)
				{
					SwapItemsInSlots(Drag.IndexOver, Drag.IndexFrom);
				}
			}
			// End:0x505
			break;
		// End:0x502
		case 4:
			// End:0x505
			break;
		// End:0xFFFF
		default:
			break;
	}
	Drag.bIsDragging = false;
	// End:0x558
	if(__OnUpdateDrag__Delegate != none)
	{
		OnUpdateDrag(OrigDrag, Drag);
	}
	Drag.bCanDropInOver = false;
	Drag.bIsOver = false;
	return true;
	//return ReturnValue;	
}

function bool SwapItemsInSlots(int Slot0, int Slot1)
{
	local MobileMenuElement Element0, Element1;

	Element0 = Items[Slot0];
	Element1 = Items[Slot1];
	// End:0x134
	if((Element0 == none) || CanPutItemInSlot(Element0, Slots[Slot1], Slot1, Slot0))
	{
		// End:0x134
		if((Element1 == none) || CanPutItemInSlot(Element1, Slots[Slot0], Slot0, Slot1))
		{
			Items[Slot0] = Element1;
			Items[Slot1] = Element0;
			UpdateItemInSlot(Slot0);
			UpdateItemInSlot(Slot1);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function MobileMenuElement AddItemToSlot(MobileMenuElement Element, int ToSlot)
{
	local MobileMenuElement PrevElement;

	// End:0x8A
	if(CanPutItemInSlot(Element, Slots[ToSlot], ToSlot))
	{
		PrevElement = Items[ToSlot];
		Items[ToSlot] = Element;
		UpdateItemInSlot(ToSlot);
		return PrevElement;
	}
	return none;
	//return ReturnValue;	
}

protected function UpdateItemInSlot(int InSlot)
{
	local MobileMenuElement Element, Slot;

	Element = Items[InSlot];
	// End:0xC3
	if(Element != none)
	{
		Slot = Slots[InSlot];
		Element.VpPos = Slot.VpPos;
		Element.VpSize = Slot.VpSize;
	}
	// End:0xEF
	if(__OnUpdateItemInSlot__Delegate != none)
	{
		OnUpdateItemInSlot(self, InSlot);
	}
	//return;	
}

function InitDragAt(int TouchX, int TouchY)
{
	Drag.IndexFrom = FindSlotIndexAt(float(TouchX), float(TouchY));
	Drag.bIsDragging = (Drag.IndexFrom >= 0) && Items[Drag.IndexFrom] != none;
	Drag.IndexOver = Drag.IndexFrom;
	Drag.bIsOver = Drag.IndexFrom >= 0;
	Drag.bCanDropInOver = false;
	Drag.OrigTouch.X = float(TouchX);
	Drag.OrigTouch.Y = float(TouchY);
	//return;	
}

function int FindSlotIndexAt(float X, float Y)
{
	local MobileMenuElement Element;
	local float ExtraX, ExtraY;
	local int Idx;

	Idx = -1;
	// End:0x289
	foreach Slots(Element)
	{
		Idx++;
		// End:0x288
		if(Element.bIsActive)
		{
			ExtraX = Element.VpSize.X * SideLeewayPercent;
			ExtraY = Element.VpSize.Y * SideLeewayPercent;
			// End:0x12D
			if(X < (Element.VpPos.X - ExtraX))
			{
				continue;
				// [Explicit Continue]
				goto J0x289;
			}
			// End:0x17B
			if(Y < (Element.VpPos.Y - ExtraY))
			{
				continue;
				// [Explicit Continue]
				goto J0x289;
			}
			// End:0x1FC
			if(X > ((Element.VpPos.X + Element.VpSize.X) + ExtraX))
			{
				continue;
				// [Explicit Continue]
				goto J0x289;
			}
			// End:0x27D
			if(Y > ((Element.VpPos.Y + Element.VpSize.Y) + ExtraY))
			{
				continue;
				// [Explicit Continue]
				goto J0x289;
			}			
			return Idx;
		}		
	}
	J0x289:
	
	return -1;
	//return ReturnValue;	
}

function int GetIndexOfItem(MobileMenuElement Item)
{
	return Items.Find(Item);
	//return ReturnValue;	
}

function RenderObject(Canvas Canvas, float DeltaTime)
{
	local MobileMenuElement Element;
	local float OrgX, OrgY;

	OrgX = Canvas.OrgX;
	OrgY = Canvas.OrgY;
	CurrentElement.bIsDragItem = false;
	CurrentElement.Index = 0;
	// End:0x1B7
	foreach Slots(Element)
	{
		// End:0x198
		if(Element.bIsVisible)
		{
			Canvas.SetOrigin(Left + Element.VpPos.X, Top + Element.VpPos.Y);
			Element.RenderElement(self, Canvas, DeltaTime, Opacity);
		}
		CurrentElement.Index++;		
	}	
	CurrentElement.Index = 0;
	J0x1D6:

	// End:0x357 [Loop If]
	if(CurrentElement.Index < Items.Length)
	{
		Element = Items[CurrentElement.Index];
		// End:0x336
		if((Element != none) && Element.bIsVisible)
		{
			Canvas.SetOrigin(Left + Element.VpPos.X, Top + Element.VpPos.Y);
			Element.RenderElement(self, Canvas, DeltaTime, Opacity);
		}
		CurrentElement.Index++;
		// [Loop Continue]
		goto J0x1D6;
	}
	Canvas.OrgX = OrgX;
	Canvas.OrgY = OrgY;
	// End:0x3D0
	if(bRenderDragItem)
	{
		RenderDragItem(Canvas, DeltaTime);
	}
	//return;	
}

function RenderDragItem(Canvas Canvas, float DeltaTime)
{
	local MobileMenuElement Element;
	local float OrgX, OrgY;

	// End:0x216
	if(Drag.bIsDragging)
	{
		OrgX = Canvas.OrgX;
		OrgY = Canvas.OrgY;
		CurrentElement.bIsDragItem = true;
		CurrentElement.Index = Drag.IndexFrom;
		Element = Items[Drag.IndexFrom];
		Canvas.SetOrigin(Left + Drag.CurTouch.X, Top + Drag.CurTouch.Y);
		Element.RenderElement(self, Canvas, DeltaTime, Opacity);
		Canvas.OrgX = OrgX;
		Canvas.OrgY = OrgY;
	}
	//return;	
}

defaultproperties
{
	SideLeewayPercent=0.1000000
	bRenderDragItem=true
	bIsActive=true
}