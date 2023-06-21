function [ NN_Noise, freq ] = NarrowBand_Noise(freq_gap, Building_Type)
% Input:
% freq_gap: the frequency resolution (Hz) (24,000 Hz for example)
% Building_Type: 'office' or 'residential'

% Output:
% NN_Noise:  narrowband noise PSD value (dbm) in frequency domain
% freq: the frequency array used for x axis.

%   References:
%   [Hrasnica04] Hrasnica, Halid, Abdelfatteh Haidine, and Ralf Lehnert. Broadband powerline communications: network design. John Wiley & Sons, 2005.
%   [Beny03] Benyoucef, Dirk. "A new statistical model of the noise power density spectrum for powerline communication." In Proceedings of the 7th International Symposium on Power-Line Communications and its Applications, Kyoto, Japan, pp. 136-141. 2003.
%
%   Bandwidth Choises are as follow
%      Band         Bandwidth
%       1           0MHz-10MHz
%       2           10MHz-20MHz
%       3           20MHz-30MHz
freq_Samp1 = floor(10/(freq_gap*10^-6));                % Sampling frequency in the first band
freq_Samp2 = floor(10/(freq_gap*10^-6));                % Sampling frequency in the second band
freq_Samp3 = floor(10/(freq_gap*10^-6));                % Sampling frequency in the third band
freq1 = zeros(1,freq_Samp1);                            % Frequency vector in the first band
freq2 = zeros(1,freq_Samp2);                            % Frequency vector in the second band
freq3 = zeros(1,freq_Samp3);                            % Frequency vector in the third band
NN_Noise1 = zeros(1,freq_Samp1);                        % Noise vector in the first band
NN_Noise2 = zeros(1,freq_Samp2);                        % Noise vector in the second band
NN_Noise3 = zeros(1,freq_Samp3);                        % Noise vector in the third band


% set up freq array
tmp_freq = 0;
for i = 1:freq_Samp1
     freq1(i) = tmp_freq;
     tmp_freq = tmp_freq + freq_gap*10^-6;
end 
for i = 1:freq_Samp2
     freq2(i) = tmp_freq;
     tmp_freq = tmp_freq + freq_gap*10^-6;
end 
for i = 1:freq_Samp3
     freq3(i) = tmp_freq;
     tmp_freq = tmp_freq + freq_gap*10^-6;
end 
freq = [freq1,freq2,freq3];





% narrowband interferer generation for 'office'

if strcmp(Building_Type, 'office')
    %NN for Band 1
    
    N1 = ceil(max(1 + 6.94 * randn,0));                 % Number of Narrowband interferer for the first band, generated based on normal distribution;[Beny03]
    for k=1:N1
        f0 = (0 + 10.*rand)*10^6;                       % Central frequency for interferer k, uniformly distributed between 0 and 10 MHz; [Beny03]
        B_k = random('exp',0.30);                       % The bandwidth of interferer k that is exponentially distributed with mean 0.30 and min(B_k) = 0.19;  [Beny03]
        if B_k < 0.19                                   
            B_k = 0.19;
        end
        A_k = max(6.5 + 19.2 * randn,0);                % Noise amplitude of interferer k in the first band, normally distributed. [Beny03]
        for i = 1:freq_Samp1
            NN_Noise1(i) = NN_Noise1(i) + A_k * exp (-((freq1(i) - f0)^2)/(2*B_k^2)) ;  % Narrowband noise in the first band obtained from the summation of all narrowband interferers in the first band
        end
    end
    
   
    %NN for Band 2
   
    N2 = ceil(max(0.69 + 3.64 * randn,0));              % Number of Narrowband interferer in the second band, generated based on normal distribution;[Beny03]
    for k=1:N2
        f0 = (10 + 10.*rand);                           % Central frequency for interferer k, uniformly distributed between 10 and 20 MHz; [Beny03]
        B_k = random('exp',0.45);                       % The bandwidth of interferer k that is exponentially distributed with mean 0.45 and min(B_k) = 0.19;  [Beny03]
        if B_k < 0.19
            B_k = 0.19;
        end
        A_k = max(4.8 + 16.6*randn,0);                  % Noise amplitude of interferer k in the second band, normally distributed. [Beny03]
        for i = 1:freq_Samp2
            NN_Noise2(i) = NN_Noise2(i) + A_k * exp (-((freq2(i) - f0)^2)/(2*B_k^2)) ;      % Narrowband noise in the second band obtained from the summation of all narrowband interferers in the second band
        end   
    end
    
    
    
    %NN for Band 3
    
    N3 = ceil(max(0.52 + 1.34 * randn,0));          % Number of Narrowband interferer in the third band, generated based on normal distribution;[Beny03]
    for k=1:N3
        f0 = (20 + 10.*rand);                       % Central frequency for interferer k, uniformly distributed between 20 and 30 MHz; [Beny03]
        B_k = random('exp',0.2);                    % The bandwidth of interferer k that is exponentially distributed with mean 0.2 and min(B_k) = 0.19;  [Beny03]
        if B_k < 0.19
            B_k = 0.19;
        end
        A_k =random('logn',0.7,1.5);                % Noise amplitude of interferer k in the third band, log normally distributed. [Beny03]
        for i = 1:freq_Samp3
            NN_Noise3(i) = NN_Noise3(i) + A_k  * exp (-((freq3(i) - f0)^2)/(2*B_k^2)) ;      % Narrowband noise in the third band obtained from the summation of all narrowband interferers in the third band
        end
    end
    
    
