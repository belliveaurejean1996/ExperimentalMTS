% focntion qui permet de calculer le coefficient de variance

function [CoV] = CoeffVar(data)

M = mean(data);
S = std(data);

CoV = (S./M)*100;

end