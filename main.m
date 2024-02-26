clear
clc

populationSize = 100; % Number of search agents
Max_iteration = 1500;
runs = 30;
%dim=30 PSO=3000 GWO=3000 WOA=3000 VPPSO=1500 AGWO=1500 SBWOA=1500 MPA=1500 QQLMPA=750
%NMPA=1500 BMPA=1500 RLMPA=1500
%dim=50 PSO=5000 GWO=5000 WOA=5000 VPPSO=2500 AGWO=2500 SBWOA=2500 MPA=2500 QQLMPA=1250
%NMPA=2500 BMPA=2500 RLMPA=2500
for fn = 1:30
    if fn == 2
        continue;   %To skip function-2 of CEC-BC-2017 because of its unstable behavior
    end
    Function_name=strcat('F',num2str(fn));
    [lb,ub,dim,fobj]=CEC2017(Function_name);
    Best_score_T = zeros(1,runs);
    PO_cg_curve2 = zeros(runs,Max_iteration);
    %     Best_pos2 = zeros(1,dim);
   for run=1:runs
        rng('shuffle');
% [fMin , bestX,Convergence_curve ] = toujingSSA(pop, M,c,d,dim,fobj);
% [gBestScore,Best,cg_curve]=HMO(N,Max_iteration,lb,ub,dim,fobj);
%         [Best_score_0,Best_pos,PO_cg_curve] = FDA(populationSize,beta,Max_iteration,lb,ub,dim,fobj);
% [Best_score_0,Best_pos,PO_cg_curve] = OFDA(populationSize,Max_iteration,lb,ub,dim,fobj);
        [Best_score_0,Best_pos,PO_cg_curve] = LEOMPA(populationSize,Max_iteration,lb,ub,dim,fobj);
gBestScore=Best_score_0-(fn*100);
        Best_score_T(1,run) = gBestScore;
        %         display(['Run: ', num2str(run), '         ', 'Fitness: ', num2str(Best_score_0), '     ', 'Position:      ', num2str(Best_pos)]);
        PO_cg_curve2(run,:) = PO_cg_curve;
        %         Best_pos2(run,:) = Best_pos;
    end
    %     Best_pos2;
    %Finding statistics
    Best_score_Best = min(Best_score_T);
    Best_score_Worst = max(Best_score_T);
    Best_score_Median = median(Best_score_T,2);
    Best_Score_Mean = mean(Best_score_T,2);
    Best_Score_std = std(Best_score_T);
    pingjun=mean(PO_cg_curve2);
    %Printing results
    display(['Fn = ', num2str(fn)]);
    display(['Best, Worst, Median, Mean, and Std. are as: ', num2str(Best_score_Best),'  ', ...
        num2str(Best_score_Worst),'  ', num2str(Best_score_Median),'  ', num2str(Best_Score_Mean),'  ', num2str(Best_Score_std)]);
    xlswrite(strcat('F:\w\SSA\MEFDA\data\CEC2017\30\','F',num2str(fn),'LEOMPA.xlsx'),PO_cg_curve2);
end
