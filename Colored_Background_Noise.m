function [ BG_Noise, freq ] = Colored_Background_Noise(level, freq_gap)
% Inputs:
% level:              'worst' or 'best' or 'random'
% freq_gap:           frequency resolution (Hz) (24000 Hz for example)

% Output:
% BG_Noise:          the background noise PSD value (dBm)
% freq:              the frequency array used in x axis

%   Reference:
%   Esmailian, Tooraj, Frank R. Kschischang, and P. Glenn Gulak. "In?building power lines as high?speed communication channels: channel characterization and a test channel ensemble." International Journal of Communication Systems 16, no. 5 (2003): 381-400.

% The frequency range 
f_high = 30000000;
f_low = 2000000;

% Assign related values to a,b,c according to the noise_level    
if strcmp(level, 'worst')
    color = 'r';
	a = -145;
	b = 53.23;
	c = - 0.337;
elseif strcmp(level, 'best')
    color = 'g';
	a = -140;
	b = 38.75;
	c = -0.720;
elseif strcmp(level, 'random')
    color = 'b';
    a = -140 -5*rand; %uniform random value btw 140 and 145
    b = 38.75 + (53.23-38.75) * rand;
    c = -0.720 + (-0.337+0.720) * rand;
end

SampleNum = floor((f_high-f_low)/freq_gap);
tmp_f = f_low * 10^(-6);
freq = zeros(1,SampleNum);
BG_Noise = zeros(1,SampleNum);
for i=1:SampleNum
    freq(i) = tmp_f;
	BG_Noise(i) = a + b * abs (tmp_f)^(c);            %background noise calculation based on [Esmailian03]
    tmp_f = tmp_f + freq_gap * 10^(-6);
end

%plot the Figure
% plot(freq,BG_Noise,color);
% %saveas(gcf,'background_noise.fig');
% %saveas(gcf,'background_noise.eps');
% xlim([f_low * 10 ^(-6),f_high  * 10 ^(-6)]);
% xlabel('frequency (MHz)');
% ylabel('PSD (dBm/Hz)');
% legend(level);
end


