create or replace type T_Mondial as object (
  monde varchar2 (100),
  member function toXML(i number) return XMLType
);
/

create table Mondial of T_Mondial ;
/

insert into Mondial values( 
      T_Mondial('je suis le monde'));
---------------------------------------------------------------------------------------------------

create or replace type T_Country as object (
   NAME        VARCHAR2(35 Byte),
   CODE        VARCHAR2(4 Byte),
   CAPITAL     VARCHAR2(35 Byte),
   PROVINCE    VARCHAR2(35 Byte),
   AREA        NUMBER,
   POPULATION  NUMBER,
   member function toXML1 return XMLType,
   member function toXML2 return XMLType,
   member function toEx2XML return XMLType,
   member function peak return VARCHAR2,
   member function continent return VARCHAR2,
   member function toEx2Q3XML return XMLType,
   member function existBorders return number,
   member function lengthborders return number,
   member function toEx2Q4XML return XMLType,
   member function toEx3XML return XMLType
   
);
/

create table TheCountries of T_Country (
  CONSTRAINT cnamenotnull CHECK (not(NAME is null)),
  CONSTRAINT ccodenotnull CHECK (not(CODE is null)),
  CONSTRAINT countryarea CHECK (AREA>=0),
  CONSTRAINT countrypop CHECK (POPULATION>=0)
);
/

insert into TheCountries(
  select T_Country(c.name, c.code, c.capital, c.province, c.area, c.population) from COUNTRY c) ;

-------------------------------------------------------------------------------------------------------

create or replace type T_Province as object (
   NAME        VARCHAR2(35 Byte), 
   COUNTRY     VARCHAR2(4 Byte),
   POPULATION  NUMBER,
   AREA        NUMBER,
   CAPITAL     VARCHAR2(35 Byte),
   CAPPROV     VARCHAR2(35 Byte),
   member function toXML return XMLType,
   member function toEx3XML return XMLType
);
/

create table TheProvinces of T_Province (
  CONSTRAINT prnamenotnull CHECK (not(NAME is null)),
  CONSTRAINT prcountrynotnull CHECK (not(COUNTRY is null)),
  CONSTRAINT prpop CHECK (POPULATION>=0),
  CONSTRAINT prarea CHECK (AREA>=0)
);
/

insert into TheProvinces (
  select T_Province (name, country, population, area, capital, capprov) from PROVINCE);

-----------------------------------------------------------------------------------------------------

create or replace type T_Mountain as object (
   NAME         VARCHAR2(35 Byte),
   MOUNTAINS    VARCHAR2(35 Byte),
   HEIGHT       NUMBER,
   TYPE         VARCHAR2(10 Byte),
   latitude     NUMBER,
   longitude    NUMBER,
   member function toXML return XMLType,
   member function toEx3XML return XMLType 
);
/

create table TheMountains of T_Mountain (
   CONSTRAINT mnamenotnull CHECK (not(NAME is null)),
   CONSTRAINT mlatitude CHECK ((latitude >= -90) AND (latitude <= 90)),
   CONSTRAINT mlongitude CHECK ((longitude >= -180) AND (longitude <= 180))
);
/

insert into TheMountains (
  select T_Mountain (name, mountains, height, type, m.coordinates.latitude, m.coordinates.longitude) from MOUNTAIN m);
  
---------------------
create or replace type T_GeoMountain as object (
   MOUNTAIN  VARCHAR2(35 Byte),
   COUNTRY   VARCHAR2(4 Byte),
   PROVINCE  VARCHAR2(35 Byte)
);
/

create table TheGeoMountains of T_GeoMountain (
   CONSTRAINT mountaintnull CHECK (not(MOUNTAIN is null)),
   CONSTRAINT gmcountry CHECK (not(COUNTRY is null)),
   CONSTRAINT gmprovince CHECK (not(PROVINCE is null)) 
);
/

insert into TheGeoMountains (
  select T_GeoMountain (mountain, country, province) from GEO_MOUNTAIN);


  
---------------------------------------------------------------------------------------------------

create or replace type T_Desert as object  (
   NAME         VARCHAR2(35 Byte),
   AREA         NUMBER,
   member function toXML return XMLType
);
/

create table TheDeserts of T_Desert(
  CONSTRAINT dnamenotnull CHECK (not(NAME is null))
);
/

