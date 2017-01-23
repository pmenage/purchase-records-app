set @mois = ?;
set @coloc = ?;

-- Liste des achats effectués pour une colocation et pour un mois donné */
select A.ID_ACHAT, A.INTITULE, A.DATE_ACHAT as DATE
from ACHAT A inner join COLOCATION C
    on C.ID_COLOCATION = A.ID_COLOCATION
where DATE_FORMAT(A.DATE_ACHAT, '%m') = @mois
and C.NOM_COLOCATION = @coloc
order by A.DATE_ACHAT asc;