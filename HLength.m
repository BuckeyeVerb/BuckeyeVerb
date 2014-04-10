% This program will determine how many blocks the "raw" impulse response
% needs to be split up into - in the fashion described in the Zero-Delay
% paper - based on your chosen size for N.  Note that this program does
% take into account the first block h0 of length 2N, then proceeds to h1,
% h2, h3, etcetera... of sizes N, N, 2N, etcetera...
%
% Two outputs are delivered from the program:
%    1. the number of blocks required to fit a given impulse response, and
%    2. the aggregate length of those blocks, in samples.
%
% Worthy of note is that this program tells you exactly how many blocks are
% are required, that is to say it may not be an odd total number (an even
% h-humber.  At the sizes of our largest h-blocks, we wouldn't want to add
% even one more on than we need to.


%-----------------------------------
N=64;

IRlen=4*(10^5); % CHANGE THIS; it's the length of an IR in samples.
blocklen=(IRlen)/N;

%-----------------------------------
NumberOfH=0; % The number of segments of h, NOT including h0.  This way the variable no. is the same as the subscript numbers in the Zero Delay paper
hFirstExp=1;  % Used internally by the loop
hSecondExp=0; % Used internally by the loop
hTotLength=2*N; % Actual length that our h will need to be.  It, likely being longer than the IR, will be zero-padded on the tail end
while (hTotLength<blocklen)
    NumberOfH=NumberOfH+1;
    if (mod(NumberOfH,2))
        hTotLength=(2^(hFirstExp))+(2^(hSecondExp));
        hFirstExp=hFirstExp+1;
        hSecondExp=hSecondExp+1;
    else
        hTotLength=(2^(hFirstExp));
    end
end

hTotLengthSamples=hTotLength*N;
disp('Total number of blocks h must be split into: ')
NumberOfH
disp('Total Length of padded h (samples): ')
hTotLengthSamples

