x = audioread('Guitar_Input.wav');
h = audioread('stalbans_omni.wav');
X = fft(x,length(x)+length(h)-1);
H = fft(h,length(x)+length(h)-1);
Y = X.*H;
y = ifft(Y);
soundsc(y,96000)
