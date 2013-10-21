function [ ir,H ] = AnalyseBasement(mls,observed,reps,N,impalign,varargin) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [ ir,H ] = AnalyseBasement(mls, observed,reps,N,impalign, DCcoupling, offset)
% Inputs:
%   mls                 mls sequence used in measurement (.wav)           
%   observed            observed data (.wav)
%   reps                reps of mls
%   N                   order of mls
%   impalign            0 or 1 
%   DCcoupling          'true' or 'false' - default 'false' if empty
%   offset              # of samples offset - default 0 if empty
% 
%   (offset, reps, N, DCcoupling, impalign all the same as in AMLS)
% 
% 
% 
% Outputs:
%   ir                    ir from AnalyseMLSSequence
%   H                     fft of ir
% 
%
%
% Function will plot the following
% 
% ~ mls input and observed output variabes (linear and log scale)
% ~ Recovered ir in the time domain
% ~ Recovered ir in the freq domain (linear and log scale)
% 
% 
% Note: Function is designed to go with the experiment titled 
% 'Basement Experiments_10_19' on the Google Drive
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set defaults
if length(varargin)==0
    DCcoupling = 'false';
    offset = 0;
elseif length(varargin)==1
    DCcoupling = varargin{1};
    offset = 0;
elseif length(varargin)==2
    DCcoupling = varargin{1};
    offset = varargin{2};
elseif length(varargin)>2
        disp('ERROR: Too many input arguments','r')
        return
end

[x Fsmls] = audioread(mls);
[y Fsobs] = audioread(observed);
ir = AnalyseMLSSequence(y,offset,reps,N,DCcoupling,impalign);

hand1 = figure;                          % plot input and output variables on the same plot
subplot(2,1,1)
plot(x);
title(sprintf('%s;   reps = %d, Order = %d, impalign = %d',observed ,reps,N, impalign),'interpreter','none');
xlabel('samples');
ylabel('x[n]')
subplot(2,1,2)
plot(y);
xlabel('samples');
ylabel('y[n]');

hand2 = figure;
plot(ir);
title(sprintf('Recovered Impulse Response for %s;   reps = %d, Order = %d, impalign = %d',observed ,reps,N, impalign),'interpreter','none');
xlabel('samples');
ylabel('h[n]');

hand3 = figure;
subplot(2,1,1)
plot(db(y));
title(sprintf('%s;   reps = %d, Order = %d, impalign = %d',observed ,reps,N, impalign),'interpreter','none');
xlabel('samples');
ylabel('dB y')
ylim([-110 0])
subplot(2,1,2)
plot(db(ir));
xlabel('samples');
ylabel('dB ir')
ylim([-110 0])


H = fft(ir);
halfNyq = Fsobs/2;
freq = [halfNyq/(length(H)/2):halfNyq/(length(H)/2):halfNyq];%generate frequency plot variable (x axis)
hand4 = figure;
subplot(2,1,1);
semilogx(freq,db(abs(H(1:length(H)/2))));
xlim([100,halfNyq])
ylim([-80, 10])
title(sprintf('Frequency response of %s;   reps = %d, Order = %d, impalign = %d',observed ,reps,N, impalign),'interpreter','none');
xlabel('Frequency (Hz)');
ylabel('dB Magnitude');
subplot(2,1,2)
plot(freq, db(abs(H(1:length(H)/2))));
ylim([-80, 10])
title('Linear Frequency Response');
xlabel('Frequency (Hz)');
ylabel('dB Magnitude');

end

