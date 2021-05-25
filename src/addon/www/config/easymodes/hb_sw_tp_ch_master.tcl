#!/bin/tclsh

#Kanal-EasyMode!

source [file join $env(DOCUMENT_ROOT) config/easymodes/em_common.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/uiElements.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/options.tcl]

#Namen der EasyModes tauchen nicht mehr auf. Der Durchgängkeit werden sie hier noch definiert.
set PROFILES_MAP(0)  "Experte"
set PROFILES_MAP(1)  "TheOneAndOnlyEasyMode"

proc getCheckBox {type param value prn} {
  set checked ""
  if { $value } then { set checked "checked=\"checked\"" }
  set s "<input id='separate_$type\_$prn' type='checkbox' $checked value='dummy' name=$param/>"
  return $s
}

proc getMinValue {param} {
  global psDescr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  set min [format {%1.1f} $param_descr(MIN)]
  return "$min"
}

proc getMaxValue {param} {
  global psDescr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  set max [format {%1.1f} $param_descr(MAX)]
  return "$max"
}

proc getTextField {type param value prn} {
  global psDescr
  set elemId 'separate_$type\_$prn'
  # Limit float to 2 decimal places
  if {[llength [split $value "."]] == 2} {
    set value [format {%1.2f} $value]
  }
  set s "<input id=$elemId type=\"text\" size=\"5\" value=$value name=\"$param\" onblur=\"ProofAndSetValue(this.id, this.id, '[getMinValue $param]', '[getMaxValue $param]', 1)\"/>"


  return $s
}

proc getUnit {param} {
  global psDescr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  set unit $param_descr(UNIT)

  if {$unit == "minutes"} {
   set unit "\${lblMinutes}"
  }

  if {$unit == "K"} {
    set unit "&#176;C"
  }

  return "$unit"
}

proc getMinMaxValueDescr {param} {
  global psDescr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  set min $param_descr(MIN)
  set max $param_descr(MAX)

  # Limit float to 2 decimal places
  if {[llength [split $min "."]] == 2} {
    set min [format {%1.2f} $min]
    set max [format {%1.2f} $max]
  }
  return "($min - $max)"
}

proc getHelpIcon {topic x y} {
  set ret "<img src=\"/ise/img/help.png\" style=\"cursor: pointer; width:18px; height:18px; position:relative; top:2px\" onclick=\"showParamHelp('$topic', '$x', '$y')\">"
  return $ret
}

proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {
  global env iface_url psDescr ch_ps_descr 
  
  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/MASTER_LANG/HB-SW-TP.js');load_JSFunc('/config/easymodes/MASTER_LANG/HB-SW-TP_HELP.js');</script>"

  upvar PROFILES_MAP  PROFILES_MAP
  upvar HTML_PARAMS   HTML_PARAMS
  upvar PROFILE_PNAME PROFILE_PNAME
  upvar $pps          ps
  upvar $pps_descr    ps_descr
  
  #upvar PROFILE_0     PROFILE_0
  upvar PROFILE_1     PROFILE_1

  set CHANNEL "CHANNEL"

  set ch [lindex [split $special_input_id _] 1]                                                                                              

	
  set hlpBoxWidth 450
  set hlpBoxHeight 160

  array set psDescr [xmlrpc $iface_url($iface) getParamsetDescription [list string $address] [list string MASTER]]

  puts "<script type=\"text/javascript\">"

    puts "setTimeSelector = function(val) {"
      puts "var selHour = parseInt(val / 60);"
      puts "var selMin = val % 60;"
      puts "jQuery('#decalcHour').val(selHour).attr('selected',true);"
      puts "jQuery('#decalcMin').val(selMin).attr('selected',true);"
    puts "}"
   puts "</script>"

 

    ## Wochenprogramm ##

    append HTML_PARAMS(separate_1) "<div id=\"Timeouts_Area\" style=\"display:none\">"

    foreach day {SATURDAY SUNDAY MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY} {
      append HTML_PARAMS(separate_1) "<div id=\"level_prof_$day\"></div>"
    }
    append HTML_PARAMS(separate_1) "</div>"

    append HTML_PARAMS(separate_1) "<script type=\"text/javascript\">"
    append HTML_PARAMS(separate_1) "tom = new HBTimeoutManager('$iface', '$address');"

    foreach day {SATURDAY SUNDAY MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY} {

      for {set i 1} {$i <= 13} {incr i} {

        set timeout     $ps(ENDTIME_${day}_$i)
        set level       $ps(LEVEL_${day}_$i)
        append HTML_PARAMS(separate_1) "tom.setLevel('$day', $timeout, $level);"

        if {$timeout == 1440} then {
          break;
        }
      }

      append HTML_PARAMS(separate_1) "tom.setDivname('$day', 'level_prof_$day');"
      append HTML_PARAMS(separate_1) "tom.writeDay('$day');"
    }

    # TODO - Set the weekly program only visible while certain modes are active.
    # This has to be clarified with the developer of the device
    append HTML_PARAMS(separate_1)  "jQuery('#Timeouts_Area').show();"

    append HTML_PARAMS(separate_1) "</script>"

    ## Ende Wochenprogramm ##


  #append HTML_PARAMS(separate_0) [cmd_link_paramset $iface $address MASTER MASTER CHANNEL]
  append HTML_PARAMS(separate_1)  "<input id='separate_CHANNEL_$ch\_0' style='display:none' type='checkbox' value='dummy' />"
  append HTML_PARAMS(separate_1)  "<input id='separate_CHANNEL_$ch\_1' style='display:none' type='checkbox' value='dummy' />"
  append HTML_PARAMS(separate_1)  "<input id='separate_CHANNEL_$ch\_2' style='display:none' type='checkbox' value='dummy' />"

  append HTML_PARAMS(separate_1) "<hr class=\"CLASS10400\" />"

  append HTML_PARAMS(separate_1) "<table class=\"ProfileTbl\">"

  set prn 3
     # set param POWERUP_ACTION
     # array set param_descr $ch_ps_descr($param)
     # append HTML_PARAMS(separate_1) "<tr>"
     #   append HTML_PARAMS(separate_1) "<td>\${stringTablePowerUpAction}</td>"
     #  append HTML_PARAMS(separate_1) "<td><select id=\"separate_CHANNEL_$ch\_$i\" name=\"$param\" >"
     #   
     #     set loop 0  
     #     foreach val $param_descr(VALUE_LIST) {
     #       if {$loop == $ps($param)} {
     #         append HTML_PARAMS(separate_1) "<option selected class=\"stringtable_value\" value=\"$loop\">$val</option>"
     #       } else {
     #         append HTML_PARAMS(separate_1) "<option class=\"stringtable_value\" value=\"$loop\">$val</option>"
     #       }
     #       incr loop
     #     }
     # 
     #   append HTML_PARAMS(separate_1) "</select></td>"
     # append HTML_PARAMS(separate_1) "</tr>"
   
     # incr prn
  set param "STATUSINFO_MINDELAY"
  set min [getMinValue $param]
  set max [getMaxValue $param]
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1)  "<td>\${stringTableStatusInfoMinDelay}</td>"
    append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$ch\_$prn\" name=\"$param\" value=\"[format {%.2f} $ps($param)]\" onblur=\"ProofAndSetValue('separate_CHANNEL_$ch\_$prn','separate_CHANNEL_$ch\_$prn', '$min', '$max', 1);\"> </td>"
    append HTML_PARAMS(separate_1) "<td>[getUnit $param] [getMinMaxValueDescr $param] </td>"
  append HTML_PARAMS(separate_1) "</tr>"
  
   incr prn
  set param "STATUSINFO_RANDOM"
  set min [getMinValue $param]
  set max [getMaxValue $param]
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>\${stringTableStatusInfoRandom}</td>"
    append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$ch\_$prn\" name=\"$param\" value=\"[format {%.2f} $ps($param)]\" onblur=\"ProofAndSetValue('separate_CHANNEL_$ch\_$prn','separate_CHANNEL_$ch\_$prn', '$min', '$max', 1);\"> </td>"
    append HTML_PARAMS(separate_1) "<td>[getUnit $param] [getMinMaxValueDescr $param] </td>"
  append HTML_PARAMS(separate_1) "</tr>"
  
      incr prn
  set param "TRANSMIT_TRY_MAX"
  set min [getMinValue $param]
  set max [getMaxValue $param]
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>\${stringTableTransmitTryMax}</td>"
    append HTML_PARAMS(separate_1) "<td> <input type=\"text\" id=\"separate_CHANNEL_$ch\_$prn\" name=\"$param\" value=\"$ps($param)\" onblur=\"ProofAndSetValue('separate_CHANNEL_$ch\_$prn','separate_CHANNEL_$ch\_$prn', '$min', '$max', 1);\"> </td>"
    append HTML_PARAMS(separate_1) "<td>[getUnit $param] [getMinMaxValueDescr $param] </td>"
  append HTML_PARAMS(separate_1) "</tr>"
    

   append HTML_PARAMS(separate_1) "</table>"
  append HTML_PARAMS(separate_1) "<hr>"


}

constructor
