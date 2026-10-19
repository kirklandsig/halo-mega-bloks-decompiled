class GFxObject extends Object within GFxMoviePlayer
	native
	dependson(GFxMoviePlayer);

struct native ASDisplayInfo
{
	var float X;
	var float Y;
	var float Z;
	var float Rotation;
	var float XRotation;
	var float YRotation;
	var float XScale;
	var float YScale;
	var float ZScale;
	var float Alpha;
	var bool Visible;
	var bool hasX;
	var bool hasY;
	var bool hasZ;
	var bool hasRotation;
	var bool hasXRotation;
	var bool hasYRotation;
	var bool hasXScale;
	var bool hasYScale;
	var bool hasZScale;
	var bool hasAlpha;
	var bool hasVisible;

	structdefaultproperties
	{
		X=0.0000000
		Y=0.0000000
		Z=0.0000000
		Rotation=0.0000000
		XRotation=0.0000000
		YRotation=0.0000000
		XScale=0.0000000
		YScale=0.0000000
		ZScale=0.0000000
		Alpha=0.0000000
		Visible=false
		hasX=false
		hasY=false
		hasZ=false
		hasRotation=false
		hasXRotation=false
		hasYRotation=false
		hasXScale=false
		hasYScale=false
		hasZScale=false
		hasAlpha=false
		hasVisible=false
	}
};

struct native ASColorTransform
{
	var LinearColor Multiply;
	var LinearColor Add;

	structdefaultproperties
	{
		Multiply=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000)
		Add=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
	}
};

var private native const int Value[12];
var array<GFxWidgetBinding> SubWidgetBindings;

// Export UGFxObject::execGet(FFrame&, void* const)
native final function ASValue Get(string Member);

// Export UGFxObject::execGetBool(FFrame&, void* const)
native final function bool GetBool(string Member);

// Export UGFxObject::execGetFloat(FFrame&, void* const)
native final function float GetFloat(string Member);

// Export UGFxObject::execGetInt(FFrame&, void* const)
native final function int GetInt(string Member);

// Export UGFxObject::execGetString(FFrame&, void* const)
native final function string GetString(string Member);

// Export UGFxObject::execGetObject(FFrame&, void* const)
native final function GFxObject GetObject(string Member, optional Class<GFxObject> Type = Class'GFxUI.GFxObject');

// Export UGFxObject::execSet(FFrame&, void* const)
native final function Set(string Member, ASValue Arg);

// Export UGFxObject::execSetBool(FFrame&, void* const)
native final function SetBool(string Member, bool B);

// Export UGFxObject::execSetFloat(FFrame&, void* const)
native final function SetFloat(string Member, float F);

// Export UGFxObject::execSetInt(FFrame&, void* const)
native final function SetInt(string Member, int I);

// Export UGFxObject::execSetString(FFrame&, void* const)
native final function SetString(string Member, string S, optional TranslationContext InContext);

// Export UGFxObject::execSetObject(FFrame&, void* const)
native final function SetObject(string Member, GFxObject val);

// Export UGFxObject::execSetFunction(FFrame&, void* const)
native final function SetFunction(string Member, Object context, name fname);

// Export UGFxObject::execTranslateString(FFrame&, void* const)
native static function string TranslateString(string StringToTranslate, optional TranslationContext InContext);

// Export UGFxObject::execGetDisplayInfo(FFrame&, void* const)
native final function ASDisplayInfo GetDisplayInfo();

// Export UGFxObject::execGetPosition(FFrame&, void* const)
native final function bool GetPosition(out float X, out float Y);

// Export UGFxObject::execGetColorTransform(FFrame&, void* const)
native final function ASColorTransform GetColorTransform();

// Export UGFxObject::execGetDisplayMatrix(FFrame&, void* const)
native final function Matrix GetDisplayMatrix();

// Export UGFxObject::execGetDisplayMatrix3D(FFrame&, void* const)
native final function Matrix GetDisplayMatrix3D();

// Export UGFxObject::execSetDisplayInfo(FFrame&, void* const)
native final function SetDisplayInfo(ASDisplayInfo D);

