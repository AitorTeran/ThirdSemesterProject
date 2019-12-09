clear all
close all
clc
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

%%
experimental = readmatrix('step1_Steady60_THD_tek0000.csv');
simulation = readmatrix('step1_Steady60_sim.csv');
fig = figure(1);
grid on
hold on
Tsexp = experimental(101,1) - experimental(100,1);
Tssim = simulation(101,1) - simulation(100,1);
exprange = 16:1:0.02/Tsexp;
Tshift = 2550;
simrange = (1+Tshift):(20000+Tshift);
meas_bias = mean(experimental(exprange,2)/sqrt(3));
exper = plot(experimental(exprange,1)-experimental(exprange(1),1),experimental(exprange,2)/sqrt(3)-meas_bias,'LineWidth',1,'Color',[0.8500, 0.3250, 0.0980]);
simu = plot(simulation(simrange,1)-simulation(simrange(1),1),simulation(simrange,2),'LineWidth',2,'Color',[0, 0.4470, 0.7410]);
hold off
exper.Color(4) = 1;
simu.Color(4) = 1;
legend('Experimental $v_a$','Simulation $v_a$')
xlabel('Time (s)')
ylabel('Voltage (V)')

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
%dark blue [0, 0.4470, 0.7410]
%light blue [0.3010, 0.7450, 0.9330]
%orange [0.8500, 0.3250, 0.0980]
%yellow [0.9290, 0.6940, 0.1250]

pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)])
print(fig,'MPC_step1_steady60','-dpdf','-fillpage') %save figure in pdf

%%
experimental = readmatrix('MPC_step1_Steady60_THD_tek0006.csv');
simulation = readmatrix('MPC_step1_Steady60_sim.csv');
fig = figure(1);
grid on
hold on
Tsexp = experimental(101,1) - experimental(100,1);
Tssim = simulation(101,1) - simulation(100,1);
exprange = 16:1:0.02/Tsexp;
Tshift = 1950;
simrange = (1+Tshift):(16100+Tshift);
meas_bias = mean(experimental(exprange,2)/sqrt(3));
exper = plot(experimental(exprange,1)-experimental(exprange(1),1),experimental(exprange,2)/sqrt(3)-meas_bias,'LineWidth',1,'Color',[0.8500, 0.3250, 0.0980]);
simu = plot(simulation(simrange,1)-simulation(simrange(1),1),simulation(simrange,2),'LineWidth',2,'Color',[0, 0.4470, 0.7410]);
hold off
exper.Color(4) = 1;
simu.Color(4) = 1;
legend('Experimental $v_a$','Simulation $v_a$')
xlabel('Time (s)')
ylabel('Voltage (V)')

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
%dark blue [0, 0.4470, 0.7410]
%light blue [0.3010, 0.7450, 0.9330]
%orange [0.8500, 0.3250, 0.0980]
%yellow [0.9290, 0.6940, 0.1250]

pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)])
print(fig,'MPC_step1_steady60','-dpdf','-fillpage') %save figure in pdf