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
[A, B, C, D] = linmod('Schema_Fonctionnel_angle')
sys = ss(A,B,C,D)
H = tf(sys)
display(H)

% ---- Q1(b) : Réponse indicielle ----

% À COMPLÉTER : Tracer la réponse indicielle de theta sur 3 secondes

figure(1)
out1 = sim('Schema_Fonctionnel_angle.slx','Solver','ode1','FixedStep','0.01','StopTime','3');
plot(out1.Y1(:,1), out1.Y1(:,2))
grid on
hold on
plot(out1.Y1(:,1), out1.Y1(:,3))
titre = 'Graphe de $\theta_{ref}(t)$ et de $\theta(t)$';
title(titre, 'Interpreter','latex')
abscisse = 'Temps (secondes)';
xlabel(abscisse,'Interpreter', 'latex')
ordonnee = '$\theta$ (en radians)';
ylabel(ordonnee,'Interpreter','latex')
xlim([0,3])
legende1 = '$\theta_{ref}(t)$';
legende2 = '$\theta$(t)';
legend(legende1, legende2,'Interpreter','latex')
hold off

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

[E, F, G, J] = linmod('Question2');
sys = ss(E,F,G,J);
Y = tf(sys);
display(Y);

% ---- Q2(b) : FT boucle x : X(s)/X_ref(s) ----

% À COMPLÉTER : Calculer la fonction de transfert H_x(s)
% H_x = ...


% ---- Q2(c) : Réponses indicielles ----

% À COMPLÉTER : Tracer les réponses indicielles de x et y sur 10 secondes
% et comparer les deux réponses


%% ====================================================================
%  QUESTION 3 — Modèle réduit vs modèle complet
%  ====================================================================

fprintf('===================== QUESTION 3 =====================\n\n');

% ---- Q3(a) : Réponses indicielles comparées ----
fprintf('Q3(a) — Réponses indicielles : modèle réduit vs modèle complet\n\n');

x0 = [0; 0; 0; 0; 0; 0]; % [x, dx, y, dy, theta, dtheta]
isQ3a = true; % Cette variable sert à activer le "step" en entrée xref
T_att = 15;

% Simulation des deux modèles (conditions initiales à compléter dans Simulink !)
data_simp = sim("modele_simplifie.slx");
data_cpl = sim("modele_complet.slx");

% À COMPLÉTER : Extraire les données et tracer la comparaison


%% ---- Q3(c) : Réponses indicielles comparées ----
fprintf('Q3(c) — Simulation complète avec conditions initiales\n\n');

isQ3a = false;

% Conditions initiales (À COMPLÉTER)
x0_pos = % Position initiale x (m)
y0_pos = % Position initiale y (m)
vx0    = % Vitesse initiale x (m/s)
vy0    = % Vitesse initiale y (m/s)

x0 = [x0_pos; vx0; y0_pos; vy0; 0; 0]; % [x, dx, y, dy, theta, dtheta]
T_att = 20;

% Simulation des deux modèles
data_simp = sim("modele_simplifie.slx");
data_cpl = sim("modele_complet.slx");

% À COMPLÉTER : Extraire les données et créer la figure avec 3 subplots


%% ---- Q3(d) : Export et visualisation dans le simulateur web ----
fprintf('Q3(d) — Export pour le simulateur web...\n');

% >>> EXÉCUTEZ cette section : elle appelle export_simulateur.m qui lit
%     data_cpl depuis le workspace, génère trajectory_data.js et ouvre
%     automatiquement le simulateur d'atterrissage dans le navigateur. <<<
export_simulateur;

fprintf('\n===================================================================\n');
fprintf('  SCRIPT TERMINÉ\n');
fprintf('===================================================================\n');
