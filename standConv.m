function [ y ] = standConv(y,block_Counter,x,h,N)
%standConv Summary of this function goes here
%   Detailed explanation goes here
%standard convolve N samples with h0
    output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N),h(1:2*N));

    %place standard convolution product into the output array
    y((block_Counter - 1)*N + 1 : (block_Counter + 2)*N - 1) = y((block_Counter - 1)*N + 1 : (block_Counter + 2)*N - 1) + output;

end

