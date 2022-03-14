import Toybox.Graphics;
import Toybox.WatchUi;

class InputView extends WatchUi.View {
    var input as Float;
    var unit as String;
    var format as String;
    var color as Number;

    function initialize(input as Float, unit as String, format as String, color as Number) {
        View.initialize();
        self.input = input;
        self.unit = unit;
        self.format = format;
        self.color = color;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.InputLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        findDrawableById("OkButton").setState(:stateDisabled);
        findDrawableById("OkLabel").setColor(Graphics.COLOR_DK_GRAY);
        findDrawableById("InputLabel").setColor(color);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout

        var view = findDrawableById("InputLabel") as Text;
        var string = input.format(format) + " " + unit;
        view.setText(string);
        
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
