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
		/*assets.enqueue("assets/font1.fnt", "assets/font1_0.png");
		var fonts = new BitmapFont(assets.getTexture("font1_0"), assets.getXml("font1"));*/

		assets.enqueue("assets/font2.fnt", "assets/font2_0.png");
		var fonts = new BitmapFont(assets.getTexture("font2_0"), assets.getXml("font2"));

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