info.setLives(3);
info.setPoints(0);

var tile_images:Array = new Array();
var tile_types:Array = new Array();
var mid_map;
var bg_map;
var container;
var intro_scene;
var you_win;
var scene_number = 1;

function loadXML()
{
	
	////////////////////////////////////////
	// XML CONFIG FILE
	////////////////////////////////////////
	var xmlLoader:URLLoader = new URLLoader();
	var xmlData:XML = new XML(); 
	xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
	try {
	     xmlLoader.load(new URLRequest("config.xml"));
	} catch (error:Error) {
	     trace("xml not found.");
	}
	
	function LoadXML(e:Event):void {
		xmlData = new XML(e.target.data);
		var tiles:XMLList  = xmlData.tile;
		for each (var tile:XML in tiles) {
			var id = tile.@id;
			tile_images[id] = tile.@src;
			tile_types[id] = tile.@type;
		}
		setup();
	}
	
}

loadXML();


function setup()
{
	////////////////////////////////////////
	// LOAD AND CACHE ALL IMAGE TILES
	////////////////////////////////////////
	Scene.cacheTiles(tile_images);
	nextFrame();
}

function clearContainer()
{
	if (container!=null)
	{
		removeChild(container);
	}
	
	container = new Container();
	addChild(container);
}

function setupIntro(a_caption)
{		
	container.x = 0;
	container.y = 0;	
	////////////////////////////////////////
	// LOAD INTRO SCENE
	////////////////////////////////////////
	intro_scene = new Scene();
	container.addChild(intro_scene);
	intro_scene.x = 0;
	intro_scene.y = 0;
	intro_scene.setHeight(stage.stageHeight);
	intro_scene.setWidth(stage.stageWidth);
	intro_scene.knowStage(stage);
	intro_scene.setCaption(a_caption);
	intro_scene.spaceToDismiss(true);
	
	//focus
	stage.stageFocusRect = false;
	stage.focus=intro_scene;

}


function setupLevel(bg_map,mid_map)
{
	container.y = 20;
	container.x = 0;
	////////////////////////////////////////
	// LOAD BACKGROUND.
	////////////////////////////////////////
	
	var back_ground:Scene = new Scene();
	container.addChild(back_ground);
	back_ground.x = 0;
	back_ground.y = 0;
	back_ground.setHeight(stage.stageHeight);
	back_ground.setWidth(stage.stageWidth);
	back_ground.knowStage(stage);
	
	////////////////////////////////////////
	// LOAD MIDDLE GROUND.
	////////////////////////////////////////
	
	var middle_ground:Scene = new Scene();
	container.addChild(middle_ground);
	middle_ground.x = 0;
	middle_ground.y = 0;
	middle_ground.setHeight(stage.stageHeight);
	middle_ground.setWidth(stage.stageWidth);
	middle_ground.knowStage(stage);

	////////////////////////////////////////
	// LOAD CHARACTER	
	////////////////////////////////////////
	
	var char:Character = new Character();
	container.addChild(char);
	char.x = 20;
	char.y = 20;

	char.addScene(back_ground);	
	char.addScene(middle_ground);
	char.knowStage(stage);
	char.knowInfo(info);
	
	stage.stageFocusRect = false;
	stage.focus=char;



	//LOAD BACKGROUND TILES IN
		for (var i = 0;i < bg_map[0].length;i++)
	{
		for (var j = 0; j < bg_map.length; j++)
		{
			var tile_num = bg_map[j][i];
			var tile_type = tile_types[tile_num];
		
			back_ground.newTile(tile_num,tile_type,i,j);
		}
	}

	
	// LOAD IN MIDDLE GROUND TILES

	for (var i = 0;i < mid_map[0].length;i++)
	{
		for (var j = 0; j < mid_map.length; j++)
		{
			var tile_num:Number = mid_map[j][i];
			var tile_type = tile_types[tile_num];
			
			middle_ground.newTile(tile_num,tile_type,i,j);
		}
	}	
}


function loadLevelCleared()
{
	////////////////////////////////////////
	// LOAD YOU WIN SCENE
	////////////////////////////////////////
	you_win = new EndLevel();
	you_win.addEventListener(MouseEvent.CLICK,function(){gotoAndStop("frameIntro");});
	you_win.useHandCursor = you_win.buttonMode = true;	
	container.addChild(you_win);
	
	scene_number++;
}
stop()