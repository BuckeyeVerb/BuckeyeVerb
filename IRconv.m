function [  ] = IRconv( sigin, ir, wavname )
%IRconv Convolves test audio with an impulse response using Fast
%Convolution
%   Inputs 
%   sigin - input signal as a vector
%   ir - Impulse Response you would like to convolve with
%   
%   Outputs
%   wavout - 96K 24-bit WAV file of the convolved output

H = fft(ir,length(sigin)+length(ir)-1);
S = fft(sigin,length(sigin)+length(ir)-1);

OUT1 = S.*H;
out1 = ifft(OUT1,length(sigin)+length(ir)-1);
audiowrite(wavname,out1,96000,'BitsPerSample',24);



end

