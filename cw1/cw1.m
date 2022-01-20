a = 6378137; 
e2 = 0.00669437999013;
macierz_lot = load('dane.txt');

%wsp. samolotu
phi = macierz_lot(:,1);  
lambda = macierz_lot(:,2); 
h = macierz_lot(:,3); 

%wsp. lotniska 
phiB = 45.74305;
lambdaB = 16.06888;
hB = 108;

N = (a ./ sqrt(1-e2 .* sind(phi) .* sind(phi)));
x = ((N + h) .* cosd(phi) .* cosd(lambda));
y = ((N + h) .* cosd(phi) .* sind(lambda));
z = ((N .* (1 - e2) + h) .* sind(phi));

NB = (a./sqrt(1-e2 .* sind(phiB) .* sind(phiB)));
xB = ((NB + hB) .* cosd(phiB) .* cosd(lambdaB));
yB = ((NB + hB) .* cosd(phiB) .* sind(lambdaB));
zB = ((NB .* (1-e2) + hB) .* sind(phiB));

n = ((-sind(phiB) .* cosd(lambdaB) .* (x - xB)) + ...
    (-sind(phiB) .* sind(lambdaB) .* (y - yB)) + ...
    (cosd(phiB) .* (z - zB)));

e = (-sind(lambdaB) .* (x - xB) + ...
    cosd(lambdaB) .* (y - yB));

u = ((cosd(phiB) .* cosd(lambdaB) .* (x - xB)) + ...
    (cosd(phiB) .* sind(lambdaB) .* (y - yB)) + ...
    (sind(phiB) .* (z - zB)));

%Azymut, odleglosc skosna s, odleglosc zenitalna samolotu
A = atand(e./n);
s = sqrt(n.^2+e.^2+u.^2);
zen = acosd(u./sqrt(n.^2+e.^2+u.^2));

for i = 1:length(A)
    if n(i) < 0 & e(i) > 0
        A(i) = A(i) + 180
    elseif n(i) < 0 & e(i) < 0
        A(i) = A(i) + 180
    elseif n(i) > 0 & e(i) < 0
        A(i) = A(i) + 360
    elseif A(i) > 360
        A(i) = A(i) - 360
    end
end

%znalezienie punktu kiedy samolot znika za horyzontem
idx = 0
for i = 1:length(A)
    if u(i) < 0 & z(i) > 90 & idx == 0 
        disp(i)
        idx = i
    end
end

%trasa samolotu
%geoscatter(phi,lambda,5,'ro');

%wykres lotu we wspolrzednych XYZ względem elipsoidy GRS80 
%plot3(x,y,z);

%wykres lotu we wspolrzednych neu względem lotniska, z punktem gdzie
%samolot znika za goryzontem
plot3(n, e, u)
hold on
plot3(n(idx), e(idx), u(idx),"o-")