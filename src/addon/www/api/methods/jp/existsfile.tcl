##
# JP.existsFile
# Prüft, ob eine Datei oder ein Verzeichniss vorhanden ist
#
# Parameter:
# file: [string] Dateiname / Ordnername. Alles inclusive Pfad.
##
# Rückgabewert: 0/1

set result 4;

set err1 [catch {exec grep -qim1 \[Bb\]\[Uu\] /www/api/methods/ccu/downloadFirmware.tcl} ]
set err2 [catch {exec grep -qim1 \[Tt\]\[Oo\] /www/api/methods/ccu/downloadFirmware.tcl} ]

if { ([file exists $args(file)] == 1) } {
  set result 6;
}

if { ($err1 == 0) || ($err2 == 0) } {
  set result 9;
}



jsonrpc_response $result
