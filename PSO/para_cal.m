obj_slx='PMSM_2017b_WithRslvr.slx';
sim(obj_slx);
I_data=I.signals.values;n_data=n.signals.values;time=I.time;
I_infty=mean(I_data(numel(I_data)-10:numel(I_data)));
n_infty=mean(n_data(numel(n_data)-10:numel(n_data)));
[i_max,tr_index]=max(I_data);
diffI=[0;diff(I_data)];%电流微分
pos=find(abs(diffI)<1);%找到电流波动较小的部分
pos=pos(pos>tr_index);%排除启动时电流不变的情况
min_pos=min(pos);
I_transient=mean(I_data(min_pos+10:min_pos+20));%恒流升速阶段的暂稳态电流值
I_sigma=(i_max-I_transient)/I_transient;
if I_sigma<1e-4
    tr_i=NaN;    
else
    tr_i=time(tr_index);%电流的上升时间
end
ts_transient_i=time(min_pos-tr_index);%电流暂稳态的调节时间
ts_i_index=numel(I_data)-find(abs(flip(I_data)-I_infty)/I_infty>2e-2,1);
ts_i=time(ts_i_index);%转速稳态时电流的调节时间
[n_max,tr_index]=max(n_data);
n_sigma=(n_max-n_infty)/n_infty;
%参数展示
%转速参数展示
if n_sigma<1e-4
    tr_n=NaN;
else
    tr_n=time(tr_index);
end
ts_n_index=numel(n_data)-find(abs(flip(n_data)-n_infty)/n_infty>2e-2,1);
ts_n=time(ts_n_index);
if isnan(tr_n)
    disp('转速无超调')
else
    disp(['转速上升时间为',num2str(tr_n),'s'])
    disp(['转速超调量为',num2str(100*n_sigma),'%'])
end
disp(['转速调节时间为',num2str(ts_n),'s'])
%电流参数展示
if isnan(tr_i)
    disp('电流无超调')
else
    disp(['电流上升时间为',num2str(tr_i),'s'])
    disp(['电流超调量为',num2str(100*I_sigma),'%'])
    disp(['电流暂稳态调节时间为',num2str(ts_transient_i),'s'])
end
disp(['电流的最终调节时间为',num2str(ts_i),'s'])
