function [ out ] = IRconv( sigin, ir)
%IRconvwav Convolves test audio with an impulse response using Fast
%Convolution
%   Inputs 
%   sigin - input signal as a vector
%   ir - Impulse Response you would like to convolve with
%   
%   Outputs
%   out - convolution of the two inputs

H = fft(ir,length(sigin)+length(ir)-1);
S = fft(sigin,length(sigin)+length(ir)-1);

OUT = S.*H;
out = ifft(OUT,length(sigin)+length(ir)-1);


end

