import Toybox.Graphics;
import Toybox.WatchUi;

class BolusConfirmView extends WatchUi.View {
    private var _value as Method;

    var counter = 0;

    function initialize(value as Float) {
        View.initialize();
        _value = value;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.BolusConfirmLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        findDrawableById("Header").setText("Press ENTER\n3 times");
        findDrawableById("StatusLabel").setText("Enact " + _value.format("%.2f") + " U");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        var circles = findDrawableById("BolusCirclesDrawable") as BolusCirclesDrawable;
        circles.counter = counter;
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}