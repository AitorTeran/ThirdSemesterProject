clear all
close all
clc
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

%Load data
neurons=xlsread('neuron_changes','neuron_change','G3:G47');
train_error=xlsread('neuron_changes','neuron_change','L3:L47');
test_error=xlsread('neuron_changes','neuron_change','M3:M47');
THD=xlsread('neuron_changes','neuron_change','K3:K47');

%%
close all

% ft = fittype('a*log(abs(b*x))');
% y_exp=fit(neurons,THD,ft) 


fig=figure(1)
plot(neurons,test_error, 'Color',[0.9290, 0.6940, 0.1250], 'LineWidth',1)
hold on
plot(neurons,train_error, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth',1)
hold on
plot(neurons,THD, 'Color',[0, 0.4470, 0.7410], 'LineWidth',1)

hold on
rectangle('Position',[5 0.4 20 9.6],'Curvature',[0.4,0.1],'LineWidth',1)

xlim([1 300])
ylim([0 30])

title('Relationship between train error, test error and THD vs number of neurons','fontweight','bold','fontsize',13);


xlabel('Number of neurons in the intermediate layer','fontsize',11)
ylabel('Train error [\%], test error [\%], THD [\%]','fontsize',11)%[deg]
grid


p = get(gca, 'Position');
h = axes('Parent', gcf, 'Position', [p(1)+0.2 p(2)+.3 p(1)+0.42 p(2)+0.38]);
plot(neurons,test_error, 'Color',[0.9290, 0.6940, 0.1250], 'LineWidth',1)
hold on
plot(neurons,train_error, 'Color',[0.8500, 0.3250, 0.0980], 'LineWidth',1)
hold on
plot(neurons,THD, 'Color',[0, 0.4470, 0.7410], 'LineWidth',1)

xlim([5 25])
ylim([0 10])
grid on
grid minor

legend('Test error','Train error','THD','location','best');


%hold on
%plot([0:0.01:30],y_exp([0:0.01:30]), 'Color',[0.3010, 0.7450, 0.9330], 'LineWidth',1)

%dark blue [0, 0.4470, 0.7410]
%light blue [0.3010, 0.7450, 0.9330]
%orange [0.8500, 0.3250, 0.0980]
%yellow [0.9290, 0.6940, 0.1250]
%%
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)])
print(fig,'Test_accuracy_vs_neurons_detail','-dpdf','-fillpage') %save figure in pdf