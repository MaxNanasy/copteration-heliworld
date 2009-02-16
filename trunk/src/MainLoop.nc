#define MS 7353;

/*assumes we have a cycle-counting integer, that is global. call it cycleCount.*/

module MainLoop {
  
}

implementation {
  //waveform period in units of single-cycle times.
  int period        = MS*2065/100;                  //this is 20.65 milliseconds.
  
  //pulse widths in units of single-cycle times.
  int rollPW        = MS*3/2;                       //this is 1.5 ms     
  int pitchPW       = MS*3/2;                       //this is 1.5 ms
  int loRotorPW     = MS*10;                        //this is 10 ms
  int hiRotorPW     = MS*10;                        //this is 10 ms
  
  //these are the next cycleCount-based times at which the motor's pulses will be set back to zero.
  int nextRollDrop  = 0;               
  int nextPitchDrop = 0;
  int nextLoDrop    = 0;
  int nextHiDrop    = 0;
  
  //this is the next rise time for all four motors.
  int nextRise      = 0;
  
  //this is the minimum allowable time to exit the loop and let other components do their things.
  int minSleepTime  = MS*3;                         //this is 3 ms.
  
  command void prepare () {                         //prepare by setting the first period's rise time to 10ms after the current clock cycle.
    nextRise = cycleCount + 10*MS;
    nextRollDrop =  nextRise + rollPW;
    nextPitchdrop = nextRise + pitchPW;
    nextLoDrop =    nextRise + loRotorPW;
    nextHiDrop =    nextRise + hiRotorPW;
  }
  
  command int main_loop () {
    int cc, temp, remainingTimeUntilNextDuty;
    bool running = true;
    while(running) {                                //while in this function, run and run and run...
      cc = cycleCount;                              //TODO GET THE CURRENT CLOCK CYCLE NUMBER.
      if(cc >= nextRollDrop) {
                                                    //here, set roll motor pin to zero.
        nextRollDrop = nextRise + rollPW;
      }
      if(cc >= nextPitchDrop) {
                                                    //here, set pitch motor pin to zero.
        nextPitchDrop = nextRise + pitchPW;
      }
      if(cc >= nextLoDrop) {
                                                    //here, set lower rotor motor pin to zero.
        nextLoDrop = nextRise + loRotorPW;
      }
      if(cc >= nextHiDrop) {
                                                    //here, set upper rotor motor pin to zero.
        nextHiDrop = nextRise + hiRotorPW;
      }
      if(cc >= nextRise) {
                                                    //here, set all four pins back to ONE. High voltage. They'll incrementally drop over the next period time.
        nextRise += period;
      }
      remainingTimeUntilNextDuty = nextRollDrop-cc;
      if(remainingTimeUntilNextDuty > (temp = nextPitchDrop-cc)) remainingTimeUntilNextDuty = temp;
      if(remainingTimeUntilNextDuty > (temp = nextLoDrop-cc))    remainingTimeUntilNextDuty = temp;
      if(remainingTimeUntilNextDuty > (temp = nextHiDrop-cc))    remainingTimeUntilNextDuty = temp;
      if(remainingTimeUntilNextDuty > (temp = nextRise-cc))      remainingTimeUntilNextDuty = temp;
      if(remainingTimeUntilNextDuty > minSleepTime) //if there is a bit of downtime without having to do anything, just exit.
        running = false;
    }
                                                    //return the number of milliseconds that the rest of the software is allotted before it has to come back to main_loop.
    return remainingTimeUntilNextDuty / CYCLES_PER_MS;  //keep it as an integer in order to force rounding down, so that we will err on the side of caution.
  }
}