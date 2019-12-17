clc
clear
close all


%% �źŲ���
Fs=1e8;	% ����Ƶ�ʣ�AD������Ϊ100MHZ)
Fcode=5e6;% 5Mhz
dataN=32;   %���ݵĳ���
r=Fs/Fcode;	% ��������
EbN0=5;	% ��������ȣ���������£�

%% ���
% Create a GMSK modulator, an AWGN channel, and a GMSK demodulator. Use a phase offset of pi/4.
hMod = comm.GMSKModulator('BitInput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
hAWGN = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Eb/No)','EbNo',EbN0);
hDemod = comm.GMSKDemodulator('BitOutput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
d1=0;
d2=0;
parfor ci=1:200000
    hError = comm.ErrorRate('ReceiveDelay', hDemod.TracebackDepth);

    data=(randsrc(dataN,1)+1)/2; % ������ɴ������304��bit
    modSignal = step(hMod, data);
    ff1=5e3;
    modSignal=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');
    noisySignal = step(hAWGN, modSignal);
    receivedData = step(hDemod, noisySignal);
    errorStats = step(hError, data, receivedData);
    d1=errorStats(1)+d1;
    d2=errorStats(2)+d2;
end

