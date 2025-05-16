clear; clc; close all;

%vstupne parametre:
t = [0 1 2 3];
rychlost_Laveho_kolesa  = [0.5 0.5 1 0.3];
rychlost_Praveho_kolesa  = [0.5 1 1 0.2];
delta_t = 0.01;     % časový krok
L = 0.2;            % rozchod kolies v metroch

if length(t) ~= length(rychlost_Laveho_kolesa) || length(t) ~= length(rychlost_Praveho_kolesa)
    error('Vektory t, rychlost_Laveho_kolesa a rychlost_Praveho_kolesa musia mať rovnakú dĺžku.');
end

x = 0;
y = 0;
uhol = 0;
xt = [];
yt = [];
xL = [];
yL = [];
xR = [];
yR = [];
tt = [];
vt_celkovy = [];
vl_celkovy = [];
vr_celkovy = [];

for i = 1:length(t)-1
    t_start = t(i);
    t_end = t(i+1);
    vl = rychlost_Laveho_kolesa(i);
    vr = rychlost_Praveho_kolesa(i);
    
    vt = (vl + vr)/2;
    omegat = (vr - vl)/L;

    cas = t_start;
    while cas < t_end
        uhol = uhol + omegat * delta_t;
        %poloha taziska:
        x = x + vt * cos(uhol) * delta_t;
        y = y + vt * sin(uhol) * delta_t;
        %poloha kolies:
        x_l = x - (L/2)*sin(uhol);
        y_l = y + (L/2)*cos(uhol);
        x_r = x + (L/2)*sin(uhol);
        y_r = y - (L/2)*cos(uhol);
        %ulozim do vektorov:
        xt(end+1) = x;
        yt(end+1) = y;
        xL(end+1) = x_l;
        yL(end+1) = y_l;
        xR(end+1) = x_r;
        yR(end+1) = y_r;
        tt(end+1) = cas;
        vt_celkovy(end+1) = vt;
        vl_celkovy(end+1) = vl;
        vr_celkovy(end+1) = vr;

        cas = cas + delta_t;
    end
end

%posledny, vzdy trojsekundovy usek, ked maju kolesa posledne rychlosti
t_start = t(end);
t_end = t_start + 3;
vl = rychlost_Laveho_kolesa(end);
vr = rychlost_Praveho_kolesa(end);
vt = (vl + vr)/2;
omegat = (vr - vl)/L;
cas = t_start;  
while cas < t_end
    uhol = uhol + omegat * delta_t;
    x = x + vt * cos(uhol) * delta_t;
    y = y + vt * sin(uhol) * delta_t;
    x_l = x - (L/2)*sin(uhol);
    y_l = y + (L/2)*cos(uhol);
    x_r = x + (L/2)*sin(uhol);
    y_r = y - (L/2)*cos(uhol);
    xt(end+1) = x;
    yt(end+1) = y;
    xL(end+1) = x_l;
    yL(end+1) = y_l;
    xR(end+1) = x_r;
    yR(end+1) = y_r;
    tt(end+1) = cas;
    vt_celkovy(end+1) = vt;
    vl_celkovy(end+1) = vl;
    vr_celkovy(end+1) = vr;
    cas = cas + delta_t;
end


%vykreslenie rychlostí
figure;
subplot(2,3,1);
plot(tt, vt_celkovy, 'k', 'LineWidth', 1);
xlabel('čas [s]'); ylabel('vt [m/s]');
title('Rychlost taziska'); grid on;

subplot(2,3,2);
plot(tt, vr_celkovy, 'b', 'LineWidth', 1);
xlabel('čas [s]'); ylabel('vr [m/s]');
title('Rychlost praveho kolesa'); grid on;

subplot(2,3,3);
plot(tt, vl_celkovy, 'r', 'LineWidth', 1);
xlabel('čas [s]'); ylabel('vl [m/s]');
title('Rychlost laveho kolesa'); grid on;

%vykreslenie trajektorie
figure;
plot(xt, yt, 'k', 'LineWidth', 2);
hold on;
plot(xL, yL, 'r--', 'LineWidth', 1);
plot(xR, yR, 'b--', 'LineWidth', 1);
legend('Ťažisko', 'Ľavé koleso', 'Pravé koleso');
xlabel('x [m]');
ylabel('y [m]');
title('trajektoria podla vektorov');
axis equal;
grid on;
%robot v konecnej polohe:
plot(xL(end), yL(end), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'HandleVisibility', 'off');
plot(xR(end), yR(end), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b', 'HandleVisibility', 'off');
plot(xt(end), yt(end), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k', 'HandleVisibility', 'off');
plot([xL(end) xt(end) xR(end)], [yL(end) yt(end) yR(end)], 'k-', 'LineWidth', 1, 'HandleVisibility', 'off');
