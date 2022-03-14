import Toybox.Graphics;
import Toybox.WatchUi;

class FreeAPSXWatchAppView extends WatchUi.View {

    hidden var firstShow; 

    function initialize() {
        View.initialize();
        firstShow = true;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        if (firstShow) { 
            WatchUi.pushView(new Rez.Menus.MainMenu(), new FreeAPSXWatchAppMenuDelegate(method(:onSelect)), WatchUi.SLIDE_IMMEDIATE);
            firstShow = false; 
        } else { 
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); 
        }
        // Graphics.FONT_NUMBER_MEDIUM
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function onSelect(id) as Void {
        if (id == :Carbs) {
            System.println("Carbs");
            var view = new InputView(0, "g", "%d", Graphics.COLOR_GREEN);
            WatchUi.pushView(view, new InputDelegate(view, method(:onCarbsConfirm), 1, 10, 120), WatchUi.SLIDE_LEFT);
        } else if (id == :TempTargets) {
            System.println("TempTargets");
        } else if (id == :Bolus) {
            System.println("Bolus");
            var view = new InputView(0, "U", "%.1f", Graphics.COLOR_BLUE);
            WatchUi.pushView(view, new InputDelegate(view, method(:onBolusConfirm), 0.1, 1, 10), WatchUi.SLIDE_LEFT);
        }
    }

    function onCarbsConfirm(carbs as Float) {
        if (carbs > 0) {
            System.println("onCarbsConfirm");
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            showConfirmationView();
        }
    }

    function onBolusConfirm(bolus as Float) {
        if (bolus > 0) {
            System.println("onBolusConfirm");
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            showConfirmationBolusView(bolus);
        }
    }

    function showConfirmationView() {
        var view = new ConfirmView();
        WatchUi.pushView(view, new ConfirmDelegate(view), WatchUi.SLIDE_IMMEDIATE);
    }

    function showConfirmationBolusView(bolus as Float) {
        var view = new BolusConfirmView(bolus);
        WatchUi.pushView(view, new BolusConfirmDelegate(view, method(:onBolusCheked), bolus), WatchUi.SLIDE_IMMEDIATE);
    }

    function onBolusCheked(ok as Boolean, value as Float) {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        if (!ok || value <= 0) { return; }

        System.println("Bolus OK");
        showConfirmationView();
    }
}