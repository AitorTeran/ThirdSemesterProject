%initialization file

Rl=0.1;
Rload=30;
L=2.4e-3;
C=14e-6;
wref=2*pi*50;
Vdc=700;
Ts=20e-6;
Td=4e-6;
s=tf('s');


% Converter states
v0 = 0;
v1 = 2/3*Vdc;
v2 = 1/3*Vdc + 1j*sqrt(3)/3*Vdc;
v3 = -1/3*Vdc + 1j*sqrt(3)/3*Vdc;
v4 = -2/3*Vdc;
v5 = -1/3*Vdc - 1j*sqrt(3)/3*Vdc;
v6 = 1/3*Vdc - 1j*sqrt(3)/3*Vdc;
v7 = 0;
v = [v0 v1 v2 v3 v4 v5 v6 v7];
states = [0 0 0;1 0 0;1 1 0;0 1 0;0 1 1;0 0 1;1 0 1;1 1 1];

%____________________________________________________________
% LC Filter model; x=[if,vc]; with linear load incoorporated;
Ac=[-Rl/L -1/L; 1/C -1/(Rload*C)];
Bc=[1/L,0;0,-1/C];
Cc=[0,1];
Dc=[0];

format long
% Discrete filter model - LC filter
system=ss(Ac,Bc,Cc,Dc);
systemd=c2d(system,Ts,'zoh');
Ad=systemd.a;
Bd=systemd.b;
Cd=systemd.c;
Dd=systemd.d;

%____________________________________________________________

% LC Filter model; x=[if,vc]; without load current as input;
Ac=[-Rl/L -1/L; 1/C 0];
Bc=[1/L,0;0,-1/C];
Cc=[0,1];
Dc=[0];

format long
% Discrete filter model - LC filter
system=ss(Ac,Bc,Cc,Dc);
systemd=c2d(system,Ts,'zoh');
Adf=systemd.a;
Bdf=systemd.b;
Cdf=systemd.c;
Ddf=systemd.d;