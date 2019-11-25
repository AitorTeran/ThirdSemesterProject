clear all
clc
close all

%%

apool = gcp('nocreate');
if isempty(apool)
    apool = parpool('local');
end

%%
init_file_VSC % call the initialization file

number_test_data=5e5;

x_opt_old = zeros (1, number_test_data); %MPC needs them in 1 row
time = zeros (1, number_test_data);
vc_alpha = zeros (1, number_test_data);
vc_beta =  zeros (1, number_test_data);
if_alpha = zeros (1, number_test_data);
if_beta = zeros (1, number_test_data);
R = zeros (1, number_test_data);
x_opt  = zeros (1, number_test_data);  %this doesn't represent anything but its for the python to work without changing it
wref = zeros (1, number_test_data);



x_opt_old = unidrnd(7,[1, number_test_data]); %it creates discrete numbers until 7 without 0

%rand generates from 0-1 using uniform distribution, multiplied by
%amplitude -/+ y0 value gives us the correct random range
time = rand(1, number_test_data)*0.018;
vc_alpha = rand(1, number_test_data)*10-5;
vc_beta =  rand(1, number_test_data)*10-5;
if_alpha = rand(1, number_test_data)*32-16;
if_beta = rand(1, number_test_data)*32-16;
R = rand(1, number_test_data)*30+30;
wref = round(rand(1, number_test_data))*10+50;

%%
tic
 parfor i=1:number_test_data
     
    [vector(:,i), vref_alpha(i), vref_beta(i)] = MPC_fcn(time(i), vc_alpha(i), vc_beta(i), if_alpha(i), if_beta(i), R(i), x_opt_old(i), v,states, Adf, Bdf, C, wref(i));
 end
 
if_alpha1=if_alpha'; %to save it in 1 column
if_beta1 = if_beta';
vc_alpha1 = vc_alpha';
vc_beta1 = vc_beta';
vref_alpha1 = vref_alpha';
vref_beta1 = vref_beta';
x_opt1 = x_opt'; 
x_opt_old1 = x_opt_old';
R1 = R';
wref1 = wref';
 
save('Validationdata.mat', 'if_alpha1', 'if_beta1', 'vc_alpha1', 'vc_beta1' ,'vref_beta1','vref_alpha1', 'x_opt_old1', 'x_opt1', 'vector', 'R1', 'wref1')

toc
