function [ hout,dir,s ] = dirpathsc( hin )
%[ hout,dir,s ] = dirpathsc( hin )
%dirpathsc scales the direct path part of an impulse response, without
%altering any of the reflections
%   hout = dirpath(hin)
%   hin - impulse response to be altered
%   hout - altered impulse response
%   dir - Just the Direct Path
%   s - scaler  

figure
plot(hin);
prompt = 'Choose the lower bound sample';
lb = input(prompt);
prompt = 'Choose the upper bound sample';
ub = input(prompt);
stem(hin);
xlim([lb ub])
prompt = 'Choose a cutoff sample';
cutoff = input(prompt);
dir = hin(1:cutoff);
ref = hin((cutoff+1):length(hin));
dirx = max(dir);
refx = max(ref);
sprintf('Direct Path max = %g',dirx)
sprintf('Reclections max = %g',refx)

prompt = 'Choose a scale for the direct path (linear)';
s = input(prompt);
dirsc = s.*dir;

hout = [dirsc;ref];


end

