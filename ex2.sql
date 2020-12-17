-- permet de générer le fichier xml de la question 1 et 2 de l'exercice 2
WbExport -type=text
         -file='ex2Q1-Q2-DTD3.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select m.toXML(3).getClobVal() 
from Mondial m;


-- permet de générer le fichier xml de la question 3 de l'exercice 2
WbExport -type=text
         -file='TEST.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select m.toXML(4).getClobVal() 
from Mondial m;

-- permet de générer le fichier xml de la question 4 de l'exercice 2

WbExport -type=text
         -file='ex2Q4-DTD5.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/

select m.toXML(5).getClobVal() 
from Mondial m;

