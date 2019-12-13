clear all
close all
clc
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

%Load data
weighting_factor=xlsread('Training_results','THD_varying_weight','A5:A13');
%train_error=xlsread('neuron_changes','neuron_change','L3:L47');
THD=xlsread('Training_results','THD_varying_weight','B5:B13');
%test_error=xlsread('neuron_changes','neuron_change','K3:K47');

%%
close all

% ft = fittype('a*log(abs(b*x))');
% y_exp=fit(neurons,THD,ft) 


fig=figure(1)
plot(weighting_factor,THD, 'Color',[0, 0.4470, 0.7410], 'LineWidth',1)
%hold on
%plot(neurons,test_error, 'Color',[0.8500, 0.3250, 0.0980], 'LineWidth',1)
%hold on
%plot(neurons,THD, 'Color',[0, 0.4470, 0.7410], 'LineWidth',1)

%xlim([1 400])
%ylim([0 30])

title('Relationship between THD and weighting factor','fontweight','bold','fontsize',13);

%legend('Train error','Test error','THD','location','best');

xlabel('Weighting factor $\lambda$','fontsize',11)
ylabel('THD $[\%]$','fontsize',11)%[deg]
grid





%hold on
%plot([0:0.01:30],y_exp([0:0.01:30]), 'Color',[0.3010, 0.7450, 0.9330], 'LineWidth',1)

%dark blue [0, 0.4470, 0.7410]
%light blue [0.3010, 0.7450, 0.9330]
%orange [0.8500, 0.3250, 0.0980]
%yellow [0.9290, 0.6940, 0.1250]
%%
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)])
print(fig,'Test_accuracy_vs_neurons_detail','-dpdf','-fillpage') %save figure in pdf