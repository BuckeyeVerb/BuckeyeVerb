function [signalmatrix, noisematrix] = Trimmer(wavename,reps,N,channels)
%TRIMMER The function reads in a wave file, finds the alignment impulse, 
% and then takes everything BEFORE the alignment impulse 
% as the noise.  GenerateMLSSequence places 2^N (the 'N' you choose) zeroes
% between the alignment impulse and the start of the actual maximum-length
% sequences; this program makes another matrix ("signalmatrix"), with the
% rest of the signal, beginning from the start of the actual MLSes.
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
    [impulset,peakvalues]=findpeaks(signalleft,'',2^N);
elseif (channels==2)
    signalright=signal(:,2);
    [impulset,peakvalues]=findpeaks(signalright,'',2^N);
end
if (channels==3)
impulset = zeros(1,length(signal(1,:)));
    for i=1:length(signal(1,:)) % Go through both stereo channels
        [k,peakvalues]=findpeaks(signal(:,i),'',2^N);  % It's very important that this
                                          % is the "findpeaks" function
                                          % included with the MLS Sequence
                                          % package and NOT the "findpeaks"
                                          % function that is included with
                                          % Matlab!
        impulset(i) = k(1);
    end
end
% At this point in the program, "impulset" is a vector listing the
% locations (indices) in "signal" where the peaks are; "peakvalues" is a
% vector the same length containing the respective amplitudes of those
% peaks.
    
%-----------------
% Displays a plot with several potential peaks labelled, since the length
% of space before the impalign might be more than the order of the MLS.
% The user will then get to choose which peak is the impalign.
figure
plot(signal(1:(length(signal)/2))) %Only plotting half for viewing ease

% Labelling the plot:
for z=1:4
    xd=double(impulset(z)); % Inputs to 'text' function must be doubles
    yd=double(peakvalues(z)); 
    text(xd,yd,[num2str(z)])
end
%-----------------


%ASK USER
prompt = 'Pick alignment impulse from numbered peaks on plot: ';
selectedZ = input(prompt);



impulseindex = impulset(selectedZ); % "impulseindex" is the number we're concerned
                              % with, as that's the location of the
                              % alignment impulse.


noisematrix=signal(1:(impulseindex-10))';
% ^ Chops everything AFTER the Impalign and saves the rest as noise.



signalmatrix=signal((impulseindex+(2^N)):((impulseindex+(2^N))+((2^N)*(reps+1))))';
% ^Creates a matrix that consists of the signal.  To ensure that the
% reverberations are included, "signalmatrix" is one MLS' length longer
% than the number of repetitions; this is the 'reps+1' term above.

%{
plot(signalmatrix)
figure
plot(noisematrix)
%}
end

