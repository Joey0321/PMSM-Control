%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Target: Parameter initialization & system analysis%%%%%%%%%%%
%%%%%%%%%%%%%%%Author: Joey%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;
fpwm =1e4;
Ts = 1e-5;
Tpwm =1e-4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters from DataSheet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rs = 17.7/2;
Ld = 0.185;
Lq = 0.185;
P = 2;
Kt = 1.32;      %%转矩系数，单位Nm/AmpsRMS 
Kb = 79.5;      %%单位V/Krpm
Tf = 0.08;      %%摩擦阻尼,单位Nm
Fl=0.007;       %%粘滞阻尼系数,单位Nm/Krpm
% Tf = 0;      %%摩擦阻尼,单位Nm
% Fl=0;       %%粘滞阻尼系数,单位Nm/Krpm
J = 9.96e-5;
Imax = 6*sqrt(2);

flux = Kt/(1.5*P*sqrt(2));      %%注意电流幅值与有效值的转换
% flux = sqrt(6)*Kb/(100*P*pi);     

wm_base = 3000*pi/30;
Udc = 230;      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Resolver observer parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UseAgSim = 1;   %% high prior than UseAgAtan2
UseAgAtan2 = 0; %% default use PI controller to estimate Ag
SinPeakValue = 0.95104;  %% near 1
K_resolver = 1; 
wn=1000;
fei=1;
K1 =wn^2;
K2 =2*fei/wn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Controller parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TestCurrentController = 0;  %% 1--> Test Current Ctrl; 0-->Test Speed Ctrl

% Kp_Cctrl_d = Ld/(4*Tpwm);
% Ki_Cctrl_d = Rs/(4*Tpwm);
% Kp_Cctrl_q = Lq/(4*Tpwm);
% Ki_Cctrl_q = Rs/(4*Tpwm);
% 
% Beta = 10*2*pi;  %%速度环 100Hz带宽
% Ba= (Beta*J- Fl)/(1.5*P*flux);
% Kp_Spdctrl = (Beta*J)/(1.5*P*flux);
% Ki_Spdctrl = Beta*Kp_Spdctrl;

Kp_Cctrl_d = Ld/(4*Tpwm);
Ki_Cctrl_d = Rs/(4*Tpwm);
Ba=0;
best_parameters=[8.4725,97,72,1.794,56.06];
global Kp_Spdctrl Ki_Spdctrl Kp_Cctrl_q Ki_Cctrl_q
Kp_Spdctrl=1;Ki_Spdctrl=1;Kp_Cctrl_q=1;Ki_Cctrl_q=1;
n=8;m=40;xmax=[1e3,1e5,1e3,1e5];xmin=[0,0,0,0];cal_f=@cal_n;f=@PID_n_access;
[Pg,fmin]=PSO(n,m,xmax,xmin,cal_f,f);

