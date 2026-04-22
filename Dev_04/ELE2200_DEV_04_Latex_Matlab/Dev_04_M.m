%% Devoir 4
% Question 1: Étude du modèle avec contrôleur PID
% a) Diagrammes fonctionnels en BO et en BF

% Chemin vers le dossier figures du projet LaTeX
fig_path = '../ELE2200_DEV_04_Latex/figures/';

% Taille par défaut de toutes les figures (4:3)
set(0, 'DefaultFigurePosition', [100, 100, 560, 420]);

% Déclaration des variables utilisées dans simulink
p1 = 0.03;
p2 = 0.02;
p3 = 1.06*(10^-5);
n = 0.3;
Gb = 92;
Ib = 7.3;
% Initialisation des gains du contrôleur PID
Kp = 0;
Kd = 0;
Ki = 0;
% Initialisation des conditions initiales des intégrateurs et des entrées
x0 = [0; 0; 0];
u0 = [0; 0];
m_value = 5;
%print -dpng -s BergmanInOut_incomplet.png;
%print -dpng -s BergmanInOutBF_incomplet.png;
% b) Point d'équilibre du système en BO

% Conditions initiales 
x0 = [92; 0; 7.3];
u0 = [0; 0];
[x_BO, u_BO, y_BO, dx_BO] = trim("BergmanInOut_incomplet", x0, u0)
% Vérification de l'ordre dans lequel les variables d'états d'équilibre
% sont retournées par la fonction trim()
[sizes, x0, noms] = feval('BergmanInOut_incomplet', [], [], [], 'sizes');
disp(noms);
% Les valeurs d'équilibre des variables d'états I(t) et X(t) sont donc
% inversées dans les valeurs retournées par trim()
% c) Point d'équilibre du système en BF

% On suppose que les valeurs des constantes du PID sont les suivantes
Kp = 0.5;
Kd = 0.01;
Ki = 0.1;
% Conditions initiales 
x0 = [92; 0; 7.3; 0];   % Une condition initiale de plus pour l'intégrateur du PID
u0 = [0; 0];
[x_BF, u_BF, y_BF, dx_BF] = trim("BergmanInOutBF_incomplet", x0, u0)
% Vérification de l'ordre dans lequel les variables d'états d'équilibre
% sont retournées par la fonction trim()
[sizes, x0, noms] = feval('BergmanInOutBF_incomplet', [], [], [], 'sizes');
disp(noms);
% d) Trouver Gu et Gm pour le système en BO

[A_BO, B_BO, C_BO, D_BO] = linmod("BergmanInOut_incomplet", x_BO, u_BO);  % Linéarisation
ModEtat_BO = ss(A_BO, B_BO, C_BO, D_BO);   % Créer un modèle d'état 
FT_BO = tf(ModEtat_BO)                     % Extraire les fonctions de transfert du modèle d'état
Gu_BO = minreal(FT_BO(1))                  % Gu(s) en boucle ouverte 
Gm_BO = minreal(FT_BO(2))                  % Gm(s) en boucle ouverte
% e) Trouver Gu et Gm pour le système en BF

[A_BF, B_BF, C_BF, D_BF] = linmod("BergmanInOutBF_incomplet", x_BF, u_BF); % Linéarisation
ModEtat_BF = ss(A_BF, B_BF, C_BF, D_BF);  % Créer un modèle d'état 
FT_BF = tf(ModEtat_BF)                     % Extraire les fonctions de transfert du modèle d'état
Gu_BF = minreal(FT_BF(1))                  % Gu(s) en boucle fermée
Gm_BF = minreal(FT_BF(2))                  % Gm(s) en boucle fermée
eig(A_BO)                 % Pôles du système en boucle ouverte
eig(A_BF)                 % Pôles du système en boucle fermée
% Système stable dans les deux cas
% f) Critère de Routh-Hurwitz pour le système en BF

% Graphe pour visualiser la condition sur b1 (table de Routh-Hurwitz)
figure(1);
x = linspace(-0.5, 0.5, 500);
y = 0.6251856*x.^2 + 0.17044478*x + 0.0052834;
plot(x,y,'Color','b');
grid on
xticks(-0.5:0.1:0.5);
title("Graphe de la condition sur $b_1$","Interpreter","latex")
legend("$0.6251856K_p^{2}+0.17044478K_p+0.0052834$","Interpreter","latex","Location","northwest")
% g) LDR du système en boucle fermée avec contrôleur PID

