function phi_reg=my_unwrap(modSignal)


figure,
subplot(2,1,1),plot((atan(real(modSignal)./imag(modSignal)))/pi*2,'o');title('unwrap前相位');
xlabel('time(10ns)');
ylabel('rad(pi)');

phi=atan(real(modSignal)./imag(modSignal));

phi_reg=[phi(1)];
reg=0;
for ii=2:length(phi)
    if(phi(ii-1)-phi(ii)>pi*0.3)
        reg=reg+pi;
    elseif(-phi(ii-1)+phi(ii)>pi*0.3)
        reg=reg-pi;
    end
    phi_reg=[phi_reg,phi(ii)+reg];
end

subplot(2,1,2),plot((phi_reg-phi_reg(1))/pi*2,'o');
title('unwrap后相位');
xlabel('time(10ns)');
ylabel('rad(pi)');