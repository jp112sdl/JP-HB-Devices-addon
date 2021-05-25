//Defines
/*
TOM_DAYIDX = new Array();
TOM_DAYIDX['SATURDAY'] = 0;
TOM_DAYIDX['SUNDAY'] = 1;
TOM_DAYIDX['MONDAY'] = 2;
TOM_DAYIDX['TUESDAY'] = 3;
TOM_DAYIDX['WEDNESDAY'] = 4;
TOM_DAYIDX['THURSDAY'] = 5;
TOM_DAYIDX['FRIDAY'] = 6;

TOM_DAY_ENG = new Array('SATURDAY', 'SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY');

tom_endtime = 0;
tom_level = 1;

tom_maxtimeout = 1440;
tom_mintimeout = 0;

*/

//-----


CC_save_Level = function(prgName)
{
  var prg = (typeof prgName != "undefined" && prgName != null) ? prgName : "";
  for (loop = 0; loop <= (document.getElementsByName(prg+'level_tmp').length -1); loop++)
  {
      document.getElementsByName(prg + 'level')[loop].value = parseInt(document.getElementsByName(prg +'level_tmp')[loop].value);
  }
};

HBTimeoutManager = Class.create();

HBTimeoutManager.prototype = Object.extend(new MsgBox(), {

  initialize: function (iface, address, isOldDevGeneration, prgName) {

    this.TOM_DAY  = new Array (
      translateKey('timeModuleLblSelSerialPatternSaturday') ,
      translateKey('timeModuleLblSelSerialPatternSunday') ,
      translateKey('timeModuleLblSelSerialPatternMonday') ,
      translateKey('timeModuleLblSelSerialPatternTuesday') ,
      translateKey('timeModuleLblSelSerialPatternWednesday') ,
      translateKey('timeModuleLblSelSerialPatternThursday') ,
      translateKey('timeModuleLblSelSerialPatternFriday')
    );

    this.isOldDevGeneration = isOldDevGeneration;
    this.iface = iface;
    this.address = address;

    this.prg = (prgName != undefined && prgName != null) ? prgName : "";

    //Woche anlegen und initialisieren
    this.week = new Array(7);
    this.divname = new Array(7); //DIV-Container
    this.weekdirty = new Array(7); //Sind ƒnderungen erfolgt?

    this.setMaxTimouts();

    for (var dayidx = 0; dayidx < 7; dayidx++) {
      this.week[dayidx] = new Array();
      this.divname[dayidx] = '';
      this.weekdirty[dayidx] = false;
    }
  },

  setMaxTimouts: function() {
    this.maxTimeOuts = 13;
  },

  setDivname: function (day, divid) {
    var dayidx = TOM_DAYIDX[day];
    this.divname[dayidx] = divid;
  },

  tom_toTime: function (timeout) {

    var h = parseInt(timeout / 60);
    var m = timeout - h * 60;

    if (String(m).length == 1) m = "0" + m;
    if (String(h).length == 1) h = "0" + h;

    return h + ":" + m;
  },

  tom_toTimeout: function (time) {

    var tokens;
    var h, m;
    var timeout = -1;

    if (this.tom_isTime(time)) {
      tokens = time.split(':');
      h = tokens[0];
      m = tokens[1];

      timeout = parseInt(h, 10) * 60 + parseInt(m, 10);
    }

    return timeout;
  },

  tom_isTime: function (time) {
    return time.match(/^[0-2]?[0-9]:[0-5][0,5]$/) != null;
  },

  tom_isLevel: function (level) {
    return level.match(/\b([01]?[0-9][0-9]?|200)\b/) != null;
  },

  tom_checkAndSetTime: function (day, inputel, timeoutIdx) {

    var dayidx = TOM_DAYIDX[day];
    var timeouts = this.week[dayidx];
    var elem = inputel.id.split("_");
    var count = -1;
    var inputelem;
    var endtime;
    var prev_endtime;
    var next_endtime;
    var time;

    if (!this.prg) {
      while ($(elem[0] + '_' + elem[1] + '_' + (count + 1))) {
        count++;
        timeouts[count][tom_endtime] = this.tom_toTimeout($(elem[0] + '_' + elem[1] + '_' + count).value);
      }
    } else {
      while ($(this.prg + elem[1] + '_' + elem[2] + '_' + (count + 1))) {
        count++;
        timeouts[count][tom_endtime] = this.tom_toTimeout($(this.prg + elem[1] + '_' + elem[2] + '_' + count).value);
      }
    }

    for (var loop = 0; loop <= (count - 1); loop++) {
      timeoutIdx = loop;
      if (!this.prg) {
        inputelem = elem[0] + "_" + elem[1] + "_" + loop;
      } else {
        inputelem = this.prg + elem[1] + "_" + elem[2] + "_" + loop;
      }
      if (this.isOldDevGeneration) {
        // Minuten der Zeit auf volle 10 pruefen und ggf. anpassen
        $(inputelem).value = time = $(inputelem).value.replace(/[1-9]$/, "0");
      } else {
        // Minuten der Zeit auf volle 5 pruefen und ggf. anpassen
        var arTime = $(inputelem).value.split(":"),
        hour = parseInt(arTime[0]),
        min =Math.round(arTime[1] / 5) * 5 ;
        if (min <= 9) {min = "0" + min;}
        if (min == 60) {min = "00"; hour++;}
        if (hour <= 9) {hour = "0" + hour;}
        if (hour == 24) {hour = "23"; min = "55";}

        $(inputelem).value = time = hour + ":" + min;
      }
      endtime = this.tom_toTimeout(time);
      prev_endtime = -1;
      next_endtime = -1;


      if (timeoutIdx != 0) prev_endtime = timeouts[timeoutIdx - 1][tom_endtime];
      if (timeoutIdx != timeouts.length - 1) next_endtime = timeouts[timeoutIdx + 1][tom_endtime];


      $(inputelem).style.backgroundColor = WebUI.getColor("transparent");
      if (endtime > 0
        && endtime <= 1440
        && (prev_endtime < 0 || prev_endtime < endtime)
        && (next_endtime < 0 || next_endtime > endtime)) timeouts[timeoutIdx][tom_endtime] = parseInt(endtime);
      else $(inputelem).style.backgroundColor = WebUI.getColor("red");

      this.weekdirty[dayidx] = true;
    }
  },

  tom_checkAndSetLevel: function (day, inputelem, timeoutIdx) {

    var level = inputelem.value;
    var dayidx = TOM_DAYIDX[day];
    var timeouts = this.week[dayidx];

    inputelem.style.backgroundColor = WebUI.getColor("transparent");

    if (this.tom_isLevel(level)
      && level >= 0
      && level <= 200) timeouts[timeoutIdx][tom_level] = parseInt(level);
    else                      inputelem.style.backgroundColor = WebUI.getColor("red");

    this.weekdirty[dayidx] = true;
  },

  tom_setDirty: function (day, inputelem, timeoutIdx) {
    CC_save_Level(this.prg);
    var tmp = inputelem.id.split("_");

    if (this.prg) {
      var id = this.prg + tmp[1] + "_" + tmp[2] + "_" + tmp[3];
    } else {
      var id = tmp[0] + "_" + tmp[1] + "_" + tmp[2];
    }
    var level = $F(id);
    var dayidx = TOM_DAYIDX[day];
    var timeouts = this.week[dayidx];

    inputelem.style.backgroundColor = WebUI.getColor("transparent");

    if (this.tom_isLevel(level)
      && level >= 0
      && level <= 200) timeouts[timeoutIdx][tom_level] = parseInt(level);
    else                      inputelem.style.backgroundColor = WebUI.getColor("red");

    this.weekdirty[dayidx] = true;

  },

  tom_getPostStr: function () {

    var postStr = "";

    for (var dayidx = 0; dayidx < 7; dayidx++) {
      //Welcher Tag enth‰lt die relevanten Daten: "wie am Vortag"-Funktion?
      var prev_day = $(this.prg + 'prevday_' + dayidx);
      var p = dayidx;
      while (prev_day.checked) {
        p--;
        prev_day = $(this.prg+ 'prevday_' + p);
      }
      //-----

      if (this.weekdirty[dayidx] || this.weekdirty[p]) //Dieser Tag oder der Vortag "dirty"?
      {
        var timeouts = this.week[p];

        if (timeouts && timeouts.length > 0) {
          for (var i = 0; i < timeouts.length; i++) {
            if (this.isOldDevGeneration) {
              postStr += "&LEVEL" + TOM_DAY_ENG[dayidx] +"_" + (i+1) + "=" + timeouts[i][tom_level];
              postStr += "&TIMEOUT_"    + TOM_DAY_ENG[dayidx] +"_" + (i+1) + "=" + timeouts[i][tom_endtime];
            } else {
              postStr += "&" + this.prg + "LEVEL_" + TOM_DAY_ENG[dayidx] + "_" + (i + 1) + "=" + timeouts[i][tom_level];
              postStr += "&" + this.prg + "ENDTIME_" + TOM_DAY_ENG[dayidx] + "_" + (i + 1) + "=" + timeouts[i][tom_endtime];
            }
          }
        }
      }
    }

    return postStr;
  },

  tom_isDirty: function () {

    for (var dayidx = 0; dayidx < 7; dayidx++) {
      if (this.weekdirty[dayidx]) return true;
    }
    return false;
  },

  //day: MONDAY, TUESDAY, ...
  //endtime: 0..1440
  setLevel: function (day, endtime, level) {

    var dayidx = TOM_DAYIDX[day];
    var timeouts = this.week[dayidx];
    var i = 0;
    if (!timeouts) timeouts = new Array();

    while (i < timeouts.length && endtime >= timeouts[i][tom_endtime]) {
      if (timeouts[i][tom_endtime] == endtime) {
        return;
      }

      i++;
    }

    if (i < timeouts.length) {
      //Es muss einsortiert werden.
      //Platz da!!!
      for (j = timeouts.length; j > i; j--) {
        timeouts[j] = timeouts[j - 1];
      }
    }

    timeouts[i] = new Array(2);
    timeouts[i][tom_endtime] = endtime;
    timeouts[i][tom_level] = level;
  },

  delLevel: function (day, endtime) {

    var dayidx = TOM_DAYIDX[day];
    var timeouts = this.week[dayidx];

    for (var i = 0; i < timeouts.length; i++) {
      if (timeouts[i][tom_endtime] == endtime) {
        timeouts.splice(i, 1);
        break;
      }
    }
  },

  delLevelByIdx: function (day, timeoutIdx) {

    var dayidx = TOM_DAYIDX[day];
    var timeouts = this.week[dayidx];
    timeouts.splice(timeoutIdx, 1);

    this.weekdirty[dayidx] = true;
  },

  addLevelByIdx: function (day, timeoutIdx) {

    var dayidx = TOM_DAYIDX[day];
    var timeouts = this.week[dayidx];

    if (timeouts.length >= this.maxTimeOuts ) {
      //alert('Der Zeitabschnitt kann nicht angelegt werden. Es kˆnnen nur bis zu '+this.maxTimeOuts+'  Zeitabschnitte angelegt werden.');
      alert(translateKey('errorCreateTimePeriod') + translateKey('maxTimePeriodReachedA') + this.maxTimeOuts+translateKey('maxTimePeriodReachedB'));
      return;
    }
    else if (timeouts[timeoutIdx][tom_endtime] - 10 == 0) {
      //alert('Der Zeitabschnitt kann nicht angelegt werden. Die Endzeit kann nicht 00:00 Uhr sein.');
      alert(translateKey('errorCreateTimePeriod') + translateKey('endtimeReached'));
      return;
    }
    else if (timeoutIdx > 0 && timeouts[timeoutIdx][tom_endtime] - 10 <= timeouts[timeoutIdx - 1][tom_endtime]) {
      //alert('Der Zeitabschnitt kann nicht angelegt werden. Er existiert schon.');
      alert(translateKey('errorCreateTimePeriod') + translateKey('timePeriodAlreadyExists'));
      return;
    }
    this.setLevel(day, timeouts[timeoutIdx][tom_endtime] - 10, timeouts[timeoutIdx][tom_level]);

    this.weekdirty[dayidx] = true;
  },

  OnClickPrevDay: function (day) {
    var dayidx = TOM_DAYIDX[day];
    var elem = $(this.prg + 'prevday_' + dayidx);

    if (elem.checked) {
      $(this.prg+'levelprofile_' + dayidx).style.display = "none";
      $(this.prg+'levelprofile_' + dayidx).style.visibility = "hidden";
    }
    else {
      $(this.prg+'levelprofile_' + dayidx).style.display = "";
      $(this.prg+'levelprofile_' + dayidx).style.visibility = "visible";
    }
    this.tom_setDirty('SATURDAY', $(this.prg + 'level_0_0_tmp'), 0);
    this.weekdirty[dayidx] = true;
  },

  tom_equals_prevday: function (day) {

    var dayidx = TOM_DAYIDX[day];

    if (dayidx == 0) return false; //Starttag ist immer ungleich des Vortages

    var this_timeouts = this.week[dayidx    ];
    var prev_timeouts = this.week[dayidx - 1];

    if (!prev_timeouts || !this_timeouts || prev_timeouts.length != this_timeouts.length) return false;

    for (var i = 0; i < this_timeouts.length; i++) {
      if (this_timeouts[i][tom_level] != prev_timeouts[i][tom_level]
        || this_timeouts[i][tom_endtime] != prev_timeouts[i][tom_endtime]) return false;
    }
    return true;
  },

  checkDayTimeouts: function (dayidx) {
    var timeouts = this.week[dayidx];

    for (i = 1; i < timeouts.length; i++) {
      if (timeouts[i][tom_endtime] <= timeouts[i - 1][tom_endtime]) {
        alert("Der " + i + ". Zeitabschnitt hat eine ung¸ltige Dauer");
      }
    }
  },

  checkTimeouts: function () {

    for (i = 0; i < this.week.length; i++) {
      checkDayTimeouts(i);
    }
  },

  writeDay: function (day) {

    var prgNr = this.prg;

    var dayidx = TOM_DAYIDX[day];
    var timeouts = this.week[dayidx];
    var endtime;

    if (!timeouts) return;

    var equals_prevday = this.tom_equals_prevday(day);

    msg = "<hr class=\"CLASS10400\" />";
    msg += "<table class=\"TimeoutTable\">";
    msg += "<tbody>";
    msg += "<tr>";

    msg += "<td>" + translateKey('lblProgramLevelProfile') + "&nbsp;" + this.TOM_DAY[dayidx] + ":</td>";
    msg += "<td>&nbsp;";
    if (dayidx == 0) msg += "<div style=\"visibility: hidden; display: none;\">";

    msg += "<input type=\"checkbox\" id=\""+prgNr+"prevday_" + dayidx + "\" onclick=\""+prgNr+"tom.OnClickPrevDay('" + day + "');\" " + (equals_prevday ? 'checked=\"checked\"' : '\"\"') + "\"/>" + translateKey('lblProgramPreviousDay');
    if (dayidx == 0) msg += "</div>";
    msg += "</td>";
    msg += "</tr>";
    msg += "</tbody>";
    msg += "</table>";

    msg += "<table class=\"TimeoutTable\" id=\""+prgNr+"levelprofile_" + dayidx + "\" " + (equals_prevday ? 'style=\"display: none; visibility: hidden;\"' : '') + ">";
    msg += "<thead>";

    msg += "<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>" + translateKey('lblProgramTimeStart') + "</td><td>" + translateKey('lblProgramTimeEnd') + "</td><td>" + translateKey('lblLevel') + "</td></tr>";
    msg += "</thead>";
    msg += "<tbody>";

    for (var i = 0; i < timeouts.length; i++) {
      if (i == 0) endtime = tom_mintimeout;
      else        endtime = timeouts[i - 1][tom_endtime];
      
      var selectedOff = "";
      var selectedOn = "";
      if (timeouts[i][tom_level] == 0) {
        selectedOff = "selected";
      } else {
        selectedOn = "selected";
      }

      msg += "<tr>";
      msg += "<td><img " + (i == timeouts.length - 1 ? 'style=\"visibility: hidden;\"' : '') + " title=\"" + translateKey('toolTipProgramDelPeriod') + "\" alt=\"Zeitabschnitt l&ouml;schen\" onclick=\""+prgNr+ "tom.delLevelByIdx('" + day + "'," + i + "); "+prgNr+ "tom.writeDay('" + day + "');\" style=\"cursor: pointer; width: 24px; height: 24px;\" src=\"/ise/img/cc_delete.png\"/></td>";
      msg += "<td><img src=\"/ise/img/add.png\" title=\"" + translateKey('toolTipProgramAddPeriod') + "\" alt=\"Zeitabschnitt hinzuf&uuml;gen\" style=\"width: 24px; height: 24px; cursor: pointer;\" onclick=\""+prgNr+ "tom.addLevelByIdx('" + day + "'," + i + "); "+prgNr+ "tom.writeDay('" + day + "');\" /></td>";
      msg += "<td>" + (i + 1) + ". " + translateKey('lblProgramPeriod') + "</td>";
      msg += "<td><input style=\"text-align: right;\" maxLength=\"5\" size=\"7\" id=\""+prgNr+"starttime_" + dayidx + "_" + i + "\" disabled=\"disabled\" type=\"text\" value=\"" + this.tom_toTime(endtime) + "\">" + translateKey('lblProgramTimeExtension') + "</td>";
      msg += "<td><input style=\"text-align: right;\" maxLength=\"5\" size=\"7\" id=\""+prgNr+"endtime_" + dayidx + "_" + i + "\" " + (i == timeouts.length - 1 ? 'disabled=\"disabled\"' : '') + " type=\"text\" value=\"" + this.tom_toTime(timeouts[i][tom_endtime]) + "\" onblur=\""+prgNr+"tom.tom_checkAndSetTime ('" + day + "', this, " + i + "); document.getElementById('"+prgNr+"starttime_" + dayidx + "_" + (i + 1) + "').value=this.value; \">" + translateKey('lblProgramTimeExtension') + "</td>";
      msg += "<td><select name=\""+prgNr+"level_tmp\" id=\""+prgNr+"level_" + dayidx + "_" + i + "_tmp\" value=\"" + timeouts[i][tom_level] + "\" onchange=\""+prgNr+"tom.tom_setDirty ('" + day + "', this, " + i + ");\"><option "+selectedOff+" value=\"0\">AUS</option><option "+selectedOn+" value=\"200\">EIN</option></select>"
      msg += "<td><input style=\"display:none\" size=\"3\" name=\""+prgNr+"level\" id=\""+prgNr+ "level_" + dayidx + "_" + i + "\" value=\"" + timeouts[i][tom_level] + "\"></td>";
      msg += "</tr>";
    }
    msg += "</tbody>";
    msg += "</table>";
    $(this.divname[dayidx]).innerHTML = msg;
  }

});



