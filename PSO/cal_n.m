function [n_sigma,ts_n,I_sigma,ts_transient_i,n_err]=cal_n(parameters)
    global Kp_Spdctrl Ki_Spdctrl Kp_Cctrl_q Ki_Cctrl_q
    %��simulink����������빤�������Ա����ʹ��
    Kp_Spdctrl=parameters(1);
    Ki_Spdctrl=parameters(2);
    Kp_Cctrl_q=parameters(3);
    Ki_Cctrl_q=parameters(4);
    sim('PMSM_2017b_WithRslvr.slx');
    I_data=I.signals.values;n_data=n.signals.values;time=I.time;
    n_infty=mean(n_data(numel(n_data)-10:numel(n_data)));
    n_err=abs(n_infty-600);%�����������ת�����
    [i_max,tr_index]=max(I_data);
    diffI=[0;diff(I_data)];%����΢��
    pos=find(abs(diffI)<1);%�ҵ�����������С�Ĳ���
    pos=pos(pos>tr_index);%�ų�����ʱ������������
    min_pos=min(pos);
    I_transient=mean(I_data(min_pos+10:min_pos+20));%�������ٽ׶ε�����̬����ֵ
    I_sigma=(i_max-I_transient)/I_transient;
    ts_transient_i=time(min_pos-tr_index);%��������̬�ĵ���ʱ��
    n_max=max(n_data);
    n_sigma=(n_max-n_infty)/n_infty;
    ts_n_index=numel(n_data)-find(abs(flip(n_data)-n_infty)/n_infty>2e-2,1);
    ts_n=time(ts_n_index);
end
