%_________________________________________________________________________
%  Marine Predators Algorithm source code (Developed in MATLAB R2015a)
%
%  programming: Afshin Faramarzi & Seyedali Mirjalili
%
% paper:
%  A. Faramarzi, M. Heidarinejad, S. Mirjalili, A.H. Gandomi, 
%  Marine Predators Algorithm: A Nature-inspired Metaheuristic
%  Expert Systems with Applications
%  DOI: doi.org/10.1016/j.eswa.2020.113377
%  
%  E-mails: afaramar@hawk.iit.edu            (Afshin Faramarzi)
%           muh182@iit.edu                   (Mohammad Heidarinejad)
%           ali.mirjalili@laureate.edu.au    (Seyedali Mirjalili) 
%           gandomi@uts.edu.au               (Amir H Gandomi)
%_________________________________________________________________________

function [Top_predator_fit,Top_predator_pos,Convergence_curve]=RLMPA(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

state_num=3;
action_num=3;

% FE = 0;             % The current number of function evaluations

Top_predator_pos=zeros(1,dim);% the best position of predators
Top_predator_fit=inf; %the fitness

Convergence_curve=zeros(1,Max_iter);
stepsize=zeros(SearchAgents_no,dim);
fitness=inf(SearchAgents_no,1);
new_fitness=inf(SearchAgents_no,1);  

% Prey=initializationRLMPA(SearchAgents_no,dim,ub,lb);
Prey=initializationMPA(SearchAgents_no,dim,ub,lb);
% figure(1)
% h=scatter(Prey(:,1),Prey(:,2),'o');

Xmin=repmat(ones(1,dim).*lb,SearchAgents_no,1);
Xmax=repmat(ones(1,dim).*ub,SearchAgents_no,1);

%initialize reward table
Reward_table=[
    -1 +1 +1
    +1 +1 +1
    +1 +1 +1];

Q_table=zeros(state_num,action_num);

Iter=0;
FADs=0.2;
P=0.8;
cur_state=1;  %the fitst state
episode=500;

gamma=0.8;

while Iter<Max_iter
    %------------------- Detecting top predator -----------------
    for i=1:size(Prey,1)
        
        Flag4ub=Prey(i,:)>ub;
        Flag4lb=Prey(i,:)<lb;
        Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        fitness(i,1)=fobj( Prey(i,:));
        [ ~, Index ] = min( fitness);
        best=Prey( Index, : );
        [ ~, Index2 ] = max( fitness);
        worst=Prey( Index2, : );
        if fitness(i,1)<Top_predator_fit
            Top_predator_fit=fitness(i,1);
            Top_predator_pos=Prey(i,:);
        end         
    end
    
    %------------------- Marine Memory saving -------------------
    if Iter==0
        fit_old=fitness;    Prey_old=Prey;
    end
    Inx=(fit_old<fitness);
    Indx=repmat(Inx,1,dim);
    Prey=Indx.*Prey_old+~Indx.*Prey;
    fitness=Inx.*fit_old+~Inx.*fitness;
    fit_old=fitness;
    Prey_old=Prey;
    
    %------------------------------------------------------------
    
    Elite=repmat(Top_predator_pos,SearchAgents_no,1);  
%     CF=(1-Iter/Max_iter)^(2*Iter/Max_iter);
    CF=1/(1+exp((10*Iter-5*Max_iter)/Max_iter));
%     Max_iter=500;
%     for Iter=1:Max_iter
%         CF1(Iter)=1/(1+exp((10*Iter-5*Max_iter)/Max_iter));
%         CF2(Iter)=(1-Iter/Max_iter)^(2*Iter/Max_iter);
%     end
%     z=1:1:500;
%     plot(z,CF1);
%     hold on
%     plot(z,CF2);
%     hold on
%     legend('CF(RLMPA','CF(MPA)')
    
    RL=0.05*levy(SearchAgents_no,dim,1.5);   %Levy random number vector
    RB=randn(SearchAgents_no,dim);          %Brownian random number vector
    
    for i=1:size(Prey,1)
        for j=1:size(Prey,2)
            R=rand();
            %-------------------phase1
            if(Q_table(cur_state, 1) >= Q_table(cur_state, 2)) && ( Q_table(cur_state, 1) >= Q_table(cur_state, 3))
                action_num=1;
                Prey=RPMBL1(Prey,SearchAgents_no,best,problem);
                Flag4ub=Prey(i,j)>ub;
                Flag4lb=Prey(i,j)<lb;
                Prey(i,j)=(Prey(i,j).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
%                 figure(1)
%                 h=scatter(Prey(:,1),Prey(:,2),'o');
                stepsize(i,j)=RB(i,j)*(Elite(i,j)-RB(i,j)*Prey(i,j));
                Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j); 
                %-------------------phase2
            elseif( Q_table(cur_state, 2) >= Q_table(cur_state, 1))&& ( Q_table(cur_state, 2) >= Q_table(cur_state, 3))
                action_num=2;
                Prey=GWL(Prey,SearchAgents_no,Iter,Max_iter,best,worst);
                Flag4ub=Prey(i,j)>ub;
                Flag4lb=Prey(i,j)<lb;
                Prey(i,j)=(Prey(i,j).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
                if i>size(Prey,1)/2
                    stepsize(i,j)=RB(i,j)*(RB(i,j)*Elite(i,j)-Prey(i,j));
                    Prey(i,j)=Elite(i,j)+P*CF*stepsize(i,j);
                else
                    stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*Prey(i,j));
                    Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j);
                end
                %-------------------phase3
            else
                action_num=3;
                S=2.4-Iter/Max_iter;
                Prey(i,j)=Prey(i,j)+S*(rand*best-rand*Prey(i,j));
                stepsize(i,j)=RL(i,j)*(RL(i,j)*Elite(i,j)-Prey(i,j));
                Prey(i,j)=Elite(i,j)+P*CF*stepsize(i,j);
            end
        end
    
        %-------------------第i个猎物的位置更新到此结束-------------------

        %-------------------Upadate reward table
        new_fitness(i,1)=fobj( Prey(i,:));
        
        if(new_fitness(i,1) <= fit_old(i,:))
            Reward_table(cur_state, action_num )=+1;
        else
            Reward_table(cur_state, action_num )=-1;
        end
        %
        cur_state=action_num;
        
        %-------------------Update Q-table
        times=0;  
        current_state=randperm(state_num,1);
        for k=1:episode
            %randomly choose an action from current state
            while isempty(find(Reward_table(current_state,:)>-1))
                current_state=rem(current_state+1,3)+1;
            end
            optional_action=find(Reward_table(current_state,:)>-1);  
            chosen_action=optional_action(randperm(length(optional_action),1));
            r=Reward_table(current_state,chosen_action);  %get current reward
            next_state=chosen_action;  
            times=times+1;
            %update Q-table
            if isempty(find(Reward_table(next_state,:)>-1))
                next_state=rem(next_state+1,3)+1;
            end
            next_possible_action=find(Reward_table(next_state,:)>-1);
            maxQ=max(Q_table(next_state,next_possible_action));  
            studyrate=1-(0.9*Iter/Max_iter);
            Q_table(current_state,chosen_action) = Q_table(current_state,chosen_action)+studyrate*(r+gamma * maxQ -Q_table(current_state,chosen_action)); %Bellman方程
            current_state=next_state;  %update the state
        end
    end
 
    %------------------ Detecting top predator ------------------
    for i=1:size(Prey,1)
        
        Flag4ub=Prey(i,:)>ub;
        Flag4lb=Prey(i,:)<lb;
        Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        fitness(i,1)=fobj( Prey(i,:));
        
        if fitness(i,1)<Top_predator_fit
            Top_predator_fit=fitness(i,1);
            Top_predator_pos=Prey(i,:);
        end
    end
    %---------------------- Marine Memory saving ----------------
    
    if Iter==0
        fit_old=fitness;
        Prey_old=Prey;
    end
    
    Inx=(fit_old<fitness);
    Indx=repmat(Inx,1,dim);
    Prey=Indx.*Prey_old+~Indx.*Prey;
    fitness=Inx.*fit_old+~Inx.*fitness;
    
    fit_old=fitness;    Prey_old=Prey;
    
    %---------- Eddy formation and FADs? effect (Eq 16) -----------
    
    if rand()<FADs
        U=rand(SearchAgents_no,dim)<FADs;
        Prey=Prey+CF*((Xmin+rand(SearchAgents_no,dim).*(Xmax-Xmin)).*U);
        
    else
        r=rand();  Rs=size(Prey,1);
        stepsize=(FADs*(1-r)+r)*(Prey(randperm(Rs),:)-Prey(randperm(Rs),:));
        Prey=Prey+stepsize;
    end
    
    Iter=Iter+1;
    Convergence_curve(Iter)=Top_predator_fit; 
end