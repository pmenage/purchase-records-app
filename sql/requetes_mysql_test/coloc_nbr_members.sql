set @date = '20121001'; 

-- La liste des colocations avec le nombre de leurs membres à une date donnée */
select NOM_COLOCATION, COUNT(CO.ID_COLOCATAIRE) as NOMBRE
from (COLOCATAIRE CO inner join PERSONNE P
      on CO.ID_PERSONNE = P.ID_PERSONNE) 
        inner join COLOCATION C
        on CO.ID_COLOCATION = C.ID_COLOCATION
where date_format(CO.DATE_ENTREE_COLOC, '%x%m%d') < @date
-- Moins les membres partis à la date donnée
and CO.ID_COLOCATAIRE not in (select CO.ID_COLOCATAIRE
                           from (COLOCATAIRE CO inner join PERSONNE P
                                 on CO.ID_PERSONNE = P.ID_PERSONNE) 
                                 inner join COLOCATION C
                                 on CO.ID_COLOCATION = C.ID_COLOCATION
                                 where date_format(CO.DATE_SORTIE_COLOC, '%x%m%d') < @date)
group by NOM_COLOCATION
;
