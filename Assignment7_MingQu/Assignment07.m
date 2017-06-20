timestep = 0.1;
g = 9.81;
l = 2;

%% task1
%initialization 
theta = [0.3];
omega = [-0.5];
omega_dot = [sin(theta(1)) * g/l];

for i=1:30
    omega(i+1)= omega(i) + timestep * omega_dot(i);
    theta(i+1)= theta(i) + timestep * omega(i) +timestep*timestep/l * omega_dot(i);
    omega_dot(i+1)= sin(theta(i)) * g / l;
    
end

figure(1);
plot(theta);
hold on
plot(omega);
plot(omega_dot);
hold off

%% task2
%initialization 
theta = [0.3];
omega = [-0.5];

for i=1:30
    omega(i+1)= omega(i) + g / l * timestep * theta(i);
    theta(i+1)= theta(i) + timestep * omega(i); 
end

figure(2);
plot(theta);
hold on
plot(omega);
hold off




