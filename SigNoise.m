function [ snratio ] = SigNoise(wavename,reps,N)
%SIGNOISE The function reads in a wave file, separates the signal from the 
% noise and then compares them using Matlab's built-in function "snr"
%It very simply uses the "Trimmer" function to separate noise and signal
%from recording.  As such, the number of repetitions ('reps') and the order
%('N') are required.

%=======MONAURAL========================================================

% Even though the "Trimmer" function is prepared to work in either stereo
% or mono modes, this program is presently written only for mono.

[signalmatrix, noisematrix]=Trimmer(wavename,reps,N,1);

% Truncating the 'signalmatrix' to the same length as 'noisematrix'
signalmatrixSHORT=signalmatrix(1:length(noisematrix));

% Performing the root of the sum of squares on each vector:
signalPow = rssq(signalmatrixSHORT).^2;
noisePow  = rssq(noisematrix).^2;
snratio = 10 * log10(signalPow/noisePow); %dividing them to get the signal-to-
% noise ratio in decibels

%{
A=wavread(wavename);
ALeft=A(:,1);
figure
plot(20*log10(abs(ALeft)))
%}

end

