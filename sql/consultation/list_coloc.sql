-- Liste des colocations avec leur gestionnaire

select NOM_COLOCATION, NOM_PERSONNE as "NOM_GESTIONNAIRE", PRENOM_PERSONNE as "PRENOM_GESTIONNAIRE"
from COLOCATION C inner join PERSONNE P
    on C.ID_PERSONNE = P.ID_PERSONNE
order by NOM_COLOCATION asc;