/**
 * ise/iseButtonsWindowHB.js
 **/

/**
 * @fileOverview ?
 * @author ise
 **/

/* * * * * * * * * * * * * * * * * * * * * * * *
 * iseButtonsWindowHB                          *
 * * * * * * * * * * * * * * * * * * * * * * * */

/**
 * @class
 **/
iseButtonsWindowHB = Class.create();

iseButtonsWindowHB.prototype = {
  /*
   * id = datapoint-ID of switch
   * initState = Creation State (0 or 1)
   */
  initialize: function(id, initState) {
    this.id = id;
    this.state = initState;
    this.divOpenH = $(this.id + "OpenH");
    this.divOpenV = $(this.id + "OpenV");
    this.divClosed = $(this.id + "Closed");
    this.divExtra = $(this.id + "Extra");

    switch (initState) {
      case 0:
      case false:
        ControlBtn.on(this.divClosed);
        break;
      case 1:
        ControlBtn.on(this.divOpenV);
        break;
      case 2:
      case true:
        ControlBtn.on(this.divOpenH);
        break;
      case 3:
        ControlBtn.on(this.divExtra);
        break;
      default:
        break;
    }
  }
};

/**
 * ise/iseButtonsServo.js
 **/

/**
 * @fileOverview ?
 * @author ise
 **/

