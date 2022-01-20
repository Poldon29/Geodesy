import math
from tokenize import Double
import numpy
a = 6378137
e2 = 0.00669437999013
fiA = 51
lamA = 20.75
fiB = 50.75
lamB = 20.75
fiC = 51
lamC = 21.25
fiD = 50.75
lamD = 21.25

#punkt sredniej szerokosci
def mid():
    fi_ = (fiA + fiB + fiC + fiD) / 4
    lam_ = (lamA + lamB + lamC + lamD)/ 4
    return (fi_, lam_)

def vincent():
    b = a * math.sqrt(1-e2)
    f = 1 - (b / a)
    l_vin = numpy.deg2rad(lamD - lamA)
    Ua = math.atan((1 - f) * math.tan(numpy.deg2rad(fiA)))
    Ub = math.atan((1 - f) * math.tan(numpy.deg2rad(fiB)))
    L = l_vin

    #iteracja
    while True:
        sin_sig = math.sqrt( (math.cos(Ub)*math.sin(L))**2 + (math.cos(Ua)*math.sin(Ub) - (math.sin(Ua)*math.cos(Ub)*math.cos(L)) )**2 )
        cos_sig = math.sin(Ua)*math.sin(Ub) + (math.cos(Ua) * math.cos(Ub) * math.cos(L))
        sig = math.atan(sin_sig / cos_sig) #rad
        sin_alf = (math.cos(Ua) * math.cos(Ub) * math.sin(L)) / sin_sig
        cos_2alf = 1 - (sin_alf**2)
        cos_2sig = cos_sig - ((2 * math.sin(Ua) * math.sin(Ub)) / cos_2alf)
        C = (f / 16) * cos_2alf * (4 + f * (4 - 3*cos_2alf))
        L2 = l_vin + (1 - C)*f*sin_alf* (sig + C*math.sin(sig) * (cos_2sig + C*cos_sig * (-1 + 2*(cos_2sig**2))))
        if abs(L2 - L) < numpy.deg2rad(0.000001 / 3600):
            break
        else:
            L = L2
    u_2 = (((a**2) - (b**2)) / (b**2)) * cos_2alf
    A = 1 + (u_2/16384) * (4096+u_2 * (-768+u_2 * (320 - 175*u_2)))
    B = (u_2/1024) * (256+u_2 * (-128+u_2 * (74 - 47*u_2)))

    pom_1 = cos_sig*(-1 + 2*(cos_2sig**2))
    pom_2 = (B*cos_2sig*(-3+ 4*(sin_sig**2)) * (-3+ 4*(cos_2sig**2)))/6
    delt_sig = B*sin_sig * (  cos_2sig + B *(pom_1 - pom_2)/4   )
    S_ab = (b * A * (sig - delt_sig))
    A_AB = math.atan((math.cos(Ub)*math.sin(L)) / ((math.cos(Ua)*math.sin(Ub)) - (math.sin(Ua)*math.cos(Ub)*math.cos(L))))
    A_BA = math.atan((math.cos(Ua)*math.sin(L)) / (((-math.sin(Ua))*math.cos(Ub)) + (math.cos(Ua)*math.sin(Ub)*math.cos(L)))) + math.pi
    print(S_ab)
    return (S_ab, A_AB, A_BA)

def kivioj():
    S_ab, A_AB, A_BA = vincent()
    n = int(S_ab / 1500)
    reszta = S_ab - n*1500
    print()
    
    





kivioj()
