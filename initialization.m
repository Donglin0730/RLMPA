function flow_x=initialization(alpha,dim,lb,ub)
flow_x0 = 0.1;
d = 0.3;
%第一个循环更新第一列
for i = 1:alpha
    if (0<=flow_x0 && flow_x0<d)
        flow_x(i,:) = (flow_x0/d);
    elseif (d<=flow_x0 && flow_x0<0.5)
        flow_x(i,:) = (flow_x0-d)/(0.5-d); 
    elseif (0.5<=flow_x0 && flow_x0<(1-d))
        flow_x(i,:) = (1-d-flow_x0)/(0.5-d); 
    elseif (1-d<=flow_x0 && flow_x0<1)
        flow_x(i,:) = (1-flow_x0)/d;
    end
    
%第二个循环更新其它所有的列 
    for j = 2:dim
        if (0<=flow_x(:,j-1) && flow_x(:,j-1)<d)
             flow_x(:,j)=(flow_x(:,j-1)/d);
        end
        
        if (d<=flow_x(:,j-1) && flow_x(:,j-1)<0.5)
             flow_x(j)=(flow_x(j-1)-d)/(0.5-d); 
        end
        
        if (0.5<=flow_x(:,j-1) && flow_x(:,j-1)<(1-d))
             flow_x(:,j)=(1-d-flow_x(:,j-1))/(0.5-d); 
        end
        
        if (1-d<=flow_x(:,j-1) && flow_x(:,j-1)<1)
             flow_x(:,j)=(1-flow_x(:,j-1))/d;
        end
    
    end  %j循环的结束
end   %i循环的结束
flow_x = lb + (ub - lb) .* flow_x;  %将前面映射的0->1之间的x变成实验需要的lb->ub
end