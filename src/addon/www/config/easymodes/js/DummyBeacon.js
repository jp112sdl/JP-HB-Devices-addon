convertAddress = function(address) {
  var val = {};
  if (address) {  
    var hAddress = parseInt(address).toString(16);
  
    while (hAddress.length < 6) {
      hAddress = "0" + hAddress;
    }
    
    val.LOW = parseInt(hAddress.substring(4), 16).toString(); 
    val.LOW = (isNaN(val.LOW)) ? "0" : val.LOW.toString();
    val.MID = parseInt(hAddress.substring(2,4), 16).toString();
    val.MID = (isNaN(val.MID)) ? "0" : val.MID;
    val.HIGH = parseInt(hAddress.substring(0,2), 16);
    val.HIGH = (isNaN(val.HIGH)) ? "0" : val.HIGH.toString();
  } else {
    val.LOW = "0";
    val.MID = "0";
    val.HIGH = "0";
  }
  return val;
};

restoreRFAddress = function(oVal) {
  
  var hexSenderAddress = "000000";

  var hSenderAddressHIGH = parseInt(oVal.senderHIGH).toString(16);
  hSenderAddressHIGH = (hSenderAddressHIGH.length == 1) ? "0" +  hSenderAddressHIGH : hSenderAddressHIGH;

  var hSenderAddressMID = parseInt(oVal.senderMID).toString(16); 
  hSenderAddressMID = (hSenderAddressMID.length == 1) ? "0" +  hSenderAddressMID : hSenderAddressMID;

  var hSenderAddressLOW = parseInt(oVal.senderLOW).toString(16); 
  hSenderAddressLOW = (hSenderAddressLOW.length == 1) ? "0" +  hSenderAddressLOW : hSenderAddressLOW;

  hexSenderAddress = hSenderAddressHIGH + hSenderAddressMID + hSenderAddressLOW;
   
  return parseInt(hexSenderAddress, 16);
};

decToHex = function(val) {
  var sHex = parseInt(val).toString(16);
  return (sHex.length == 1) ? "0" +  sHex : sHex;
}

self.init = function (chn) {
  var options = jQuery(".select_"+chn+" option");
  if (options) {
    var arr = options.map(function(_, o) {
        return {
            t: jQuery(o).text(),
            v: o.value,
            i: o.id
        };
    }).get();
    arr.sort(function(o1, o2) {
        return o1.t > o2.t ? 1 : o1.t < o2.t ? -1 : 0;
    });
    options.each(function(j, o) {
        //console.log(j);
        o.value = arr[j].v;
        o.id = arr[j].i;
        jQuery(o).text(arr[j].t);
    });
  }
    
  jQuery(".ADDRESS_SENDER_HIGH_BYTE_"+chn).hide();
  jQuery(".ADDRESS_SENDER_MID_BYTE_"+chn).hide();
  jQuery(".ADDRESS_SENDER_LOW_BYTE_"+chn).hide();
  
  var high = jQuery(".ADDRESS_SENDER_HIGH_BYTE_"+chn).val();
  var mid = jQuery(".ADDRESS_SENDER_MID_BYTE_"+chn).val();
  var low = jQuery(".ADDRESS_SENDER_LOW_BYTE_"+chn).val();

  var val = {};
  val.senderHIGH=high;
  val.senderMID=mid;
  val.senderLOW=low;

  var rf = restoreRFAddress(val);
  document.getElementById("deviceSelectionBox_"+chn).value = rf;
  
  setDevice(document.getElementById("deviceSelectionBox_"+chn), chn);
} 


self.setDevice = function (elm, chn) {
  //console.log("setDevice "+elm.value+" ch:"+chn);
  
  var devType = jQuery(".FD_CYCLIC_TIMEOUT_"+chn).val();

  if (elm.value === "0") {
    jQuery(".j_param_"+chn).hide();
    jQuery(".j_sens_param_"+chn).hide();
    jQuery(".ADDRESS_SENDER_HIGH_BYTE_"+chn).val(0);
    jQuery(".ADDRESS_SENDER_MID_BYTE_"+chn).val(0); 
    jQuery(".ADDRESS_SENDER_LOW_BYTE_"+chn).val(0); 
    document.getElementById("deviceTypeSelectionBox_"+chn).value = 0;
  } else {
    jQuery(".j_param_"+chn).show();
    // 0 = Aktor, > 0 = Sensor
    if (devType !== "0") { 
      jQuery(".j_sens_param_"+chn).show();
      document.getElementById("deviceTypeSelectionBox_"+chn).value = 1;
    } else { 
      jQuery(".j_sens_param_"+chn).hide(); 
      jQuery(".FD_CYCLIC_TIMEOUT_"+chn).val(0); 
      document.getElementById("deviceTypeSelectionBox_"+chn).value = 0;
    }
    var senderBYTES = convertAddress(parseInt(elm.value));
    jQuery(".ADDRESS_SENDER_HIGH_BYTE_"+chn).val(senderBYTES.HIGH); 
    jQuery(".ADDRESS_SENDER_MID_BYTE_"+chn).val(senderBYTES.MID); 
    jQuery(".ADDRESS_SENDER_LOW_BYTE_"+chn).val(senderBYTES.LOW); 
    
    jQuery(".HEXADDR_"+chn).html("(0x "+decToHex(senderBYTES.HIGH)+" "+decToHex(senderBYTES.MID)+" "+decToHex(senderBYTES.LOW)+")"); 
  }

};

self.setDeviceType = function (elm, chn, min) {
  //console.log("setDeviceType "+elm.value+" ch:"+chn);
  if (elm.value === "0") {
    jQuery(".j_sens_param_"+chn).hide();
    jQuery(".FD_CYCLIC_TIMEOUT_"+chn).val(0); 
  } else {
    jQuery(".j_sens_param_"+chn).show();
    jQuery(".FD_CYCLIC_TIMEOUT_"+chn).val(min); 
  }
};

