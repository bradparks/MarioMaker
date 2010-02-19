package{
import flash.display.MovieClip;
import flash.events.*;

public class CoinBlock extends Tile
{
	public function CoinBlock() 
	{	
		this.destroyable = true;
		destroy_type = "death";
		points = 1;
	}
}
}