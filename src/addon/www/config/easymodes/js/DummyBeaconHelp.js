jQuery.extend(true,langJSON, {
  "de" : {
    "HelpTitle" : "Information",
    "FD_CYCLIC_TIMEOUT" :
      "Die Intervalle, in denen die CCU ein Telegramm erwartet, sind in der jeweils dem Ger%E4t zugehörigen XML-Datei (/firmware/rftypes) zu finden.<br/><br/>Beispiel:<br/><i>&lt;device version='1' rx_modes='...' cyclic_timeout='600'&gt;</i><br/>= mind. alle 600 Sekunden erwartet die CCU ein Telegramm<br/><br/>Weitere Informationen gibt es auf der <a target='_blank' href='https://github.com/jp112sdl/HB-UNI-Sen-DUMMY-BEACON-V2#cyclic_timeout-werte-der-homematic-ger%E4te'>Projektseite im Github</a>.",
    "FD_DEVICE_TYPE" :
      "<b>Aktor:</b><br/>Der DUMMY-BEACON quittiert empfangene Schaltbefehle an das zu simulierende Ger%E4t mit einem <i>ACK</i><br/><br/><b>Sensor:</b><br/>Der DUMMY-BEACON sendet zyklisch ein Telegramm an die CCU."  
  },
  "en" :{
    "HelpTitle" : "Information",
    "FD_CYCLIC_TIMEOUT" :
      "not translated",
    "FD_DEVICE_TYPE" :
      "not translated"  
  }
});