/**
 * @class
 **/ 
iseButtonsServo = Class.create();

iseButtonsServo.prototype = {
  /*
   * id = DOM-ID of switch
   * initState = Creation State 
   */
  initialize: function(id, initState, lvlDP, oldLvlDP, iViewOnly, bSliderPosFlag, label)
  {
    conInfo( "iseServo: initialize()" );
    this.id = id;
    this.state = initState;
    this.lvlDP = lvlDP;
    this.oldLvlDP = oldLvlDP;

    if(bSliderPosFlag)
    {
        this.bSliderPosFlag = bSliderPosFlag;
    }
    else
    {
        this.bSliderPosFlag = false;
    }
    this.slider = new sliderControl("Servo", this.id, initState, iViewOnly,this.bSliderPosFlag, 0, 180, 0.555556, '&deg;');
    
    this.hasRampClicked = false;
    
    this.txtDeg = $(this.id + "Deg");
    
    // Add event handlers
    if (iViewOnly === 0)
    {
      this.mouseOut = this.onMouseOut.bindAsEventListener(this);
      Event.observe($("slidCtrl" + this.id), 'mouseout', this.mouseOut);
    
      this.rampClick = this.onRampClick.bindAsEventListener(this);
      Event.observe(this.slider.e_base, 'mousedown', this.rampClick);
      
      this.handleClick = this.onHandleClick.bindAsEventListener(this);
      Event.observe($("slidCtrl" + this.id), 'mouseup', this.handleClick);
      
      this.clickUp = this.onClickUp.bindAsEventListener(this);
      Event.observe($(this.id + "Up"), 'click', this.clickUp);

      this.clickDown = this.onClickDown.bindAsEventListener(this);
      Event.observe($(this.id + "Down"), 'click', this.clickDown);
      
      this.DegChange = this.onDegChange.bindAsEventListener(this);
      Event.observe($(this.id + "Deg"), 'change', this.DegChange);
    }
    this.refresh(false);
  },
  
  onMouseOut: function(event)
  {
    var e = event;
    if (!e) { e = window.event; }
    var relTarg = e.relatedTarget || e.fromElement;
    if( relTarg )
    {
      var b1 = (relTarg.id.indexOf("slider")!=-1);
      var b2 = (relTarg.id.indexOf("base")!=-1);
      var b3 = (relTarg.id.indexOf("green")!=-1);
      if( !b1 && !b2 && !b3 ) 
      {
        if( this.hasRampClicked )
        {
          conInfo( "iseServo: onMouseOut() ["+relTarg.id+"] "+this.slider.n_value  );
          this.hasRampClicked = false;
          this.state = this.slider.n_value;
          //this.refresh();
        }
      }
    }
  },
 
  onRampClick: function(ev)
  {
     conInfo( "iseServo: onRampClick()" );
     this.hasRampClicked = true;
     var pos = Position.page(this.slider.e_base);
     var offset = ev.clientX - pos[0];
     var val = ( offset * 180 ) / this.slider.n_controlWidth;  
     var oldstate = parseInt(this.state);
     this.state = Math.floor(val);
     if (this.state < (oldstate-3))
     {
       this.slider.f_setValue(val);     
     }     
     else if (this.state > (oldstate+3))
     {
       this.slider.f_setValue(val);     
     } 
     conInfo("setting Servo DP "+this.lvlDP+" State --> " + this.state + " -- old State --> "+oldstate);   
     //window.setTimeout("ibd"+this.id+".refresh()",1000);
  },
  
  onHandleClick: function()
  {
    conInfo( "iseServo: onHandleClick()" );
    //this.state = this.txtDeg.value;
    this.refresh();
  },
  
  onClickUp: function()
  {
    conInfo( "iseServo: onClickUp()" );
    this.state = this.slider.n_value;
    this.state += 10; 
    if (this.state > 180)
    {
      this.state = 180;
    }
    this.refresh();
  },
  
  onClickDown: function()
  {
    conInfo( "iseServo: onClickDown()" );
    this.state = this.slider.n_value;
    this.state -= 10; 
    if (this.state < 0)
      this.state = 0;
    this.refresh();
  },
   
  
  onDegChange: function()
  {
    conInfo( "iseServo: onDegChange()" );
    if( isNaN(this.txtDeg.value) ) return;
    if( parseInt(this.txtDeg.value) > 180 ) this.txtDeg.value = 180;
    if( parseInt(this.txtDeg.value) < 0 ) this.txtDeg.value = 0;
    this.state = this.txtDeg.value;
    this.refresh();
  },
  
  update: function(newVal)
  {
    conInfo( "iseServo: update()" );
    this.state = newVal;
    this.refresh(newVal);
  },
  
  refresh: function(setstate)
  {
    conInfo( "iseServo: refresh() " + this.state );
    this.slider.f_setValue(this.state, true);
    this.txtDeg.value = this.state;

    if(typeof setstate == "undefined")
    {
      conInfo("setting Servo DP "+this.lvlDP+" State -------> " + this.state);    
      setDpState(this.lvlDP, (this.state / 180));
    }
  }
};