// Export UGFxObject::execSetPosition(FFrame&, void* const)
native final function SetPosition(float X, float Y);

// Export UGFxObject::execSetColorTransform(FFrame&, void* const)
native final function SetColorTransform(ASColorTransform cxform);

// Export UGFxObject::execSetDisplayMatrix(FFrame&, void* const)
native final function SetDisplayMatrix(Matrix M);

// Export UGFxObject::execSetDisplayMatrix3D(FFrame&, void* const)
native final function SetDisplayMatrix3D(Matrix M);

// Export UGFxObject::execSetVisible(FFrame&, void* const)
native final function SetVisible(bool Visible);

// Export UGFxObject::execGetText(FFrame&, void* const)
native final function string GetText();

// Export UGFxObject::execSetText(FFrame&, void* const)
native final function SetText(coerce string Text, optional TranslationContext InContext);

final function SetTextWithIcon(string Text, optional TranslationContext InContext)
{
	local string convertedString, remainingString;
	local array<string> returnedStrings;

	convertedString = "";
	remainingString = Text;
	J0x20:

	// End:0xC7 [Loop If]
	if(true)
	{
		returnedStrings = ConvertTextToIcons(remainingString);
		// End:0x76
		if(returnedStrings[0] != "")
		{			
			convertedString $= returnedStrings[0];			
		}
		else
		{			
			convertedString $= remainingString;
			// [Explicit Break]
			goto J0xC7;
		}
		// End:0xC1
		if(returnedStrings[1] != "")
		{
			remainingString = returnedStrings[1];			
		}
		else
		{
			// [Explicit Break]
			goto J0xC7;
		}
		// [Loop Continue]
		goto J0x20;
	}
	J0xC7:

	SetBool("html", true);
	SetString("htmlText", convertedString);
	//return;	
}

final function array<string> ConvertTextToIcons(string inputString)
{
	local array<string> returnArray;
	local int iconStartIndex, iconEndIndex, iconHeight, iconWidth;
	local float originalIconHeight;
	local int iconOffset;
	local string iconPath, convertedString;

	returnArray.AddItem("");
	returnArray.AddItem("");
	iconStartIndex = InStr(inputString, "[");
	// End:0x29B
	if(iconStartIndex >= 0)
	{
		iconEndIndex = InStr(inputString, "]");
		iconPath = Mid(inputString, iconStartIndex + 1, (iconEndIndex - iconStartIndex) - 1);
		originalIconHeight = float(Texture2D(DynamicLoadObject(iconPath, Class'Engine.Texture2D')).SizeY);
		iconHeight = int((GetFloat("_height") / GetFloat("bottomScroll")) * 0.9000000);
		iconWidth = int((float(iconHeight) / originalIconHeight) * float(Texture2D(DynamicLoadObject(iconPath, Class'Engine.Texture2D')).SizeX));
		iconOffset = int(((float(-1) / (float(iconHeight) / originalIconHeight)) * float(iconHeight)) * 0.2500000);
		convertedString = ((((((((Mid(inputString, 0, iconStartIndex) $ "<img src='img://") $ iconPath) $ "' width='") $ string(iconWidth)) $ "' height='") $ string(iconHeight)) $ "' hspace='0' vspace='") $ string(iconOffset)) $ "'/>";
		returnArray[0] = convertedString;
		returnArray[1] = Mid(inputString, iconEndIndex + 1);
	}
	return returnArray;
	//return ReturnValue;	
}

final function HackSetTextWithIcon(string Text, optional TranslationContext InContext)
{
	local string convertedString, remainingString;
	local array<string> returnedStrings;

	convertedString = "";
	remainingString = Text;
	J0x20:

	// End:0xC7 [Loop If]
	if(true)
	{
		returnedStrings = HackConvertTextToIcons(remainingString);
		// End:0x76
		if(returnedStrings[0] != "")
		{			
			convertedString $= returnedStrings[0];			
		}
		else
		{			
			convertedString $= remainingString;
			// [Explicit Break]
			goto J0xC7;
		}
		// End:0xC1
		if(returnedStrings[1] != "")
		{
			remainingString = returnedStrings[1];			
		}
		else
		{
			// [Explicit Break]
			goto J0xC7;
		}
		// [Loop Continue]
		goto J0x20;
	}
	J0xC7:

	SetBool("html", true);
	SetString("htmlText", convertedString);
	//return;	
}

