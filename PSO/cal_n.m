function [n_sigma,ts_n,I_sigma,ts_transient_i,n_err]=cal_n(parameters)
    global Kp_Spdctrl Ki_Spdctrl Kp_Cctrl_q Ki_Cctrl_q
    %将simulink所需参数导入工作区，以便仿真使用
    Kp_Spdctrl=parameters(1);
    Ki_Spdctrl=parameters(2);
    Kp_Cctrl_q=parameters(3);
    Ki_Cctrl_q=parameters(4);
    sim('PMSM_2017b_WithRslvr.slx');
    I_data=I.signals.values;n_data=n.signals.values;time=I.time;
    n_infty=mean(n_data(numel(n_data)-10:numel(n_data)));
    n_err=abs(n_infty-600);%期望与输出的转速误差
    [i_max,tr_index]=max(I_data);
    diffI=[0;diff(I_data)];%电流微分
    pos=find(abs(diffI)<1);%找到电流波动较小的部分
    pos=pos(pos>tr_index);%排除启动时电流不变的情况
    min_pos=min(pos);
    I_transient=mean(I_data(min_pos+10:min_pos+20));%恒流升速阶段的暂稳态电流值
    I_sigma=(i_max-I_transient)/I_transient;
    ts_transient_i=time(min_pos-tr_index);%电流暂稳态的调节时间
    n_max=max(n_data);
    n_sigma=(n_max-n_infty)/n_infty;
    ts_n_index=numel(n_data)-find(abs(flip(n_data)-n_infty)/n_infty>2e-2,1);
    ts_n=time(ts_n_index);
end
