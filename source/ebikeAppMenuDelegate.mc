using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;

class ebikeAppMenuDelegate extends WatchUi.MenuInputDelegate {

    private var ebike;
    private var oldErrorReport;

    function initialize(theBike) {
    	ebike = theBike;
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (ebike.errorReport == null || !ebike.errorReport.equals(Rez.Strings.NoGo)){
        	oldErrorReport = ebike.errorReport;
	        if (item == :item_1) {
	            ebike.errorReport = Rez.Strings.NoGo;
	        } else if (item == :item_2) {
	            ebike.errorReport = Rez.Strings.NoGo;
	        }
	        new Timer.Timer().start(method(:onMenuTimerUpdate), 3000, false);    
        }
    }
    
    function onMenuTimerUpdate(){
    	ebike.errorReport = oldErrorReport;
    }

}