/**
 * ise/iseButtonsAirFlap.js
 **/

/**
 * @fileOverview ?
 * @author ise
 **/

/**
 * @class
 **/ 
iseButtonsAirFlap = Class.create();

iseButtonsAirFlap.prototype = {
  /*
   * id = DOM-ID of switch
   * initState = Creation State 
   */
  initialize: function(id, initState, lvlDP, oldLvlDP, iViewOnly, bSliderPosFlag, label)
  {
    conInfo( "iseAirFlap: initialize()" );
    this.id = id;
    this.state = initState;
    this.lvlDP = lvlDP;
    this.oldLvlDP = oldLvlDP;

    if(bSliderPosFlag)
    {
        this.bSliderPosFlag = bSliderPosFlag;
    }
    else
    {
        this.bSliderPosFlag = false;
    }
    this.slider = new sliderControl("AirFlap", this.id, initState, iViewOnly,this.bSliderPosFlag);

    
    this.hasRampClicked = false;
    
    this.txtPerc = $(this.id + "Perc");
    
    // Add event handlers
    if (iViewOnly === 0)
    {
      this.mouseOut = this.onMouseOut.bindAsEventListener(this);
      Event.observe($("slidCtrl" + this.id), 'mouseout', this.mouseOut);
    
      this.rampClick = this.onRampClick.bindAsEventListener(this);
      Event.observe(this.slider.e_base, 'mousedown', this.rampClick);
      
      this.handleClick = this.onHandleClick.bindAsEventListener(this);
      Event.observe($("slidCtrl" + this.id), 'mouseup', this.handleClick);

      this.PercChange = this.onPercChange.bindAsEventListener(this);
      Event.observe($(this.id + "Perc"), 'change', this.PercChange);
    }
    this.refresh(false);
  },
  
  onMouseOut: function(event)
  {
    var e = event;
    if (!e) { e = window.event; }
    var relTarg = e.relatedTarget || e.fromElement;
    if( relTarg )
    {
      var b1 = (relTarg.id.indexOf("slider")!=-1);
      var b2 = (relTarg.id.indexOf("base")!=-1);
      var b3 = (relTarg.id.indexOf("green")!=-1);
      if( !b1 && !b2 && !b3 ) 
      {
        if( this.hasRampClicked )
        {
          conInfo( "iseAirflap: onMouseOut() ["+relTarg.id+"] "+this.slider.n_value  );
          this.hasRampClicked = false;
          this.state = this.slider.n_value;
          //this.refresh();
        }
      }
    }
  },
 
  onRampClick: function(ev)
  {
     conInfo( "iseAirFlap: onRampClick()" );
     this.hasRampClicked = true;
     var pos = Position.page(this.slider.e_base);
     var offset = ev.clientX - pos[0];
     var val = ( offset * 100 ) / this.slider.n_controlWidth;  
     var oldstate = parseInt(this.state);
     this.state = Math.floor(val);
     if (this.state < (oldstate-3))
     {
       this.slider.f_setValue(val);     
     }     
     else if (this.state > (oldstate+3))
     {
       this.slider.f_setValue(val);     
     } 
     conInfo("setting AirFlap DP "+this.lvlDP+" State --> " + this.state + " -- old State --> "+oldstate);   
     //window.setTimeout("ibd"+this.id+".refresh()",1000);
  },
  
  onHandleClick: function()
  {
    conInfo( "iseAirFlap: onHandleClick()" );
    //this.state = this.txtPerc.value;
    this.refresh();
  },
  
  onPercChange: function()
  {
    conInfo( "iseAirFlap: onPercChange()" );
    if( isNaN(this.txtPerc.value) ) return;
    if( parseInt(this.txtPerc.value) > 100 ) this.txtPerc.value = 100;
    if( parseInt(this.txtPerc.value) < 0 ) this.txtPerc.value = 0;
    this.state = this.txtPerc.value;
    this.refresh();
  },
  
  update: function(newVal)
  {
    conInfo( "iseAirFlap: update()" );
    this.state = newVal;
    this.refresh(newVal);
  },
  
  refresh: function(setstate)
  {
    conInfo( "iseAirFlap: refresh() " + this.state );
    this.slider.f_setValue(this.state, true);
    this.txtPerc.value = this.state;

    if(typeof setstate == "undefined")
    {
      conInfo("setting Servo DP "+this.lvlDP+" State -------> " + this.state);    
      setDpState(this.lvlDP, (this.state / 100));
    }
  }
};

