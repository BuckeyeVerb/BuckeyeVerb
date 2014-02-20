function [ y ] = outputComp(y, block_Counter, s_B, e_B, IR, X, N)
%outputComp Summary of this function goes here
%   Detailed explanation goes here
    y((block_Counter + s_B)*N + 1 : (block_Counter + e_B)*N - 1) = y((block_Counter + s_B)*N + 1 : (block_Counter + e_B)*N - 1) + ifft(IR.*X);
end

