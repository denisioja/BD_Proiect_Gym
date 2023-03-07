--CREAREA TABELELOR

create sequence Vestiar_ID_Vestiar_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Vestiar (
    ID_Vestiar int constraint Vestiar_ID_Vestiar_PK primary key,
    Numar_chei int constraint Vestiar_Numar_chei_NN not null,
    Dimeniune int constraint Vestiar_Dimensiune_NN not null
);

create sequence Angajat_ID_Angajat_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Angajat (
    ID_Angajat int constraint Angajat_ID_Angajat_PK primary key,
    Nume varchar(20) constraint Angajat_Nume_NN not null,
    Prenume varchar(20) constraint Angajat_Prenume_NN not null,
    Data_nastere date constraint Angajat_Data_nastere_NN not null,
    Post varchar(20) constraint Angajat_Post_NN not null,
    Salariu number(7,2)
        constraint Angajat_Salariu_NN not null
        constraint Angajat_Salariu_CK check (Salariu >= 1000),
    Data_angajare date default trunc(sysdate)
        constraint Angajat_Data_angajare_NN not null,
    Vanzari int,
    Nr_clienti_antrenati int
);

create sequence Client_ID_Client_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Client (
    ID_Client int constraint Client_ID_Client_PK primary key,
    Nume varchar(20),
    Prenume varchar(20),
    Adresa varchar(30),
    ID_Vestiar int constraint Client_ID_Vestiar_FK references Vestiar(ID_Vestiar) on delete set null,
    ID_Angajat int constraint Client_ID_Angajat_FK references Angajat(ID_Angajat) on delete set null,
    Data_nastere date
);

create sequence Tip_abon_ID_Tip_abonament_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Tip_abon (
    ID_Tip_abon int constraint Tip_abon_ID_Tip_abonament_PK primary key,
    Denumire varchar(30) constraint Tip_abon_Denumire_NN not null,
    Pret number(7,2) constraint Tip_abon_Pret_NN not null,
    Include_sauna char(2)
        constraint Tip_abon_Include_sauna_NN not null
        constraint Tip_abon_Include_sauna_CK check ( Include_sauna in ('Da', 'Nu') ),
    Include_aerobic char(2)
        constraint Tip_abon_Include_aerobic_NN not null
        constraint Tip_abon_Include_aerobic_CK check ( Include_aerobic in ('Da', 'Nu') )
);

create sequence Abonamente_ID_Abonament_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Abonamente (
    ID_Abonamente int constraint Abonamente_ID_Abonamente_PK primary key,
    ID_Tip_Abonament int
        constraint Abonamente_ID_Tip_Abonament_NN not null
        constraint Abonamente_ID_Tip_Abonament_FK references Tip_abon(ID_Tip_abon) on delete cascade,
    ID_Client int
        constraint Abonamente_ID_Client_NN not null
        constraint Abonamente_ID_Client_FK references Client(ID_Client) on delete cascade,
    Data_inceput date default trunc(sysdate),
    Data_sfarsit date,
    ID_Angajat int
        constraint Abonamente_ID_Angajat_NN not null
        constraint Abonamente_ID_Angajat_FK references Angajat(ID_Angajat) on delete set null

);

create sequence Vanzari_ID_Vanzare_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Vanzari (
    ID_Vanzare int constraint Vanzari_ID_Vanzare_PK primary key,
    ID_Client int
        constraint Vanzari_ID_Client_FK references Client(ID_Client) on delete cascade
        constraint Vanzari_ID_Client_NN not null,
    Data date default trunc(sysdate)
        constraint Vanzari_Data_NN not null,
    ID_Angajat int
        constraint Vazari_ID_Angajat_FK references Angajat(ID_Angajat) on delete cascade
        constraint Vazari_ID_Angajat_NN not null
);

create sequence Furnizor_ID_Furnizor_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Furnizor (
    ID_Furnizor int constraint Furnizor_ID_Furnizor_PK primary key,
    Nume varchar(20) constraint Furnizor_Nume_NN not null,
    Adresa varchar(30) constraint Furnizor_Adresa_NN not null
);

