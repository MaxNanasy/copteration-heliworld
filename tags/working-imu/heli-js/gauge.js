Gauge = FS.Object.extend({
  pair: null,
  p: null,
  init: function() {
    if(!this.p) this.p=FS.Pair.create();
    this.element = this.can = document.createElement('canvas');
    this.con = this.can.getContext('2d');
    this.can.width = (this.can.height = 50);
    this.can.style.cssText = "width:50px; height:50px; position:absolute; border:1px solid navy;";
    WRAPPER.appendChild(this.can);
    this.updateToPos();
    this.updater = FS.Task.create({
      name: "Updater for Gauge "+this.name,
      onframe: this.paint.bind(this)
    }).start();
  },
  updateToPos: function() {
    this.element.style.left = this.p.x+"px";
    this.element.style.top  = this.p.y+"px";
  },
  paint: function() {
    if(!this.pair) return;
    // this.con.fillStyle = Math.random()>0.5?"white":document.body.style.backgroundColor;
    this.con.clearRect(0,0,50,50);

    this.con.strokeStyle = "rgba(255,255,255,0.5)";
    this.con.beginPath();
    this.con.moveTo(25,0);
    this.con.lineTo(25,50);
    this.con.moveTo(0,25);
    this.con.lineTo(50,25);
    this.con.closePath();
    this.con.stroke();

    this.con.strokeStyle = "black";    
    this.con.beginPath();
    this.con.moveTo(25,25);
    this.con.lineTo(25+this.pair.x*20, 25+this.pair.y*20);
    this.con.closePath();
    this.con.stroke();
  }
});