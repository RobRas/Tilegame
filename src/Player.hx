import starling.core.Starling;
import starling.display.Sprite;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.events.*;
import flash.ui.*;
import Menu;
import Game;

enum DIRECTION
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
	NONE;
}

class Player extends Sprite implements GameSprite
{
	//temporary image
	private var image : TextField;

	private var dir : DIRECTION;
	private var moving : Bool;
	private var game : Game;

	public var gridX : UInt;
	public var gridY : UInt;

	private var score : UInt;
	private var speed : Float;

	public var wallColor : UInt;

	public function new(g : Game, gridX : UInt, gridY : UInt)
	{
		super();
		dir = NONE;
		moving = false;
		game = g;
		wallColor = 0xffffff;

		this.gridX = gridX;
		this.gridY = gridY;

		x = gridX * Game.GRID_SIZE;
		y = gridY * Game.GRID_SIZE;
		speed = 0.2;
		score = 0;

		addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
					if(dir != DOWN) dir = UP;
				case Keyboard.DOWN:
					if(dir != UP) dir = DOWN;
				case Keyboard.LEFT:
					if(dir != RIGHT) dir = LEFT;
				case Keyboard.RIGHT:
					if(dir != LEFT) dir = RIGHT;
			}
		});
		addEventListener(Event.ENTER_FRAME, function()
		{
			if(moving) return;
			switch(dir)
			{
				case LEFT:
					checkDirection(-1, 0);
				case RIGHT:
					checkDirection(1, 0);
				case UP:
					checkDirection(0, -1);
				case DOWN:
					checkDirection(0, 1);
				default: return;
			}
		});

		addChild(new TextField(Game.GRID_SIZE,Game.GRID_SIZE,
							"P",Menu.bitmapFont,20,0x0000ff));
	}

	private function checkDirection(dirX : Int, dirY : Int)
	{
		var nx = gridX + dirX;
		var ny = gridY + dirY;

		if(game.validPos(nx, ny))
		{
			switch(game.getTileType(nx, ny))
			{
				case EMPTY:
					moveTo(nx,ny);
				case SCORE:
					wallColor = game.removeGlowstick(nx,ny);
					score += 10;
					if(score % 100 == 0 && speed > 0.025)
						speed -= 0.01;
					game.updateScore(score);

					moveTo(nx,ny);
				default:
					game.reset();
			}
		}
		else
		{	game.reset();}
	}

	private function moveTo(nx : Int, ny : Int)
	{
		moving = true;
		Starling.juggler.tween(this, speed,
		{
			transition: Transitions.LINEAR,
			x: nx * Game.GRID_SIZE, y : ny * Game.GRID_SIZE,
			onComplete: function()
			{
				moving = false;
				game.createWall(gridX, gridY, wallColor);
				gridX = nx;
				gridY = ny;
			}
		});
	}

	public function getX() : UInt
	{	return cast(Std.int(x / Game.GRID_SIZE), UInt);}

	public function getY() : UInt
	{	return cast(Std.int(y / Game.GRID_SIZE), UInt);}
}