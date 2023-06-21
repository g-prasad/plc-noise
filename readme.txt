CUMULATIVE POWER LINE NOISE
By Gautham Prasad, Jahidur Rahman, Hao Ma, Fariba Aalamifar
The University of British Columbia, Vancouver, British Columbia

This document contains details of each of the function

	a. PLC_noise.m - This is the main file that accumulates the following types of noise-
		i. Colored background noise
		ii. Narrowband noise
		iii. Periodic synchronous impulse noise
		iv. Periodic asynchronous impulse noise
		v. Aperiodic impulse noise
	   This file is written as a function that can be called in your custom transceiver script. Once you introduce the power line channel to your transmitted signal, call this function to add power line noise.
	   This file can also be run as a stand-alone script to examine noise.
	   This file provides you with three different options to choose the noise conditions:
		i. Best - lowest practically possible in-home power line noise level
		ii. Worst - highest practically possible power line noise level
		iii. Random - a noise level somewhere between the ’Best’ and ‘Worst’ conditions
	   Additionally, you can edit individual noise files for more options.

	   %%% INPUT
	   % level - output noise level required
	   %       'best' - lowest noise possible in an in-home scenario
	   %       'worst' - highest noise possible in an in-home scenario
	   %       'rand' - a noise level somewhere randomly in between the 'best' and 'worst' conditions

	   %%% OUTPUT
	   % noise_time - time domain noise samples in one mains cycle

	   %%% EXAMPLE
	   % total_noise   = PLC_noise('worst') --- gives you the time domain noise samples under a worst-case network condition (high noise)
	   % total_noise   = PLC_noise          --- gives you the time domain noise samples under a random network condition 
	   % total_noise   = PLC_noise('best')  --- gives you the time domain noise samples under a best-case network condition (low noise)

	   % REFERENCES
	   % [1] Latchman, Haniph A., et al. Homeplug AV and IEEE 1901: A Handbook for PLC Designers and Users. John Wiley & Sons, 2013.
	
	b. prasad_sync.m - Periodic synchronous impulse noise
	   %%% INPUTS
	   % f_samp                    = sampling frequency used in the transceiver system [DEFAULT: 75MHz]
	   % str                       = Choose noise conditions [DEFAULT: 'rand']
	   % num_cyc                   = number of mains cycles of impulse noise required [DEFAULT: 1]
	   % N_FFT                     = FFT Size [Default: 3072]

 	   %%% OUTPUT
	   % p_noise_sync_fin_conc     = generated periodic synchronous noise samples for one mains cycle 

	   %%% REFERENCES
	   % [1] Çelebi, Hasan Basri. Noise and multipath characteristics of power line communication channels. Diss. University of South Florida, 2010.
	   % [2] Cortés, José Antonio, et al. "Analysis of the indoor broadband power-line noise scenario." Electromagnetic Compatibility, IEEE Transactions on 52.4 (2010): 849-858.
	   % [3] IEEE Standards Association. "IEEE Standard for Broadband over Power Line Networks: Medium Access Control and Physical Layer Specifications." IEEE Std 1901 2010 (2010): 1-1586.

	c. prasad_async.m - Periodic asynchronous impulse noise
	   %%% INPUTS
	   % f_samp                    = sampling frequency used in the transceiver system [DEFAULT: 75MHz] 
	   % str                       = Choose noise conditions [DEFAULT: 'rand']
	   % num_cyc                   = number of mains cycles of impulse noise required [DEFAULT: 1]
	   % N_FFT                     = FFT Size [Default: 3072]

	   %%% OUTPUT
	   % p_noise_async_fin         = generated periodic asynchronous noise samples for 'num_cyc' number of mains cycles

	   %%% REFERENCES
	   % [1] Çelebi, Hasan Basri. Noise and multipath characteristics of power line communication channels. Diss. University of South Florida, 2010.
	   % [2] Cortés, José Antonio, et al. "Analysis of the indoor broadband power-line noise scenario." Electromagnetic Compatibility, IEEE Transactions on 52.4 (2010): 849-858.
	   % [3] IEEE Standards Association. "IEEE Standard for Broadband over Power Line Networks: Medium Access Control and Physical Layer Specifications." IEEE Std 1901 2010 (2010): 1-1586.

	d. AperiodicImpulseNoise.m - Aperiodic Impulse noise
	   %%% INPUTS
	   % f_samp                    = sampling frequency used in the transceiver system
	   % str                       = Choose noise conditions

	   %%% OUTPUT
	   % p_noise_sync_fin          = generated aperiodic impulse noise samples for one mains cycle 

	   %%% REFERENCES
	   % [1] Çelebi, Hasan Basri. Noise and multipath characteristics of power line communication channels. Diss. University of South Florida, 2010.
	   % [2] Cortés, José Antonio, et al. "Analysis of the indoor broadband power-line noise scenario." Electromagnetic Compatibility, IEEE Transactions on 52.4 (2010): 849-858.
	   % [3] IEEE Standards Association. "IEEE Standard for Broadband over Power Line Networks: Medium Access Control and Physical Layer Specifications." IEEE Std 1901 2010 (2010): 1-1586.
 
	e. GBN.m - Generalized background noise
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




