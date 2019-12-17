clc
clear
close all
%%

Fs=1e8;	% 采样频率（AD采样率为100MHZ）
data=32;   %数据的长度

r=20;	% 过采样率
bitData=(randsrc(data,1)+1)/2; % 随机生成传输符号304个bit
hMod = comm.GMSKModulator('BitInput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
modSignal = step(hMod, bitData);

EbN0=12;	% 带内信噪比（高信噪比下）
SNR=EbN0-10*log10(r);	% 信噪比
noise=sqrt(1/10^(SNR/10)/2)*(randn(size(modSignal))+1i*randn(size(modSignal)));	% 产生高斯白噪声

%%

ff1=1e4;
modSignal1=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');
for EbN0=1:100%2;	% 带内信噪比（高信噪比下）
    SNR=EbN0-10*log10(r);	% 信噪比
    noise=sqrt(1/10^(SNR/10)/2)*(randn(size(modSignal))+1i*randn(size(modSignal)));	% 产生高斯白噪声
    
    
    figure,plot(real(modSignal),imag(modSignal),'bo');
    hold on;plot(real(modSignal1),imag(modSignal1),'ro');
    hold on;plot(real(modSignal+noise),imag(modSignal+noise),'ko');
    title(num2str(EbN0));
    pause(0.05);
end