/**
 * @class
 **/
iseRFIDKey = Class.create();

iseRFIDKey.prototype = {
  /*
   * id = datapoint-ID of switch
   */
  initialize: function(id, shortId, longId, iViewOnly) {
    this.id = id;
    this.divShort = $(this.id + "Short");
    this.divLong = $(this.id + "Long");
    this.shortId = shortId;
    this.longId = longId;
    
    if( this.divShort ) { ControlBtn.off(this.divShort); }
    if( this.divLong ) { ControlBtn.off(this.divLong); }
    
    // Add event handlers
    if (iViewOnly === 0)
    {
      if (this.divShort) {
        this.clickShort = this.onClickShort.bindAsEventListener(this);
        Event.observe(this.divShort, 'mousedown', this.clickShort);
      }
      if (this.divLong) {
        this.clickLong = this.onClickLong.bindAsEventListener(this);
        Event.observe(this.divLong, 'mousedown', this.clickLong);
      }
    }
  },
  
  onClickShort: function() {
    setDpState(this.shortId, 1);
    ControlBtn.pushed(this.divShort);
    $("btn" + this.shortId + "s").src = "/ise/img/rfid_hold_80.png";
    var t = this;
    new PeriodicalExecuter(function(pe) {
      ControlBtn.off(t.divShort);
      $("btn" + t.shortId + "s").src = "/ise/img/rfid_80.png";
      pe.stop();
    }, 1);
  },
  
  onClickLong: function() {
    setDpState(this.longId, 1);
    ControlBtn.pushed(this.divLong);
    $("btn" + this.longId + "l").src = "/ise/img/rfid_hold_80.png";
    var t = this;
    new PeriodicalExecuter(function(pe) {
      ControlBtn.off(t.divLong);
      $("btn" + t.longId + "l").src = "/ise/img/rfid_80.png";
      pe.stop();
    }, 1);
  }
};