create sequence Cat_produs_ID_Cat_produs_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Cat_produs (
    ID_Categorie_produs int constraint Cat_produs_ID_Cat_produs_PK primary key,
    Nume varchar(20) constraint Cat_produs_Nume_NN not null
);

create sequence Produse_ID_Produs_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Produse (
    ID_Produs int constraint Produse_ID_Produs_PK primary key,
    Denumire_produs varchar(20) constraint Produse_Denumire_produs_NN not null,
    ID_Furnizor int
        constraint Produse_ID_Furnizor_NN not null
        constraint Produse_ID_Furnizor_FK references Furnizor(ID_Furnizor) on delete set null,
    ID_Categorie int
        constraint Produse_ID_Categorie_NN not null
        constraint Produse_ID_Categorie_FK references Cat_produs(ID_Categorie_produs) on delete cascade,
    Pret_vanzare number(7,2)
        constraint Produse_Pret_vanzare_NN not null,
        constraint Produse_Pret_vanzare_CK check ( Pret_vanzare >= Pret_cumparare ),
    Pret_cumparare number(7,2) constraint Produse_Pret_cumparare_NN not null,
    Stoc int default 0
        constraint Produse_Stoc_CK check ( Stoc > 0 )
        constraint Produse_Stoc_NN not null,
    Cantite_vanduta int default 0
        constraint Produse_Cantitate_vanduta_NN not null
);

create sequence Prod_vand_ID_Prod_vand_Seq
start with 1
maxvalue 99999
nocycle nocache;

create table Prod_vand (
    ID_Produse_vandute int constraint Prod_vand_ID_Prod_vand_PK primary key ,
    ID_Produs int
        constraint Prod_vand_ID_Produs_FK references Produse(ID_Produs) on delete cascade
        constraint Prod_vand_ID_Produs_NN not null,
    ID_Vanzare int
        constraint Prod_vand_ID_Vanzare_FK references Vanzari(ID_Vanzare) on delete cascade
        constraint Prod_vand_ID_Vanzare_NN not null,
    Cantitate int default 1
        constraint Prod_vand_Cantiate_NN not null,
        constraint Prod_vand_Cantiate_CK check (Cantitate>=1)
);

--CONSTRANGERI, SEQUENCE SI STERGERE PENTRU TABELE

drop sequence Client_ID_Client_Seq;
drop table Client cascade constraints;

drop sequence Abonamente_ID_Abonament_Seq;
drop table Abonamente;

drop sequence Tip_abon_ID_Tip_abonament_Seq;
drop table Tip_abon cascade constraints;

drop sequence Vestiar_ID_Vestiar_Seq;
drop table Vestiar cascade constraints;

drop sequence Angajat_ID_Angajat_Seq;
drop table Angajat cascade constraints;

drop sequence Vanzari_ID_Vanzare_Seq;
drop table Vanzari cascade constraints;

drop sequence Prod_vand_ID_Prod_vand_Seq;
drop table Prod_vand;

drop sequence Produse_ID_Produs_Seq;
drop table Produse cascade constraints;

drop sequence Furnizor_ID_Furnizor_Seq;
drop table Furnizor cascade constraints;

drop sequence Cat_produs_ID_Cat_produs_Seq;
drop table Cat_produs cascade constraints;

--INSERARE DATE

--Vestiar

insert into Vestiar(ID_Vestiar, Numar_chei, Dimeniune)
values (Vestiar_ID_Vestiar_Seq.nextval, 2, 2500);

insert into Vestiar(ID_Vestiar, Numar_chei, Dimeniune)
values (Vestiar_ID_Vestiar_Seq.nextval, 3, 2400);

insert into Vestiar(ID_Vestiar, Numar_chei, Dimeniune)
values (Vestiar_ID_Vestiar_Seq.nextval, 1, 2450);

insert into Vestiar(ID_Vestiar, Numar_chei, Dimeniune)
values (Vestiar_ID_Vestiar_Seq.nextval, 3, 2550);

insert into Vestiar(ID_Vestiar, Numar_chei, Dimeniune)
values (Vestiar_ID_Vestiar_Seq.nextval, 2, 2500);

