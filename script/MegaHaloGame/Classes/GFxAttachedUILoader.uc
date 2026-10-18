class GFxAttachedUILoader extends GFxObject within GFxMoviePlayer;

var bool bInitialized;
var string ImagePath;

function SetImage(string ImgPath)
{
	// End:0x58
	if(bInitialized!)
	{
		SetString("_source", "img://" $ ImgPath);
		ImagePath = ImgPath;
		bInitialized = true;		
	}
	else
	{
		// End:0xB1
		if((ImgPath != "") && ImgPath != ImagePath)
		{
			LoadImage("img://" $ ImgPath);
			ImagePath = ImgPath;
		}
	}
	//return;	
}

function LoadImage(string ImgPath)
{
	ActionScriptVoid("load");
	//return;	
}
