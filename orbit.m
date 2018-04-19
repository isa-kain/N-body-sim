function orbit(varargin)
% Simulates orbits of n-length array of bodies
% Types is n-length array specifying what those bodies are: 'Star', 'Planet', 'Satellite'
% Masses, radii, positions, velocities are nx3 matrices containing respective parameters

%% Create n objects using input data

% G = 6.67408*10^(-3); %m3/kgs2
% AU = 149597870.7; %km

switch nargin
    case 0  % DOES NOT WORK -- AERO TOOLBOX?
        %Default conditions simulate inner solar system
        % figures from: https://nssdc.gsfc.nasa.gov/planetary/factsheet/
        % starting positions(km) and velocities(km/s) at perihelion
        % must have aerospace toolbox installed to use planetEphemeris
        % mass in kg, radii in km
        bodies(1) = addBody("Star", 1.9855e+30, 695700, [0 0 0], [0 0 0]); %sun %m=1.9855e+30
        [pos,vel] = planetEphemeris(juliandate(2000,1,1), 'SolarSystem', 'Mercury', '405', 'km');
        bodies(2) = addBody("Planet", 3.30104e+23, 2440, pos, vel); %mercury
        [pos,vel] = planetEphemeris(juliandate(2000,1,1), 'SolarSystem', 'Venus',   '405', 'km');
        bodies(3) = addBody("Planet", 4.86732e+24, 6052, pos, vel); %venus
        [pos,vel] = planetEphemeris(juliandate(2000,1,1), 'SolarSystem', 'Earth',   '405', 'km');
        bodies(4) = addBody("Planet", 5.97219e+24, 3396, pos, vel); %earth
        [pos,vel] = planetEphemeris(juliandate(2000,1,1), 'SolarSystem', 'Mars',    '405', 'km');
        bodies(5) = addBody("Planet", 6.41693e+23, 6792/2, pos, vel); %mars
        [pos,vel] = planetEphemeris(juliandate(2000,1,1), 'SolarSystem', 'Jupiter', '405', 'km');
        bodies(6) = addBody("Planet", 1.89813e+27, 71492, pos, vel); %jupiter
        
        xl = [-1e+09 1e+09]; yl = [-1e+09 1e+09]; zl = [-1e+09 1e+09];
        dt = .00001;

        %heliocentric position data: https://omniweb.gsfc.nasa.gov/coho/helios/planet.html
        
    case 1 
        % Create bodies with arbitrary radii masses pos and vel
        n = varargin{1};
        if isnumeric(n)
            for i=1:n
                bodies(i) = addBody('', rand*10^10, rand, ...
                    [rand*round(rand)*(-1)      rand*round(rand)*(-1)      rand*round(rand)*(-1)], ...
                    [rand*1000*round(rand)*(-1) rand*1000*round(rand)*(-1) rand*1000*round(rand)*(-1)]);
            end
            xl = [-2 2]; yl = [-2 2]; zl = [-2 2];
            dt = .0000001;
        else
            % Hardcode example - access with empty string input
            bodies(1) = addBody("A" , 80000000   , 120   , [2000 0 0]        , [0 25 0]);
            bodies(2) = addBody("B" , 1500000000 , 220   , [5 5 0]           , [0 1 0]);
            bodies(3) = addBody("C" , 8000000    , 60    , [-2000 0 0]       , [0 -43.75 0]);

            xl = [-3000 3000]; yl = [-3000 3000]; zl = [-10 10];
            dt = .1;
        end
        
    case 5
        % create bodies with input data
        types = varargin{1}; %MUST use " " around types to create STRING array
        masses = varargin{2}; 
        radii = varargin{3};
        positions = varargin{4};
        velocities = varargin{5};
        
        if length(types)~=length(masses) || length(masses)~=length(radii) || ...
                length(radii)~=(length(positions)/3) || (length(positions)/3)~=(length(velocities)/3)
            error('Input arrays of different sizes.')
        elseif length(masses)>7
            error('That is a bit excessive.')
        end
        
        for i=1:length(masses)
            bodies(i) = addBody(types(i), masses(i), radii(i), [positions(i) positions(i+1) ...
                positions(i+2)], [velocities(i) velocities(i+1) velocities(i+2)]);
        end
        
        %determine xl, yl, zl
        dt = .1;
end

n = length(bodies);
save('bodies.mat')

%% Draw loop
shg; clf
set(gcf,'menu','none','numbertitle','off','name','Orbital Sim')
axis([-1 1 -1 1 -1 1])
xlim(xl); ylim(yl); zlim(zl);
% xlim manual; ylim manual; zlim manual;
xlabel('X'); ylabel('Y'); zlabel('Z');
grid on; hold on;
stop = uicontrol('style','toggle','string','stop');

N = 10000000;
spot = plot([],[]);

for rep=0:N
    if get(stop,'value') == 0
        % bring everyone's coordinates into matrix
        loc = reshape([bodies.p],[3,n]);
        drawnow;
        
        % Plot trail
        if mod(rep,29)==0
            plot3(loc(1,:),loc(2,:),loc(3,:),'.', 'MarkerSize', 5, 'Color', [.9 .69 .64])
            title(sprintf('Time elapsed: %0.5g', rep))
            grid on;
        end
        
        % Plot marker
        if mod(rep,9)==0
            delete(spot);
            spot = plot3(loc(1,:), loc(2,:), loc(3,:), 'b.', 'MarkerSize', 17);
        end
        
        % Update bodies
%         n = collision(bodies); 
        bodies = update(bodies, dt); 
    else
        if get(stop,'value') == 1
            break
        end
    end
end

save('bodies.mat')
hold off;


    %Check collisions; for now, treat as inelastic collision of point
    %masses, return new single body, ignore accretion details
    %running counter of body parameters?
    %for later: relativistic effects

end