import starling.core.Starling;
import starling.display.*;
import starling.events.*;
import starling.text.TextField;
import flash.events.TimerEvent;
import flash.utils.Timer;

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