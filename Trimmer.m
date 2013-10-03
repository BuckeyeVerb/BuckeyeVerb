Enter file contents herefunction [signalmatrix, noisematrix] = Trimmer(wavename,reps,N,channels)
%SMOOTHER The function reads in a wave file, finds the alignment impulse, 
%and then takes everything BEFORE the impulse as the
%noise.  GenerateMLSSequence places 2^N (the 'N' you choose) zeroes between
%the alignment impulse and the start of the actual maximum-length
%sequences; this program makes another matrix ("signalmatrix"), with the
%rest of the signal, beginning from the start of the actual MLSes.
%
%INPUTS:
%          wavename          WAVE AUDIO file that will be used
%          reps              Number of repetitions of the MLS sequence in
%                            the recording in question
%          N                 Order/length of one max. length sequence in
%                            the recording in question
%          channels          Use to specify how many, or which, channel to
%                            use.  For monaural recordings, put in either
%                            1 or 2; 1 to use the left channel or 2 to use
%                            the right channel.  To use both channels of a
%                            stereo recording, enter 3.  This variable is
%                            optional; if nothing is specified it will
%                            default to 1.
%
%OUTPUTS:
%          signalmatrix      A matrix containing the portion of the
%                            original recording ranging from the
%                            beginning of the MLS and goes to the end of
%                            the original recording.
%          noisematrix       A matrix containing the portion of the
%                            original recording ranging from the beginning
%                            of the recording to just before the alignment
%                            impulse.

%=======STEREOPHONIC===================================================

% These first couple lines are 'priming' the function for mono or stereo
% use; if the number of channels is NOT specified the program will default
% to monaural mode using the left channel.

if (nargin < 4)
    channels = 1;
end



signal=wavread(wavename); % "signal" is the raw data matrix from the WAVE file.


if (channels==1)
    signalleft=signal(:,1);
    impulset=findpeaks(signalleft,'',2^N);
elseif (channels==2)
    signalright=signal(:,2);
    impulset=findpeaks(signalright,'',2^N);
end
if (channels==3)
impulset = zeros(1,length(signal(1,:)));
    for i=1:length(signal(1,:)) % Go through both stereo channels
        k=findpeaks(signal(:,i),'',2^N);  % It's very important that this
                                          % is the "findpeaks" function
                                          % included with the MLS Sequence
                                          % package and NOT the "findpeaks"
                                          % function that is included with
                                          % Matlab!
        impulset(i) = k(1);
    end
end

    
impulseindex = min(impulset); % "impulseindex" is the number we're concerned
                             % with, as that's the location of the
                             % alignment impulse.


noisematrix=signal(1:(impulseindex-2))'; % Chops off everything AFTER a
                                         % certain point; point is two
                                         % samples BEFORE the Impalign;
                                         % only noise is retained.
signalmatrix=signal((impulseindex+(2^N)):(impulseindex+(2^N))+((2^N)*(reps+1)))';
% ^Creates a matrix of equal length to "noisematrix" that consists of the
% signal.


%------PRESENTLY UNUSED; may be incorporated later for plotting---------
%X=[1:length(C)]; % X is a matrix for the length of the 'C' vector
%X=X*(1/96000);   % Changing the units of X from samples to seconds.
%-----------------------------------------------------------------------


plot(signalmatrix)
    

    
end

