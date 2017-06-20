function [ returns ] = expectedReturn( policy, attempts )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if length(policy) > 0 && attempts < 6
    
    %take the next task and increase attempts
    task = policy(1);
    attempts = attepts+1;
    returns = (task(2) * (task(1) + expectedReturn(policy[1:], attempts))
                   + (1-task(2)) * (0 + expectedReturn(policy, attempts)))
    
end

