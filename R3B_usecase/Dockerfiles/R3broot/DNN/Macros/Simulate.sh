#!/bin/bash

# Perform the full simulation:
root -b -l -q MCtransport.cpp
root -b -l -q NeuLAND_Digitizer.cpp
root -b -l -q NeuLAND_JanClusters.cpp
root -b -l -q NeuLAND_Translation.cpp
root -b -l -q ClusterSignals.cpp
root -b -l -q NeuLAND_ScoreCollection.cpp
root -b -l -q TranslateClusters.cpp
root -b -l -q TradMed_ComputeCuts.cpp
