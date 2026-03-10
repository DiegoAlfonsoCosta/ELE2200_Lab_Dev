%% SCRIPT DE TRAVAIL — Devoir 2 ELE2200 (Hiver 2026)
%  Atterrissage vertical d'une fusée — Contrôle en cascade
%
%  Prérequis : les schémas Simulink modele_simplifie.slx et
%              modele_complet.slx doivent être dans le même dossier.
%

clear; close all; clc;

%% ====================================================================
%  PARAMETRES DU SYSTEME (communs à toutes les questions)
%  ====================================================================
m  = 1000;    % Masse (kg)
J  = 6000;    % Moment d'inertie (kg.m^2)
d  = 4;       % Distance CG-tuyère (m)
g  = 9.81;    % Gravité (m/s^2)
Ts = 0.01;    % Pas de simulation Simulink (s)

fprintf('===================================================================\n');
fprintf('  Devoir 2 ELE2200 — Atterrissage de fusée\n');
fprintf('===================================================================\n\n');

%% ====================================================================
%  QUESTION 1 — Asservissement de l'angle theta
%  ====================================================================

fprintf('===================== QUESTION 1 =====================\n\n');

% ---- Q1(a) : Fonction de transfert Theta/Theta_ref ----

% À COMPLÉTER : Calculer la fonction de transfert H_theta(s)
% H_theta = ...
Kpo = 39.5;
Kio = 0.6;
Kdo = 13.4;

[A, B, C, D] = linmod('Schema_Fonctionnel_angle');
sys = ss(A,B,C,D);
H = tf(sys);
display(H);

pole(H)

% ---- Q1(b) : Réponse indicielle ----

% À COMPLÉTER : Tracer la réponse indicielle de theta sur 3 secondes

figure(1)
out1 = sim('Schema_Fonctionnel_angle.slx','Solver','ode1','FixedStep','0.01','StopTime','3');
plot(out1.Y1(:,1), out1.Y1(:,2))
grid on
hold on
plot(out1.Y1(:,1), out1.Y1(:,3))
titre = 'Graphe de $\theta_{ref}(t)$ et de $\theta(t)$';
title(titre, 'Interpreter','latex','FontSize',16)
abscisse = 'Temps (secondes)';
xlabel(abscisse,'Interpreter', 'latex','FontSize',12)
ordonnee = '$\theta$ (en radians)';
ylabel(ordonnee,'Interpreter','latex','FontSize',12)
xlim([0,3])
legende1 = '$\theta_{ref}(t)$';
legende2 = '$\theta$(t)';
legend(legende1, legende2,'Interpreter','latex','FontSize',16)
hold off
print -dpng script_devoir2.png
print -dpng -s Schema_Fonctionnel_angle.png
%% ====================================================================
%  QUESTION 2 — Contrôle de la position en x et y
%  ====================================================================

fprintf('===================== QUESTION 2 =====================\n\n');

% ---- Q2(a) : FT boucle y : Y(s)/Y_ref(s) ----

% À COMPLÉTER : Calculer la fonction de transfert H_y(s)
% H_y = ...
Kpy = 75000;
Kiy = 125000;
Kdy = 15000;

[E, F, G, J] = linmod('Schema_Y_Q2');
sys = ss(E,F,G,J);
Y = tf(sys);
display(Y);
stepinfo(sys)
print -dpng -s Schema_Y_Q2.png

% ---- Q2(b) : FT boucle x : X(s)/X_ref(s) ----
% À COMPLÉTER : Calculer la fonction de transfert H_x(s)
% H_x = ...
Kpx = -0.440;
Kix = -0.176;
Kdx = -0.367;

[A_s, B_s, C_s, D_s] = linmod('Schema_X_Q2b');
sys2 = ss(A_s,B_s,C_s,D_s);
X = tf(sys2);
display(X);
stepinfo(sys2)
print -dpng -s Schema_X_Q2b.png
print -dpng -s Algebre_X.png

% ---- Q2(c) : Réponses indicielles ----
% À COMPLÉTER : Tracer les réponses indicielles de x et y sur 10 secondes
% et comparer les deux réponses
figure(2)
out2 = sim('Question2.slx','Solver','ode5','FixedStep','0.01','StopTime','10');
plot(out2.YQ2(:,1), out2.YQ2(:,2))
grid on
hold on
plot(out2.YQ2(:,1), out2.YQ2(:,3))
titre1 = 'Graphe de x(t) et de y(t) pour une entrée échelon unité';
title(titre, 'Interpreter','latex', 'FontSize',14)
abscisse1 = 'Temps (secondes)';
xlabel(abscisse1,'Interpreter', 'latex','FontSize',12)
ordonnee1 = 'x et y (en mètres)';
ylabel(ordonnee1,'Interpreter','latex','FontSize',12)
xlim([0,10])
legende3 = '$x(t)$';
legende4 = '$y(t)$';
legend(legende3, legende4,'Interpreter','latex', 'Fontsize',16)
hold off
print -dpng -s Question2.png
print -dpng script_devoirLateX.png

