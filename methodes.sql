
create or replace type body T_Mountain as
   member function toXML return XMLType is
   output XMLType;
   begin 
      output := XMLType.createxml ('<mountain name="'||name||'" height="'||height||'"/>');
   return output;
   end ;
   
    member function toEx3XML return XMLType is 
    output XMLType;
    begin
      output := XMLType.createxml ('<mountain altitude="'||height||'" latitude="'||latitude||'" longitude="'||longitude||'">' ||name||'</mountain>');
    return output ;
    end;
end ;
/
create or replace type body T_Desert as
   member function toXML return XMLType is
   output XMLType;
   begin 
      if (area is null) then 
        output := XMLType.createxml ('<desert name="'||name||'"/>');
      else 
        output := XMLType.createxml ('<desert name="'||name||'" area="'||area||'"/>');
      end if ;
   return output;
   end ;
end ;
/

create or replace type body T_Island as
   member function toXML return XMLType is
   output XMLType;
   begin 
    output := XMLType.createxml ('<island name="'||name||'"/>');
    output := XMLType.appendchildxml(output,'island', XMLType('<coordinates latitude="'||latitude||'" longitude="'||longitude||'"/>'));
   return output;
   end ;
end ;
/

create or replace type body T_Airport as 
  member function toXML return XMLType is
  output XMLType ;
   begin 
    if (city is null) then 
      output := XMLType.createxml ('<airport name="'||name||'"/>');
    else 
      output := XMLType.createxml ('<airport name="'||name||'" nearCity="'||city||'"/>');
    end if;
    return output ;
   end ;
end ;
/

 
create or replace type body T_Encompasses as 
  member function toXML return XMLType is
  output XMLType ;
   begin 
    output := XMLType.createxml ('<continent name="'||continent||'" percent="'||percentage||'"/>');
   return output ;
   end ;
end ;
/


create or replace type body T_Province as 
  member function toXML return XMLType is 
  output XMLType ;
  ensMountains T_ensMountains;
  ensDeserts T_ensDeserts ;
  ensIslands T_ensIslands;
  mountain T_Mountain ;
  desert T_Desert ;
  island T_Island ;
  begin
    output := XMLType.createxml('<province name="'||name||'" capital="'||capital||'"/>');
    
    select value(gm) 
    bulk collect into ensMountains
    from TheGeoMountains gm
    where self.name = gm.province and self.country = gm.country ;
    
    select value(gd) 
    bulk collect into ensDeserts
    from TheGeoDeserts gd
    where gd.province = self.name and gd.country = self.country ;
    
    select value(gi) 
    bulk collect into ensIslands
    from TheGeoIslands gi
    where gi.province = self.name and gi.country = self.country ;
    
    for indx IN 1..ensMountains.COUNT
      loop
        select value(m) into mountain
        from TheMountains m 
        where ensMountains(indx).mountain = m.name ;
        output := XMLType.appendchildxml(output,'province', mountain.toXML());   
      end loop;
 
    for indx IN 1..ensDeserts.COUNT
      loop
        select value(d) into desert
        from TheDeserts d
        where ensDeserts(indx).desert = d.name;
        output := XMLType.appendchildxml(output,'province', desert.toXML());   
      end loop;
      
    for indx IN 1..ensIslands.COUNT
      loop
        select value(i) into island
        from TheIslands i
        where ensIslands(indx).island = i.name;
        output := XMLType.appendchildxml(output,'province', island.toXML());   
      end loop;  
  return output ; 
  end;
  
  member function toEx3XML return XMLType is 
  output XMLType ;
  output2 XMLType ;
  output3 XMLType ;
  ensMountains T_ensMountains ;
  mountain T_Mountain;
  ensSources T_ensSources ;
  source T_Source ;
  begin 
    output := XMLType.createxml('<province name="'||name||'"/>');
    output2 := XMLType.createxml('<mountains/>');
    output3 := XMLType.createxml('<rivers/>');
   
      
    select value(gm) 
    bulk collect into ensMountains
    from TheGeoMountains gm
    where self.name = gm.province and self.country = gm.country ;
    
    if(ensMountains.COUNT > 0) then 
      for indx IN 1..ensMountains.COUNT
        loop
          select value(m) into mountain
          from TheMountains m 
          where ensMountains(indx).mountain = m.name ;
          output2 := XMLType.appendchildxml(output2,'mountains', mountain.toEx3XML());   
        end loop;
      output :=  XMLType.appendchildxml(output,'province', output2);
    end if ;
    
    select value(s) bulk collect into ensSources
    from TheSources s
    where s.country = self.country and s.province = self.name ; 
    
    if(ensSources.COUNT>0) then
      for indx IN 1..ensSources.COUNT
        loop
         output3 := XMLType.appendchildxml(output3, 'rivers', XMLType('<river>'||ensSources(indx).name||'</river>')); 
         end loop;
       output :=  XMLType.appendchildxml(output,'province', output3);
     end if;
    
   return output ;
  end;
