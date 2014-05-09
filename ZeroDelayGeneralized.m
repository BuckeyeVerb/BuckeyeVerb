%number of samples in a block
N = 32;

%number of blocks of input
x_Total = 1024;

%Fill input signal vector with random numbers
x = rand(1,x_Total*N);

%number of blocks of impulse response
h_Total = 16;

%Fill input signal vector with random numbers
h = rand(1,h_Total*N);

%Final output array filled with 0's
y = zeros(1,(length(x) + length(h)) - 1);

for block_Counter = 1:x_Total
    %standard convolve N samples with h0 
    y = standConv(y,block_Counter,x,h,N);
    
    m_F = 1;
    
    impulse_Size = ceil(log2(h_Total)) - 1;
    
    for impulse_Counter = 1:impulse_Size
        
        if rem(block_Counter,m_F) == 0
             
            IR = IRComp(h,2*m_F,3*m_F,2*m_F,N);
            X = XComp(x,block_Counter,1*m_F,2*m_F,N);    
    
            y = outputComp(y,block_Counter,1*m_F,3*m_F,IR,X,N);           
            
            %Addresses the last block of impulse response.
            if (impulse_Counter ~= impulse_Size) || ((floor(log2(h_Total)) - 1) == impulse_Size)
                IR = IRComp(h,3*m_F,4*m_F,2*m_F,N);     
                y = outputComp(y,block_Counter,2*m_F,4*m_F,IR,X,N);
            end
            
        end
        
        m_F = m_F * 2;
        
    end
    
    %Print out computation
    %y((block_Counter - 1)*N + 1 : (block_Counter)*N)
    
end

% for block_Counter = x_Total + 1:(x_Total + h_Total)
%     %Print out computation   
%     if (block_Counter == (x_Total + h_Total))
%         y((block_Counter - 1)*N + 1 : (block_Counter)*N - 1)
%     else
%         y((block_Counter - 1)*N + 1 : (block_Counter)*N)
%     end    
% end

y

w = conv(x,h);
%figure(1)
%plot(y,'r')
%title('Plot of Standard Convolution Output vs # of Samples', 'FontSize', 18)
%ylabel('Output')
%xlabel('# of Samples')
%figure(2)
%plot(w,'g')
%title('Plot of Zero-Delay Convolution Output vs # of Samples', 'FontSize', 18)
%ylabel('Output')
%xlabel('# of Samples')
figure(3)
plot(y-w)
title('Zero-Delay vs Standard Convolution', 'FontSize', 18)
ylabel('Output Delta')
xlabel('# of Samples')