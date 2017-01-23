/* Liste des débits */

-- Pour l'interface

(select MONTANT_VERSEMENT as DEBIT
 from VERSEMENT V
 where V.ID_PERSONNE_R = ?)
union
/* liste des debits concerne achat */
(select ROUND(MONTANT_ACHAT/(
/* nb de personnes concernes par achat */
                                    select NB_PERS_CONCERNE
                                    from (select ID_ACHAT, count(ID_PERSONNE) as NB_PERS_CONCERNE
                                          from CONCERNE C
                                          group by ID_ACHAT) as AC
                                    where AC.ID_ACHAT = A.ID_ACHAT),2) as DEBIT
 from (ACHAT A inner join CONCERNE C
    on A.ID_ACHAT = C.ID_ACHAT)
    where ? = C.ID_PERSONNE)
order by 1 ASC;