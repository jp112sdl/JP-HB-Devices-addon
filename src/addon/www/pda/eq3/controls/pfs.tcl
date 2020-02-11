#!/bin/tclsh

set DPControls_GETSTATUS(PFS.STATE) [list PFSControl_getStatus]

proc PFSControl_getStatus { channelId dataPoint } {
	array set dp $dataPoint
	
	set script "var dpId = \"$dp(ID)\";"
	append script {
		var dp = dom.GetObject(dpId);
		Write(dp.Value());
	}
	
	switch -exact -- [rega_exec $script] {
		0       { set status "Geschlossen" }
		1       { set status "Offen-ausgangs" }
		2       { set status "Offen-eingangs" }
		default { set status "unbekannt" }
	}
	
	set    result [status_separator]
	append result {<tr><td class="status">}
	append result {<div class="caption">Status</div>}
	append result "<div class=\"center\">$status</div>"
	append result {</td></tr>}
	return $result

}