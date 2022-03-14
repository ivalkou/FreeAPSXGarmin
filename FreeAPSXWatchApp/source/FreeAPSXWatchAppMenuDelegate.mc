import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class FreeAPSXWatchAppMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _callback as Method;

    function initialize(callback as Method) {
        Menu2InputDelegate.initialize();
        _callback = callback;
    }

    function onSelect(item) as Void {
        var id = item.getId();
        _callback.invoke(id);
    }

}