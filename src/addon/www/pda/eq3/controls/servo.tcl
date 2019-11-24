#!/bin/tclsh

set DPControls_GETSTATUS(SERVO.LEVEL)   [list ServoControl_getStatus]
set DPControls_GETCONTROLS(SERVO.LEVEL) [list ServoControl_getControls]
#set DPControls_GETTOPCONTROLS(SERVO.LEVEL) [list ServoControl_getTopControls]

set COMMANDS(serv180) [list ServoControl_serv180]
set COMMANDS(serv135)  [list ServoControl_serv135]
set COMMANDS(serv90)  [list ServoControl_serv90]
set COMMANDS(serv45)  [list ServoControl_serv45]
set COMMANDS(serv0)   [list ServoControl_serv0]

proc ServoControl_getStatus { channelId dataPoint } {
	array set dp $dataPoint
	
	set    script "var dpId = \"$dp(ID)\";"
	append script {
		var dp = dom.GetObject(dpId);
		var level = dp.Value() * 180;
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

proc ServoControl_getTopControls { channelId dataPoint } {
	global sid favListId favId UI_URLBASE
	set result ""
	
	append result [button "Ein"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=serv180"]
	
	return $result
}


proc ServoControl_getControls { channelId dataPoint } {
	global sid favListId favId UI_URLBASE
	set result ""
	
	append result [button "180°"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=serv180"]
	append result [button "135°" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=serv135"]
	append result [button "90°" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=serv90"]
	append result [button "45°" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=serv45"]
	append result [button "0°"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=serv0"]
	
	return $result
}

proc ServoControl_dim { channelId level } {
	set    script "var channelId = \"$channelId\";"
	append script "var level = $level;"
	append script {
		var channel = dom.GetObject(channelId);
		var dpId = channel.DPByControl("SERVO.LEVEL"); 
		var dp = dom.GetObject(dpId);
		dp.State(level);
	}
	
	rega_exec $script
}

proc ServoControl_dim180 { } {
	global fav
	ServoControl_dim $fav(ID) 1.00;
}

proc ServoControl_dim135 { } {
	global fav
	ServoControl_dim $fav(ID) 0.75;
}

proc ServoControl_dim90 { } {
	global fav
	ServoControl_dim $fav(ID) 0.50;
}

proc ServoControl_dim45 { } {
	global fav
	ServoControl_dim $fav(ID) 0.25;
}

proc ServoControl_dim0 { } {
	global fav
	ServoControl_dim $fav(ID) 0.00;
}

