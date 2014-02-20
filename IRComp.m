function [ IR ] = IRComp(h,s_B,e_B,h_Size,N)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    IR = fft(h(s_B*N + 1 : e_B*N), h_Size*N - 1);
end

