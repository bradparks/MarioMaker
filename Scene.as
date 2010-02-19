package{
import flash.display.MovieClip;
import flash.display.Stage;
import flash.display.Bitmap;
import flash.events.*;
import flash.net.URLRequest;
import flash.display.Loader;
import Caption;
import Tile;
import TLAS3.gs.*;
public class Scene extends MovieClip
{
	static var tile_images:Array = new Array();
	var loader:Loader;
	var scene_caption:Caption;
	var space_dismiss:Boolean; // if this is set to true, when space is pressed we go to the next scene.
	var mainstage;
	
	var _keys:Array;
	
	var scroll_speed:Number;
	var scene_width:Number;
	var scene_height:Number;
	var tile_size:Number;
	var is_interactive:Boolean;
	var is_x_scrollable:Boolean;
	var is_y_scrollable:Boolean;
	
	var tiles_array:Array;
	var char:MovieClip;
	
	
	var SPACE;Number;
	////////////////////////////////////////
	// CONSTRUCTOR
	////////////////////////////////////////
	public function Scene() 
	{
		//DEFAULTS
		scroll_speed = 4;
		scene_width = 500;
		scene_height = 300;
		tile_size = 16;
		is_interactive:true;
		is_x_scrollable:true;
		is_y_scrollable:false;	
		space_dismiss = false;
		_keys = new Array();
		
/*
		mc_mask.width = scene_width;
		mc_mask.height = scene_height;	
		this.mask = mc_mask;
*/
		tiles_array = new Array();
		this.addEventListener(MouseEvent.CLICK, mouseClick);
		SPACE = 32;
	}
		
	public function knowStage(a_stage)
	{
		mainstage = a_stage;
		mainstage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
		mainstage.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
	}	
	
	////////////////////////////////////////
	// SCENE SIZE
	////////////////////////////////////////
	public function setWidth(a_width)
	{
		scene_width = a_width;
/*
		mask.width = scene_width;
		this.mask = mc_mask;
*/
	}
	
	public function setHeight(a_height)
	{
		scene_height = a_height;
/*
		mask.height = scene_height;
		this.mask = mc_mask;
*/
	}

	public function getWidth():Number
	{
		return scene_width;
	}
	
	public function getHeight():Number
	{
		return scene_height;
	}

	
	////////////////////////////////////////
	// SCROLL SPEED
	////////////////////////////////////////
	
	public function setScrollSpeed(a_speed)
	{
		scroll_speed = a_speed;
	}

	public function getScrollSpeed()
	{
		return scroll_speed;
	}

	
	/////////////////////////////////////////////////////////////////////
	// ADD A NEW TILE (image url, type of tile, x position, y position)
	/////////////////////////////////////////////////////////////////////
	
	public function previousScene()
	{
		char.removeEvents();
		TweenLite.to(char,1,{y:20,onComplete:previousSceneComplete});
		char.info.addDamage(1);
	}

	public function previousSceneComplete()
	{
		if (char.info.getLives()>=1)
		{
			try {
   			MovieClip(parent.parent).prevFrame();
			} catch (error:Error) {
			     // statements
			}

		}else
		{
			try {
				MovieClip(parent.parent).gotoAndStop("restart");						     
			} catch (error:Error) {
			     // statements
			}
		}
	}
		
	public function newTile(tile_num,tile_type,x_num,y_num)
	{
		var x_pos = x_num * tile_size;
		var y_pos = y_num * tile_size;
		
		if (tile_type=="goomba")
		{
			var tile = new Goomba();
			tile_type = "dumb_enemy";
		}else if (tile_type=="dumb_enemy")
		{
			var tile = new DumbEnemy();
		}else if (tile_type=="brick")
		{
			var tile = new Brick();
			tile_type = "wall";
		}else if (tile_type=="coin_block")
		{
			var tile = new CoinBlock();
			tile_type = "wall";
		}	
		else
		{
			var tile = new Tile();
		}
		tile.setParentScene(this);
		tile.knowChar(char);
		addChild(tile);
		tile.x = x_pos;
		tile.y = y_pos;

		if (tile_num>0)
		{
			var bitmap = new Bitmap(tile_images[tile_num].content.bitmapData.clone());
			tile.loadImage(bitmap);
		}
		tile.setType(tile_type);
		
		if (tile_type=="coin")
		{
			tile.setPoints(1);
		}
	
		if (tiles_array[x_num] == null)
		{
			tiles_array[x_num] = new Array();
		}
		tiles_array[x_num][y_num] = tile;
	}

	////////////////////////////////////////
	// CHARACTER FUNCTIONS
	////////////////////////////////////////
	
	// CREATE A REFERENCE TO THE CHARACTER
	public function knowChar(a_char)
	{
		char = a_char;
	}

	public function canMoveDown(mc)
	{
		var tile_x = Math.floor((mc.x - this.x + (mc.width/2))/tile_size);
		var tile_y = Math.floor((mc.y + (mc.height))/tile_size);
		tile_type = "wall";
		try {
		  var tile_type = tiles_array[tile_x][tile_y].getType();
		} catch (error:Error) {
			previousScene();
		}
		if (tile_type=="wall")
		{
			return false;
		}else{
			return true;
		}		
	}

	public function currentTile(mc):Tile
	{
		var tile_x = Math.floor((mc.x - this.x + (mc.width/2))/tile_size);
		var tile_y = Math.floor((mc.y + (mc.height/2))/tile_size);
	  return tiles_array[tile_x][tile_y];
	}

	public function canMoveUp(mc)
	{
		var tile_x = Math.floor((mc.x - this.x + (mc.width/2))/tile_size);
		var tile_y = Math.floor((mc.y)/tile_size);
		tile_type = "wall";
		try {
		  var tile_type = tiles_array[tile_x][tile_y].getType();
		} catch (error:Error) {
		}
		if (tile_type=="wall" && tiles_array[tile_x][tile_y].isDestroyable()==false)
		{
			return false;
		}else{
			return true;
		}		
	}

	public function canMoveLeft(mc)
	{
		var tile_x = Math.floor((mc.x - this.x + mc.parent.x)/tile_size);
		var tile_y = Math.floor((mc.y)/tile_size);
		tile_type = "wall";
		try {
		  var tile_type = tiles_array[tile_x][tile_y].getType();
		} catch (error:Error) {
		}
		if (tile_type=="wall")
		{
			return false;
		}else{
			return true;
		}		
	}

	public function canMoveRight(mc)
	{
		var tile_x = Math.floor((mc.x - this.x + mc.width + mc.parent.x)/tile_size);
		var tile_y = Math.floor((mc.y)/tile_size);
		tile_type = "wall";
		try {
		  var tile_type = tiles_array[tile_x][tile_y].getType();
		} catch (error:Error) {
		}
		if (tile_type=="wall")
		{
			return false;
		}else{
			return true;
		}		
	}
	

	////////////////////////////////////////
	// MORE MOVE FUNCTIONS
	////////////////////////////////////////
	
	public function wontFallLeft(mc)
	{
		var tile_x = Math.floor((mc.x - this.x + mc.parent.x)/tile_size);
		var tile_y = Math.floor((mc.y + (mc.height)+10)/tile_size);
		tile_type = "wall";
		try {
		  var tile_type = tiles_array[tile_x][tile_y].getType();
		} catch (error:Error) {
		}
		if (tile_type=="wall")
		{
			return true;
		}else{
			return false;
		}		
	}

	public function wontFallRight(mc)
	{
		var tile_x = Math.floor((mc.x - this.x + mc.width + mc.parent.x)/tile_size);
		var tile_y = Math.floor((mc.y + (mc.height))/tile_size);
		tile_type = "wall";
		try {
		  var tile_type = tiles_array[tile_x][tile_y].getType();
		} catch (error:Error) {
		}
		if (tile_type=="wall")
		{
			return true;
		}else{
			return false;
		}		
	}


	////////////////////////////////////////
	// IMAGE LOADING
	////////////////////////////////////////
	
	public function loadImage(url:String)
	{
		try {
		     	loader = new Loader();
		loader.load(new  URLRequest(url));
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		} catch (error:Error) {
		     trace("g image not loaded.");
		}
	}
	
	public function onLoadComplete(event:Event):void
	{
		this.addChild(loader);
		loader.x=0;
		loader.y=0;
	}
	
	public static function cacheTiles(tiles:Array)
	{
		var count = 1;
		for each (var tile_image in tiles)
		{
			tile_images[count] = new Loader();
			tile_images[count].load(new URLRequest(tile_image));
			count++;
		}
	}
		
	////////////////////////////////////////
	// CAPTION
	////////////////////////////////////////
	public function makeCaption()
	{
		if (scene_caption==null)
		{
			scene_caption = new Caption();
			this.addChild(scene_caption);
			scene_caption.x = 0;
			scene_caption.y = 0;
			scene_caption.knowStage(mainstage);
		}
	}
	public function setCaption(a_caption)
	{		
		makeCaption();
		scene_caption.setCaption(a_caption);
	}

	public function setBackgroundColor(a_color)
	{		
		makeCaption();
		scene_caption.setBackgroundColor(a_color);
	}

	public function setCaptionColor(a_color)
	{		
		makeCaption();
		scene_caption.setCaptionColor(a_color);
	}
	
	////////////////////////////////////////
	// FUNCTIONALITY FOR LOADING NEXT SCENE
	////////////////////////////////////////
	
	// IF dismiss IS SET TO TRUE, THEN AS SOON AS SPACE IS PRESSED,
	// WE'LL MOVE TO THE NEXT SCENE, SPECIFIED IN scenes_array.
	public function spaceToDismiss(dis)
	{
		space_dismiss = dis;
	}
	
	public function loadNextScene()
	{
		if (tile_images.length>0)
		{
			MovieClip(parent.parent).nextFrame();
		}
	}	
	
	public function loadLevelClear()
	{
			MovieClip(parent.parent).gotoAndStop("frameLevelClear");	
	}


	public function mouseClick(e:MouseEvent)
	{
		if (space_dismiss==true)
		{
			loadNextScene();
			space_dismiss = false;
		}
	}
	////////////////////////////////////////
	// KEYBOARD HELPERS
	////////////////////////////////////////
	
	function handleKeyDown(evt:KeyboardEvent):void
	{
    if (_keys.indexOf(evt.keyCode) == -1)
    {
        _keys.push(evt.keyCode);
    }
		
		if (space_dismiss==true)
		{
			loadNextScene();
			space_dismiss = false;
		}
	}
	
	function handleKeyUp(evt:KeyboardEvent):void
	{
    var i:int = _keys.indexOf(evt.keyCode);
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