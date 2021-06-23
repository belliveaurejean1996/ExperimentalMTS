% cette fonction permet de calculer le module en tention du composite
function [MeanModulus, AllModule] = ModuleTraction(SpecimenID, Thickness, Width)

% Change de directory basé sur le ID
cd(['E:\Universite\Matrise\Article - Comparison\ResultatsExperimental\Comparaison\Data\' SpecimenID]);

for j = 1:4
    file = ['extensometre_' num2str(j, '%d') '.dat'];

    % read traction failure data
    [A2,B2,C2,D2]=textread(file,'%s%s%s%s%*[^\n]'); %#ok<*DTXTRD>
    temps_ext=str2double(A2);
    Disp_ext=str2double(B2);
    Force_ext=str2double(C2);
    Def_ext=str2double(D2)/2;

    % create table to store data
    varNames = {'temps','Disp','Force','Def'};
    Ext_data = table(temps_ext, Disp_ext, Force_ext, Def_ext, 'VariableNames',varNames);
    Ext_data = rmmissing(Ext_data); % delete Nan
    idx = Ext_data.Def < 0 ; % Delete all row with disp < 0
    Ext_data(idx,:) = [] ;

    % calculate the stress based on the cross-section and the Force
    stress_ext = Ext_data.Force/(Thickness*Width);

    p = polyfit(Ext_data.Def,stress_ext,1);
    M(j) = p(1); %#ok<AGROW>
end

% take the mean of all 4 of the extensometer data
MeanModulus = mean(M)/1e3;
AllModule = M/1e3;

end