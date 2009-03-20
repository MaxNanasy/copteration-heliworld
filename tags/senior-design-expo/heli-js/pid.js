FS.PidController = FS.Object.extend({
	t: 0,				//this is the target value we want our measured value to match. Set this directly from the context in which this controller will be used.
	m: 0,				//this is the measured value that we want to fix. Set this directly from the context in which this controller will be used.
	e: 0,				//this is the error on the most recent (or current) step.
	kc: 1/20000,		//this is the gain for the proportional component.
	ti: 100000,			//this is the time constant for the integrative component.
	td: 10000,			//this is the time constant for the derivative component.
	ie: 0,				//this is the running integral of error, in units of error*milliseconds. This is the accumulation of all the error over time from the controller's inception.
	de: 0,				//this is the running derivative of error, in units of error per millisecond. This is how much the error changed per milli over the last frame.
	out: 0,				//this is the output of the controller: use this to set the value that will be controlled by this controller.

//	init: function() {
//		arguments.callee.base.call(this);
//	},
	prepare: function() {
		this.e = this.t - this.m;
	},
	step: function(time,frameCount) {
		var newE = this.t - this.m;
		this.de = (newE - this.e) / time;	//the derivative of the error for this frame becomes the amount the error changed per millisecond over the last frame.
		this.e = newE;						//the error is the target value minus the measured value.
		this.ie += this.e * time;			//the integrated error gets the current error times frame-time added to it.
		this.out = 0 + this.kc*(this.e + 1*1/this.ti*this.ie + 1*this.td*this.de);
		//clog("FRAME COUNT="+frameCount+"\nt="+this.t+"\nm="+this.m+"\ne="+this.e+"\n\nie="+this.ie+"\nde="+this.de+"\nout="+this.out);
	}
});