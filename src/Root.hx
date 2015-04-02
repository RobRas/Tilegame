import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.textures.TextureSmoothing;

class Root extends Sprite {

	public static var assets:AssetManager;

	public function new() {
		super();
	}

	public function start(startup:Startup) {
		assets = new AssetManager();

		//spritesheet
		assets.enqueue("assets/sprites.png");
		assets.enqueue("assets/sprites.xml");

		//bitmap fonts
		assets.enqueue("assets/font3.fnt");
		assets.enqueue("assets/font3.png");
		var fonts = new BitmapFont(assets.getTexture("font3"), assets.getXml("font3"));
		fonts.smoothing = TextureSmoothing.NONE;

		//tilemap
		assets.enqueue("assets/tile1.png");
		assets.enqueue("assets/tile2.png");
		assets.enqueue("assets/tile3.png");
		assets.enqueue("assets/tile4.png");
		assets.enqueue("assets/tile5.png");
		assets.enqueue("assets/tile6.png");
		assets.enqueue("assets/tile7.png");
		assets.enqueue("assets/tile8.png");
		assets.enqueue("assets/tile9.png");
		assets.enqueue("assets/tile10.png");
		assets.enqueue("assets/tile11.png");
		assets.enqueue("assets/tile12.png");
		assets.enqueue("assets/tile13.png");
		assets.enqueue("assets/tile14.png");
		assets.enqueue("assets/tile15.png");

		
		//player sprites
		assets.enqueue("assets/bandit1.png");
		assets.enqueue("assets/bandit2.png");
		assets.enqueue("assets/bandit3.png");
		assets.enqueue("assets/bandit4.png");
		assets.enqueue("assets/bandit5.png");
		assets.enqueue("assets/bandit6.png");

		//people sprites
		assets.enqueue("assets/red1.png");
		assets.enqueue("assets/red2.png");
		assets.enqueue("assets/red3.png");
		assets.enqueue("assets/red4.png");
		assets.enqueue("assets/red5.png");
		assets.enqueue("assets/red6.png");
		assets.enqueue("assets/red7.png");
		assets.enqueue("assets/red8.png");

		assets.enqueue("assets/green1.png");
		assets.enqueue("assets/green2.png");
		assets.enqueue("assets/green3.png");
		assets.enqueue("assets/green4.png");
		assets.enqueue("assets/green5.png");
		assets.enqueue("assets/green6.png");
		assets.enqueue("assets/green7.png");
		assets.enqueue("assets/green8.png");

		assets.enqueue("assets/blue1.png");
		assets.enqueue("assets/blue2.png");
		assets.enqueue("assets/blue3.png");
		assets.enqueue("assets/blue4.png");
		assets.enqueue("assets/blue5.png");
		assets.enqueue("assets/blue6.png");
		assets.enqueue("assets/blue7.png");
		assets.enqueue("assets/blue8.png");
		

		assets.enqueue("assets/TileGame.mp3");
		assets.loadQueue(function onProgress(ratio:Float)
		{
			if (ratio == 1)
			{
				Starling.juggler.tween(startup.loadingBitmap, 1.0,
				{
					transition:Transitions.EASE_OUT, delay:0, alpha: 0, onComplete:
					function(){	startup.removeChild(startup.loadingBitmap);}
				});
				fonts.smoothing = "none";
				TextField.registerBitmapFont(fonts,"FutureWorld");
				addChild(new Menu());
			}
		});
	}
}