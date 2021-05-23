array set param_descr $ps_descr(SHORT_ACT_NUM)
set min 0
set max $param_descr(MAX)

global dev_descr_sender
# Beim Rauchmelder gibt es keine Einschaltverzögerung.
# Das Profil enthält nur die Signalart und die Anzahl der Signale.
# Daher gibt es keine horizontale Begrenzungslinie
if {$dev_descr_sender(TYPE) != "SMOKE_DETECTOR_TEAM"} { 
	append HTML_PARAMS(separate_$prn) "<tr><td colspan=\"2\"><hr></td></tr>"
}

incr pref
append HTML_PARAMS(separate_$prn) "<tr><td>\${signal_effect}</td><td>"
array_clear options

set options(1)	"Static"
set options(2)	"Blink"
set options(3)  "Breath"
set options(4)  "Color Wipe"
set options(5)  "Color Wipe Inverse"
set options(6)  "Color Wipe Reverse"
set options(7)  "Color Wipe Reverse Inverse"
set options(8)  "Color Wipe Random"
set options(9)  "Random Color"
set options(10)  "Single Dynamic"
set options(11)  "Multi Dynamic"
set options(12)  "Rainbow"
set options(13)  "Rainbow Cycle"
set options(14)  "Scan"
set options(15)  "Dual Scan"
set options(16)  "Fade"
set options(17)  "Theater Chase"
set options(18)  "Theater Chase Rainbow"
set options(19)  "Running Lights"
set options(20)  "Twinkle"
set options(21)  "Twinkle Random"
set options(22)  "Twinkle Fade"
set options(23)  "Twinkle Fade Random"
set options(24)  "Sparkle"
set options(25)  "Flash Sparkle"
set options(26)  "Hyper Sparkle"
set options(27)  "Strobe"
set options(28)  "Strobe Rainbow"
set options(29)  "Multi Strobe"
set options(30)  "Blink Rainbow"
set options(31)  "Chase White"
set options(32)  "Chase Color"
set options(33)  "Chase Random"
set options(34)  "Chase Rainbow"
set options(35)  "Chase Flash"
set options(36)  "Chase Flash Random"
set options(37)  "Chase Rainbow White"
set options(38)  "Chase Blackout"
set options(39)  "Chase Blackout Rainbow"
set options(40)  "Color Sweep Random"
set options(41)  "Running Color"
set options(42)  "Running Red Blue"
set options(43)  "Running Random"
set options(44)  "Larson Scanner"
set options(45)  "Comet"
set options(46)  "Fireworks"
set options(47)  "Fireworks Random"
set options(48)  "Merry Christmas"
set options(49)  "Fire Flicker"
set options(50)  "Fire Flicker (soft)"
set options(51)  "Fire Flicker (intense)"
set options(52)  "Circus Combustus"
set options(53)  "Halloween"
set options(54)  "Bicolor Chase"
set options(55)  "Tricolor Chase"
set options(56)  "TwinkleFOX"
set options(57)  "Spots"
set options(58)  "Custom 1"
set options(59)  "Custom 2"
set options(60)  "Custom 3"
set options(61)  "Custom 4"
set options(62)  "Custom 5"
set options(63)  "Custom 6"
set options(64)  "Custom 7"

append HTML_PARAMS(separate_$prn) [get_ComboBox options SHORT_ACT_TYPE|LONG_ACT_TYPE separate_${special_input_id}_$prn\_$pref PROFILE_$prn SHORT_ACT_TYPE]
append HTML_PARAMS(separate_$prn) "</td></tr>"

incr pref
set id "separate_${special_input_id}_$prn\_$pref"
append HTML_PARAMS(separate_$prn) "<tr><td>\${signal_effectoptions} ($min - $max)</td><td>"
append HTML_PARAMS(separate_$prn) "<input type=\"text\" id=\"$id\" name=\"SHORT_ACT_OPTIONS|LONG_ACT_OPTIONS\" value=\"$ps(SHORT_ACT_OPTIONS)\" size=5 onchange=\"ProofFreeValue(\'$id\', $min, $max);\">"
append HTML_PARAMS(separate_$prn) "</td></tr>"

incr pref
set id "separate_${special_input_id}_$prn\_$pref"
append HTML_PARAMS(separate_$prn) "<tr><td>\${signal_speed} ($min - $max)</td><td>"
append HTML_PARAMS(separate_$prn) "<input type=\"text\" id=\"$id\" name=\"SHORT_ACT_NUM|LONG_ACT_NUM\" value=\"$ps(SHORT_ACT_NUM)\" size=5 onchange=\"ProofFreeValue(\'$id\', $min, $max);\">"
append HTML_PARAMS(separate_$prn) "</td></tr>"

incr pref
set id "separate_${special_input_id}_$prn\_$pref"
append HTML_PARAMS(separate_$prn) "<tr><td>\${signal_intens} ($min - $max)</td><td>"
append HTML_PARAMS(separate_$prn) "<input type=\"text\" id=\"$id\" name=\"SHORT_ACT_INTENS|LONG_ACT_INTENS\" value=\"$ps(SHORT_ACT_INTENS)\" size=5 onchange=\"ProofFreeValue(\'$id\', $min, $max);\">"
append HTML_PARAMS(separate_$prn) "</td></tr>"

incr pref
set id "separate_${special_input_id}_$prn\_$pref"
append HTML_PARAMS(separate_$prn) "<tr><td>R ($min - $max)</td><td>"
append HTML_PARAMS(separate_$prn) "<input type=\"text\" id=\"$id\" name=\"SHORT_ACT_COLOR_R|LONG_ACT_COLOR_R\" value=\"$ps(SHORT_ACT_COLOR_R)\" size=5 onchange=\"ProofFreeValue(\'$id\', $min, $max);\">"
append HTML_PARAMS(separate_$prn) "</td></tr>"

incr pref
set id "separate_${special_input_id}_$prn\_$pref"
append HTML_PARAMS(separate_$prn) "<tr><td>G ($min - $max)</td><td>"
append HTML_PARAMS(separate_$prn) "<input type=\"text\" id=\"$id\" name=\"SHORT_ACT_COLOR_G|LONG_ACT_COLOR_G\" value=\"$ps(SHORT_ACT_COLOR_G)\" size=5 onchange=\"ProofFreeValue(\'$id\', $min, $max);\">"
append HTML_PARAMS(separate_$prn) "</td></tr>"

incr pref
set id "separate_${special_input_id}_$prn\_$pref"
append HTML_PARAMS(separate_$prn) "<tr><td>B ($min - $max)</td><td>"
append HTML_PARAMS(separate_$prn) "<input type=\"text\" id=\"$id\" name=\"SHORT_ACT_COLOR_B|LONG_ACT_COLOR_B\" value=\"$ps(SHORT_ACT_COLOR_B)\" size=5 onchange=\"ProofFreeValue(\'$id\', $min, $max);\">"
append HTML_PARAMS(separate_$prn) "</td></tr>"

incr pref
set id "separate_${special_input_id}_$prn\_$pref"
append HTML_PARAMS(separate_$prn) "<tr><td>W ($min - $max)</td><td>"
append HTML_PARAMS(separate_$prn) "<input type=\"text\" id=\"$id\" name=\"SHORT_ACT_COLOR_W|LONG_ACT_COLOR_W\" value=\"$ps(SHORT_ACT_COLOR_W)\" size=5 onchange=\"ProofFreeValue(\'$id\', $min, $max);\">"
append HTML_PARAMS(separate_$prn) "</td></tr>"