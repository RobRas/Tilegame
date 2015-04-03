import starling.display.*;
import starling.core.Starling;
import starling.events.*;
import starling.text.TextField;
import starling.textures.Texture;
import flash.media.*;
import starling.animation.Transitions;
import starling.textures.TextureSmoothing;

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
	public inline static var bitmapFont = "font3";

	private inline static var creditsText = "Temitope Alaga\n Cate Holcomb\n Justin Liddicoat";

	private static inline var instructionText = "The nefarious Rave Bandit wants to steal all the glowsticks from the rave. "
	+"Navigate the dance floor with the arrow keys, and avoid the dancers, walls, and your light trail.";

	//for resetting
	private static inline var RESET_GAME = "ResetGame";

	public function new()
	{
		super();
		addChild(new GameMusic());
		setDancers();
		setMenu(Main);
		addEventListener(RESET_GAME, function(){setMenu(Main);});
	}

	private function setMenu(state : GAME_STATE, ?sz : UInt)
	{
		removeChildren(4);
		switch(state)
		{
			case Main:
				var title = new MenuText(400,100,"Rave Bandit",32);
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
				var title = new MenuText(200,100,"Pick a difficulty",20);
				title.y = setHeight(15);
				addChild(title);

				var easy = new MenuButton(75,50,"Easy",20,function()
				{
					setMenu(Play,30);
				});
				easy.y = setHeight(30);

				var medium = new MenuButton(75,50,"Medium",20,function()
				{
					setMenu(Play,50);
				});
				medium.y = setHeight(40);

				var hard = new MenuButton(75,50,"Hard",20,function()
				{
					setMenu(Play,70);
				});
				hard.y = setHeight(50);

				addChild(easy);
				addChild(medium);
				addChild(hard);

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

	public function setDancers(){
		var red = new Dancer(1);
		red.scaleX = 2;
		red.scaleY = 2;
		red.smoothing = TextureSmoothing.NONE;
		red.x = Starling.current.stage.stageWidth/2 - red.width/2;
		red.y = setHeight(75);
		addChild(red);
		var blue = new Dancer(2);
		blue.scaleX = 2;
		blue.scaleY = 2;
		blue.smoothing = TextureSmoothing.NONE;
		blue.x = Starling.current.stage.stageWidth/4 - blue.width/2;
		blue.y = setHeight(75);
		addChild(blue);
		var green = new Dancer(3);
		green.scaleX = 2;
		green.scaleY = 2;
		green.smoothing = TextureSmoothing.NONE;
		green.x = 3*(Starling.current.stage.stageWidth/4) - green.width/2;
		green.y = setHeight(75);
		addChild(green);
	}
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
		addEventListener(Event.TRIGGERED, fn);
	}
}

class GameMusic extends Sprite
{
	private var sound : Sound;
	private var channel : SoundChannel;
	private var volume : Float;
	private var isPlaying : Bool;

	public function new()
	{
		super();
		sound = Root.assets.getSound("TileGame");
		channel = null;
		isPlaying = false;
		volume = 0.5;

		var dec = new Button(Texture.empty(50,50), "-");
		dec.fontName = Menu.bitmapFont;
		dec.fontColor = 0xffffff;
		dec.fontSize = 20;
		dec.addEventListener(Event.TRIGGERED, decVol);

		var inc = new Button(Texture.empty(50,50),"+");
		inc.x = inc.width;
		inc.fontColor = 0xffffff;
		inc.fontName = Menu.bitmapFont;
		inc.fontSize = 20;
		inc.addEventListener(Event.TRIGGERED, incVol);

		addChild(inc);
		addChild(dec);

		play();
	}

	public function play()
	{
		if(!isPlaying)
		{
			channel = sound.play();
			channel.soundTransform = new SoundTransform(volume);
			isPlaying = true;
			if(!channel.hasEventListener(flash.events.Event.SOUND_COMPLETE))
			{
				channel.addEventListener(flash.events.Event.SOUND_COMPLETE,
				function(e:flash.events.Event)
				{
					isPlaying = false;
					play();
				});
			}
		}
	}

	public function stop()
	{
		if(isPlaying)
		{
			channel.stop();
			isPlaying = false;
		}
	}

	private function incVol()
	{
		volume += 0.1;
		if(volume > 1.0) volume = 1.0;
		channel.soundTransform = new SoundTransform(volume);
	}

	private function decVol()
	{
		volume -= 0.1;
		if(volume < 0.0) volume = 0.0;
		channel.soundTransform = new SoundTransform(volume);
	}
}