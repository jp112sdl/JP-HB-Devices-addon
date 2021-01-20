set result false

catch {exec printf $args(version) > $args(file)} e

if {[string trim $e] == ""} {
  set result true
}

jsonrpc_response $result