/**
 * @class
 **/
iseIRKey = Class.create();

iseIRKey.prototype = {
  /*
   * id = datapoint-ID of switch
   */
  initialize: function(id, shortId, longId, iViewOnly) {
    this.id = id;
    this.divShort = $(this.id + "Short");
    this.divLong = $(this.id + "Long");
    this.shortId = shortId;
    this.longId = longId;
    
    if( this.divShort ) { ControlBtn.off(this.divShort); }
    if( this.divLong ) { ControlBtn.off(this.divLong); }
    
    // Add event handlers
    if (iViewOnly === 0)
    {
      if (this.divShort) {
        this.clickShort = this.onClickShort.bindAsEventListener(this);
        Event.observe(this.divShort, 'mousedown', this.clickShort);
      }
      if (this.divLong) {
        this.clickLong = this.onClickLong.bindAsEventListener(this);
        Event.observe(this.divLong, 'mousedown', this.clickLong);
      }
    }
  },
  
  onClickShort: function() {
    setDpState(this.shortId, 1);
    ControlBtn.pushed(this.divShort);
    $("btn" + this.shortId + "s").src = "/ise/img/ir_hold_80.png";
    var t = this;
    new PeriodicalExecuter(function(pe) {
      ControlBtn.off(t.divShort);
      $("btn" + t.shortId + "s").src = "/ise/img/ir_80.png";
      pe.stop();
    }, 1);
  },
  
  onClickLong: function() {
    setDpState(this.longId, 1);
    ControlBtn.pushed(this.divLong);
    $("btn" + this.longId + "l").src = "/ise/img/ir_hold_80.png";
    var t = this;
    new PeriodicalExecuter(function(pe) {
      ControlBtn.off(t.divLong);
      $("btn" + t.longId + "l").src = "/ise/img/ir_80.png";
      pe.stop();
    }, 1);
  }
};


