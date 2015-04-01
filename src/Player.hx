import starling.core.Starling;
import starling.display.Sprite;
import starling.display.Image;
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
	//the 8 player direcetion images
	private var up:Image; 
	private var down:Image; 
	private var right:Image; 
	private var left:Image; 
	private var jup:Image; 
	private var jdown:Image; 
	private var jright:Image; 
	private var jleft:Image;
	private var currentImage : Image;

	private var dir : DIRECTION;
	private var moving : Bool;
	private var jumping : Bool;
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
		jumping = false;
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
				case Keyboard.SPACE:
					jumping = !jumping;
			}
		});
		addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case Keyboard.SPACE:
					jumping = !jumping;
			}
			changeSprite();
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

		up = new Image(Root.assets.getTexture("bandit5"));
		down = new Image(Root.assets.getTexture("bandit1"));
		right = new Image(Root.assets.getTexture("bandit3"));
		left = new Image(Root.assets.getTexture("bandit3"));
		jup = new Image(Root.assets.getTexture("bandit6"));
		jdown = new Image(Root.assets.getTexture("bandit2"));
		jright = new Image(Root.assets.getTexture("bandit4"));
		jleft = new Image(Root.assets.getTexture("bandit4"));

		//format the player images for the begining of the game
		up.visible = false;
		right.visible = false;
		left.visible = false;
		left.scaleX = -1;
		left.x = left.x + left.width;
		jup.visible = false;
		jdown.visible = false;
		jright.visible = false;
		jleft.visible = false;
		jleft.scaleX = -1;
		jleft.x = jleft.x + jleft.width;

		addChild(up);
		addChild(down);
		addChild(right);
		addChild(left);
		addChild(jup);
		addChild(jdown);
		addChild(jright);
		addChild(jleft);
		currentImage = down;


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
						speed -= 0.05;
					game.updateScore(score);

					moveTo(nx,ny);
				default:
					game.reset();
			}
		}
		else
		{	game.reset();}
	}

	//changes the displayed image of the sprite depending on dir
	private function changeSprite(){
		var next: Image = currentImage;
		switch(dir){
			case UP:
				if (jumping) next = jup;
				else next = up;
			case DOWN:
				if (jumping) next = jdown;
				else next = down;
			case LEFT:
				if (jumping) next = jleft;
				else next = left;
			case RIGHT:
				if (jumping) next = jright;
				else next = right;
			case NONE:

		}

		if (next != currentImage){
			currentImage.visible = false;
			currentImage = next;
			next.visible = true;
			} 
	}

	private function moveTo(nx : Int, ny : Int)
	{
		moving = true;
		changeSprite();
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