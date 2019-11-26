clear all
close all
clc
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

%Load data
weight=xlsread('Training_results','THD_varying_weight','A5:A13');
THD=xlsread('Training_results','THD_varying_weight','B5:B13');

%%
fig=figure(1)
plot(weight,THD*100, 'Color',[0, 0.4470, 0.7410], 'LineWidth',1)

title('Relationship between THD and weighting factor','fontweight','bold','fontsize',13);

%legend('LPF 1st order','Discrete LPF 1st order','LPF 2nd order','Discrete LPF 2nd order','location','best');
%xlim([10 5000*2*pi])
%ylim([-180 10])

xlabel('Weighting factor','fontsize',11)
ylabel('THD [\%]','fontsize',11)%[deg]
grid


pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)])
print(fig,'Weight_factor_vs_THD','-dpdf','-r0') %save figure in pdf