import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;
import Toybox.Graphics;

var pointColors = [ 
    Graphics.COLOR_DK_GRAY,
    Graphics.COLOR_DK_GRAY,
    Graphics.COLOR_DK_GRAY
];

class BolusConfirmDelegate extends WatchUi.BehaviorDelegate {
    private var _view as View;
    private var _timer as Timer;
    private var _callback as Method;
    private var _value as Float;
    private var _ok = false;

    function initialize(view as View, callback as Method, value as Float) {
        BehaviorDelegate.initialize();
        _view = view;
        _callback = callback;
        _value = value;
        _timer = new Timer.Timer();
    }

    function onMenu() as Boolean {
        System.println("onMenu");
        return true;
    }

    function onBack() as Boolean {
        System.println("onBack");
        _callback.invoke(false, 0);
        return true;
    }

    function onSelect() as Boolean {
        if (_ok) { return true; }
        System.println("onSelect");
        _view.counter += 1;
        if (_view.counter > 3) {
            _view.counter = 3;
        }
        if (_view.counter == 3) {
            _timer.stop();
            _ok = true;
            var label = _view.findDrawableById("StatusLabel") as Text;
            label.setText("OK");
            label.setColor(Graphics.COLOR_GREEN);
            _timer.start(method(:onFinishTimer), 1000, false);
        }
        if (!_ok) {
            _timer.stop();
            _timer.start(method(:onTimer), 1000, true);
        }
        WatchUi.requestUpdate(); 
        return true;
    }

    function onTimer() {
        _view.counter -= 1;
        if (_view.counter < 0) {
            _view.counter = 0;
        }
        if (_view.counter == 0) {
            _timer.stop();
        }

        WatchUi.requestUpdate(); 
    }

    function onFinishTimer() {
        _callback.invoke(true, _value);
        WatchUi.requestUpdate(); 
    }
}