--Angajat

insert into Angajat(ID_Angajat, Nume, Prenume, Data_nastere, Post, Salariu, Data_angajare, Vanzari, Nr_clienti_antrenati)
values (Angajat_ID_Angajat_Seq.nextval, 'Vaidos', 'Marcel', TO_DATE('12-01-2002', 'DD-MM-YYYY'), 'Antrenor', 3000, TO_DATE('14-05-2020', 'DD-MM-YYYY'), null, 5);

insert into Angajat(ID_Angajat, Nume, Prenume, Data_nastere, Post, Salariu, Data_angajare, Vanzari, Nr_clienti_antrenati)
values (Angajat_ID_Angajat_Seq.nextval, 'Husariu', 'Paul', TO_DATE('29-11-2003', 'DD-MM-YYYY'), 'Receptioner', 2500, TO_DATE('13-08-2019', 'DD-MM-YYYY'), 6, null);

insert into Angajat(ID_Angajat, Nume, Prenume, Data_nastere, Post, Salariu, Data_angajare, Vanzari, Nr_clienti_antrenati)
values (Angajat_ID_Angajat_Seq.nextval, 'Spaciu', 'Daniel', TO_DATE('23-06-2000', 'DD-MM-YYYY'), 'Antrenor', 3100, TO_DATE('02-12-2018', 'DD-MM-YYYY'), null, 3);

insert into Angajat(ID_Angajat, Nume, Prenume, Data_nastere, Post, Salariu, Data_angajare, Vanzari, Nr_clienti_antrenati)
values (Angajat_ID_Angajat_Seq.nextval, 'Dobre', 'Ana', TO_DATE('30-05-1989', 'DD-MM-YYYY'), 'Ingrijitoare', 2000, TO_DATE('18-03-2015', 'DD-MM-YYYY'), null, null);

insert into Angajat(ID_Angajat, Nume, Prenume, Data_nastere, Post, Salariu, Data_angajare, Vanzari, Nr_clienti_antrenati)
values (Angajat_ID_Angajat_Seq.nextval, 'Tepes', 'Raluca', TO_DATE('19-09-1999', 'DD-MM-YYYY'), 'Receptioner', 2500, TO_DATE('04-04-2021', 'DD-MM-YYYY'), 10, null);

--Client

insert into Client(ID_Client, Nume, Prenume, Adresa, ID_Vestiar, ID_Angajat, Data_nastere)
values (Client_ID_Client_Seq.nextval, 'Ionescu', 'Mihai','Calea Giulesti, nr.69', 1, 1, TO_DATE('12-01-2003', 'DD-MM-YYYY'));

insert into Client(ID_Client, Nume, Prenume, Adresa, ID_Vestiar, ID_Angajat, Data_nastere)
values (Client_ID_Client_Seq.nextval, null, null, null, null, null, null);

insert into Client(ID_Client, Nume, Prenume, Adresa, ID_Vestiar, ID_Angajat, Data_nastere)
values (Client_ID_Client_Seq.nextval, 'Dumitru', 'Fabian', 'Calea Dristorului, nr.10', 2, 3, TO_DATE('26-02-1999', 'DD-MM-YYYY'));

insert into Client(ID_Client, Nume, Prenume, Adresa, ID_Vestiar, ID_Angajat, Data_nastere)
values (Client_ID_Client_Seq.nextval, 'Besel', 'Adrian', 'Str Baba Novac, nr.10', 4, 2, TO_DATE('24-07-2002', 'DD-MM-YYYY'));

insert into Client(ID_Client, Nume, Prenume, Adresa, ID_Vestiar, ID_Angajat, Data_nastere)
values (Client_ID_Client_Seq.nextval, 'Popescu', 'George', 'Str. Camapuling, nr.1', 3, 1, TO_DATE('12-08-2002', 'DD-MM-YYYY'));

