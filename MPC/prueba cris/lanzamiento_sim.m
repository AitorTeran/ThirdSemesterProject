x_old=1;
t=0.002;
Rload=30;
i_f=[1,2];
v_c=[2,3];


Ts=0.00002;


sim('Conventional_FSMPC_algorithm_tommy','SimulationMode','normal','AbsTol','1e-5',...
            'StopTime', num2str(Ts), ... %Stoptime of the simulation
            'ZeroCross','on', ...
            'SaveTime','on','TimeSaveName','tout', ...
            'SaveState','on','StateSaveName','xoutNew',...
            'SaveOutput','on','OutputSaveName','youtNew',...
            'SignalLogging','on','SignalLoggingName','logsout')