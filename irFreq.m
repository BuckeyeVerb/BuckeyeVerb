function [ir,Mag,Phase] = irFreq(wav,reps,N,impalign,dynRange)

%   irFreq takes in a wav file and outputs the impulse response and
%   Magnitude and Phase of the Frequency Response

Y = wavread(wav);
y = Y(:,1);
ir = AnalyseMLSSequence(y,0,reps,N,'false',impalign);
figure
clf
plot(ir);
title(wav);
xlabel('n [samples]');
ylabel('h(n)');

figure
clf
plot(20*log10(abs(ir)));

H = fft(ir);
Mag = abs(H);
Phase = angle(H);
figure
clf
subplot(2,1,1)
semilogx((20*log10(Mag)));
title(wav);
xlim([1 20000]);
ylim(dynRange);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
grid on;
subplot(2,1,2)
semilogx(Phase);
xlim([1 20000]);
xlabel('Frequency [Hz]');
ylabel('Phase [rad]');
grid on;


end

