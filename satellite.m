function [T,X,Y,Z,U,V,W]= satellite(Xo,Yo,Zo,Uo,Vo,Wo,Tf)
%SATELLITE is meant to take the inputs of the initial components of the
%velocity and position as well as the final time. The outputs are vectors
%of time, position, and velocity of satellite trajectories.
%   call function: [T,X,Y,Z,U,V,W]= satellite(Xo,Yo,Zo,Uo,Vo,Wo,Tf)

%% defining constants
Re = 6.37* 10^6;
Me=5.97* 10^24;
G = 6.67408*10^-11;
m=250;
As=0.25;
Pa=5.5*10^-12;
Cd = 2.2;
%% defining variables

%setting columns equal to thier own varibale


% preallocating
n=1;
U(n) = Uo;
V(n)= Vo;
W(n)=Wo;
X(n)=Xo;
Y(n)=Yo;
Z(n)=Zo;
T(n)=0;
% dt is 1 so i can just let it be
%% the for loop.
while T(n)<Tf-1

  
    U(n+1) = U(n) - (((G*Me)*((X(n))/(X(n).^2+Y(n).^2+Z(n).^2).^(3/2)))+((Cd*Pa*As)/(2*m))*U(n)*sqrt(U(n).^2+V(n).^2+(W(n).^2)));
    V(n+1) = V(n) - (((G*Me)*((Y(n))/(X(n).^2+Y(n).^2+Z(n).^2).^(3/2)))+((Cd*Pa*As)/(2*m))*U(n)*sqrt(U(n).^2+V(n).^2+(W(n).^2)));
    W(n+1) = W(n) - (((G*Me)*((Z(n))/(X(n).^2+Y(n).^2+Z(n).^2).^(3/2)))+((Cd*Pa*As)/(2*m))*U(n)*sqrt(U(n).^2+V(n).^2+(W(n).^2)));
    X(n+1) = X(n)+U(n+1);
    Y(n+1)=Y(n)+V(n+1);
    Z(n+1)=Z(n)+W(n+1);
    T(n+1)=T(n)+1;
    n=n+1;
    

end %for loop
end% function

% questions: how do i take the data from the readtable function and use
% scripted/ linear indexing to find what im looking for?