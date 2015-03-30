import starling.display.*;
import starling.core.Starling;
import starling.events.*;
import starling.text.TextField;
import starling.textures.Texture;
import flash.media.*;
import starling.animation.Transitions;

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

	private inline static var creditsText = "Temitope Alaga\nCate Holcomb\nAdd others' name later...";

	private static inline var instructionText = "The nefarious Rave Bandit wants to steal all the glowsticks from the rave. "
	+"Navigate the dance floor with the arrow keys, and avoid the dancers, walls, and your light trail.";

	//for resetting
	private static inline var RESET_GAME = "ResetGame";

	public function new()
	{
		super();
		addChild(new GameMusic());
		addChild(new Background());
		setMenu(Main);
		addEventListener(RESET_GAME, function(){setMenu(Main);});
	}

	private function setMenu(state : GAME_STATE, ?sz : UInt)
	{
		removeChildren(2);
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
				var title = new MenuText(200,100,"Pick a stage size",20);
				title.y = setHeight(15);
				addChild(title);

				var text = new MenuText(100,100,"Size: 10",20);
				text.y = setHeight(30);
				addChild(text);

				var num = 10;

				var f = function(b:Bool)
				{
					if(b)
					{
						num += 10;
						if(num > 100) num = 100;
					}
					else
					{
						num -= 10;
						if(num < 10) num = 10;
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

		color = 0;
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
		fontColor = 0;

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

class GameMusic extends Sprite
{
	private var sound : Sound;
	private var channel : SoundChannel;
	private var volume : Float;
	private var isPlaying : Bool;
	private var inc : Button;
	private var dec : Button;

	public function new()
	{
		super();
		sound = Root.assets.getSound("TileGame");
		channel = null;
		isPlaying = false;
		volume = 0.5;

		inc = new Button(Texture.empty(50,50),"+");
		inc.x = 0;
		inc.y = Starling.current.stage.stageHeight - inc.height;
		inc.fontName = Menu.bitmapFont;
		inc.fontSize = 20;
		inc.addEventListener(Event.TRIGGERED, incVol);

		dec = new Button(Texture.empty(50,50),"-");
		dec.x = dec.width;
		dec.y = inc.y;
		dec.fontName = Menu.bitmapFont;
		dec.fontSize = 20;
		dec.addEventListener(Event.TRIGGERED, decVol);

		addChild(inc); addChild(dec);
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

class Background extends Sprite
{
	private inline static var SIZE = 128;
	private var tweening : Array<Bool>;
	private var time : Float;

	public function new()
	{
		super();

		tweening = new Array();
		var i = 0;
		while(i < Starling.current.stage.stageWidth)
		{
			var j = 0;
			while(j < Starling.current.stage.stageHeight)
			{
				var q = new Quad(SIZE,SIZE,Std.random(0xaaaaaa)+0x222222);
				q.x = i;
				q.y = j;
				addChild(q);
				tweening.push(false);
				j += SIZE;
			}
			i += SIZE;
		}

		time = 0;
		addEventListener(Event.ENTER_FRAME, move);
	}

	private function move(e:EnterFrameEvent)
	{
		time += e.passedTime;
		if(time > 2)
		{
			time = 0;
			for(i in 0...numChildren-1)
				cast(getChildAt(i),Quad).color = Std.random(0xaaaaaa)+0x222222;
		}
	}
}