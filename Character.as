package{
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.*;
import flash.ui.Keyboard;
import Info;

public class Character extends MovieClip
{
	var scenes_array:Array;
	var mainstage:Stage;
	var info:Info; // reference to info box
	
	var _keys:Array;
	var LEFT:Number;
	var RIGHT:Number;
	var UP:Number;
	var DOWN:Number;
	
	// variables for jumping
	var jumping:Boolean;
	var falling:Boolean;
	var jump_count:Number;
	var accel:Number;
	
	static var accel_speed = 4;
	static var speed = 4;
	////////////////////////////////////////
	// CONSTRUCTOR
	////////////////////////////////////////
	public function Character() 
	{
		scenes_array = new Array();
		_keys = new Array();
		jumping = false;
		falling = false;
		jump_count = 0;
		accel = accel_speed;
		LEFT = 37;
		RIGHT = 39;
		UP = 38;
		DOWN = 40;

		this.addEventListener(Event.ENTER_FRAME,enterframe,false,0,true);		
	}
		
	public function enterframe(e:Event)
	{
	
		checkCurrentTile();
		//////////////////////////
		// KEY PRESSES
		//////////////////////////
/*
		if (isKeyPressed(DOWN))
		{
			moveDown();
		}
*/
		if (isKeyPressed(UP))
		{
			moveUp();
		}

		if (isKeyPressed(LEFT))
		{
			moveLeft();
		}else if (isKeyPressed(RIGHT))
		{
			moveRight();
		}

		if(canMoveDown() && !jumping)
		{
			falling = true;
		}else{
			falling = false;
			accel = accel_speed;
		}
		
		if (jumping && !falling)
		{
			jump();	
		}

		if (falling)
		{
			fall();	
		}

	}
	
	public function moveDown()
	{		
		if (canMoveDown())
		{
			this.y+=speed;
		}	
	}

	public function moveUp()
	{		
		if (canMoveUp() && !jumping && !falling)
		{
			jumping = true;
			body.gotoAndStop(3);
		}	
	}

	public function moveLeft()
	{		
		if (canMoveLeft())
		{
			body.scaleX=-1;
			body.gotoAndStop(2);
			if (scenes_array[0].x==0 || this.x > mainstage.stageWidth/2)
			{
				this.x-=speed;
			}else
			{
				scrollLeft();
			}
		}	
	}

	public function moveRight()
	{		
		if (canMoveRight())
		{
			body.scaleX=1;
			body.gotoAndStop(2);
			if (this.x < (scenes_array[0].getWidth()/2))
			{
				this.x+=speed;
			}else
			{
				scrollRight();
			}
		}	
	}


	////////////////////////////////////////
	// HELPER FUNCTIONS FOR MOVING
	////////////////////////////////////////
	
	public function fall()
	{
		this.y+=accel;
		accel+=.2;
	}
	
	public function jump()
	{
		this.y-=accel;
		jump_count++;
		accel+=.2;
		if (jump_count > 10 || !canMoveUp())
		{
			jumping = false;
			jump_count = 0;
			accel = accel_speed;
			falling = true;
		}
	}
	
	
	
	////////////////////////////////////////
	// SCROLLING
	////////////////////////////////////////
	
	public function scrollLeft()
	{
		for each(var scene in scenes_array)
		{
			scene.x+=scene.getScrollSpeed();
/* 			scene.mask.x-=scene.getScrollSpeed(); */
		}
	}

	public function scrollRight()
	{
		for each(var scene in scenes_array)
		{
			if (scene.x+scene.width > mainstage.stageWidth){
				scene.x-=scene.getScrollSpeed();
/* 				scene.mask.x+=scene.getScrollSpeed(); */
			}else
			{
				this.x+=speed;
			}
		}
	}

	
	
	
	
	
	
		
	// PASS A REFERENCE TO THE MAIN STAGE.
	public function knowStage(a_stage)
	{
		mainstage = a_stage;
		mainstage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
		mainstage.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
	}
	
	// MAKE A REFERENCE TO THE GAME INFO BOX.
	public function knowInfo(a_info)
	{
		info = a_info;
	}

	public function addScene(a_scene)
	{
		scenes_array.push(a_scene);
		a_scene.knowChar(this);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	////////////////////////////////////////
	// HELPER FUNCTIONS
	////////////////////////////////////////
	
	// THIS IS USED TO SEE WHAT THE CURRENT TILE WE'RE ON IS.
	public function checkCurrentTile()
	{
		for each(var scene in scenes_array)
		{
			var cur_tile = scene.currentTile(this);
			
			if (cur_tile.isDestroyable() && !cur_tile.mobile)
			{
				cur_tile.destroy();
			}
			
			if (cur_tile.tile_type=="end")
			{
				removeEvents();
				scene.loadLevelClear();
				break;
			}
		}	
	}
	
	// THESE ARE USED TO CHECK IF IT'S OKAY
	// TO MOVE IN A PARTICULAR DIRECTION.
	public function canMoveDown():Boolean
	{
		for each(var scene in scenes_array)
		{
			if (!scene.canMoveDown(this))
			{
				return false;
			}
		}
		return true;
	}

	public function canMoveUp():Boolean
	{
		for each(var scene in scenes_array)
		{
			if (!scene.canMoveUp(this))
			{
				return false;
			}
		}
		return true;
	}

	public function canMoveLeft():Boolean
	{
		for each(var scene in scenes_array)
		{
			if (!scene.canMoveLeft(this))
			{
				return false;
			}
		}
		return true;
	}

	public function canMoveRight():Boolean
	{
		for each(var scene in scenes_array)
		{
			if (!scene.canMoveRight(this))
			{
				return false;
			}
		}
		return true;
	}

	
	public function removeEvents()
	{
		this.removeEventListener(Event.ENTER_FRAME,enterframe);		
	}
	
	// THESE ARE USED TO GIVE SUPPORT FOR KEYS
	function handleKeyDown(evt:KeyboardEvent):void
	{
	    if (_keys.indexOf(evt.keyCode) == -1)
	    {
	        _keys.push(evt.keyCode);
	    }
	}
	
	function handleKeyUp(evt:KeyboardEvent):void
	{
	    var i:int = _keys.indexOf(evt.keyCode);
			body.gotoAndStop(1);
	    if (i > -1)
	    {
	        _keys.splice(i, 1);
	    }
	}
	
	function isKeyPressed(key:int):Boolean
	{
	    return _keys.indexOf(key) > -1;
	}
	
}
}
