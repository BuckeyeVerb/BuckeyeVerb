function [ hnew ] = TailExt( hin )
%TailExt Extends the reverb tail of an impulse response to lower the noise
%floor of an IR to be convolved with an input signal
%   hnew = TailExt( hin)
%   hin - Impulse Response to be altered
%   hnew - Impulse Response with extended tail

figure
plot(db(hin))
title('Impulse Response to be Altered');
prompt = 'Choose the leftmost point from which to make a linear window';
p1 = input(prompt);
prompt = 'Choose the rightmost point from which to make a linear window';
p2 = input(prompt);

[out,PosEnv,hpos] = taperset(hin,0,p1,p2);

figure
plot(db(hpos)-db(out));
title('Difference in Positive Part of Impulse');
prompt = 'Choose a dB offset for the linear fit';
bnew = input(prompt);

[out,PosEnv,hpos] = taperset(hin,bnew,p1,p2);
plot(db(hpos)-db(out));
title('Difference in Positive Part of Impulse');
 
% Negative Part
hneg = 0.5*(hin-abs(hin));
outneg = hneg.*PosEnv;
figure
plot(db(hneg)-db(outneg));
title('Difference in Negative part of Impulse')

% Combining Them
hnew = out+outneg;
figure
subplot(2,1,1);
    plot(hnew);
    title('New IR with Extended Tail');
subplot(2,1,2);
    plot(db(hnew));
    ylabel('dB') 
    
end

function [out,PosEnv,hpos] = taperset(hin,b,p1,p2);
x = (0:length(hin)-1);
s = (db(hin(p2))-db(hin(p1)))/(p2-p1);
Exp = 10.^((s.*x+b)/20);
figure
subplot(2,1,1)
    plot(x,db(hin),x,db(Exp));
    title('IR with Linear Window fit');
    xlabel('samples');
    ylabel('dB');
subplot(2,1,2)
    plot(Exp);
    title('Exponential window');
    
 % Positive part
 hpos = 0.5*(abs(hin)+hin);
 win = db(Exp);
 win(1:p1) = 0;
 win = win';
 PosEnv = 10.^(win/20);
 out = hpos.*PosEnv;
 
end