insert into TheDeserts (
   select T_Desert( name, area) from DESERT);
   
---------------

create or replace type T_GeoDesert as object  (
   DESERT  VARCHAR2(35 Byte),
   COUNTRY   VARCHAR2(4 Byte),
   PROVINCE  VARCHAR2(35 Byte)
);
/

create table TheGeoDeserts of T_GeoDesert(
  CONSTRAINT desertnotnull CHECK (not(DESERT is null)),
  CONSTRAINT gdcountry CHECK (not(COUNTRY is null)),
  CONSTRAINT gdprovince CHECK (not(PROVINCE is null)) 
);
/

insert into TheGeoDeserts (
   select T_GeoDesert(desert, country, province) from GEO_DESERT);
   
---------------------------------------------------------------------------------------------------

create or replace type T_Island as object  (
   NAME         VARCHAR2(35 Byte),
   ISLANDS      VARCHAR2(35 Byte),
   AREA         NUMBER,
   HEIGHT       NUMBER,
   TYPE         VARCHAR2(10 Byte),
   latitude     NUMBER,
   longitude    NUMBER,
   member function toXML return XMLType
);
/

create table TheIslands of T_Island(
  CONSTRAINT inamenotnull CHECK (not(NAME is null)),
  CONSTRAINT ISLANDAR CHECK (Area >= 0), 
  CONSTRAINT ilatitude CHECK ((latitude >= -90) AND (latitude <= 90)),
  CONSTRAINT ilongitude CHECK ((longitude >= -180) AND (longitude <= 180))
);
/

insert into TheIslands (
   select T_Island (name, islands, area, height, type, i.coordinates.latitude, i.coordinates.longitude) from ISLAND i);
   
--------------------------------

create or replace type T_GeoIsland as object  (
   ISLAND  VARCHAR2(35 Byte),
   COUNTRY   VARCHAR2(4 Byte),
   PROVINCE  VARCHAR2(35 Byte)
);
/

create table TheGeoIslands of T_GeoIsland(
  CONSTRAINT islandnotnull CHECK (not(ISLAND is null)),
  CONSTRAINT gicountry CHECK (not(COUNTRY is null)),
  CONSTRAINT giprovince CHECK (not(PROVINCE is null)) 
);
/

insert into TheGeoIslands (
   select T_GeoIsland (island, country, province) from GEO_ISLAND);
   
---------------------------------------------------------------------------------------------------

create or replace type T_Continent as object  (
   NAME  VARCHAR2(20 Byte),
   -- AREA  NUMBER(10),
   member function toXML return XMLType
);
/

create table TheContinents of T_Continent(
  CONSTRAINT contnamenotnull CHECK (not(NAME is null))
);
/

insert into TheContinents (
   select T_Continent (name) from CONTINENT);

--------------------------------------------------------------------------------------------------------

create or replace type T_Airport as object (
   NAME       VARCHAR2(100 Byte),
   COUNTRY    VARCHAR2(4 Byte),
   CITY       VARCHAR2(50 Byte),
 
     member function toXML return XMLType
);
/

create table TheAirports of T_Airport;/

insert into TheAirports (
  select T_Airport (name, country, city) from AIRPORT);
  /
  
--------------------------------------------------------------------------------------------------------

create or replace type T_Encompasses as object (
   COUNTRY     VARCHAR2(4 Byte),
   CONTINENT   VARCHAR2(20 Byte),
   PERCENTAGE  NUMBER,
   member function toXML return XMLType
);
/

create table TheEncompasses of T_Encompasses (
   CONSTRAINT ecountrynotnull CHECK (not(COUNTRY is null)),
   CONSTRAINT econtinentnotnull CHECK (not(CONTINENT is null)),
   CHECK ((Percentage > 0) AND (Percentage <= 100))
);
/

insert into TheEncompasses(
  select T_Encompasses (country, continent, percentage) from ENCOMPASSES);
/
-----------------------------------------------------------------------------------------------------------
-- DTD 2 : 

---------------------------------


