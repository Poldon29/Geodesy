% Regulus (Alfa Leonis, α Leo)
rektascensja = 10.1395318;   % 10h 08m 22,311s
deklinacja = 11.9672083;     % +11° 58′ 01,95″

% Warszawa (północna) 
fi = 52.226879;          
lambda = 21.020319;  

% Singapur (równik)
%fi = 1.366055;
%lambda = 103.839492;

% Buenos Aires (południowa)
%fi = -34.613826;       
%lambda = -58.4521837;  

h = 0:1:24;
t = katgodz(2021, 7, 29, h, lambda, rektascensja);

for i = 1:length(h)
    if t(i) > 360 
        t(i) = t(i) - 360; 
    end 
end

%rozwiązanie trójkąta paralaktycznego
for i = 1:length(h)
cosZ(i) = ( sind(fi) * sind(deklinacja) + cosd(fi) * cosd(deklinacja) * cosd(t(i)) );
gora(i) = ( -cosd(deklinacja) * sind(t(i)) ); 
dol(i) = ( cosd(fi) * sind(deklinacja) - sind(fi) * cosd(deklinacja) * cosd(t(i)) );
A(i) = atan2d(gora(i), dol(i)); 
end

for i = 1:length(h)
    if A(i) < 0 
        A(i) = A(i) + 360; 
    end 
end 

Z = acosd(cosZ);

disp(Z)
for i = 1:length(h)
    x_(i) = sind(Z(i))*cosd(A(i)); 
    y_(i) = sind(Z(i))*sind(A(i)); 
    z_(i) = cosd(Z(i)); 
end

%wysokosc
h_ = 90 - Z;

%wykres wysokosci od czasu
%plot(h,h_)
%xlabel("czas")
%ylabel("wysokosc (stopnie)")

%wykres kata zenitalnego od czasu
%plot(h,Z)
%xlabel("czas")
%ylabel("kąt")

%zobrazowanie gwiazdy na sferze
[x,y,z] = sphere(20);
z(z < 0) = 0;
S = surf(x,y,z); 
axis equal
set(S, 'Facecolor', [0,1,1]); 
hold on 
scatter3(x_ * 1.1, y_ * 1.1, z_ * 1.1, 'yellow', 'filled');

%funkcje

function [t] = katgodz(y, d, m, h, lambda, alfa) 
jd = juliandate(datetime(y, m, d));
g = GMST(jd); 
UT1 = h * 1.002737909350795; 
S = UT1 * 15 + lambda + g;  
t = S - alfa * 15; 
end  

function g = GMST(JD)
T = (JD - 2451545) / 36525;
g = 280.46061837 + 360.98564736629 * (JD - 2451545) + 0.000387933 * T.^2 - T.^3/38710000;
g = mod(g, 360);
end