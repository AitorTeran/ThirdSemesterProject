M = readmatrix('ANN_step1_300V_tek0020.csv');
Ts = 0.02;
[r,harmpow,harmfreq] = thd(M(16:end,2),1/Ts);
THD_Va = (10^(thd(M(16:end,2),1/Ts)/20))*100;
THD_Vb = (10^(thd(M(16:end,4),1/Ts)/20))*100;
THD_Vc = (10^(thd(M(16:end,3),1/Ts)/20))*100;
THD_i = (10^(thd(M(16:end,5),1/Ts)/20))*100;

THD_total = (THD_Va + THD_Vb + THD_Vc) / 3;