% This is a dummy test for the overlap save method of convolution 
% Given in HW 5, Problem 5, ECE 5200
% Problem statement:
% 
% Let x[n] be a length 10 signal given by [-7,-2,3,-1,0,6,-7,-2,6,1], and 
% let h[n] be a length 3 signal given by [3, -2, 1]. For parts (a) through 
% (d) below, show your work and the final output.
% 
% a.)
% 
% Use the MATLAB command conv to evaluate the linear convolution, 
% x[n] ? h[n]
% 
% given
x = [-7 -2 3 -1 0 6 -7 -2 6 1];
h = [3 -2 1];

lincon = conv(x,h);

% b.)
% 
% Use the MATLAB command cconv to evaluate the circular convolution, 
% x[n] cN
% h[n], for N = 16.

ccon = cconv(x,h,16);

% c.)

% Use MATLAB to compute the N-DFTs X[k] and H[k] for N = 16, and to compute 
% the inverse N-DFT of Y [k] = X[k]H[k] for N = 16.
% Hint: The MATLAB command fft(x, N) computes the N -DFT of a vector x 
% representing the sequence. The MATLAB command ifft(x, N) computes the 
% inverse N -DFT of x.

X = fft(x,16);
H = fft(h,16);

Y = X.*H;

y = ifft(Y);

% d.)

% Use the overlap-save method with segments of length N = 8 to find the 
% linear convolution of x[n] and h[n]. Indicate how many segments of x[n] 
% are needed, and what sequences you used for each segment. To find the 
% circular convolution for each segment, you may either compute it by hand 
% in the time domain, use the cconv command in MATLAB, or perform fast 
% convolution using the fft and ifft commands in MATLAB.

%x needs to be padded with two zeros at the beginning and four zeros at the
%end. (the two zeros at the beginning is for length(h)-1 -- has to do wth circular
%convolution) (The 4 zeros at the end is so you can fit exactly two
%segments into the padded vector x. Otherwise, one of the segments will be
%cut short.)
paddedx = [0 0 x 0 0 0 0];

seg1 = cconv(h,paddedx(1:8),8); %8 is the length of the segment
seg1 = seg1(3:end); %because of circular convolution, the first length(h)-1 values of each segment are garbage.
%the above step is throwing away those garbage values. In this case, h is
%lingth 3, so we get rid of the first two values in the convolution.


%For this example, I have simply done direct form convolution again for the
%second segment. However, for this second segment, you can use an fft/ifft
%combination to greatly save on computational cost. This is what the paper
%is telling us to do. It turns out that for very small legnths of
%convolution, direct form is fast, which is why you start the first segment
%off with a direct form convoltuion. But, for longer segments, fft/ifft
%convolution is much more efficient.


seg2 = cconv(h,paddedx(7:end),8); %the location of this second convoltuion segment is 
%such that we can throw away the first two "garbage" values and have it
%line up with the first segment.
seg2 = seg2(3:end); %again, we throw away the first two values because they are garbage due to circular convolution.

fasty = [seg1 seg2]; %place the two segments together to form the fast convolution chain

figure
subplot(2,2,1)
stem(lincon)
title('Linear Convolution')
ylabel('Mag')
xlabel('Samples')

subplot(2,2,2)
stem(ccon)
title('16 point circular convolution')
ylabel('Mag')
xlabel('Samples')

subplot(2,2,3)
stem(y)
title('16 point FFt convoltion')
ylabel('Mag')
xlabel('Samples')

subplot(2,2,4)
stem(fasty)
title('Fast Convolution')
ylabel('Mag')
xlabel('Samples')