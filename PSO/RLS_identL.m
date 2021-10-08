function[sys,x0,str,ts]=RLS_ident1(t,x,u,flag)
theta0=[0.1]; %����ʶ�����ĳ�ֵ��ȡ���С��ʵ����
Pn0=1000000*eye(1);            % Э�������ȡ��ִ��ʵ��Ϊ0.5
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
x0=[theta0';Pn0(:)];% ��Ҫ���µ�״̬�����ĳ�ֵ
str=[];
ts=[-1,0]; % �̳������źŵĲ���ʱ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u)
h=[u(1)]';             %�ɼ�����
Pn0=reshape(x(2:end),1,1);     %��״̬�����з����p0
K=Pn0*h*inv(eye(1)+h'*Pn0*h);           %�����������
Pn1=(Pn0-K*h'*Pn0);             %������һ��Э������
theta0=x(1:1); %��״̬�����з����theta0
y=[u(2)]
theta1=theta0+K*(y-h'*0.99*theta0);  %������һ��theta
sys=[theta1;Pn1(:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlOutputs(t,x,u)
theta1=x(1:1);
sys=theta1;
