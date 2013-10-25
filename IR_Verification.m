function [] = IR_Verification(observed, mls, reps, N, channels)
%This function takes in a measurement .wav file, extracts the IR using
%AMLS, and verifies that the IR was extracted correctly.
%
%Inputs:
%
%
%
%   observed                 string - name of measured .wav file  
%                            ex] 'test.wav'
% 
%   mls                      string - name of mls used during measurement 
%                            ex] 'mls.wav'
% 
%   reps                     repetitions of mls
% 
%   N                        order of mls
% 
%   channels                 Use to specify how many, or which, channel to
%                            use.  For monaural recordings, put in either
%                            1 or 2; 1 to use the left channel or 2 to use
%                            the right channel.  To use both channels of a
%                            stereo recording, enter 3.  This variable is
%                            optional; if nothing is specified it will
%                            default to 1.
 
if (nargin < 5)
    channels = 1;
end

% use Trimmer tool to clean up recording, y = trimmed observed output

[y,noise] = Trimmer(observed, reps, N, channels);

% read in mls .wav file, x = mls

x = audioread(mls);


% Extract impulese response using AMLS, hq = recovered IR

hq = AnalyseMLSSequence(y,0,reps,N,true,0);

% send variables to IR_Verification_Plot.m to verify the extraction

yrecovered = IR_Verification_Plot(hq, x, y, observed);

end

function [yrecovered] = IR_Verification_Plot(hq, x, y, observed, varargin)
%This function is a generalization of the test script
%Convolution_IR_Verification_Test.m.
%
%Inputs:
%  hq - Impulse response recovered from AMLS
%  x  - MLS sequence (Full sequence, not just one burst)
%  y  - Measured recorded data (****.WAV)
%  showplot - 1 - plots yrecovered and y
%         0 - does not plot yrecovered and y
%         (default = 1)
%    
%Outputs:
%  yrecovered - x * hq
%
%Compare yrecovered with y to verify that the IR was recovered correctly.
%========================================================================
%Example:
%
% reps = 12;
% N = 19;
% impalign = 1;
% channels = 1;
% 
% [y,fs] = audioread('WAV_0159_001.wav');
% y = y(5e5:8e6,1);
% 
% [x,fs2] = audioread('5461ms_MLS_12.wav');
% 
% [hq] = AnalyseMLSSequence(y, 0, reps, N, true , impalign);
%
% yrecovered = IR_Verification(hq, x, y);
%========================================================================

%Set default
if length(varargin) == 0
   showplot = 1; 
elseif length(varargin) == 1
   showplot = varargin{1};
else
    disp('Error: too many input variables')
    return
end

% x[n] * hq[n] = yq[n] -- done in freq domain to save time

X = fft(x,length(x));
HQ = fft(hq,length(x));
YQ = X.*HQ;

yrecovered = ifft(YQ);

if showplot == 1
%Plot y and yq

figure
subplot(1,2,1)
plot(yrecovered)
xlabel('Samples')
ylabel('Amplitude')
title('Data Recovered Using Convolution')
ylim([-.8,.8])

subplot(1,2,2)
plot(y)
xlabel('Samples')
ylabel('Amplitude')
title(sprintf('Data From .wav file %s',observed))
ylim([-.8,.8])

end

end