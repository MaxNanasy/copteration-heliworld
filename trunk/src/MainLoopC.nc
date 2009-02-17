#define MS 91900 //keep as 919 for real program
#define MAX_PW_ROTORS 19*MS
#define MIN_PW_ROTORS MS
#define MAX_PW_TILTS 2*MS
#define MIN_PW_TILTS MS
#define DELTA_ROTORS MAX_PW_ROTORS-MIN_PW_ROTORS
#define DELTA_TILTS MAX_PW_TILTS-MIN_PW_TILTS

/*assumes we have a cycle-counting integer, that is global. call it cycleCount.*/

module MainLoopC {
  uses interface Counter<TMicro,uint32_t>;
  uses interface Leds;

  provides interface Init;
  provides interface Motors;
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
  
  //set the first period's rise time to 10ms after the current clock cycle.
  command error_t Init.init () {
    nextRise = call Counter.get() + 10*MS;
    nextRollDrop =  nextRise + rollPW;
    nextPitchDrop = nextRise + pitchPW;
    nextLoDrop =    nextRise + loRotorPW;
    nextHiDrop =    nextRise + hiRotorPW;
    return SUCCESS;
  }
  
  int main_loop () {
    int cc, temp, remainingTimeUntilNextDuty;
    bool running = TRUE;
    while(running) {                                //while in this function, run and run and run...
      cc = call Counter.get();                              //TODO GET THE CURRENT CLOCK CYCLE NUMBER.
      if(cc >= nextRollDrop) {
                                                    //here, set roll motor pin to zero.
        nextRollDrop = nextRise + rollPW;
        call Leds.led0Off();
      }
      if(cc >= nextPitchDrop) {
                                                    //here, set pitch motor pin to zero.
        nextPitchDrop = nextRise + pitchPW;
        call Leds.led1Off();
      }
      if(cc >= nextLoDrop) {
                                                    //here, set lower rotor motor pin to zero.
        nextLoDrop = nextRise + loRotorPW;
        call Leds.led2Off();
      }
      if(cc >= nextHiDrop) {
                                                    //here, set upper rotor motor pin to zero.
        nextHiDrop = nextRise + hiRotorPW;
      }
      if(cc >= nextRise) {
                                                    //here, set all four pins back to ONE. High voltage. They'll incrementally drop over the next period time.
        nextRise += period;
        call Leds.led0On();
        call Leds.led1On();
        call Leds.led2On();
      }
      remainingTimeUntilNextDuty = nextRollDrop-cc;
      if(remainingTimeUntilNextDuty > (temp = nextPitchDrop-cc)) remainingTimeUntilNextDuty = temp;
      if(remainingTimeUntilNextDuty > (temp = nextLoDrop-cc))    remainingTimeUntilNextDuty = temp;
      if(remainingTimeUntilNextDuty > (temp = nextHiDrop-cc))    remainingTimeUntilNextDuty = temp;
      if(remainingTimeUntilNextDuty > (temp = nextRise-cc))      remainingTimeUntilNextDuty = temp;
      if(remainingTimeUntilNextDuty > minSleepTime) //if there is a bit of downtime without having to do anything, just exit.
        running = FALSE;
    }
                                                    //return the number of milliseconds that the rest of the software is allotted before it has to come back to main_loop.
    return remainingTimeUntilNextDuty / MS;  //keep it as an integer in order to force rounding down, so that we will err on the side of caution.

  }
  async command void Motors.setTopRotorPower (float power) {
    hiRotorPW = MIN_PW_ROTORS + power*DELTA_ROTORS;
  }
  async command void Motors.setBottomRotorPower (float power) {
    loRotorPW = MIN_PW_ROTORS + power*DELTA_ROTORS;
  }
  async command void Motors.setPitchPower (float power) {
    pitchPW = MIN_PW_TILTS + power*DELTA_TILTS;
  }
  async command void Motors.setRollPower (float power) {
    rollPW = MIN_PW_TILTS + power*DELTA_TILTS;
  }
  
  async event void Counter.overflow() {
  //freak out, because we just overflowed a 32-bit microsecond counter!!!!!!! :(
  }
}