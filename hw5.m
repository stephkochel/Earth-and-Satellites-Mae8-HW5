clc;clear all; format long;
name = 'Stephanie Kochel';
id='A19391497';
hw_num=5;
%% Task 1
p1a = evalc('help satellite');
Tf=5000;
for sat_id = 1:1
    [Xo,Yo,Zo,Uo,Vo,Wo] = read_input('satellite_data.txt',sat_id);
    [T{sat_id},X{sat_id},Y{sat_id},Z{sat_id},U{sat_id},V{sat_id},W{sat_id}]= satellite(Xo,Yo,Zo,Uo,Vo,Wo,Tf);
end

% This script plots Earth surface. Data file earth_topo.mat 
% has the earth topographical data. The axes are normalized by 10^6 m.

Re = 6.37e6;
load('earth_topo.mat'); 
[x,y,z] = sphere(50);
s = surf(Re*x/1e6,Re*y/1e6,Re*z/1e6); % create a sphere
s.CData = topo;                % set color data to topographic data
s.FaceColor = 'texturemap';    % use texture mapping
s.EdgeColor = 'none';          % remove edges
s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
s.SpecularStrength = 0.4;      % change the strength of the reflected light
grid on; box on; axis equal;
axis(7*[-1 1 -1 1 -1 1]);  % IMPORTANT: axis unit is in 10^6 m
xlabel('x (10^6 m)'); ylabel('y (10^6 m)'); zlabel('z (10^6 m)'); title('Earth');
set(gca,'LineWidth',1,'FontSize',14, ...
        'Xtick',[-6:4:6],'Ytick',[-6:4:6],'Ztick',[-6:4:6]);
hold on;
plot3(X{1}/1e6,Y{1}/1e6,Z{1}/1e6,'-k','LineWidth',2)
hold on;
plot3(X{sat_id}(end)/1e6,Y{sat_id}(end)/1e6,Z{sat_id}(end)/1e6,'om','MarkerSize',5,'MarkerFaceColor','auto')
legend('Earth','Satellite 1 Trajectory','Satellite 1 End Position')


p1b = 'see figure1';


%% Task 2 
Tf = 12400;

for sat_id = 1:6
   
    [Xo,Yo,Zo,Uo,Vo,Wo] = read_input('satellite_data.txt',sat_id);
    [T{sat_id},X{sat_id},Y{sat_id},Z{sat_id},U{sat_id},V{sat_id},W{sat_id}]= satellite(Xo,Yo,Zo,Uo,Vo,Wo,Tf);
    alt{sat_id}  = sqrt(X{sat_id}.^2 + Y{sat_id}.^2 + Z{sat_id}.^2) - Re;
    Vmag{sat_id} = sqrt(U{sat_id}.^2 + V{sat_id}.^2 + W{sat_id}.^2); % where i got stuck was that i didnt put {sat_id} and basically that meant to make it into a vector given the iteration of sat id
    
end

figure(2);
cs='krbgcm';
subplot(2,1,1);hold on;
for sat_id = 1:6
    plot(T{sat_id},alt{sat_id},cs(sat_id),'LineWidth',1)
    leg{sat_id} = sprintf('ID: %03d',sat_id);
end
xlabel('time (s)');
ylabel('altitude(m)');
title('Altitude v Time');
legend(leg);

subplot (2,1,2);hold on;
for sat_id = 1:6
    plot(T{sat_id},Vmag{sat_id},cs(sat_id),'LineWidth',1)
    leg{sat_id} = sprintf('ID: %03d',sat_id);
end
xlabel('time (s)');
ylabel('Speed(m/s)');
title('Speed v Time');
legend(leg);
box on; grid on; axis tight;

for sat_id = 1:6
   stat(sat_id).sat_id = sat_id; % this created structure stat for interval 1:6, field sat_id
   stat(sat_id).final_position = [X{sat_id}(end), Y{sat_id}(end), Z{sat_id}(end)];
   stat(sat_id).final_velocity =[U{sat_id}(end), V{sat_id}(end), W{sat_id}(end)];
   counter = 0;
   for k = 2:length(alt{sat_id})-1
       if alt{sat_id}(k-1) < alt{sat_id}(k) && alt{sat_id}(k) > alt{sat_id}(k+1)
           counter = counter+1; % basically dooing that little matrix thing to check for local maxima
           stat(sat_id).time_lmax_altitude(counter) = T{sat_id}(k)
       end

   end
    stat(sat_id).orbital_period = stat(sat_id).time_lmax_altitude(2) - stat(sat_id).time_lmax_altitude(1);
    

end

