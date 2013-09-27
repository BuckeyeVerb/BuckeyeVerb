%This test script will be testing the functions GenerateMLSSequence.m,
%and AnalyseMLSSequence.m. The script will generate an impulse response and
%an MLS sequence and convolve the two signals. The output signal will then
%be sent to AnalyseMLSSequence.m. If the codes are working correctly, the
%AnalyseMLSSequence function should recover the same impulse response.

%{
[x, burst] = GenerateMLSSequence(4,3,1);        
% x is our system input
% burst is one burst of our mls sequence

h = [1 1 0 0 0 0 0];
% Made up impulse response

y = conv(burst,h); 
% 'observed'

% recovery of h
ir = AnalyseMLSSequence(y,0,0,3,'false',1);
%}

% Tests to see just how this stuff works.  All h's will be [1 0 0 0...] 
% 2 repetitions for each of these examples. No impalign.
% Taking N = 2 here
[x2,b2] = GenerateMLSSequence(2,2,0);
h2 = [1 0 0]';
y2 = conv(x2,h2);
r2 = AnalyseMLSSequence(y2,0,2,2,'false',0);

% Taking N = 2 here, applying offset
r2_ = AnalyseMLSSequence(y2,20,2,2,'true',0);


% N = 3 
[x3,b3] = GenerateMLSSequence(2,3,0);
h3 = [1 0 0 0 0 0 0]';
y3 = conv(x3,h3);
r3 = AnalyseMLSSequence(y3,0,2,3,'false',0);

% Another N = 3 example
h3_ = [1 0 1 1 0 0 0]';
y3_ = conv(x3,h3_);
r3_ = AnalyseMLSSequence(y3_,0,2,3,'false',0);

% Another N = 3 example, different h
h3w = [1 0 .25 .33 .12 0 0]';
y3w = conv(x3,h3w);
r3w = AnalyseMLSSequence(y3w,0,2,3,'false',0);

% N = 5
[x5,b5] = GenerateMLSSequence(4,5,0);
h5 = [1 1 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
y5 = conv(x5,h5);
r5 = AnalyseMLSSequence(y5,0,4,5,'false',0);

% With Impalign, N = 3
[x3_ia,b3_ia] = GenerateMLSSequence(2,3,1);
h3_ia = [1 0 1 1 .25 0 0]';
y3_ia = conv(x3_ia,h3_ia);
r3_ia = AnalyseMLSSequence(y3_ia,0,2,3,'false',1);

% For small Mershon Booth
[test_Genelecs, mls] = GenerateMLSSequence(9,15,1);
wavwrite(test_Genelecs, 96000, 24, '341ms_MLS_9');
[test_Genelecs, mls] = GenerateMLSSequence(20,15,1);
wavwrite(test_Genelecs, 96000, 24, '341ms_MLS_20');

% For Measurements 9/17/13 Smith 2180
[Smith20, mls] = GenerateMLSSequence(20,19,1);
wavwrite(Smith20, 96000, 24, '5461ms_MLS_20');
[Smith12, mls] = GenerateMLSSequence(12,19,1);
wavwrite(Smith12, 96000, 24, '5461ms_MLS_12');



