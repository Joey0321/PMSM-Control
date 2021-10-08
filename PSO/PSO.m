function [Pg,fmin]=PSO(n,m,xmax,xmin,cal_f,f)
%全局粒子群算法,f为目标函数,dimension为维度,n为代数,m为种群规模
    dimension=numel(xmax);
    w=1;c1=2;c2=2;%速度惯性系数
    sigma_data=zeros(1,n);
    ts_data=zeros(1,n);
    dt=0.3;%位移仿真间隔
    vmax=0.1*(xmax-xmin);%速度限幅
    v=zeros(m,dimension);%初始速度为0
    X=(xmax-xmin).*rand(m,dimension)+xmin;%初始位置满足(xmin,xmax)内均匀分布
    P=X;%P为每个粒子每代的最优位置
    last_f=f(X);
    [fmin,min_i]=min(last_f);%Pg为所有代中的最优位置 
    Pg=X(min_i,:);
    last_Pg=Pg;
    legend_str=cell(0);
    legend_i=1;
    figure(1)
    legend_str{legend_i}=num2str(1);
    draw(Pg)
    for i=1:n
        v=w*v+c1*rand*(P-X)+c2*rand*(ones(m,1)*Pg-X);
        v=(v>vmax).*vmax+(v>=-vmax & v<=vmax).*v+(v<-vmax).*(-vmax);
        X=X+v*dt;
        X=(X>xmax).*xmax+(X>=xmin & X<=xmax).*X+(X<xmin).*(xmin);
        new_f=f(X);%新的目标函数值
        update_j=find(new_f<last_f);
        P(update_j,:)=X(update_j,:);%修正每个粒子的历史最优值
        [new_fmin,min_i]=min(new_f);
        new_Pg=X(min_i,:);
        Pg=(new_fmin<fmin)*new_Pg+(new_fmin>=fmin)*Pg;
        last_f=new_f;%保存当前的函数值
        fmin=min(new_fmin,fmin);%更新函数最小值
        [sigma,ts,~,~]=cal_f(Pg);
        sigma_data(1,i)=sigma;
        ts_data(1,i)=ts;
        if last_Pg~=Pg
            legend_i=legend_i+1;
            figure(1)
            legend_str{legend_i}=num2str(i);
            draw(Pg)
            hold on
        end
        last_Pg=Pg;
        disp(['迭代次数：',num2str(i)])
    end
    figure(1)
    legend(legend_str)
    title('响应曲线随迭代次数的变化')
    figure(2)
    plot(ts_data)
    title('调节时间随迭代次数的变化')
    figure(3)
    plot(sigma_data)
    title('超调量随迭代次数的变化')
end
