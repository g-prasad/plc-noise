function [ GB_N, freq ] = GBN(level,building_Type,freq_gap)

% Computes the summation of "colored background noise" and "narrowband noise".
% Inputs:
% level:              'worst' or 'best' or 'random' ('random' is something between worst case and best case)
% freq_gap:           frequency resolution (Hz) (24000 Hz for example)
% Building_Type: 'office' or 'residential'

% Output:
% GB_N:          General Background Noise = the Background + Narrowband noise PSD value (dBm)
% freq:          the frequency array used in x axis (MHz)

%   References:
%   [Hrasnica04] Hrasnica, Halid, Abdelfatteh Haidine, and Ralf Lehnert. Broadband powerline communications: network design. John Wiley & Sons, 2005.
%   [Beny03] Benyoucef, Dirk. "A new statistical model of the noise power density spectrum for powerline communication." In Proceedings of the 7th International Symposium on Power-Line Communications and its Applications, Kyoto, Japan, pp. 136-141. 2003.
%   [Esmailian03] Esmailian, Tooraj, Frank R. Kschischang, and P. Glenn Gulak. "In building power lines as high?speed communication channels: channel characterization and a test channel ensemble." International Journal of Communication Systems 16, no. 5 (2003): 381-400.

[BB_Noise, freq] = Colored_Background_Noise(level,freq_gap);
[NN_Noise, freq1] = NarrowBand_Noise(freq_gap,building_Type);
min_length = min(length(BB_Noise),length(NN_Noise));

GB_N = BB_Noise(1:min_length);%+NN_Noise(1:min_length);      %General Background Noise
% figure(1);
% plot(freq(1:min_length),GB_N);
% xlim([2,30]);
% %saveas(gcf,'GBN.fig');
% xlabel('frequency (MHz)');
% ylabel('PSD (dBm/Hz)');
end
