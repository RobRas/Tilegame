import starling.core.Starling;
import starling.display.MovieClip;
import starling.display.Image;
import starling.animation.Transitions;
import Game;

class Dancer extends MovieClip {

	public function new(col:UInt){
		if (col == 1){
			super(Root.assets.getTextures("red"),3);
		}else if(col == 2){
			super(Root.assets.getTextures("blue"),3);
		}else{
			super(Root.assets.getTextures("green"),3);
		}
		loop = true;
		play();

		Starling.juggler.add(this);
	}

}