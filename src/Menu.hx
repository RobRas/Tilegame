import starling.display.*;
import starling.core.Starling;
import starling.events.*;
import starling.text.TextField;
import starling.textures.Texture;

enum GAME_STATE
{
	Main;
	Instructions;
	Credits;
	Play;
	Type;
}

class Menu extends Sprite
{
	//This is where the name of the bitmap font should be placed
	public inline static var bitmapFont = "Arial";

	private inline static var creditsText = "Temitope Alaga\nAdd others' name later...";

	private static inline var instructionText = "Add instructions later...";

	//for resetting
	private static inline var RESET_GAME = "ResetGame";

	public function new()
	{
		super();
		setMenu(Main);
		addEventListener(RESET_GAME, function(){setMenu(Main);});
	}

	private function setMenu(state : GAME_STATE, ?sz : UInt)
	{
		removeChildren();
		switch(state)
		{
			case Main:
				var title = new MenuText(200,50,"Tile",50);
				title.y = setHeight(15);
				addChild(title);

				var play = new MenuButton(100,50,"Play",20,
				function(){setMenu(Type);});
				play.y = setHeight(30);
				addChild(play);

				var instr = new MenuButton(150,50,"Instructions",20,
				function(){setMenu(Instructions);});
				instr.y = setHeight(45);
				addChild(instr);

				var credits = new MenuButton(100,50,"Credits",20,
				function(){setMenu(Credits);});
				credits.y = setHeight(60);
				addChild(credits);

			case Type:
				var title = new MenuText(200,100,"Pick a stage size",20);
				title.y = setHeight(15);
				addChild(title);

				var text = new MenuText(100,100,"Size: 5",20);
				text.y = setHeight(30);
				addChild(text);

				var num = 5;

				var f = function(b:Bool)
				{
					if(b)
					{
						num += 5;
						if(num > 100) num = 100;
					}
					else
					{
						num -= 5;
						if(num < 5) num = 5;
					}
					text.text = "Size: " + num;
				};

				var up = new MenuButton(75,50,">",50,
				function(){ f(true);});
				up.y = setHeight(45);
				var down = new MenuButton(75,50,"<",50,
				function(){ f(false);});
				down.y = setHeight(60);
				addChild(up); addChild(down);

				var play = new MenuButton(100,100,"Start",20,
				function(){ setMenu(Play,num);});
				play.y = setHeight(85);
				addChild(play);

			case Instructions:
				var instr = new MenuText(300,300,instructionText,20);
				instr.y = setHeight(15);
				addChild(instr);

				var back = new MenuButton(100,50,"Back",20,
				function(){setMenu(Main);});
				back.y = setHeight(60);
				addChild(back);

			case Credits:
				var cred = new MenuText(300,300,creditsText,20);
				cred.y = setHeight(15);
				addChild(cred);

				var back = new MenuButton(100,50,"Back",20,
				function(){setMenu(Main);});
				back.y = setHeight(60);
				addChild(back);

			case Play:
				var game = new Game(sz);
				game.x = Starling.current.stage.stageWidth/2 - game.width/2;
				game.y = Starling.current.stage.stageHeight/2 - game.height/2;
				addChild(game);
				game.addScore(this);
		}
	}

	public static function setHeight(n : Float) : Float
	{	return (n/100) * Starling.current.stage.stageHeight;}

	public function reset()
	{	dispatchEvent(new Event(RESET_GAME));}
}

class MenuText extends TextField
{
	public function new(w:UInt, h:UInt, s:String, f:UInt)
	{
		super(w,h,s,Menu.bitmapFont,f);

		color = 0xffffff;
		addEventListener(Event.ADDED, function()
		{
			x = Starling.current.stage.stageWidth/2 - w/2;
		});
	}
}

class MenuButton extends Button
{
	public function new(w:UInt, h:UInt, s:String, f:UInt, fn : Void->Void)
	{
		super(Texture.empty(w,h), s);
		fontName = Menu.bitmapFont;
		fontSize = f;
		fontColor = 0xffffff;

		addEventListener(Event.ADDED, function()
		{
			x = Starling.current.stage.stageWidth/2 - w/2;
		});
		addEventListener(Event.TRIGGERED, function()
		{
			fn();
		});
	}
}