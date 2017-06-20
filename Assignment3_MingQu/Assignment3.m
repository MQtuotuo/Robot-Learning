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
    
    