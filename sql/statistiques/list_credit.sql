-- Liste des credits
-- Liste des credits versement à une autre personne
(select MONTANT_VERSEMENT as CREDIT
from VERSEMENT V
where V.ID_PERSONNE_P = ? )
union
-- Liste des credits versement à une cagnotte 
(select MONTANT_PARTICIPATION as CREDIT
from PARTICIPATION PA 
where PA.ID_PERSONNE = ? )
union
-- Liste des credits achat
(select MONTANT_ACHAT as CREDIT
from ACHAT A
where  A.ID_PERSONNE = ? )
order by 1 ASC;