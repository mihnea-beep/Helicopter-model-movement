%id pt proces personalizat

P_tan = date_indiv(50);

% 1. Analiza hodografului

% Vector de pulsatii - selecteaza banda de frecventa de interes

omeg = logspace(-2, 2, 1000)';

%f_transf = tf(P_tan, omeg);

nyquist(P_tan, omeg);

%hold on;

[re, im] = nyquist(P_tan, omeg);

% a)

inters1 = evalfr(P_tan, 0);

for i = 1: 1000
    if(omeg(i) >= 1.87 )
        if( omeg(i) <= 1.89)
        disp(i);
        rez = i;
        end
    end
    
end

% b)

inters2 = re(1, 1, rez);

% c) 

P_tan_2 = 2*P_tan;


%nyquist(P_tan_2, omeg);

[re, im] = nyquist(P_tan_2, omeg);

rez = afla_omega(1.88, 1.89, omeg);

inters3 = re(1, 1, rez);

hold on;

nyquist(P_tan_2, omeg);

hold off;

% d)

[re, im] = nyquist(P_tan * exp(-1i*pi/4), omeg);

nyquist(P_tan * exp(-1i*pi/4), omeg);

rez = afla_omega(1.6, 1.7, omeg);

inters4 = re(1, 1, rez); %77


%inters4 = 0;

% e)

P_aux = tf(1, [1 0]);


[re, im] = nyquist(P_tan * P_aux, omeg);

nyquist(P_tan * P_aux, omeg);

rez = afla_omega(0.02, 0.03, omeg);

%rez = afla_omega(0.03, 0.04, omeg);

asimpt = re(1, 1, rez);

% 2) Remedierea tendintei de instabilitate

K_1 = 100 / (0.3801 / 4.427);

T_1 = 400;

C_1 = tf(K_1, [T_1, 1]);

%nyquist(P_tan * C_1); arata ok fara omeg

%hold on;

nyquist(P_tan * C_1, omeg); %cu omeg, pct din dreapta se duce

K_2 = 100 / (0.3801 / 4.427);

T_2 = 2000;

C_2 = K_2 * tf( [1, 1], [T_2, 1] );

nyquist(P_tan * C_2, omeg);

hold on;

nyquist( [-1 1], [1, 1], omeg );

hold off;

%aceeasi precizare: cu/fara omeg

% 3) Diagramele Bode - determinarea
% modului in care un sistem raspunde 
% la intrari armonice

t = -pi : 0.001 : pi;

u = 7 * sin( t + pi/4 );

%plot(t, u);

y = 7 * abs( evalfr(P_tan, j*1) ) * sin( t + pi/4 + angle( evalfr(P_tan, j*1) ) );

% in loc de arg, angle? arg nu exista?

bode(P_tan);
%hold on;
%u_frecv = tf( 7*[1 1], sqrt(2)*[1 0 1] );

%bode(P_tan * u_frecv);

lsim(P_tan, u, t);

%hold on;

%plot(t, y); nu prea seamana (seamana putin)

amp1 = 7 * abs( evalfr(P_tan, j*1) );

def1 = rad2deg( pi / 4 + angle( evalfr(P_tan, j*1) ) );

bode(3 * P_tan);

lsim(3 * P_tan, u, t);

amp2 = 7 * abs( evalfr(3 * P_tan, j*1) );

def2 = rad2deg( pi / 4 + angle( evalfr(3*P_tan, j*1) ) );

bode( exp( -1i * pi / 6 ) * P_tan);

lsim( exp( -1i * pi / 6 ) * P_tan, u, t);

amp3 = 7 * abs( evalfr( exp( -1i * pi / 6 ) * P_tan, 1*j ) );

def3 = rad2deg( pi / 4 + angle( evalfr( exp( -1i * pi / 6) * P_tan, 1*j) ) );

bode(P_tan * 100);

omeg_1 = 3.56; % e direct de pe grafic (fara functie speiciala)

omeg_2 = 1.88; % tot direct de pe grafic

% 4) Construim 2 sist. pt a ajusta 
% caracteristica frecventiala a lui P_tan

K_3 = K_1; % ?

w_3 = 0.2; % ?!

C_3 = tf( K_3 * w_3, [1 w_3] );


bode(P_tan * C_3);

[mag, phase, wout] = bode(P_tan * C_3);

%bode(P_tan);
A_4 = 1;
B_4 = 4;

C_4 = 100 * tf( B_4 * [1 A_4], A_4 * [1 B_4]);

bode(P_tan * C_4);

save('Dragodanescu_Mihnea_323AA_tema2.mat', 'inters1', 'inters2',...
    'inters3', 'inters4', 'asimpt', 'K_1', 'T_1', 'K_2', 'T_2',...
    'amp1','def1','amp2','def2','amp3','def3','omeg_1',...
    'omeg_2', 'K_3', 'w_3', 'A_4', 'B_4');






