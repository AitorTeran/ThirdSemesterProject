
close all

%%
apool = gcp('nocreate');
if isempty(apool)
    apool = parpool('local');
end
%%
init_file_VSC % call the initialization file
 
x_opt_old = [1, 2, 3, 4, 5, 6, 7];

time=0:0.002:0.018;
% vref_alpha=325*sin(2*pi*50*time);
% vref_beta=325*sin(2*pi*50*time-3*pi/2);

vc_alpha = -5:1:5;
vc_beta = -5:1:5;
% 
if_alpha=-16:2:16;
if_beta=-16:2:16;

R = 30:10:60;

wref = 0:20:100;

%if_alpha=14*sin(2*pi*50*time);
%if_beta=14*sin(2*pi*50*time-3*pi/2);

[time1, vc_alpha1, vc_beta1, if_alpha1, if_beta1, R1, x_opt_old1, wref1]=ndgrid(time, vc_alpha, vc_beta, if_alpha, if_beta, R, x_opt_old, wref); % Create grid

%[time1, vc_alpha1, vc_beta1, if_alpha1, if_beta1, x_opt_old1]=ndgrid(time, vc_alpha, vc_beta, if_alpha, if_beta, x_opt_old); % Create grid

if_alpha1 = if_alpha1(:)';
if_beta1 = if_beta1(:)';
vc_alpha1 = vc_alpha1(:)';
vc_beta1 = vc_beta1(:)';
x_opt_old1 = x_opt_old1(:)';
% i_alpha1 = i_alpha1(:)';
% i_beta1 = i_beta1(:)';
R1 = R1(:)';
time1= time1(:)';
wref1 = wref1(:)';

iterations = numel(x_opt_old1);
x_opt  = zeros (1, iterations); 
vref_alpha1 = zeros (1, iterations); 
vref_beta1 = zeros (1, iterations); 
vector = zeros(7, iterations);
%%
tic

 parfor i=1:iterations
     
    [vector(:,i), vref_alpha1(i), vref_beta1(i)] = MPC_fcn(time1(i), vc_alpha1(i), vc_beta1(i), if_alpha1(i), if_beta1(i), R1(i), x_opt_old1(i), v,states, Adf, Bdf, C, wref1(i));
 end
 
if_alpha1=if_alpha1';
if_beta1 = if_beta1';
vc_alpha1 = vc_alpha1';
vc_beta1 = vc_beta1';
vref_alpha1 = vref_alpha1';
vref_beta1 = vref_beta1';
x_opt_old1 = x_opt_old1';
x_opt = x_opt'; 
% i_beta1 = i_beta1';
% i_alpha1 = i_alpha1';
R1 = R1';
wref1 = wref1';
 
save('dataANNcrd.mat', 'if_alpha1', 'if_beta1', 'vc_alpha1', 'vc_beta1' ,'vref_beta1','vref_alpha1', 'x_opt_old1', 'x_opt', 'vector', 'R1', 'wref1')

toc