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


  if {($param == "HB_METER_CONSTANT_WATER")  || ($param == "HB_COUNT_INITIAL_VALUE") } {
    set min [format {%.3f} $min]
    set max [format {%.3f} $max]
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

proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {

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

    set param "HB_METER_CONSTANT_WATER"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableHbMeterConstantWater}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"[format {%.3f} $ps($param)]\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', $min, $max, 1);\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
    
    append HTML_PARAMS(separate_1) "<tr class=\"\"><td colspan=\"100%\"><hr/></td></tr>"    

    incr prn
    set param "HB_COUNT_INITIAL_VALUE"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableHbCountInitialValue}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"[format {%.3f} $ps($param)]\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', $min, $max, 1);\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
    
    append HTML_PARAMS(separate_1) "<tr class=\"\"><td colspan=\"100%\"><hr/></td></tr>"    

    incr prn
    set param "HB_ANALOG_LOW_THRESHOLD"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableHbAnalogLowThreshold}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', '$min', '$max', 1);\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
     
    incr prn
    set param "HB_ANALOG_HIGH_THRESHOLD"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableHbAnalogHighThreshold}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', '$min', '$max', 1);\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
    
    incr prn
    set param "HB_PULSE_DELAY_MS"
    set min [getMinValue ps_descr $param]
    set max [getMaxValue ps_descr $param]
    append HTML_PARAMS(separate_1) "<tr class=\"\">"
      append HTML_PARAMS(separate_1) "<td class=\"stringtable_value\">\${stringTableHbPulseDelayMS}</td>"
      append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$chn\_$prn\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$chn\_$prn','separate_CHANNEL_$chn\_$prn', '$min', '$max', 1);\"> </td>"
      append HTML_PARAMS(separate_1) "<td>[getUnit ps_descr $param] [getMinMaxValueDescr ps_descr $param] </td>"
    append HTML_PARAMS(separate_1) "</tr>"
    
    incr prn
    set param "HB_CHANGE_MODE"                                                            
    append HTML_PARAMS(separate_1) "<tr>"
      array_clear options
      set options(0) "bei Wechsel von dunkel > hell"
      set options(1) "bei Wechsel von hell > dunkel"
      set options(2) "beide Wechsel"
      append HTML_PARAMS(separate_1) "<td>\${stringTableHbChangeMode} </td>"
      set cmb $chn                                                                                                                                
      append cmb $prn  
      append HTML_PARAMS(separate_1) "<td>[get_ComboBox options $param separate_CHANNEL_$chn\_$prn ps $param]</td>"
    append HTML_PARAMS(separate_1) "</tr>"
   append HTML_PARAMS(separate_1) "</table>"

}
constructor