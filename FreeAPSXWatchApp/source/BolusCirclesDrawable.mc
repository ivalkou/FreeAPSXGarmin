import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Time;

class BolusCirclesDrawable extends WatchUi.Drawable {
    var counter = 0;

    function initialize() {
        var dictionary = {
            :identifier => "BolusCirclesDrawable"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        for( var i = 1; i <= 3; i++ ) {
            if (counter < i) {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            }
            dc.fillCircle(width * 0.35 + (i-1) * width * 0.15, height * 0.8, width * 0.05);
        }
    }
}