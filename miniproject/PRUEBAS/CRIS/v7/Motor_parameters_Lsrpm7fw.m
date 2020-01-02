clear all
Vm=60; %45


%PLL Parameters

% Bw = 100;
% zeta = 0.707;
% Vm = 70;
% c2 = -L2/(L1^2-L2^2)
% deltaT = 1/10e3;
% k1 = 2*c2*deltaT;
% 
% Kp_pll = Bw*(2.2*zeta-0.668*zeta^2)*1/(2*k1)
% 
% Ki_pll = Bw^2*(1.1-0.334*zeta)^2*1/(2*k1)

Ki_pll=10; %100 %2000 %10
Kp_pll=30; %10 %10 %50

wo=15; %10 %15


% LSRPM motor, 7kW

Vs               = 360;           % max. RMS phase voltage
Vph              = Vs*sqrt(2);    % [V], peak value, phase voltage

nrat             = 1750;          % [rpm], rate speed

Npp              = 8/2;           % Number of pole pairs = 1/2 number of poles

Omegae_rat       = 2*pi*nrat/60*Npp;   
                                  % Rated electrical angular frequency

Lndmpm           = 0.412;         % [Web.turns], rotor peak PM flux linkage

J                = 1*1e-3;        % Motor inertia [J.m^2]

Trat             = 10;            % Rated torque 38 Nm.
Tl_const         = Trat/nrat^2;   % Fan load torque constants

% ____________________________________________________________________________________________


fs               = 20e3;          % switching frequency
Ts=1/fs;
% Initilizing the Simulink model
Omegae_ini       = 0;             % Initial motor shaft speed, electrical value, [rad]
Lndd_ini         = Lndmpm;        % This means at t=0, theta=0 and N-pole aligned with d-axis 

Omeg_const       = Omegae_rat;

Omegae           = 2*pi*5;

% --------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------

Rs               = 0.78;                           % [Om]
Lls              = 2e-3;                           % [H]
Ld               = 10e-3;                          % [H]
Lq               = 12.8e-3;                        % [H]

Lmd              = Ld-Lls;                         % [H]
Lmq              = Lq-Lls;                         % [H]

% _________________________________________________________________________
% Modify the inductance values
% Ld               = 70e-3;
% Lq               = Ld;
% _________________________________________________________________________


L1               = (Ld+Lq)/2;
L2               = (Ld-Lq)/2;

c1=L1/(L1^2-L2^2);
c2=-L2/(L1^2-L2^2);
% _________________________________________________________________________
% Limiting the max. transient current in the output of speed loop PI
I_rated          = 16;            % Peak rated power
Iphmax           = I_rated*sqrt(2)*3;
% _________________________________________________________________________



% --------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------

switch 2
case 1
    % 
    Ki1          = 2;  
    Kp1          = 0.4;
    
    Ki2          = 550;
    Kp2          = 6;

    Ki3          = 450;     
    Kp3          = 6;  

    
case 2
    % Tuned by tuning Kp first and then Ki...
    Ki1          = 2; %2  
    Kp1          = 0.005;  %0.05 %0.005
    
    Ki2          = 6000; %10000 %6000 %3000
    Kp2          = 6;  %12 %6 %2

    Ki3          = 6000;     %10000 %6000 %3000
    Kp3          = 6;  %12 %6 %2
    
   
end

% ____________________________________________________________________________________________
% Parameters used for PI anti wind-up function

% ____________________________________________________________________________________________

% --------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------



