

/* Nom(s) : Fabrice Kouakou & Jeff-Love Jean Francois */


/* PARTIE 2 */
/* d�truit la bd si elle existe */

use master
go
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Bd_Reseau')
BEGIN
    ALTER DATABASE Bd_Reseau SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	drop database Bd_Reseau
END


/* cr�ation de votre bd  */

CREATE DATABASE Bd_Reseau
go

Use Bd_Reseau
go

/* cr�ation de vos tables simples */

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



/*	4- Cas �u toutes les contraintes sont d�finis DANS le create de la table, 
	auncune contrainte apr�s le create (dans le cas d'une table avec une cl� �trang�re) */

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


/*  5- Cas o� toutes les contraintes sont d�finis APR�S la creation de la table (dans le cas d'une table avec cl� �trang�re)*/
	
		/* contraintes APRES la c�ation de la derni�re table */

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
  
/* 10-m'assure qu'il n'y a pas 2 pi�ces pareils pour un projet */
/* 11- unicit� */ 


/* PARTIE 3 */
/* 2. a) insertion de donn�es en batch � partir de bdDonnee pour les employes */
/* 2. b) insertion de donn�es en batch � partir de bdDonnee pour les pieces de votre sujet */
/* 2. c) pratique cross apply : trouver les employ�s qui ont un nom et pr�nom identique � d�autres. */
/* 3. ajout de donn�es, au moins 3 dans chaque table */

/* 3. a)	Pour la table de projet, ajouter 4 donn�es dont 2 pour la m�me compagnie */
/* 3. b)	Pour la table des projets-pi�ces, faites des ajouts pour 2 projets diff�rents et pour chacun utiliser au moins 3 pi�ces diff�rentes. 
			Une m�me pi�ce sera dans les 2 projets*/

/* 3. c)	Pour la table d�imputation, utiliser comme employ�, un employ� ayant le m�me nom qu�un autre. 			
			Pour un m�me projet,un des employ�s aura 2 imputations et l�autre une. 
			Ajouter 3 imputations pour le m�me projet.
			Ajouter 2 pi�ces diff�rentes parmi celles import�es et une pareille. Bien entendu, ce doit �tre les pi�ces d�j� associ�es � ce projet (projets-pi�ces). 
			Assurez-vous que ce soit toujours la date d�aujourd�hui lorsque vous ex�cutez votre script.
			*/
/* c) m�me chose pour un 2e projet */ 

/* 4. un select des tables pour prouver les bons ajouts */

/* 5.	Faites une instruction SQL qui vous affiche, pour chaque pi�ce, le nombre d�imputations r�alis� en tout dans le magasin, 
		la quantit� totale de pi�ces imput�es, 
		et le nombre de projets dont elle fait partie. (Select avanc�).
*/
/* 6. tests de contrainte  */
/* contrainte CHECK sur email */	

/* contrainte CHECK sur quantitePrevu */	

/* contrainte CHECK sur quantiteStock */
	
/* contrainte CHECK sur quantitePieceImpute */

/* contrainte sur dateImputation */
	
/* m'assure qu'il n'y a pas 2 pi�ces pareils pour un projet */
	
/* La description d�un projet ne pourra pas �tre identique � un autre projet*/

/* le nom de compagnie ne peut pas �tre identique � une autre compagnie */

/* les num�ros d�une pi�ce de l�industrie doivent �tre tous diff�rents*/





