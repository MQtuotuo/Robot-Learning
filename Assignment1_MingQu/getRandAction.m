function [ sample_reward ] = getRandAction( action )
% get the reward from the random action
a1 = 1; b1 = 4;
a2 = -2; b2 = 3;
a3 = 0; b3 = 6;
a4 = 2; b4 = 3;
a5 = -1; b5 = 2;

switch action
    case 1
        sample_reward = getUniReward(a1, b1);
    case 2
        sample_reward = getUniReward(a2, b2);
    case 3
        sample_reward = getUniReward(a3, b3);
    case 4
        sample_reward = getUniReward(a4, b4);
    case 5
        sample_reward = getUniReward(a5, b5);

end

