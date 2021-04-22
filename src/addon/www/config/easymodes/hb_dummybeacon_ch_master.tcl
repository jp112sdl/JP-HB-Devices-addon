#!/bin/tclsh
source [file join $env(DOCUMENT_ROOT) config/easymodes/em_common.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/EnterFreeValue.tcl]

proc getHelpIcon {topic x y} {
  set ret "<img src=\"/ise/img/help.png\" style=\"cursor: pointer; width:24px; height:24px; position:relative; top:2px\" onclick=\"showParamHelp('$topic', '$x', '$y')\">"
  return $ret
}

proc getMinValue {ps_descr param} {
  upvar ps_descr descr
  array_clear param_descr
  array set param_descr $descr($param)
  return $param_descr(MIN)
}

proc getMaxValue {ps_descr param} {
  upvar ps_descr descr
  array_clear param_descr
  array set param_descr $descr($param)
  return $param_descr(MAX)
}

proc getMinMaxValueDescr {ps_descr param} {
  upvar ps_descr descr 
  array_clear param_descr
  array set param_descr $descr($param)
  set min $param_descr(MIN)
  set max $param_descr(MAX)

  return "($min - $max)" 
}

proc getUnit {ps_descr param} {
  upvar ps_descr descr 
  array_clear param_descr
  array set param_descr $descr($param)
  set unit $param_descr(UNIT)
  return "$unit"
}

proc getCheckBox {param value chn prn} {
  set checked ""
  if { $value } then { set checked "checked=\"checked\"" }
  set s "<input id='separate_CHANNEL\_$chn\_$prn' type='checkbox' $checked value='dummy' name=$param>"
  return $s
}

proc get_devicenames {allDevices dummydeviceAddress} {
  global ise_CHANNELNAMES iface_url iface
  
  set url $iface_url($iface)
  
  set dummydeviceAddr [lindex [split $dummydeviceAddress ":"] 0]  
  set _iface [string tolower $iface]
  array_clear result 

  foreach val $allDevices {
    array set devDescr $val
    if {($devDescr(ADDRESS) != $dummydeviceAddr ) &&  ($devDescr(PARENT) == "") } {
      set name [string tolower $ise_CHANNELNAMES($iface;$devDescr(ADDRESS))]   
      if { [string first $_iface $name] == -1} {
        set result($devDescr(ADDRESS)) $ise_CHANNELNAMES($iface;$devDescr(ADDRESS))
      }
    }
  }
  return [array get result]
}

proc get_devname { address } {  
  set rega_cmd ""
  append rega_cmd "string devName = '$address';"
  append rega_cmd "string dev_id;"
  append rega_cmd "foreach(dev_id, dom.GetObject(ID_DEVICES).EnumUsedIDs()){"
  append rega_cmd "object dev=dom.GetObject(dev_id);"
  append rega_cmd "if (dev.Address() == devName) { devName = dev.Name(); }"
  append rega_cmd "}"
  
  array set result [rega_script $rega_cmd]
  return $result(devName);
}

proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {
  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/js/DummyBeacon.js');</script>"
  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/js/DummyBeaconHelp.js');</script>"

  global iface_url

  upvar PROFILES_MAP  PROFILES_MAP
  upvar HTML_PARAMS   HTML_PARAMS
  upvar PROFILE_PNAME PROFILE_PNAME
  upvar $pps          ps
  upvar $pps_descr  ps_descr
  
  set url $iface_url($iface)

  set comment {
    foreach val [array names ps] {
      puts "$val: $ps($val)<br/>"
    }
    foreach val [array names ps_descr] {
      puts "$val: $ps_descr($val)<br/>"
    }

    puts "<br/><br/>"
  }

  set allDevices [xmlrpc $url listDevices]
  set chn [lindex [split $special_input_id _] 1]                                                                                              
  set paramCount 0
  set senderRF "" 
  array_clear devnames
  array set devnames [get_devicenames $allDevices $address] 
  array set ccuDescr [xmlrpc $url getDeviceDescription [list string "BidCoS-RF"]]
  
  append HTML_PARAMS(separate_1) "<table class=\"ProfileTbl\">"

  append HTML_PARAMS(separate_1) "<tr>"
  append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableFdSimulate}</td>"
  append HTML_PARAMS(separate_1) "<td><select class=\"select\_$chn\" id=\"deviceSelectionBox\_$chn\" onchange=\"setDevice(this, $chn)\">"
  append HTML_PARAMS(separate_1) "<option id='$chn\_0' value='0'>-&nbsp;nicht&nbsp;belegt&nbsp;-</option>"

  foreach name [array names devnames] {
    array set parentDescr [xmlrpc $url getDeviceDescription [list string $name]]
    set senderRF     $parentDescr(RF_ADDRESS)
    set senderSERIAL $parentDescr(ADDRESS)
    set senderNAME   [get_devname $senderSERIAL]
    if {$senderRF != $ccuDescr(RF_ADDRESS)} {   
      append HTML_PARAMS(separate_1) "<option id='$chn\_$senderRF' value='$senderRF'>$senderNAME ($senderSERIAL)</option>"
    }
  }
  append HTML_PARAMS(separate_1) "</select></td>"
    append HTML_PARAMS(separate_1) "<td class=\"HEXADDR\_$chn j_param_$chn\"></td>"
  append HTML_PARAMS(separate_1) "</tr>"

  incr paramCount
  set param "ADDRESS_SENDER_HIGH_BYTE"
  append HTML_PARAMS(separate_1) "<input class=\"$param\_$chn\" type=\"text\" id=\"separate_CHANNEL_$chn\_$paramCount\" name=\"$param\" value=\"$ps($param)\" >"

  incr paramCount
  set param "ADDRESS_SENDER_MID_BYTE"
  append HTML_PARAMS(separate_1) "<input class=\"$param\_$chn\" type=\"text\" id=\"separate_CHANNEL_$chn\_$paramCount\" name=\"$param\" value=\"$ps($param)\" >"

  incr paramCount
  set param "ADDRESS_SENDER_LOW_BYTE"
  append HTML_PARAMS(separate_1) "<input class=\"$param\_$chn\" type=\"text\" id=\"separate_CHANNEL_$chn\_$paramCount\" name=\"$param\" value=\"$ps($param)\" >"

  incr paramCount
  set param            "FD_CYCLIC_TIMEOUT"
  set minCyclicTimeout 60
  append HTML_PARAMS(separate_1) "<tr class=\"j_param_$chn\">"
    append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableFdSimulateDeviceType}</td>"
    append HTML_PARAMS(separate_1) "<td><select class=\"selectDeviceType\_$chn j_param_$chn\" id=\"deviceTypeSelectionBox\_$chn\" onchange=\"setDeviceType(this, $chn, parseInt([getMinValue ps_descr $param]))\">"
      append HTML_PARAMS(separate_1) "<option id='DeviceType\_$chn\_0' value='0'>\${stringTableFdSimulateDeviceTypeActuator}</option>"
      append HTML_PARAMS(separate_1) "<option id='DeviceType\_$chn\_1' value='1'>\${stringTableFdSimulateDeviceTypeSensor}</option>"
    append HTML_PARAMS(separate_1) "</select></td>"
    append HTML_PARAMS(separate_1) "<td></td><td>[getHelpIcon FD_DEVICE_TYPE 500 110]</td>"
  append HTML_PARAMS(separate_1) "</tr>"

  append HTML_PARAMS(separate_1) "<tr class=\"j_sens_param_$chn\">"
    append HTML_PARAMS(separate_1) "<td class=\"j_sens_param_$chn stringtable_value\">\${stringTableFdSendEvery}</td>"
    append HTML_PARAMS(separate_1) "<td class=\"j_sens_param_$chn\"><input class=\"$param\_$chn\" type=\"text\" style=\"width: 64px;\" id=\"separate_CHANNEL_$chn\_$paramCount\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$paramCount','separate_CHANNEL_$chn\_$paramCount',  (document.getElementById('deviceTypeSelectionBox_'+$chn).value != '0' ) ? '$minCyclicTimeout'  : '0' , '[getMaxValue ps_descr $param]', 1);\"> </td>"
    append HTML_PARAMS(separate_1) "<td class=\"j_sens_param_$chn\">[getUnit ps_descr $param] <i>$minCyclicTimeout - [getMaxValue ps_descr $param]</i></td>"
    append HTML_PARAMS(separate_1) "<td>[getHelpIcon $param 500 140]</td>"
  append HTML_PARAMS(separate_1) "</tr>"
    
  incr paramCount
  set param "FD_STATUS"
  append HTML_PARAMS(separate_1) "<tr class=\"j_sens_param_$chn\">"
    append HTML_PARAMS(separate_1) "<td class=\"j_sens_param_$chn stringtable_value\">den \${stringTableFdStatus}</td>"
    append HTML_PARAMS(separate_1) "<td class=\"j_sens_param_$chn\"> <input type=\"text\" style=\"width: 40px;\" id=\"separate_CHANNEL_$chn\_$paramCount\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$paramCount','separate_CHANNEL_$chn\_$paramCount', '[getMinValue ps_descr $param]', '[getMaxValue ps_descr $param]', 1);\"> </td>"
    append HTML_PARAMS(separate_1) "<td class=\"j_sens_param_$chn\">[getUnit ps_descr $param] <i>[getMinMaxValueDescr ps_descr $param]</i></td>"
  append HTML_PARAMS(separate_1) "</tr>"
  
  incr paramCount
  set param "FD_BROADCAST"
  append HTML_PARAMS(separate_1) "<tr class=\"j_sens_param_$chn\">"
    append HTML_PARAMS(separate_1) "<td class=\"j_sens_param_$chn stringtable_value\">\${stringTableFdBroadcast}</td>"
    append HTML_PARAMS(separate_1) "<td class=\"j_sens_param_$chn\">[getCheckBox '$param' $ps($param) $chn $paramCount]</td>"
  append HTML_PARAMS(separate_1) "</tr>"
    
  append HTML_PARAMS(separate_1) "</table>"
  
  puts "<script type=\"text/javascript\">init($chn);</script>"
}
constructor