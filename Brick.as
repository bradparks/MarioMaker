package{
import flash.display.MovieClip;
import flash.events.*;

public class Brick extends Tile
{
	public function Brick() 
	{	
		this.destroyable = true;
		destroy_type = "death";
	}
}
}