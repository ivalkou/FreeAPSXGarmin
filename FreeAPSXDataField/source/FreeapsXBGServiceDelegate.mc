import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Communications;

(:background)
class FreeAPSXBGServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() {
        System.println("Temp event");
        Communications.transmit("status", null, new CommsRelay(method(:onTransmitComplete)));
    }

    function onPhoneAppMessage(msg) {
        System.println(msg.data);
        Application.Storage.setValue("status", msg.data as Dictionary);
        Background.exit(null);
    }

    function onTransmitComplete(isSuccess) {
        if (isSuccess) {
            System.println("Listener onComplete");
        } else {
            System.println("Listener onError");
        }
        Background.exit(isSuccess);
    }
}