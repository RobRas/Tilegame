import starling.core.Starling;
import starling.display.MovieClip;
import starling.display.Image;
import starling.animation.Transitions;

class Dancer extends MovieClip {

	public function new(col:UInt, fps:UInt = 3){
		if (col == 1){
			super(Root.assets.getTextures("red"),fps);
		}else if(col == 2){
			super(Root.assets.getTextures("blue"),fps);
		}else{
			super(Root.assets.getTextures("green"),fps);
		}
		loop = true;
		play();

		Starling.juggler.add(this);
	}

}