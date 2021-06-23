%% bar chart Traction

% Bar chart Resistance
figure('Name','Traction R et M')
subplot(1,2,1)
X = categorical({'UD','Woven'});
X = reordercats(X,{'UD','Woven'});
Y = [mean(var.UDTraction.Resistance), mean(var.WovenTraction.Resistance)];
errhigh = [std(var.UDTraction.Resistance), std(var.WovenTraction.Resistance)];
errlow  = [std(var.UDTraction.Resistance), std(var.WovenTraction.Resistance)];
MaxStrength = [max(var.UDTraction.Resistance), max(var.WovenTraction.Resistance)];
MinStrength = [min(var.UDTraction.Resistance), min(var.WovenTraction.Resistance)];

hold on
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';
p = plot(X, MaxStrength,'*k');
p2 = plot(X, MinStrength,'*k');
ylabel('Containtes (MPa)')
title('Résistance')
hold off

% Bar chart Resistance
subplot(1,2,2)
X = categorical({'UD','Woven'});
X = reordercats(X,{'UD','Woven'});
Y = [mean(var.UDTraction.Module), mean(var.WovenTraction.Module)];
errhigh = [std(var.UDTraction.Module), std(var.WovenTraction.Module)];
errlow  = [std(var.UDTraction.Module), std(var.WovenTraction.Module)];
MaxModulus = [max(var.UDTraction.Module), max(var.WovenTraction.Module)];
MinModulus = [min(var.UDTraction.Module), min(var.WovenTraction.Module)];

hold on
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
p = plot(X, MaxModulus,'*k');
p2 = plot(X, MinModulus,'*k');
ylabel('Module (GPa)')
title('Rigidité')
hold off

%% Bar chart Flexion

% Bar chart Resistance
figure('Name','Flexion R et M')
subplot(1,2,1)
X = categorical({'Woven'});
X = reordercats(X,{'Woven'});
Y = [mean(var.WovenFlexion.Resistance)];
errhigh = [std(var.WovenFlexion.Resistance)];
errlow  = [std(var.WovenFlexion.Resistance)];
MaxStrength = [max(var.WovenFlexion.Resistance)];
MinStrength = [min(var.WovenFlexion.Resistance)];

hold on
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';
p = plot(X, MaxStrength,'*k');
p2 = plot(X, MinStrength,'*k');
ylabel('Containtes (MPa)')
title('Résistance')
hold off


% Bar chart Resistance
subplot(1,2,2)
X = categorical({'Woven'});
X = reordercats(X,{'Woven'});
Y = [mean(var.WovenFlexion.Module)];
errhigh = [std(var.WovenFlexion.Module)];
errlow  = [std(var.WovenFlexion.Module)];
MaxModulus = [max(var.WovenFlexion.Module)];
MinModulus = [min(var.WovenFlexion.Module)];

hold on
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
p = plot(X, MaxModulus,'*k');
p2 = plot(X, MinModulus,'*k');
ylabel('Module (GPa)')
title('Rigidité')
hold off
