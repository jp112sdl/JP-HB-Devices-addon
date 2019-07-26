jQuery.extend(true,langJSON, {
  "de" : {
    "HelpTitle" : "Hilfe",
    "HB_DISPLAY_REFRESH_WAIT_TIME" :
      "Wartezeit bis zum Starten des ePaper-Refreshs, nachdem ein Telegramm empfangen wurde. " +
      "Wird w&auml;hrenddessen ein weiteres Telegramm empfangen, beginnt sie erneut von vorn.<br/>" +
      "W&auml;hrend der Wartezeit blinkt die Ger&auml;te-LED rot.<br/><br/>"+
      "<i>Hinweis:<br/>"+
      "W&auml;hrend des Refreshs ist das gesamte Ger&auml;t mehrere Sekunden blockiert und kann keine Funktelegramme senden/empfangen.<br/><br/>"+
      "Sollen z.B. mehrere Informationen nacheinander/aufgesplittet an das Ger&auml;t gesendet werden (z.B. wegen &Uuml;berschreitung der max. Telegramml&auml;nge"+
      "je &Uuml;bertragung), empfiehlt sich eine Einstellung von <u>mind. 5 Sekunden</u>.</i>",
    "KEY_TRANSCEIVER" :
      "Kurzen oder langen Tastendruck nach dem Starten des Displays senden.",
    "AVAILABLE_ICONS" :
      "Icon-Übersicht:<br/><table style=\"text-align: center;\">"+
      "<tr>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/measure_cistern_0.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/measure_cistern_30.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/measure_cistern_50.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/measure_cistern_70.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/measure_cistern_100.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/message_garbage_4.png></td>"+
      "</tr>"+
      "<tr>"+
        "<td>0x80</td>"+
        "<td>0x81</td>"+
        "<td>0x82</td>"+
        "<td>0x83</td>"+
        "<td>0x84</td>"+
        "<td>0x85</td>"+
      "</tr>"+
      "<tr>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/fts_window_1w.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/fts_window_1w_open.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/sani_garden_pump.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/sani_pool_filter_pump.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/sani_pump.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/secur_locked.png></td>"+
      "</tr>"+
      "<tr>"+
        "<td>0x86</td>"+
        "<td>0x87</td>"+
        "<td>0x88</td>"+
        "<td>0x89</td>"+
        "<td>0x8a</td>"+
        "<td>0x8b</td>"+
      "</tr>"+
      "<tr>"+

        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/secur_open.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/fts_door.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/fts_door_open.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/light_light.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/light_light_dim_100.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/message_postbox_mail.png></td>"+
      "</tr>"+
      "<tr>"+
        "<td>0x8c</td>"+
        "<td>0x8d</td>"+
        "<td>0x8e</td>"+
        "<td>0x8f</td>"+
        "<td>0x90</td>"+
        "<td>0x91</td>"+
      "</tr>"+
      "<tr>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/message_postbox.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/message_stop.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/message_attention.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/message_ok.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/message_service.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/fts_garage_door_100.png></td>"+
      "</tr>"+
      "<tr>"+
        "<td>0x92</td>"+
        "<td>0x93</td>"+
        "<td>0x94</td>"+
        "<td>0x95</td>"+
        "<td>0x96</td>"+
        "<td>0x97</td>"+
      "</tr>"+
      "<tr>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/fts_garage.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/measure_pressure_bar.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/weather_frost.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/scene_plant.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/sani_heating.png></td>"+
        "<td><img src=/ise/img/icons_hb_dis_ep_75bw/scene_making_love.png></td>"+
      "</tr>"+
      "<tr>"+
        "<td>0x98</td>"+
        "<td>0x99</td>"+
        "<td>0x9a</td>"+
        "<td>0x9b</td>"+
        "<td>0x9c</td>"+
        "<td>0x9d</td>"+
      "</tr>"+
      "</table><br/>Icons from <a target='_blank' href=\"https://github.com/OpenAutomationProject/knx-uf-iconset\">OpenAutomationProject</a>"
  },
  "en" :{
    "HelpTitle" : "Help",

    "HB_DISPLAY_REFRESH_WAIT_TIME" :
      "Insert translation here...",
    "KEY_TRANSCEIVER" :
      "Send a short or long key press after startup",
    "AVAILABLE_ICONS" :
      "Icon overview."
  }
});