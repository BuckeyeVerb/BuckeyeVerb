% CXCORR Circular Cross Correlation function estimates. 
% CXCORR(a,b), where a and b represent samples taken over time interval T
% which is assumed to be a common period of two corresponded periodic signals. 
% a and b are  row vectors, either real or complex. M is the length of the
% longer vector.
% 
% [x,c]=CXCORR(a,b) returns the length M-1 circular cross correlation sequence c
% with corresponded lags x.
%   
% The circular cross correlation is:
%         c(k) = sum[a(n)*conj(b(n+k))]/[norm(a)*norm(b)]; 
% where vector b is shifted CIRCULARLY by k samples.
%
% The function doesn't check the format of input vectors a and b!
%
% For circular covariance between a and b look for CXCOV(a,b) in
% http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&objectId=1093734
%
% Reference:
% A. V. Oppenheim, R. W. Schafer and J. R. Buck, Discrete-Time Signal Processing, 
% Upper Saddler River, NJ : Prentice Hall, 1999.
%
% Author: G. Levin, Apr. 26, 2004.

function [x,c]=cxcorr(a,b)
if length(a)>length(b)
    zeropad1 = zeros(1, length(a)-length(b));
    b = [b zeropad1];
end
if length(b)>length(a)
    zeropad1 = zeros(1, length(b)-length(a));
    a = [a zeropad1];
end
na=norm(a);
nb=norm(b);
a=a/na; %normalization
b=b/nb;
for k=1:length(b)
    c(k)=a*b';
    b=[b(end),b(1:end-1)]; %circular shift
end
x=[0:length(b)-1]; %lags