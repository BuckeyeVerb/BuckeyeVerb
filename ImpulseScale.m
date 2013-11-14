function [y] = ImpulseScale(ir,B, N)
%This function will load in the IR Weigel_004 and scale the initial spike by
%a certain value B. B = 1 is dry. B = 0 is wet. The ir will be a linear combination of the initial
%spike with the reverb tail. The combination is given by ir = (1-B) iri + B
%irt, where iri is the initial spike, and irt is the reverb tail.
%
% INUPUT
%   B = "wetness" nob.  [0 -----> 1 ;  dry -----> wet]
%   ir = impulse response
%   N = number of samples to be the initial spike
%
% Note: in order for this function to work, you must have the following in
% your directory
%   Recovered_IRs.mat
%   GuitarReveb.m


%trim the Weigel_004 IR

ir = ir(1:1e5);

n = (1:length(ir));

env1 = exp(-n/1e5);

ir = ir.*env1';


% seperate the first 500 samples (the initial spike) form the rest of the
% IR. call the initial spike iri and the reverb tail irt

iri = ir(1:N);

irt = ir(N+1:end);

zeropad1 = zeros(length(iri),1);

zeropad2 = zeros(length(irt),1);

iri = [iri; zeropad2];
irt = [zeropad1; irt];
% Make the output a linear combination of the initial spike and the reverb
% tail. ir = (1 - B) iri + B irt

ir2 = (1-B)*iri + B * irt;

%send the ir to the guitar reverb function

y = GuitarReverb(ir2);

end