using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Activity;
using Toybox.ActivityMonitor;

class ebikeBatteryLevel extends WatchUi.Drawable {

	const PENWIDTH      = 5;

    private var radius, centerX, centerY, minX, minY, maxX, maxY = 0;
    private var ebike = null;
    private var fontHeight = 0;
    private var hrValues = [ 0,0,0,0,0 ];
	private var index = 0; 
	function initialize() {
		Drawable.initialize({ :identifier => "batteryLevel" });
    }
    
    function setData(theBike){
	    ebike = theBike;
    }

	function draw(dc) {
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.clear();
		if (maxY == 0){
	        minX = 0;
	    	maxX = dc.getWidth(); 
	    	minY = 0;
	    	maxY = dc.getHeight(); 
	        centerX = ( ( maxX - minX ) / 2 ) + minX;
	        centerY = ( ( maxY - minY ) / 2 ) + minY;
	        radius = centerX > centerY ? centerY : centerX;
        }
        fontHeight = Graphics.getFontHeight(Graphics.FONT_SYSTEM_LARGE);
		drawBatteryLevel(dc);	
	}
	
	/***********************************************************************************/
    // 12 o'clock is 100 and 0 %; 100% is full circle; 
    /***********************************************************************************/
    function drawBatteryLevel(dc) {
        var batteryPercentage = 0;
        if (ebike != null && ebike.batteryValue >= 0){
        	batteryPercentage = ebike.batteryValue; // System.getSystemStats().battery;
        }
        if ( batteryPercentage > ebike.batLvlGreen ) {
        	dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
        	
        } else if ( batteryPercentage > ebike.batLvlYellow ) {
        	dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_YELLOW);
        	
        } else if ( batteryPercentage > ebike.batLvlRed ) {
        	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        	
        } else {
        	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        }
    	var endAngle =  90 - (batteryPercentage * 3.60);
    	if ( endAngle < 0 ) {
    		endAngle = 360 + endAngle;
    	}
    	dc.setPenWidth(PENWIDTH);
     	dc.drawArc(centerX, centerY, radius - PENWIDTH, Graphics.ARC_CLOCKWISE, 90, endAngle );
     	
        var time = Time.now();
        var clockTime  = Gregorian.info(time, Time.FORMAT_SHORT);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var text = Lang.format("$1$:$2$:$3$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);
        dc.drawText(centerX, centerY-fontHeight, Graphics.FONT_SYSTEM_LARGE, text , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
     	
     	index++;
     	if ( index >= 5 ){ index = 0; }
	    var heartRate = Activity.getActivityInfo().currentHeartRate;
	    if (heartRate != null && heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
	    	hrValues[index] = heartRate;
	    }
        heartRate = (hrValues[0] + hrValues[1] + hrValues[2] + hrValues[3] + hrValues[4])/5;
		dc.drawText(centerX, centerY+fontHeight, Graphics.Graphics.FONT_SYSTEM_LARGE, heartRate.toString() + " HR" , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);         	

    }
		
}
