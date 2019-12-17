function fc=root_music_f(modSignal)  %#ok<*FNDEF>
un=modSignal.^2;
N=length(un);

M=20;%����ؾ������
xs = zeros(M , N - M);
for k = 1 : N - M
    xs(:,k) = un(k + M - 1 : -1 : k).';%������������
end
R = xs * xs'/(N - M);%����ؾ���
[U E]=svd(R);%E�Խ�Ԫ����������ֵ
G=U(:,4:M);
Gr=G*G';
co=zeros(2*M-1,1);
for m=1:M
    co(m:m+M-1)=co(m:m+M-1)+Gr(M:-1:1,m);
end
z=roots(co);
ph=angle(z)/(2*pi);
err=abs(abs(z)-1);
tmp=sort(err);
index1=find(err==tmp(1));
index2=find(err==tmp(3));
f_1 = angle(z(index1)) / (2 * pi);
f_2 = angle(z(index2)) / (2 * pi);
fc=(f_1+f_2)/2;

