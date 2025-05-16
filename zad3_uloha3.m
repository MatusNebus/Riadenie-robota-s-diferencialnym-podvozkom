clc; clear all; close all;

R1 = input('Polomer prvej krivky: ');
L1 = input('Dĺžka rovnej časti: ');
R2 = input('Polomer druhej krivky: ');

L = 0.2;  %rozchod kolies
delta_t = 0.001; %casovy inkrement
vT = 1; %toto som si povedal, aby som mal jednoduchsie vzorce

%rychlosti kolies pre prvu krivku:
vL1 = vT + L/(2*R1);
vR1 = vT - L/(2*R1);

%rychlosti kolies pre rovnu ciaru:
vR_rovno = vT;
vL_rovno = vT;

%rychlosti kolies pre druhu krivku:
vL2 = vT - L/(2*R2);
vR2 = vT + L/(2*R2);

%vypocty casov tych troch casti
t1 = R1 * (pi/2) / vT;
t2 = L1 / vT;
t3 = R2 * (pi/2) / vT;

x = 0;
y = 0;
uhol = pi/2;
t_global = 0;

% vektory ktore chcem na konci vykreslit:
vt = []; vl = []; vr = [];
xt = []; yt = [];
xr = []; yr = [];
xl = []; yl = [];
tt = [];

%prva krivka:
t = 0;
while t < t1
    vl_krok = vL1;
    vr_krok = vR1;
    vt_krok = (vl_krok + vr_krok)/2;
    omega = (vr_krok - vl_krok)/L;

    uhol = uhol + omega * delta_t;
    x = x + vt_krok * cos(uhol) * delta_t;
    y = y + vt_krok * sin(uhol) * delta_t;

    [x_l, y_l, x_r, y_r] = polohy_kolies(x, y, uhol, L);

    xt(end+1) = x; yt(end+1) = y;
    xl(end+1) = x_l; yl(end+1) = y_l;
    xr(end+1) = x_r; yr(end+1) = y_r;
    vl(end+1) = vl_krok; vr(end+1) = vr_krok; vt(end+1) = vt_krok;
    t_global = t_global + delta_t;
    tt(end+1) = t_global;

    t = t + delta_t;
end

%rovny usek:
t = 0;
while t < t2
    vl_krok = vL_rovno;
    vr_krok = vR_rovno;
    vt_krok = (vl_krok + vr_krok)/2;
    omega = (vr_krok - vl_krok)/L;

    uhol = uhol + omega * delta_t;
    x = x + vt_krok * cos(uhol) * delta_t;
    y = y + vt_krok * sin(uhol) * delta_t;

    [x_l, y_l, x_r, y_r] = polohy_kolies(x, y, uhol, L);

    xt(end+1) = x; yt(end+1) = y;
    xl(end+1) = x_l; yl(end+1) = y_l;
    xr(end+1) = x_r; yr(end+1) = y_r;
    vl(end+1) = vl_krok; vr(end+1) = vr_krok; vt(end+1) = vt_krok;
    t_global = t_global + delta_t;
    tt(end+1) = t_global;

    t = t + delta_t;
end

% druha krivka
t = 0;
while t < t3
    vl_krok = vL2;
    vr_krok = vR2;
    vt_krok = (vl_krok + vr_krok)/2;
    omega = (vr_krok - vl_krok)/L;

    uhol = uhol + omega * delta_t;
    x = x + vt_krok * cos(uhol) * delta_t;
    y = y + vt_krok * sin(uhol) * delta_t;

    [x_l, y_l, x_r, y_r] = polohy_kolies(x, y, uhol, L);

    xt(end+1) = x; yt(end+1) = y;
    xl(end+1) = x_l; yl(end+1) = y_l;
    xr(end+1) = x_r; yr(end+1) = y_r;
    vl(end+1) = vl_krok; vr(end+1) = vr_krok; vt(end+1) = vt_krok;
    t_global = t_global + delta_t;
    tt(end+1) = t_global;

    t = t + delta_t;
end

%priebehy rychlosti:
figure;
subplot(2,3,1);
plot(tt, vt, 'k', 'LineWidth', 1.5);
title('Rýchlosť ťažiska');
xlabel('čas [s]'); ylabel('v_t [m/s]');
grid on;

subplot(2,3,2);
plot(tt, vr, 'b', 'LineWidth', 1.5);
title('Rýchlosť pravého kolesa');
xlabel('čas [s]'); ylabel('v_r [m/s]');
grid on;

subplot(2,3,3);
plot(tt, vl, 'r', 'LineWidth', 1.5);
title('Rýchlosť ľavého kolesa');
xlabel('čas [s]'); ylabel('v_l [m/s]');
grid on;


%vykreslenie trajektorie:
figure;
plot(xt, yt, 'k', 'LineWidth', 2); hold on;
plot(xl, yl, 'r--', 'LineWidth', 1);
plot(xr, yr, 'b--', 'LineWidth', 1);
legend('Ťažisko', 'Ľavé koleso', 'Pravé koleso');
xlabel('x [m]'); ylabel('y [m]');
title('Trajektória robota po krivke');
axis equal; grid on;
%robot v konecnej polohe:
plot(xl(end), yl(end), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'HandleVisibility', 'off');
plot(xr(end), yr(end), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b', 'HandleVisibility', 'off');
plot(xt(end), yt(end), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k', 'HandleVisibility', 'off');
plot([xl(end), xt(end), xr(end)], [yl(end), yt(end), yr(end)], 'k-', 'HandleVisibility', 'off');

%funkcia na pocitanie polohy kolies
function [x_l, y_l, x_r, y_r] = polohy_kolies(x, y, uhol, L)
    x_l = x - (L/2) * sin(uhol);
    y_l = y + (L/2) * cos(uhol);
    x_r = x + (L/2) * sin(uhol);
    y_r = y - (L/2) * cos(uhol);
end








