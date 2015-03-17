import starling.core.Starling;
import starling.display.*;
import starling.events.*;
import starling.text.TextField;
import flash.events.TimerEvent;
import flash.utils.Timer;

enum GRIDTYPE
{
	EMPTY;
	PLAYER;
	WALL;
	SCORE;
}

class Game extends Sprite
{
	public static inline var GRID_SIZE = 32;
	private var grid : Array<Array<GRIDTYPE>>;
	private var sticks : Array<Glowstick>;
	private var size : UInt;
	private var scoreText : TextField;

	public function new(gridNum : UInt = 40)
	{
		super();

		size = GRID_SIZE*gridNum;
		createGridLines();

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
		addPlayer(10, 10);
	}

	public function updateScore(sc : UInt)
	{	scoreText.text = Std.string(sc);}

	private function createGridLines()
	{
		//horizontal lines
		var i : UInt = 0;
		while(i <= size)
		{
			var quad = new Quad(size, 2.5, 0xffff00);
			quad.y = i; i += GRID_SIZE;
			addChild(quad);
		}

		//vertical lines
		var j : UInt = 0;
		while(j <= size)
		{
			var quad = new Quad(2.5, size, 0xffff00);
			quad.x = j; j += GRID_SIZE;
			addChild(quad);
		}
	}

	private function addPlayer(gridX : UInt, gridY : UInt) {
		var p = new Player(this, gridX, gridY);
		scoreText = new TextField(Game.GRID_SIZE*3,Game.GRID_SIZE,"0",
									Menu.bitmapFont,20,0xffffff);
		addChild(scoreText);
		addChild(p);

		//check every frame to ensure the grid is positioned correctly
		addEventListener(Event.ENTER_FRAME, function()
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

			scoreText.x = Starling.current.stage.stageWidth/2 - scoreText.width - x;
			scoreText.y = scoreText.height - y;
		});
	}

	public function getTileType(gridX : UInt, gridY : UInt)
	{	return grid[gridX][gridY];}

	public function createWall(gridX : UInt, gridY : UInt)
	{
		grid[gridX][gridY] = WALL;
		addChild(new Wall(gridX, gridY));
	}

	private function addGlowsticks()
	{
		while(sticks.length < Game.GRID_SIZE / 2)
		{
			var nx = Std.random(Game.GRID_SIZE);
			var ny = Std.random(Game.GRID_SIZE);
			while(getTileType(nx,ny) != EMPTY)
			{
				nx = Std.random(Game.GRID_SIZE);
				ny = Std.random(Game.GRID_SIZE);
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

	public function removeWall(wall : Wall)
	{
		grid[wall.getX()][wall.getY()] = EMPTY;
		removeChild(wall);
	}

	public function removeGlowstick(nx : UInt, ny : UInt)
	{
		grid[nx][ny] = EMPTY;
		for(s in sticks)
		{
			if(s.getX() == nx && s.getY() == ny)
			{
				sticks.remove(s);
				removeChild(s);
				addGlowsticks();
				break;
			}
		}
	}

	public function getSize() : UInt
	{	return size;}

	public function validPos(gridX : Int, gridY : Int) : Bool
	{
		return gridX >= 0 && gridX <= grid.length - 1 &&
				gridY >= 0 && gridY <= grid[0].length - 1;
	}
}

interface GameSprite
{
	public function getX() : UInt;
	public function getY() : UInt;
}

class Wall extends Sprite implements GameSprite
{
	public function new(gridX : UInt, gridY : UInt)
	{
		super();
		x = gridX * Game.GRID_SIZE;
		y = gridY * Game.GRID_SIZE;

		var q = new Quad(Game.GRID_SIZE, Game.GRID_SIZE);
		addChild(q);

		addEventListener(Event.ADDED, function()
		{
			var timer = new Timer(1000,2);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
			{
				cast(parent, Game).removeWall(this);
			});
		});
	}

	public function getX() : UInt
	{	return cast(Std.int(x / Game.GRID_SIZE), UInt);}

	public function getY() : UInt
	{	return cast(Std.int(y / Game.GRID_SIZE), UInt);}
}

class Glowstick extends Sprite implements GameSprite
{
	var quad : Quad;

	public function new(gridX : UInt, gridY : UInt)
	{
		super();

		x = gridX * Game.GRID_SIZE;
		y = gridY * Game.GRID_SIZE;

		quad = new Quad(Game.GRID_SIZE / 4, Game.GRID_SIZE);
		do{quad.color = Std.random(0xcccccc);}
		while(quad.color < 0x444444);
		addChild(quad);
		quad.x = quad.y = Game.GRID_SIZE/2;
		quad.pivotX = quad.width/2;
		quad.pivotY = quad.height/2;
		quad.alpha = 0.75;

		var rotFac = Std.random(10)+1;

		addEventListener(Event.ENTER_FRAME, function()
		{
			quad.rotation += (rotFac*Math.PI/180);
		});
	}

	public function getX() : UInt
	{	return cast(Std.int(x / Game.GRID_SIZE), UInt);}

		public function getY() : UInt
	{	return cast(Std.int(y / Game.GRID_SIZE), UInt);}
}