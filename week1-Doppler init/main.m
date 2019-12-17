clc
clear
close all
%% �źŲ���
Fs=1e8;	% ����Ƶ�ʣ�AD������Ϊ100MHZ)
Fcode=5e6;% 5Mhz
dataN=32;   %���ݵĳ���
r=Fs/Fcode;	% ��������
EbN0=50;	% ��������ȣ���������£�

%% ���
% Create a GMSK modulator, an AWGN channel, and a GMSK demodulator. Use a phase offset of pi/4.
hMod = comm.GMSKModulator('BitInput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
hAWGN = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Eb/No)','EbNo',EbN0);
hDemod = comm.GMSKDemodulator('BitOutput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
hError = comm.ErrorRate('ReceiveDelay', hDemod.TracebackDepth);



%% 0.	�о�������Ƶ�ƶԵз����ܵ�Ӱ��
data=(randsrc(dataN,1)+1)/2; % ������ɴ������304��bit
modSignal = step(hMod, data);
phi_reg=my_unwrap(modSignal);
ff1=5e3;
modSignal1=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');
phi_reg2=my_unwrap(modSignal1);
close all
plot(phi_reg,'b');
hold on,plot(phi_reg2,'r');
xlabel('time(10ns)');
ylabel('phi(pi)');
title('phi');
legend('ԭʼ�ź�','������Ƶ���ź�');

noisySignal = step(hAWGN, modSignal1);
receivedData = step(hDemod, noisySignal);
errorStats = step(hError, data, receivedData);

close all
%% 1.	FFT��������Ƶ�ʣ���Ƶ��

square_x=fftshift(abs(fft(modSignal1.^2-mean(modSignal1.^2))));
figure,plot(linspace(-Fs,Fs,length(modSignal1)),square_x);
xlabel('f(Hz)');
ylabel('|Y|^2');
close all
%% 2.musicӦ����ƽ���ײ���Ƶ
x=music_f(noisySignal)*1e8;
close all
%% 3.��λ�����Ƶ

n=3;
L=length(modSignal1)-n;

xx=linspace(-Fs,Fs,L);
x=modSignal1(1:L);
fft_tmp=fftshift(fft(x.^2-mean(x.^2)));
square_x=abs(fft_tmp);
figure,plot(linspace(-Fs,Fs,length(fft_tmp)),square_x);
tmp=sort(square_x,'descend');
f1_index=find(square_x==tmp(1));
f2_index=find(square_x==tmp(2));

fcc=(xx(f1_index)+xx(f2_index))*1e0;
phi1_0=angle(fft_tmp(f1_index));
phi2_0=angle(fft_tmp(f2_index));

% t
x=modSignal1(n:L+n-1);
fft_tmp=fftshift(fft(x.^2-mean(x.^2)));
square_x=abs(fft_tmp);
figure,plot(linspace(-Fs,Fs,length(fft_tmp)),square_x);
phi1_t=angle(fft_tmp(f1_index));
phi2_t=angle(fft_tmp(f2_index));


% ����
f1=(phi1_t-phi1_0+(-8:0.25:8)*pi)/(2*pi*(n-1)/1e8);
x=abs(abs(f1)-2.5e6);
tmp=sort(x);
f1=f1(find(x==tmp(1)));
f2=(phi2_t-phi2_0+(-8:0.25:8)*pi)/(2*pi*(n-1)/1e8);
x=abs(abs(f2)-2.5e6);
tmp=sort(x);
f2=f2(find(x==tmp(1)));
abs(abs(f1)-abs(f2))/2;
close all
%% 4)ƥ���˲���Ƶ
data=(randsrc(dataN,1)+1)/2; % ������ɴ������304��bit
modSignal = step(hMod, data);
ff1=5e3;
modSignal1=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');
EbN0=5;
hAWGN = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Eb/No)','EbNo',EbN0);
modSignal1 = step(hAWGN, modSignal1);
I=real(modSignal1);
Q=imag(modSignal1);
delt_f=0:100:6e3;
res=[];
for f=delt_f
    tmp=modSignal.*exp(1i*2*pi*f/Fs*(1:length(modSignal)).');
    I1=real(tmp);
    Q1=imag(tmp);
    res=[res,I'*I1+Q'*Q1];
end
plot(delt_f,res);
index=find(res==max(res));hold on;
plot(delt_f(index),res(index),'ro');
xlabel('delt f(Hz)');
ylabel('��϶�');
title('5KHz�Ķ�����Ƶ��');

%% ��Ϸ�
f=969:3:1206;




