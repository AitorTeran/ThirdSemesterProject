clear all
close all
clc
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');


%%
Ts = 20e-6;
Vm = 325;
w = 2*pi*50;
phase_offset = 1.51;
v_ref_old2 = Vm*sin(w*9*Ts+phase_offset);
v_ref_old = Vm*sin(w*10*Ts+phase_offset);
v_ref = Vm*sin(w*11*Ts+phase_offset);
v_ref1= 3*v_ref - 3*v_ref_old +v_ref_old2;
v_ref2 = 6*v_ref - 8*v_ref_old + 3*v_ref_old2;

fig = figure(1);
hold on
plot([9*Ts 10*Ts 11*Ts], [v_ref_old2 v_ref_old v_ref], 'o', 'color', [0, 0.4470, 0.7410])
plot([12*Ts 13*Ts], [v_ref1 v_ref2],'o' , 'color', [0.3010, 0.7450, 0.9330])
plot(0.8*9*Ts:Ts/100:13*Ts*1.1, Vm*sin(w*(0.8*9*Ts:Ts/100:13*Ts*1.1)+phase_offset), 'color', [0.8500, 0.3250, 0.0980])
grid on
legend('Known values','Predicted values','Sinusoidal')
xlabel('Time [s]')
ylabel('Voltage [V]')
%dark blue [0, 0.4470, 0.7410]
%light blue [0.3010, 0.7450, 0.9330]
%orange [0.8500, 0.3250, 0.0980]
%yellow [0.9290, 0.6940, 0.1250]
%%
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)])
print(fig,'Lagrange_polynomials','-dpdf','-fillpage') %save figure in pdf