
function [g_averge_filtre] = function_moyanage_filtre(ImageRef,r,c)



fil_averge=fspecial('average', [r c]);


g_averge_filtre = imfilter(ImageRef, fil_averge, 'conv');


end
