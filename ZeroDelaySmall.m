%x = audioread('Guitar_Input.wav");

%h = audioread('ir.wav');

%Fill input signal vector with 1's
x = ones(1,128);

%Fill impulse response vector with 1's
h = ones(1,128);

%Final output array filled with 0's
y = zeros(1,255);

%start counter at 1
block_Counter = 1;

%assuming that the number of blocks goes from h0 to h6.
%the size of each block is assumed to be 64 samples
%this would yield an IR of exactly 512 samples
%the number of samples in the input signal is assumed to be a power of 2;
%for simplicity sake, let us assume that the input signal is also 512
%samples

N = 16;

%convolve the first N samples with h0
output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N),h(1:2*N));

%play output
%soundsc(output,96000);

y(1:3*N - 1) = y(1:3*N - 1) + output;

%fast convolve h1 with first N samples 
IR = fft(h( 2*N + 1 : 3*N ), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N  : (block_Counter)*N), 2*N - 1);
output_1_1 = IR.*X;
OUT_1_1 = ifft(output_1_1);

y(2*N + 1 : 4*N - 1) = y(2*N + 1 : 4*N - 1) + OUT_1_1;

%carry over from FFT math previously (overlap add portion)
%carry_over_1_1 = ifft(output_1_1(0.5*length(output_1_1)+1:length(output_1_1)));

%fast convolve h2 with first N samples
IR = fft(h( 3*N + 1: 4*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N  : (block_Counter)*N), 2*N - 1);
output_1_2 = IR.*X;
OUT_1_2 = ifft(output_1_2);

y(3*N + 1 : 5*N - 1) = y(3*N + 1 : 5*N - 1) + OUT_1_2;