% writing report -- so this opens the files and covers ch 9 .
fid = fopen('report.txt','w');
fprintf(fid,'%s\n',name); 
fprintf(fid,'%s\n', id);
fprintf(fid, 'satellite ID, travel distance(m), orbital period(s)\n');
for sat_id = 1:6
    travel_dist = sum(sqrt(diff(X{sat_id}).^2 + diff(Y{sat_id}).^2 + diff(Z{sat_id}).^2));
    fprintf(fid,'%d\t%15.9e\t%15.9e\n',sat_id, travel_dist,stat(sat_id).orbital_period);
end


fclose(fid);
p2a = evalc('help read_input');p2b = 'see figure 2';
p2c = stat(1);p2d=stat(2);p2e=stat(3);p2f=stat(4);p2g=stat(5);p2h=stat(6);
p2i=evalc('type report.txt');

%% Task 3
Tf = 6000;
for sat_id = 1:520
    [Xo,Yo,Zo,Uo,Vo,Wo] = read_input('satellite_data.txt',sat_id);
    [T{sat_id},X{sat_id},Y{sat_id},Z{sat_id},U{sat_id},V{sat_id},W{sat_id}]= satellite(Xo,Yo,Zo,Uo,Vo,Wo,Tf);
    
end

xtar = -5.5e6;
ytar = -3.9e6;
ztar = 0;
counter3=0;
for sat_id=1:520
    dist = sqrt(   (X{sat_id}(1)-xtar)^2  +(Y{sat_id}(1)-ytar)^2+(Z{sat_id}(1)-ztar)^2);
    if dist<=2000000
        counter3=counter3+1;
        cluster_sid(counter3) = sat_id;

    end
end
    
figure(3);

subplot(1,2,1); hold on;

for sat_id = 1:520
    plot3(X{sat_id}(1)/1e6,Y{sat_id}(1)/1e6,Z{sat_id}(1)/1e6,'mo','MarkerFaceColor','m','MarkerSize',3);
    view(3)
end

for sat_id = 1:numel(cluster_sid)
    plot3(X{cluster_sid(sat_id)}(1)/1e6,Y{cluster_sid(sat_id)}(1)/1e6,Z{cluster_sid(sat_id)}(1)/1e6,'bo','MarkerFaceColor','b','MarkerSize',6);
end
title('Initial position at t=0');

Re = 6.37e6;
load('earth_topo.mat'); 
[x,y,z] = sphere(50);
s = surf(Re*x/1e6,Re*y/1e6,Re*z/1e6); % create a sphere
s.CData = topo;                % set color data to topographic data
s.FaceColor = 'texturemap';    % use texture mapping
s.EdgeColor = 'none';          % remove edges
s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
s.SpecularStrength = 0.4;      % change the strength of the reflected light
grid on; box on; axis equal;
axis(7*[-1 1 -1 1 -1 1]);  % IMPORTANT: axis unit is in 10^6 m
xlabel('x (10^6 m)'); ylabel('y (10^6 m)'); zlabel('z (10^6 m)'); title('Earth');
set(gca,'LineWidth',1,'FontSize',14, ...
        'Xtick',[-6:4:6],'Ytick',[-6:4:6],'Ztick',[-6:4:6]);

subplot(1,2,2); hold on;

for sat_id = 1:520
    plot3(X{sat_id}(end)/1e6,Y{sat_id}(end)/1e6,Z{sat_id}(end)/1e6,'mo','MarkerFaceColor','m','MarkerSize',3);
    view(3)
end

for sat_id = 1:numel(cluster_sid)
    plot3(X{cluster_sid(sat_id)}(end)/1e6,Y{cluster_sid(sat_id)}(end)/1e6,Z{cluster_sid(sat_id)}(end)/1e6,'bo','MarkerFaceColor','b','MarkerSize',6);
end
title('Final position at t=6000');

Re = 6.37e6;
load('earth_topo.mat'); 
[x,y,z] = sphere(50);
s = surf(Re*x/1e6,Re*y/1e6,Re*z/1e6); % create a sphere
s.CData = topo;                % set color data to topographic data
s.FaceColor = 'texturemap';    % use texture mapping
s.EdgeColor = 'none';          % remove edges
s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
s.SpecularStrength = 0.4;      % change the strength of the reflected light
grid on; box on; axis equal;
axis(7*[-1 1 -1 1 -1 1]);  % IMPORTANT: axis unit is in 10^6 m
xlabel('x (10^6 m)'); ylabel('y (10^6 m)'); zlabel('z (10^6 m)'); title('Earth');
set(gca,'LineWidth',1,'FontSize',14, ...
        'Xtick',[-6:4:6],'Ytick',[-6:4:6],'Ztick',[-6:4:6]);

p3a = 'see figure 3';
p3b = 'closest';
p3c = 'decrease';