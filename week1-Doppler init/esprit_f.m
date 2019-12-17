function kk=esprit_f(modSignal)  %#ok<*FNDEF>
un=modSignal.^2;
N=length(un);
M=8;%自相关矩阵阶数
xs = zeros(M , N - M);
for k = 1 : N - M
    xs(:,k) = un(k + M - 1 : -1 : k).';
end
Rxx = xs( : , 1 : end - 1) * xs( : , 1 : end - 1)' / (N - M - 1);
Rxy = xs( : , 1 : end - 1) * xs( : , 2 : end)' / (N - M - 1);
%寻找最小特征值
[U , E] = svd(Rxx);
ev = diag(E);
emin = ev(end);
Z = [zeros(M - 1 , 1) , eye(M - 1) ; 0 , zeros(1 , M - 1)];
Cxx = Rxx - emin * eye(M);
Cxy = Rxy - emin * Z;
[U , E] = eig(Cxx , Cxy);
z = diag(E);
ph = angle(z) / (2 * pi);
err = abs(abs(z) - 1);

tmp=sort(err);

kk=[];
ok=1;
for ii=1:length(err)
    index=find(err==tmp(ii));
    f_ = angle(z(index)) / (2 * pi);
    if f_<0
        continue;
    end
    if isempty(kk)==1
        kk=[f_];
        continue
    end
    if length(kk)<2 & isempty(find((kk-f_)<0.01))==1
        kk=[kk,f_];
    end
    if length(kk)==2
        break
    end
end

