function [x] = RPMBL1(x,pop,best)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
a=randperm(pop);
for i=1:(round(pop/2))
%     e=benchmark_func(x(a(i),:),problem);
%     f=benchmark_func((x(a(i+pop/2),:)),problem);
    Rmv = (x(a(i)) +(x(a(i+pop/2),:))./2);
    x(a((pop/2)+i),:)= x(a(i),:)+rand(1)*(best-Rmv.*1);    
end
end

