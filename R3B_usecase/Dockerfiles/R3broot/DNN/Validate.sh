#!/bin/bash

# Full script for network Validation Only one input-parameter is required:
# The number of threads to execute the script on.
# A second argument can be provided to the script. If this is 'GPU', the 
# Script will use GPU TensorFlow instead of regular TensorFlow.

# First modify/recreate inputs for validation:
cd ./Macros/
    root -b -l -q GenerateValidationInput.cpp
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

# Add the training and validation parts:
TrainingOutputPath="${TheOutputPath}/DNN_Training/"
ValidationOutputPath="${TheOutputPath}/DNN_Validation/"

# Check for the Training directory:
if [ ! -d "${TrainingOutputPath}" ]
then
echo 'ERROR: You must train the network before running this script!'
return
fi

# Then, Deal with the validation directory:
if [ ! -d "${ValidationOutputPath}" ]
then
    # Then, we should make it:
    mkdir -p ${ValidationOutputPath}
    
    # DNN DataBase directory:
    if [ ! -d "${ValidationOutputPath}/DNN_DataBase/" ]
    then
        mkdir -p "${ValidationOutputPath}/DNN_DataBase/"
    fi
    
    # Check step 2:
    for ((nMult=0; nMult<${MaxMultiplicity}; ++nMult))
    do
        ThisMult=`expr ${nMult} + 1`
        
        if [ ! -d "${ValidationOutputPath}/DNN_Step2_Mult${ThisMult}/" ]
        then
            mkdir -p "${ValidationOutputPath}/DNN_Step2_Mult${ThisMult}/"
        fi
    done
fi

# Then, check if the required files exist:
if [ -f "${TrainingOutputPath}/CutsFile.txt" ]
then
cp "${TrainingOutputPath}/CutsFile.txt" "${ValidationOutputPath}/CutsFile.txt"
else
echo 'ERROR: You cannot do validation without CutsFile.txt!'
return
fi

if [[ "${NEBULAFLAG}" = "1" ]]
then
if [ -f "${TrainingOutputPath}/NEBULA_CutsFile.txt" ]
then
cp "${TrainingOutputPath}/NEBULA_CutsFile.txt" "${ValidationOutputPath}/NEBULA_CutsFile.txt"
else
echo 'ERROR: You cannot do validation without NEBULA_CutsFile.txt!'
return
fi
fi

# Then, check if the required files exist:
if [ -f "${TrainingOutputPath}/TimeFile.txt" ]
then
cp "${TrainingOutputPath}/TimeFile.txt" "${ValidationOutputPath}/TimeFile.txt"
else
echo 'ERROR: You cannot do validation without TimeFile.txt!'
return
fi

if [[ "${NEBULAFLAG}" = "1" ]]
then
if [ -f "${TrainingOutputPath}/TimeFile_NEBULA.txt" ]
then
cp "${TrainingOutputPath}/TimeFile_NEBULA.txt" "${ValidationOutputPath}/TimeFile_NEBULA.txt"
else
echo 'ERROR: You cannot do validation without TimeFile_NEBULA.txt!'
return
fi
fi

# Then, check if the required Network files exist:
if [ ! -f "${TrainingOutputPath}/TheMultNetwork_Final.h5" ]
then
echo 'ERROR: You cannot do validation without the final network file!'
return
fi

if [[ "${NEBULAFLAG}" = "1" ]]
then
if [ ! -f "${TrainingOutputPath}/TheNEBULAMultNetwork_Final.h5" ]
then
echo 'ERROR: You cannot do validation without the final NEBULA network file!'
return
fi
fi

# The required scores-files:
if [ -f "${TrainingOutputPath}/NeuLAND_TheScorersFile.root" ]
then
cp "${TrainingOutputPath}/NeuLAND_TheScorersFile.root" "${ValidationOutputPath}/NeuLAND_TheScorersFile.root"
else
echo 'ERROR: You cannot do validation without NeuLAND_TheScorersFile.root!'
return
fi

if [[ "${NEBULAFLAG}" = "1" ]]
then
if [ -f "${TrainingOutputPath}/NEBULA_TheScorersFile.root" ]
then
cp "${TrainingOutputPath}/NEBULA_TheScorersFile.root" "${ValidationOutputPath}/NEBULA_TheScorersFile.root"
else
echo 'ERROR: You cannot do validation without NEBULA_TheScorersFile.root!'
return
fi
fi

