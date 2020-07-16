#!/bin/tclsh

source [file join $env(DOCUMENT_ROOT) config/easymodes/em_common.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/EnterFreeValue.tcl]


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


  if {($param == "COND_TX_THRESHOLD_HI")  || ($param == "COND_TX_THRESHOLD_LO") } {
    set min [format {%.2f} $min]
    set max [format {%.2f} $max]
  }

  return "($min - $max)" 
}

proc getUnit {ps_descr param} {
  upvar ps_descr descr 
  array_clear param_descr
  array set param_descr $descr($param)
  set unit $param_descr(UNIT)
  return "$unit"
}

proc setSelectedSensorType {selSensorType elmID} {
  puts "<script type=\"text/javasscript\">"
    puts "var options = \$\$('select#$elmID option');"
                                            
   puts "options\[$selSensorType\].selected = true;"
  puts "</script>"               
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
  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/js/HBCurrentSensor.js');</script>"

  global iface_url

  upvar PROFILES_MAP  PROFILES_MAP
  upvar HTML_PARAMS   HTML_PARAMS
  upvar PROFILE_PNAME PROFILE_PNAME
  upvar $pps          ps
  upvar $pps_descr  ps_descr
  
  set url $iface_url($iface)
  set devType "HB_GENERIC"

  set comment {
    foreach val [array names ps] {
      puts "$val: $ps($val)<br/>"
    }
    foreach val [array names ps_descr] {
      puts "$val: $ps_descr($val)<br/>"
    }

    puts "<br/><br/>"
  }

  set chn [lindex [split $special_input_id _] 1]                                                                                              


  append HTML_PARAMS(separate_1) "<table class=\"ProfileTbl\">"

    set prn 1

    set param "SENSOR_TYPE"                                                            
    append HTML_PARAMS(separate_1) "<tr>"
      array_clear options
      set options(0) "SCT-013-015"
      set options(1) "SCT-013-020"
      set options(2) "SCT-013-030"
      set options(3) "SCT-013-050"
      set options(4) "SCT-013-100"
      set options(4) "INA219"
      set options(4) "ACS712 or other"
      append HTML_PARAMS(separate_1) "<td>\${stringTableHbGenericDistSensorType} </td>"
      set cmb $chn                                                                                                                                
      append cmb $prn  
      append HTML_PARAMS(separate_1) "<td>[get_ComboBox options $param separate_CHANNEL_$chn\_$prn ps $param]</td>"
    append HTML_PARAMS(separate_1) "</tr>"

    incr prn
    set param "SAMPLE_TIME"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_currentsensor\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableHBSampleTime}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', parseInt($min), parseInt($max), parseFloat(1));\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
    
    append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_currentsensor\"><td colspan=\"100%\"><hr/></td></tr>"    

    incr prn
    set param "COND_TX_THRESHOLD_HI"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_currentsensor\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableCondThresholdHi}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"[format {%.2f} $ps($param)]\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', parseInt($min), parseInt($max), parseFloat(1));\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
    
    incr prn
    set param "COND_TX_DECISION_ABOVE"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_currentsensor\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableCondTxDecisionAbove}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', parseInt($min), parseInt($max), parseFloat(1));\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"


   append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_currentsensor\"><td colspan=\"100%\"><hr/></td></tr>"    
    
    incr prn
    set param "COND_TX_THRESHOLD_LO"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_currentsensor\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableCondThresholdLo}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"[format {%.2f} $ps($param)]\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', parseInt($min), parseInt($max), parseFloat(1));\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
    
    incr prn
    set param "COND_TX_DECISION_BELOW"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"j_custom j_currentsensor\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableCondTxDecisionBelow}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', parseInt($min), parseInt($max), parseFloat(1));\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
    
   append HTML_PARAMS(separate_1) "</table>"

}
constructor