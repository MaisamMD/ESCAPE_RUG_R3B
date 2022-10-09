#!/bin/bash

# This script (re)sets all inputs to default values:
cd ./InputFiles
rm -rf ./InputsFile.txt
rm -rf ./OutputPath.txt
cd ../Macros
root -b -l -q GenerateInputs.cpp
#root -b -l -q GenerateSAMURAIInputs.cpp
#root -b -l -q GenerateSnAumannInputs.cpp
cd ../
