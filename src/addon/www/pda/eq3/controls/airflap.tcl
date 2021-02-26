#!/bin/tclsh

set DPControls_GETSTATUS(AIRFLAP.LEVEL)   [list AirflapControl_getStatus]
set DPControls_GETCONTROLS(AIRFLAP.LEVEL) [list AirflapControl_getControls]

set COMMANDS(airflap100) [list AirflapControl_pct100]
set COMMANDS(airflap75)  [list AirflapControl_pct75]
set COMMANDS(airflap50)  [list AirflapControl_pct50]
set COMMANDS(airflap25)  [list AirflapControl_pct25]
set COMMANDS(airflap0)   [list AirflapControl_pct0]

proc AirflapControl_getStatus { channelId dataPoint } {
	array set dp $dataPoint
	
	set    script "var dpId = \"$dp(ID)\";"
	append script {
		var dp = dom.GetObject(dpId);
		var level = dp.Value() * 100;
		! Nachkommastellen abschneiden:
		level = 0 + level;
		Write(level);
	}
	set level [rega_exec $script]
	if { "" == $level } { set level "0" }
	
	set    result [status_separator]
	append result {<tr><td class="status">}
	append result {<div class="caption">Stellwert</div>}
	append result "<div class=\"center\">$level %</div>"
	append result {</td></tr>}
	return $result
}

proc AirflapControl_getTopControls { channelId dataPoint } {
	global sid favListId favId UI_URLBASE
	set result ""
	
	append result [button "Ein"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=airflap100"]
	
	return $result
}


proc AirflapControl_getControls { channelId dataPoint } {
	global sid favListId favId UI_URLBASE
	set result ""
	
	append result [button "100%"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=airflap100"]
	append result [button "75%" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=airflap75"]
	append result [button "50%" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=airflap50"]
	append result [button "25%" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=airflap25"]
	append result [button "0%"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=airflap0"]
	
	return $result
}

proc AirflapControl_dim { channelId level } {
	set    script "var channelId = \"$channelId\";"
	append script "var level = $level;"
	append script {
		var channel = dom.GetObject(channelId);
		var dpId = channel.DPByControl("AIRFLAP.LEVEL"); 
		var dp = dom.GetObject(dpId);
		dp.State(level);
	}
	
	rega_exec $script
}

proc AirflapControl_pct100 { } {
	global fav
	AirflapControl_dim $fav(ID) 1.00;
}

proc AirflapControl_pct75 { } {
	global fav
	AirflapControl_dim $fav(ID) 0.75;
}

proc AirflapControl_pct50 { } {
	global fav
	AirflapControl_dim $fav(ID) 0.50;
}

proc AirflapControl_pct25 { } {
	global fav
	AirflapControl_dim $fav(ID) 0.25;
}

proc AirflapControl_pct0 { } {
	global fav
	AirflapControl_dim $fav(ID) 0.00;
}

