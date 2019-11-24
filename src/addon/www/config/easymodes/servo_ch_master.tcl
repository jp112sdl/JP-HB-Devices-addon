#!/bin/tclsh

# dev_descr(TYPE) enthaelt den Sendertype (KEY, WATERDETECTIONSENSOR usw.)

proc isLongKeyPressAvailable {} {
  return 1
}

global env dev_descr internalKey iface iface_url

set internalKey 1
set longKeyPressAvailable 0
set addr $dev_descr(ADDRESS)

## array set paramSet [xmlrpc $iface_url($iface) getParamset [list string $addr] [list string MASTER]]

# check if long keypress is available
## catch {set longKeyPressAvailable $paramSet(CONF_BUTTON_TIME)}


#puts "longKeyPressAvailable: [isLongKeyPressAvailable]<br/>"

set longKeyPressAvailable [isLongKeyPressAvailable]
	
if {$longKeyPressAvailable == 1} { 
  puts "<input type=\"hidden\" id=\"dev_descr_sender_tmp\" value=\"SERVO-$addr\">" 
  puts "<input type=\"hidden\" id=\"dev_descr_receiver_tmp\" value=\"SERVO\">" 
  source [file join $env(DOCUMENT_ROOT) config/easymodes/SERVO/SERVO.tcl]  
} else {
  # Dimmer without long keypress      
  puts "<input type=\"hidden\" id=\"dev_descr_sender_tmp\" value=\"SERVO_woLongKeyPress-$addr\">" 
  puts "<input type=\"hidden\" id=\"dev_descr_receiver_tmp\" value=\"SERVO_woLongKeyPress\">" 
  source [file join $env(DOCUMENT_ROOT) config/easymodes/SERVO_woLongKeyPress/SERVO_woLongKeyPress.tcl]  
}

