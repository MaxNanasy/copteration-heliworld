var tPBox, aPBox;
var WRAPPER;
var boxMover;

function main() {

	WRAPPER = document.getElementById('wrapper');

	tPBox = document.createElement('div');
	tPBox.style.cssText = "position: absolute; left: -1000px; top: 50%; width:10px; height: 10px; background: black; z-index: 10;";
	WRAPPER.appendChild(tPBox);

	aPBox = document.createElement('div');
	aPBox.style.cssText = "position: absolute; left: 0px; top: 50%; width:10px; height: 10px; background: white; z-index: 11; opacity: .5;";
	WRAPPER.appendChild(aPBox);

	boxMover = FS.Task.create({
		name: "box mover",
		minFPS: 100,
		tP: 500,
		aP: 0,
		init: function() {
			arguments.callee.base.call(this);
			this.controller = FS.PidController.create();
			this.controller.t = this.tP;
			this.controller.m = this.aP;
			this.controller.prepare();
		},
		run: function(time) {
			if(!time) return;
			tPBox.style.left = this.tP + "px";
			aPBox.style.left = this.aP + "px";
			this.controller.t = this.tP;
			this.controller.m = this.aP;
			this.controller.step(time,this.frameCount);
			this.aP += time * this.controller.out;			
		}
	}).start();

}