end ; 
/

create or replace type body T_Organization is 
  member function toXML return XMLType is 
    output XMLType ;
    ensCountries T_ensCountries ;
    begin
     output := XMLType.createxml('<organization/>'); 
     
     select value(c) bulk collect into ensCountries
     from TheCountries c, TheMembers m
     where c.code = m.country and m.organization=self.abbreviation ;
    
     for indx IN 1..ensCountries.COUNT
     loop
       output := XMLType.appendchildxml(output,'organization', ensCountries(indx).toXML2());   
     end loop ;
       
     output := XMLType.appendchildxml(output,'organization', XMLType('<headquarter name="'||city||'"/>')); 
     
     return output;
     end ;
end ;
/

create or replace type body T_Language as
 member function toXML return XMLType is
   output XMLType;
   begin
       output := XMLType.createxml('<language language="'||name||'" percent="'||percentage||'"/>');    
      return output;
   end;
end;
/

create or replace type body T_Borders as 

  member function toXML(code VARCHAR2) return XMLType  is 
    output XMLType ;
    ensBorders1 T_ensBorders;
    ensBorders2 T_ensBorders ;
    begin
    
    output := XMLType.createxml('<borders/>');    
       
     select value(b) bulk collect into ensBorders1
     from TheBorders b
     where b.country1 = code ;
      
      for indx IN 1..ensBorders1.COUNT
      loop
        output := XMLType.appendchildxml(output,'borders', XMLType ('<border countryCode="'||ensBorders1(indx).country2||'" length="'||ensBorders1(indx).length||'"/>'));     
      end loop;    
      
     select value(b) bulk collect into ensBorders2
     from TheBorders b
     where b.country2 = code ;
      
      for indx IN 1..ensBorders2.COUNT
      loop
        output := XMLType.appendchildxml(output,'borders', XMLType ('<border countryCode="'||ensBorders2(indx).country1||'" length="'||ensBorders2(indx).length||'"/>'));     
      end loop;        
      
      
      return output ;  
    end;

end;
/

