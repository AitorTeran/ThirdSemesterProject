net = importKerasNetwork('model_9796.h5','Classes',{'State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7'});
    weights1 = double(net.Layers(2,1).Weights);
    biases1 = double(net.Layers(2,1).Bias);
    weights2 =double(net.Layers(4,1).Weights);
    biases2 = double(net.Layers(4,1).Bias);
    
    save('weights1.mat','weights1');
    save('biases1.mat','biases1');
    save('weights2.mat','weights2');
    save('biases2.mat','biases2');
    
    %then just run imitator_controller.slx (simulink model), it takes from
    %init_function callbacks automatically these saved matrixes and load
    %them and simulate with that