if [ -f "${TrainingOutputPath}/NormParams.txt" ]
then
cp "${TrainingOutputPath}/NormParams.txt" "${ValidationOutputPath}/NormParams.txt"
else
echo 'NOTE: NormParams.txt is missing. But technically we could do without.'
# NOTE: No return command.
fi

if [[ "${NEBULAFLAG}" = "1" ]]
then
if [ -f "${TrainingOutputPath}/NEBULA_NormParams.txt" ]
then
cp "${TrainingOutputPath}/NEBULA_NormParams.txt" "${ValidationOutputPath}/NEBULA_NormParams.txt"
else
echo 'NOTE: NEBULA_NormParams.txt is missing. But technically we could do without.'
# NOTE: No return command.
fi
fi

####################################################################################

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
    root -b -l -q "TranslateClusters.cpp(1,0,kFALSE)"
    
    # Then, extract the DNN multiplicity from the network:
    cd ../Keras/Script/
    
#    if [[ $2 = "GPU" ]]
#    then
#        source /home/christiaan/Desktop/GPUTensorFlow/bin/activate
#    else
#        source /home/christiaan/Desktop/TensorFlow/bin/activate
#    fi

    python ./GenerateMultOutput.py
    
    if [[ "${NEBULAFLAG}" = "1" ]]
    then
    python ./GenerateNEBULAMultOutput.py
    fi
    
    cd ../../Macros
    
    # Next, convert info to ROOT-file:
    root -b -l -q "Read_DNN_Multiplicity.cpp(1)"
    
    # And then, generate the DNN input for the second step:
    root -b -l -q "TranslateClusters.cpp(1,0,kTRUE)"
    
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
    
    # Merge detection efficiency files:
    root -b -l -q "MergeDetectionEffFile.cpp($1,kFALSE)"
    if [[ "${NEBULAFLAG}" = "1" ]]
    then
    root -b -l -q "MergeDetectionEffFile.cpp($1,kTRUE)"
    fi
    
    # Then, run the translation of clusters. 
    # ATTENTION should NOT be done in MT mode for validation!
    cd ../Macros
    root -b -l -q "TranslateClusters.cpp(1,0,kFALSE)"
    
    # Then, extract the DNN multiplicity from the network:
    cd ../Keras/Script
    
#    if [[ "$2" = "GPU" ]]
#    then
#        source /home/christiaan/Desktop/GPUTensorFlow/bin/activate
#    else
#        source /home/christiaan/Desktop/TensorFlow/bin/activate
#    fi

    python ./GenerateMultOutput.py
    
    if [[ "${NEBULAFLAG}" = "1" ]]
    then
    python ./GenerateNEBULAMultOutput.py
    fi
    
    cd ../../Macros
    
    # Next, convert info to ROOT-file:
    root -b -l -q "Read_DNN_Multiplicity.cpp($1)"
    
    # And then, generate the DNN input for the second step:
    # ATTENTION should NOT be done in MT mode for validation!
    root -b -l -q "TranslateClusters.cpp(1,0,kTRUE)"
    
    # Merging does not need to be redone.
    
    # So, no more is required here.
    cd ../
fi

# The next step is now, to use the network for prediction of Step2.
cd ./Keras/Script/

# Activate python virtual environment:
#if [[ "$2" = "GPU" ]]
#then
#source /home/christiaan/Desktop/GPUTensorFlow/bin/activate
#else
#source /home/christiaan/Desktop/TensorFlow/bin/activate
#fi

# Execute predictions:
for ((nMult=0; nMult<${MaxMultiplicity}; ++nMult))
do
    ThisMult=`expr ${nMult} + 1`
    python ./GenerateStep2OneCluster.py ${ThisMult}
    
    if [[ "${NEBULAFLAG}" = "1" ]]
    then
    python ./GenerateNEBULAStep2OneCluster.py ${ThisMult}
    fi
done

# Then, continue to do the analysis:
cd ../../Macros
./Analyze.sh $1
cd ../

# And, finally, save the inputs:
cp ./InputFiles/InputsFile.txt "${ValidationOutputPath}/InputsFile.txt"

# Done.


