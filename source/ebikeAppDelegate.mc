using Toybox.WatchUi;

class ebikeAppDelegate extends WatchUi.BehaviorDelegate {

    private var ebike;
    
    function initialize(theBike) {
        ebike = theBike;
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new ebikeAppMenuDelegate(ebike), WatchUi.SLIDE_UP);
        return true;
    }

}