% Utiliser rltool pour le lieu des racines
s = tf("s");
Correcteur = -(Kd*(s^2) + Kp*s + Ki)/s;
%rltool(Gu_BO, Correcteur)
% h) Erreur en régime permanent du système linéarisé avec contrôleur

out0 = sim("BF_Q1_ERP.slx", 'Solver','ode45','StopTime','2000');
plot(out0.ERP(:,1), out0.ERP(:,2), "Color","b");
grid on
title("Graphe de G(t) en BF lin\'earis\'e pour $\delta u(t)=2H_s(t)$ et $\delta m(t)=0$", "Interpreter","Latex");
xlabel("temps (s)", "Interpreter","Latex");
ylabel("Glyc\'emie G(t) (mg/dL)","Interpreter","latex");
saveas(gcf, fullfile(fig_path, 'Q1h_erp.png'));
% Question 2: Commande de la glycémie en présence de perturbations
% a) Simulation du système non linéaire sans contrôleur

x0 = [92, 0, 7.3];  % conditions initiales
figure(2);
out1 = sim("BO_Q2.slx", 'Solver','ode45','StopTime','400');
plot(out1.GBO_Q2(:,1), out1.GBO_Q2(:,2), "Color","b");
grid on
title("Graphe de G(t) en BO pour u(t)=2$H_s(t)$ et m(t)=$5\chi_{[0,5]}(t)$", "Interpreter","Latex");
xlabel("temps (s)", "Interpreter","Latex");
ylabel("Glyc\'emie G(t) (mg/dL)","Interpreter","latex");
saveas(gcf, fullfile(fig_path, 'Q2a_BO_glycemie.png'));
% La glycémie se stabilise dans la zone de sécurité
% b) Simulation du système non linéaire avec contrôleur

figure(3);
out3 = sim("BF_Q2.slx", 'Solver','ode45','StopTime','400');
plot(out3.GBF_Q2(:,1), out3.GBF_Q2(:,2), "Color","b");
grid on
title("Graphe de G(t) en BF pour u(t)=2$H_s(t)$ et m(t)=$5\chi_{[0,5]}(t)$", "Interpreter","Latex");
xlabel("temps (s)", "Interpreter","Latex");
ylabel("Glyc\'emie G(t) (mg/dL)","Interpreter","latex");
saveas(gcf, fullfile(fig_path, 'Q2b_BF_glycemie.png'));
figure(4);
plot(out1.GBO_Q2(:,1), out1.GBO_Q2(:,2), "Color","b");
hold on
plot(out3.GBF_Q2(:,1), out3.GBF_Q2(:,2), "Color","r");
grid on
title("Graphe de G(t) pour u(t)=2$H_s(t)$ et m(t)=$5\chi_{[0,5]}(t)$", "Interpreter","Latex");
xlabel("temps (s)", "Interpreter","Latex");
ylabel("Glyc\'emie G(t) (mg/dL)","Interpreter","latex");
legend("boucle ouverte", "boucle ferm\'ee","Interpreter", "Latex", "Location","best");
saveas(gcf, fullfile(fig_path, 'Q2b_comparaison_BO_BF.png'));
% Question 3: Robustesse du système de pancréas artificiel
% Export du schéma Simulink BF_Q3

open_system('BF_Q3');
print('-sBF_Q3', '-dpng', fullfile(fig_path, 'SchemaQ3.png'));
% a) Comparaison modèle linéarisé à non linéaire

