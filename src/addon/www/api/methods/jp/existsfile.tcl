##
# JP.existsFile
# Prüft, ob eine Datei oder ein Verzeichniss vorhanden ist
#
# Parameter:
# file: [string] Dateiname / Ordnername. Alles inclusive Pfad.
##
# Rückgabewert: 0/1

set result 4;

if { ([file exists $args(file)] == 1) } {
  set result 6;
}

jsonrpc_response $result
