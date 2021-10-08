obj_slx='PMSM_2017b_WithRslvr.slx';
sim(obj_slx);
I_data=I.signals.values;n_data=n.signals.values;time=I.time;
I_infty=mean(I_data(numel(I_data)-10:numel(I_data)));
n_infty=mean(n_data(numel(n_data)-10:numel(n_data)));
[i_max,tr_index]=max(I_data);
diffI=[0;diff(I_data)];%����΢��
pos=find(abs(diffI)<1);%�ҵ�����������С�Ĳ���
pos=pos(pos>tr_index);%�ų�����ʱ������������
min_pos=min(pos);
I_transient=mean(I_data(min_pos+10:min_pos+20));%�������ٽ׶ε�����̬����ֵ
I_sigma=(i_max-I_transient)/I_transient;
if I_sigma<1e-4
    tr_i=NaN;    
else
    tr_i=time(tr_index);%����������ʱ��
end
ts_transient_i=time(min_pos-tr_index);%��������̬�ĵ���ʱ��
ts_i_index=numel(I_data)-find(abs(flip(I_data)-I_infty)/I_infty>2e-2,1);
ts_i=time(ts_i_index);%ת����̬ʱ�����ĵ���ʱ��
[n_max,tr_index]=max(n_data);
n_sigma=(n_max-n_infty)/n_infty;
%����չʾ
%ת�ٲ���չʾ
if n_sigma<1e-4
    tr_n=NaN;
else
    tr_n=time(tr_index);
end
ts_n_index=numel(n_data)-find(abs(flip(n_data)-n_infty)/n_infty>2e-2,1);
ts_n=time(ts_n_index);
if isnan(tr_n)
    disp('ת���޳���')
else
    disp(['ת������ʱ��Ϊ',num2str(tr_n),'s'])
    disp(['ת�ٳ�����Ϊ',num2str(100*n_sigma),'%'])
end
disp(['ת�ٵ���ʱ��Ϊ',num2str(ts_n),'s'])
%��������չʾ
if isnan(tr_i)
    disp('�����޳���')
else
    disp(['��������ʱ��Ϊ',num2str(tr_i),'s'])
    disp(['����������Ϊ',num2str(100*I_sigma),'%'])
    disp(['��������̬����ʱ��Ϊ',num2str(ts_transient_i),'s'])
end
disp(['���������յ���ʱ��Ϊ',num2str(ts_i),'s'])
