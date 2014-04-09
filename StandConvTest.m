x = audioread('Guitar_Input.wav');
h = audioread('stalbans_omni.wav');
y = conv(x,h);
soundsc(y,96000)