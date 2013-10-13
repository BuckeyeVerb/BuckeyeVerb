%This test is meant to verify something that the team strongly suspects is 
%true. The team thinks that the impulse responses being recovered from 
%the measured data are not the true impulse responses of the room.
%In order to verify this idea, two parallel tests will be preformed on 
%measured data and simulated data.
%
%The test with measured data will be to recover an impulse response using 
%AMLS. Then convolve the IR with the MLS sequence. The result in theory should 
%be the same measured data.
%
%The test will then be recreated using all simulated data and a known impulse 
%response.

%%%%Note the following files must be in the working directory
%      WAV_0159_001.wav
%      5461ms_MLS_12.wav     

%Define the following variables
%	x = MLS sequence
%	hs = simulated IR
%	h = what measured IR ?should be? ? correct impulse response
%	ys = simulated recording
%   yobs = simulated recording plus noise
%	y = actual recording
%	yq = recording recovered from convolving 
%	ysq = simulated recording recovered through convolution
%	hq = IR as recovered from AMLSSeq as we?ve been using it up to this point

%USING MEASURED DATA=======================================================

%Define MLS parameters

reps = 12;
N = 19;
impalign = 1;
channels = 1;
%Import .wav file of measured data
%Use first test from Weigel; WAV_0159_001 - only keep the first channel

[y,fs] = audioread('WAV_0159_001.wav');
y = y(5e5:8e6,1); %This step is designed to crudely crop the noise out of the file

%Import .wav file of MLS sequence
%Use Corresponding MLS sequence; 5461ms_MLS_12

[x,fs2] = audioread('5461ms_MLS_12.wav');

%Recover IR using AMLS

[hq] = AnalyseMLSSequence(y, 0, reps, N, true , impalign);

%x[n] * hq[n] = yq[n] -- done in freq domain to save time

X = fft(x,length(x));
HQ = fft(hq,length(x));
YQ = X.*HQ;

yq = ifft(YQ);

%Plot y and yq

figure
subplot(1,2,1)
plot(yq)
xlabel('Samples')
ylabel('Amplitude')
title('Data Recovered Using Convolution')

subplot(1,2,2)
plot(y)
xlabel('Samples')
ylabel('Amplitude')
title('Data From .wav file (WAV\_0159\_001 - weigel)')

%USING SIMULATED DATA======================================================

%x * hs = ys
%ys + noise = yobs
%AMLS(yobs) = hobs
%These three steps are all done in the function DummyTestOne

[x,hs,hobs,h2,yobs] = DummyTestOne(10,.01);

%x[n] * hobs = ysq  --- done in the freq domain again

X = fft(x,length(yobs));
HOBS = fft(hobs,length(yobs));
YSQ = X.*HOBS;

ysq = ifft(YSQ);

%plot yobs and ysq

figure
subplot(1,2,1)
plot(ysq)
xlabel('Samples')
ylabel('Amplitude')
title('Sim Data Recovered Using Convolution')

subplot(1,2,2)
plot(yobs)
xlabel('Samples')
ylabel('Amplitude')
title('Actual Sim Data')