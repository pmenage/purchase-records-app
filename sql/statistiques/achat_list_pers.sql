-- Pour chaque achat, le nombre de personnes concernées.

select A.INTITULE, count(C.ID_PERSONNE) as NB_PERS_CONCERNE
from CONCERNE C inner join ACHAT A
    on A.ID_ACHAT = C.ID_ACHAT
group by C.ID_ACHAT;
