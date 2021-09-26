-- permet de générer le fichier xml de l'exercice 3
WbExport -type=text
         -file='ex3-DTD6.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
/
select m.toXML(6).getClobVal() 
from Mondial m ;


; 
