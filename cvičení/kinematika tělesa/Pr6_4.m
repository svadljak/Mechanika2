clear; close all;

%% Zadání
    a = 0.4;   % [m*s^-2]
    r = 0.3;   % [m]
    m = 0.8;   % [m]
    l = 0.7;   % [m]
    
    t1 = 0.8;  % [s]
    t2 = 1.9;  % [s]

%% Kinematika
    s = @(t) 1/2 * a * t.^2;
    s_dot = @(t) a.*t;
    t = linspace(0, t2, 100);

    % Pohyb bodu A
        x_A = s(t);
        y_A = zeros(size(t));
            sinphi = r ./ (m + r - s(t));
        phi = asin(sinphi);

    % Úhlová rychlost tyče
        omega = 1 ./ (sqrt(1 - sinphi.^2)) * r.*s_dot(t) ./ (m + r - s(t)).^2;

    % Pohyb bodu D
        x_D = x_A + l*cos(phi);
        y_D = l*sinphi;

    % Rychlost bodu D
        x_D_dot = s_dot(t) - l.*omega.*sinphi;
        y_D_dot = l.*omega.*cos(phi);


%% Výsledky v čase t1 = 0.8 s
    % Výpočet pro bod A v čase t1
        x_A_t1 = s(t1);
        y_A_t1 = 0;  % dle zadání y_A = 0
        sinphi_t1 = r / (m + r - s(t1));
        phi_t1 = asin(sinphi_t1);
    
    % Výpočet úhlové rychlosti omega v čase t1
        omega_t1 = 1 / (sqrt(1 - sinphi_t1^2)) * r * s_dot(t1) / (m + r - s(t1))^2;
    
    % Výpočet polohy bodu D v čase t1
        x_D_t1 = x_A_t1 + l * cos(phi_t1);
        y_D_t1 = l * sinphi_t1;
        
    % Výpočet složek rychlosti bodu D v čase t1
        x_D_dot_t1 = s_dot(t1) - l * omega_t1 * sinphi_t1;
        y_D_dot_t1 = l * omega_t1 * cos(phi_t1);
    
    % Výpis výsledků do příkazového okna
        fprintf('Hodnoty v čase t1 = %.2f s:\n', t1);
        fprintf('x_A = %.3f m\n', x_A_t1);
        fprintf('y_A = %.3f m\n', y_A_t1);
        fprintf('omega = %.3f rad/s\n', omega_t1);
        fprintf('x_D = %.3f m\n', x_D_t1);
        fprintf('y_D = %.3f m\n', y_D_t1);
        fprintf('x_D_dot = %.3f m/s\n', x_D_dot_t1);
        fprintf('y_D_dot = %.3f m/s\n', y_D_dot_t1);



%% Grafy
lw = 2;
figure;
tlo = tiledlayout(2, 3, 'TileSpacing','Compact','Padding','Compact');
set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

% --- BOD A ---
    % Pohyb bodu A - časová závislost
        ax1 = nexttile;
        yyaxis left
        plot(t, x_A, 'b', 'LineWidth', lw);
        ylabel('$x_A$ [m]');
        yyaxis right
        plot(t, y_A, 'r', 'LineWidth', lw);
        ylabel('$y_A$ [m]');
        xlabel('t [s]');
        title('Pohyb bodu A ({\v{c}as})');
        grid on;
    
    % Pohyb bodu A - v rovině xy
        ax2 = nexttile;
        plot(x_A, y_A, 'g', 'LineWidth', lw);
        xlabel('$x_A$ [m]');
        ylabel('$y_A$ [m]');
        title('Pohyb bodu A (rovina)');
        axis equal; grid on;

% --- Úhlová rychlost
    ax3 = nexttile;
    plot(t, omega, 'k', 'LineWidth', lw);
    ylabel('$\omega$ [rad/s]');
    xlabel('t [s]');
    title('Uhlova rychlost v case');
    grid on;


% --- BOD D ---
    % Pohyb bodu D - časová závislost
        ax4 = nexttile;
        yyaxis left
        plot(t, x_D, 'b', 'LineWidth', lw);
        ylabel('$x_D$ [m]');
        yyaxis right
        plot(t, y_D, 'r', 'LineWidth', lw);
        ylabel('$y_D$ [m]');
        xlabel('t [s]');
        title('Pohyb bodu D ({\v{c}as})');
        grid on;
    
    % Pohyb bodu D - v rovině xy
        ax5 = nexttile;
        plot(x_D, y_D, 'g', 'LineWidth', lw);
        xlabel('$x_D$ [m]');
        ylabel('$y_D$ [m]');
        title('Pohyb bodu D (rovina)');
        axis equal; grid on;

    % Rychlost bodu D
        ax6 = nexttile;
        yyaxis left
        plot(t, x_D_dot, 'r', 'LineWidth', lw);
        ylabel('$\dot{x}_D$ [m/s]');
        yyaxis right
        plot(t, y_D_dot, 'b', 'LineWidth', lw);
        ylabel('$\dot{y}_D$ [m/s]');
        xlabel('t [s]');
        title('Rychlost bodu D');
        grid on;

%% Animace
figure;
hold on;
% Nastavení os a popisků
    axis equal;
    grid on;
    xlabel('x [m]');
    ylabel('y [m]');
    title('Animace pohybu');
    ylim([-0.1 0.8]);
    xlim([0 1.4]);

% Statické prvky
    % Vykreslení vodorovné čáry od počátku do x = m
        plot([0 m], [0 0], 'k-', 'LineWidth', 2);
    
    % Vykreslení horní půlkružnice se středem v (m+r,0) a poloměrem r
        theta = linspace(0, pi, 100);
        x_semicircle = (m + r) + r*cos(theta);
        y_semicircle = r*sin(theta);
        plot(x_semicircle, y_semicircle, 'k-', 'LineWidth', 2);


% Bod B
    x_B = x_A + 1.8*l*cos(phi);
    y_B = 1.8*l*sinphi;



% Inicializace animovaných objektů
    tyc = plot([x_A(1), x_B(1)], [y_A(1), y_B(1)], 'k-', 'LineWidth',lw);
    hA = plot(x_A(1), y_A(1), 'bo', 'MarkerSize', 8, 'MarkerFaceColor','b');
    hD = plot(x_D(1), y_D(1), 'ro', 'MarkerSize', 8, 'MarkerFaceColor','r');
    
    
    text_marg = 0.05;
    textA = text(x_A(1), y_A(1) + text_marg, ' A', 'Color', 'b', 'FontSize', 12, 'FontWeight', 'bold');
    textD = text(x_D(1), y_D(1) + text_marg, ' D', 'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold');

% Animační smyčka
    for k = 1:length(t)
        set(tyc, 'XData', [x_A(k), x_B(k)], 'YData',[y_A(k), y_B(k)]);
        set(hA, 'XData', x_A(k), 'YData', y_A(k));
        set(hD, 'XData', x_D(k), 'YData', y_D(k));
            set(textA, 'Position', [x_A(k) - text_marg, y_A(k) + text_marg, 0]);
            set(textD, 'Position', [x_D(k) - text_marg, y_D(k) + text_marg, 0]);
        pause(0.05);
        drawnow;
    end
