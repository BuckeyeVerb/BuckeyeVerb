function [ output ] = GuitarReverb( ir )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function takes in an impulse response, convolves it with the Guitar
% sample clip titled Guitar_Input.wav (must be in working directory), and
% plays it back via soundsc. The function can output the convolved
% waveform.
%   INPUTS
%    ir = impulse response to be convolved
%   
%   OUTPUTS
%    output = convolved output of Guitar_Input.wav * ir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = audioread('Guitar_Input.wav');

%Preform Convolution

IR = fft(ir, length(ir)+length(y)-1);

Y = fft(y, length(ir)+length(y)-1);

OUT = Y.*IR;

output = ifft(OUT);

%Play output

soundsc(output,96000)

end