HbStatusDisplayDialogEPaper = Class.create(StatusDisplayDialog, {

  initEPaper: function () {
    conInfo("HbStatusDisplayDialogEPaper - initEPaper");
    this.displayType = "DIS-EP42BW";
  },

    // This creates the content of the dialog.
  _addElements: function() {
    var dialogContentElem = jQuery("#statusDisplayDialog"),
    textOptions = this._getTextOptions(),
    iconOptions = this._getIconOptions(),

    freeTextValue = translateKey("statusDisplayOptionFreeText"),
    arrDisabledElements = ["disabled", "","","","disabled","disabled"];

    dialogContentElem.append(function(index,html){
      //var content =  "<tr><th>&nbsp;</th><th>Text</th> <th id='headFreeText' class='hidden'></th><th name='optionHeader'>Color</th><th name='optionHeader'>Icon</th></tr>";
      var content =  "<tr><th>&nbsp;</th><th>Text</th> <th id='headFreeText' class='hidden'></th><th name='optionHeader'>Icon</th></tr>";
      for (var loop = 0; loop <= 9; loop++) {
        content +=
          "<tr>" +
            "<td>"+translateKey("statusDisplayLine")+ " "+(loop + 1)+": </td>"+
            "<td><select id='textSelect_"+loop+"' onchange='textOnChange(this)' >"+textOptions+"</select></td>" +
            "<td id='cellFreeText_"+loop+"' class='hidden'><input id='freeText_"+loop+"' type='text' value='"+freeTextValue+"' maxlength='16' size='19' style='text-align:center'></td>" +
            "<td id='placeHolder_"+loop+"' class='hidden'></td>" +
            "<td name='optionContainer_"+loop+"' class='hidden'><select id='iconSelect_"+loop+"' onchange='iconOnChange(this)'>"+iconOptions+"</select></td>" +
            "<td name='optionContainer_"+loop+"' class='hidden' id='iconPreview_"+loop+"'></td>"+
          "</tr>";
      }

      content += "<tr><td colspan='4'><hr></td></tr>";

      content += "<tr><td height='15px;'></td></tr>";

      return content;
    });
  },

    // Creates the options for the text selector
  _getTextOptions: function() {
    var options = "";
    options += "<option value='-1'>"+translateKey("stringTableNotUsed")+"</option>";
    for (var loop = 0; loop <= 19; loop++) {
      options += "<option value='"+loop+"'>"+ translateKey("statusDisplayOptionText")+ " " +(loop + 1)+"</option>";
    }
    options += "<option value='99'>"+translateKey("statusDisplayOptionFreeText")+"</option>";
    return options;
  },

    // Creates the options for the icon selector
  _getIconOptions: function() {
    var options = "",
    arOptionText = [
      translateKey("iconOff"),
      translateKey("iconOn"),
      translateKey("iconOpen"),
      translateKey("iconClosed"),
      translateKey("iconError"),
      translateKey("iconOK"),
      translateKey("iconInfo"),
      translateKey("iconNewMessage"),
      translateKey("iconServiceMessage"),
      translateKey("iconHbGarage"),
      translateKey("iconHbShutter"),
      translateKey("iconHbShutterUp"),
      translateKey("iconHbShutterDown"),
      translateKey("iconHbUp"),
      translateKey("iconHbDown"),
      translateKey("iconHbSnowflake"),
      translateKey("iconHbWarning"),
      translateKey("iconHbError"),
      translateKey("iconHbBell"),
      translateKey("iconHbCalendar"),
      translateKey("iconHbThermometer"),
      translateKey("iconHbBattery"),
      translateKey("iconHbRadiatorHorizontal"),
      translateKey("iconHbRadiatorVertical"),
      translateKey("iconHbBathtub"),
      translateKey("iconHbValve"),
      translateKey("iconHbSprinkler")

    ];

    options += "<option name='option_NotUsed' value='-1'>" + translateKey("stringTableNotUsed") + "</option>";
    for (var loop = 0; loop < 27; loop++) {
      options += "<option name='option_"+loop+"' value='"+loop+"'>" + arOptionText[loop] + "</option>";
    }
    return options;
  },

   // Creates the string, necessary for the text field within the program
  _createConfigString: function() {
    var textElm, freeTextElm,iconElm,
    result = this.startKey + ","; // Start key

    // Read 10 lines and create string
    for (var loop = 0; loop < 10; loop++) {
      textElm = jQuery("#textSelect_" + loop);
      iconElm = jQuery("#iconSelect_" + loop);
      freeTextElm = jQuery("#freeText_" + loop);

      if (textElm.val() == -1) {
        result+= this.lf + ",";
      } else {
        result += this.textKey + ",";
        if (textElm.val() != "99") {
          // Predefined text bloc
          result += this._convertVal2HexVal(textElm.val()) + ",";
        } else {
          // Free user customized text
          //result += freeTextElm.val() + ",";
          result += this._convertPlainText2Hex(freeTextElm.val());
        }
        if (iconElm.val() != -1) {
          result += this.iconKey + ",";
          result += this._convertVal2HexVal(iconElm.val()) + ",";
        }
        result += this.lf + ",";
      }
    }
    result+= this.endKey; // End key
    this.configString = result;
  },
  /**
   * Initializes the dialog
   * @private
   */
  _initAllValues: function() {
    var self = this,
    arValues = this.channelValue.split(","),
    sizeChannelValue = arValues.length,
    arAllValues = this._getAllValues();

    conInfo("DIS-EP42BW: All values of the channel: ");
    conInfo(arAllValues);

    jQuery.each(arAllValues, function(index, line) {
      var textElm = jQuery("#textSelect_" + index),
      iconElm = jQuery("#iconSelect_" + index),
      freeTextElm = jQuery("#freeText_" + index);

      if (line.text != "notUsed") {
        textElm.val(self._convertHexVal2Val(line.text));
        // User defined text
        if (parseInt(line.text.split(",")[0],16) < 128) {
          freeTextElm.val(decodeStringStatusDisplay(self._convertHexString2PlainText(line.text)));
        }
        if (line.icon != -1) {
          iconElm.val(self._convertHexVal2Val(line.icon));
          setIconPreview({index: index, value: iconElm.val()});
        } else {
          // Icon not in use
          iconElm.val("-1");
        }
        displayStatusDisplayOptionContainer(index, true);
      } else {
        textElm.val("-1");
      }
    });

    setFreeTextContainer();
  },
    // Returns an array of objects with the values of all lines.
  // [Object {text="0x80, color="0x81", icon="0x82},.....]}
  _getAllValues: function() {
    var val = this.channelValue;
    var arValues = val.split(","), //replace(/ /g, "").split(","),
    arLines = []; // contains the lines 1,2,3

    // Is a start key and end key available? Otherwise the string isn¬•t valid.
    if (arValues[0] == this.startKey && arValues[arValues.length - 1] == this.endKey) {
      var lineIndex = 0,
      textIndex,
      nextTextBlockIndex = 0,
      textOffset = 0;

      arValues.shift(); // remove the start key 0x02
      arValues.pop(); // remove the end key 0x03
      //console.log("arValues: " + arValues);
      for (var loopx = 0; loopx < arValues.length; loopx++) {
        //console.log("current loopx: " + loopx);
        var valueSet = {};
        nextTextBlockIndex = 0;
                // Is LF?
        if (arValues[loopx] == this.lf) {
          valueSet.text="notUsed";
           arLines[lineIndex] = valueSet;
          lineIndex++;
        }

        if (arValues[loopx] == this.textKey) {
          valueSet.text = "";
          // Read till icon or lf and increase loopx by the number of read chars
          textIndex = loopx + 1;
          do {
            valueSet.text += arValues[textIndex];
            if ((arValues[textIndex + 1] != this.iconKey) && (arValues[textIndex + 1] != this.lf)) {
              valueSet.text += ",";
            }

            //console.log("added char: " + arValues[textIndex]);
            textIndex++;
            nextTextBlockIndex++;
          } while ((arValues[textIndex] != this.iconKey) && (arValues[textIndex] != this.lf)) ;

          // Icon hinzuf¬∏gen, entweder nicht benutzt (-1) oder den entsprechenden Wert
          // Add the icon, either not used (-1) or the correspondent value
          valueSet.icon = (arValues[textIndex] == this.iconKey) ? arValues[textIndex + 1] : -1;
          arLines[lineIndex] = valueSet;
          lineIndex++;
          if (valueSet.icon == -1) {textOffset = 1;} else {textOffset = 3;}
          // Jump to the next text block
          loopx += nextTextBlockIndex + textOffset; // Springe zum n‚Ä∞chsten Textblock
          //console.log("new loopx : " + loopx);
        }
      }
    } else {
      conInfo("Value string invalid");
    }
    return arLines;
  }
});

