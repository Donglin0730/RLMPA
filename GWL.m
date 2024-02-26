function [x] = GWL(x,pop,t,M,best,worst)
a=1/(1+exp(5*cos((pi/2)*(t/M))));
for j=1:pop
    s=x(j,:);
    gao=best+a*(s-worst).*randn(size(s));
    r1=rand;
    r2=rand;
    s=gao+(r1*best-r2*s).*randn(size(s));
    x(j,:)=s;
end
end