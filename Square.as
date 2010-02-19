package{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.*;
import flash.net.URLRequest;
import flash.display.Loader;

public class Square extends MovieClip
{
	var loader:Loader;
	var number:Number;
	var myUrl:String;
	public function Square()
	{
	}
	
	public function loadImage(url:String)
	{
		try {
 			this.removeChild(loader);	
		} catch (error:Error) {
		     // statements
		}
		
		if (url!=null)
		{
			loader = new Loader();
			loader.load(new  URLRequest(url));
			myUrl = url;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		}
	}
	
	public function setNumber(a_number)
	{
		number = a_number;
	}
	
	public function getLoader():Loader
	{
		return loader;
	}

	public function getNumber():Number
	{
		return number;
	}

	public function getUrl():String
	{
		return myUrl;
	}
	
	
	////////////////////////////////////////
	// RESIZING THE HIT AREA
	////////////////////////////////////////
	public function setWidth(a_width)
	{
		this.width = a_width;
	}

	public function setHeight(a_height)
	{
		this.height = a_height;
	}
	
	////////////////////////////////////////
	// HELPER FUNCTION
	////////////////////////////////////////
	public function onLoadComplete(event:Event):void
	{
		this.addChild(loader);
		setChildIndex(hit,2);
		setChildIndex(loader,1);
		loader.x=0;
		loader.y=0;
	}
}
}