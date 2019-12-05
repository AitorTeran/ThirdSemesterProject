net = importKerasNetwork('model_9796.h5','Classes',{'State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7'});
input_data = load('Validationdata.mat');

weights1 = double(net.Layers(2,1).Weights);
biases1 = double(net.Layers(2,1).Bias);

delta_Vc_alpha = input_data.vc_alpha1 - input_data.vref_alpha1;  
delta_Vc_beta =  input_data.vc_beta1 - input_data.vref_beta1; 

data_mat = [input_data.R1, input_data.if_alpha1, input_data.if_beta1, delta_Vc_alpha, delta_Vc_beta, input_data.vref_alpha1, input_data.vref_beta1, input_data.x_opt_old1];

output = zeros(size(data_mat,1),15);
for i = 1:size(data_mat,1)
    output(i,:) = max(0,(weights1*data_mat(i,:)' + biases1));
end