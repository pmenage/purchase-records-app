set @id := ? ;

-- Liste des débits et leur montant pour tout le monde
select * from (
-- Liste des debits recevoir argent 
(select P.ID_PERSONNE as ID_P, 
        P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM,  
        V.DATE_VERSEMENT as DATE,
        MONTANT_VERSEMENT as MONTANT, 'DEBIT' as OPERATION, 
        'VERSEMENT' as TYPE, V.ID_VERSEMENT as ID_A
from VERSEMENT V inner join PERSONNE P
    on P.ID_PERSONNE = V.ID_PERSONNE_R)
union
-- Liste des debits concerne achat
(select P.ID_PERSONNE as ID_P,
        P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, 
        A.DATE_ACHAT as DATE,
        ROUND(MONTANT_ACHAT/(
                        -- Nombres de personnes concernées par achat 
                        select NB_PERS_CONCERNE
                        from (select ID_ACHAT, count(C.ID_PERSONNE) as NB_PERS_CONCERNE
                              from CONCERNE C
                              group by ID_ACHAT) as AC
                        where AC.ID_ACHAT = A.ID_ACHAT), 2) as MONTANT,
        'DEBIT' as OPERATION, 'ACHAT' as TYPE, A.ID_ACHAT as ID_A
from (ACHAT A inner join CONCERNE C
    on A.ID_ACHAT = C.ID_ACHAT)
    inner join PERSONNE P
        on P.ID_PERSONNE = C.ID_PERSONNE)
                ) L
-- Décommenter la ligne suivante pour avoir la liste des débits pour chaque personne
where ID_P = @id
order by 1 asc, 3 asc;