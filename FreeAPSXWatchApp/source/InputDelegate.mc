import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;

class InputDelegate extends WatchUi.BehaviorDelegate {
    private var swipesEnabled = false;
    private var _view as View;
    private var _callback as Method;
    private var _keyUpPressedTime = 0;
    private var _upTimer as Timer;
    private var _keyDownPressedTime = 0;
    private var _downTimer as Timer;
    private var _increment as Float;
    private var _bigIncrement as Float;
    private var _maxValue as Float;
    
    function initialize(
        view as View, 
        callback as Method, 
        inctement as Float, 
        bigIncrement as Float, 
        maxValue as Float) {

        BehaviorDelegate.initialize();
        _view = view;
        _increment = inctement;
        _bigIncrement = bigIncrement;
        _maxValue = maxValue;
        _callback = callback;
        _upTimer = new Timer.Timer();
        _downTimer = new Timer.Timer();
    }

    function onSelectable(selectableEvent as SelectableEvent) as Boolean {
        var selectable = selectableEvent.getInstance() as Selectable;
        var id = selectable.identifier as String;
        var state = selectable.getState();
        var prevState = selectableEvent.getPreviousState();

        if (id.equals("PlusButton")) {
            if (state == :stateHighlighted) {
                return handlePress(KEY_UP);
            } else if (state == :stateSelected || (state == :stateDefault && prevState == :stateHighlighted)) {
                return handleRelease(KEY_UP);
            } 
        }

        if (id.equals("MinusButton")) {
            if (state == :stateHighlighted) {
                return handlePress(KEY_DOWN);
            } else if (state == :stateSelected || (state == :stateDefault && prevState == :stateHighlighted)) {
                return handleRelease(KEY_DOWN);
            }
        }

        if (id.equals("OkButton")) {
            if (state == :stateHighlighted) {
                return handlePress(KEY_ENTER);
            } else if (state == :stateSelected) {
                return handleRelease(KEY_ENTER);
            }
        }

        if (id.equals("CancelButton")) {
            if (state == :stateHighlighted) {
                return handlePress(KEY_ESC);
            } else if (state == :stateSelected) {
                return handleRelease(KEY_ESC);
            }
        }

        return false;
    }

    function onKeyPressed(keyEvent) { 
        var ok = handlePress(keyEvent.getKey()); 
        if (ok) {
            WatchUi.requestUpdate(); 
        }
        return ok;
    } 

    function onKeyReleased(keyEvent) { 
        var ok = handleRelease(keyEvent.getKey()); 
        if (ok) {
            WatchUi.requestUpdate(); 
        }
        return ok;
    }

    function handlePress(btn) as Boolean {
        if (btn == KEY_UP) { 
            var button = _view.findDrawableById("PlusButton") as Selectable;
            button.setState(:stateHighlighted);
            WatchUi.requestUpdate(); 

            _keyUpPressedTime = System.getTimer(); 
            _upTimer.start(method(:onHoldUpTimer), 500, true);
            return true; 
        } 

        if (btn == KEY_DOWN) { 
            var button = _view.findDrawableById("MinusButton") as Selectable;
            button.setState(:stateHighlighted);
            WatchUi.requestUpdate(); 

            _keyDownPressedTime = System.getTimer(); 
            _downTimer.start(method(:onHoldDownTimer), 500, true);
            return true; 
        } 

        if (btn == KEY_ESC) { 
            var button = _view.findDrawableById("CancelButton") as Selectable;
            button.setState(:stateHighlighted);
            WatchUi.requestUpdate(); 
            return true; 
        } 

        if (btn == KEY_ENTER) { 
            var button = _view.findDrawableById("OkButton") as Selectable;
            if (_view.input > 0) {
                button.setState(:stateHighlighted);
            }
            WatchUi.requestUpdate(); 
            return true; 
        } 

        return false;
    }

    function handleRelease(btn) as Boolean {
        if ((_keyUpPressedTime > 0) && (btn == KEY_UP)) { 
            var button = _view.findDrawableById("PlusButton") as Selectable;
            button.setState(:stateDefault);
            WatchUi.requestUpdate(); 

            var delta = System.getTimer() - _keyUpPressedTime; // ms since last press 
            _keyUpPressedTime = 0; 
            if (delta > 500) { 
                // We have a hold 
                System.println("RELEASE");
            } else { 
                // We have a regular press  
                System.println("PRESS");
                add(_increment);
            } 
            _upTimer.stop();
            return true; 
        } 

        if ((_keyDownPressedTime > 0) && (btn == KEY_DOWN)) { 
            var button = _view.findDrawableById("MinusButton") as Selectable;
            button.setState(:stateDefault);
            WatchUi.requestUpdate(); 

            var delta = System.getTimer() - _keyDownPressedTime; // ms since last press 
            _keyDownPressedTime = 0; 
            if (delta > 500) { 
                // We have a hold 
                System.println("RELEASE");
            } else { 
                // We have a regular press  
                System.println("PRESS");
                add(-_increment);
            } 
            _downTimer.stop();
            return true; 
        } 

        if (btn == KEY_ESC) { 
            var button = _view.findDrawableById("CancelButton") as Selectable;
            button.setState(:stateDefault);
            WatchUi.requestUpdate(); 
            cancel();
            return true; 
        } 

        if (btn == KEY_ENTER) { 
            if (_view.input > 0) {
                var button = _view.findDrawableById("OkButton") as Selectable;
                button.setState(:stateDefault);
                WatchUi.requestUpdate(); 
                confirm();
                return true; 
            }
        } 

        return false; 
    }

    function onHoldUpTimer() {
        add(_bigIncrement);
    }

    function onHoldDownTimer() {
        add(-_bigIncrement);
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Boolean {
        if (!swipesEnabled) {
            return false;
        }
        var dir = swipeEvent.getDirection();
        switch (dir) {
        case SWIPE_UP:
            System.println("UP");
            add(_increment);
            break;
        case SWIPE_DOWN:
            System.println("DOWN");
            add(-_increment);
            break;
        case SWIPE_RIGHT:
            System.println("RIGHT");
            add(-_bigIncrement);
            break;
        case SWIPE_LEFT:
            System.println("LEFT");
            add(_bigIncrement);
            break;
        }
         
        return true;
    }

    function add(value) {
        _view.input += value;
        if (_view.input > _maxValue) {
            _view.input = _maxValue;
        }
        if (_view.input < 0) {
            _view.input = 0;
        }

        if (_view.input > 0) {
            _view.findDrawableById("OkButton").setState(:stateDefault);
            _view.findDrawableById("OkLabel").setColor(Graphics.COLOR_GREEN);
        } else {
            _view.findDrawableById("OkButton").setState(:stateDisabled);
            _view.findDrawableById("OkLabel").setColor(Graphics.COLOR_DK_GRAY);
        }
        

        WatchUi.requestUpdate(); 
    }

    function confirm() { 
        _callback.invoke(_view.input);
    }

    function cancel() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT); 
    }
}