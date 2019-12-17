clc
clear
close all
%%

Fs=1e8;	% ����Ƶ�ʣ�AD������Ϊ100MHZ��
data=32;   %���ݵĳ���

r=20;	% ��������
bitData=(randsrc(data,1)+1)/2; % ������ɴ������304��bit
hMod = comm.GMSKModulator('BitInput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
modSignal = step(hMod, bitData);

EbN0=12;	% ��������ȣ���������£�
SNR=EbN0-10*log10(r);	% �����
noise=sqrt(1/10^(SNR/10)/2)*(randn(size(modSignal))+1i*randn(size(modSignal)));	% ������˹������

%%

ff1=1e4;
modSignal1=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');
for EbN0=1:100%2;	% ��������ȣ���������£�
    SNR=EbN0-10*log10(r);	% �����
    noise=sqrt(1/10^(SNR/10)/2)*(randn(size(modSignal))+1i*randn(size(modSignal)));	% ������˹������
    
    
    figure,plot(real(modSignal),imag(modSignal),'bo');
    hold on;plot(real(modSignal1),imag(modSignal1),'ro');
    hold on;plot(real(modSignal+noise),imag(modSignal+noise),'ko');
    title(num2str(EbN0));
    pause(0.05);
end



