#!/usr/bin/python

# Using TOSSIM, this script simulates the interaction between the remote, autopilot, and environment.

from TOSSIM import *
import sys

node = 0;

t = Tossim ([])

# simNode exists to boot the two motes, since we can't have a heterogeneous simulation, and initiate the environment.
simNode = t.getNode (node)

remoteLogFile      = open ("/tmp/Remote.log"     , "w")
autopilotLogFile   = open ("/tmp/Autopilot.log"  , "w")
environmentLogFile = open ("/tmp/Environment.log", "w")

t.addChannel ("Remote"     , remoteLogFile     )
t.addChannel ("Autopilot"  , autopilotLogFile  )
t.addChannel ("Environment", environmentLogFile)

# This will boot the two motes and initiate the environment.
simNode.bootAtTime (0)

# This runs the simulation.
for i in range (100000): t.runNextEvent()
