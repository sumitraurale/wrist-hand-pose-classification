%-----------------------------------------------------------------------------------
% feature_extract: Extract feature vector for each channel withinm an EMG segment 
%
% method was developed for the randomly acquised EMG from 8-channels.  
%
% Syntax: [feature_overall]=feature_extract(emg_data)
%
% Inputs: 
%     emg_data   - 1-channel of EMG data (size N x channels)
%
% Outputs: 
%     feature_overall - extracted concatinated feature vector (size 1 x 104)
%                       on evaluated feature vector from each channel (size 1 x 13)
%
% Example:
%     N=256;
%     channels=8;
%     emg_data=rand(N,channels);
%
%     [feature_overall]=feature_extract(emg_data)
%
%
% Author: Sumit Raurale, Ph.D.
%         email: sumit.raurale@gmail.com
%         ECIT, Queen's University Belfast, United Kingdom
%-----------------------------------------------------------------------------------

function [feature_overall]=feature_extract(emg_data)

% load parameters:
feature_parameters;

if(max(size(emg_data))~=segment_dim) && (min(size(emg_data))~=channel_no)
    error('the emg segment is different than prescribed dimension.');
end

if(ar_no~=6)
    error('No. of AR coefficients are different than prescribed.'); 
end

%-----------------------------------------------------------------------------------
% Generate feature vectors
%-----------------------------------------------------------------------------------

for j = 1:channel_no
    
    % Select EMG channel segment
    emg_segment = emg_data(:,j);
    
    % compute feature vector of channel segment
    feature_vec = gen_feature(emg_segment,ar_no);
    
    % combine feature vector from each channel
    feature_all(j,:) = feature_vec;
    
end

% concatinate all channel feature vectors to one feature vector per segment
feature_overall = reshape(feature_all.',1,[]);

