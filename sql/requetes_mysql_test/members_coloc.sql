set @coloc = 'CDEUX';

-- Ensemble des membres d’une colocation donnée
select NOM_PERSONNE as NOM, PRENOM_PERSONNE as PRENOM, P.ID_PERSONNE as ID
from (COLOCATAIRE CO inner join PERSONNE P
    on CO.ID_PERSONNE = P.ID_PERSONNE)
        inner join COLOCATION C
        on CO.ID_COLOCATION = C.ID_COLOCATION
where C.NOM_COLOCATION = @coloc
-- Au cas où une personne revient plusieurs fois dans la même colocation
-- pour qu'il n'apparaisse pas deux fois dans le tableau
group by P.ID_PERSONNE
order by NOM_PERSONNE asc;