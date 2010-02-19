package{
import flash.display.MovieClip;
import flash.events.*;
import flash.display.*;
import flash.text.*;
import TLAS3.gs.*;

public class Caption extends MovieClip
{
	var mainstage:Stage;
	public function Caption() 
	{

	}
	
	public function setCaption(a_caption)
	{
		caption_text.text = a_caption;
	}

	public function getCaption():String
	{
		return caption_text.text;
	}

	public function setBackgroundColor(a_color)
	{
		TweenLite.to(bg,1,{tint:a_color});
	}

	public function setCaptionColor(a_color)
	{
		TweenLite.to(caption_text,1,{tint:a_color});
	}


	public function knowStage(a_stage)
	{
		mainstage = a_stage;
		bg.width = mainstage.stageWidth;
		bg.height = mainstage.stageHeight;
	}	

}
}