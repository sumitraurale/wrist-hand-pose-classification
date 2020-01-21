%-----------------------------------------------------------------------------------
% gen_feature: evaluate a feature vector (size 1 x 13) based on 8 time-domain
%              features for an EMG segment (size 256 x 1)
%
% Syntax: [feature_vec] = gen_feature(emg_segment,ar_no)
%
% Inputs: 
%     emg_segment  - an EMG channel segment (size 256 x 1)
%     ar_no        - Number of AR coefficients to be extracted 
%
% Outputs: 
%     feature_vec  - evaluated feature vector (size 1 x 13) with following order:
%                    [AR(1-6), IEMG logRMS kurtosis skewness RMS variance MAV]
%
% Example:
%     N=256;
%     emg_segment=rand(N,1);
%     ar_no=6;
%
%     [feature_vec] = gen_feature(emg_segment,ar_no)
%
% Author: Sumit Raurale, Ph.D.
%         email: sumit.raurale@gmail.com
%         ECIT, Queen's University Belfast, United Kingdom
%-----------------------------------------------------------------------------------

function [feature_vec] = gen_feature(emg_segment,ar_no)

n=length(emg_segment);

% Compute IEMG Feature
F_immg=sum(abs(emg_segment));

% Compute MAV Feature
F_mean=sum(emg_segment)/n;
F_MAV=abs(F_mean);

% Compute Variance Feature
x1 = bsxfun(@minus, emg_segment, F_mean);
F_var = sum(abs(x1).^2) ./ (n-1);

% Compute RMS Feature
F_rms=sqrt(mean(emg_segment .* conj(emg_segment)));

% Compute log RMS Feature
F_logrms=log(F_rms);

% Compute Kurtosis Feature
x0 = emg_segment - repmat(nanmean(emg_segment), [n 1]);
s2 = nanmean(x0.^2);
m4 = nanmean(x0.^4);
F_kurt = m4 ./ s2.^2;

% Compute Skewness Feature
m3 = nanmean(x0.^3);
F_skew = m3 ./ s2.^(1.5);

% Compute AR Feature
ar_in = emg_segment;
AR_coef = autoreg(ar_in,ar_no);

%% Final Feature Vector

feature_vec = [AR_coef F_immg F_logrms F_kurt F_skew F_rms F_var F_MAV];


function [AR_coef] = autoreg(ar_in,coef)  

%#codegen

narginchk(2,Inf)

% estimate covariance flag
pt = true;

options.Approach = 'fb';
options.Window = 'now';
options.DataOffset = 0;
options.EstCovar = true;
options.MaxSize = 250e3;

if isa(ar_in,'double') && isvector(ar_in)
      ar_in = ar_in(:); 
else
end

yor = cell(1);
yor{1,1} = ar_in;
Ne = numel(yor);
Ncaps = 256;

options.EstCovar = pt;

% Perform estimation.

maxsize = options.MaxSize;
if ischar(maxsize), maxsize = 250e3; end 

approach = options.Approach;
win = options.Window;

yOff = 0;
for kexp = 1:Ne
   yor{kexp} = yor{kexp} - yOff(kexp);
end

y = yor; % Keep the original y for later computation of e

if strcmp(approach,'yw'), win = 'ppw'; end

% override pt for the other approaches
pt1 = true; 

% Now compute the regression matrix
if pt1
   nmax = coef;
   M = floor(maxsize/coef);
   R1 = zeros(0,coef+1);
   fb = strcmp(approach,'fb');
   if strcmp(approach,'fb')
      R2 = zeros(0,coef+1);
      yb = cell(1,Ne);
      for kexp = 1:Ne
         yb{kexp} = conj(y{kexp}(Ncaps(kexp):-1:1));
      end
   end
   for kexp = 1:Ne
      Ncap = Ncaps(kexp);
      yy = y{kexp};
      for k = nmax:M:Ncap-1
         jj = (k+1:min(Ncap,k+M));
         phi = zeros(length(jj),coef);
         if fb
            phib = zeros(length(jj),coef);
         end
         for k1 = 1:coef
            phi(:,k1) = -yy(jj-k1);
         end
         if fb
            for k2 = 1:coef
               phib(:,k2) = -yb{kexp}(jj-k2);
            end
         end

         if fb
            R22 = triu(qr([R2;[[phi;phib],[yy(jj);yb{kexp}(jj)]]]));
            [nRr,nRc] = size(R22);
            R23 = R22(1:min(nRr,nRc),:);
         end
         R12 = triu(qr([R1; [phi,yy(jj)]]));
         [nRr,nRc] = size(R12);
         R13 = R12(1:min(nRr,nRc),:);
      end
   end
   
   R01 = R13;   R02 = R23;
   covR = [];   covR = R01(1:coef,1:coef);
   P = pinv(covR);
   
   if ~any(strcmp(approach,{'burg','gl'}))
      if ~fb
         AR_coef = (P * R01(1:coef,coef+1)).';
      else
         AR_coef = (pinv(R02(1:coef,1:coef)) * R02(1:coef,coef+1)).';
      end
   end

end

