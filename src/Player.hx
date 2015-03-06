import starling.core.Starling;
import starling.display.Sprite;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.events.*;
import flash.ui.*;
import Menu;

enum DIRECTION
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
	NONE;
}

class Player extends Sprite
{
	//temporary image
	private var image : TextField;

	private var dir : DIRECTION;
	private var moving : Bool;
	private var game : Game;
	
	public var gridX : UInt;
	public var gridY : UInt;

	public function new(g : Game, gridX : UInt, gridY : UInt)
	{
		super();
		dir = NONE;
		moving = false;
		game = g;
		
		this.gridX = gridX;
		this.gridY = gridY;
		
		x = gridX * Game.GRID_SIZE;
		y = gridY * Game.GRID_SIZE;

		addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
					dir = UP;
				case Keyboard.DOWN:
					dir = DOWN;
				case Keyboard.LEFT:
					dir = LEFT;
				case Keyboard.RIGHT:
					dir = RIGHT;
			}
		});
		addEventListener(Event.ENTER_FRAME, function()
		{
			if(moving) return;
			switch(dir)
			{
				case LEFT:
					moveDirection(-1, 0);
				case RIGHT:
					moveDirection(1, 0);
				case UP:
					moveDirection(0, -1);
				case DOWN:
					moveDirection(0, 1);
				default: return;
			}
		});

		addChild(new TextField(Game.GRID_SIZE,Game.GRID_SIZE,"P",Menu.bitmapFont,20,0x0000ff));

	}
	
	private function moveDirection(dirX : Int, dirY : Int) {
		var nx = gridX + dirX;
		var ny = gridY + dirY;
		
		if(game.validPos(nx, ny)) {
			if (game.getTileType(nx, ny) == EMPTY) {
				moving = true;
				Starling.juggler.tween(this, 0.1,
				{
					transition: Transitions.LINEAR,
					x: nx * Game.GRID_SIZE, y : ny * Game.GRID_SIZE,
					onComplete: function() {
						moving = false;
						game.createWall(gridX, gridY);
						gridX = nx;
						gridY = ny;
					}
				});
			} else if (game.getTileType(nx, ny) == WALL) {
				Menu.reset();
			}
		} else {
				Menu.reset();
			}
	}
}