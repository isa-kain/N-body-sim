function bodies = update(bodies, dt)
%find forces acting on each bodies(i) by all other bodies
%modify pos vel and acceleration vectors

G = 6.67408*10^(-3); %m3/kgs2  actual value 10^-11

%----- i didn't touch this, why it broke :( -----%

    % For each body i, find net force by bodies j
    for i=1:length(bodies)
        for j=1:length(bodies)
            if i==j
                continue
            end
            r = bodies(i).p - bodies(j).p; %towards i
            R = norm(r); %scalar distance
            f = -(G*bodies(i).m*bodies(j).m)/(R^2);
            bodies(i).f = bodies(i).f + f.*(r./R); 
        end

        % Calculate parameters based on net force
        bodies(i).a = bodies(i).f./bodies(i).m;
        bodies(i).v = bodies(i).v + bodies(i).a.*dt;
        bodies(i).p = bodies(i).p + bodies(i).v.*dt;

        bodies(i).f = [0,0,0]; %need to zero the force
    end
end