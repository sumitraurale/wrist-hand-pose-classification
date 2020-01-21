%-----------------------------------------------------------------------------------
% EMG movement classification system parameters
%
% Author: Sumit Raurale, Ph.D.
%         email: sumit.raurale@gmail.com
%         ECIT, Queen's University Belfast, United Kingdom
%-----------------------------------------------------------------------------------

% specify number of EMG channels to be considered
channel_no = 8;

% specify dimension of EMG segment and overlap 
segment_dim = 256;     % EMG segment dimension
overlap_dim = 128;     % EMG overlap dimension

% Class label order MLP was trianed
Class_label = string({'Hand_open','Wrist_flexion','Wrist_pronation',...
       'Wrist_ulnar_flexion','Relaxation','Wrist_supination',...
       'Hand_close','Wrist_extension','Wrist_radial_flexion'});
