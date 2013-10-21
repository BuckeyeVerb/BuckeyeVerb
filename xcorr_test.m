%This script is to test the xcorr function in MATLAB in relation to the MLS
%signals. The MLS signal has the property that x (star) x = delta function
%[where x is the MLS sequence and (star) is the cross correlation operator]
%Let y be an output signal and h be an impulse response. Then y = x * h.
%x (star) y = x (star) x * h = delta function * h = h. The result is that
%xcorr between the mls sequence and the output signal yeilds the impulse
%response.


N = 10; %Order of MLS
P = 2^N - 1;

%Generate MLS, x
%Generate IR, h
%Convolve x * h, y
%Preform all three of the above operations using Dummy_Test_One.m

[x,h,h1,h2,y] = DummyTestOne(N,0);


% first veryify the delta function property of x. 
% Preform: 1/(P+1) * xcorr(x,x);

[f corr] = cxcorr(x',x');


stem(corr)
title('MLS autocorrelation test')

%Cross correlate x (star) y h3

[f h3] = cxcorr(y',x');

figure
subplot(1,3,1)
plot(h3)
title('IR Recovered using xcorr')


subplot(1,3,2)
plot(h1)
title('IR Recovered using AMLS')

subplot(1,3,3)
plot(h)
title('Original IR')


%This method does not seem to be working. I am getting h3 to be much longer
%than it should be. I will try to verify the relations
%x (star) y = x (star) x * h = delta function * h = h



%First verify that x (star) y = x (star) x * h

[f xstary] = cxcorr(y',x');
xstarxconvh = cconv(corr,h',length(h));

figure
subplot(1,2,1)
plot(xstary)
title('x (star) y')

subplot(1,2,2)
plot(xstarxconvh)
title('x (star) x * h')


%Next verify x (star) x * h = h

hq = cconv(corr,h',length(h));


figure
subplot(1,2,1)
plot(hq)
title('IR Recovered using x (star) x * h')

subplot(1,2,2)
plot(h)
title('Original IR')