%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sicherheitsabstand auf der Autobahn visualisiert %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
speed = 80:10:160;  % Geschwindigkeitsbereich [km/h]

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
ylim([0, 200]);

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

set(gcf,'units','centimeters','position',[5,5, 12,18]);  % set size