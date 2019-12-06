% Normalized voltage
t = 0:1/20000:1;
Va = 1.15*cos(100*pi*t);
Vb = 1.15*cos(100*pi*t+2*pi/3);
Vc = 1.15*cos(100*pi*t-2*pi/3);

for i = 1:length(Va)
    vsrt = sort([Va(i) Vb(i) Vc(i)]);
    vmax(i) = vsrt(1);
    vmid(i) = vsrt(2);
    vmin(i) = vsrt(3);
end    
figure
subplot(2,1,1)
set(gca, 'FontName', 'Times New Roman')
set(gca,'FontSize',12)
grid on
hold on
plot(t(1:500)*1000,Va(1:500),'--','LineWidth',2)
plot(t(1:500)*1000,Vb(1:500),'-.','LineWidth',2)
plot(t(1:500)*1000,Vc(1:500),':','LineWidth',2)
plot(t(1:500)*1000,vmid(1:500),'LineWidth',2)
plot(t(1:500)*1000,vmid(1:500)*0.5,'LineWidth',2)
legend('$v^*_a$','$v^*_b$','$v^*_c$','$v_{mid}$','$v_{zs}$','Interpreter','latex','FontSize',12)

subplot(2,1,2)
set(gca, 'FontName', 'Times New Roman')
set(gca,'FontSize',12)
grid on
hold on
plot(t(1:500)*1000,Va(1:500)+vmid(1:500)*0.5,'--','LineWidth',2)
plot(t(1:500)*1000,Vb(1:500)+vmid(1:500)*0.5,'-.','LineWidth',2)
plot(t(1:500)*1000,Vc(1:500)+vmid(1:500)*0.5,':','LineWidth',2)
xlabel('Time (ms)')
legend('$v^{**}_a$','$v^{**}_b$','$v^{**}_c$','Interpreter','latex','FontSize',12)

%% SVM
k = 30000;
t = 1/k:1/k:0.02;

va(1:length(t)/6) = 2/3;
va(length(t)/6+1:2*length(t)/6) = 1/3;
va(2*length(t)/6+1:3*length(t)/6) = -1/3;
va(3*length(t)/6+1:4*length(t)/6) = -2/3;
va(4*length(t)/6+1:5*length(t)/6) = -1/3;
va(5*length(t)/6+1:6*length(t)/6) = 1/3;

vb(1:length(t)/6) = -1/3;
vb(length(t)/6+1:2*length(t)/6) = 1/3;
vb(2*length(t)/6+1:3*length(t)/6) = 2/3;
vb(3*length(t)/6+1:4*length(t)/6) = 1/3;
vb(4*length(t)/6+1:5*length(t)/6) = -1/3;
vb(5*length(t)/6+1:6*length(t)/6) = -2/3;

vc(1:length(t)/6) = -1/3;
vc(length(t)/6+1:2*length(t)/6) = -2/3;
vc(2*length(t)/6+1:3*length(t)/6) = -1/3;
vc(3*length(t)/6+1:4*length(t)/6) = 1/3;
vc(4*length(t)/6+1:5*length(t)/6) = 2/3;
vc(5*length(t)/6+1:6*length(t)/6) = 1/3;

figure
set(gca, 'FontName', 'Times New Roman')
set(gca,'FontSize',12)
grid on
hold on
plot(t*1000,va,'--','LineWidth',2)
plot(t*1000,vb,'-.','LineWidth',2)
plot(t*1000,vc,':','LineWidth',2)
xlabel('Time (ms)')
ylabel('Normalized voltage')
legend('V_{AN}','V_{BN}','V_{CN}')