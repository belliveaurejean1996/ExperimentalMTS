function [stress, disp, R, Load, Moment] = ResistanceTraction(SpecimenID, Thickness, Width)

% Change de directory basé sur le ID
cd(['E:\Universite\Matrise\Article - Comparison\ResultatsExperimental\Comparaison\Data\' SpecimenID]);
   
% read traction failure data
[A1,B1,C1]=textread(['traction.dat'],'%s%s%s%*[^\n]'); %#ok<NBRAK>
Disp=str2double(A1);
Force=str2double(B1);
temps=str2double(C1);

Force = rmmissing(Force);
disp = rmmissing(Disp);
temps = rmmissing(temps);

% calculate the stress based on the cross-section and the Force
stress = Force/(Thickness*Width);

% Extract maximum load
Load = Force;
Moment = 0;

% Max stress
R = max(stress);
cd('E:\Universite\Matrise\Article - Comparison\ResultatsExperimental\Comparaison');
end