close all
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

ReferenceSelection=1;


for k = [2,4,5,6,7]

    % Constants that have to be defined in Simulink
  %  variable1 = variable1_sim(1);
 %   variable2 = variable1_sim(1);

    % Run the simulation
    Sim = sim('Conventional_FSMPC_algorithm2','SimulationMode','normal','AbsTol','1e-5',...
            'StopTime', '11', ... %Stoptime of the simulation
            'ZeroCross','on', ...
            'SaveTime','on', ...
            'SaveState','on',...
            'SaveOutput','on',...
            'SignalLogging','on','SignalLoggingName','logsout');
                
    data = [Sim.simout.time(400:end)-1 ,Sim.simout.data(400:end,:)];
    Output{k}=data; % Simulation data - returns it as an array
end
