#!/bin/tclsh

# dev_descr_sender(TYPE) enthaelt den Sendertype (KEY, WATERDETECTIONSENSOR usw.)

global dev_descr_receiver dev_descr_sender sender_group 

set  pair ""
set mem "HB"

if {$sender_group != ""} {set pair "_PAIR"}

set multilingual 1
set ACTOR $dev_descr_receiver(TYPE)
append ACTOR $mem

catch {puts "<input type=\"hidden\" id=\"dev_descr_sender_tmp\" value=\"$dev_descr_sender(TYPE)$pair-$dev_descr_sender(PARENT)\">"} 
catch {puts "<input type=\"hidden\" id=\"dev_descr_receiver_tmp\" value=\"$ACTOR\">"} 

if {[catch {set x $dev_descr_sender(TYPE)$pair}] == 0} {
	
	if {[catch {source [file join $env(DOCUMENT_ROOT) config/easymodes/$ACTOR/$x.tcl]}] != 0} {
		catch {source [file join $env(DOCUMENT_ROOT) config/easymodes/NO_PROFILE.tcl]}
	}

} else {
	
	if {[catch {source [file join $env(DOCUMENT_ROOT) config/easymodes/$ACTOR/$dev_descr_sender_tmp.tcl]}] != 0} {
		catch {source [file join $env(DOCUMENT_ROOT) config/easymodes/NO_PROFILE.tcl]}
	}
}


