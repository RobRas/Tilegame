import starling.core.Starling;
import starling.display.*;
import starling.events.*;
import starling.text.TextField;
import flash.events.TimerEvent;
import flash.utils.Timer;
import Tilemap;
import GameObstacles;


enum GRIDTYPE
{
	EMPTY;
	PLAYER;
	WALL;
	SCORE;
	DANCER;
}

class Game extends Sprite
{
	public static inline var GRID_SIZE = 32;
	private var grid : Array<Array<GRIDTYPE>>;
	private var sticks : Array<Glowstick>;
	private var dancers : Array<Dancer>;
	private var size : UInt;
	private var scoreText : ScoreText;
	public var wallcount : UInt = 1;

	public function new(gridNum : UInt)
	{
		super();

		size = GRID_SIZE*gridNum;
		addChild(new Tilemap(gridNum));

		grid = new Array();
		for(i in 0...gridNum)
		{
			grid[i] = new Array();
			for(j in 0...gridNum)
			{
				grid[i].push(EMPTY);
			}
		}

		sticks = new Array();
		addGlowsticks();
		dancers = new Array();
		addDancers();
		addPlayer(cast(gridNum/2,UInt), cast(gridNum/2,UInt));
	}

	public function updateScore(sc : UInt)
	{	scoreText.setText(Std.string(sc));}


	private function addPlayer(gridX : UInt, gridY : UInt)
	{
		var p = new Player(this, gridX, gridY);
		addChild(p);

		scoreText = new ScoreText();
		scoreText.x = Starling.current.stage.stageWidth - scoreText.width;
		scoreText.y = scoreText.height;

		//check every frame to ensure the grid is positioned correctly
		//only if the grid so big that it can't fit on screen
		if(size/Game.GRID_SIZE > 20)
		{
			addEventListener(Event.ENTER_FRAME, function(e:EnterFrameEvent)
			{
				//center positions of player
				var centerX = p.x + Game.GRID_SIZE/2;
				var centerY = p.y + Game.GRID_SIZE/2;

				//new grid position
				x = -(centerX - Starling.current.stage.stageWidth/2);
				y = -(centerY - Starling.current.stage.stageHeight/2);

				//bound grid
				if(x > 0) x = 0;
				else if(x < -(size - Starling.current.stage.stageWidth))
					x = -(size - Starling.current.stage.stageWidth);

				if(y > 0) y = 0;
				else if(y < -(size - Starling.current.stage.stageHeight))
					y = -(size - Starling.current.stage.stageHeight);
			});
		}
	}

	public function addScore(ob:Sprite)
	{	ob.addChild(scoreText);}

	public function getTileType(gridX : UInt, gridY : UInt)
	{	return grid[gridX][gridY];}

	public function createWall(gridX : UInt, gridY : UInt, col : UInt)
	{
		grid[gridX][gridY] = WALL;
		addChild(new Wall(gridX, gridY, col));
	}

	private function addGlowsticks()
	{
		var gridNum : Int = Std.int(size/Game.GRID_SIZE);
		while(sticks.length < (gridNum * gridNum)/ 30)
		{
			var nx = Std.random(gridNum);
			var ny = Std.random(gridNum);
			while(getTileType(nx,ny) != EMPTY)
			{
				nx = Std.random(gridNum);
				ny = Std.random(gridNum);
			}
			createGlowstick(nx,ny);
		}
	}

	private function createGlowstick(gridX : UInt, gridY : UInt)
	{
		grid[gridX][gridY] = SCORE;
		var stick = new Glowstick(gridX, gridY);
		sticks.push(stick);
		addChild(stick);
	}

	private function addDancers(){
		var gridNum : Int = Std.int(size/Game.GRID_SIZE);
		while(dancers.length < gridNum )
		{
			var nx = Std.random(gridNum);
			var ny = Std.random(gridNum);
			while(getTileType(nx,ny) != EMPTY)
			{
				nx = Std.random(gridNum);
				ny = Std.random(gridNum);
			}
			createDancer(nx,ny);
		}
	}

	private function createDancer(gridX : UInt, gridY : UInt){
		grid[gridX][gridY] = DANCER;
		var d = new Dancer(Std.random(3),Std.random(20) + 1);
		d.x = gridX * Game.GRID_SIZE;
		d.y = gridY * Game.GRID_SIZE;
		dancers.push(d);
		addChild(d);
	}

	public function removeWall(wall : Wall)
	{
		grid[wall.getX()][wall.getY()] = EMPTY;
		removeChild(wall);
	}

	public function removeGlowstick(nx : UInt, ny : UInt) : UInt
	{
		grid[nx][ny] = EMPTY;
		for(s in sticks)
		{
			if(s.getX() == nx && s.getY() == ny)
			{
				sticks.remove(s);
				removeChild(s);
				addGlowsticks();
				return s.getColor();
			}
		}
		return 0xffffff;
	}

	public function getSize() : UInt
	{	return size;}

	public function validPos(gridX : Int, gridY : Int) : Bool
	{
		return gridX >= 0 && gridX <= grid.length - 1 &&
				gridY >= 0 && gridY <= grid[0].length - 1;
	}

	public function reset()
	{	cast(parent, Menu).reset();}
}


class Tilemap extends Sprite
{
	public function new(num : UInt)
	{
		super();
		for(i in 0...num)
		{
			for(j in 0...num)
			{
				var im = new Image(Root.assets.getTexture("tile" + (Std.random(13)+1)));
				im.x = i * Game.GRID_SIZE; im.y = j * Game.GRID_SIZE;
				addChild(im);
			}
		}
		addEventListener(Event.ADDED, flatten);
	}
}

