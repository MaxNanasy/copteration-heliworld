HeliDash = FS.Object.extend({
  heli: null,
  b: FS.BoundedArea.create({x:10,y:10,X:500,Y:10}),
  init: function() {
    arguments.callee.base.call(this);
    var e = this.element = document.createElement('div');
    var s = this.span = document.createElement('span');
    s.style.cssText = "position:absolute; left:10px; top:30px;";
    e.appendChild(s);
    e.style.cssText = "position:absolute; background:#DDDDDD; border:1px solid #999999; opacity:.5; color:black; width:"+this.b.w+"px; height:"+this.b.h+"px; left:"+this.b.x+"px; top:"+this.b.y+"px; font-family:lucida grande, tahoma, sans-serif; font-size:11px;";
    this.updater = FS.Task.create({onframe:this.update.bind(this)});

    this.autoButton = this.makeButton('Wind',toggleAuto);
    this.windButton = this.makeButton('Auto',toggleWind);

    WRAPPER.appendChild(e);
    
    var vertLine = this.vertLine = document.createElement('div');
    vertLine.style.cssText = "position:absolute; opacity:.5; left:50%; top:0px; width:1px; height:100%; background:white;";
    WRAPPER.appendChild(vertLine);
    var horzLine = this.horzLine = document.createElement('div');
    horzLine.style.cssText = "position:absolute; opacity:.5; top:50%; left:0px; height:1px; width:100%; background:white;";
    WRAPPER.appendChild(horzLine);
    
    
    this.gTA = Gauge.create({pair: this.heli.tA, p:{x:140, y:FSHost.bounds.Y-60},  name: "tA"});
    this.gA =  Gauge.create({pair: this.heli.a,  p:{x:80, y:FSHost.bounds.Y-60},  name: "a"});
    this.gTS = Gauge.create({pair: this.heli.tS, p:{x:270, y:FSHost.bounds.Y-60}, name: "tS"});
    this.gS =  Gauge.create({pair: this.heli.s,  p:{x:210, y:FSHost.bounds.Y-60}, name: "s"});
    
    this.gWind =  Gauge.create({pair: WIND.wind(),  p:{x:10, y:FSHost.bounds.Y-60}, name: "wind"});

  },
  
  makeButton: function(value,action) {
    var b = document.createElement('input');
    b.setAttribute('type','button');
    b.onclick = action;
    b.value = value;
    this.element.appendChild(b);
    return b;
  },
  
  start: function() {
    this.updater.start();
    return this;
  },
  stop: function() {
    this.updater.stop();
    return this;
  },
  
  update: function() {
    if(!this.heli) return;
    var h = this.heli;

    var windValue = WIND_ON?"Disable Wind (w)":"Enable Wind (w)";
    if(this.windButton.value!=windValue) this.windButton.value = windValue;
    var autoValue = AUTO_ON?"Disable Autopilot (a)":"Enable Autopilot (a)";
    if(this.autoButton.value!=autoValue) this.autoButton.value = autoValue;

    var html = "<big><center>Helicopter State<br></center></big>";
    html+="Throttle: "+h.throttle;
    html+="<br>&nbsp;&nbsp;&nbsp;&nbsp;along X: "+h._thrX;
    html+="<br>&nbsp;&nbsp;&nbsp;&nbsp;along Y: "+h._thrY;
    html+="<br>Tilt: "+h.tilt;
    html+="<br>Position: "+h.p;
    html+="<br>Target Position: "+h.tP;
    html+="<br>Speed: "+h.s;
    html+="<br>Target Speed: "+h.tS;
    html+="<br>Acceleration: "+h.a;
    html+="<br>Target Acceleration: "+h.tA;
    html+="<br>";
    html+="<br>";
    html+="<big><center>World State<br></center></big>";
    html+="Wind: "+WIND.wind();
    this.span.innerHTML = html;
    this.element.style.height = this.span.offsetHeight+2*this.span.offsetTop+"px";
    this.element.style.width  = this.span.offsetWidth+2*this.span.offsetLeft+"px";
  }
});