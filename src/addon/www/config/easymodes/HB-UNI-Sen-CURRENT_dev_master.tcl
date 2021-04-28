#!/bin/tclsh
source [file join /www/config/easymodes/em_common.tcl]

proc getHelpIcon {topic x y} {
  set ret "<img src=\"/ise/img/help.png\" style=\"cursor: pointer; width:24px; height:24px; position:relative; top:2px\" onclick=\"showParamHelp('$topic', '$x', '$y')\">"
  return $ret
}

proc getCheckBox {param value prn} {
  set checked ""
  if { $value } then { set checked "checked=\"checked\"" }
  set s "<input id='separate_DEVICE_$prn' type='checkbox' $checked value='dummy' name=$param/>"
  return $s
}

proc getComboBox {arOptions prn param val} {
  upvar $arOptions options
  set s "<select  id=\"separate_DEVICE\_$prn\" name=$param onchange=\"powerSupplyHasChanged(this)\">"
  #set s "<select id=\"separate_DEVICE\_$prn\" name=$param>"
  foreach value [lsort -real [array names options]] {
    set selected ""
    if {$value == $val} {set selected "selected=\"selected\""}
    append s "<option value=$value $selected>$options($value)</option>"
  }
  append s "</select>"
  return $s
}

proc getComboBox1 {arOptions prn param val} {
  upvar $arOptions options

  set s "<select id=\"separate_DEVICE\_$prn\" name=$param>"
  foreach value [lsort -real [array names options]] {
    set selected ""
    if {$value == $val} {set selected "selected=\"selected\""}
    append s "<option value=$value $selected>$options($value)</option>"
  }
  append s "</select>"
  return $s
}

proc getMinMaxValueDescr {param} {
  global psDescr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  set min $param_descr(MIN)
  set max $param_descr(MAX)

  # Limit float to 1 decimal places
  if {[llength [split $min "."]] == 2} {
    set min [format {%1.1f} $min]
    set max [format {%1.1f} $max]
  }
  return "($min - $max)"
}

proc getTextField {prn param val} {
  global psDescr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  
  if {[llength [split $param_descr(MIN) "."]] == 2} {
    set minValue [format {%1.1f} $param_descr(MIN)]
    set maxValue [format {%1.1f} $param_descr(MAX)]
  } else {
    set minValue $param_descr(MIN)
    set maxValue $param_descr(MAX)
  }

  set elemId 'separate_DEVICE\_$prn'
  # Limit float to 1 decimal places
  if {[llength [split $val "."]] == 2} {
    set val [format {%1.1f} $val]
  }

  set s "<input id=$elemId type=\"text\" size=\"5\" value=$val name=$param onblur=\"ProofAndSetValue(this.id, this.id, '$minValue', '$maxValue', 1)\">"
  return $s
}

proc displayFields {id mode} {
  # mode can be 'show' or 'hide' 
  if {$mode != "hide"} {
    set mode "show"
  }
  puts "<script type=\"text/javasscript\">"
    #puts "\$\$(\".j_custom\").invoke('$mode');"
    puts "\$\$(\"$id\").invoke('$mode');"
  puts "</script>"
}

proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {
  set hlpBoxWidth  350
  set hlpBoxHeight  70

  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/js/HB-UNI-Sen-CURRENT_HELP.js')</script>"
  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/js/HBCurrentSensor.js');</script>"
  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/MASTER_LANG/HM_ES_PMSw.js');</script>"

  global iface_url psDescr
  
  upvar PROFILES_MAP  PROFILES_MAP
  upvar HTML_PARAMS   HTML_PARAMS
  upvar PROFILE_PNAME PROFILE_PNAME
  upvar $pps          ps


  array set psDescr [xmlrpc $iface_url($iface) getParamsetDescription [list string $address] [list string MASTER]]
  array set devDescr [xmlrpc $iface_url($iface) getDeviceDescription [list string $address]]                                                       
  set DEVICE $devDescr(TYPE) 
  
  append HTML_PARAMS(separate_1) "<table class=\"ProfileTbl\">"
  set prn 1

  set param POWER_SUPPLY
  set selectedPowerSupply $ps($param)
  append HTML_PARAMS(separate_1) "<tr>"
    array_clear options
    set options(0) "\${stringTableMainsPowered}"
    set options(1) "\${stringTableBatteryPowered}"
    append HTML_PARAMS(separate_1) "<td>\${stringTablePowerSupply}</td>"
    append HTML_PARAMS(separate_1) "<td>[getComboBox options $prn '$param' $ps($param)]</td>"
  append HTML_PARAMS(separate_1) "</tr>"

  incr prn     
  set param LOW_BAT_LIMIT
    append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_lowbat\">"
      append HTML_PARAMS(separate_1) "<td>\${stringTableBatteryLowBatLimit}</td>"
      append HTML_PARAMS(separate_1) "<td>[getTextField $prn $param $ps($param)]&nbsp;V&nbsp;[getMinMaxValueDescr $param]</td>"
    append HTML_PARAMS(separate_1) "</tr>"

    append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_currentsensor\"><td colspan=\"100%\"><hr/></td></tr>"    

  incr prn                       
  set param HB_MEASURE_INTERVAL       
  append HTML_PARAMS(separate_1) "<tr>"  
    append HTML_PARAMS(separate_1) "<td>\${stringTableHBMeasureInterval}</td>"  
    append HTML_PARAMS(separate_1) "<td>[getTextField $prn $param $ps($param)]&nbsp;s&nbsp;[getMinMaxValueDescr $param]</td>"  
  append HTML_PARAMS(separate_1) "</tr>"  
  
  incr prn                       
  set param HBWEA_TRANSMIT_INTERVAL       
  append HTML_PARAMS(separate_1) "<tr>"  
    append HTML_PARAMS(separate_1) "<td>\${stringTableHbWeaTransmitInterval} alle</td>"  
    append HTML_PARAMS(separate_1) "<td>[getTextField $prn $param $ps($param)]&nbsp;Messungen&nbsp;[getMinMaxValueDescr $param]</td>"  
    append HTML_PARAMS(separate_1) "<td>[getHelpIcon $param $hlpBoxWidth $hlpBoxHeight]</td>"
  append HTML_PARAMS(separate_1) "</tr>"  
  
  incr prn                       
  set param BACKLIGHT_ON_TIME       
  append HTML_PARAMS(separate_1) "<tr>"  
    append HTML_PARAMS(separate_1) "<td>\${stringTableDisplayBacklightTime}</td>"  
    append HTML_PARAMS(separate_1) "<td>[getTextField $prn $param $ps($param)]&nbsp;s&nbsp;[getMinMaxValueDescr $param]</td>"  
    append HTML_PARAMS(separate_1) "<td>[getHelpIcon $param $hlpBoxWidth $hlpBoxHeight]</td>"
  append HTML_PARAMS(separate_1) "</tr>"  
  
  incr prn                       
  set param HB_CONDITIONCHECK_AVERAGE
  append HTML_PARAMS(separate_1) "<tr>"
    array_clear options
    set options(0) "\${stringTableHBCheckEachMeasure}"
    set options(1) "\${stringTableHBCheckAverage}"
    append HTML_PARAMS(separate_1) "<td>\${stringTableHBConditionCheckAverage}</td>"
    append HTML_PARAMS(separate_1) "<td>[getComboBox1 options $prn '$param' $ps($param)]</td>"
  append HTML_PARAMS(separate_1) "</tr>"
  
  append HTML_PARAMS(separate_1) "</table>"

  switch $selectedPowerSupply {
    0	{displayFields ".j_lowbat" "hide"}
  }

}
constructor