--Tip abonament

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o zi', 40, 'Nu', 'Nu');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o zi', 45, 'Da', 'Nu');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o zi', 45, 'Nu', 'Da');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o zi', 50, 'Da', 'Da');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o saptamana', 60, 'Nu', 'Nu');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o saptamana', 65, 'Da', 'Nu');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o saptamana', 65, 'Nu', 'Da');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o saptamana', 70, 'Da', 'Da');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o luna', 120, 'Nu', 'Nu');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o luna', 125, 'Da', 'Nu');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o luna', 125, 'Nu', 'Da');

insert into Tip_abon(ID_Tip_abon, Denumire, Pret, Include_sauna, Include_aerobic)
values (Tip_abon_ID_Tip_abonament_Seq.nextval, 'Abonament pentru o luna', 130, 'Da', 'Da');

--Abonamente

insert into Abonamente(ID_Abonamente, ID_Tip_Abonament, ID_Client, Data_inceput, Data_sfarsit, ID_Angajat)
values (Abonamente_ID_Abonament_Seq.nextval, 1, 1, TO_DATE('24-01-2023', 'DD-MM-YYYY'), TO_DATE('25-01-2023', 'DD-MM-YYYY'), 5);

insert into Abonamente(ID_Abonamente, ID_Tip_Abonament, ID_Client, Data_inceput, Data_sfarsit, ID_Angajat)
values (Abonamente_ID_Abonament_Seq.nextval, 5, 4, TO_DATE('24-01-2023', 'DD-MM-YYYY'), TO_DATE('31-01-2023', 'DD-MM-YYYY'), 1);

insert into Abonamente(ID_Abonamente, ID_Tip_Abonament, ID_Client, Data_inceput, Data_sfarsit, ID_Angajat)
values (Abonamente_ID_Abonament_Seq.nextval, 2, 1, TO_DATE('01-02-2023', 'DD-MM-YYYY'), TO_DATE('01-02-2023', 'DD-MM-YYYY'), 3);

insert into Abonamente(ID_Abonamente, ID_Tip_Abonament, ID_Client, Data_inceput, Data_sfarsit, ID_Angajat)
values (Abonamente_ID_Abonament_Seq.nextval, 3, 4, TO_DATE('05-01-2023', 'DD-MM-YYYY'), TO_DATE('05-02-2023', 'DD-MM-YYYY'), 4);

insert into Abonamente(ID_Abonamente, ID_Tip_Abonament, ID_Client, Data_inceput, Data_sfarsit, ID_Angajat)
values (Abonamente_ID_Abonament_Seq.nextval, 2, 4, TO_DATE('17-01-2023', 'DD-MM-YYYY'), TO_DATE('18-01-2023', 'DD-MM-YYYY'), 2);

--Vanzari

insert into Vanzari(ID_Vanzare, ID_Client, ID_Angajat)
values (Vanzari_ID_Vanzare_Seq.nextval, 1, 3);

insert into Vanzari(ID_Vanzare, ID_Client, Data, ID_Angajat)
values (Vanzari_ID_Vanzare_Seq.nextval, 3, TO_DATE('12-01-2023', 'DD-MM-YYYY'), 4);

insert into Vanzari(ID_Vanzare, ID_Client, Data, ID_Angajat)
values (Vanzari_ID_Vanzare_Seq.nextval, 5, TO_DATE('02-11-2022', 'DD-MM-YYYY'), 1);

insert into Vanzari(ID_Vanzare, ID_Client, Data, ID_Angajat)
values (Vanzari_ID_Vanzare_Seq.nextval, 4, TO_DATE('24-12-2022', 'DD-MM-YYYY'), 2);

insert into Vanzari(ID_Vanzare, ID_Client, Data, ID_Angajat)
values (Vanzari_ID_Vanzare_Seq.nextval, 2, TO_DATE('17-12-2022', 'DD-MM-YYYY'), 5);

--Furnizor

insert into Furnizor(ID_Furnizor, Nume, Adresa)
values (Furnizor_ID_Furnizor_Seq.nextval, 'GymBeam', 'Sos. Mihai Bravu, nr.2');

insert into Furnizor(ID_Furnizor, Nume, Adresa)
values (Furnizor_ID_Furnizor_Seq.nextval, 'LR', 'Bd-ul Energeticienilor, nr.7');

