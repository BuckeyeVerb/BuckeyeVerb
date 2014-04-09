%number of samples in a block
N = 128;

x = audioread('Guitar_Input.wav');

h = audioread('stalbans_omni.wav');

x_realsampleSize = length(x)

h_realsampleSize = length(h)

%if the number of samples in input signal is not to the power of 2, extend
%the size of the input vector till it is a size of 2
if ceil(log2(x_realsampleSize)) ~= floor(log2(x_realsampleSize))
   x(2^(ceil(log2(x_realsampleSize)))) = 0;
   x = transpose(x);
end

%if the number of samples in the impulse response is not to the power of 2, extend
%the size of the input vector till it is a size of 2
if ceil(log2(h_realsampleSize)) ~= floor(log2(h_realsampleSize))
   h(2^ceil(log2(h_realsampleSize))) = 0;
   h = transpose(h);
end

x_newsampleSize = length(x)

h_newsampleSize = length(h)

x_Total = length(x)/N

h_Total = length(h)/N

%Final output array filled with 0's
y = zeros(1,(length(x) + length(h)) - 1);

for block_Counter = 1:x_Total
    
    %Standard convolve N samples with h0 
    y = standConv(y,block_Counter,x,h,N);
    
    %Fast convolution multiplication factor. This doubles each time,
    %as every pair-wise set of IR blocks is double in size to the previous
    %set
    m_F = 1;
    
    %This is the number of iterations needed to complete the fast
    %convolutions
    impulse_Size = ceil(log2(h_Total)) - 1;
    
    %For loop that computes fast convolutions
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
    %soundsc(y((block_Counter - 1)*N + 1 : (block_Counter)*N),96000)
    
end

% for block_Counter = x_Total + 1:(x_Total + h_Total)
%     %Print out computation   
%     if (block_Counter == (x_Total + h_Total))
%         %y((block_Counter - 1)*N + 1 : (block_Counter)*N - 1)
%         soundsc(y((block_Counter - 1)*N + 1 : (block_Counter)*N - 1),96000)
%     else
%         %y((block_Counter - 1)*N + 1 : (block_Counter)*N)
%         soundsc(y((block_Counter - 1)*N + 1 : (block_Counter)*N),96000)
%     end    
% end

%soundsc(y,96000)
%w = conv(x,h)
%plot(y-w)
