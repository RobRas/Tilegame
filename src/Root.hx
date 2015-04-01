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

		//bitmap fonts
		assets.enqueue("assets/font3.fnt");
		assets.enqueue("assets/font3.png");
		var fonts = new BitmapFont(assets.getTexture("font3"), assets.getXml("font3"));
		fonts.smoothing = TextureSmoothing.NONE;
		
		//player sprites
		assets.enqueue("assets/bandit1.png");
		assets.enqueue("assets/bandit2.png");
		assets.enqueue("assets/bandit3.png");
		assets.enqueue("assets/bandit4.png");
		assets.enqueue("assets/bandit5.png");
		assets.enqueue("assets/bandit6.png");

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