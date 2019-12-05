clear all
close all
clc
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');


%%
x = -10:0.01:10;
sigmoid = 1./(1+exp(-x));
tangent = tanh(x);
relu = max(0,x);

fig = figure(2);
hold on
plot(x,relu, 'color', [0, 0.4470, 0.7410])
grid on
xlabel('x')
ylabel('ReLU(x)','Interpreter','latex')
ylim([-2 12])
%dark blue [0, 0.4470, 0.7410]
%light blue [0.3010, 0.7450, 0.9330]
%orange [0.8500, 0.3250, 0.0980]
%yellow [0.9290, 0.6940, 0.1250]
%%
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)])
print(fig,'Lagrange_polynomials','-dpdf','-fillpage') %save figure in pdf