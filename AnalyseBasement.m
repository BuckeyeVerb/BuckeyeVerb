function [ ir,H ] = AnalyseBasement( x, observed,offset,reps,N,DCcoupling,impalign) 
%[ ir,H ] = AnalyseBasement(x, observed,offset,reps,N,DCcoupling,impalign)
%   x = input MLS variable
%   observed = Your observed .wav file recorded at the mic
%   offset, reps, N, DCcoupling, impalign all the same as in AMLS

[y Fs] = audioread(observed);
ir = AnalyseMLSSequence(y,offset,reps,N,DCcoupling,impalign);

figure                          % plot input and output variables on the same plot
subplot(2,1,1)
plot(x);
title(sprintf('reps = %d, Order = %d',reps,N));
xlabel('samples');
ylabel('x[n]')
subplot(2,1,2)
plot(y);
xlabel('samples');
ylabel('y[n]');

figure
plot(ir);
title(sprintf('Recovered Impulse Response, reps = %d, Order = %d',reps,N));
xlabel('samples');
ylabel('h[n]');

figure
subplot(2,1,1)
plot(db(y));
xlabel('samples');
ylabel('dB y')
subplot(2,1,2)
plot(db(ir));
xlabel('samples');
ylabel('dB ir')

H = fft(ir);
figure
subplot(2,1,1);
semilogx(db(abs(H(1:length(H)/2))));
title('Frequency Response to 96000 Hz');
xlabel('logscale sampled Frequency');
ylabel('dB Magnitude');
subplot(2,1,2)
plot(db(abs(H)));
title('Linear FR');
xlabel('linear sampled Frequency');
ylabel('dB Magnitude');

end

