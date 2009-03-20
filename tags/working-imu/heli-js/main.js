var WIND_ON = true;
var AUTO_ON = false;

FSHost.simpleAttach();

function main() {
  window.WRAPPER = document.getElementById('wrapper');
  FSHost.resizeFun.addFun(resized);
  FSHost.mouseMoveFun.addFun(mouseMoved);
  FSHost.keyPressFun.addFun(keyPressed);
  createCopter();
  createReadout();
}

function resized() {
  
}

function createCopter() {
  window.HELI = Heli.create().start();
}

function createReadout() {
  window.DASH = HeliDash.create({heli: HELI}).start();
}

function mouseMoved() {
  if(!window.HELI || AUTO_ON) return;
  var x=FSHost.mouse.x, y=FSHost.mouse.y, w=FSHost.bounds.X, h=FSHost.bounds.Y;
  HELI.throttle = 2*(h-y)/h;
  HELI.tilt     = 4*(x/w-.5)*90*Math.PI/360;
}

function toggleAuto() {
  AUTO_ON = !AUTO_ON;
  if(window.HELI) HELI.auto = AUTO_ON;
}

function toggleWind() {
  WIND_ON = !WIND_ON;
}

function keyPressed(e) {
  if(e.which==119) toggleWind();
  else if(e.which==97)  toggleAuto();
  else if(e.which==13 || e.which==114) {}
  // else alert(e.which);
}




function celebrate() {
  for(var i=0; i<20; i++)
    FS.Particle.create().start();
}
