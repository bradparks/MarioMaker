package{
import flash.display.MovieClip;
import flash.events.*;

public class DumbEnemy extends Tile
{
	var direction:String;
	public function DumbEnemy() 
	{	
		direction = "LEFT";
		this.addEventListener(Event.ENTER_FRAME,enterframe,false,0,true);
		this.destroyable = true;
		destroy_type = "scaleY";
		points = 1;
		damage = 1;
		mobile = true;
	}

	public function enterframe(e:Event):Boolean
	{

		if(this.x+parent.x < -20 || this.x+parent.x > parent_scene.scene_width + 20)
		{
			return false;
		}
		if (direction=="LEFT"){
			if (parent_scene.canMoveLeft(this) && parent_scene.wontFallLeft(this))
			{
				moveLeft();	
			}else
			{
			//	this.loader.scaleX = -1;
			//	this.loader.x = this.width;
				direction = "RIGHT";
			}
		}

		if (direction=="RIGHT"){
			if (parent_scene.canMoveRight(this) && parent_scene.wontFallRight(this))
			{
				moveRight();	
			}else
			{
			//	this.loader.scaleX = 1;
			//	this.loader.x = 0;
				direction = "LEFT";
			}
		}
		
		// HITTEST WITH CHAR
		if (this.hitTestObject(char))
		{
			trace("hit!");
			if (char.falling==true)
			{
				this.destroy();			
				this.removeEventListener(Event.ENTER_FRAME,enterframe);	
			}else
			{
				this.removeEventListener(Event.ENTER_FRAME,enterframe);	
				parent_scene.previousScene();
			}
		}
		return true;
	}
	
	////////////////////////////////////////
	// MOVING
	////////////////////////////////////////
	public function moveLeft()
	{
		this.x-=2;
	}
	
	public function moveRight()
	{
		this.x+=2;
	}
	
}
}