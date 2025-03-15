%% Vyčištění prostředí
clear; close all; clc;

%% Parametry
r = 0.4;   % Poloměr [m]
b = 0.5;   % Vertikální posun bodu C [m]
l = 1;     % Délka [m]

%% Čas a úhel
t_anim = 0:0.01:2;
phi = pi * t_anim;

%% Výpočet pozic bodů
% Souřadnice bodu B (vertikální posun dle zadání)
posB_y = -b - l + sqrt(r^2 + b^2 + 2 * r * b * sin(phi));

% Souřadnice bodu A
posA_x = r * cos(phi);
posA_y = r * sin(phi);

%% Vykreslení grafů
figure;
tiledlayout(2,1);

% Graf y-ové souřadnice bodu A
nexttile;
plot(t_anim, posA_y, 'b', 'LineWidth', 1.5);
xlabel('t [s]');
ylabel('y_A [m]');
grid on;

% Graf y-ové souřadnice bodu B
nexttile;
plot(t_anim, posB_y, 'r', 'LineWidth', 1.5);
xlabel('t [s]');
ylabel('y_B [m]');
grid on;


%% Spuštění animace
animateRope(posA_x, posA_y, posB_y, r, b);


%% Funkce pro animaci lana s popisky bodů A a B
function animateRope(posA_x, posA_y, posB_y, radius, offset)
    % Nastavení grafu animace
    fig = figure;
    ax = gca;
    hold(ax, 'on'); grid(ax, 'on'); axis(ax, 'equal');
    xlim(ax, [-1.5 * radius, 1.5 * radius]);
    ylim(ax, [min(posB_y)*1.2, radius*1.5]);
    xlabel(ax, 'x [m]');
    ylabel(ax, 'y [m]');

    % Vykreslení pevných prvků: počátek, kružnice a bod C
    plot(ax, 0, 0, 'ko');                     % počátek
    theta = linspace(0, 2*pi, 300);
    plot(ax, radius*cos(theta), radius*sin(theta), 'k');  % kružnice
    plot(ax, 0, -offset, 'ks');                % bod C

    % Inicializace grafických objektů pro animaci (body A a B, a lano)
    hA = plot(ax, posA_x(1), posA_y(1), 'bo', 'MarkerFaceColor', 'b');
    hB = plot(ax, 0, posB_y(1), 'ro', 'MarkerFaceColor', 'r');
    ropeLine = line(ax, [posA_x(1), 0, 0], [posA_y(1), -offset, posB_y(1)], ...
                    'LineStyle', '--', 'Color', 'k');
                
    % Přidání textových popisků pro body A a B
    textA = text(posA_x(1), posA_y(1), ' A', 'Color', 'b', 'FontSize', 12, 'FontWeight', 'bold');
    textB = text(0, posB_y(1), ' B', 'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold');

    % Smyčka animace: aktualizace grafických objektů bez jejich mazání
    for idx = 1:length(posA_x)
        % Aktualizace pozic bodů a lana
        set(hA, 'XData', posA_x(idx), 'YData', posA_y(idx));
        set(hB, 'XData', 0, 'YData', posB_y(idx));
        set(ropeLine, 'XData', [posA_x(idx), 0, 0], 'YData', [posA_y(idx), -offset, posB_y(idx)]);
        
        % Aktualizace popisků s malým offsetem, aby nebyly přímo na bodech
        set(textA, 'Position', [posA_x(idx)+0.02, posA_y(idx)+0.02, 0]);
        set(textB, 'Position', [0.02, posB_y(idx)+0.02, 0]);
        
        drawnow limitrate;
        pause(0.05);
    end
end
