%%Import the speed data
SpdReq_data=Spd.signals.values(:,1);
SpdAct_data=Spd.signals.values(:,2);

%%speed step response indicator
time = Spd.time;
Out = SpdAct_data;
In  = SpdReq_data;

% %define the mean value of last 30 points as final steady-state value 
% Out_infty=mean(Out(numel(Out)-30:numel(Out)));
% StedyErr = Out_infty-In(1);

% define the request input value as final steady-state value  (0 steady err)
Out_infty=In(1);
StedyErr = 0;
sigma = 0.02;

%%rising time
tr_index_min = max(find(Out <= (Out_infty*0.1)));
tr_index_max = min(find(Out >= (Out_infty*0.9)));
tr = time(tr_index_max)-time(tr_index_min);

%%peak time and overshoot
[Out_max,tp_index]=max(Out);
if abs(Out_max-Out_infty)/abs(Out_infty) <= sigma
    tp = NaN;
    op = 0;
else
    tp = time(tp_index);
    op = abs(Out_max-Out_infty)/abs(Out_infty);
end


%%settling time 
flag = 0;
pos_sigma = find(abs(Out-Out_infty)/abs(Out_infty) <= sigma);
for j = 1:numel(pos_sigma)-1
    if pos_sigma(j+1)-pos_sigma(j)>1 
        ts_index = pos_sigma(j+1);
        flag = flag+1
    end
end
if flag == 0
    ts_index = pos_sigma(1);
end
ts = time(ts_index);

%%Number of oscillation  
err = Out_infty-Out;
count = 0;
for i = tr_index_max :ts_index
    if err(i)*err(i+1)<0
        count =count +1;
    end
end
no = round(count/2);


if isnan(tp)
    disp('ת���޳���')
else
    disp(['ת������ʱ��Ϊ',num2str(tr),'s'])
    disp(['ת�ٳ�����Ϊ',num2str(100*op),'%'])
end
disp(['ת�ٵ���ʱ��Ϊ',num2str(ts),'s'])
disp(['ת���񵴴���Ϊ',num2str(no),'��'])
% disp(['ת����̬���Ϊ',num2str(StedyErr),'rpm'])

figure
plot(time,In,'-r',time,Out,'-b')
grid on;
hold on;
plot([0,time(end)],[Out_infty*(1+sigma),Out_infty*(1+sigma)],'k--');
plot([0,time(end)],[Out_infty*(1-sigma),Out_infty*(1-sigma)],'k--'); % ����sigma��% ����sigma��
% text(time(tp_index),Out(tp_index),['(',num2str(time(tp_index)),',',num2str(Out(tp_index)),')'],'color','b')
text(time(ts_index),Out(ts_index),['(����ʱ��ts=',num2str(time(ts_index)),')'],'color','m')
text(time(tr_index_max),Out(tr_index_max),['(����ʱ��tr=',num2str(time(tr_index_max)),')'],'color','m')
text(time(round(numel(time)/3)),Out_max/3,['(������Op=',num2str(op*100),'%',')'],'color','r')
text(time(round(numel(time)/3)),Out_max/4,['(�񵴴���no=',num2str(no),')'],'color','r')
text(time(round(numel(time)/3)),Out_max/6,['(��̬��ֵsigma=',num2str(sigma),')'],'color','r')
xlabel('time/s')
ylabel('Speed/Rpm')
legend('SpdReq','SpdAct')
