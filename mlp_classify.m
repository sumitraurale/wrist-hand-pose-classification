%-----------------------------------------------------------------------------------
% mlp_classify: evaluate feature class output (size 9 x 1) for prediciting
%               nine-classes from projected feature vector (size 8 x 1)
%
% Syntax: [class_out] = mlp_classify(feat_proj)
%
% Inputs: 
%     feat_proj  - projected feature vector from LDA (size 8 x 1)
%
% Outputs: 
%     class_out  - evaluated feature class vector (size 9 x 1)
%
%
% Author: Sumit Raurale, Ph.D.
%         email: sumit.raurale@gmail.com
%         ECIT, Queen's University Belfast, United Kingdom
%-----------------------------------------------------------------------------------

function [class_out] = mlp_classify(feat_proj)  %#codegen

train_mlp_parameters;

% Dimensions
Q = 1; % samples/series

% Allocate Outputs

% Input 1
Xp1 = mapminmax_apply(feat_proj,x1_step1);
    
% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
% Layer 2
a2 = tansig_apply(repmat(b2,1,Q) + LW2_1*a1);
    
% Layer 3
a3 = tansig_apply(repmat(b3,1,Q) + LW3_2*a2);
    
% Layer 4
a4 = repmat(b4,1,Q) + LW4_3*a3;
    
% Output 1
class_out = mapminmax_reverse(a4,y1_step1);


% Format Output Arguments

isCellX = iscell(feat_proj);
if ~isCellX,
    
    elements = numel(class_out);
    if elements == 0
        class_out = [];
        return
    end
    
    if elements == 1
        if isnumeric(class_out{1}) || ischar(class_out{1}) || islogical(class_out{1}) || isstruct(class_out{1})
            class_out = class_out{1};
            return
        end
    end
       
end
end

% ======================= MODULE FUNCTIONS =======================

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
  y = bsxfun(@minus,x,settings.xoffset);
  y = bsxfun(@times,y,settings.gain);
  y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
  x = bsxfun(@minus,y,settings.ymin);
  x = bsxfun(@rdivide,x,settings.gain);
  x = bsxfun(@plus,x,settings.xoffset);
end
