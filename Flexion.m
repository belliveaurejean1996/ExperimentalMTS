% cette fonction permet de calculer le module en tention du composite
function [stress, Disp, Max_eps, E, R, Load, Moment] = Flexion(SpecimenID, h, b, L)
    
% Change de directory basé sur le ID
cd(['E:\Universite\Matrise\Article - Comparison\ResultatsExperimental\Comparaison\Data\' SpecimenID]);
    
% read traction failure data
[A1,B1,C1]=textread(['flexion.dat'],'%s%s%s%*[^\n]'); %#ok<DTXTRD,*NBRAK>
temps=str2double(A1);
Disp=str2double(B1);
Force=str2double(C1);

Force = rmmissing(Force)*-1;
Disp = rmmissing(Disp)*-1;
temps = rmmissing(temps); %#ok<NASGU>

% maximum load
Moment = ((1/8)*(max(Force))*(L*((3^2)*25)/((h^2)*b)))/1000;
Load = ((1/8)*(Force)*(L*((3^2)*25)/((h^2)*b)))/1000;
% Load = (Force).*(((3^2)*25)/((h^2)*b));

% calculate the stress based on the cross-section and the Force
stress = (3*L*Force)/(4*b*(h^2));

% calcule la résistance
R = max(stress);

% calculate the deflexion
eps = (4.36*Disp*h)/(L^2);
Max_eps = max(eps);

% calcule du module de flexion
Bound1 = 0.001;
Bound2 = 0.003;

[~,ix1] = min(abs(eps-Bound1));
[~,ix2] = min(abs(eps-Bound2));

DS = stress(ix2)-stress(ix1);
DEPS = eps(ix2)-eps(ix1);

E = (DS / DEPS)/1e3;

end