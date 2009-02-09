#!/usr/bin/python

from TOSSIM import *
import sys

remoteNode = 0;

t = Tossim ([])

remote    = t.getNode (remoteNode)

remoteLogFile      = open ("/tmp/Remote.log"     , "w")
autopilotLogFile   = open ("/tmp/Autopilot.log"  , "w")
environmentLogFile = open ("/tmp/Environment.log", "w")

t.addChannel ("Remote"     , remoteLogFile     )
t.addChannel ("Autopilot"  , autopilotLogFile  )
t.addChannel ("Environment", environmentLogFile)

remote.bootAtTime (0)

for i in range (100000): t.runNextEvent()
