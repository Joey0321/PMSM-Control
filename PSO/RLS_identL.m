function[sys,x0,str,ts]=RLS_ident1(t,x,u,flag)
theta0=[0.1]; %被辨识参数的初值，取充分小的实向量
Pn0=1000000*eye(1);            % 协方差矩阵，取充分大的实数为0.5
switch flag,
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes(theta0,Pn0);
    case 2,
        sys=mdlUpdate(t,x,u);
    case 3,
        sys=mdlOutputs(t,x,u);
    case {1,4,9}
        sys=[];
    otherwise
        error(['Unhanded flag=',num2str(flag)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[sys,x0,str,ts]=mdlInitializeSizes(theta0,Pn0)
sizes=simsizes;
sizes.NumContStates=0;
sizes.NumDiscStates=2;
sizes.NumOutputs=1;
sizes.NumInputs=2;
sizes.DirFeedthrough=0;
sizes.NumSampleTimes=1;
sys=simsizes(sizes);
x0=[theta0';Pn0(:)];% 需要更新的状态向量的初值
str=[];
ts=[-1,0]; % 继承输入信号的采样时间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u)
h=[u(1)]';             %采集数据
Pn0=reshape(x(2:end),1,1);     %从状态变量中分离出p0
K=Pn0*h*inv(eye(1)+h'*Pn0*h);           %计算增益矩阵
Pn1=(Pn0-K*h'*Pn0);             %计算下一个协方差阵
theta0=x(1:1); %从状态变量中分离出theta0
y=[u(2)]
theta1=theta0+K*(y-h'*0.99*theta0);  %计算下一个theta
sys=[theta1;Pn1(:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlOutputs(t,x,u)
theta1=x(1:1);
sys=theta1;
