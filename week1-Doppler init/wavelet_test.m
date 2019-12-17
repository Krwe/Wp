clc
clear
close all


%% 信号产生
Fs=1e8;	% 采样频率（AD采样率为100MHZ)
Fcode=5e6;% 5Mhz
dataN=32;   %数据的长度
r=Fs/Fcode;	% 过采样率
EbN0=5;	% 带内信噪比（高信噪比下）

%% 解调
% Create a GMSK modulator, an AWGN channel, and a GMSK demodulator. Use a phase offset of pi/4.
hMod = comm.GMSKModulator('BitInput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
hAWGN = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Eb/No)','EbNo',EbN0);
hDemod = comm.GMSKDemodulator('BitOutput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
d1=0;
d2=0;
parfor ci=1:200000
    hError = comm.ErrorRate('ReceiveDelay', hDemod.TracebackDepth);

    data=(randsrc(dataN,1)+1)/2; % 随机生成传输符号304个bit
    modSignal = step(hMod, data);
    ff1=5e3;
    modSignal=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');
    noisySignal = step(hAWGN, modSignal);
    receivedData = step(hDemod, noisySignal);
    errorStats = step(hError, data, receivedData);
    d1=errorStats(1)+d1;
    d2=errorStats(2)+d2;
end

