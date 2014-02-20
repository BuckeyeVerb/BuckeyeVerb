function [ B,b,G ] = IRscale( ir,N )
%IRscale Scales and Trims the correction IR
%   Inputs
%   ir
%   
% % Find optimal Scaling of Correction Filter Impulse Responses % %

figure
plot(ir);
prompt = 'Choose the lower bound sample';
lb = input(prompt);
prompt = 'Choose the upper bound sample';
ub = input(prompt);
stem(ir);
xlim([lb ub])
prompt = 'Choose a cutoff sample';
cutoff = input(prompt);
ir_trimmed = ir(1:cutoff);

M = length(ir_trimmed)+N-1;
G = fft(ir_trimmed,M);
f = 96000*[0:M-1]/M;
B = 0;
z = 0;
figure
if z == 0
    semilogx(f,-db(abs(G))-B);
    xlim([20 2e4]);
    grid on
    xlabel('Frequency [Hz]');
    ylabel('Magnitude [dB]');
    title('Correction Filter from Studio_0_0_1, 9899c/Speaker0');
    prompt = 'Choose Scaling factor in dB';
    B = input(prompt);
    close
    
    semilogx(f,-db(abs(G))+B);
    xlim([20 2e4]);
    grid on
    xlabel('Frequency [Hz]');
    ylabel('Magnitude [dB]');
    title('Correction Filter from Studio_0_0_1, 9899c/Speaker0');
    prompt = 'Happy? (1 for YES, 0 for NO)';
    z == input(prompt);
    
end
G = -G;
B
b = exp(B/20)



end

