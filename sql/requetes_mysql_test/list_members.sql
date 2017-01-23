-- Créer une vue contenant la liste des membres d'une colocation
create or replace view MEMBERS as
select C.NOM_COLOCATION, P.ID_PERSONNE as ID,
        P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM
from (COLOCATAIRE CO inner join PERSONNE P
    on CO.ID_PERSONNE = P.ID_PERSONNE)
        inner join COLOCATION C
        on CO.ID_COLOCATION = C.ID_COLOCATION
group by ID
order by NOM_PERSONNE asc;

-- pour afficher la vue
select * from MEMBERS;