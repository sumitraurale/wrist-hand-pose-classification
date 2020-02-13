EMG Wrist-Hand Pose Classification 

Collection of M-files (computer Matlab code) for EMG classification system to identify 
nine wrist-hand movements based on randomly acquiesced forearm EMG signals from Myo 
Armband as described in [1]. The system uses a linear combination of eight time-domain 
features followed by linear discriminant analysis (LDA) projection and multi-layer 
perceptron (MLP) classification. It is developed and tested on EMG recordings from 
10-subjects (seven male,three female)  aged  27±4  years using 8-active sensors 
enclosed in Myo Armband. The system operates on an EMG segment across eight channels. 
Requires Matlab programming environments. 
Updates can be found at https://github.com/sumitraurale/wrist-hand-pose-classification. 

To cite this system, please use reference [1,2]. 


Overview:

A low-complexity method to nine wrist-hand movements based on randomly acquired forearm 
EMG signals. The method was developed by assessing eight time-domain features from a 
256-segement EMG window across eight channels. Estimated features from eight channels 
were concatenated and reduced with LDA analysis and is classified using data driven 
MLP approach. The code here implements this movement classification system, which was 
trained with EMG recording for nine movement data with 100 sessions from 10 healthy subjects. 


Quick Start:

Set system trained parameters in Matlab using the system_parameters function: 

>>    system_parameters; 

Example: 

% Generate random signal segment 

>>   segment_dim=256;  
>>   channel_no=8;  
>>   emg_data = rand(segment_dim,channel_no); 
>>   Fs=200; 


% Plot EMG segment 

>>   figure(1); 
>>   t=(0: segment_dim-1)./Fs; 
>>   plot(t,emg_data); 
>>   xlabel('time (seconds)');  ylabel('Amplitude (mV)'); 

 
% Evaluate feature vector 

>>  feature_overall = feature_extract(emg_data); 

 
Files:
All Matlab files (.m files) have a description and an example in the header. 
To read this header, type help <filename.m> in Matlab. 


Requirements:
Matlab (R2013 or newer, Mathworks website). 


Test Computer Setup:
• hardware: Intel® i7® CPU 3.6 GHz, 64-bit, 4GB Memory. 
• operating system: Windows 7 Enterprise, 64-bit. 
• software: Matlab (R2016a) with Signal Processing Toolbox. 


References:
1. SA Raurale, J McAllister, JM del Rincon, “Real-Time Embedded EMG Signal Analysis for 
Wrist-Hand Pose Identification”, IEEE Transactions on Signal Processing. (Under Review) 
2. S Raurale, J McAllister, JM del Rincon, “EMG Acquisition and Hand Pose Classification 
for Bionic Hands from Randomly-placed Sensors”, in 2018 IEEE International Conference on 
Acoustics, Speech and Signal Processing (ICASSP), pp. 1105-1109, IEEE, 2015. 
DOI: 10.1109/ICASSP.2018.8462409 


Contact:
Sumit A. Raurale, Ph.D. 
Data Science and Scalable Computing, 
The Institute of Electronics, Communications and Information Technology (ECIT), 
Queen’s University Belfast, 
United Kingdom 

 
