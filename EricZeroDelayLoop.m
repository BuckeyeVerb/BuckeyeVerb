%x = audioread('Guitar_Input.wav");

%h = audioread('ir.wav');
% ^^^Presently Unused^^^ %

%Fill input signal vector with 1's
x = ones(1,512);
x = [x,zeros(1,64)];

%Fill impulse response vector with 1's
h = ones(1,512);

%Final output array filled with 0's
y = zeros(1,1023+64);


% Slicing up the overall impulse response "h" into segments h0, h1, h2,
% etc...  In this example we've only gone to h4.  All the FFTs use two
% arguments, the first of which is the data and the second is a length.
% Matlab's "fft" function automatically appends zeroes if the length it's
% given is longer than the length of the signal given.
h0 = h(1:2*N);
H1 = fft( h(2*N+1:3*N) , 2*N-1);
H2 = fft( h(3*N+1:4*N) , 2*N-1);
H3 = fft( h(4*N+1:6*N) , 4*N-1);
H4 = fft( h(6*N+1:8*N) , 4*N-1);


%assuming that the number of blocks goes from h0 to h6.
%the size of each block is assumed to be 64 samples
%this would yield an IR of exactly 512 samples
%the number of samples in the input signal is assumed to be a power of 2;
%for simplicity sake, let us assume that the input signal is also 512
%samples

N = 64;


for block_Counter = 1:8
    output = conv( x((block_Counter-1)*N+1:(block_Counter)*N) , h0); % Convolves current N-length block of X with h0
    y((block_Counter-1)*N+1:(block_Counter+2)*N-1) = y((block_Counter-1)*N+1:(block_Counter+2)*N-1) + output; % Adds just-computed y0 to the output stream
    
    
    % Since FFT block convolution happens with every N samples that come
    % in, these next 8 lines haven't been written in an "if" statement
    X = fft( x((block_Counter-1)*N+1:(block_Counter)*N) , 2*N-1); % Extracting relevant block of x, zero padding, & taking FFT
    
    IR=X.*H1; % Doing the elem-by-elem multiplication w/ h1
    output=ifft(IR); % Self explanatory
    y((block_Counter+1)*N+1:(block_Counter+3)*N-1) = y((block_Counter+1)*N+1:(block_Counter+3)*N-1) + output; % Committing y1 to y
    
    IR=X.*H2; % Doing the elem-by-elem multiplication w/ h2
    output=ifft(IR); % Self explanatory
    y((block_Counter+2)*N+1:(block_Counter+4)*N-1) = y((block_Counter+2)*N+1:(block_Counter+4)*N-1) + output; % Committing y1 to y
    
    
    % This "if" loop runs every other time and performs the h3 and h4
    % convolutions, using the same method as used above for h1 and h2:
    if rem(block_Counter,2)==0
        X = fft( x((block_Counter-2)*N+1:(block_Counter)*N) , 4*N-1);
        
        IR=X.*H3;
        output=ifft(IR);
        y((block_Counter+2)*N+1:(block_Counter+6)*N-1) = y((block_Counter+2)*N+1:(block_Counter+6)*N-1) + output;
    
        IR=X.*H4;
        output=ifft(IR);
        y((block_Counter+4)*N+1:(block_Counter+8)*N-1) = y((block_Counter+4)*N+1:(block_Counter+8)*N-1) + output;
    end     
end

classicconv=conv(x,h);
plot(y-classicconv)