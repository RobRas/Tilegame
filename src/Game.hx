import starling.core.Starling;
import starling.display.*;
import starling.events.*;

class Game extends Sprite
{
	public static inline var GRID_SIZE = 32;
	private var grid : Array<Array<UInt>>;
	private var menu : Menu;
	private var size : UInt;

	public function new(m : Menu, gridNum : UInt = 40)
	{
		super();
		menu = m;

		size = GRID_SIZE*gridNum;
		createGridLines();

		grid = new Array();
		for(i in 0...gridNum)
		{
			grid[i] = new Array();
			for(j in 0...gridNum)
			{
				grid[i].push(0);
			}
		}

		var p = new Player(m);
		addChild(p);
		addEventListener(Event.ENTER_FRAME, function()
		{
			//center positions of player
			var centerX = p.x + p.width/2;
			var centerY = p.y + p.height/2;

			//new camera position
			var newX = centerX - Starling.current.stage.stageWidth/2;
			var newY = centerY - Starling.current.stage.stageHeight/2;

			x = -newX; y = -newY;
			if(x > 0) x = 0;
			else if(x < -(size - Starling.current.stage.stageWidth))
				x = -(size - Starling.current.stage.stageWidth);

			if(y > 0) y = 0;
			else if(y < -(size - Starling.current.stage.stageHeight))
				y = -(size - Starling.current.stage.stageHeight);
		});
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

	public function getSize() : UInt
	{	return size;}
}