function [newb] = addBody(type, mass, radius, position, velocity)
    newb.t = type;
    newb.m = mass; %scalar
    newb.r = radius; %scalar
    newb.p = position; %vector [0 0 0]
    newb.v = velocity; %vector [0 0 0]
    newb.a = [0 0 0]; %vector 
    newb.f = [0 0 0]; %vector 
end