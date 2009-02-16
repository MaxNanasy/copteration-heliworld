Heli = FS.Particle.extend({
  throttle: 1,    //ranges from 0 to 2, with 1 equalling throttle equivalent to the weight of the helicopter. At 2, the helicopter should accelerate upward at G.
  tilt: 0,        //0 is vertical; positive radians are clockwise tilt, and negative radians are counterclockwise tilt.
  auto: false,

  s: {x:0,y:0},
  bounceFactor:0.3,
  edgeMode: "bounce",
  universe: WIND,

  init: function() {
    var e = this.element = this.can = document.createElement('canvas');
    this.con = e.getContext('2d');
    e.style.cssText = "position:absolute; z-index:2; left:"+Math.round(FSHost.bounds.X/2-50)+"px; top:"+Math.round(FSHost.bounds.Y/2-50)+"px; width:100px; height:100px;";
    e.width = (e.height = 100);
    WRAPPER.appendChild(e);
    arguments.callee.base.call(this);
    this.tS = FS.Pair.create();
    this.tP = FS.Pair.create({x:FSHost.bounds.w/2-50, y:FSHost.bounds.h/2-50});
    this.tA = FS.Pair.create();
    FS.setInterval(function(){
      if(true || this.frameCount%2!=0) return;
      var img = document.createElement('img');
      img.src = "images/puff.png";
      img.style.cssText = "position:absolute; width:30px; height:30px; z-index:1;";
      WRAPPER.appendChild(img);
      FS.Particle.create({element: img, mass: .1, universe:this.universe, p:{x:this.p.x+50-15,y:this.p.y+50-15}, s:this.s.clone(),
        onframe: function() {
          this.element.style.width  = 30+(this.elapsedTime/1000*120)+"px";
          this.element.style.height = 30+(this.elapsedTime/1000*120)+"px";
        }
      }).start();
    }.bind(this),0);
  },
  
  run: function(time) {
    arguments.callee.base.apply(this,arguments);
    var th = this.throttle;
    var ti = this.tilt;
    var xT = this._thrX = th * Math.sin(ti);
    var yT = this._thrY = th * Math.cos(ti);
    this.s.x += xT*time/1000;
    this.s.y -= yT*time/1000;
    
    this.tS.x = FS.bound((this.tP.x - this.p.x)/150,-1,1);
    this.tS.y = FS.bound((this.tP.y - this.p.y)/150,-1,1);
    this.tA.x = (this.tS.x - this.s.x)/5;
    this.tA.y = (this.tS.y - this.s.y)/5;
    if(this.auto) {
      if(this.tA.x < this.a.x)
        this.tilt -= 3*Math.PI/360;  //rotate a tenth of a degree per frame
      else
        this.tilt += 3*Math.PI/360;
      if(this.tA.y < this.a.y)
        this.throttle += .1;// * Math.abs(this.a.y-this.tA.y);      //adjust throttle by a thousanth of a capacity per frame
      else
        this.throttle -= .1;// * Math.abs(this.a.y-this.tA.y);
      // this.throttle = FS.bound(this.throttle,.2,1.8);
      this.tilt = FS.bound(this.tilt,Math.PI/-4,Math.PI/4);
    }
    
    this.paint();
  },
  
  paint: function() {
    var t = this.tilt, c = this.con, e = this.can;
    try{
      c.clearRect(0,0,100,100);
      c.fillStyle = "black";
      c.save();
      c.translate(50,50);
      c.save();
      c.rotate(this.tilt);
      c.fillRect(-30,-5,60,10);
      c.fillStyle = "red";
      c.fillRect(-1,0-this.throttle*20,1,this.throttle*20);
      c.restore();
      var g = this.universe.gravity();
      c.fillStyle = "green";
      c.fillRect(-1,0,1,g.y*20);
      c.restore();
    } catch(e) {      c.restore();      c.restore();clog("Bad Canvas Thing Occurred.");}
  }
  
  
  
  
});