create or replace type body T_Country as

   member function toXML1 return XMLType is
   output XMLType;
  ensEncompasses T_ensEncompasses;
   ensAirports T_ensAirports;
   ensProvinces T_ensProvinces ; 
   begin
      
      output := XMLType.createxml('<country idcountry="'||code||'" nom="'||name||'"/>');
      select value(e)
      bulk collect into ensEncompasses
      from TheEncompasses e
      where code = e.country ;
      
      for indx IN 1..ensEncompasses.COUNT
      loop
         output := XMLType.appendchildxml(output,'country', ensEncompasses(indx).toXML());   
      end loop;
      
      select value(p)
      bulk collect into ensProvinces
      from TheProvinces p
      where code = p.country ;
      
      for indx IN 1..ensProvinces.COUNT
      loop
         output := XMLType.appendchildxml(output,'country', ensProvinces(indx).toXML());   
      end loop;

      select value(a)
      bulk collect into ensAirports
      from TheAirports a
      where code = a.country;
      
      for indx IN 1..ensAirports.COUNT
      loop
         output := XMLType.appendchildxml(output,'country', ensAirports(indx).toXML());   
      end loop;

      return output;
   end;
   

   member function toXML2 return XMLType is
    output XMLType ;
    ensLanguages T_ensLanguages ;
    borders T_borders ;
    begin
      if (code is null) then 
        output := XMLType.createxml('<country name="'||name||'" population = "' ||population||'"/>');
      else 
        output := XMLType.createxml('<country code="'||code||'" name="'||name||'" population = "' ||population||'"/>');
      end if ;
      
      select value(l) bulk collect into ensLanguages
      from TheLanguages l
      where l.country = code ;
      
      for indx IN 1..ensLanguages.COUNT
      loop
         output := XMLType.appendchildxml(output,'country', ensLanguages(indx).toXML());   
      end loop;
          
      select value(b) into borders from TheBorders b where rownum<=1 ;      
      
      output := XMLType.appendchildxml(output,'country', borders.toXML(self.code));     
    
      return output ;
    end; 
    
    
   member function toEx2XML return XMLType is
   output XMLType; 
   output2 XMLType ;
   output3 XMLType ;
   ensMountains T_ensChar ;
   ensDeserts T_ensChar;
   ensIslands T_ensChar;
   mountain T_Mountain ;
   island T_Island ;
   desert T_Desert;
   mountainname VARCHAR2(100);
   exist number;
   begin
    output := XMLType.createxml('<country name="'||name||'"/>');
    output2 := XMLType.createxml('<geo/>');
    
    
    --select self.peak() into mountainname
    --from DUAL ;
    output3 := XMLType.createxml('<peak name="'||self.peak()||'"/>');
    
    select DISTINCT gm.mountain
    bulk collect into ensMountains
    from TheGeoMountains gm
    where self.code = gm.country ;
    
    select DISTINCT gd.desert
    bulk collect into ensDeserts
    from TheGeoDeserts gd
    where gd.country = self.code ;
    
    select DISTINCT gi.island
    bulk collect into ensIslands
    from TheGeoIslands gi
    where gi.country = self.code ;
    
    for indx IN 1..ensMountains.COUNT
      loop
        select value(m) into mountain
        from TheMountains m 
        where ensMountains(indx) = m.name ;
        output2 := XMLType.appendchildxml(output2,'geo', mountain.toXML());   
      end loop;
 
     for indx IN 1..ensDeserts.COUNT
      loop
        select value(d) into desert
        from TheDeserts d
        where ensDeserts(indx) = d.name;
        output2 := XMLType.appendchildxml(output2,'geo', desert.toXML());   
      end loop;
      
    for indx IN 1..ensIslands.COUNT
      loop
        select value(i) into island
        from TheIslands i
        where ensIslands(indx) = i.name;
        output2 := XMLType.appendchildxml(output2,'geo', island.toXML());   
      end loop;  
      
      output :=  XMLType.appendchildxml(output,'country', output2);
      output :=  XMLType.appendchildxml(output,'country', output3);
    return output;  
    end;
    
  member function peak return VARCHAR2 is
  exist number ;
  namemountain VARCHAR2(100);
  begin 
  
   select count(gm.mountain) into exist
   from TheMountains m, TheGeoMountains gm
   where m.name=gm.mountain and gm.country=self.code
   and m.height = (
     select max(m1.height) from TheMountains m1, TheGeoMountains gm where m1.name = gm.mountain and gm.country=self.code GROUP BY gm.country);

       
   if (exist>0) then
       select DISTINCT gm.mountain into namemountain
   from TheMountains m, TheGeoMountains gm
   where m.name=gm.mountain and gm.country=code
   and m.height = (
     select max(m1.height) from TheMountains m1, TheGeoMountains gm where m1.name = gm.mountain and gm.country=code GROUP BY gm.country);
       namemountain := namemountain ;
    
    
   else 
       namemountain := '0';
   end if;
   return namemountain;
  end;
   
  member function toEx2Q3XML return XMLType is 
  output XMLType ;
  output2 XMLType;
  conti VARCHAR(50);
  borders T_Borders ;
  ensCountries T_ensChar ; 
  border number ;
  begin
      --select self.continent() into conti 
      --from dual ;
      output := XMLType.createxml('<country name="'||name||'" continent="'||self.continent()||'"/>');
      

      select e.country bulk collect into ensCountries 
      from TheEncompasses e, TheBorders b
      where e.continent=conti and e.country<>self.code and
     ( (b.country1=self.code and b.country2 = e.country) or (b.country2=self.code and b.country1 = e.country));
      
     -- select value(b) into borders from TheBorders b where rownum<=1 ;
       output2 := XMLType.createxml('<contCountries/>');
      
      for indx IN 1..ensCountries.COUNT
      loop
         select b.length into border
         from TheBorders b
         where  ((b.country1=self.code and b.country2 = ensCountries(indx)) or (b.country2=self.code and b.country1 = ensCountries(indx)));
         
         output2 := XMLType.appendchildxml(output2,'contCountries', XMLType('<border countryCode="'||ensCountries(indx)||'" length="'||border||'"/>'));
          
        --end if;
         
      end loop;      
      output :=  XMLType.appendchildxml(output,'country', output2);
      return output ;
  end;

  
  member function continent return VARCHAR2 is 
  co VARCHAR2(50);
  begin
    select e.continent into co
    from TheEncompasses e 
    where e.country=self.code
    and e.percentage = (select max(e1.percentage) from TheEncompasses e1 where e1.country=self.code);
    
    return co ;
  end;
  
  member function existBorders return number is
  c number ;
  begin
  select count(value(b)) into c
  from TheBorders b
  where b.country1=self.code or b.country2=self.code; 
  return c;
  end;
  
  member function toEx2Q4XML return XMLType is
  output XMLType ;
  output2 XMLType ;
  lborders number ;
  conti VARCHAR(50);
  border number;
  ensCountries T_ensChar ; 
  begin
  
  select self.lengthborders() into lborders
  from dual ;
    
   output := XMLType.createxml('<country name="'||name||'" blength="'||lborders||'"/>');  
   
      select c.code bulk collect into ensCountries
      from TheCountries c, TheBorders b
      where c.code<>self.code and
     ( (b.country1=self.code and b.country2 = c.code) or (b.country2=self.code and b.country1 = c.code));
      
     
       output2 := XMLType.createxml('<contCountries/>');
      
      for indx IN 1..ensCountries.COUNT
      loop
         select b.length into border
         from TheBorders b
         where  ((b.country1=self.code and b.country2 = ensCountries(indx)) or (b.country2=self.code and b.country1 = ensCountries(indx)));
         
         output2 := XMLType.appendchildxml(output2,'contCountries', XMLType('<border countryCode="'||ensCountries(indx)||'" length="'||border||'"/>'));
  
         
      end loop;      
      output :=  XMLType.appendchildxml(output,'country', output2);
      return output ;
  
  
  end;
  
  member function lengthborders return number is
  c number ;
  nb number ;
  begin
    
    select count(*) into nb
    from TheBorders b
     where b.country1 = self.code
    or b.country2 = self.code ;
    
    if(nb=0) then
      return 0;
    end if;
    
    select sum(length) into c
    from TheBorders b
    where b.country1 = self.code
    or b.country2 = self.code ;
    return c ;
    
  end;
  
  member function toEx3XML return XMLType is 
  output XMLType ;
  output2 XMLType ; 
  ensProvinces T_ensProvinces; 
  lborders number ; 
  ensOrga T_ensOrganizations;
  d varchar2 (10);
  begin
    --select self.lengthborders() into lborders
    --from dual ;
    output := XMLType.createxml ('<country name="'||self.name||'" population="'||self.population||'" borderslength="'||self.lengthborders()||'"/>');
    output2 := XMLType.createxml('<organizations/>');
   

    select value(p) bulk collect into ensProvinces
    from TheProvinces p 
    where p.country=self.code ;
    
    for indx IN 1..ensProvinces.COUNT
    loop
       output := XMLType.appendchildxml(output,'country', ensProvinces(indx).toEx3XML());
    end loop;
    
    select value(o) bulk collect into ensOrga
    from TheOrganizations o, TheMembers i
    where i.country = self.code and o.abbreviation=i.organization
    order by o.established ;
    
    if(ensOrga.COUNT>0) then
      for indx IN 1..ensOrga.COUNT
        loop
         d := to_char(ensOrga(indx).established,'DD/MM/YYYY') ;
         if d is null then 
          output2 := XMLType.appendchildxml(output2,'organizations',XMLType('<organization>' ||ensOrga(indx).name||'</organization>' ));
         else
          output2 := XMLType.appendchildxml(output2,'organizations',XMLType('<organization date="'||d||'">' ||ensOrga(indx).name||'</organization>' ));
         end if ;
       end loop;
     output :=  XMLType.appendchildxml(output,'country', output2);
    end if ;
    
     
    
    return output ;
  end; 
  
