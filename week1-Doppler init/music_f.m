function fc=music_f(modSignal)

un=modSignal.^2-mean(modSignal.^2);
N=length(un);
M=16;%自相关矩阵阶数
xs = zeros(M , N - M);
for k = 1 : N - M
    xs(:,k) = un(k + M - 1 : -1 : k).';%构造样本矩阵
end
R = xs * xs'/(N - M);%自相关矩阵
[U E]=svd(R);%E对角元素上是特征值
%  2
N1=2;%信号源个数估计
En=U( :,N1+1: M);
NF=102400;
for n=1:NF
    Aq=exp(-1i*2*pi*(n-1)/NF*(0 :M-1)');
    Pmusic(n)=1/(Aq'*En*En'*Aq);%music谱
end
 %归一化
omiga=linspace(-0.5,0.5,NF);
Pmusic = 10 * log10(Pmusic);
Pmusic_right = [Pmusic(end-NF/2+1:end) Pmusic(1:end-NF/2)];
Pmusic_right_2=Pmusic_right;

%
figure,

h1=plot( omiga , Pmusic_right_2,'k-');
xlabel('\omega/2\pi');
ylabel('伪谱/dB');


xx=omiga;
yy=abs(Pmusic_right_2);
point=[];
for ii=2:length(xx)-1
    if(yy(ii)>yy(ii-1)&&yy(ii)>yy(ii+1))
        point=[point,yy(ii)];
    end
end
point=sort(point,'descend');
fc=abs(xx(find(yy==point(1)))+xx(find(yy==point(2))))/2;
