function fc=music_f(modSignal)

un=modSignal.^2-mean(modSignal.^2);
N=length(un);
M=16;%����ؾ������
xs = zeros(M , N - M);
for k = 1 : N - M
    xs(:,k) = un(k + M - 1 : -1 : k).';%������������
end
R = xs * xs'/(N - M);%����ؾ���
[U E]=svd(R);%E�Խ�Ԫ����������ֵ
%  2
N1=2;%�ź�Դ��������
En=U( :,N1+1: M);
NF=102400;
for n=1:NF
    Aq=exp(-1i*2*pi*(n-1)/NF*(0 :M-1)');
    Pmusic(n)=1/(Aq'*En*En'*Aq);%music��
end
 %��һ��
omiga=linspace(-0.5,0.5,NF);
Pmusic = 10 * log10(Pmusic);
Pmusic_right = [Pmusic(end-NF/2+1:end) Pmusic(1:end-NF/2)];
Pmusic_right_2=Pmusic_right;

%
figure,

h1=plot( omiga , Pmusic_right_2,'k-');
xlabel('\omega/2\pi');
ylabel('α��/dB');


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
