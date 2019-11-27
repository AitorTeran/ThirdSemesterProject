clear all
close all
clc
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

%Load data
neurons=xlsread('Training_results2','neuron_change','A2:A33');
accuracy=xlsread('Training_results2','neuron_change','D2:D33');

%%
ft = fittype('a*log(abs(b*x))');
y_exp=fit(neurons,accuracy,ft) 


fig=figure(1)
plot(neurons,accuracy, 'Color',[0, 0.4470, 0.7410], 'LineWidth',1)

title('Relationship between test accuracy and number of neurons','fontweight','bold','fontsize',13);

%legend('LPF 1st order','Discrete LPF 1st order','LPF 2nd order','Discrete LPF 2nd order','location','best');
%xlim([10 5000*2*pi])
%ylim([-180 10])

xlabel('Number of neurons in the intermediate layer','fontsize',11)
ylabel('Test accuracy [\%]','fontsize',11)%[deg]
grid

hold on
plot([0:0.01:30],y_exp([0:0.01:30]), 'Color',[0.3010, 0.7450, 0.9330], 'LineWidth',1)

%dark blue [0, 0.4470, 0.7410]
%light blue [0.3010, 0.7450, 0.9330]
%orange [0.8500, 0.3250, 0.0980]
%yellow [0.9290, 0.6940, 0.1250]
%%
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)])
print(fig,'Test_accuracy_vs_neurons','-dpdf','-fillpage') %save figure in pdf