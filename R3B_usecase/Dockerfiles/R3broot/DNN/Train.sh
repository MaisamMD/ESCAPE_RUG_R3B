#!/bin/bash

# Full script for network training. Only one input-parameter is required:
# The number of threads to execute the script on.
# A second argument can be provided to the script. If this is 'GPU', the 
# Script will use GPU TensorFlow instead of regular TensorFlow.

# First deal with the inputs and set them to training specs:
cd ./Macros
root -b -l -q GenerateTrainingInput.cpp
cd ../

# Next, obtain the output Path:
cd ./Macros/
root -b -l -q GenerateOutputPath.cpp
root -b -l -q GenerateMaxMultiplicity.cpp
root -b -l -q GenerateUseNEBULA.cpp
cd ../

# And read it into bash:
read TheOutputPath < ./InputFiles/OutputPath.txt
read MaxMultiplicity < ./InputFiles/MaxMultiplicity.txt
read NEBULAFLAG < ./InputFiles/NEBULA_Presence.txt

# Add the Training:
TrainingOutputPath="${TheOutputPath}/DNN_Training/"

# Then, check if the directory exists:
if [ ! -d "${TrainingOutputPath}" ]
then
    # Then, we should make it:
    mkdir -p ${TrainingOutputPath}
    
    # Check the DNN DataBase:
    if [ ! -d "${TrainingOutputPath}/DNN_DataBase/" ]
    then
        mkdir -p "${TrainingOutputPath}/DNN_DataBase/"
    fi
    
    # Check step 2:
    for ((nMult=0; nMult<${MaxMultiplicity}; ++nMult))
    do
        ThisMult=`expr ${nMult} + 1`
        
        if [ ! -d "${TrainingOutputPath}/DNN_Step2_Mult${ThisMult}/" ]
        then
            mkdir -p "${TrainingOutputPath}/DNN_Step2_Mult${ThisMult}/"
        fi
    done
fi

# Then, generate the geometry:
cd ./Geometry
./Geometry.sh
cd ../

# Next, see if we have an input:
if [ -z "$1" ] || [ $1 -eq '1' ]
then
    # Then, there is no input, so we should just run in single-thread mode:
    echo ''
    echo ' ===========> Executing single-thread simulation <=========='
    echo ''
    cd ./Macros
    
    # Simply do the simulation:
    root -b -l -q MCtransport.cpp
    root -b -l -q NeuLAND_Digitizer.cpp
    root -b -l -q NeuLAND_JanClusters.cpp
    root -b -l -q NeuLAND_Translation.cpp
    root -b -l -q ClusterSignals.cpp
    root -b -l -q NeuLAND_ScoreCollection.cpp
    root -b -l -q "TranslateClusters.cpp(1,0,kFALSE)"
    root -b -l -q TradMed_ComputeCuts.cpp
    
    # Then, no more is required here.
    cd ../
else
    # Then, we should run in multi-thread mode:
    echo ''
    echo ' ===========> Executing MULTI-THREAD simulation <==========='
    echo ''
    cd ./MT
    
    # Execute Multi-thread part. This script will only work if a
    # positive integer has been supplied:
    ./ExecuteMT.sh $1
    wait
    
    # Next, we have to merge the files, so that we can do the rest 
    # in single-thread mode. Generate the required Par-file:
    ./GenerateParFile.sh $1
    wait
    
    # And then, we will have to merge all files.
    ./MergeTheFiles.sh $1
    wait
    
    # Then, run the scorecollection (on the whole dataset!)
    cd ../Macros
    root -b -l -q "NeuLAND_ScoreCollection.cpp($1,-1)"
    
    # Then, merge the detection efficiency files:
    cd ../MT
    root -b -l -q "MergeDetectionEffFile.cpp($1,kFALSE)"
    if [[ "${NEBULAFLAG}" = "1" ]]
    then
    root -b -l -q "MergeDetectionEffFile.cpp($1,kTRUE)"
    fi
    cd ../Macros
    
    # Then, run the translation of clusters in MT mode if possible:
    if [[ "${NEBULAFLAG}" = "1" ]]
    then
        root -b -l -q "TranslateClusters.cpp(1,0,kFALSE)"
    else
        cd ../MT
        ./MTClusterTranslation.sh $1 'Train'
        wait
        cd ../Macros
    fi
    
    # Then, merge he outcome as well:
    cd ../MT
    # root -b -l -q "MergeFiles.cpp($1,4)"
    # root -b -l -q "MergeHists.cpp($1,4)"
    
    # Compute the traditional method cuts:
    cd ../Macros
    root -b -l -q TradMed_ComputeCuts.cpp
    
    # Then, no more is required here.
    cd ../
fi

# The next step is now, to train the Network:
cd ./Keras/Script/

# Activate python virtual environment:
#if [[ "$2" = "GPU" ]]
#then
#source /home/christiaan/Desktop/GPUTensorFlow/bin/activate
#else
#source /home/christiaan/Desktop/TensorFlow/bin/activate
#fi

# Run the Keras scripts:
python ./DefineNetwork.py 0
python ./TrainNetwork.py 0

if [[ "${NEBULAFLAG}" = "1" ]]
then
python ./DefineNEBULANetwork.py 0
python ./TrainNEBULANetwork.py 0
fi

for ((nMult=0; nMult<${MaxMultiplicity}; ++nMult))
do
    ThisMult=`expr ${nMult} + 1`
    
    python ./DefineNetwork.py ${ThisMult}
    python ./TrainNetwork.py ${ThisMult}
        
    if [[ "${NEBULAFLAG}" = "1" ]]
    then
    python ./DefineNEBULANetwork.py ${ThisMult}
    python ./TrainNEBULANetwork.py ${ThisMult}
    fi
    
done

cd ../../

# And, finally, save the inputs:
cp ./InputFiles/InputsFile.txt "${TrainingOutputPath}/InputsFile.txt"

# Done.


