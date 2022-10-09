#!/bin/bash

# Generates the Geometry of the simulation:

root -b -l -q NeuLAND_BuildGeometry.cpp
root -b -l -q VETO_BuildGeometry.cpp
root -b -l -q NEBULA_BuildGeometry.cpp
root -b -l -q NEBULA_VETO_BuildGeometry.cpp
root -b -l -q GLAD_BuildGeometry.cpp
root -b -l -q Build_Chamber_Dummy_Geometry.cpp
root -b -l -q Target_BuildGeometry.cpp
root -b -l -q PSP_BuildGeometry.cpp
root -b -l -q StarTrack_BuildGeometry.cpp
root -b -l -q VacuumVessel_BuildGeometry.cpp
root -b -l -q CALIFA_BuildGeometry.cpp
root -b -l -q TOFwall_BuildGeometry.cpp
