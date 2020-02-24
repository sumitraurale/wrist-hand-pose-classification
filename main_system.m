%-----------------------------------------------------------------------------------
% EMG_movement_classification: Detect one of nine wrist-hand movement from
% an EMG segment (size: segment_dim x channel_no)
%
% Note: this method was developed and trained on randomly acquised forearm
%       EMG signals (channels 1-8) in clockwise orientation from Myo Armband.  
% 
% Example:
%       segment_dim=256;
%       channel_no=8;
%       emg_data = rand(segment_dim,channel_no);
%
%
% Author: Sumit Raurale, Ph.D.
%         email: sumit.raurale@gmail.com
%         ECIT, Queen's University Belfast, United Kingdom
%-----------------------------------------------------------------------------------

close all; clear all;

% load system parameters
system_parameters;

% Sample EMG segment (provide input as 'emg_data' or uncomment the below line)
%emg_data = rand(segment_dim,channel_no);    

%-----------------------------------------------------------------------------------
% 1. time-domain feature extraction
%-----------------------------------------------------------------------------------
feature_overall = feature_extract(emg_data);

%-----------------------------------------------------------------------------------
% 2. Linear discriminant analysis projection
%-----------------------------------------------------------------------------------
train_lda_parameters;

% Extract feature projection vector
feat_proj =  eigvector.' * (feature_overall - meanX).';

%-----------------------------------------------------------------------------------
% 3. Multi-layer Perceptron classification
%-----------------------------------------------------------------------------------
% Analyse feature class vector
class_out = mlp_classify(feat_proj);
class_no = vec2ind(class_out);

% Display Identified pose name  
movement = Class_label(class_no);

% Print the Identified movement
fprintf('The Identified pose is "%s". \n',movement);

