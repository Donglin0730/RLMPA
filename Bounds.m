
function s = Bounds(s, Lb, Ub,best1,best2) 
temp = s;
I = temp < Lb;
temp(I)=best2(I)+rand*(best1(I)-best2(I));
J = temp > Ub;
temp(J)=best2(J)+rand*(best1(J)-best2(J));
s = temp;
end