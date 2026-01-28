function [media,patrat,inm_transp]=ex_3_func(compl)
media = mean(real(compl));
patrat = compl.^2;
inm_transp = compl * compl.';
end