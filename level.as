clearContainer();

switch (scene_number)
{
	case 1:
		include "mid_map.as";
		include "bg_map.as";
		break;
	case 2 :
		include "mid_map2.as";
		include "bg_map.as";
		break;
	default :
 		break;
}

setupLevel(bg_map,mid_map);