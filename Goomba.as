package{
import flash.display.MovieClip;
import flash.events.*;
import flash.net.URLRequest;
import flash.display.Loader;

public class Goomba extends DumbEnemy
{
	var goomba_loader:Loader;
	public function Goomba() 
	{
		loader = anim;
	}
	public override function loadImage(a_bmp)
	{	
		//do nothing (overriding default tile loadImage function);
	}
}
}