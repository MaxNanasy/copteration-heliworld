WIND = FS.Universe.create({
  gravity: function() {return {x:0, y:1};},
  wX: 0,
  offX: 0,
  wY: 0,
  init: function() {
    this._wind = FS.Pair.create();
    this._zero = FS.Pair.create();
    this.updater = FS.Task.create({
      name: "Wind Updater",
      onframe: function() {
        this.wX += .3*(Math.random()-this.wX);
        this.wY += .3*(Math.random()-this.wY);
      }.bind(this)
    }).start();
    this.switcher = FS.setInterval(function() {
      this.offX = .3*(Math.random()*4 - 1);
    }.bind(this),1000,{
      name: "Wind Switcher"
    });
  },
  wind: function() {
    this._wind.x = WIND_ON ? 5*(this.wX-.5)+this.offX : 0;
    this._wind.y = WIND_ON ? 5*(this.wY-.5)           : 0;
    return this._wind;
  },
  viscosity: function() {return .1;}
});