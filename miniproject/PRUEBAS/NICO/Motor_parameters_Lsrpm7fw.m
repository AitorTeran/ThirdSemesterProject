% LSRPM motor, 7kW

clear all

Vs               = 360;           % max. RMS phase voltage
Vph              = Vs*sqrt(2);    % [V], peak value, phase voltage

nrat             = 1750;          % [rpm], rate speed

Npp              = 8/2;           % Number of pole pairs = 1/2 number of poles

Omegae_rat       = 2*pi*nrat/60*Npp;   
                                  % Rated electrical angular frequency

Lndmpm           = 0.412;         % [Web.turns], rotor peak PM flux linkage

J                = 1*1e-3;        % Motor inertia [J.m^2]

Trat             = 38;            % Rated torque 38 Nm.
Tl_const         = Trat/nrat^2;   % Fan load torque constants

% ____________________________________________________________________________________________


fs               = 20e3;          % switching frequency

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
    Ki1          = 2;  
    Kp1          = 0.05;
    
    Ki2          = 6000;
    Kp2          = 6;

    Ki3          = 6000;     
    Kp3          = 6;  
    
   
end

% ____________________________________________________________________________________________
% Parameters used for PI anti wind-up function

% ____________________________________________________________________________________________

% --------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------

%PLL PI calculation. Bandwidth formula taken from reference 23 in Kaiyuan
%paper. The formulas from reference 23, does not consider a gain in the
%error term, so we divide with our gain 2*k to compensate. 

Bw = 50;%100;
zeta = 0.707;
Vm = 70;
c2 = -L2/(L1^2-L2^2)
deltaT = 1/10e3;
k1 = 2*c2*deltaT;

Kp_pll = Bw*(2.2*zeta-0.668*zeta^2)*1/(2*k1)

Ki_pll = Bw^2*(1.1-0.334*zeta)^2*1/(2*k1)




%Variables for NM model

VoltageDisturbance = 30;
