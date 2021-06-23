% determine quelle sorte de chip est utilisé
function ChipType = ChipTypeFun(SpecimenID)

    % Is it UD or Woven chips
    SubString1 = 'DUD';
    SubString2 = 'DW';
    SubString3 = 'CUDQI';
    SubString4 = 'CWQI';
    SubString5 = 'CWCP';
    SubString6 = 'CUD0';
    SubString7 = 'CUD90';
    
    if contains(SpecimenID,SubString1) == 1
        ChipType = 'UD';
    elseif contains(SpecimenID,SubString2) == 1
        ChipType = 'Woven';
    elseif contains(SpecimenID,SubString3) == 1
        ChipType = 'UDQI';
    elseif contains(SpecimenID,SubString4) == 1
        ChipType = 'WovenQI';
    elseif contains(SpecimenID,SubString5) == 1
        ChipType = 'CrossW';
    elseif contains(SpecimenID,SubString6) == 1
        ChipType = 'CrossUD0';
    elseif contains(SpecimenID,SubString7) == 1
        ChipType = 'CrossUD90';
    else
        disp('Chip type not detected')
    end
    
end