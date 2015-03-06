import starling.core.Starling;
import starling.display.*;
import starling.events.*;

enum GRIDTYPE
{
	EMPTY;
	PLAYER;
	WALL;
}

class Game extends Sprite
{
	public static inline var GRID_SIZE = 32;
	private var grid : Array<Array<GRIDTYPE>>;
	private var size : UInt;

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
		
		addPlayer(10, 10);
	}

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
		addChild(p);
		
		//check every frame to ensure the grid is positioned correctly
		addEventListener(Event.ENTER_FRAME, function()
		{
			//center positions of player
			var centerX = p.x + p.width/2;
			var centerY = p.y + p.height/2;

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

	public function getSize() : UInt
	{	return size;}

	public function validPos(cx : Float, cy : Float) : Bool
	{
		return cx >= 0 && cx <= size - GRID_SIZE &&
				cy >= 0 && cy <= size - GRID_SIZE;
	}
}