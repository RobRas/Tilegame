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
		//createGridLines();
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

	/*private function createGridLines()
	{
		//horizontal lines
		var i : UInt = 0;
		while(i <= size)
		{
			var quad = new Quad(size, 2.5, 0);
			quad.y = i; i += GRID_SIZE;
			addChild(quad);
		}

		//vertical lines
		var j : UInt = 0;
		while(j <= size)
		{
			var quad = new Quad(2.5, size, 0);
			quad.x = j; j += GRID_SIZE;
			addChild(quad);
		}
	}*/

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
			/*var totalTime : Float = 0;
			var frameCount = 0;*/
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

				//checking the frame rate
				/*totalTime += e.passedTime;
				if(++frameCount % 60 == 0)
				{
					trace("Frame Rate: " + frameCount/totalTime);
					frameCount = 0; totalTime = 0;
				}*/
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
		var d = new Dancer(Std.random(3));
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

	public function reset(score : UInt)
	{	cast(parent, Menu).reset(score);}
}

interface GameSprite
{
	public function getX() : UInt;
	public function getY() : UInt;
}

class Wall extends Sprite implements GameSprite
{
	public function new(gridX : UInt, gridY : UInt, col : UInt)
	{
		super();
		x = gridX * Game.GRID_SIZE;
		y = gridY * Game.GRID_SIZE;

		var q = new Quad(Game.GRID_SIZE, Game.GRID_SIZE, col);
		addChild(q);

		addEventListener(Event.ADDED, function()
		{
			var timer = new Timer(100, Math.ceil(cast(parent, Game).wallcount++/2));
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
		while(quad.color < 0x606060);
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

	public function getColor() : UInt
	{	return quad.color;}

	public function getX() : UInt
	{	return cast(Std.int(x / Game.GRID_SIZE), UInt);}

		public function getY() : UInt
	{	return cast(Std.int(y / Game.GRID_SIZE), UInt);}
}

class ScoreText extends Sprite
{
	private var quad : Quad;
	private var score : TextField;

	public function new()
	{
		super();
		score = new TextField(Game.GRID_SIZE*3,Game.GRID_SIZE,"0",
							Menu.bitmapFont,20,0xffffff);
		quad = new Quad(score.width,score.height,0);
		addChild(quad);
		addChild(score);
	}

	public function setText(s:String)
	{	score.text = s;}
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