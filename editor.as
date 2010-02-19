//CONFIGURABLE
var screen_width = 80;
var screen_height = 10;
var tile_size = 16;

// if you specify a map, that map will be initially loaded
// instead of a blank screen
var map = new Array();

// GLOBAL VARIABLES
var current_tile = 0;
var current_img;
var clicked:Boolean = false;

var LEFT = 37;
var RIGHT = 39;
var UP = 38;
var DOWN = 40;

var tiles_array:Array = new Array();
var _keys:Array = new Array();
var images_array:Array = new Array();
	 
/*---------load XML config file-------*/
var xmlLoader:URLLoader = new URLLoader();
var xmlData:XML = new XML(); 
xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
xmlLoader.load(new URLRequest("config.xml"));


function LoadXML(e:Event):void {
	xmlData = new XML(e.target.data);
	var tiles:XMLList = xmlData.tile;
	

	//create blank tile
	var square:Square = new Square();
	library.addChild(square);
	square.y = 0;
	square.x = 0;
	square.setWidth(tile_size);
	square.setHeight(tile_size);
	square.setNumber(0);
	square.addEventListener(MouseEvent.CLICK,setGlobals);

	var count = 1;
	for each (var tile:XML in tiles)
	{
		var square:Square = new Square();

		images_array[tile.@id] = tile.@src;
		square.loadImage(tile.@src);
		if (count==0)
		{
			current_img = tile.@src;
		}
		library.addChild(square);
		square.y = 0;
		square.x = count * tile_size;
		square.setWidth(tile_size);
		square.setHeight(tile_size);
		square.setNumber(tile.@id);
		square.addEventListener(MouseEvent.CLICK,setGlobals);
		count++;
	}	
	start();
}
/*------------------------------------*/



function start()
{
	if (map.length!=0)
	{
		//screen_width = map[0].length;
		//screen_height = map.length;
	}

	for (var i=0;i<screen_height;i++)
	{
		tiles_array[i] = new Array();	
		for (var j=0;j<screen_width;j++)
		{
			var square:Square = new Square();
			container.addChild(square);
			square.x = (tile_size-1)*j;
			square.y = (tile_size-1)*i;
			square.setWidth(tile_size);
			square.setHeight(tile_size);
			square.addEventListener(MouseEvent.MOUSE_OVER, setImage);
			square.addEventListener(MouseEvent.CLICK, setImage2);
			tiles_array[i][j] = square;
			
			if (i <map.length && j <map[0].length)
			{
				var map_num = map[i][j];
				square.setNumber(map_num);	
				square.loadImage(images_array[map_num]);
			}else{
			square.setNumber(0);
		//	square.loadImage(current_img);
			}
		}
	}
}

function setImage(e:MouseEvent)
{
	if (clicked==true)
	{
 		e.target.parent.loadImage(current_img);
		e.target.parent.setNumber(current_tile);
	}
}

function setImage2(e:MouseEvent)
{
	e.target.parent.loadImage(current_img);
	e.target.parent.setNumber(current_tile);
}


function setLoaderImage(e:MouseEvent)
{
	if (clicked==true)
	{
		trace(e.target.parent);
		//e.target.parent.loadImage(current_img);
		//e.target.parent.setNumber(current_tile);
	}
}


function setGlobals(e:MouseEvent)
{
	current_tile = e.target.parent.getNumber();
	current_img = e.target.parent.getUrl();
}

stage.addEventListener(MouseEvent.MOUSE_DOWN,function(){clicked = true;});
stage.addEventListener(MouseEvent.MOUSE_UP,function(){clicked = false;});




stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
stage.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
stage.addEventListener(Event.ENTER_FRAME,function(){enterframe();});		


function enterframe()
{
	if (isKeyPressed(LEFT))
	{
		if (container.x<50)
		{
			container.x += tile_size;
		}
	}

	if (isKeyPressed(RIGHT))
	{
		if ((container.x + container.width)>750)
		{
		container.x -= tile_size;
		}
	}
	
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

    if (i > -1)
    {
        _keys.splice(i, 1);
    }
}

function isKeyPressed(key:int):Boolean
{
    return (_keys.indexOf(key) > -1);
}

generate.addEventListener(MouseEvent.CLICK,function(){generateMap();});

var output:String = "";

function generateMap()
{
	output+="var map = [";
	for (var i=0;i<screen_height;i++)
	{
		output+="[";
		for (var j=0;j<screen_width;j++)
		{
			output+=tiles_array[i][j].getNumber();
			
			if (j<screen_width-1)
			{
				output+=",";
			}
		}	
		output+="],\n";
	}
	output+="];";
	
	trace(output);
}