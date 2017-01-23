use COLOC;

-- ============================================================
--   Nom de la base   :  COLOCATIONS                               
--   Nom de SGBD      :  ORACLE Version 7.0                    
--   Date de creation :  22/11/16  16:59
--   Auteurs  	      :  eleclerc001, pmenage, wchan                     
-- ============================================================
-- ============================================================
--   Table : PERSONNE                                           
-- ============================================================

create table PERSONNE
(
    ID_PERSONNE 			int 		not null auto_increment,
    NOM_PERSONNE			varchar(20) not null,
    PRENOM_PERSONNE 		varchar(20) not null,
    MAIL_PERSONNE			varchar(40) not null,
	ADRESSE_PERSONNE		varchar(40)	,
	TELEPHONE_PERSONNE		varchar(10)	,
    primary key (ID_PERSONNE)
);


-- ============================================================
--   Table : COLOCATION                                         
-- ============================================================
create table COLOCATION
(
	ID_COLOCATION			int			not null auto_increment,
	NOM_COLOCATION			varchar(20)	not null,
	ADRESSE_COLOCATION		varchar(40)	not null,
	ID_PERSONNE				int			not null,
	primary key (ID_COLOCATION)
);

-- ============================================================
--   Index : COLOCATION_FK1                                          
-- ============================================================
-- create index COLOCATION_FK1 on COLOCATION (ID_PERSONNE asc);

-- ============================================================
--   Table : COLOCATAIRE                                    
-- ============================================================
create table COLOCATAIRE
(
	ID_COLOCATAIRE			int			not null auto_increment,
	ID_PERSONNE				int			not null,
	ID_COLOCATION			int			not null,
	DATE_ENTREE_COLOC		date		not null,
	DATE_SORTIE_COLOC		date		,
	primary key (ID_COLOCATAIRE)
);

-- ============================================================
--   Table : CAGNOTTE                                          
-- ============================================================
create table CAGNOTTE
(
	ID_CAGNOTTE				int			not null auto_increment,
	ID_COLOCATION			int			not null,
    primary key (ID_CAGNOTTE)
);

-- ============================================================
--   Index : CAGNOTTE_FK1                                        
-- ============================================================
-- create index CAGNOTTE_FK1 on CAGNOTTE (ID_COLOCATION asc);

-- ============================================================
--   Table : PARTICIPATION                                            
-- ============================================================
create table PARTICIPATION
(
	ID_PARTICIPATION		int			not null auto_increment,
	ID_PERSONNE				int			not null,
	ID_CAGNOTTE				int			not null,
	DATE_PARTICIPATION		date		not null,
	MONTANT_PARTICIPATION	float		not null,
	primary key (ID_PARTICIPATION)
);		

-- ============================================================
--   Table : VERSEMENT                                            
-- ============================================================
create table VERSEMENT
(
	ID_VERSEMENT			int			not null auto_increment,
	DATE_VERSEMENT			DATE		not null,
	MONTANT_VERSEMENT		FLOAT		not null,
	ID_PERSONNE_P			int			not null,
	ID_PERSONNE_R			int			not null,
    primary key (ID_VERSEMENT)
);

-- ============================================================
--   Index : VERSEMENT_FK1                                        
-- ============================================================
-- create index VERSEMENT_FK1 on VERSEMENT (ID_PERSONNE_P asc);

-- ============================================================
--   Index : VERSEMENT_FK2                                        
-- ============================================================
-- create index VERSEMENT_FK2 on VERSEMENT (ID_PERSONNE_R asc);

-- ============================================================
--   Table : ACHAT
-- ============================================================
create table ACHAT
(
	ID_ACHAT				int			not null auto_increment,
	INTITULE				varchar(20)	,
	DATE_ACHAT				date		not null,
	MONTANT_ACHAT			float		not null,
	ID_COLOCATION			int			not null,
	ID_PERSONNE				int			,
	primary key (ID_ACHAT)
);

-- ============================================================
--   Index : ACHAT_FK1                                        
-- ============================================================
-- create index ACHAT_FK1 on ACHAT (ID_COLOCATION asc);

-- ============================================================
--   Index : ACHAT_FK2                                        
-- ============================================================
-- create index ACHAT_FK2 on ACHAT (ID_PERSONNE asc);

-- ============================================================
--   Table : CONCERNE                                      
-- ============================================================
create table CONCERNE
(
	ID_ACHAT				int			not null,
	ID_PERSONNE				int			not null,
	primary key (ID_PERSONNE, ID_ACHAT)
);

alter table COLOCATION
      add constraint fk_colocation foreign key (ID_PERSONNE)
      	  references PERSONNE (ID_PERSONNE);

alter table COLOCATAIRE
      add constraint fk1_colocataire foreign key (ID_PERSONNE)
      	  references PERSONNE (ID_PERSONNE);

alter table COLOCATAIRE
      add constraint fk2_colocataire foreign key (ID_COLOCATION)
      	  references COLOCATION (ID_COLOCATION);

alter table CAGNOTTE
      add constraint fk1_cagnotte foreign key (ID_COLOCATION)
      	  references COLOCATION (ID_COLOCATION);

alter table PARTICIPATION
      add constraint fk1_participation foreign key (ID_PERSONNE)
      	  references PERSONNE (ID_PERSONNE);

alter table PARTICIPATION
      add constraint fk2_participation foreign key (ID_CAGNOTTE)
      	  references CAGNOTTE (ID_CAGNOTTE);

alter table VERSEMENT
      add constraint fk1_versement foreign key (ID_PERSONNE_P)
      	  references PERSONNE (ID_PERSONNE);

alter table VERSEMENT
      add constraint fk2_versement foreign key (ID_PERSONNE_R)
      	  references PERSONNE (ID_PERSONNE);

alter table ACHAT
      add constraint fk1_achat foreign key (ID_COLOCATION)
      	  references COLOCATION (ID_COLOCATION);

alter table ACHAT
      add constraint fk2_achat foreign key (ID_PERSONNE)
      	  references PERSONNE (ID_PERSONNE);

alter table CONCERNE
      add constraint fk1_concerne foreign key (ID_PERSONNE)
      	  references PERSONNE (ID_PERSONNE);

alter table CONCERNE
      add constraint fk2_concerne foreign key (ID_ACHAT)
      	  references ACHAT (ID_ACHAT);
