set @coloc:= ? ;

select S.ID, S.NOM, S.PRENOM, ROUND(S.SOLDE, 2) as SOLDE from
(select * from MEMBERS) M,

-- Liste des soldes
(select D.ID, D.NOM, D.PRENOM, (C.TOTAL_CREDIT - D.TOTAL_DEBIT) as SOLDE
from 
-- Total des débits
(select DEB.ID_PERSONNE as ID, DEB.NOM, DEB.PRENOM, SUM(DEB.MONTANT) as TOTAL_DEBIT from (
-- Liste des débits et leur montant
select * from (
-- Liste des debits recevoir argent 
    (select P.ID_PERSONNE, P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM,  
            MONTANT_VERSEMENT as MONTANT, 'VERSEMENT' as TYPE, V.ID_VERSEMENT as ID
    from VERSEMENT V inner join PERSONNE P
        on P.ID_PERSONNE = V.ID_PERSONNE_R)
union
-- Liste des debits concerne achat
    (select P.ID_PERSONNE, P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, MONTANT_ACHAT/(
            -- Nombre de personnes concernees par achat 
            select NB_PERS_CONCERNE
            from (select ID_ACHAT, count(C.ID_PERSONNE) as NB_PERS_CONCERNE
                  from CONCERNE C
                  group by ID_ACHAT) as AC
            where AC.ID_ACHAT = A.ID_ACHAT) as MONTANT, 'ACHAT' as TYPE, A.ID_ACHAT as ID
    from (ACHAT A inner join CONCERNE C
        on A.ID_ACHAT = C.ID_ACHAT)
        inner join PERSONNE P
        on P.ID_PERSONNE = C.ID_PERSONNE)
order by 1 asc, 3 asc ) LD
) DEB 
group by DEB.ID_PERSONNE 
) D,

-- Total des credits
(select CRE.ID_PERSONNE as ID, CRE.NOM, CRE.PRENOM, SUM(CRE.MONTANT) as TOTAL_CREDIT from(
-- Liste des crédits avec leur montant
select * from (
-- Liste des credits versement à une autre personne
(select P.ID_PERSONNE, P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, V.DATE_VERSEMENT as DATE, 
        MONTANT_VERSEMENT as MONTANT, 'CREDIT' as OPERATION, 
        'VERSEMENT' as TYPE, V.ID_VERSEMENT as ID
from VERSEMENT V inner join PERSONNE P
    on P.ID_PERSONNE = V.ID_PERSONNE_P)
union
-- Liste des credits versement à une cagnotte 
(select P.ID_PERSONNE, P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, PA.DATE_PARTICIPATION as DATE, 
        MONTANT_PARTICIPATION as MONTANT, 'CREDIT' as OPERATION, 
        'CAGNOTTE' as TYPE, PA.ID_PARTICIPATION as ID
from PARTICIPATION PA inner join PERSONNE P
    on P.ID_PERSONNE = PA.ID_PERSONNE)
union
-- Liste des credits achat 
(select P.ID_PERSONNE, P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, A.DATE_ACHAT as DATE,
        MONTANT_ACHAT as MONTANT, 'CREDIT' as OPERATION, 
        'ACHAT' as TYPE, A.ID_ACHAT as ID
from ACHAT A inner join PERSONNE P
    on P.ID_PERSONNE = A.ID_PERSONNE)
order by 1 asc, 3 asc ) LC
) CRE 
group by CRE.ID_PERSONNE ) C
where C.ID = D.ID ) S
where M.ID = S.ID
-- Commenter la ligne suivante pour avoir la liste des soldes de tout le monde
and M.NOM_COLOCATION = @coloc
;
