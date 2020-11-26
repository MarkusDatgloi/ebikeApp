using Toybox.Application;
using Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;
using Application.Properties as AppProps;
using Application.Storage as AppStorage;

class ebikeAppApp extends Application.AppBase {

    private var view;
    private var ebike;
    private var bleHandler;
    private var propsManager;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
	    if (view != null){
	    	view.onTimerStop();
	    }
    }

    // Return the initial view of your application here
    function getInitialView() {
		ebike = new ebikeData();
		
		propsManager = new ebikePropsManager(ebike);
        propsManager.getUserSettings();
        
		bleHandler = new ebikeBleDelegate(ebike, propsManager);
		Ble.setDelegate(bleHandler);
		ebike.bleInitProfiles();
		
		view = new ebikeAppView(ebike, bleHandler, propsManager);
        return [ view, new ebikeAppDelegate(ebike) ];
    }
    
    
    function onSettingsChanged() {
		propsManager.getUserSettings();
		bleHandler.onSettingsChanged();
		view.onSettingsChanged();
	}

}
