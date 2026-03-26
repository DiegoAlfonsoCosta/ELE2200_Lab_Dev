%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ELE2200 : Systemes et simulations         %%%
%%% Labo4   : Premieres notions de controle   %%%
%%%           Exemple du Pendule Inversé      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------------------------%
% Donnees numeriques de la modelisation du pendule  %
%---------------------------------------------------%
m = 1;
l = 0.5;
M = 1;
g = 9.81;


%---------------------------------------------------%
% Modele d'etat obtenu apres linearisation          %
%---------------------------------------------------%
% Point d'equilibre pour X = [x, xdot, theta, thetadot]:
% X_e = [0 0 0 0]^T, U_e = 0

A = [ 0 1     0     0;
      0 0   m*g/M   0;
      0 0     0     1;
      0 0 (M+m)*g/(l*M) 0 ];

B = [ 0 1/M 0 1/(M*l) ]';
C = [ 0  0  1  0;
      1  0  0  0 ];
D = [ 0  0 ]';

sys = ss(A,B,C,D)

% Fonction de transfert G1 = delta_theta / delta_u 
G1 = zpk(sys(1,1))
pole(G1)

% Fonction de transfert G2 = delta_x / delta_u 
G2 = zpk(sys(2,1))
pole(G2)


%---------------------------------------------------%
% Gains des correcteurs                             %
%---------------------------------------------------%

% Kp1 = 
% Kd1 =
% Kp2 = 
% Kd2 =

