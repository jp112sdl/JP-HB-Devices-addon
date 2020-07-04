#!/bin/tclsh

set DPControls_GETSTATUS(FAN.LEVEL)   [list FanControl_getStatus]
set DPControls_GETCONTROLS(FAN.LEVEL) [list FanControl_getControls]
#set DPControls_GETTOPCONTROLS(FAN.LEVEL) [list FanControl_getTopControls]

set COMMANDS(dim100) [list FanControl_dim100]
set COMMANDS(dim75)  [list FanControl_dim75]
set COMMANDS(dim50)  [list FanControl_dim50]
set COMMANDS(dim25)  [list FanControl_dim25]
set COMMANDS(dim0)   [list FanControl_dim0]

proc FanControl_getStatus { channelId dataPoint } {
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
	append result {<div class="caption">Dimmwert</div>}
	append result "<div class=\"center\">$level %</div>"
	append result {</td></tr>}
	return $result
}

proc FanControl_getTopControls { channelId dataPoint } {
	global sid favListId favId UI_URLBASE
	set result ""
	
	append result [button "Ein"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=dim100"]
	
	return $result
}


proc FanControl_getControls { channelId dataPoint } {
	global sid favListId favId UI_URLBASE
	set result ""
	
	append result [button "Ein"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=dim100"]
	append result [button "75 %" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=dim75"]
	append result [button "50 %" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=dim50"]
	append result [button "25 %" "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=dim25"]
	append result [button "Aus"  "$UI_URLBASE/fav.cgi?sid=$sid&uiStyle=[getUIStyle]&favListId=$favListId&favId=$favId&cmd=dim0"]
	
	return $result
}

proc FanControl_dim { channelId level } {
	set    script "var channelId = \"$channelId\";"
	append script "var level = $level;"
	append script {
		var channel = dom.GetObject(channelId);
		var dpId = channel.DPByControl("FAN.LEVEL"); 
		var dp = dom.GetObject(dpId);
		dp.State(level);
	}
	
	rega_exec $script
}

proc FanControl_dim100 { } {
	global fav
	FanControl_dim $fav(ID) 1.00;
}

proc FanControl_dim75 { } {
	global fav
	FanControl_dim $fav(ID) 0.75;
}

proc FanControl_dim50 { } {
	global fav
	FanControl_dim $fav(ID) 0.50;
}

proc FanControl_dim25 { } {
	global fav
	FanControl_dim $fav(ID) 0.25;
}

proc FanControl_dim0 { } {
	global fav
	FanControl_dim $fav(ID) 0.00;
}
