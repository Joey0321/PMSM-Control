function draw_n_I(parameters)
    global Kp_Spdctrl Ki_Spdctrl Kp_Cctrl_q Ki_Cctrl_q
    Kp_Spdctrl=parameters(1);
    Ki_Spdctrl=parameters(2);
    Kp_Cctrl_q=parameters(3);
    Ki_Cctrl_q=parameters(4);
    sim('PMSM_2017b_WithRslvr.slx')
    n_data=n.signals.values;time=n.time;%��ȡת�����м���Ӧʱ��
    I_data=I.signals.values;
    figure
    subplot(211)
    plot(time,I_data,'r-','LineWidth',1.5)
    title('��������')
    subplot(212)
    plot(time,n_data,'b-','LineWidth',1.5)
    title('ת�ٲ���')
end
