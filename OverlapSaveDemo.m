function [y] = OverlapSaveDemo(x,h,N)
% Simple demonstration of the overlap-save method working.
% Input "x" is the 'long' (w/ respect to IR) input signal
% Input "h" is the impulse response
% Input "N" is the length of the segments in the overlap-save method (I.E.
% the length of each little chunk of convolution that is done at any one
% time.  N must be reasonably chosen; constraint: length(h) < N < length(x)
% Also, N SHOULD BE A POWER OF TWO!  Not critical for this implementation,
% but it'll make it faster.
%
% Throughout the program, lowercase variables represent the vectors in
% time-space and capital variables represent the vectors in frequency-space
% in other words, X = FFT(x).  This only applies to x, h, and y.
%
% Since this is only a DEMO, it will show the equivalency between
% straightforward convolution of x & h (using Matlab's built-in "conv"
% function) and overlap-save as we have written it.
%
% In keeping with the way "wavread" defines its matrices, all vectors here
% are vertical.


M=length(x);
L=length(h);

% Inserting a lead-in zero-buffer on "x" so circular convolution starts at
% the proper place:
xLeadzeroes=zeros((length(h)-1),1);
xPrePad=[xLeadzeroes;x];

% Tacking on the tailing zeroes to "x" so that it is long enough for the
% last convolution to happen.
xNLength=ceil(length(xPrePad)/(N-L+1));
xTailzeroes=zeros(((xNLength*(N-L+1)+L-1)-length(xPrePad)),1);
xFullPad=[xPrePad;xTailzeroes];
% xFullPad should now have (length(h)-1) zeroes ahead of it and enough
% zeroes on the end of it to make its overall length an integer multiple of
% (N-L+1), which is the amount of space between the beginnings of
% neighbouring segments.

H=fft(h,N); % taking FFT of "h" outside the loop so we don't waste time doing it repeatedly

y=0; % Giving the function a "y" variable so it doesn't complain about 
     % there not being one later.

     
% Now for the overlapping and saving!
% The 'for' loop chops out part of the zero-padded signal "xFullPad" and
% stores it in the variable "xi."  An FFT of "xi" is taken which then gets
% multiplied with H, and the inverse FFT of this product is then taken.
% The variable "stor" chops out only the useful (saveable) portion of the
% signal.  The final line of the loop simply appends the new data ("stor")
% onto the end of "y," the program's ultimate output variable.

% This loop runs for every segment except the final one, since not the
% entire segment is saved (useless zeroes on end).
     
for i=1:(xNLength-1)
    xi=xFullPad(((i*(N-L+1))-N+L):((i*(N-L+1))+L-1));
    X=fft(xi);
    Y=X.*H;
    yi=ifft(Y);
    stor=yi((L):end); % Temporary variable that holds the newest usuable (saved) values 
    y=[y;stor];
end

% The next six lines of code are identical to those above, except that
% "stor" does not save the entire properly-calculated length of "yi,"
% instead only taking as far as needed to complete the length of the
% convolution, which should be M+L-1

xi=xFullPad(((xNLength*(N-L+1))-N+L):((xNLength*(N-L+1))+L-1));
X=fft(xi);
Y=X.*H;
yi=ifft(Y);
stor=yi((L):(L-1+(rem((length(xPrePad)),(N-L+1)))));
y=[y;stor];
y=y(2:end); % Chopping off the useless zero at the start of "y," it's left over from initializing "y"

% These last two unsuppressed lines are to compare the result "y" with slow
% (explicit) convolution
Classicconv=conv(x,h)
Circconv=cconv(x,h)
Difference=y-Classicconv