%This script in meant to test the function in the DSP toolbox called
%dsp.SpectrumAnalyzer. This script was written by Austin Mackey

%First a simple sin wave is created and plotted in the time domain

%The sin wave has the form y[n] = A sin[2pif n + phi] 

%set up sin handle H
A = 1;    %[units]
f = 200;  %[Hz]
phi = 0;  %[rad]
H = dsp.SineWave(A,f,phi);
H.SampleRate = 20000; %[samples/sec]
H.SamplesPerFrame = 10000; %[samples] corresponding to two cycles


%Generate sin wave
y = step(H);

%plot sinwave in time domain
figure
plot(y)
xlabel('Samples')
ylabel('Magnitude [units]')
title('Test Sinwave in Time Domain')

%Next the function dsp.SpectrumAnalyzer is initialized. This stage just
%primes the spectrum analyzer to be run on a given signal. The next step
%will be to actualy generate the spectrum analysis window

Hfreq = dsp.SpectrumAnalyzer;
Hfreq.PlotAsTwoSidedSpectrum = false;
Hfreq.SampleRate = 20000;
Hfreq.FrequencyScale = 'Log';

%Generate SpectrumAnalyzer window on the sin wave stored in y
step(Hfreq,y)
