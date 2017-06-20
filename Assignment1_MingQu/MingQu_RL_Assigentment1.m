%% 1.1)
clear all
%Five arms' intervals
a1 = 1; b1 = 4;
a2 = -2; b2 = 3;
a3 = 0; b3 = 6;
a4 = 2; b4 = 3;
a5 = -1; b5 = 2;

%reward uniformly
r1 = (a1 + b1)/2;
r2 = (a2 + b2)/2;
r3 = (a3 + b3)/2;
r4 = (a4 + b4)/2;
r5 = (a5 + b5)/2;

%expected reward
expReward = (r1+r2+r3+r4+r5)/5;
disp('Exercise 1.1')
disp(['The expected reward is ' num2str(expReward)])
disp('------------------------------------------')

%% 1.2)
Rewards=0;

for i=1:1000
    action = randi([1, 5]);
    randReward = getRandAction(action);
    Rewards = Rewards+randReward;   
end
avgReward = Rewards/1000;
disp('Exercise 1.2')
disp(['The average reward is ' num2str(avgReward)])
disp('------------------------------------------')

%% 1.3)
clear all
disp('Exercise 1.3')
epsilon = 0.1;
Q = zeros(1, 5);
%Q=[1 2 3 4 5];
counts = zeros(1, 5);
rewards = 0;
actions = 0;
Qs = zeros(1000, 5);
for i = 1:1000
    if rand() < epsilon
        % sample uniformly
        action = randi([1, 5]);
    else
        % take optimum action
        [m, I] = max(Q);
        action = I;
        
    end
    
    reward = getRandAction(action);
    counts(action) = counts(action) + 1;
    Q(action) = Q(action) + 1. / (counts(action)) * (reward - Q(action));
    Qs(i, :) = Q;
    rewards = rewards + reward;
    actions = actions + action;
    
    if mod(i,100)==0
        percent = i;
        disp(['Step' num2str(i)])
        for j=1:5 
            avgCounts = counts(j)/i;
            disp([ 'a' num2str(j) ':  ' num2str(avgCounts*100) '%'])
        end
        avgRewards2 = rewards/i;
        disp([ 'resulting average rewards:  ' num2str(avgRewards2)])
    end
     
end
disp('------------------------------------------')
%% 1.4)
clear all;
disp('Exercise 1.4')
epsilon = 0.1;
Q = zeros(1, 5);
lr = 0.02; 
counts = zeros(1, 5);
rewards = 0;
actions = 0;
Qs = zeros(1000, 5);
for i = 1:1000
    
    if rand() < epsilon
        % sample uniformly
        action = randi([1, 5]);
    else
        % take optimum action
        [m, I] = max(Q);
        action = I;     
    end
    
    if i<500   
       reward = getRandAction(action);
    else
       reward = getRandAction2(action); 
    end
    
    counts(action) = counts(action) + 1;
    Q(action) = Q(action) + lr * (reward - Q(action));
    Qs(i, :) = Q;
    rewards = rewards + reward;
    actions = actions + action;
    
    if mod(i,100)==0
        percent = i;
        disp(['Step' num2str(i)])
        for j=1:5 
            avgCounts = counts(j)/i;
            disp([ 'a' num2str(j) ':  ' num2str(avgCounts*100) '%'])
        end
        avgRewards2 = rewards/i;
        disp([ 'resulting average rewards: ' num2str(avgRewards2)])
    end
     
end
disp('------------------------------------------')



%% 1.5)
clear all
disp('Exercise 1.5')
epsilon = 0.1;
Q = 7*ones(1, 5);
counts = zeros(1, 5);
rewards = 0;
actions = 0;
Qs = zeros(1000, 5);
lr = 0.02;
for i = 1:1000
    if rand() < epsilon
        % sample uniformly
        action = randi([1, 5]);
    else
        % take optimum action
        [m, I] = max(Q);
        action = I;  
    end
    
    reward = getRandAction(action);
   
    counts(action) = counts(action) + 1;
    Q(action) = Q(action) + lr * (reward - Q(action));
    Qs(i, :) = Q;
    rewards = rewards + reward;
    actions = actions + action;
    
    if mod(i,100)==0
        percent = i;
        disp(['Step' num2str(i)])
        for j=1:5 
            avgCounts = counts(j)/i;
            disp([ 'a' num2str(j) ':  ' num2str(avgCounts*100) '%'])
        end
        avgRewards2 = rewards/i;
        disp([ 'resulting average rewards:  ' num2str(avgRewards2)])
    end
     
end
disp('------------------------------------------')
