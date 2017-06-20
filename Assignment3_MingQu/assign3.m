%% Robot Learning - Assignment 3
% Alternative solution in matlab / octave by Philipp Allgeuer
%
% assign3.m - Philipp Allgeuer - 02/05/13
% 
% Solves Assignment 3 of the Robot Learning course (SS13).

%% Main function
% This function solves Questions 3.1 $\rightarrow$ 3.3 in turn and then plots and displays all the required results.

% Main Function
function [V,Vstar] = assign3

	% Display a header
	disp('Assignment 3');
	disp('------------');
	
	% Define the problem
	g = [0 0 0 0 0 0 0 0 0;
	     0 0 0 0 0 0 0 0 0;
	     0 1 1 1 0 1 1 0 0;
	     0 0 0 0 0 0 0 1 0;
	     0 0 0 0 0 0 0 1 3;
	     0 0 0 0 0 0 0 1 0;
	     0 1 1 1 0 1 1 0 0;
	     0 2 2 2 2 2 2 0 0;
	     0 2 2 2 2 2 2 0 0];
	gamma = 0.9;
	tol = 1; % Setting to 0.1 or 0.01 makes it a lot slower but gives slightly better value functions
	
	% Define anonymous functions to wrap real ones (Octave can't handle direct references to functions as a parameter it would seem)
	Pol  = @(s,a) DefPolicy(s,a);
	Pfn  = @(s,sd,a) Pssa(s,sd,a,g);
	Rfn  = @(s,sd,a) Rssa(s,sd,a,g);
	Pfnn = @(s,sd,a) Pssan(s,sd,a,g);
	Rfnn = @(s,sd,a) Rssan(s,sd,a,g);
	
	% Question 3.1
	V = EvalPolicy(Pol,Pfn,Rfn,gamma,tol);
	
	% Question 3.2
	Vstar = OptimalV(Pfn,Rfn,gamma,tol);
	OptPol = @(s,a) OptPolicy(s,a,Vstar,Pfn,Rfn,gamma);

	% Evaluate the optimal policy again to check that it indeed gives the optimal value function back (from which it was constructed)
	Vcheck = EvalPolicy(OptPol,Pfn,Rfn,gamma,tol);
	
	% Question 3.3
	Vstarn = OptimalV(Pfnn,Rfnn,gamma,tol);
	OptPoln = @(s,a) OptPolicy(s,a,Vstarn,Pfnn,Rfnn,gamma);
	
	% Evaluate the optimal policy again to check that it indeed gives the optimal value function back (from which it was constructed)
	Vcheckn = EvalPolicy(OptPoln,Pfnn,Rfnn,gamma,tol);
	
	% Display the numeric results
	disp('V =');disp(V);disp(' ');
	disp('V* (det) =');disp(Vstar);disp(' ');
	disp('Det: Max |V* - Vcheck| =');disp(max(max(abs(Vstar - Vcheck))));disp(' ');
	disp('V* (non-det) =');disp(Vstarn);disp(' ');
	disp('Non-Det: Max |V* - Vcheck| =');disp(max(max(abs(Vstarn - Vcheckn))));disp(' ');
	
	% Plot the results
	PlotValueFn(V,10,'Expected value function of initial policy');
	PlotValueFn(Vstar,11,'Optimal value function for deterministic transitions');
	PlotPolicy(OptPol,g,12,'Optimal policy for deterministic transitions');
	PlotValueFn(Vstarn,13,'Optimal value function for non-deterministic transitions');
	PlotPolicy(OptPoln,g,14,'Optimal policy for non-deterministic transitions');
    
end

%% Plotting Functions
% These functions are used to generalise the plotting of policies and value functions so that code does not need to be unnecessarily repeated.

% Plot the required policy (assumed that all probabilities are either 0 or 1)
function PlotPolicy(Pol,g,fig,name)

	% Do the required plotting
	figure(fig);
    set(fig,'Position',[100 100 850 580]);
	subplot(1,1,1);cla;
	axis([0 10 0 10]);
	set(gca,'xtick',0:1:10);
	set(gca,'ytick',0:1:10);
	hold on;
	plot([1 9],[5 5],'ro','MarkerSize',15);
	for r = 1:9
		for c = 1:9
			s = [r c];
			for a = 1:4
				if (Pol(s,a) > 0) && ~all(s == [5 9]) % If this is the greedy action for this state...
					DrawArrow(r,c,a);
				end
			end
			if g(r,c) == 1
				plot(c,10-r,'rx','MarkerSize',15);
			elseif g(r,c) == 2
				plot(c,10-r,'r*','MarkerSize',15);
			end
		end
	end
	hold off;
	grid on;
	title(name);
    axis equal;

end

% Plot the required value function
function PlotValueFn(V,fig,name)
	
	% Do the required plotting
	figure(fig);
    set(fig,'Position',[100 100 850 580]);
	subplot(1,1,1);
	surf(V);
	title(name);
	
end

% Draw an arrow in the right spot and in the right direction to signify an action at a state
function DrawArrow(r,c,a) % Arrows aren't usably implemented in Octave/Matlab... :(

	% Arrow shape constants
	b = 0.1;
	e = 0.5;
	d = e - b * 1.3;
	rfleche = [-d -e -d;d e d;-b 0 b;-b 0 b];
	cfleche = [-b 0 b;-b 0 b;-d -e -d;d e d];
	
	% Plot the required arrow
	plot(c+[0 cfleche(a,2)],10-r-[0;rfleche(a,2)],'b','LineWidth',1.5);
	plot(c+cfleche(a,:),10-r-rfleche(a,:),'b','LineWidth',1.5);
	
end

%% Policy Evaluation
% Apply the iterative policy evaluation algorithm on a generic policy, supplied as a parameter.
% The core equation of this method is the following.
%
% $$ V(s) \leftarrow \Sigma_a \pi(s,a) \Sigma_{s'} P_{ss'}^a [ R_{ss'}^a + \gamma V(s') ] $$
%
% This is iterated over every state in multiple sweeps, until the maximum absolute change of any value of V during a sweep is below some stopping criterion.

% Apply iterative policy evaluation to estimate the value function corresponding to a particular policy
function V = EvalPolicy(Pol,Pfn,Rfn,gamma,tol)

	% Calculate the expected point values of all the cells
	V = zeros(9,9);
	delta = Inf;
	while delta > tol % Wait until the maximum absolute change in V of any cell is less than a specified tolerance
		delta = 0;
		for r = 1:9
			for c = 1:9
				if ~((r == 5) && (c == 9)) % Force goal position to stay at V = 0 as the episode ends if you go there
				
					% Save the old value of V for this cell
					VOldrc = V(r,c);
					
					% Update our estimate for V
					s = [r c];
					sum = 0;
					for a = 1:4 % Every possible action...
						for inc = [-1 -1;-1 0;-1 1;0 -1;0 0;0 1;1 -1;1 0;1 1]' % Every possible successor cell is within +-1 in r and c
							sd = s + inc';
							if ~any((sd<1)|(sd>9)) % Bound sd to within the grid
								sum = sum + Pol(s,a) * Pfn(s,sd,a) * (Rfn(s,sd,a) + gamma * V(sd(1),sd(2)));
							end
						end
					end
					V(r,c) = sum;
					
					% Update delta if we just saw a bigger change in V than anywhere previously in this sweep
					delta = max([delta abs(V(r,c) - VOldrc)]);
					
				end
			end
		end
	end

end

%% Policy Optimisation
% Apply the value iteration algorithm to numerically calculate the optimal value function $V^*(s)$.
% The core equation of this method is the following.
%
% $$ V(s) \leftarrow max_a \Sigma_{s'} P_{ss'}^a [ R_{ss'}^a + \gamma V(s') ] $$
%
% This is iterated over every state in sweeps until the maximum absolute change of any value of V during a sweep is below some stopping criterion.
% The optimal policy can then be evaluated based on the optimal value function using the following formula.
%
% $$ \pi^*(s) = arg max_a \Sigma_{s'} P_{ss'}^a [ R_{ss'}^a + \gamma V^*(s') ] $$
%
% The |DefPolicy| function implements the policy defined in Question 3.1.

% Apply value iteration algorithm to obtain an optimal value function V*
function V = OptimalV(Pfn,Rfn,gamma,tol)

	% Calculate the optimum point values of all the cells iteratively
	V = zeros(9,9);
	delta = Inf;
	while delta > tol % Wait until the maximum absolute change in V of any cell is less than a specified tolerance
		delta = 0;
		for r = 1:9
			for c = 1:9
				if ~((r == 5) && (c == 9)) % Force goal position to stay at V = 0 as the episode ends if you go there
				
					% Save the old value of V for this cell
					VOldrc = V(r,c);
					
					% Update our value for V
					s = [r c];
					maxv = -Inf;
					for a = 1:4 % Every possible action...
						sum = 0;
						for inc = [-1 -1;-1 0;-1 1;0 -1;0 0;0 1;1 -1;1 0;1 1]' % Every possible successor cell is within +-1 in r and c, and there's always at least one
							sd = s + inc';
							if ~any((sd<1)|(sd>9)) % Bound sd to within the grid
								sum = sum + Pfn(s,sd,a) * (Rfn(s,sd,a) + gamma * V(sd(1),sd(2)));
							end
						end
						if sum > maxv % Find the value for the greediest move
							maxv = sum; % Note that if two greedy moves are the same value, this just systematically picks one of them
						end
					end
					V(r,c) = maxv;
					
					% Update delta if we just saw a bigger change in V than anywhere previously in this sweep
					delta = max([delta abs(V(r,c) - VOldrc)]);
					
				end
			end
		end
	end

end

% Implements the optimal policy defined as greedy with respect to the optimal value function
function Prob = OptPolicy(s,a,Vstar,Pfn,Rfn,gamma)

	% Calculate the greedy move with respect to Vstar
	maxv = -Inf;
	for aa = 1:4 % Every possible action...
		sum = 0;
		for inc = [-1 -1;-1 0;-1 1;0 -1;0 0;0 1;1 -1;1 0;1 1]' % Every possible successor cell is within +-1 in r and c, and there's always at least one
			sd = s + inc';
			if ~any((sd<1)|(sd>9)) % Bound sd to within the grid
				sum = sum + Pfn(s,sd,aa) * (Rfn(s,sd,aa) + gamma * Vstar(sd(1),sd(2)));
			end
		end
		if sum > maxv % Find the value and action for the greediest move
			maxv = sum;
			maxa = aa;
		end
	end
	
	% Implement the policy to always choose the greedy move
	if a == maxa
		Prob = 1;
	else
		Prob = 0;
	end
					
end

% Implements the policy specified in Question 3.1
function Prob = DefPolicy(s,a) %#ok<INUSL>

	% Choose a random action with probability 0.5, otherwise move to the right
	PVec = [0.125 0.125 0.125 0.625]; % In the order up/down/left/right
	Prob = PVec(a);
	
end

%% Transition and Reward Probabilities
% These functions define the transition and reward probabilities of the Markov Decision Process.
% 'Deterministic' refers to the probabilities as defined in Question 3.1 (|Pssa| and |Rssa|).
% 'Non-deterministic' refers to the probabilities as defined in Question 3.3 (|Pssan| and |Rssan|).

% Implements the transition probabilities defined in Question 3.1
function Prob = Pssa(s,sd,a,g)

	% Calculate the ideal target square of the action
	move = [-1 0;1 0;0 -1;0 1]; % In the order up/down/left/right
	stmp = s + move(a,:);
	if any((stmp<1)|(stmp>9)) || g(stmp(1),stmp(2)) == 1
		stmp = s; % Tried to go off the grid or on an X, so it moves nowhere...
	end
	
	% Unit probability iff the ideal target square is sd
    Prob = all(stmp == sd); % Comparing row and column...

end

% Implements the transition probabilities defined in Question 3.3
function Prob = Pssan(s,sd,a,g)

    % Problem constants
    PVec = [0.2 0.6 0.2];
    off = [-1 -1 -1 -1 0 1;1 1 1 -1 0 1;-1 0 1 -1 -1 -1;-1 0 1 1 1 1];

	% Calculate the possible target squares and see whether sd is one of them
    rtmp = s(1) + off(a,1:3);
    ctmp = s(2) + off(a,4:6);
    for k = 1:3
        if (rtmp(k)<1) || (rtmp(k)>9) || (ctmp(k)<1) || (ctmp(k)>9) || (g(rtmp(k),ctmp(k))==1)
            rtmp(k) = s(1); % If try to move off edge or onto an X, stay where you are
            ctmp(k) = s(2);
        end
    end
    Prob = ((rtmp==sd(1)) & (ctmp==sd(2))) * PVec';
    
end

% Implements the reward probabilities defined in Question 3.1
function Reward = Rssa(s,sd,a,g) %#ok<INUSL>

	% Problem constants
	RVec = [-1 -20 1 100]; % [Free X * G]
	move = [-1 0;1 0;0 -1;0 1]; % In the order up/down/left/right
	
	% Work out where the move would ideally go
	stmp = s + move(a,:);
	
	% Assign the appropriate rewards (assume the move is possible/legal - if not Pssa is zero anyway)
	if any((stmp<1)|(stmp>9))
		Reward = -5; % Note: Assume that if you're on a * field and you move against the border you don't get an extra +1
	else
		Reward = RVec(g(stmp(1),stmp(2))+1);
	end

end

% Implements the reward probabilities defined in Question 3.3
function Reward = Rssan(s,sd,a,g)

	% Problem constants
    PVec = [0.2 0.6 0.2];
	RVec = [-1 -20 1 100]; % [Free X * G]
    off = [-1 -1 -1 -1 0 1;1 1 1 -1 0 1;-1 0 1 -1 -1 -1;-1 0 1 1 1 1];
	
    % Work out where the move would ideally go
    rtmp = s(1) + off(a,1:3);
    ctmp = s(2) + off(a,4:6);
    Reward = 0;
    Rwd = [0 0 0];
    Invalid = [0 0 0];
    for k = 1:3
        if (rtmp(k)<1) || (rtmp(k)>9) || (ctmp(k)<1) || (ctmp(k)>9) % If you went off the grid...
            Rwd(k) = -5;
            Invalid(k) = PVec(k); % Hack that simplifies Reward calculation below
        else
            Rwd(k) = RVec(g(rtmp(k),ctmp(k))+1); % Apply the appropriate reward based on the square you are entering
            if g(rtmp(k),ctmp(k)) == 1 % If you hit an X...
                Invalid(k) = PVec(k); % Hack that simplifies Reward calculation below
            end
        end
        if (rtmp(k)==sd(1)) && (ctmp(k)==sd(2)) && (Invalid(k)==0) % Note: It is implicitly assumed here that this is only true at most one of the three times it is evaluated - this makes logical sense
            Reward = Rwd(k);
        end
    end
    
    % Handle case where sd is the same as s
    if all(sd == s) % Only way to stay where you are is to have made an invalid move
        if ~all(Invalid == 0)
            Reward = Rwd*(Invalid/sum(Invalid))'; % Calculate the expected value (weight by probabilities)
         end
    end

end
% EOF