final function array<string> HackConvertTextToIcons(string inputString)
{
	local array<string> returnArray;
	local int iconStartIndex, iconEndIndex;
	local string iconPath, convertedString;

	returnArray.AddItem("");
	returnArray.AddItem("");
	iconStartIndex = InStr(inputString, "[");
	// End:0x1F2
	if(iconStartIndex >= 0)
	{
		iconEndIndex = InStr(inputString, "]");
		iconPath = Mid(inputString, iconStartIndex + 1, (iconEndIndex - iconStartIndex) - 1);
		// End:0x146
		if(iconPath == "MainHUD.InlineInputIcons.inputIcon_lb")
		{
			convertedString = ((Mid(inputString, 0, iconStartIndex) $ "<img src='img://") $ iconPath) $ "' width='42' height='21' hspace='0' vspace='-7'/>";			
		}
		else
		{
			convertedString = ((Mid(inputString, 0, iconStartIndex) $ "<img src='img://") $ iconPath) $ "' width='21' height='21' hspace='0' vspace='-7'/>";
		}
		returnArray[0] = convertedString;
		returnArray[1] = Mid(inputString, iconEndIndex + 1);
	}
	return returnArray;
	//return ReturnValue;	
}

// Export UGFxObject::execGetElement(FFrame&, void* const)
native final function ASValue GetElement(int Index);

// Export UGFxObject::execGetElementObject(FFrame&, void* const)
native final function GFxObject GetElementObject(int Index, optional Class<GFxObject> Type = Class'GFxUI.GFxObject');

// Export UGFxObject::execGetElementBool(FFrame&, void* const)
native final function bool GetElementBool(int Index);

// Export UGFxObject::execGetElementFloat(FFrame&, void* const)
native final function float GetElementFloat(int Index);

// Export UGFxObject::execGetElementInt(FFrame&, void* const)
native final function int GetElementInt(int Index);

// Export UGFxObject::execGetElementString(FFrame&, void* const)
native final function string GetElementString(int Index);

// Export UGFxObject::execSetElement(FFrame&, void* const)
native final function SetElement(int Index, ASValue Arg);

// Export UGFxObject::execSetElementObject(FFrame&, void* const)
native final function SetElementObject(int Index, GFxObject val);

// Export UGFxObject::execSetElementBool(FFrame&, void* const)
native final function SetElementBool(int Index, bool B);

// Export UGFxObject::execSetElementFloat(FFrame&, void* const)
native final function SetElementFloat(int Index, float F);

// Export UGFxObject::execSetElementInt(FFrame&, void* const)
native final function SetElementInt(int Index, int I);

// Export UGFxObject::execSetElementString(FFrame&, void* const)
native final function SetElementString(int Index, string S);

// Export UGFxObject::execGetElementDisplayInfo(FFrame&, void* const)
native final function ASDisplayInfo GetElementDisplayInfo(int Index);

// Export UGFxObject::execGetElementDisplayMatrix(FFrame&, void* const)
native final function Matrix GetElementDisplayMatrix(int Index);

// Export UGFxObject::execSetElementDisplayInfo(FFrame&, void* const)
native final function SetElementDisplayInfo(int Index, ASDisplayInfo D);

// Export UGFxObject::execSetElementDisplayMatrix(FFrame&, void* const)
native final function SetElementDisplayMatrix(int Index, Matrix M);

// Export UGFxObject::execSetElementVisible(FFrame&, void* const)
native final function SetElementVisible(int Index, bool Visible);

// Export UGFxObject::execSetElementPosition(FFrame&, void* const)
native final function SetElementPosition(int Index, float X, float Y);

// Export UGFxObject::execSetElementColorTransform(FFrame&, void* const)
native final function SetElementColorTransform(int Index, ASColorTransform cxform);

