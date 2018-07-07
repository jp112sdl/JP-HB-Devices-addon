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

// Je nach Gehäuseform dürfen nur bestimmte Parameter sichtbar sein.
// This doesn�t work with IE10 therefore this function was rewritten
_caseHasChanged = function(elm) {

  var caseHeightElem;

  $$('[name="CASE_HIGH"]')[0].value = "300";

  switch (elm.selectedIndex) {
    case 0:
      $$(".j_caseLength, .j_caseFilllevel").invoke("hide");
      document.getElementById("caseHeightMinMaxA").style.display = "none";
      document.getElementById("caseHeightMinMaxB").style.display = "inline";
      break;
    case 1:
      document.getElementById("caseHeightMinMaxA").style.display = "inline";
      document.getElementById("caseHeightMinMaxB").style.display = "none";
      $$(".j_caseLength").invoke("hide");
      $$(".j_caseFilllevel").invoke("show");
      break;
    case 2:
      document.getElementById("caseHeightMinMaxA").style.display = "none";
      document.getElementById("caseHeightMinMaxB").style.display = "inline";
      $$(".j_caseFilllevel").invoke("hide");
      $$(".j_caseLength").invoke("show");
      break;
  }

};

caseHasChanged = function(elm) {
  conInfo("Case has changed....");
  var caseHeightElem;

  jQuery('[name="CASE_HIGH"]').first().val("300");

  switch (elm.selectedIndex) {
    case 0:
      jQuery(".j_caseLength, .j_caseFilllevel").hide();
      jQuery("#caseHeightMinMaxB").css("display","none");
      jQuery("#caseHeightMinMaxA").css("display","inline");
      break;
    case 1:
      jQuery("#caseHeightMinMaxA").css("display", "inline");
      jQuery("#caseHeightMinMaxB").css("display","none");
      jQuery(".j_caseLength").hide();
      jQuery(".j_caseFilllevel").show();
      break;
    case 2:
      jQuery("#caseHeightMinMaxB").css("display","none");
      jQuery("#caseHeightMinMaxA").css("display","inline");
      jQuery(".j_caseFilllevel").hide();
      jQuery(".j_caseLength").show();
      break;
  }

};

ProofValue = function(elmID, min, caseSelectorID, deviceMaxValue) {
  
  var isValModified = (document.getElementById("caseHeightMinMaxA").style.display == "none") ? true : false ;
  var elm = $(elmID);
  var max, value; 
  var valLength = elm.value.length;

  if (isValModified) {
    max = 600;  
  } else {
    max = deviceMaxValue;
  }
  
  // Die Werte dürfen nur in 10cm Schritten eingegeben werden.
  //if (valLength == 3) {
  //  value = (elm.value / 10).toFixed(0) * 10;
  //  elm.value = (value <= max) ? value : max;
  //} 
  ProofAndSetValue(elmID, elmID, min, max, 1);
};

showHelpElem = function(mode) {
  if (!mode || (mode != "hide")) {
    $("caseHelp").show();
    document.getElementById("caseHelp").scrollIntoView();
  }
};
