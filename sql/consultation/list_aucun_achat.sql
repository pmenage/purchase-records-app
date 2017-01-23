-- Liste des colocations pour lesquels aucun achat n’a été enregistré au cours des 6 derniers mois
select C.NOM_COLOCATION
from COLOCATION C inner join ACHAT A
    on A.ID_COLOCATION = C.ID_COLOCATION
where (select MAX(A.DATE_ACHAT)
        from ACHAT) < (select subdate(current_date, 182));