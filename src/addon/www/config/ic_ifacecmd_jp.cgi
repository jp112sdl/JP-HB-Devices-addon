#!/bin/tclsh
source once.tcl
sourceOnce cgi.tcl
sourceOnce session.tcl
sourceOnce ic_common.tcl
loadOnce tclrpc.so

#Datenbank der Geraetebeschreibungen fuers WebUI
sourceOnce devdescr/DEVDB.tcl 
  
set cmd ""

proc cmd_SendInternalKeyPressNoPopup {} {
  global iface_url
  catch {import iface}
  catch {import sender}
  catch {import receiver}
  catch {import longKeyPress}

  set simLongKeyPress "false"

  catch {
    if {[info exists longKeyPress] == 1} {
      if {$longKeyPress == 1} {
        set simLongKeyPress "true"
      }
    }
  }
    
  if {[catch {xmlrpc $iface_url($iface) activateLinkParamset [list string $receiver] [list string $sender] [list bool $simLongKeyPress]}]} then {
    set error "<div class=\"CLASS20700\">\${dialogSimulateKeyPressError}</div>"
    puts "<script type=\"text/javascript\">MessageBox.show('\${dialogHint}','$error' ,'', 400, 80);</script>"
  } else {
    #set success "<div class=\"CLASS20700\">\${dialogSimulateKeyPressSuccess}</div>"
    #puts "<script type=\"text/javascript\">MessageBox.show('\${dialogHint}','$success' ,'', 420, 40);</script>"
  }
}

cgi_eval {

  cgi_input
  catch { import cmd }

  if {[session_requestisvalid 0] > 0} then {

    html {
      head {
      puts "<meta http-equiv=\"cache-control\" content=\"no-cache\" />"
    puts "<meta http-equiv=\"pragma\"        content=\"no-cache\" />"
    puts "<meta http-equiv=\"expires\"       content=\"0\" />"
          puts "<title>response of request with command: $cmd</title>"
      }
      body {
        puts "<script src=\"/config/js/ic_common.js\" type=\"text/javascript\"></script>"
          cmd_$cmd
      }
    }
  }
}
