package{
import flash.display.MovieClip;
import flash.events.*;
import flash.text.*;

public class Info extends MovieClip
{
	public function Info() 
	{
	}
	
	public function setLives(a_lives)
	{
		lives.text = a_lives;
	}

	public function getLives():Number
	{
		return Number(lives.text);
	}

	public function setPoints(a_points)
	{
		points.text = a_points;
	}

	public function getPoints():Number
	{
		return Number(points.text);
	}
	
	public function addPoints(num_points)
	{
		setPoints(getPoints()+num_points);
	}

	public function addDamage(num_damage)
	{
		setLives(getLives()-num_damage);
	}
	

}
}