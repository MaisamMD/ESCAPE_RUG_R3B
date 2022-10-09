#!/bin/bash

# Performs an entire simulation:

# root -b -l -q ChangeInputs.cpp

cd ../Geometry/
root -b -l -q NeuLAND_BuildGeometry.cpp
#root -b -l -q GLAD_BuildGeometry.cpp
cd ../Macros/

root -b -l -q MCtransport.cpp
root -b -l -q NeuLAND_Digitizer.cpp
root -b -l -q NeuLAND_Translation.cpp
root -b -l -q ClusterSignals.cpp
root -b -l -q TranslateClusters.cpp
root -b -l -q TradMed_ComputeCuts.cpp
root -b -l -q TradMed_Apply.cpp
