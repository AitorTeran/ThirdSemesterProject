close all
clear all
clc


Ki_pll=100; %100 %2000 %10  %20000
Kp_pll=5; %10 %10 %50 %400
s=tf('s');
hw=(Kp_pll*s^2+Ki_pll*s)/(s^2+Kp_pll*s+Ki_pll);
ho=(Ki_pll+Kp_pll*s)/(s^2+Kp_pll*s+Ki_pll);


rlocus(hw);
figure()
rlocus(ho);
figure()
margin(hw)
figure()
step(ho)
figure()
step(hw)