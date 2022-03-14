import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;
import Toybox.Graphics;

class ConfirmDelegate extends WatchUi.BehaviorDelegate {
    private var _view as View;
    private var _timer as Timer;

    function initialize(view as View) {
        BehaviorDelegate.initialize();
        _view = view;
        _timer = new Timer.Timer();
        _timer.start(method(:onTimer), 5000, false);
    }

    function onMenu() as Boolean {
        System.println("onMenu");
        return true;
    }

    function onBack() as Boolean {
        System.println("onBack");
        return true;
    }

    function onTimer() {
        var label = _view.findDrawableById("StatusLabel") as Text;
        label.setText("OK");
        label.setColor(Graphics.COLOR_GREEN);
        WatchUi.requestUpdate(); 
        _timer.start(method(:onDone), 2000, false);
    }

    function onDone() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT); 
    }
}