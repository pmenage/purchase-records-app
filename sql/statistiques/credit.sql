set @id := ? ;

-- Liste des crédits avec leur montant pour chaque personne
select * from (
-- Liste des credits versement à une autre personne 
(select P.ID_PERSONNE as ID_P, 
        P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM,
        V.DATE_VERSEMENT as DATE,
        MONTANT_VERSEMENT as MONTANT, 'CREDIT' as OPERATION, 
        'VERSEMENT' as TYPE, V.ID_VERSEMENT as ID_A
from VERSEMENT V inner join PERSONNE P
    on P.ID_PERSONNE = V.ID_PERSONNE_P)
union
-- Liste des credits versement à une cagnotte 
(select P.ID_PERSONNE as ID_P, 
        P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, 
        PA.DATE_PARTICIPATION as DATE,
        MONTANT_PARTICIPATION as MONTANT, 'CREDIT' as OPERATION, 
        'CAGNOTTE' as TYPE, PA.ID_PARTICIPATION as ID_A
from PARTICIPATION PA inner join PERSONNE P
    on P.ID_PERSONNE = PA.ID_PERSONNE)
union
-- Liste des credits achat 
(select P.ID_PERSONNE as ID_P, 
        P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, 
        A.DATE_ACHAT as DATE,
        MONTANT_ACHAT as MONTANT, 'CREDIT' as OPERATION, 
        'ACHAT' as TYPE, A.ID_ACHAT as ID_A
from ACHAT A inner join PERSONNE P
    on P.ID_PERSONNE = A.ID_PERSONNE) 
                ) L
-- Décommenter la ligne suivante pour avoir la liste des debits pour chaque personne
where ID_P = @id
order by 1 asc, 3 asc;