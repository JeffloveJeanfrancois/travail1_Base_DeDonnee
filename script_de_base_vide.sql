

/* Nom(s) : Fabrice Kouakou & Jeff-Love Jean Francois */


/* PARTIE 2 */
/* détruit la bd si elle existe */

use master
go
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Bd_Reseau')
BEGIN
    ALTER DATABASE Bd_Reseau SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	drop database Bd_Reseau
END


/* création de votre bd  */

CREATE DATABASE Bd_Reseau
go

Use Bd_Reseau
go

/* création de vos tables simples */

create table tbl_compagnie(
id_compagnie int primary key,
nom nvarchar(200) unique
)
go

create table tbl_piece(
id_piece int identity primary key,
description nvarchar(200),
numeroIndustrie int unique
)
go

create table tbl_employee(
id_employee int identity primary key,
nom nvarchar(200),
prenom nvarchar(200),
email nvarchar(200) null 
)
go


/* 9- modification d'un null en not null */

alter table tbl_employee
alter column email nvarchar(200) not null
go

alter table tbl_employee 
add constraint UQ_email unique (email)
go

alter table tbl_employee
add constraint Ck_email Check (email like '%[@]%')
go



/*	4- Cas òu toutes les contraintes sont définis DANS le create de la table, 
	auncune contrainte après le create (dans le cas d'une table avec une clé étrangère) */

	create table tbl_projet(
	id_projet int identity primary key,
	nom nvarchar(200) unique,
	description nvarchar(200), 
	id_compagnie int references tbl_compagnie(id_compagnie) not null
	)
	go

	create table tbl_stock(
	id_stock int identity primary key, 
	quantite_stock int,
	quantite_prevu int,
	check (quantite_stock >= 0),
	Check (quantite_prevu >= 0),
	id_piece int references tbl_piece(id_piece) not null,
	id_projet int references tbl_projet(id_projet) not null,
	constraint UQ_projetPiece unique (id_piece, id_projet)
	)
	go


/*  5- Cas où toutes les contraintes sont définis APRÈS la creation de la table (dans le cas d'une table avec clé étrangère)*/
	
		/* contraintes APRES la céation de la dernière table */

		create table tbl_impute(
		quantite_impute int,
		date_imputee date,
		id_employee int not null,
		id_stock int not null
		)
		go

		alter table tbl_impute
		add constraint FK_impute_employee foreign key (id_employee) references tbl_employee(id_employee),
		constraint FK_impute_stock foreign key (id_stock) references tbl_stock(id_stock),
		constraint CK_quantiteImpute Check (quantite_impute >= 0),
		constraint Dt_dateImpute check (date_imputee <= getDate())

		go


 --pour ajouter les piece il faut prendre ceux qui n'ont pas de generique 
  
/* 10-m'assure qu'il n'y a pas 2 pièces pareils pour un projet */
/* 11- unicité */ 


/* PARTIE 3 */
/* 2. a) insertion de données en batch à partir de bdDonnee pour les employes */
/* 2. b) insertion de données en batch à partir de bdDonnee pour les pieces de votre sujet */
/* 2. c) pratique cross apply : trouver les employés qui ont un nom et prénom identique à d’autres. */
/* 3. ajout de données, au moins 3 dans chaque table */

/* 3. a)	Pour la table de projet, ajouter 4 données dont 2 pour la même compagnie */
/* 3. b)	Pour la table des projets-pièces, faites des ajouts pour 2 projets différents et pour chacun utiliser au moins 3 pièces différentes. 
			Une même pièce sera dans les 2 projets*/

/* 3. c)	Pour la table d’imputation, utiliser comme employé, un employé ayant le même nom qu’un autre. 			
			Pour un même projet,un des employés aura 2 imputations et l’autre une. 
			Ajouter 3 imputations pour le même projet.
			Ajouter 2 pièces différentes parmi celles importées et une pareille. Bien entendu, ce doit être les pièces déjà associées à ce projet (projets-pièces). 
			Assurez-vous que ce soit toujours la date d’aujourd’hui lorsque vous exécutez votre script.
			*/
/* c) même chose pour un 2e projet */ 

/* 4. un select des tables pour prouver les bons ajouts */

/* 5.	Faites une instruction SQL qui vous affiche, pour chaque pièce, le nombre d’imputations réalisé en tout dans le magasin, 
		la quantité totale de pièces imputées, 
		et le nombre de projets dont elle fait partie. (Select avancé).
*/
/* 6. tests de contrainte  */
/* contrainte CHECK sur email */	

/* contrainte CHECK sur quantitePrevu */	

/* contrainte CHECK sur quantiteStock */
	
/* contrainte CHECK sur quantitePieceImpute */

/* contrainte sur dateImputation */
	
/* m'assure qu'il n'y a pas 2 pièces pareils pour un projet */
	
/* La description d’un projet ne pourra pas être identique à un autre projet*/

/* le nom de compagnie ne peut pas être identique à une autre compagnie */

/* les numéros d’une pièce de l’industrie doivent être tous différents*/





