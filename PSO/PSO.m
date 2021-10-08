function [Pg,fmin]=PSO(n,m,xmax,xmin,cal_f,f)
%ȫ������Ⱥ�㷨,fΪĿ�꺯��,dimensionΪά��,nΪ����,mΪ��Ⱥ��ģ
    dimension=numel(xmax);
    w=1;c1=2;c2=2;%�ٶȹ���ϵ��
    sigma_data=zeros(1,n);
    ts_data=zeros(1,n);
    dt=0.3;%λ�Ʒ�����
    vmax=0.1*(xmax-xmin);%�ٶ��޷�
    v=zeros(m,dimension);%��ʼ�ٶ�Ϊ0
    X=(xmax-xmin).*rand(m,dimension)+xmin;%��ʼλ������(xmin,xmax)�ھ��ȷֲ�
    P=X;%PΪÿ������ÿ��������λ��
    last_f=f(X);
    [fmin,min_i]=min(last_f);%PgΪ���д��е�����λ�� 
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
        new_f=f(X);%�µ�Ŀ�꺯��ֵ
        update_j=find(new_f<last_f);
        P(update_j,:)=X(update_j,:);%����ÿ�����ӵ���ʷ����ֵ
        [new_fmin,min_i]=min(new_f);
        new_Pg=X(min_i,:);
        Pg=(new_fmin<fmin)*new_Pg+(new_fmin>=fmin)*Pg;
        last_f=new_f;%���浱ǰ�ĺ���ֵ
        fmin=min(new_fmin,fmin);%���º�����Сֵ
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
        disp(['����������',num2str(i)])
    end
    figure(1)
    legend(legend_str)
    title('��Ӧ��������������ı仯')
    figure(2)
    plot(ts_data)
    title('����ʱ������������ı仯')
    figure(3)
    plot(sigma_data)
    title('����������������ı仯')
end
