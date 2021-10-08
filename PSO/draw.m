function draw(parameters)
    global Kp_Spdctrl Ki_Spdctrl Kp_Cctrl_q Ki_Cctrl_q
    Kp_Spdctrl=parameters(1);
    Ki_Spdctrl=parameters(2);
    Kp_Cctrl_q=parameters(3);
    Ki_Cctrl_q=parameters(4);
    sim('PMSM_2017b_WithRslvr.slx')
    n_data=n.signals.values;time=n.time;%获取转速序列及对应时刻
    plot(time,n_data)
