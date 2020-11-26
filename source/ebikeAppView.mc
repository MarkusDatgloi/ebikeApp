using Toybox.WatchUi;
using Toybox.Timer;


class ebikeAppView extends WatchUi.View {

	private var ebike;
	private var bleHandler;		// the BLE delegate
    private var propsManager;
    private var prompt;
    private var timer;
	private var displayString = "";
	
	private const secondsWaitBattery = 15;		// only read the battery value every 15 seconds
	private var secondsSinceReadBattery = secondsWaitBattery;

	private var modeNames = [
		"Off",
		"Eco",
		"Trail",
		"Boost",
		"Walk",
	];

	private var connectCounter = 0;		// number of seconds spent scanning/connecting to a bike

    function initialize(theBike, theBleDelegate, thePropsManager) {
        View.initialize();
		//System.println("initialize");
        ebike = theBike;
    	bleHandler = theBleDelegate;
		propsManager = thePropsManager;
		timer = new Timer.Timer();
		prompt = null;
    }

    // Load your resources here
    function onLayout(dc) {
		//System.println("onLayout");
        setLayout(Rez.Layouts.MainLayout(dc));
        prompt = View.findDrawableById("prompt");
        View.findDrawableById("batteryLevel").setData(ebike);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
		//System.println("onShow");
		timer.start(method(:onTimerUpdate), 1000, true);    
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
		//System.println("onUpdate");
        compute(dc);
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	timer.stop();
    }

    //==================================
    
	// called by app when settings change
	function onSettingsChanged() {
		//System.println("onSettingsChanged");
		// do some stuff in case user has changed the MAC address or the lock flag
    	WatchUi.requestUpdate();   // update the view to reflect changes
	}
    
    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(dc) {
        // See Activity.Info in the documentation for available information.
    	// To test values use the "App settings editor"
    
    	// var showBattery = (showList[0]==1 || showList[1]==1 || showList[2]==2);   
    	var showBattery = (ebike.showList[0]==1 || ebike.showList[1]==1 || ebike.showList[2]==1);   
    	if (showBattery) {
	    	// only read battery value every 15 seconds once we have a value
	    	secondsSinceReadBattery++;
	    	if (ebike.batteryValue < 0 || secondsSinceReadBattery >= secondsWaitBattery){
	    		secondsSinceReadBattery = 0;
	    		bleHandler.requestReadBattery();
	    	}
		}
		    
    	var showMode = (ebike.showList[0]>=2 || ebike.showList[1]>=2 || ebike.showList[2]>=2);
    	bleHandler.requestNotifyMode(showMode);		// set whether we want mode or not (continuously)
		bleHandler.compute();
		
		// create the string to display to user
   		displayString = "";
		// could show status of scanning & pairing if we wanted
		if (bleHandler.isConnecting()) {
			connectCounter++;
			if (ebike.errorReport != null && !ebike.errorReport.equals("") && connectCounter > 10){
				displayString = ebike.errorReport;
			} else {
			    if (connectCounter > 20) {
					displayString = "power ON ?  " + connectCounter;
				} else {
					displayString = "Scan " + connectCounter;
				}
			}
		} else {
			connectCounter = 0;
			for (var i = 0; i < ebike.showList.size(); i++) {
				switch (ebike.showList[i]) {
					case 0:		// off
					{
						break;
					}

					case 1:		// battery
					{
	    				displayString += ((displayString.length()>0)?" ":"") + ((ebike.batteryValue>=0) ? ebike.batteryValue : "---") + "%";
						break;
					}

					case 2:		// mode name
					{
	    				displayString += ((displayString.length()>0)?" ":"") + ((ebike.modeValue>=0 && ebike.modeValue<modeNames.size()) ? modeNames[ebike.modeValue] : "----");
						break;
					}

					case 3:		// gear
					{
    					displayString += ((displayString.length()>0)?" ":"") + ((ebike.gearValue>=0 && ebike.gearValue<255) ? ebike.gearValue : "Gear?");
						break;
					}
				}  // end case
			}  // end for
		}
		if ( ebike.errorReport != null && !ebike.errorReport.equals("") ){
			displayString = ebike.errorReport;
		} else {
			if (displayString.equals("") || displayString.find("-") != null){
			   if ( ebike.deviceName != null ) {
					displayString = ebike.deviceName;			   
			   } else {
					displayString = "Connected";
			   }
			} 
		}		
		// System.println(displayString + " [" + displayString.length() + "]");
		prompt.setText(displayString);
	
    }
    
        // Timer callback
    function onTimerUpdate(){
		//System.println("onUpdate");
		WatchUi.requestUpdate();
	}

    // Timer callback
    function onTimerStop(){
		//System.println("onTimerStop");
		if (timer != null){
			timer.stop();
		}
	}
	
    
}
