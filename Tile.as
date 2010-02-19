package{
import flash.display.MovieClip;
import flash.events.*;
import flash.display.Stage;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.text.*;
import Scene;
import TLAS3.gs.*;
public class Tile extends MovieClip
{
	var loader:MovieClip;
	var tile_type:String;
	var parent_scene:Scene;
	var mainstage:Stage;
	var char:MovieClip;
	
	var destroy_type:String;
	
	var points:Number; // determines how many points you get if you take this tile
	var damage:Number; // determines how much damage you get if you get hit by this tile.
	var destroyable:Boolean; // flag for if this tile disappears on contact
	var mobile:Boolean; // flag for whether this tile is walking around (like an enemy)
	public function Tile() 
	{
		tile_type = "background";
		destroyable = false;
		points = 0;
		damage = 0;
		loader = new MovieClip();
		mobile = false;
	}
	
	////////////////////////////////////////
	// IMAGE LOADING
	////////////////////////////////////////
	public function loadImage(a_bmp)
	{	
		this.addChild(loader);
		loader.addChild(a_bmp);
/*
		try {
    	loader = new Loader();
			loader.load(new URLRequest(a_url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		} catch (error:Error) {
	     trace(a_url + " was not found.");
		}
*/
	}
	
	public function onLoadComplete(event:Event):void
	{
		this.addChild(loader);
		loader.x=0;
		loader.y=0;
	}
	
	////////////////////////////////////////
	// TYPE FUNCTIONS
	////////////////////////////////////////
	public function setType(a_type)
	{
		tile_type = a_type;
	}
	
	public function getType():String
	{
		return tile_type;
	}
	
	////////////////////////////////////////
	// POINTS
	////////////////////////////////////////
	
	public function hasPoints():Boolean
	{
		if (points > 0)
		{
			return true;
		}else
		{
			return false;
		}
	}
	
	public function setPoints(num_points)
	{
		points = num_points;
		destroyable = true;
	}

	public function getPoints():Number
	{
		return points;
	}

	////////////////////////////////////////
	// DAMAGE
	////////////////////////////////////////
	
	public function hasDamage():Boolean
	{
		if (damage > 0)
		{
			return true;
		}else
		{
			return false;
		}
	}
	
	public function setDamage(num_damage)
	{
		damage = num_damage;
	}

	public function getDamage():Number
	{
		return damage;
	}
	
	////////////////////////////////////////
	// DESTROY FUNCTIONS
	////////////////////////////////////////
	public function isDestroyable():Boolean
	{
		return destroyable;
	}
	
	public function destroy()
	{
		if (points > 0)
		{
			animatePoints();
		}
		char.info.addPoints(points);
		this.points = 0;
		this.destroyable = false;
		this.tile_type = "background";
		this.damage = 0;		
		
		if (destroy_type=="explode")
		{
			TweenLite.to(loader,.5,{scaleX:1.3, scaleY:1.3,alpha:0,onComplete:removeLoader});		
		}else if (destroy_type=="scaleX")
		{
			TweenLite.to(loader,.5,{scaleX:0,onComplete:removeLoader});		
		}else if (destroy_type=="scaleY")
		{
			var newY = loader.y + loader.height;
			TweenLite.to(loader,.5,{scaleY:0,y:newY,onComplete:removeLoader});		
		}else if (destroy_type=="death")
		{
			removeLoader();
			this.gotoAndPlay("death");
		}
		else 		
		{
			TweenLite.to(loader,.5,{scaleX:0,onComplete:removeLoader});
		}	
	}

	public function removeLoader()
	{
		this.removeChild(loader);
	}
		
	public function animatePoints()
	{
		var pointsMC:MovieClip = new MovieClip();
		addChild(pointsMC);
		pointsMC.y = -20;
		
		var point:TextField = new TextField();
		pointsMC.addChild(point);
		var tfp:TextFormat = new TextFormat();
		tfp.color = 0xFFFFFF;
		tfp.size = 13;
		tfp.font = "Arial";
		point.text = String(this.points);
		point.setTextFormat(tfp);
		
		TweenLite.to(pointsMC,1,{alpha:0,y:-30, onComplete:removeMC});

		function removeMC(){ removeChild(pointsMC);};
	}
		
	////////////////////////////////////////
	// PARENT SCENE FUNCTIONS
	////////////////////////////////////////
	
	public function setParentScene(a_scene)
	{
		parent_scene = a_scene;	
	}
	
	public function knowChar(a_char)
	{
		char  = a_char;
	}
	
	public function knowStage(a_stage)
	{
		mainstage = a_stage;
	}
}
}