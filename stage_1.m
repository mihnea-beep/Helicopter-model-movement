%   id tema 50
P_tan = date_indiv(50);

% 1.Analiza stabilitate

% a) Matricea Hurwitz

H = [ [1.9017 1 0]' [4.4273 3.5174 1.9017]' [0 0 4.4273]' ];

% b)  Minorii principali 1x1, 2x2, 3x3 sunt pozitivi
%   deci procesul e stabil

det1 = det( H(1,1) );
det2 = det( H(1:2,1:2) );
det3 = det( H );

% c) Pozitionarea polilor in planul complex

numitor = P_tan.den{1};

poli = roots( numitor );

% polii au partea reala negativa, deci procesul
% este stabil

% 2. Raspunsul in timp

% vector de timp

t = (0:0.01:180)';

% a) impuls

h_pondere = impulse(P_tan, t); % vector coloana automat

% impulse(P_tan, t) tinde la 0, cond necesara,
% dar nu si suficienta pt ca sist sa fie stabil

% b) rasp treapta

rasp_trp = step(P_tan, t);

% c) convolutie treapta unitara si h_pondere

trp = double(t>=0); % treapta unitara de lung lui t

% prod conv * pas de esantionare

prod_conv = conv(trp, h_pondere)*0.01;

% selectam lungimea lui t
% prima parte a rezultatului

prod_conv_t = prod_conv (1: length(t));

% d) rasp conv

rasp_conv = prod_conv_t;

% e) dif intre norma inf a diferentei
% dintre rasp_trp si rasp_conv

norma_dif = norm(rasp_trp - rasp_conv, inf);

% valoare foarte mica, deci cele doua
% metode de calcul dau aceleasi rezultate
% graficele rasp_conv si rasp_trp se suprapun

% 3. Descompunerea raspunsului total

% a) rasp total

x0 = [ 1 1 1 ]; % vector de cond initiale

rasp_tot = lsim( ss(P_tan, 'min'), trp, t, x0 );

% b) rasp perm

rasp_perm = trp * evalfr(P_tan, 0);

% c) rasp tran

rasp_tran = rasp_tot - rasp_perm;

% d) rasp liber

rasp_libr = initial( ss(P_tan, 'min'), x0, t);

% e) rasp_fort

rasp_fort = rasp_tot - rasp_libr;

% 4. Performante regim tranzitoriu la intrare
% treapta unitara

% a) 

Step_Info = stepinfo(P_tan)

tc1 = Step_Info.RiseTime;

tt1 = Step_Info.SettlingTime;

tv1 = Step_Info.PeakTime;

sr1 = Step_Info.Overshoot;

figure(1)
step(t, P_tan);
hold on;

% tc 1 grafic

plot(tc1, evalfr( P_tan, tc1 ), '*' );
%plot(tt1, evalfr( P_tan, tt1 ), '*' );
%plot(tv1, evalfr( P_tan, tv1 ), '*' );
%plot(sr1, evalfr( P_tan, sr1 ), '*' );

% b) 

P_aux = tf( 1, [10 1] );

Step_Info2 = stepinfo(P_tan * P_aux)

tc2 = Step_Info2.RiseTime;

tt2 = Step_Info2.SettlingTime;

tv2 = Step_Info2.PeakTime;

sr2 = Step_Info2.Overshoot;

% c) 

s = complex(1, 2);

Step_Info3 = stepinfo(P_tan * tf('s') + 1)

tc3 = Step_Info3.RiseTime;

tt3 = Step_Info3.SettlingTime;

tv3 = Step_Info3.PeakTime;

sr3 = Step_Info3.Overshoot;

step(t, P_tan * P_aux );

step(t, P_tan * tf('s') + 1);

save('Dragodanescu_Mihnea_323AA_tema1.mat', 'H', 'det1', 'det2',...
    'det3', 'poli', 'h_pondere', 'rasp_trp', 'rasp_conv',...
    'norma_dif', 'rasp_tot', 'rasp_perm', 'rasp_tran',...
    'rasp_libr', 'rasp_fort', 'tc1', 'tt1', 'tv1', 'sr1',...
    'tc2', 'tt2', 'tv2', 'sr2', 'tc3', 'tt3', 'tv3', 'sr3');













