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
		Starling.current.stage.addEventListener(RESET_GAME, function(){setMenu(Main);});
	}

	private function setMenu(state : GAME_STATE)
	{
		removeChildren();
		switch(state)
		{
			case Main:
				var title = new MenuText(200,50,"Tile",50);
				title.y = setHeight(15);
				addChild(title);

				var play = new MenuButton(100,50,"Play",20,
				function(){setMenu(Play);});
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
				addChild(new Game());
		}
	}

	public static function setHeight(n : Float) : Float
	{	return (n/100) * Starling.current.stage.stageHeight;}

	public static function reset()
	{	Starling.current.stage.dispatchEvent(new Event(RESET_GAME));}
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