% narrowband interferer generation for 'residential' building
    
elseif strcmp(Building_Type, 'residential')
    % NN for Band 1
    
    N1 = ceil(max(0.88 + 5.47 * randn,0));           % Number of Narrowband interferer for the first band, generated based on normal distribution;[Beny03]
    for k=1:N1
        f0 = (0 + 10.*rand);                         % Central frequency for interferer k, uniformly distributed between 0 and 10 MHz; [Beny03]
        B_k = random('exp',0.20);                    % The bandwidth of interferer k that is exponentially distributed;  [Beny03]
        if B_k < 0.23
            B_k = 0.23;
        end
        A_k = 0.97 + (54.4-0.97) * rand;             % Noise amplitude of interferer k in the first band, uniformly distributed. [Beny03]
        for i = 1:freq_Samp1
            NN_Noise1(i) = NN_Noise1(i) + A_k * exp (-((freq1(i) - f0)^2)/(2*B_k^2)) ;       % Narrowband noise in the first band obtained from the summation of all narrowband interferers in the first band
        end
    end
    
    % NN for Band 2  
    
    N2 = ceil(max(0.35 + 3.94 * randn,0));           % Number of Narrowband interferer for the second band, generated based on normal distribution;[Beny03]
    for k=1:N2
        f0 = (10 + 10.*rand);                        % Central frequency for interferer k, uniformly distributed between 10 and 20 MHz; [Beny03]
        B_k = random('exp',0.18);                    % The bandwidth of interferer k that is exponentially distributed;  [Beny03]
        if B_k < 0.23
            B_k = 0.23;
        end
        A_k = max(9.6 + 23.2*randn,0);                % Noise amplitude of interferer k in the first band, normally distributed. [Beny03]
        for i = 1:freq_Samp2
            NN_Noise2(i) = NN_Noise2(i) + A_k * exp (-((freq2(i) - f0)^2)/(2*B_k^2)) ;       % Narrowband noise in the second band obtained from the summation of all narrowband interferers in the second band
        end   
    end
    
    % NN for Band 3
    N3 = ceil(max(0.72 + 2.53 * randn,0));            % Number of Narrowband interferer for the third band, generated based on normal distribution;[Beny03]
    for k=1:N3
        f0 = (20 + 10.*rand);                         % Central frequency for interferer k, uniformly distributed between 20 and 30 MHz; [Beny03]
        B_k = random('exp',0.09);                     % The bandwidth of interferer k that is exponentially distributed;  [Beny03]
        if B_k < 0.23
            B_k = 0.23;
        end
        A_k =random('logn',0.96,1.4);                 % Noise amplitude of interferer k in the third band, log normally distributed. [Beny03]
        for i = 1:freq_Samp3
            NN_Noise3(i) = NN_Noise3(i) + A_k  * exp (-((freq3(i) - f0)^2)/(2*B_k^2)) ;          % Narrowband noise in the third band obtained from the summation of all narrowband interferers in the third band
        end
        
    end
    
end


NN_Noise = [NN_Noise1,NN_Noise2,NN_Noise3];         % Concatenate narrowband noise of the three bandwidth
% plot(freq,NN_Noise);
% %saveas(gcf,'NarrowBand_Noise.fig');
% xlim([2,30]);
% xlabel('frequency (MHz)');
% ylabel('PSD (dBm/Hz)');
end

