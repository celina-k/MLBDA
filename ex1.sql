-- permet de générer le fichier xml de la question 1 de l'exercice 1
WbExport -type=text
         -file='mondialDTD1.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select m.toXML(1).getClobVal() 
from Mondial m;

-- permet de générer le fichier xml de la question 2 de l'exercice 1
WbExport -type=text
         -file='mondialDTD2.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select m.toXML(2).getClobVal() 
from Mondial m;


