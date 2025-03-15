close all; clear all;

%% Zadané hodnoty
    h = 300; % [m]
    g = 9.81; % [m/s^2]
    v_A0 = 100; % [m/s]
    phi_0 = pi/6; % [rad]

%% Výpočet kinematiky
    % čas dopadu
        D_sqrt = sqrt(v_A0^2*sin(phi_0)^2 + 2*g*h);

        T12 = [(v_A0*sin(phi_0) + D_sqrt)/g;
               (v_A0*sin(phi_0) - D_sqrt)/g];

        % výběr času dopadu
            T_kladne = T12(T12 >= 0);
            T = min(T_kladne);

    % vzdálenost dopadu
        L = v_A0*cos(phi_0)*T;


    % Výpis výsledků
    fprintf("Doba dopadu je %.2f [s].\nStřela dopadne do vzdálenosti %.2f [m].", T, L)



%% Animace
    t_anim = linspace(0, T, 200);  % 200 snímků animace
    
    % Výpočet souřadnic pro animaci
    x_anim = v_A0*cos(phi_0)*t_anim;
    y_anim = h + v_A0*sin(phi_0)*t_anim - 0.5*g*t_anim.^2;
    
    %% Nastavení grafu
    figure;
    axis([0, max(x_anim)*1.1, 0, max(y_anim)*1.1]);
    xlabel('x [m]');
    ylabel('y [m]');
    title('Dráha střely');
    grid on;
    hold on;
    
    %% Vytvoření animovaného řádku a aktuální pozice
    hLine = animatedline('LineWidth', 2);
    hPoint = plot(0, 0, 'r-', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    
    %% Smyčka animace
    for i = 1:length(t_anim)
        % Přidání bodu do animovaného řádku
        addpoints(hLine, x_anim(i), y_anim(i));
        % Aktualizace pozice bodu
        set(hPoint, 'XData', x_anim(i), 'YData', y_anim(i));
        drawnow;
        pause(0.01); % Zpomalení animace (upravte podle potřeby)
    end
