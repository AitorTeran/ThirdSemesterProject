clear all 

Files=dir('*.h5*');

for i=2:1:length(Files)
    Ts=0.5;
    Files=dir('*.h5*');
    name=Files(i).name;
    net = importKerasNetwork(name,'Classes',{'State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7'});
    %net = importKerasNetwork('97_9803_9673.h5','Classes',{'State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7'});
    weights1 = double(net.Layers(2,1).Weights);
    biases1 = double(net.Layers(2,1).Bias);
    weights2 =double(net.Layers(4,1).Weights);
    biases2 = double(net.Layers(4,1).Bias);
    
    simresults = sim('thd_get_data','SimulationMode','normal','AbsTol','0.5', 'StopTime', num2str(Ts));

    thd_average=sum(simresults.caramba.Data(:))/length(simresults.caramba.Data);
    thd_value(i,1)=thd_average*100;
    %model(i)=char(name);
        
    clearvars -except i thd_value 
end