// Export UGFxObject::execGetElementMember(FFrame&, void* const)
native final function ASValue GetElementMember(int Index, string Member);

// Export UGFxObject::execGetElementMemberObject(FFrame&, void* const)
native final function GFxObject GetElementMemberObject(int Index, string Member, optional Class<GFxObject> Type = Class'GFxUI.GFxObject');

// Export UGFxObject::execGetElementMemberBool(FFrame&, void* const)
native final function bool GetElementMemberBool(int Index, string Member);

// Export UGFxObject::execGetElementMemberFloat(FFrame&, void* const)
native final function float GetElementMemberFloat(int Index, string Member);

// Export UGFxObject::execGetElementMemberInt(FFrame&, void* const)
native final function int GetElementMemberInt(int Index, string Member);

// Export UGFxObject::execGetElementMemberString(FFrame&, void* const)
native final function string GetElementMemberString(int Index, string Member);

// Export UGFxObject::execSetElementMember(FFrame&, void* const)
native final function SetElementMember(int Index, string Member, ASValue Arg);

// Export UGFxObject::execSetElementMemberObject(FFrame&, void* const)
native final function SetElementMemberObject(int Index, string Member, GFxObject val);

// Export UGFxObject::execSetElementMemberBool(FFrame&, void* const)
native final function SetElementMemberBool(int Index, string Member, bool B);

// Export UGFxObject::execSetElementMemberFloat(FFrame&, void* const)
native final function SetElementMemberFloat(int Index, string Member, float F);

// Export UGFxObject::execSetElementMemberInt(FFrame&, void* const)
native final function SetElementMemberInt(int Index, string Member, int I);

// Export UGFxObject::execSetElementMemberString(FFrame&, void* const)
native final function SetElementMemberString(int Index, string Member, string S);

// Export UGFxObject::execActionScriptSetFunction(FFrame&, void* const)
protected native final function ActionScriptSetFunction(string Member);

// Export UGFxObject::execActionScriptSetFunctionOn(FFrame&, void* const)
protected native final function ActionScriptSetFunctionOn(GFxObject Target, string Member);

// Export UGFxObject::execInvoke(FFrame&, void* const)
native final function ASValue Invoke(string Member, array<ASValue> args);

// Export UGFxObject::execActionScriptVoid(FFrame&, void* const)
native final function ActionScriptVoid(string method);

// Export UGFxObject::execActionScriptInt(FFrame&, void* const)
native final function int ActionScriptInt(string method);

// Export UGFxObject::execActionScriptFloat(FFrame&, void* const)
native final function float ActionScriptFloat(string method);

// Export UGFxObject::execActionScriptString(FFrame&, void* const)
native final function string ActionScriptString(string method);

// Export UGFxObject::execActionScriptObject(FFrame&, void* const)
native final function GFxObject ActionScriptObject(string Path);

// Export UGFxObject::execActionScriptArray(FFrame&, void* const)
native final function array<GFxObject> ActionScriptArray(string Path);

// Export UGFxObject::execGotoAndPlay(FFrame&, void* const)
native final function GotoAndPlay(string frame);

// Export UGFxObject::execGotoAndPlayI(FFrame&, void* const)
native final function GotoAndPlayI(int frame);

// Export UGFxObject::execGotoAndStop(FFrame&, void* const)
native final function GotoAndStop(string frame);

// Export UGFxObject::execGotoAndStopI(FFrame&, void* const)
native final function GotoAndStopI(int frame);

// Export UGFxObject::execCreateEmptyMovieClip(FFrame&, void* const)
native final function GFxObject CreateEmptyMovieClip(string instancename, optional int Depth = -1, optional Class<GFxObject> Type = Class'GFxUI.GFxObject');

// Export UGFxObject::execAttachMovie(FFrame&, void* const)
native final function GFxObject AttachMovie(string symbolname, string instancename, optional int Depth = -1, optional Class<GFxObject> Type = Class'GFxUI.GFxObject');

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	//return ReturnValue;	
}

event bool WidgetUnloaded(name WidgetName, name WidgetPath, GFxObject Widget)
{
	//return ReturnValue;	
}
