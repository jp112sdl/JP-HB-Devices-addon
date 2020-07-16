self.displayCustom = function (elem) {
  var mode = ($(elem.id).checked == 1) ? "hide" : "show";
  $$(".j_custom").invoke(mode);
};

setVal = function(tmpElm, type) {
  var elmID; 
  
  switch (type) {
    case "channel" : 
      elmID = tmpElm.id.replace(/tmp/,"separate_CHANNEL");
      break;
    case "linkSender" : 
      elmID = tmpElm.id.replace(/tmp/,"separate_sender");
      break;
    case "linkReceiver" : 
      elmID = tmpElm.id.replace(/tmp_separate/,"separate_receiver");
      break;
  }

  if (tmpElm.value > 100) {tmpElm.value = 100;}
  if (tmpElm.value < 0) {tmpElm.value = 0;}
  
  var convertedValue = (2 * parseFloat(tmpElm.value));
  if (isNaN(convertedValue)) {convertedValue = 0; tmpElm.value = 0;}
  document.getElementById(elmID).value = convertedValue.toFixed(0);
};

powerSupplyHasChanged = function(elm) {
  conInfo("powerSupply has changed....");    
  switch (elm.selectedIndex) {  
    case 0:                             
      jQuery(".j_lowbat").hide();
      break;                           
    case 1:      
      jQuery(".j_lowbat").show();
      break;                             
  }                                      
};                                       