end;
/

create or replace type body T_Continent  as 
  member function toXML return XMLType is 
  output XMLType ;
  ensCountries T_ensCountries ; 
  begin   
    output := XMLType.createxml('<continent name="'||name||'"/>');  
     select value(c) bulk collect into ensCountries
    from TheCountries c, TheEncompasses e
    where e.continent = self.name and e.country=c.code ;
    
    
    for indx IN 1..ensCountries.COUNT
    loop
       output := XMLType.appendchildxml(output,'continent', ensCountries(indx).toEx3XML());
    end loop;
    
      return output ;
  end;
end ;
/


create or replace type body T_Mondial as 
  member function toXML(i number) return XMLType is
  output XMLType ;
  ensCountries T_ensCountries ;
  ensOrganizations T_ensOrganizations ;
  ensContinent T_ensContinents ;
  dtd XMLType ;
  borders number ;
   begin 
      output := XMLType.createxml('<mondial/>');
      
      select value(c) bulk collect into ensCountries 
      from TheCountries c ; 
     
     
      case i
      when 1 then
     
        for indx IN 1..ensCountries.COUNT
      loop
        output := XMLType.appendchildxml(output,'mondial', ensCountries(indx).toXML1());
      end loop ;
      
      when 2 then         
      select value(o) bulk collect into ensOrganizations 
      from TheOrganizations o 
      where o.city is not null and o.country is not null ; 
      
      for indx IN 1..ensOrganizations.COUNT
      loop
       output := XMLType.appendchildxml(output,'mondial', ensOrganizations(indx).toXML()); 
      end loop;
      
      when 3 then 
      for indx IN 1..ensCountries.COUNT
      loop
        output := XMLType.appendchildxml(output,'mondial', ensCountries(indx).toEx2XML());
      end loop ;
      
      
      when 4 then 
      for indx IN 1..ensCountries.COUNT
      loop
        output := XMLType.appendchildxml(output,'mondial', ensCountries(indx).toEx2Q3XML());
      end loop ;
      
      when 5 then 
      for indx IN 1..ensCountries.COUNT
      loop
        output := XMLType.appendchildxml(output,'mondial', ensCountries(indx).toEx2Q4XML());
      end loop ;
      
      when 6 then 
      select value(c) bulk collect into ensContinent 
      from TheContinents c;
      
      for indx IN 1..ensContinent.COUNT
      loop
        output := XMLType.appendchildxml(output,'mondial', ensContinent(indx).toXML());
      end loop ;
      
      end case;
   return output ;
   end ;   
end ;
/


   
