set result 0
if {[catch {set fp [open $args(file) r]}] == 0} {
  if { $fp >= 0 } {
    set result [string trim [read $fp]]
    close $fp
  }
}

jsonrpc_response [json_toString $result]
