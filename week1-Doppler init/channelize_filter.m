clc
clear
close all

%% 信号产生
Fs=1e8;	% 采样频率（AD采样率为100MHZ）
data=32;   %数据的长度

r=20;	% 过采样率
bitData=(randsrc(data,1)+1)/2; % 随机生成传输符号304个bit
hMod = comm.GMSKModulator('BitInput', true,'SamplesPerSymbol',r,'BandwidthTimeProduct',0.5);
modSignal = step(hMod, bitData);


EbN0=12;	% 带内信噪比（高信噪比下）
SNR=EbN0-10*log10(r);	% 信噪比
noise=sqrt(1/10^(SNR/10)/2)*(randn(size(modSignal))+1i*randn(size(modSignal)));	% 产生高斯白噪声



%% 原始信号
phi_reg1=my_unwrap(modSignal);title('原始信号');
%figure,plot(linspace(-Fs,Fs,length(modSignal)),fftshift(abs(fft(modSignal.^2-mean(modSignal.^2)))));
% figure,cwt(phi_reg1,'bump',Fs);
% figure,cwt(noise,'bump',Fs);
figure,cwt(modSignal,'bump',Fs);
figure,cwt(modSignal+noise,'bump',Fs);
% 
% 
figure,cwt(low_pass(modSignal+noise),'bump',Fs);
%% 频偏

ff1=1e3;
modSignal1=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');

% phi_reg2=my_unwrap(modSignal1);title('频偏');
% (phi_reg2(end)-phi_reg1(end))*pi/2/(length(modSignal)/Fs)/ff1;
% 
% plot(phi_reg2(1:end-1)-phi_reg2(2:end),'o');
% figure,plot(phi_reg2-phi_reg1,'o')
%% 噪声
modSignal1=modSignal+noise;
phi_reg3=my_unwrap(modSignal1);title('噪声');
%figure,plot(linspace(-Fs,Fs,length(modSignal)),fftshift(abs(fft(modSignal1.^2-mean(modSignal1.^2)))));


%% 滤波之后
modSignal2 = low_pass(modSignal1);


%figure,plot(linspace(-Fs,Fs,length(modSignal)),fftshift(abs(fft(modSignal2.^2-mean(modSignal2.^2)))));
phi_reg3=my_unwrap(modSignal2);title('滤波之后');
%figure,plot(real(modSignal2))
%plot(phi_reg3(1:end-1)-phi_reg3(2:end),'o');
% figure,plot(real(modSignal))



%% 频域相位差分测频
% close all
% ff1=1e5;
% modSignal_1=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');
% 
% 
% square_x=fftshift(abs(fft(modSignal_1.^2-mean(modSignal_1.^2))));
% figure,plot(linspace(-Fs,Fs,length(modSignal_1)),square_x);
% 
% n=5;
% L=length(modSignal)-n;
% 
% xx=linspace(-Fs,Fs,L);
% % 0
% x=modSignal_1(1:L);
% fft_tmp=fftshift(fft(x.^2-mean(x.^2)));
% square_x=abs(fft_tmp);
% figure,plot(linspace(-Fs,Fs,length(fft_tmp)),square_x);
% tmp=sort(square_x,'descend');
% f1_index=find(square_x==tmp(1));
% f2_index=find(square_x==tmp(2));
% 
% fcc=(xx(f1_index)+xx(f2_index))*1e0
% phi1_0=angle(fft_tmp(f1_index));
% phi2_0=angle(fft_tmp(f2_index));
% 
% % t
% x=modSignal_1(n:L+n-1);
% fft_tmp=fftshift(fft(x.^2-mean(x.^2)));
% square_x=abs(fft_tmp);
% figure,plot(linspace(-Fs,Fs,length(fft_tmp)),square_x);
% phi1_t=angle(fft_tmp(f1_index));
% phi2_t=angle(fft_tmp(f2_index));
% 
% 
% % 计算
%  f1=(phi1_t-phi1_0)/2/pi/(n-1)/4*1e8
%  f2=(phi2_t-phi2_0)/2/pi/(n-1)/4*1e8
              
% figure,
% plot((atan(real(modSignal1)./imag(modSignal1))),'o');
% figure,
% plot(unwrap(atan(real(modSignal1)./imag(modSignal1)),pi*0.9),'o');
% figure,
% plot(atan(real(modSignal2)./imag(modSignal2))/pi);
% figure,
% plot(atan(real(modSignal3)./imag(modSignal3))/pi);
%%
% 
% F0=music_f(modSignal)
% % F0=root_music_f(modSignal);
% x=modSignal;
% xx=linspace(-0.5,0.5,length(x));
% yy=fftshift(abs(fft(x.^2-mean(x.^2))));
% 
% 
% tmp=sort(yy,'descend');
% index1=find(yy==tmp(1));
% index2=find(yy==tmp(2));
% f_1 = xx(index1);
% f_2 = xx(index2);
% F1=(f_1+f_2)/2
% figure,plot(xx,yy);
% %  f=esprit_f(modSignal)
% % for ii=0:9
% %     ff1=ii*10^7*0.5;
% %     x=modSignal.*exp(1i*2*pi*ff1/Fs*(1:length(modSignal)).');
% %     figure,plot(linspace(-Fs,Fs,length(x)),fftshift(abs(fft(x.^2-mean(x.^2)))));title(num2str(0.5*ii));
% % end