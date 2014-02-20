function [ X ] = XComp( x, block_Counter, s_B, x_Size, N )
%XComp Summary of this function goes here
%   Detailed explanation goes here
    X = fft(x( 1 + (block_Counter - s_B)*N  : (block_Counter)*N), x_Size*N - 1);
end

