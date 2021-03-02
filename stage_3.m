% Tema 3 - SS
% set de regulatoare pentru miscarea
% laterala a unui elicopter

% look for: ?

% ID - proces personalizat

[~, P_gir] = date_indiv(50);

% a = 1; % a scalar pozitiv pt. ca bucla de reglare % ?
         % sa fie intern stabila
         
% [X, Y, N, M] = eucl_Youla(P_gir.num{1}, P_gir.den{1}, a);

% Q = tf([1], [1 1]); % ?

% C = (X + M * Q) / (Y - N * Q); % regulator stabilizaror, pt orice Q stabil

% C = tf(ss(C, 'min')); % forma ireductibila pt functia de transfer! - ASA -

% 1)
% Modelul miscarii orizontale e instabil, deci vom avea nevoie
% sa obtinem un regulator stabilizator

a1 = 3.5; % scalar real pozitiv

Q1 = tf([1], [1 1]); % functie de transfer stabila

[X, Y, N, M] = eucl_Youla(P_gir.num{1}, P_gir.den{1}, a1);

C1 = (X + M * Q1) / (Y - N * Q1); % compensator care asigura:

% a) ? ca bucla de reglare cu react. unit. neg. ce are pe
% calea directa C1 si P_gir este intern stabila

C1 =  tf(ss(C1, 'min'));

T1 = (P_gir * C1) / (1 + P_gir * C1); % transferul de la ref., la iesire

T1 = tf(ss(T1, 'min'));

% asig. ca rasp. la tr. unit. al lui T1 are:

% b) timp de crestere sub o secunda

step(T1);

step_inf = stepinfo(T1);

timp_crestere = step_inf.RiseTime;

% c) timp tranzitoriu intre 3 si 5 secunde

timp_tranz = step_inf.SettlingTime;

% Impunem ca modelul compensatorului sa aiba pol in origine

% 2)

a2 = 3; % scalar real pozitiv

Q2 = tf([1], [1 0.0464]); % functie de transfer stabila %-3.9952

[X, Y, N, M] = eucl_Youla(P_gir.num{1}, P_gir.den{1}, a2);

C2 = (X + M * Q2) / (Y - N * Q2);

C2 = tf(ss(C2, 'min'));

% modelul compensatorului are pol in 0, impunand
% corespunzator Q2(0)

q0 = evalfr(Q2, 0);

y0 = evalfr(Y, 0); % Y(0)/N(0) = Q2(0)

n0 = evalfr(N, 0);

% transferul de la referinta la iesire

T2 = (P_gir * C2) / (1 + P_gir * C2);

T2 = tf(ss(T2, 'min'));

step(T2);

step_inf2 = stepinfo(T2);

timp_crestere2 = step_inf2.RiseTime; % sub o sec

timp_tranzitoriu2 = step_inf2.SettlingTime; % intre 3-5 sec

suprareglaj2 = step_inf2.Overshoot; % <50%

% Modelul elicopterului ar putea sa nu ii aproximeze
% foarte fidel dinamica. Construim un regulator
% ce asigura margini de stabilitate bune

% 3)

a3 = 3;

Q3 = tf([1], [1 1]);

% Q3 = tf(ss(Q3, 'min')); nu influenteaza

[X Y N M] = eucl_Youla(P_gir.num{1}, P_gir.den{1}, a3);

C3 = (X + M * Q3) / (Y - N * Q3);

C3 = tf(ss(C3, 'min'));

margin(P_gir * C3); % margine amplif. 9.41 > 8.5 dB
                    % margine faza 43.5 > 40
                    
% [Gm, Pm, Wgm, Wpm] = margin(P_gir * C3); % 20log10 * Gm pt dB

% Transferul de la referinta la iesire

T3 = (P_gir * C3) / (1 + P_gir * C3);

T3 = tf(ss(T3, 'min'));

step(T3);

step_info3 = stepinfo(T3);

timp_crestere3 = step_info3.RiseTime;

timp_tranzitoriu3 = step_info3.SettlingTime;

margin(P_gir * C3);

% Compensator cu poli in origine care sa asigure
% si margini de stabilitate bune

% 4)

a4 = 3;

Q4 = tf([1], [1 0.0464]);

[X Y N M] = eucl_Youla(P_gir.num{1}, P_gir.den{1}, a4);

C4 = (X + M * Q4) / (Y - N * Q4);

C4 = tf(ss(C4, 'min'));

% pol in 0 => modific numitorul Q4

margin(P_gir * C4); % m. amp. = 9.35 dB
                    % m. faza = 42.9 deg
% Transfer ref. iesire

T4 = (P_gir * C4) / (1 + P_gir * C4);

T4 = tf(ss(T4, 'min'));

step(T4);

step_info4 = stepinfo(T4);

timp_crestere4 = step_info4.RiseTime; % timp crestere < 1 sec

timp_tranzitoriu4 = step_info4.SettlingTime; % timp tranz. 3-5 sec

suprareglaj4 = step_info4.Overshoot; % suprareglaj < 50%

save('Dragodanescu_Mihnea_323AA_tema3.mat', 'a1', 'Q1', ...
    'a2', 'Q2', 'a3', 'Q3', 'a4', 'Q4');







