import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.Time;
import Toybox.System;
import Toybox.Communications;

class FreeAPSXDataFieldApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        //register for temporal events if they are supported
        if(Toybox.System has :ServiceDelegate) {
            // canDoBG=true;
            Background.registerForTemporalEvent(new Time.Duration(5 * 60));
            Background.registerForPhoneAppMessageEvent();
            System.println("****background is ok****");
        } else {
            System.println("****background not available on this device****");
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new FreeAPSXDataFieldView() ] as Array<Views or InputDelegates>;
    }

    function getServiceDelegate() {
        return [new FreeAPSXBGServiceDelegate()];
    }


}

function getApp() as FreeAPSXDataFieldApp {
    return Application.getApp() as FreeAPSXDataFieldApp;
}