figure(5);
clf;
[num_u, den_u] = tfdata(Gu_BF, 'v');
[num_m, den_m] = tfdata(Gm_BF, 'v');
out3a = sim("BF_Q3.slx", 'Solver','ode45','StopTime','400');
h1 = plot(out3a.GBF_Q3(:,1), out3a.GBF_Q3(:,2), "Color","g");
hold on
h2 = plot(out3.GBF_Q2(:,1), out3.GBF_Q2(:,2), "Color","r");
grid on
title("Comparaison lin\'earis\'e vs non lin\'eaire ($K_p=0.5$)", "Interpreter","Latex");
xlabel("temps (s)", "Interpreter","Latex");
ylabel("Glyc\'emie G(t) (mg/dL)","Interpreter","latex");
legend([h1, h2], {"Lin\'earis\'e", "Non lin\'eaire"}, "Interpreter","Latex", "Location","best");
saveas(gcf, fullfile(fig_path, 'Q3a_lin_nonlin.png'));
hold off;
% b) Effet de l'augmentation de Kp sur la réponse du modele linéarisée

%% Paramètres de la plage de Kp
Kp_start = 0.5;
Kp_end   = 10.0;
Kp_step  = 2;

Kd = 0.01;
Ki = 0.1;
m_value=5;
figure(6);
clf;
hold on

handles = gobjects(0);
legend_entries = {};
idx = 0;

for Kp = Kp_start : Kp_step : Kp_end

    x0 = [92; 0; 7.3; 0];
    u0 = [0; 0];

    [x_BF, u_BF, ~, ~] = trim("BergmanInOutBF_incomplet", x0, u0);
    [A_BF, B_BF, C_BF, D_BF]= linmod("BergmanInOutBF_incomplet", x_BF, u_BF);
    ModEtat_BF= ss(A_BF, B_BF, C_BF, D_BF);
    FT_BF= tf(ModEtat_BF);
    Gu_BF= minreal(FT_BF(1));
    Gm_BF= minreal(FT_BF(2));
    [num_u, den_u]= tfdata(Gu_BF, 'v');
    [num_m, den_m]= tfdata(Gm_BF, 'v');

    out3a = sim("BF_Q3.slx", 'Solver','ode45','StopTime','400','MaxStep','0.1');

    idx = idx + 1;
    handles(idx) = plot(out3a.GBF_Q3(:,1), out3a.GBF_Q3(:,2));
    legend_entries{idx} = sprintf("Lin\\'earis\\'e $K_p=%.2f$", Kp);
end

idx = idx + 1;
handles(idx) = plot(out3.GBF_Q2(:,1), out3.GBF_Q2(:,2), 'k--', 'LineWidth', 1.5);
legend_entries{idx} = "Non lin\'eaire";

legend(handles, legend_entries, "Interpreter","Latex", "Location","best");

%% Mise en forme
grid on
title("Comparaison lin\'earis\'e vs non lin\'eaire pour diff\'erents $K_p$", "Interpreter","Latex");
xlabel("temps (s)", "Interpreter","Latex");
ylabel("Glyc\'emie G(t) (mg/dL)", "Interpreter","Latex");
saveas(gcf, fullfile(fig_path, 'Q3b_effet_Kp.png'));
hold off
% c) Comparaison modèle linéarisé à non linéaire

%% Paramètres de la plage de Kp
  
Kp=5;
m_value=50;

[x_BF, u_BF, ~, ~]        = trim("BergmanInOutBF_incomplet", x0, u0);
[A_BF, B_BF, C_BF, D_BF]  = linmod("BergmanInOutBF_incomplet", x_BF, u_BF);
ModEtat_BF                 = ss(A_BF, B_BF, C_BF, D_BF);
FT_BF                      = tf(ModEtat_BF);
Gu_BF                      = minreal(FT_BF(1));
Gm_BF                      = minreal(FT_BF(2));
[num_u, den_u]             = tfdata(Gu_BF, 'v');
[num_m, den_m]             = tfdata(Gm_BF, 'v');


out3a = sim("BF_Q3.slx", 'Solver','ode45','StopTime','400','MaxStep','0.1');
plot(out3a.GBF_Q3(:,1), out3a.GBF_Q3(:,2));
grid on
title("Comparaison lin\'earis\'e vs non lin\'eaire pour diff\'erents $K_p$", "Interpreter","Latex");
xlabel("temps (s)", "Interpreter","Latex");
ylabel("Glyc\'emie G(t) (mg/dL)", "Interpreter","Latex");
saveas(gcf, fullfile(fig_path, 'Q3c_robustesse.png'));