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



x_opt_old = unidrnd(7,[1, number_test_data]); %it creates discrete numbers until 7 without 0

%rand generates from 0-1 using uniform distribution, multiplied by
%amplitude -/+ y0 value gives us the correct random range
time = rand(1, number_test_data)*0.018;
vc_alpha = rand(1, number_test_data)*10-5;
vc_beta =  rand(1, number_test_data)*10-5;
if_alpha = rand(1, number_test_data)*32-16;
if_beta = rand(1, number_test_data)*32-16;
R = rand(1, number_test_data)*30+30;

%%
tic
 parfor i=1:number_test_data
     
    [vector(:,i), vref_alpha(i), vref_beta(i)] = MPC_fcn(time(i), vc_alpha(i), vc_beta(i), if_alpha(i), if_beta(i), R(i), x_opt_old(i), v,states, Adf, Bdf, C, wref);
 end
 
if_alpha=if_alpha'; %to save it in 1 column
if_beta = if_beta';
vc_alpha = vc_alpha';
vc_beta = vc_beta';
vref_alpha = vref_alpha';
vref_beta = vref_beta';
x_opt = x_opt'; 
x_opt_old = x_opt_old';
R = R';
 
save('Validationdata.mat', 'if_alpha', 'if_beta', 'vc_alpha', 'vc_beta' ,'vref_beta','vref_alpha', 'x_opt_old', 'x_opt', 'vector', 'R')

toc
