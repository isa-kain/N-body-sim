function n = collision(bodies)
    %check to see if bodies are within r1+r2 of each other
    for i=1:length(bodies)
        for j=1:length(bodies)
            if i==j
                continue
            end
            dis = norm(bodies(j).r - bodies(i).r);
            if dis<=(abs(bodies(i).r) + abs(bodies(j).r))
                disp('smash!')
                indices = [i, j];
                newbody = smash(bodies, indices);
                bodies(i) = newbody; %replace original body with new body
                bodies(j).m = -1;
                break 
            end
        end
    end
    % Remove erased bodies
    bodies([bodies(:).m]>0);

    n = length(bodies);
end

function [newbody] = smash(bodies, indices)
    % Assume completely inelastic collision
    % Find velocity, position of new body
    b1 = bodies(indices(1));
    b2 = bodies(indices(2));
    
    mnew = b1.m + b2.m;
    vnew = ((b1.m*b1.v) + (b2.m*b2.v))/mnew;
    pnew = mean([b1.p;b2.p]);
    
    % Determine new radius using volumes of original bodies
    v1 = 4*pi/pi*b1.r;
    v2 = 4*pi/pi*b2.r;
    rnew = nthroot((3/(4*pi)*(v1+v2)), 3);
    
    if strcmp(b1.t,'Star') || strcmp(b2.t,'Star')
        newtype = 'Star';
    else
        newtype = 'Planet';
    end
    
    newbody = addBody(newtype, mnew, rnew, pnew, vnew);
end