%% ====================================================================
%  QUESTION 3 — Modèle réduit vs modèle complet
%  ====================================================================

fprintf('===================== QUESTION 3 =====================\n\n');

% ---- Q3(a) : Réponses indicielles comparées ----
fprintf('Q3(a) — Réponses indicielles : modèle réduit vs modèle complet\n\n');

x0 = [0; 0; 0; 0; 0; 0]; % [x, dx, y, dy, theta, dtheta]
isQ3a = true; % Cette variable sert à activer le "step" en entrée xref
T_att = 15;

Kptheta=39.5;
Kitheta=0.6;
Kdtheta=13.4;

Kpy =75000;
Kiy =125000;
Kdy =15000;

Kpx =-0.440;
Kix =-0.176;
Kdx =-0.367;

% Conditions initiales (À COMPLÉTER)
x0_pos = 10;% Position initiale x (m)
y0_pos = 50;% Position initiale y (m)
vx0    = -0.1;% Vitesse initiale x (m/s)
vy0    = 0.3;% Vitesse initiale y (m/s)

% Simulation des deux modèles (conditions initiales à compléter dans Simulink !)
data_simp = sim("modele_simplifie.slx");data_cpl = sim("modele_complet.slx");

% À COMPLÉTER : Extraire les données et tracer la comparaison

t  = data_simp.xsimp(:,1);
x_simp = data_simp.xsimp(:,3);
x_cpl  = data_cpl.x2Dsim(:,2);

figure;
plot(t, x_simp, 'b', 'LineWidth', 1.5); hold on;
plot(t,  x_cpl,  'r--', 'LineWidth', 1.5);
grid on;

xlabel('Temps (s)');
ylabel('x (m)');
legend('Modèle simplifié', 'Modèle complet');
title('Comparaison des deux modèles');
print -dpng FigureMatlab/q_3_a.png
close(gcf)

%% ---- Q3(c) : Réponses indicielles comparées ----
fprintf('Q3(c) — Simulation complète avec conditions initiales\n\n');

isQ3a = false;



x0 = [x0_pos; vx0; y0_pos; vy0; 0; 0]; % [x, dx, y, dy, theta, dtheta]
T_att = 20;

% Simulation des deux modèles
data_simp = sim("modele_simplifie.slx");
data_cpl = sim("modele_complet.slx");

% À COMPLÉTER : Extraire les données et créer la figure avec 3 subplots
t  = data_simp.xsimp(:,1);

x_ref = x0_pos .* (1 - tanh(4*t./T_att).^3);
x_simp = data_simp.xsimp(:,3);
x_cpl  = data_cpl.x2Dsim(:,2);

y_ref = y0_pos + (d - y0_pos) .* tanh(4*t./T_att).^5;
y_simp = data_simp.ysimp(:,3);
y_cpl  = data_cpl.x2Dsim(:,4);

theta_ref = data_cpl.thetasim(:,2);
theta_simp = theta_ref;
theta_cpl  = data_cpl.thetasim(:,3);

ref = [ x_ref;y_ref;theta_ref];
simp = [ x_simp;y_simp;theta_simp];
cpl = [ x_cpl;y_cpl;theta_cpl];
legend_txt = { ...
    'x_{ref}',     'x_{simp}',     'x_{cpl}'; ...
    'y_{ref}',     'y_{simp}',     'y_{cpl}'; ...
    '\theta_{ref}','\theta_{simp}','\theta_{cpl}' ...
};

figure;

subplot(3,1,1)
plot(t, x_ref, '--', 'LineWidth', 1.5); hold on
plot(t, x_simp, 'LineWidth', 1.5)
plot(t, x_cpl,  'LineWidth', 1.5)
grid on
ylabel('x (m)')
legend('x_{ref}','x_{simp}','x_{cpl}')
title('Comparaison des deux modèles')

subplot(3,1,2)
plot(t, y_ref, '--', 'LineWidth', 1.5); hold on
plot(t, y_simp, 'LineWidth', 1.5)
plot(t, y_cpl,  'LineWidth', 1.5)
grid on
ylabel('y (m)')
legend('y_{ref}','y_{simp}','y_{cpl}')

subplot(3,1,3)
plot(t, theta_ref, '--', 'LineWidth', 1.5); hold on
plot(t, theta_simp, 'LineWidth', 1.5)
plot(t, theta_cpl,  'LineWidth', 1.5)
grid on
ylabel('\theta (rad)')
xlabel('Temps (s)')
legend('\theta_{ref}','\theta_{simp}','\theta_{cpl}')
print -dpng FigureMatlab/q_3_c.png
close(gcf)

%% ---- Q3(d) : Export et visualisation dans le simulateur web ----
fprintf('Q3(d) — Export pour le simulateur web...\n');

% >>> EXÉCUTEZ cette section : elle appelle export_simulateur.m qui lit
%     data_cpl depuis le workspace, génère trajectory_data.js et ouvre
%     automatiquement le simulateur d'atterrissage dans le navigateur. <<<
export_simulateur;

fprintf('\n===================================================================\n');
fprintf('  SCRIPT TERMINÉ\n');
fprintf('===================================================================\n');