create or replace type T_Organization as object (
   ABBREVIATION  VARCHAR2(12 Byte),  
   NAME          VARCHAR2(80 Byte),
   CITY          VARCHAR2(35 Byte),
   COUNTRY       VARCHAR2(4 Byte),
   ESTABLISHED   DATE,
   member function toXML return XMLType
);
/
create table TheOrganizations of T_Organization (
  CONSTRAINT oabbre CHECK (not(ABBREVIATION is null)),
  CONSTRAINT oname CHECK (not(NAME is null))
);
/
insert into TheOrganizations (
    select T_Organization (abbreviation, name, city, country, established) from ORGANIZATION);
------------------


create or replace type T_Language as object (
   COUNTRY     VARCHAR2(4 Byte),
   NAME        VARCHAR2(50 Byte),
   PERCENTAGE  NUMBER,
   member function toXML return XMLType
);
/


create table TheLanguages of T_Language (
  CONSTRAINT lcountry CHECK (not(COUNTRY is null)),
  CONSTRAINT lname CHECK (not(NAME is null)),
  CONSTRAINT lpercentage CHECK ((PERCENTAGE >= -180) AND (PERCENTAGE <= 180))

);
/

insert into TheLanguages(
  select T_Language(country, name, percentage) from LANGUAGE ) ;

--------------------------------------------------------------------------------------



create or replace type T_Borders as object (
   COUNTRY1  VARCHAR2(4 Byte),
   COUNTRY2  VARCHAR2(4 Byte),
   LENGTH    NUMBER,
   member function toXML(code VARCHAR2) return XMLType 
);
/


create table TheBorders of T_Borders (
  CONSTRAINT bcountry1 CHECK (not(COUNTRY1 is null)),
  CONSTRAINT bcountry2 CHECK (not(COUNTRY2 is null)),
  CONSTRAINT llenght CHECK (LENGTH>0)
);
/

insert into TheBorders(
  select T_Borders (country1, country2, length) from BORDERS ) ;

-----------------------------------------------------------------------------------------------------------

create or replace type T_isMember as object (
   COUNTRY       VARCHAR2(4 Byte),
   ORGANIZATION  VARCHAR2(12 Byte)
);
/

create table TheMembers of T_isMember (
  CONSTRAINT mcountry1 CHECK (not(COUNTRY is null)),
  CONSTRAINT morganization CHECK (not(ORGANIZATION is null))
);
/

insert into TheMembers(
  select T_isMember (country, organization) from ISMEMBER ) ;

-----------------------------------------------------------------------------------------------------------
--create or replace type T_River as object (
  -- NAME            VARCHAR2(35 Byte),
   --member function toEx3XML return XMLType 
--);
--/
--create table TheRivers of T_River (
  --CONSTRAINT rname CHECK (not(NAME is null))
--);
--/

--insert into TheRivers(
  --  select T_River (name) from RIVER);

-----------------------------------------------------------------------------------------------------------

create or replace type T_Source as object (
   NAME            VARCHAR2(35 Byte),
   COUNTRY         VARCHAR2(4 Byte),
   PROVINCE  VARCHAR2(35 Byte)
);
/
create table TheSources of T_Source (
  CONSTRAINT sname CHECK (not(NAME is null)),
  CONSTRAINT scountry CHECK (not(COUNTRY is null)),
  CONSTRAINT sprovince CHECK (not(PROVINCE is null))
);
/

insert into TheSources(
    select T_Source (river, country, province) from GEO_SOURCE);

-----------------------------------------------------------------------------------------------------------



create or replace type T_ensMountains as table of T_GeoMountain; 
/
create or replace type T_ensDeserts as table of T_GeoDesert ;
/
create or replace type T_ensIslands as table of T_GeoIsland ;
/
create or replace type T_ensEncompasses as table of T_Encompasses;
/
create or replace type T_ensAirports as table of T_Airport ;
/
create or replace type T_ensProvinces as table of T_Province ;
/ 
create or replace type T_ensLanguages as table of T_Language ; 
/
create or replace type T_ensBorders as table of T_Borders ;
/
create or replace type T_ensCountries as table of T_Country ;
/ 
create or replace type T_ensOrganizations as table of T_Organization ;
/
create or replace type T_ensChar as table of VARCHAR2(100) ;
/
create or replace type T_ensContinents as table of T_Continent ;
/
create or replace type T_ensSources as table of T_Source ;
/
-----------------------------------------------------------------------------------------------------------
