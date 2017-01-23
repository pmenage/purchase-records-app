-- Pour une personne donnée, la liste des crédits avec leur montant */
select * from (
-- Liste des credits versement à une autre personne 
    (select P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM,  
          MONTANT_VERSEMENT as MONTANT,'versement' as TYPE,
          V.ID_VERSEMENT as ID
    from VERSEMENT V inner join PERSONNE P
        on ? = V.ID_PERSONNE_P)
union
-- Liste des credits versement à une cagnotte 
    (select P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, 
            MONTANT_PARTICIPATION as MONTANT, 
          'cagnotte' as TYPE, PA.ID_PARTICIPATION as ID
    from PARTICIPATION PA inner join PERSONNE P
        on ? = PA.ID_PERSONNE)
union
-- Liste des credits achat 
    (select P.NOM_PERSONNE as NOM, P.PRENOM_PERSONNE as PRENOM, 
            MONTANT_ACHAT as MONTANT, 'achat' as TYPE,
            A.ID_ACHAT as ID
    from ACHAT A inner join PERSONNE P
        on ? = A.ID_PERSONNE)) L
where NOM = ? and PRENOM = ?
order by 1 asc, 3 asc;