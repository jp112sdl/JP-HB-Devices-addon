#!/bin/tclsh
source [file join /www/config/easymodes/em_common.tcl]


set PROFILES_MAP(0)  "Experte"
set PROFILES_MAP(1)  "TheOneAndOnlyEasyMode"


proc getHelpIcon {topic x y} {
  set ret "<img src=\"/ise/img/help.png\" style=\"cursor: pointer; width:18px; height:18px; position:relative; top:2px\" onclick=\"showParamHelp('$topic', '$x', '$y')\" />"
  return $ret
}

proc getDeviceCheckBox {param value prn} {
  set checked ""
  if { $value } then { set checked "checked=\"checked\"" }
  set s "<input id='separate_DEVICE_$prn' type='checkbox' $checked value='dummy' name=$param />"
  return $s
}

proc getDeviceComboBox {arOptions param val prn } {
  upvar $arOptions options

  set s "<select id=\"separate_DEVICE\_$prn\" name=$param />"
  foreach value [lsort -real [array names options]] {
    set selected ""
    if {$value == $val} {set selected "selected=\"selected\""}
    append s "<option value=$value $selected>$options($value)</option>"
  }
  append s "</select>"
  return $s
}

proc getDeviceTextField {param val prn} {
  global psDescr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  set minValue [format {%1.1f} $param_descr(MIN)]
  set maxValue [format {%1.1f} $param_descr(MAX)]

  set elemId 'separate_DEVICE\_$prn'
  # Limit float to 2 decimal places
  if {[llength [split $val "."]] == 2} {
    set val [format {%1.2f} $val]
  }

  set s "<input id=$elemId type=\"text\" size=\"5\" value=$val name=$param onblur=\"ProofAndSetValue(this.id, this.id, $minValue, $maxValue, 1)\" />"
  return $s
}

proc getDeviceTextFieldColor {param value prn {extraparam ""}} {

  set ident separate\_DEVICE\_$prn
  set s "<input id=\"$ident\" type=\"text\" value=$value name=$param />"

  set hsvVal [expr $value * 360 / 199]
  set saturation 100%

  if {$hsvVal > 360} { 
    set hsvVal 360
    set saturation 0%
  }
  append s "<script type=\"text/javascript\">"
  append s " jQuery(\"#$ident\").spectrum({id: \"rgbwBtnColor\_$prn\", color: \"hsv($hsvVal,$saturation,100%)\", preferredFormat: 'convert360To200', showPalette: true, showInput: false, palette: \['white'\],cancelText: translateKey('btnCancel'),chooseText: translateKey('btnOk')});"
  append s "</script>"

  return $s
}

proc getDeviceTextField100Percent {param value prn {extraparam ""}} {
  global psDescr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  set minValue [format {%1.1f} $param_descr(MIN)]
  set maxValue [format {%1.1f} $param_descr(MAX)]

  set minValue [expr $minValue * 100]
  set maxValue [expr $maxValue * 100]

  set elemIdTmp 'separate_DEVICE\_$prn\_tmp'
  set elemId 'separate_DEVICE\_$prn'

  # Limit float to 2 decimal places
  if {[llength [split $value "."]] == 2} {
    set value [format {%1.2f} $value]
  }

  set s "<input id=$elemIdTmp type=\"text\" size=\"5\" value=[format %.0f [expr $value * 100]] name=$param\_tmp onblur="
  append s "\"ProofAndSetValue(this.id, this.id, $minValue, $maxValue, 1);"
  append s "jQuery('#separate_DEVICE\_$prn').val(this.value / 100);\" />"

  append s "<input id=$elemId type=\"text\" size=\"5\" class=\"hidden\" value=$value name=$param />"
  return $s
}

proc getMinMaxValueDescr {param} {
  global psDescr dev_descr
  upvar psDescr descr
  array_clear param_descr
  array set param_descr $descr($param)
  set min $param_descr(MIN)
  set max $param_descr(MAX)

  set unit "noUnit"

  catch {set unit $param_descr(UNIT)}

  if {($unit == "100%") && ($max <= 1)} {
    set min [format %.0f [expr $min * 100]]
    set max [format %.0f [expr $max * 100]]
  }

  # Limit float to 2 decimal places
  if {[llength [split $min "."]] == 2} {
    set min [format {%1.2f} $min]
    set max [format {%1.2f} $max]
  }

  return "($min - $max)"
}


proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {
  global iface_url psDescr
  
  upvar PROFILES_MAP  PROFILES_MAP
  upvar HTML_PARAMS   HTML_PARAMS
  upvar PROFILE_PNAME PROFILE_PNAME
  upvar $pps          ps
  upvar $pps_descr    ps_descr
  
  set hlpBoxWidth 450
  set hlpBoxHeight 160

  #puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/MASTER_LANG/HB-DIS-EP-42BW_HELP.js')</script>"

  array set psDescr [xmlrpc $iface_url($iface) getParamsetDescription [list string $address] [list string MASTER]]
  array set devDescr [xmlrpc $iface_url($iface) getDeviceDescription [list string $address]]                                                       
  set DEVICE $devDescr(TYPE) 
  
  #foreach val [array names psDescr] {
  #  puts "$val: $psDescr($val)\n"
  #}
  # HB_RINGER_CHANNEL: DEFAULT 6 FLAGS 1 ID HB_RINGER_CHANNEL MAX 6 MIN 0 OPERATIONS 3 TAB_ORDER 2 TYPE ENUM UNIT {} 
  # VALUE_LIST {na {Ch.: 1} {Ch.: 2} {Ch.: 3} {Ch.: 4} {Ch.: 5} {Ch.: 6}} 
  # HB_TOUCHED_BRIGHTNESS: DEFAULT 0.000000 FLAGS 1 ID HB_TOUCHED_BRIGHTNESS MAX 1.000000 MIN 0.000000 OPERATIONS 3 TAB_ORDER 5 TYPE FLOAT UNIT 100% 
  # HB_DIMMED_BRIGHTNESS: DEFAULT 0.000000 FLAGS 1 ID HB_DIMMED_BRIGHTNESS MAX 1.000000 MIN 0.000000 OPERATIONS 3 TAB_ORDER 6 TYPE FLOAT UNIT 100% 
  # HB_BUZZER_ENABLED: DEFAULT 0 FLAGS 1 ID HB_BUZZER_ENABLED MAX 1 MIN 0 OPERATIONS 3 TAB_ORDER 0 TYPE BOOL UNIT {} 
  # HB_PRGOGRAM_HSV_COLOR: DEFAULT 0 FLAGS 1 ID HB_PRGOGRAM_HSV_COLOR MAX 255 MIN 0 OPERATIONS 3 TAB_ORDER 4 TYPE INTEGER UNIT {} 
  # TRANSMIT_DEV_TRY_MAX: DEFAULT 2 FLAGS 1 ID TRANSMIT_DEV_TRY_MAX MAX 10 MIN 1 OPERATIONS 3 TAB_ORDER 1 TYPE INTEGER UNIT {} 
  # HB_ACTIVE_HSV_COLOR: DEFAULT 0 FLAGS 1 ID HB_ACTIVE_HSV_COLOR MAX 255 MIN 0 OPERATIONS 3 TAB_ORDER 3 TYPE INTEGER UNIT {}

  #foreach val [array names devDescr] {
  #  puts "$val: $devDescr($val)\n"
  #}
  # CHILDREN: HB69303328:0 HB69303328:1 HB69303328:2 HB69303328:3 HB69303328:4 HB69303328:5 HB69303328:6 INTERFACE: MEQ1889068 
  # TYPE: HB-CDL-6 UPDATABLE: 1 FIRMWARE: 0.1 FLAGS: 1 RX_MODE: 4 PARAMSETS: MASTER PARENT: RF_ADDRESS: 3633144 ROAMING: 0 VERSION: 1 ADDRESS: HB69303328

  
  append HTML_PARAMS(separate_1) "<table class=\"ProfileTbl\">"
  set prn 1
  set param HB_BUZZER_ENABLED
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>\${stringTableHbBuzzerEnabled}</td>"
    append HTML_PARAMS(separate_1) "<td>[getDeviceCheckBox '$param' $ps($param) $prn]&nbsp;[getHelpIcon $param $hlpBoxWidth $hlpBoxHeight]</td>"
  append HTML_PARAMS(separate_1) "</tr>"

  incr prn
  set param TRANSMIT_DEV_TRY_MAX
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>\${stringTableTransmitDevTryMax}</td>"
    append HTML_PARAMS(separate_1) "<td>[getDeviceTextField $param $ps($param) $prn ]&nbsp;[getMinMaxValueDescr $param]</td>"
  append HTML_PARAMS(separate_1) "</tr>"

  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td colspan=\"3\"><hr></td>"
  append HTML_PARAMS(separate_1) "</tr>"


  incr prn
  set param HB_RINGER_CHANNEL
  append HTML_PARAMS(separate_1) "<tr>"
    array_clear options
    set options(0) "na"
    set options(1) "1"
    set options(2) "2"
    set options(3) "3"
    set options(4) "4"
    set options(5) "5"
    set options(6) "6"
    append HTML_PARAMS(separate_1) "<td>\${stringTableHbRingerChannel}</td>"
    append HTML_PARAMS(separate_1) "<td>[getDeviceComboBox options $param $ps($param) $prn ]</td>"
  append HTML_PARAMS(separate_1) "</tr>"


  incr prn
  set param HB_ACTIVE_HSV_COLOR
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>\${stringTableHbActiveHsvColor}</td>"
    append HTML_PARAMS(separate_1) "<td>[getDeviceTextFieldColor $param $ps($param) $prn ]</td>"
  append HTML_PARAMS(separate_1) "</tr>"


  incr prn
  set param HB_PRGOGRAM_HSV_COLOR
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>\${stringTableHbProgramHsvColor}</td>"
    append HTML_PARAMS(separate_1) "<td>[getDeviceTextFieldColor $param $ps($param) $prn ]</td>"
  append HTML_PARAMS(separate_1) "</tr>"


  incr prn
  set param HB_TOUCHED_BRIGHTNESS
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>\${stringTableHbTouchedBrightness}</td>"
    append HTML_PARAMS(separate_1) "<td>[getDeviceTextField100Percent $param $ps($param) $prn ]&nbsp;%&nbsp;[getMinMaxValueDescr $param]</td>"
  append HTML_PARAMS(separate_1) "</tr>"

  incr prn
  set param HB_DIMMED_BRIGHTNESS
  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>\${stringTableHbDimmedBrightness}</td>"
    append HTML_PARAMS(separate_1) "<td>[getDeviceTextField100Percent $param $ps($param) $prn ]&nbsp;%&nbsp;[getMinMaxValueDescr $param]</td>"
  append HTML_PARAMS(separate_1) "</tr>"


   
  append HTML_PARAMS(separate_1) "</tr>"
  append HTML_PARAMS(separate_1) "</table>"
}
constructor

