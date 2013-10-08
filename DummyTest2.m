function [x,burst,h,h1,h2,y] = DummyTest2(N,RT60,reps,impalign,scale,s,pad)
%Dummy Test Two - Same as DT1 but with added input arguments for padding
%output, RT60, and impalign
%
%syntax: [x,burst,h,h1,h2,y] = DummyTest2(N,RT60,reps,impalign,scale,s,pad)
%
% Output Variables:
% x is the generated MLS sequence using GenerateMLS.m (no repititions)
% h is the randomly generated impulse response
% h1 is the recovered impulse response using AnalyzeMLSSequence
% h2 is the recovered impulse response using ffts
% y is the convolution of the two signals
%
% Input Variables:
% reps is the number of MLS repetitions (minimum 2)
% N is the order of the MLS sequence
% s is the level of noise in the output. 0 corresponds to no SNR = inf, 1 is
% SNR = 1
% RT60 is the reverb time in milliseconds
% impalign: 1 to include alignment impulse, 0 to to exclude
% scale: scale h by some factor. Scale by approx 1/100 to obtain a similar
% "observed" as we've been getting in real data. 1 to leave h in the range
% of [-1,1]
% pad: pad y with (pad*P) zeros. This occurs before noise is added. Added
% to make "observed" more realistic.
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

[x burst] = GenerateMLSSequence(reps,N,impalign);
figure
plot(x);                                                        % The simulated impulse - Random but "known"
xlabel('n [samples]');
ylabel('x');
title('x(n) - MLS Signal');


%Generate known (random) impulse response h(t)               
n = [1:P];                                                          % Tell the exponential to work 1 sample at a time up to length P
RL = RT60*.001*96000;                                               % Reverb Length in Samples for a Sample Rate of 96K, RT60 in ms   
a = -log(.001)/RL;                                                  % Exponential parameter
                                                         
noise = rand(P,1)-rand(P,1);
posNoise = 0.5*(abs(noise)+noise);
negNoise = 0.5*(noise-abs(noise));

posImp = exp(-a.*n).*(posNoise)';
negImp = exp(-a.*n).*(negNoise)';
h = posImp + negImp;
h = scale.*h;
figure
plot(h);                                                        % The simulated impulse - Random but "known"
xlabel('n [samples]');
ylabel('h');
title('h(n) - Known Impulse Response, Noise w/ Exponential Decay');



%convolve x(t)*h(t)=y(t) Note: according to the MLS theory pager by Mark
%Thomas, the convolution must be circular. For the intitail test, linear
%convolution will be preformed

y = conv(x,h);
y = padarray(y,pad*P);
%add noise to the output signal
noise = s.*(rand(length(y),1)-rand(length(y),1));
y = y + noise;
figure
plot(y);
xlabel('n [samples]');
ylabel('y');
title('y(n) - observed');
%Send y(t) through AnMLS function  y(t) -> AnMLS -> h1(t)


h1 = AnalyseMLSSequence(y,0,reps,N,true,impalign);
h1=h1(1:length(h1)-1,1);
figure
plot(h1);
xlabel('n [samples]');
ylabel('h1');
title('h1(n) - recovered from AMLS');

%Send y(t) though a new function that extracts h(t) from the frequency domain


h2 = FFTImpulseExtraction(x,y,burst);

%transpose h to match dim h1 and dim h2
%h=h';
end

%Compare h1(t), h2(t), and h(t)

function h2 = FFTImpulseExtraction(x,y,burst)
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
Y = fft(y,length(y));
X = fft(x,length(y));

%H = Y/X.  Divide the two signals to get the transferfunction H

H = Y./X;

%Take inverse transform to get impulse response
h2 = ifft(H);

%Get rid of zero pads
h2 = h2(1:length(burst));
figure
plot(h2);
xlabel('n [samples]');
ylabel('h2');
title('h2(n) - recovered from FFTs');

end
