%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sicherheitsabstand auf der Autobahn visualisiert %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
speed = 80:10:250;  % Geschwindigkeitsbereich [km/h]

%% Bußgeld in Deutschland
% Quelle Bußgeld: https://www.bussgeldkatalog.org/abstand/ (Stand: 21.01.2025)

v_2 = speed./2;          % Halber Tacho
v_4 = v_2.*(5/10);       % Viertel Tacho (Start Bußgeld)
v_2_3_10 = v_2.*(3/10);  % Start Fahrverbot (wenn über 100km/h)

%% Anhalteweg
% Quelle Beschleunigungswert: https://copradar.com/chapts/references/acceleration.html
% "Many safety experts use 15 ft/sec2 (0.47 g's) as the maximum deceleration
% that is safe for the average driver to maintain control"

breaking_acceleration = 5;  % [m/s^2]

speed_meter_per_second = speed/3.6;

reaction_time = 1;  % [s]
stop_distance_1s = ...
    speed_meter_per_second .* reaction_time + ...
    speed_meter_per_second.^2 ./ (2*breaking_acceleration);

reaction_time = 0;  % [s]
stop_distance_0s = ...
    speed_meter_per_second .* reaction_time + ...
    speed_meter_per_second.^2 ./ (2*breaking_acceleration);

%% Plot
figure(1); clf; grid on; hold on;
xlabel("Geschwindigkeit [km/h]"); ylabel("Abstand [m]");
ylim([0, 200]); xlim([80, 250]);

plot(speed, v_2, "b", "LineWidth",2)
plot(speed, v_4, ".-")
plot(speed, v_2_3_10, "r--")

plot(speed, stop_distance_1s, "g*-")
plot(speed, stop_distance_0s, "o-")

xline(130, "k--")  % Richtgeschwindigkeit

legend([...
    "Halber Tacho (Richtwert)", ...
    "Start Bußgeld (1/4)", ...
    "Start Fahrverbot (>100km/h)",...
    "Anhalteweg 1s Reaktionszeit",...
    "Anhalteweg 0s Reaktionszeit"
    ],...
    "Location","northwest")

set(gcf,'units','centimeters','position',[5,5, 22,18]);  % set size

saveas(gcf, 'overview.svg');  % save as image

%% Plot2 Vorderes Auto macht Vollbremsung (Abstand bei Stillstand)

distance_after_80 = 80*ones(size(speed)) + stop_distance_0s - stop_distance_1s;
distance_after_60 = 60*ones(size(speed)) + stop_distance_0s - stop_distance_1s;
distance_after_40 = 40*ones(size(speed)) + stop_distance_0s - stop_distance_1s;
distance_after_20 = 20*ones(size(speed)) + stop_distance_0s - stop_distance_1s;


figure(2); clf; grid on; hold on;
xlabel("Geschwindigkeit [km/h]"); ylabel("Abstand nach Vollbremsung [m]");
xlim([80, 250]); ylim([-20, max(distance_after_80)]);
title("Vollbremsung vom vorrausfahrenden Auto");

rectangle('Position',[0,-100,300,100],'FaceColor',[255/255, 176/255, 176/255],'LineWidth',0.001)

plot(speed, distance_after_80, "LineWidth",2)
plot(speed, distance_after_60, "LineWidth",2)
plot(speed, distance_after_40, "LineWidth",2)
plot(speed, distance_after_20, "LineWidth",2)

yline(0, "k", "Unfall-Linie", "LineWidth",2)
xline(130, "k--")  % Richtgeschwindigkeit

legend([...
    "80m Sicherheitsabstand", ...
    "60m Sicherheitsabstand", ...
    "40m Sicherheitsabstand",...
    "20m Sicherheitsabstand",...
    ],...
    "Location","northeast")

saveas(gcf, 'vollbremsung_auto_vorne.svg');  % save as image