YesNoDialog.RESULT_NO = 0;
YesNoDialog.RESULT_YES = 1;

function jphbInfoButton() {
  jQuery("#jphbError").hide();        
  if (homematic('CCU.existsFile', {'file': "/usr/local/addons/jp-hb-devices-addon/install_error"})) {
    jQuery("#jphbError").show();        
  }

  var fileJPHBInfo = "/usr/local/addons/jp-hb-devices-addon/infoPageVisited";

  jQuery("#jphbInfoPage").hide();        
  
  var localInfoVersion = homematic('jp.getInfoWebVersion', {'file': fileJPHBInfo});
  var  webInfoVersion  = 0;
  
  if (localInfoVersion === 0) { jQuery("#jphbInfoPage").show(); }   
                                         
  jphbInfoPageClick = function() { homematic('jp.setInfoWebVersion', {'file': fileJPHBInfo, 'version': webInfoVersion}); jQuery("#jphbInfoPage").hide(); }   
  
  function setInfoVersion(responseText) {
    webInfoVersion = parseInt(responseText, 10) || 0;
    if (localInfoVersion < webInfoVersion) {
      jQuery("#jphbInfoPage").show();
    }
  }
  
  function errorFunc(error) {
    consle.error(error); 
  }             
  
  function httpGet(u) {                                  
     return new Promise(function(resolve, reject) {        
       var xhr = new XMLHttpRequest();                     
       xhr.addEventListener("load", function() {           
         resolve(this.responseText);                                                                                                         
       });                                                 
       xhr.open('GET', u);                        
       xhr.send();                                                                                                  
     });                                                                                                            
   }                                                                                                                   
 
  // httpGet Promise resolved mit "responseText"
  httpGet('https://raw.githubusercontent.com/jp112sdl/JP-HB-Devices-addon/gh-pages/version').then(setInfoVersion).catch(errorFunc);
}