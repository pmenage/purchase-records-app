-- ============================================================
--    creation des donnees
-- ============================================================

-- PERSONNE

insert into PERSONNE values ( null , 'DUPONT' , 'MARIE' , 'marie.dupont@gmail.com' , '17 RUE DU CAILLOU 33400 TALENCE' , '0137492847') ;
insert into PERSONNE values ( null , 'MARTEAU' , 'EUGENE' , 'eugmarteau@outlook.com' , '13 RUE DU GENOU 33600 PESSAC' , '0138394687') ;
-- Test des champs nuls adresse et telephone
insert into PERSONNE values ( null , 'LAFONT' , 'REMI' , 'remilafont@gmail.com' , '92 BOULEVARD MARIUS 33000 BORDEAUX' , null ) ;
insert into PERSONNE values ( null , 'DURANT', 'JEAN' , 'jdurant@hotmail.com' , null , '0635697810' ) ;
-- Même nom de famille qu'un autre membre de la colocation
insert into PERSONNE values ( null , 'DUPONT' , 'GEORGE' , 'george_dupont@gmail.com' , null, null ) ;

commit;

-- COLOCATION

insert into COLOCATION values ( null , 'CUN' , '28 RUE EUGENE 92100 BOULOGNE' , 1 ) ;
-- Adresse de colocation et adresse principale identique
insert into COLOCATION values ( null , 'CDEUX', '76 AVENUE DES PETITS POIS 33000 BORDEAUX' , 3 ) ; 

commit ;

-- COLOCATAIRE

insert into COLOCATAIRE values ( null, 2 , 1 , '19910101' , null ) ;
-- Le gestionnaire est aussi colocataire
insert into COLOCATAIRE values ( null, 3 , 2 , '19910101' , '20000801' ) ; 
insert into COLOCATAIRE values ( null, 1 , 2 , '20120901' , null ) ; 
insert into COLOCATAIRE values ( null, 4 , 2 , '20140901' , '20150701' ) ;
insert into COLOCATAIRE values ( null, 5 , 2 , '20150901' , null ) ;
-- Revient une 2e fois dans la colocation apres l'avoir quitté
insert into COLOCATAIRE values ( null, 4 , 2 , '20160616' , null ) ;

commit ;

-- CAGNOTTE

insert into CAGNOTTE values ( null , 2 ) ;

commit ; 

-- PARTICIPATION

insert into PARTICIPATION values ( null , 3 , 1 , '20161101' , 20.00 ) ;
insert into PARTICIPATION values ( null , 1 , 1 , '20161101' , 40.00 ) ;
insert into PARTICIPATION values ( null , 3 , 1 , '20161102' , 0.33) ;

commit ; 

-- VERSEMENT
-- Effectuer un versement nul à soi-même
insert into VERSEMENT values ( null , '19910101' , 0.00 , 2 , 2 ) ;
insert into VERSEMENT values ( null , '19910101' , 0.00 , 3 , 3 ) ;
insert into VERSEMENT values ( null , '20120901' , 0.00 , 1 , 1 ) ;
insert into VERSEMENT values ( null , '20140901' , 0.00 , 4 , 4 ) ;
insert into VERSEMENT values ( null , '20150901' , 0.00 , 5 , 5 ) ;
-- 3 possède 2 credits de mêmes dates, même montants et mêmes id
insert into VERSEMENT values ( null , '20161101' , 20.00 , 3 , 1 ) ;
insert into VERSEMENT values ( null , '20161102' , 20.00 , 1 , 3 ) ;

commit ;

-- ACHAT

insert into ACHAT values ( null , 'CHAUSSETTES' , '19960204' , 20.00 , 1 , 2 ) ;
-- Effectuer un achat qui ne nous concerne pas
insert into ACHAT values ( null , 'MANGER' , '20161101' , 50.00 , 2 , 1 ) ; 
-- Effectuer un achat avec la cagnotte
insert into ACHAT values ( null , 'MANGER' , '20161102' , 61.00 , 2 , null ) ; 
commit ; 

-- CONCERNE

insert into CONCERNE values ( 1 , 2 ) ;
-- Achat ne concernant qu'une personne
insert into CONCERNE values ( 2 , 4 ) ;
-- Achat concernant plusieurs personnes
insert into CONCERNE values ( 3 , 1 ) ;
insert into CONCERNE values ( 3 , 3 ) ;
insert into CONCERNE values ( 3 , 4 ) ;

-- Le solde de 3 est nul (ses crédits et débits s'équilibrent)
-- Le solde de 5 est nul (il n'a aucun crésit ni débit)
-- Le solde de 4 est négatif 
-- Le solde de 1 est positif 

commit ; 

-- ============================================================
--    verification des donnees
-- ============================================================
