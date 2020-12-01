#!/bin/tclsh
source [file join /www/config/easymodes/em_common.tcl]


set PROFILES_MAP(0)  "Experte"
set PROFILES_MAP(1)  "TheOneAndOnlyEasyMode"


proc getCheckBox {param value special_input_id prn } {

  set checked ""
  if { $value } then { set checked "checked=\"checked\"" }
  set s "<input id=\"separate\_${special_input_id}\_${prn}\" type=\"checkbox\" name=\"$param\" value=\"dummy\" $checked />"
  return $s
}


proc getNumberStringBox {param value special_input_id prn} {

  set s "<input type=\"text\" value=\"$value\" name=\"$param\" size=\"8\" maxlength=\"8\" id=\"separate\_${special_input_id}\_${prn}\" />"
  return $s
}


proc getDeviceTextField4Bit {param value special_input_id prn  } {

  set elemId 'separate\_$special_input_id\_$prn'
  set elemIdTmp 'separate\_$special_input_id\_$prn\_tmp'

  set s "<input id=$elemIdTmp type=\"text\" size=\"10\" name=$param\_tmp  onblur=\"checkInput($elemIdTmp, $elemId)\" />" 
  append s "<input id=$elemId type=\"text\" size=\"10\"   name=$param />"       
  puts "<script type=\"text/javascript\">prepareValue($elemIdTmp, $elemId, $value);</script>"

  return $s
}



proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {
  global env iface_url psDescr

  upvar PROFILES_MAP  PROFILES_MAP
  upvar HTML_PARAMS   HTML_PARAMS
  upvar PROFILE_PNAME PROFILE_PNAME
  upvar $pps          ps
  upvar $pps_descr    ps_descr

  #set chn [lindex [split $special_input_id _] 1]
  #array set psDescr [xmlrpc $iface_url($iface) getParamsetDescription [list string $address] [list string MASTER]]
  
  #foreach val [array names psDescr] {
  #  puts "$val: $psDescr($val)\n"
  #}
  
  puts "<script type=\"text/javascript\">"
      puts "checkInput = function(elemIdTmp, elemId) {"
      puts "var source = document.getElementById(elemIdTmp);"
      puts "var target = document.getElementById(elemId);"
      # do conversation - encrypt
      puts "target.value = source.value;"
    puts "}"
    puts "prepareValue = function(elemIdTmp, elemId, value) {"
      puts "var source = document.getElementById(elemIdTmp);"
      puts "var target = document.getElementById(elemId);"
      puts "target.value = value;"
      # do conversation - decrypt or so
      puts "source.value = value;"
  puts "}"
  puts "</script>"


  append HTML_PARAMS(separate_1) "<table class=\"ProfileTbl\">"

  append HTML_PARAMS(separate_1) "<tr style=\"visibility: hidden; display: none;\">"
    append HTML_PARAMS(separate_1) "<td colspan=\"9\">"
      append HTML_PARAMS(separate_1) "<input type=\"hidden\" name=\"UI_HINT\" value=\"0\" id=\"separate_${special_input_id}_1\">"
      append HTML_PARAMS(separate_1) "<input type=\"hidden\" name=\"UI_DESCRIPTION\" value=\"Expertenprofil\" id=\"separate_${special_input_id}_2\">"
    append HTML_PARAMS(separate_1) "</td>"
  append HTML_PARAMS(separate_1) "</tr>"

  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td>Kanal&nbsp;</td>"
    append HTML_PARAMS(separate_1) "<td align=center>1</td>"
    append HTML_PARAMS(separate_1) "<td align=center>2</td>"
    append HTML_PARAMS(separate_1) "<td align=center>3</td>"
    append HTML_PARAMS(separate_1) "<td align=center>4</td>"
    append HTML_PARAMS(separate_1) "<td align=center>5</td>"
    append HTML_PARAMS(separate_1) "<td align=center>6</td>"
    append HTML_PARAMS(separate_1) "<td>&nbsp;</td>"
    append HTML_PARAMS(separate_1) "<td>PIN Nummer</td>"
  append HTML_PARAMS(separate_1) "</tr>"

  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td></td>"

    set param HB_LINK_CHANNEL_1_1
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 3]</td>" 

    set param HB_LINK_CHANNEL_1_2
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 4]</td>" 

    set param HB_LINK_CHANNEL_1_3
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 5]</td>" 

    set param HB_LINK_CHANNEL_1_4
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 6]</td>" 

    set param HB_LINK_CHANNEL_1_5
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 7]</td>" 

    set param HB_LINK_CHANNEL_1_6
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 8]</td>" 
    append HTML_PARAMS(separate_1) "<td>&nbsp;</td>"

    set param HB_PASSWORD_1
    #append HTML_PARAMS(separate_1) "<td>[getDeviceTextField4Bit $param $ps($param) $special_input_id 9]</td>" 
    append HTML_PARAMS(separate_1) "<td>[getNumberStringBox $param $ps($param) $special_input_id 9]</td>" 
  append HTML_PARAMS(separate_1) "</tr>"

  append HTML_PARAMS(separate_1) "<tr>"
    append HTML_PARAMS(separate_1) "<td></td>"

    set param HB_LINK_CHANNEL_2_1
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 10]</td>" 

    set param HB_LINK_CHANNEL_2_2
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 11]</td>" 

    set param HB_LINK_CHANNEL_2_3
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 12]</td>" 

    set param HB_LINK_CHANNEL_2_4
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 13]</td>" 

    set param HB_LINK_CHANNEL_2_5
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 14]</td>" 

    set param HB_LINK_CHANNEL_2_6
    append HTML_PARAMS(separate_1) "<td>[getCheckBox $param $ps($param) $special_input_id 15]</td>" 
    append HTML_PARAMS(separate_1) "<td>&nbsp;</td>"

    set param HB_PASSWORD_2
    append HTML_PARAMS(separate_1) "<td>[getNumberStringBox $param $ps($param) $special_input_id 16]</td>" 
  append HTML_PARAMS(separate_1) "</tr>"

  append HTML_PARAMS(separate_1) "</tr>"
  append HTML_PARAMS(separate_1) "</table>"
}
constructor

