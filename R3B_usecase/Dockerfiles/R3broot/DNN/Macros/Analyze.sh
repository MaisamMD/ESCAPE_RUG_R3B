#!/bin/bash

# Performs all Analysis FairTasks. Test if the input is a positive integer:
if [ $1 -eq $1 2>/dev/null -o $1 -eq 0 2>/dev/null ] && [ $1 -gt "0" ]
then
    if [ -z "$1" ] || [ $1 -eq '1' ]
    then
        root -b -l -q "Read_DNN_Multiplicity.cpp(1)"
        root -b -l -q "BetaReconstruction.cpp(1)"
        root -b -l -q "SingleReconstruction.cpp(1)"
        root -b -l -q "GetMultMatrices.cpp(1)"
        root -b -l -q "TradMed_Apply.cpp(1)"
        root -b -l -q "NeuLAND_ScoreApplication.cpp(1)"
        root -b -l -q "NeuLAND_DNNScoreApplication.cpp(1)"
        root -b -l -q "CombineReconstructions.cpp(1)"
        root -b -l -q "ConvertReconstruction.cpp(1)"
        root -b -l -q "ApplyVETOCondition.cpp(1)"
        root -b -l -q "NeuLAND_DetectionRate.cpp(1)"
        root -b -l -q "ErelSpectra.cpp(1,kTRUE)"
        root -b -l -q "PhysListPlots.cpp(1)"
        root -b -l -q "MakePlots.cpp(kTRUE)"
    else
        root -b -l -q "Read_DNN_Multiplicity.cpp($1)"
        root -b -l -q "BetaReconstruction.cpp($1)"
        root -b -l -q "SingleReconstruction.cpp($1)"
        root -b -l -q "GetMultMatrices.cpp($1)"
        root -b -l -q "TradMed_Apply.cpp($1)"
        root -b -l -q "NeuLAND_ScoreApplication.cpp($1)"
        root -b -l -q "NeuLAND_DNNScoreApplication.cpp($1)"
        root -b -l -q "CombineReconstructions.cpp($1)"
        root -b -l -q "ConvertReconstruction.cpp($1)"
        root -b -l -q "ApplyVETOCondition.cpp($1)"
        root -b -l -q "NeuLAND_DetectionRate.cpp($1)"
        root -b -l -q "ErelSpectra.cpp($1,kTRUE)"
        root -b -l -q "PhysListPlots.cpp($1)"
        root -b -l -q "MakePlots.cpp(kTRUE)"
    fi
else
echo '### FATAL: You should supply a positive integer as input to this script!'
fi
