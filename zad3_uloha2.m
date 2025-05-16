clear; clc; close all;

strana = input('Zadaj dĺžku strany štvorca (m): ');

v = 1;              % rýchlosť kolies v m/s
L = 0.2;            % rozchod kolies v metroch
delta_t = 0.0001;  %casovy inkrement

t_ciara = strana / v;
t_otocka = (pi * L) / 4;

x = 0;
y = 0;
uhol = 0;
t_global = 0;

%vektory ktore chcem vykreslovat:
vt = []; vl = []; vr = [];
xt = []; yt = [];
xr = []; yr = [];
xl = []; yl = [];
tt = [];

for i = 1:4
    %rovna ciara
    t = 0;
    while t < t_ciara
        [x, y, uhol, vl_krok, vr_krok, vt_krok] = rovno(x, y, uhol, v, delta_t, L);
        [x_l, y_l, x_r, y_r] = polohy_kolies(x, y, uhol, L);

        %ulozim vypocitane hodnoty do vektorov:
        xt(end+1) = x;
        yt(end+1) = y;
        xl(end+1) = x_l;
        yl(end+1) = y_l;
        xr(end+1) = x_r;
        yr(end+1) = y_r;
        vl(end+1) = vl_krok;
        vr(end+1) = vr_krok;
        vt(end+1) = vt_krok;
        t_global = t_global + delta_t;
        tt(end+1) = t_global;

        t = t + delta_t;
    end

    %zabocenie
    t = 0;
    while t < t_otocka
        [x, y, uhol, vl_krok, vr_krok, vt_krok] = zabacanie(x, y, uhol, v, delta_t, L);
        [x_l, y_l, x_r, y_r] = polohy_kolies(x, y, uhol, L);

        %ulozim vypocitane hodnoty do vektorov:
        xt(end+1) = x;
        yt(end+1) = y;
        xl(end+1) = x_l;
        yl(end+1) = y_l;
        xr(end+1) = x_r;
        yr(end+1) = y_r;
        vl(end+1) = vl_krok;
        vr(end+1) = vr_krok;
        vt(end+1) = vt_krok;
        t_global = t_global + delta_t;
        tt(end+1) = t_global;

        t = t + delta_t;
    end
end

%priebehy rychlostí:
figure;
subplot(2,3,1);
plot(tt, vt, 'k', 'LineWidth', 1);
title('Rýchlosť ťažiska');
grid on;
xlabel('čas [s]');
ylabel('v_t [m/s]');

subplot(2,3,2);
plot(tt, vr, 'b', 'LineWidth', 1);
title('Pravé koleso');
grid on;
xlabel('čas [s]');
ylabel('v_r [m/s]');

subplot(2,3,3);
plot(tt, vl, 'r', 'LineWidth', 1);
title('Ľavé koleso');
grid on;
xlabel('čas [s]');
ylabel('v_l [m/s]');


%vykreslenie trajektorie:
figure;
plot(xt, yt, 'k', 'LineWidth', 2);
hold on;
plot(xl, yl, 'r--', 'LineWidth', 1);
plot(xr, yr, 'b--', 'LineWidth', 1);
xlabel('x [m]');
ylabel('y [m]');
axis equal;
grid on;
title('Trajektória robota po štvorci');
%robot v konecnej polohe (vlastne tu aj v zaciatocnej):
plot(xl(end), yl(end), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'HandleVisibility', 'off');
plot(xr(end), yr(end), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b', 'HandleVisibility', 'off');
plot(xt(end), yt(end), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k', 'HandleVisibility', 'off');
plot([xl(end), xt(end), xr(end)], [yl(end), yt(end), yr(end)], 'k-', 'HandleVisibility', 'off');

% funkcie na pocitanie polohy:
function [x, y, uhol, vl, vr, vt] = rovno(x, y, uhol, v, dt, L)
    vl = v;
    vr = v;
    vt = (vl + vr)/2;
    omega = (vr - vl)/L;
    uhol = uhol + omega * dt;
    x = x + vt * cos(uhol) * dt;
    y = y + vt * sin(uhol) * dt;
end

function [x, y, uhol, vl, vr, vt] = zabacanie(x, y, uhol, v, dt, L)
    vl = -v;
    vr =  v;
    vt = (vl + vr)/2;
    omega = (vr - vl)/L;
    uhol = uhol + omega * dt;
    x = x + vt * cos(uhol) * dt;
    y = y + vt * sin(uhol) * dt;
end

function [x_l, y_l, x_r, y_r] = polohy_kolies(x, y, theta, L)
    x_l = x - (L/2) * sin(theta);
    y_l = y + (L/2) * cos(theta);
    x_r = x + (L/2) * sin(theta);
    y_r = y - (L/2) * cos(theta);
end