%carry over from FFT math previously (overlap add portion)
%carry_over_1_2 = ifft(output_1_2(0.5*length(output_1_2)+1:length(output_1_2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve N to 2N samples with h0
output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N), h(1:2*N));

y(N + 1 : 4*N - 1) = y(N + 1 : 4*N - 1) + output;

%play output
%soundsc(output,96000);

%fast convolve h1 with N - 2N samples 
IR = fft(h(2*N + 1 : 3*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_2_1 = IR.*X;
OUT_2_1 = ifft(output_2_1);

y(3*N + 1 : 5*N - 1) = y(3*N + 1 : 5*N - 1) + OUT_2_1;

%carry over from FFT math previously (overlap add portion)
%carry_over_2_1 = output_2_1(0.5*length(output_2_1)+1:length(output_2_1));

%fast convolve h2 with N - 2N samples 
IR = fft(h(3*N + 1 : 4*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_2_2 = IR.*X;
OUT_2_2 = ifft(output_2_2);

y(4*N + 1 : 6*N - 1) = y(4*N + 1 : 6*N - 1) + OUT_2_2;

%carry over from FFT math previously (overlap add portion)
%carry_over_2_2 = output_2_2(0.5*length(output_2_2)+1:length(output_2_2));

%fast convolve h3 with 1 - 2N samples 
IR = fft(h(4*N + 1:6*N), 4*N - 1);
X = fft(x( 1 + (block_Counter - 2)*N : (block_Counter)*N), 4*N - 1);
output_12_3 = IR.*X;
OUT_12_3 = ifft(output_12_3);

y(4*N + 1 : 8*N - 1) = y(4*N + 1 : 8*N - 1) + OUT_12_3;

%carry over from FFT math previously (overlap add portion)
%carry_over_12_3 = output_12_3(0.5*length(output_12_3)+1:length(output_12_3));

%fast convolve h4 with 1 - 2N samples 
IR = fft(h(6*N + 1:8*N), 4*N - 1);
X = fft(x( 1 + (block_Counter - 2)*N : (block_Counter)*N), 4*N - 1);
output_12_4 = IR.*X;
OUT_12_4 = ifft(output_12_4);

y(6*N + 1 : 10*N - 1) = y(6*N + 1 : 10*N - 1) + OUT_12_4;

%carry over from FFT math previously (overlap add portion)
%carry_over_12_4 = output_12_4(0.5*length(output_12_4)+1:length(output_12_4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 2N to 3N samples with h0
output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N), h(1:2*N));

%play output
%soundsc(output,96000);

y(2*N + 1 : 5*N - 1) = y(2*N + 1 : 5*N - 1) + output;

%fast convolve h1 with 2N - 3N samples 
IR = fft(h(2*N + 1 : 3*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_3_1 = IR.*X;
OUT_3_1 = ifft(output_3_1);

y(4*N + 1 : 6*N - 1) = y(4*N + 1 : 6*N - 1) + OUT_3_1;

%carry over from FFT math previously (overlap add portion)
%carry_over_3_1 = output_3_1(0.5*length(output_3_1)+1:length(output_3_1));

%fast convolve h2 with 2N - 3N samples 
IR = fft(h(3*N + 1 : 4*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_3_2 = IR.*X;
OUT_3_2 = ifft(output_3_2);

%carry over from FFT math previously (overlap add portion)
%carry_over_3_2 = output_3_2(0.5*length(output_3_2)+1:length(output_3_2));

y(5*N + 1 : 7*N - 1) = y(5*N + 1 : 7*N - 1) + OUT_3_2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 3N to 4N samples with h0
output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N), h(1:2*N));

%play output
%soundsc(output,96000);

y(3*N + 1 : 6*N - 1) = y(3*N + 1 : 6*N - 1) + output;

%fast convolve h1 with 3N - 4N samples 
IR = fft(h(2*N + 1 : 3*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_4_1 = IR.*X;
OUT_4_1 = ifft(output_4_1);

%carry over from FFT math previously (overlap add portion)
%carry_over_4_1 = output_4_1(0.5*length(output_4_1)+1:length(output_4_1));

y(5*N + 1 : 7*N - 1) = y(5*N + 1 : 7*N - 1) + OUT_4_1;

%fast convolve h2 with 3N - 4N samples 
IR = fft(h(3*N + 1 : 4*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_4_2 = IR.*X;
OUT_4_2 = ifft(output_4_2);

%carry over from FFT math previously (overlap add portion)
%carry_over_4_2 = output_4_2(0.5*length(output_4_2)+1:length(output_4_2));

y(6*N + 1 : 8*N - 1) = y(6*N + 1 : 8*N - 1) + OUT_4_2;

%fast convolve h3 with 2N - 4N samples 
IR = fft(h(4*N + 1 : 6*N), 4*N - 1);
X = fft(x( 1 + (block_Counter - 2)*N : (block_Counter)*N), 4*N - 1);
output_34_3 = IR.*X;
OUT_34_3 = ifft(output_34_3);

%carry over from FFT math previously (overlap add portion)
%carry_over_34_3 = output_34_3(0.5*length(output_34_3)+1:length(output_34_3));

y(6*N + 1 : 10*N - 1) = y(6*N + 1 : 10*N - 1) + OUT_34_3;

%fast convolve h4 with 2N - 4N samples 
IR = fft(h(6*N + 1 : 8*N), 4*N - 1);
X = fft(x( 1 + (block_Counter - 2)*N : (block_Counter)*N), 4*N - 1);
output_34_4 = IR.*X;
OUT_34_4 = ifft(output_34_4);

%carry over from FFT math previously (overlap add portion)
%carry_over_34_4 = output_34_4(0.5*length(output_34_4)+1:length(output_34_4));

y(8*N + 1 : 12*N - 1) = y(8*N + 1 : 12*N - 1) + OUT_34_4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 4N to 5N samples with h0
output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N), h(1:2*N));

%play output
%soundsc(output,96000);

y(4*N + 1 : 7*N - 1) = y(4*N + 1 : 7*N - 1) + output;

%fast convolve h1 with 4N - 5N samples 
IR = fft(h(2*N + 1 : 3*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_5_1 = IR.*X;
OUT_5_1 = ifft(output_5_1);

%carry over from FFT math previously (overlap add portion)
%carry_over_5_1 = output_5_1(0.5*length(output_5_1)+1:length(output_5_1));

y(6*N + 1 : 8*N - 1) = y(6*N + 1 : 8*N - 1) + OUT_5_1;

%fast convolve h2 with 4N - 5N samples 
IR = fft(h(3*N + 1 : 4*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_5_2 = IR.*X;
OUT_5_2 = ifft(output_5_2);

%carry over from FFT math previously (overlap add portion)
%carry_over_5_2 = output_5_2(0.5*length(output_5_2)+1:length(output_5_2));

y(7*N + 1 : 9*N - 1) = y(7*N + 1 : 9*N - 1) + OUT_5_2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 5N to 6N samples with h0
output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N), h(1:2*N));

%play output
%soundsc(output,96000);

y(5*N + 1 : 8*N - 1) = y(5*N + 1 : 8*N - 1) + output;

%fast convolve h1 with 5N - 6N samples 
IR = fft(h(2*N + 1 : 3*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_6_1 = IR.*X;
OUT_6_1 = ifft(output_6_1);

%carry over from FFT math previously (overlap add portion)
%carry_over_6_1 = output_6_1(0.5*length(output_6_1)+1:length(output_6_1));

y(7*N + 1 : 9*N - 1) = y(7*N + 1 : 9*N - 1) + OUT_6_1;

%fast convolve h2 with 5N - 6N samples 
IR = fft(h(3*N + 1 : 4*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_6_2 = IR.*X;
OUT_6_2 = ifft(output_6_2);

%carry over from FFT math previously (overlap add portion)
%carry_over_6_2 = output_6_2(0.5*length(output_6_2)+1:length(output_6_2));

y(8*N + 1 : 10*N - 1) = y(8*N + 1 : 10*N - 1) + OUT_6_2;

%fast convolve h3 with 4N - 6N samples 
IR = fft(h(4*N + 1 : 6*N), 4*N - 1);
X = fft(x( 1 + (block_Counter - 2)*N : (block_Counter)*N), 4*N - 1);
output_56_3 = IR.*X;
OUT_56_3 = ifft(output_56_3);

%carry over from FFT math previously (overlap add portion)
%carry_over_56_3 = output_56_3(0.5*length(output_56_3)+1:length(output_56_3));

y(8*N + 1 : 12*N - 1) = y(8*N + 1 : 12*N - 1) + OUT_56_3;

%fast convolve h4 with 4N - 6N samples 
IR = fft(h(6*N + 1 : 8*N), 4*N - 1);
X = fft(x( 1 + (block_Counter - 2)*N : (block_Counter)*N), 4*N - 1);
output_56_4 = IR.*X;
OUT_56_4 = ifft(output_56_4);

%carry over from FFT math previously (overlap add portion)
%carry_over_56_4 = output_56_4(0.5*length(output_56_4)+1:length(output_56_4));

y(10*N + 1 : 14*N - 1) = y(10*N + 1 : 14*N - 1) + OUT_56_4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 6N to 7N samples with h0
output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N), h(1:2*N));

%play output
%soundsc(output,96000);

y(6*N + 1 : 9*N - 1) = y(6*N + 1 : 9*N - 1) + output;

%fast convolve h1 with 6N - 7N samples 
IR = fft(h(2*N + 1 : 3*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_7_1 = IR.*X;
OUT_7_1 = ifft(output_7_1);

%carry over from FFT math previously (overlap add portion)
%carry_over_7_1 = output_7_1(0.5*length(output_7_1)+1:length(output_7_1));

y(8*N + 1 : 10*N - 1) = y(8*N + 1 : 10*N - 1) + OUT_7_1;

%fast convolve h2 with 6N - 7N samples 
IR = fft(h(3*N + 1 : 4*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_7_2 = IR.*X;
OUT_7_2 = ifft(output_7_2);

%carry over from FFT math previously (overlap add portion)
%carry_over_7_2 = output_7_2(0.5*length(output_7_2)+1:length(output_7_2));

y(9*N + 1 : 11*N - 1) = y(9*N + 1 : 11*N - 1) + OUT_7_2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_Counter = block_Counter + 1;

%convolve 7N to 8N samples with h0
output = conv(x(1 + (block_Counter - 1)*N : (block_Counter)*N), h(1:2*N));

%play output
%soundsc(output,96000);

y(7*N + 1 : 10*N - 1) = y(7*N + 1 : 10*N - 1) + output;

%fast convolve h1 with 7N - 8N samples 
IR = fft(h(2*N + 1 : 3*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_8_1 = IR.*X;
OUT_8_1 = ifft(output_8_1);

%carry over from FFT math previously (overlap add portion)
%carry_over_8_1 = output_8_1(0.5*length(output_8_1)+1:length(output_8_1));

y(9*N + 1 : 11*N - 1) = y(9*N + 1 : 11*N - 1) + OUT_8_1;

%fast convolve h2 with 7N - 8N samples 
IR = fft(h(3*N + 1 : 4*N), 2*N - 1);
X = fft(x( 1 + (block_Counter - 1)*N : (block_Counter)*N), 2*N - 1);
output_8_2 = IR.*X;
OUT_8_2 = ifft(output_8_2);

%carry over from FFT math previously (overlap add portion)
%carry_over_8_2 = output_8_2(0.5*length(output_8_2)+1:length(output_8_2));

y(10*N + 1 : 12*N - 1) = y(10*N + 1 : 12*N - 1) + OUT_8_2;

%fast convolve h3 with 6N - 8N samples 
IR = fft(h(4*N + 1 : 6*N), 4*N - 1);
X = fft(x( 1 + (block_Counter - 2)*N : (block_Counter)*N), 4*N - 1);
output_78_3 = IR.*X;
OUT_78_3 = ifft(output_78_3);

%carry over from FFT math previously (overlap add portion)
%carry_over_78_3 = output_78_3(0.5*length(output_78_3)+1:length(output_78_3));

y(10*N + 1 : 14*N - 1) = y(10*N + 1 : 14*N - 1) + OUT_78_3;

%fast convolve h4 with 6N - 8N samples 
IR = fft(h(6*N + 1 : 8*N), 4*N - 1);
X = fft(x( 1 + (block_Counter - 2)*N : (block_Counter)*N), 4*N - 1);
output_78_4 = IR.*X;
OUT_78_4 = ifft(output_78_4);

%carry over from FFT math previously (overlap add portion)
%carry_over_78_4 = output_78_4(0.5*length(output_78_4)+1:length(output_78_4));

y(12*N + 1 : 16*N - 1) = y(12*N + 1 : 16*N - 1) + OUT_78_4;

y
