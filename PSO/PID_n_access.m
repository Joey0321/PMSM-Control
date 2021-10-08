function [y,ts_n,n_sigma,ts_transient_i,I_sigma]=PID_n_access(parameters_list)
    M=size(parameters_list,1);%������Ҫ�����������simulink�޷����з��棩
    ts_n0=0.03;n_sigma0=1e-2;I_sigma0=1e-3;ts_i0=1e-4;%����ֵ
    %��simulink����������빤�������Ա����ʹ��
    y=zeros(M,1);
    n_sigma=zeros(M,1);ts_n=zeros(M,1);
    for sim_i=1:M
        parameters=parameters_list(sim_i,:);
        [n_sigma,ts_n,I_sigma,ts_transient_i,n_err]=cal_n(parameters);
        y(sim_i)=log(ts_n./ts_n0+1)+log(n_sigma./n_sigma0+1)+log(I_sigma/I_sigma0+1)+log(ts_transient_i/ts_i0+1)+exp(n_err*10);
    end
end