insert into Furnizor(ID_Furnizor, Nume, Adresa)
values (Furnizor_ID_Furnizor_Seq.nextval, 'Dymatize', 'Str. Nicolae Iorga, nr.1');

insert into Furnizor(ID_Furnizor, Nume, Adresa)
values (Furnizor_ID_Furnizor_Seq.nextval, 'MuscleTech', 'Splaiul Unirii, nr.12');

insert into Furnizor(ID_Furnizor, Nume, Adresa)
values (Furnizor_ID_Furnizor_Seq.nextval, 'BioTech', 'Int. Rosiori, nr.50');

--Categorie produs

insert into Cat_produs(ID_Categorie_produs, Nume)
values (Cat_produs_ID_Cat_produs_Seq.nextval, 'Proteine');

insert into Cat_produs(ID_Categorie_produs, Nume)
values (Cat_produs_ID_Cat_produs_Seq.nextval, 'Vitamine');

insert into Cat_produs(ID_Categorie_produs, Nume)
values (Cat_produs_ID_Cat_produs_Seq.nextval, 'Creatina');

insert into Cat_produs(ID_Categorie_produs, Nume)
values (Cat_produs_ID_Cat_produs_Seq.nextval, 'Gustari proteice');

insert into Cat_produs(ID_Categorie_produs, Nume)
values (Cat_produs_ID_Cat_produs_Seq.nextval, 'Bauturi');
commit;

--Produse

insert into Produse(ID_Produs, Denumire_produs, ID_Furnizor, ID_Categorie, Pret_vanzare, Pret_cumparare, Stoc, Cantite_vanduta)
values (Produse_ID_Produs_Seq.nextval, 'Colagen', 1, 1, 50, 45, 100, 12);

insert into Produse(ID_Produs, Denumire_produs, ID_Furnizor, ID_Categorie, Pret_vanzare, Pret_cumparare, Stoc, Cantite_vanduta)
values (Produse_ID_Produs_Seq.nextval, 'Vitamina C', 3, 2, 30, 25, 50, 2);

insert into Produse(ID_Produs, Denumire_produs, ID_Furnizor, ID_Categorie, Pret_vanzare, Pret_cumparare, Stoc, Cantite_vanduta)
values (Produse_ID_Produs_Seq.nextval, 'Baton proteic', 5, 4, 10, 7, 321, 52) ;

insert into Produse(ID_Produs, Denumire_produs, ID_Furnizor, ID_Categorie, Pret_vanzare, Pret_cumparare, Stoc, Cantite_vanduta)
values (Produse_ID_Produs_Seq.nextval, 'Creatina monohidrata', 4, 3, 90, 80, 12, 4);

insert into Produse(ID_Produs, Denumire_produs, ID_Furnizor, ID_Categorie, Pret_vanzare, Pret_cumparare, Stoc, Cantite_vanduta)
values (Produse_ID_Produs_Seq.nextval, 'Bauturi izotonice', 2, 5, 40 ,35, 37, 15);

--Produse vandute

insert into Prod_vand(ID_Produse_vandute, ID_Produs, ID_Vanzare, Cantitate)
values (Prod_vand_ID_Prod_vand_Seq.nextval, 1, 3, 5);

insert into Prod_vand(ID_Produse_vandute, ID_Produs, ID_Vanzare, Cantitate)
values (Prod_vand_ID_Prod_vand_Seq.nextval, 3, 2, 3);

insert into Prod_vand(ID_Produse_vandute, ID_Produs, ID_Vanzare, Cantitate)
values (Prod_vand_ID_Prod_vand_Seq.nextval, 4, 5, 1);

insert into Prod_vand(ID_Produse_vandute, ID_Produs, ID_Vanzare, Cantitate)
values (Prod_vand_ID_Prod_vand_Seq.nextval, 2, 4, 2);

insert into Prod_vand(ID_Produse_vandute, ID_Produs, ID_Vanzare, Cantitate)
values (Prod_vand_ID_Prod_vand_Seq.nextval, 5, 1, 4);

commit ;

