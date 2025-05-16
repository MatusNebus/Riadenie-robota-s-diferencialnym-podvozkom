clc; clear; close all;

global L xt yt uhol vL vR history running pauza rychlost hSpeedText
L = 0.2;
xt = 0;
yt = 0;
uhol = pi/2;
vL = 0;
vR = 0;
running = true;
pauza = false;
rychlost = 0.2;
history = struct('xt', [], 'yt', [], ...
                 'xl', [], 'yl', [], ...
                 'xr', [], 'yr', [], ...
                 'vT', [], 'vL', [], 'vR', [], ...
                 't', []);

disp("OVLÁDANIE:");
disp("W: dopredu");
disp("S: dozadu");
disp("D: doprava");
disp("A: doľava");
disp("1-5: rýchlosti od 0.1 po 0.5 m/s");
disp("Medzerník: zastaviť (napr. na preskúmanie priebehov rýchlostí)");
disp("Esc: ukončiť");

%hlavny figure pre trajektoriu:
f = figure('KeyPressFcn', @klavesa_stlacena, ...
           'KeyReleaseFcn', @klavesa_pustena, ...
           'CloseRequestFcn', @zavriet, ...
           'NumberTitle', 'off');
ax = axes(f);
hold(ax, 'on');
grid(ax, 'on'); 
axis(ax, 'equal');
xlabel(ax, 'x [m]');
ylabel(ax, 'y [m]');
title(ax, 'Ovládanie robota pomocou klávesnice');
%text pre aktualnu zvolenu rychlost:
hSpeedText = text(ax, 0.02, 0.95, sprintf('Zvolená rýchlosť: %d (%.1f m/s)', rychlost*10, rychlost), ...
                  'Units', 'normalized', 'FontSize', 10, 'BackgroundColor', 'w', ...
                  'EdgeColor', 'k', 'Margin', 2);

hT = plot(ax, NaN, NaN, 'k-', 'LineWidth', 2);
hL = plot(ax, NaN, NaN, 'r--', 'LineWidth', 1);
hR = plot(ax, NaN, NaN, 'b--', 'LineWidth', 1);
hBody = plot(ax, NaN, NaN, 'k-', 'LineWidth', 1.2);
hDots(1) = plot(ax, NaN, NaN, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
hDots(2) = plot(ax, NaN, NaN, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');
hDots(3) = plot(ax, NaN, NaN, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');

%figure pre priebehy rychlosti
f2 = figure('Name', 'Priebehy rýchlostí', 'NumberTitle', 'off');
axVT = subplot(3,1,1); hVT = plot(axVT, NaN, NaN, 'k'); grid on; ylabel('v_T [m/s]'); title('Rýchlosť ťažiska');
axVR = subplot(3,1,2); hVR = plot(axVR, NaN, NaN, 'b'); grid on; ylabel('v_R [m/s]'); title('Rýchlosť pravého kolesa');
axVL = subplot(3,1,3); hVL = plot(axVL, NaN, NaN, 'r'); grid on; ylabel('v_L [m/s]'); xlabel('čas [s]'); title('Rýchlosť ľavého kolesa');

%loop:
simStart = tic;
while running
    if pauza
        pause(0.01);
        continue;
    end

    t = toc(simStart);

    %vypocet pohybu
    vT = (vL + vR) / 2;
    omega = (vR - vL) / L;
    uhol = uhol + omega * 0.01;
    xt = xt + vT * cos(uhol) * 0.01;
    yt = yt + vT * sin(uhol) * 0.01;
    [x_l, y_l, x_r, y_r] = polohy_kolies(xt, yt, uhol, L);

    %ulozim vypocitane hodnoty
    history.xt(end+1) = xt;
    history.yt(end+1) = yt;
    history.xl(end+1) = x_l;
    history.yl(end+1) = y_l;
    history.xr(end+1) = x_r;
    history.yr(end+1) = y_r;
    history.vT(end+1) = vT;
    history.vL(end+1) = vL;
    history.vR(end+1) = vR;
    history.t(end+1) = t;

    %pridam do grafov:
    set(hT, 'XData', history.xt, 'YData', history.yt);
    set(hL, 'XData', history.xl, 'YData', history.yl);
    set(hR, 'XData', history.xr, 'YData', history.yr);
    set(hVT, 'XData', history.t, 'YData', history.vT);
    set(hVR, 'XData', history.t, 'YData', history.vR);
    set(hVL, 'XData', history.t, 'YData', history.vL);
    set(hBody, 'XData', [x_l xt x_r], 'YData', [y_l yt y_r]);
    set(hDots(1), 'XData', x_l, 'YData', y_l);
    set(hDots(2), 'XData', xt,  'YData', yt);
    set(hDots(3), 'XData', x_r, 'YData', y_r);

    %aby som videl vzdy najviac poslednych 10 sekund:
    t_now = t;
    t_min = max(0, t_now - 10);
    if t_now - t_min > 0
        xlim(axVT, [t_min, t_now]);
        xlim(axVR, [t_min, t_now]);
        xlim(axVL, [t_min, t_now]);
    end

    drawnow limitrate;
end

%funkcie:
function klavesa_stlacena(~, event)
    global vL vR pauza rychlost running hSpeedText
    switch lower(event.Key)
        case 'w'
            vL = rychlost; vR = rychlost;
        case 's'
            vL = -rychlost; vR = -rychlost;
        case 'a'
            vL = -rychlost; vR = rychlost;
        case 'd'
            vL = rychlost; vR = -rychlost;
        case 'space'
            pauza = ~pauza;
        case 'escape'
            running = false;
            close all;
        case {'1','2','3','4','5'}
            rychlost = str2double(event.Key) / 10;
            set(hSpeedText, 'String', sprintf('Zvolená rýchlosť: %d (%.1f m/s)',rychlost*10, rychlost));
    end
end

function klavesa_pustena(~, ~)
    global vL vR
    vL = 0;
    vR = 0;
end

function [x_l, y_l, x_r, y_r] = polohy_kolies(x, y, uhol, L)
    x_l = x - (L/2) * sin(uhol);
    y_l = y + (L/2) * cos(uhol);
    x_r = x + (L/2) * sin(uhol);
    y_r = y - (L/2) * cos(uhol);
end

function zavriet(src, ~)
    global running
    running = false;
    delete(src);
    close all;
end
