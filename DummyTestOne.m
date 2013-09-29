function [x,h,h1,h2,y] = DummyTestOne(N,s)
%Dummy Test One -Two different ways of extracting impulse responses from measured data.
%
%syntax: [x,h,h1,h2,y] = DummyTestOne(N)
%
% Output Variables:
% x is the generated MLS sequence using GenerateMLS.m (no repititions)
% h is the randomly generated impulse response
% h1 is the recovered impulse response using AnalyzeMLSSequence
% h2 is the recovered impulse response using ffts
% y is the convolution of the two signals
%
% Input Variables:
% N is the order of the MLS sequence
% s is the level of noise in the output. 0 corresponds to no SNR = inf, 1 is
% SNR = 1
%
%   So far in order to get the impulse response from measured data, the team 
%has run the raw data through the function AnalyzeMLSSequence. The team 
%suspects that there is another method of extracting the impulse response 
%that could also be effective. This second method involves dividing the 
%FFT of the measured data by the FFT of the MLS sequence yielding the 
%FFT of the impulse response.
%
%   In this test, the team will set up a scenario where a known impulse 
%response is convolved with an MLS sequence. The impulse response will be 
%extracted from the output signal using the two methods described above.
%
%   This test is an attempt to gain more insight into the AnalyzeMLS function.


%Generate MLS sequence
P=2^N - 1; %length of MLS sequence

x = GenerateMLS(N,1);
x=x';

%Generate known impulse response h(t)

h = rand(1,P)- rand(1,P);
h=h';

%convolve x(t)*h(t)=y(t) Note: according to the MLS theory pager by Mark
%Thomas, the convolution must be circular. For the intitail test, linear
%convolution will be preformed

y = conv(x,h);

%add noise to the output signal
noise = s.*(rand(length(y),1)-rand(length(y),1));
y = y + noise;

%Send y(t) through AnMLS function  y(t) -> AnMLS -> h1(t)

h1 = AnalyseMLSSequence(y,0,1,N,true,0);
h1=h1(1:length(h1)-1,1);

%Send y(t) though a new function that extracts h(t) from the frequency domain

%before sending output y to this new function, make sure that x and y are
%of equal length
y2 = y(1:2:end);

h2 = FFTImpulseExtraction(x,y2);
end

%Compare h1(t), h2(t), and h(t)

function h2 = FFTImpulseExtraction(x,y)
%This function extracts the time domain impulse response from a given input
%and output.
%
% Inputs:
% x = time domain input signal
% y = time domain output signal
% 
% Outputs:
% h2 = time domain impulse response of system

%Take ffts of the input and output variables
Y = fft(y);
X = fft(x);

%H = Y/X.  Divide the two signals to get the transferfunction H

H = Y./X;

%Take inverse transform to get impulse response
h2 = ifft(H);


end
