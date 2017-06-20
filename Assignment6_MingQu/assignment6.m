clear all;
l = 0.75;
mc = 1.5; mp = 0.5; g = 9.81;
noise=[0.001 0.001 0.001 0.001];
states=[0 0 0 0];

%% task1
for t=1:100 
    position(t)=states(1);
    speed(t)=states(2);
    angle(t)=states(3);
    angSpeed(t)=states(4);
    
    states=calculateState( states, 0 );
  
end

figure;
plot(position);
hold on
plot(speed);
plot(angle);
plot(angSpeed);

%% task2

states=[0 0 0 0];
position=[];
speed=[];
angle=[];
angSpeed=[];
setToInitial;
 
t=1;
reward=0;

k1 = -1; k2 = 3; k3 = -1; k4 = 2;

while true
    position(t)=states(1);
    speed(t)=states(2);
    angle(t)=states(3);
    angSpeed(t)=states(4);
    
    t=t+1;
    
    %calculate the force
   F = calculateForce( states, k1, k2, k3, k4 );
   
    %calculate the states
   states=calculateState( states, F );
  
    if abs(states(1))<=0.1 && abs(states(3))<=0.1
                reward =reward+ 0;
    else if abs(states(1))>3.0 || abs(states(3))>0.8 
                reward =reward - 2 * (1000 - t);
                break;
        else 
                reward = reward - 1;
        end
    end
    
     
end

figure(1);
plot(position);
hold on
plot(speed);
plot(angle);
plot(angSpeed);

 
%% task3
states=[0 0 0 0];
position=[];
speed=[];
angle=[];
angSpeed=[];
setToInitial;
gradient=[0 0 0 0];
epsilon = 0.8;
alpha = 0.001;
maxReward = -2000;
maxParams = [0 0 0 0];

for i=1:5000
    setToInitial;
    reward2(i)  = episode( k1(i), k2(i), k3(i), k4(i), states );
      
    if reward2(i) > maxReward  
        maxReward = reward2(i);
        maxParams(1) = k1(i);
        maxParams(2) = k2(i);
        maxParams(3) = k3(i);
        maxParams(4) = k4(i);
    end
  
    setToInitial;
    gradient(1) = (episode(k1(i)+epsilon, k2(i), k3(i), k4(i), states)-reward2(i))/epsilon;
    setToInitial;
    gradient(2) = (episode(k1(i), k2(i)+epsilon, k3(i), k4(i), states)-reward2(i))/epsilon;
    setToInitial;
    gradient(3) = (episode(k1(i), k2(i), k3(i)+epsilon, k4(i), states)-reward2(i))/epsilon;
    setToInitial;
    gradient(4) = (episode(k1(i), k2(i), k3(i), k4(i)+epsilon, states)-reward2(i))/epsilon;
    k1(i+1) =k1(i)+ alpha*gradient(1);
    k2(i+1) =k2(i)+ alpha*gradient(2);
    k3(i+1) =k3(i)+ alpha*gradient(3);
    k4(i+1) =k4(i)+ alpha*gradient(4);
    
      
end

figure(2);
plot(k1);
hold on
plot(k2);
plot(k3);
plot(k4);
plot(reward2);

%% task3 the best


states=[0 0 0 0];
position=[];
speed=[];
angle=[];
angSpeed=[];
setToInitial;
 
t=1;
reward=0;

k1 = -120.5362; k2 = -184.1750; k3 = -65.7400; k4 = 138.8162;

while true
    position(t)=states(1);
    speed(t)=states(2);
    angle(t)=states(3);
    angSpeed(t)=states(4);
    
    t=t+1;
    
    %calculate the force
   F = calculateForce( states, k1, k2, k3, k4 );
   
    %calculate the states
   states=calculateState( states, F );
  
    if abs(states(1))<=0.1 && abs(states(3))<=0.1
                reward =reward+ 0;
    else if abs(states(1))>3.0 || abs(states(3))>0.8 
                reward =reward - 2 * (1000 - t);
                break;
        else 
                reward = reward - 1;
        end
    end
    
     
end

figure(3);
plot(position);
hold on
plot(speed);
plot(angle);
plot(angSpeed);


