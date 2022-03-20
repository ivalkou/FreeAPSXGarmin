using Toybox.Communications as Comms;
import Toybox.Background;

(:background)
class CommsRelay extends Comms.ConnectionListener {
    hidden var mCallback;

    function initialize(callback) {
        ConnectionListener.initialize();
        mCallback = callback;
    }

    function onComplete() {
        mCallback.invoke(true);
    }

    function onError() {
        mCallback.invoke(false);
    }
}