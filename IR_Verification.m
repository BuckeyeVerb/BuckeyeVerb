function [yrecovered] = IR_Verification(hq, x, y, varargin)
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
if ISEMPTY(varargin) == 0
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

subplot(1,2,2)
plot(y)
xlabel('Samples')
ylabel('Amplitude')
title('Data From .wav file (WAV\_0159\_001 - weigel)')

end

end