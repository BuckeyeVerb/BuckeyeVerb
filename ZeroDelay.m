%x = audioread('Guitar_Input.wav");

%h = audioread('ir.wav');

%Fill input signal vector with 1's
x = ones(1024);

%Fill impulse response vector with 1's
h = ones(1024);

%starts incrementing from 0 onwards; For example, if there were 16 blocks, 
%counter would go from 0 to 15
block_Counter = 0;

%assuming that the number of blocks goes from h0 to h6.
%the size of each block is assumed to be 64 samples
%this would yield an IR of exactly 1024 samples
%the number of samples in the input signal is assumed to be a power of 2;
%for simplicity sake, let us assume that the input signal is also 1024
%samples

N = 64;

%convolve the first N samples with first half of h0
output = conv(x(block_Counter*N + 1 : N+block_Counter*N),h(1:N));

%play output
soundsc(output,96000);

%fast convolve h1 with first N samples 
IR = fft(h(2*N:3*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_1_1 = IR.*X;
OUT_1_1 = ifft(output_1_1(1:0.5*length(output_1_1)));

%carry over from FFT math previously (overlap add portion)
carry_over_1_1 = output_1_1(0.5*length(output_1_1)+1:length(output_1_1));

%fast convolve h2 with first N samples
IR = fft(h(3*N:4*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_1_2 = IR.*X;
OUT_1_2 = ifft(output_1_2(1:0.5*length(output_1_2)));

%carry over from FFT math previously (overlap add portion)
carry_over_1_2 = output_1_2(0.5*length(output_1_2)+1:length(output_1_2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 1 to 2N samples with h0
output = conv(x( (block_Counter - 1)*N + 1 : N+block_Counter*N), h(1:2*N));

%play output
soundsc(output,96000);

%fast convolve h1 with second N samples 
IR = fft(h(2*N:3*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_2_1 = IR.*X;
OUT_2_1 = ifft(output_2_1(1:0.5*length(output_2_1)));

%carry over from FFT math previously (overlap add portion)
carry_over_2_1 = output_2_1(0.5*length(output_2_1)+1:length(output_2_1));

%fast convolve h2 with N - 2N samples 
IR = fft(h(3*N:4*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_2_2 = IR.*X;
OUT_2_2 = ifft(output_2_2(1:0.5*length(output_2_2)));

%carry over from FFT math previously (overlap add portion)
carry_over_2_2 = output_2_2(0.5*length(output_2_2)+1:length(output_2_2));

%fast convolve h3 with 1 - 2N samples. 
IR = fft(h(4*N:6*N), 4*N - 1);
X = fft(x((block_counter - 1)*N + 1  : N+block_Counter*N), 4*N - 1);
output_12_3 = IR.*X;
OUT_12_3 = ifft(output_12_3(1:0.5*length(output_12_3)));

%carry over from FFT math previously (overlap add portion)
carry_over_12_3 = output_12_3(0.5*length(output_12_3)+1:length(output_12_3));

%fast convolve h4 with 1 - 2N samples. 
IR = fft(h(6*N:8*N), 4*N - 1);
X = fft(x((block_counter - 1)*N + 1  : N+block_Counter*N), 4*N - 1);
output_12_4 = IR.*X;
OUT_12_4 = ifft(output_12_4(1:0.5*length(output_12_4)));

%carry over from FFT math previously (overlap add portion)
carry_over_12_4 = output_12_4(0.5*length(output_12_4)+1:length(output_12_4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 1N to 3N samples with h0
output = conv(x((block_counter - 1)*N + 1 : N+block_Counter*N),h(1:2*N));

%play output
soundsc(output,96000);

%fast convolve h1 with 2N - 3N samples 
IR = fft(h(2*N:3*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_3_1 = IR.*X;
OUT_3_1 = ifft(output_3_1(1:0.5*length(output_3_1)));

%carry over from FFT math previously (overlap add portion)
carry_over_3_1 = output_3_1(0.5*length(output_3_1)+1:length(output_3_1));

%fast convolve h2 with 2N - 3N samples 
IR = fft(h(3*N:4*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_3_2 = IR.*X;
OUT_3_2 = ifft(output_3_2(1:0.5*length(output_3_2)));

%carry over from FFT math previously (overlap add portion)
carry_over_3_2 = output_3_2(0.5*length(output_3_2)+1:length(output_3_2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ceiling Reached. Algorithm gets somewhat repititive from here on in. In
% this particular example, every 4 blocks of code will look very similar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 2N to 4N samples with h0
output = conv(x((block_counter - 1)*N + 1 : N+block_Counter*N),h(1:2*N));

%play output
soundsc(output,96000);

%fast convolve h1 with 3N - 4N samples 
IR = fft(h(2*N:3*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_4_1 = IR.*X;
OUT_4_1 = ifft(output_4_1(1:0.5*length(output_4_1)));

%carry over from FFT math previously (overlap add portion)
carry_over_4_1 = output_4_1(0.5*length(output_4_1)+1:length(output_4_1));

%fast convolve h2 with 3N - 4N samples 
IR = fft(h(3*N:4*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_4_2 = IR.*X;
OUT_4_2 = ifft(output_4_2(1:0.5*length(output_4_2)));

%carry over from FFT math previously (overlap add portion)
carry_over_4_2 = output_4_2(0.5*length(output_4_2)+1:length(output_4_2));

%fast convolve h3 with 2N - 4N samples 
IR = fft(h(4*N:6*N), 4*N - 1);
X = fft(x((block_counter - 1)*N + 1  : N+block_Counter*N), 4*N - 1);
output_34_3 = IR.*X;
OUT_34_3 = ifft(output_34_3(1:0.5*length(output_34_3)));

%carry over from FFT math previously (overlap add portion)
carry_over_34_3 = output_34_3(0.5*length(output_34_3)+1:length(output_34_3));

%fast convolve h4 with 2N - 4N samples 
IR = fft(h(6*N:8*N), 4*N - 1);
X = fft(x((block_counter - 1)*N + 1  : N+block_Counter*N), 4*N - 1);
output_34_4 = IR.*X;
OUT_34_4 = ifft(output_34_4(1:0.5*length(output_34_4)));

%carry over from FFT math previously (overlap add portion)
carry_over_34_4 = output_34_4(0.5*length(output_34_4)+1:length(output_34_4));

%fast convolve h5 with 1 - 4N samples 
IR = fft(h(8*N:12*N), 8*N - 1);
X = fft(x((block_counter - 1)*N + 1  : N+block_Counter*N), 8*N - 1);
output_1234_5 = IR.*X;
OUT_1234_5 = ifft(output_1234_5(1:0.5*length(output_1234_5)));

%carry over from FFT math previously (overlap add portion)
carry_over_1234_5 = output_1234_5(0.5*length(output_1234_5)+1:length(output_1234_5));

%fast convolve h6 with 1 - 4N samples 
IR = fft(h(12*N:16*N), 8*N - 1);
X = fft(x((block_counter - 1)*N + 1  : N+block_Counter*N), 8*N - 1);
output_1234_6 = IR.*X;
OUT_1234_6 = ifft(output_1234_6(1:0.5*length(output_1234_6)));

%carry over from FFT math previously (overlap add portion)
carry_over_1234_6 = output_1234_6(0.5*length(output_1234_6)+1:length(output_1234_6));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 3N to 5N samples with h0
output = conv(x((block_counter - 1)*N + 1 : N+block_Counter*N),h(1:2*N));

%play output
soundsc(output,96000);

%fast convolve h1 with 4N - 5N samples 
IR = fft(h(2*N:3*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_5_1 = IR.*X;
OUT_5_1 = ifft(output_5_1(1:0.5*length(output_5_1)));

%carry over from FFT math previously (overlap add portion)
carry_over_5_1 = output_5_1(0.5*length(output_5_1)+1:length(output_5_1));

%fast convolve h2 with 4N - 5N samples 
IR = fft(h(3*N:4*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_5_2 = IR.*X;
OUT_5_2 = ifft(output_5_2(1:0.5*length(output_5_2)));

%carry over from FFT math previously (overlap add portion)
carry_over_5_2 = output_5_2(0.5*length(output_5_2)+1:length(output_5_2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 2N to 4N samples with h0
output = conv(x((block_counter - 1)*N + 1 : N+block_Counter*N),h(1:2*N));

%play output
soundsc(output,96000);

%fast convolve h1 with 5N - 6N samples 
IR = fft(h(2*N:3*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_6_1 = IR.*X;
OUT_6_1 = ifft(output_6_1(1:0.5*length(output_6_1)));

%carry over from FFT math previously (overlap add portion)
carry_over_6_1 = output_6_1(0.5*length(output_6_1)+1:length(output_6_1));

%fast convolve h2 with 5N - 6N samples 
IR = fft(h(3*N:4*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_6_2 = IR.*X;
OUT_6_2 = ifft(output_6_2(1:0.5*length(output_6_2)));

%carry over from FFT math previously (overlap add portion)
carry_over_6_2 = output_6_2(0.5*length(output_6_2)+1:length(output_6_2));

%fast convolve h3 with 4N - 6N samples 
IR = fft(h(4*N:6*N), 4*N - 1);
X = fft(x((block_counter - 1)*N + 1  : N+block_Counter*N), 4*N - 1);
output_56_3 = IR.*X;
OUT_56_3 = ifft(output_56_3(1:0.5*length(output_56_3)));

%carry over from FFT math previously (overlap add portion)
carry_over_56_3 = output_56_3(0.5*length(output_56_3)+1:length(output_56_3));

%fast convolve h4 with 4N - 6N samples 
IR = fft(h(6*N:8*N), 4*N - 1);
X = fft(x((block_counter - 1)*N + 1  : N+block_Counter*N), 4*N - 1);
output_56_4 = IR.*X;
OUT_56_4 = ifft(output_56_4(1:0.5*length(output_56_4)));

%carry over from FFT math previously (overlap add portion)
carry_over_56_4 = output_56_4(0.5*length(output_56_4)+1:length(output_56_4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 5N to 7N samples with h0
output = conv(x((block_counter - 1)*N + 1 : N+block_Counter*N),h(1:2*N));

%play output
soundsc(output,96000);

%fast convolve h1 with 6N - 7N samples 
IR = fft(h(2*N:3*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_7_1 = IR.*X;
OUT_7_1 = ifft(output_7_1(1:0.5*length(output_7_1)));

%carry over from FFT math previously (overlap add portion)
carry_over_7_1 = output_7_1(0.5*length(output_7_1)+1:length(output_7_1));

%fast convolve h2 with 6N - 7N samples 
IR = fft(h(3*N:4*N), 2*N - 1);
X = fft(x(block_Counter*N + 1 : N+block_Counter*N), 2*N - 1);
output_7_2 = IR.*X;
OUT_7_2 = ifft(output_7_2(1:0.5*length(output_7_2)));

%carry over from FFT math previously (overlap add portion)
carry_over_7_2 = output_7_2(0.5*length(output_7_2)+1:length(output_7_2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
