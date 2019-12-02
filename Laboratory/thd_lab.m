M = readmatrix('step1_Steady30_THD_tek0000.csv');
Ts = M(3,2);
[r,harmpow,harmfreq] = thd(M(16:end,2),1/Ts);
THD_Va = (10^(thd(M(16:end,2),1/Ts)/20))*100;
THD_Vb = (10^(thd(M(16:end,4),1/Ts)/20))*100;
THD_Vc = (10^(thd(M(16:end,3),1/Ts)/20))*100;
THD_i = (10^(thd(M(16:end,5),1/Ts)/20))*100;