function [ out ] = secondDerivAngl( angle, angSpeed, f)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
l = 0.75;
mc = 1.0; mp = 0.5; g = 9.81;
temp1 = g*sin(angle)*(mc+mp);
temp2 = (f+mp*l*angSpeed*angSpeed)*cos(angle);
temp3=4*l*(mc+mp)/3-mp*l*cos(angle)*cos(angle);

out = (temp1-temp2)/temp3;
end

