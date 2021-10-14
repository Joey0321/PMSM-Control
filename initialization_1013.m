%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Target: Parameter initialization & system analysis%%%%%%%%%%%
%%%%%%%%%%%%%%%Author: Joey 2021-07-01%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;
fpwm =1e4;
Ts = 1e-6;   %%plantform run step
Tpwm =1e-4;  %%SW (uC) run step

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters from DataSheet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rs = 17.7/2;
Ls = 0.185/2; 
Ld = Ls;
Lq = Ls;
P = 2;          
Kt = 1.32;      %%unit--Nm/A_rms 
Kb = 79.5;      %%unit--V_rms/Krpm
Tf = 0.08;      
Fl=0.007*3/(100*pi);   
J = 9.96e-5;
Imax = 6*sqrt(2);
flux = Kt/(1.5*P*sqrt(2));  
% flux = sqrt(6)*Kb/(100*P*pi); 
Udc = 230*sqrt(2);
TqNorm=0.6*9550/2500;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Speed and Current Controller parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TestCurrentController = 0;  %% 1--> Test Current Ctrl; 0-->Test Speed Ctrl
% rate_Tq = 8/0.05; 
% rate_current = Imax/0.001; 
% rate_spd = 2500/0.005; 

Kp_Cctrl_d = Ld/(4*Tpwm);
Ki_Cctrl_d = Rs/(4*Tpwm);
Kp_Cctrl_q = Lq/(4*Tpwm);
Ki_Cctrl_q = Rs/(4*Tpwm);


Beta = 100*2*pi;  %%100Hz
Ba= (Beta*J- Fl)/(1.5*P*flux);
Kp_Spdctrl = (Beta*J)/(1.5*P*flux);
Ki_Spdctrl = Beta*Kp_Spdctrl;
%%1 ;0.12
Kp_Spdctrl_2 = 1*(pi*J)/(300*P*flux*Tpwm);
Ki_Spdctrl_2 = 0.12*(pi*J)/(6000*P*flux*Tpwm^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ADC signal process 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SimMode =1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PWM method 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UsePwmSelector = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Resolver parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AgSelector = 0;   %% 0->Sim ; 1-->rslvr
%%rslvr method parameters
SinPeakValue = 0.999;  %% near 1
K_resolver = 1; 
wn=1000;
fei=1.5;
K1 =wn^2;
K2 =2*fei/wn;

% %%SMO method parameters  ?sensorless?
% % A = exp(-Rs/(Ld*Tpwm));
% % B = (1-A)/Rs;
% A = -Rs/Ld;
% B = 1/Ld;
% K_SMO = 300;
% f_LPF = 3000/(2*pi); 
% Kp_PLL_SMO = 4;
% Ki_PLL_SMO = 45;