ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY';
ALTER SESSION SET NLS_DATE_LANGUAGE='AMERICAN';



 REM Creation de la base de donnees aerienne

drop table pilote CASCADE CONSTRAINTS;

create table pilote(
       pl#     	number(4)    	constraint pk_pilote 
				primary key,
       plnom    varchar2(12)	constraint 
				nl_pilote_plnom not null 
				constraint 
				uk_pilote_plnom  unique,
       dnaiss	date   		constraint 
				nl_pilote_dnaiss  
				not null,
       adr     	varchar2(20)    default 'Paris',
       tel	varchar2(12),       
       sal	number(7,2)    constraint nl_pilote_sal 
				 not null constraint 
				chk_pilote_sal  
				check (sal < 70000.0)
);

drop table avion CASCADE CONSTRAINTS ;

create table avion(
       av#     	number(4)       	constraint pk_avion  primary key,
       avtype	varchar2(10)	constraint nl_avion_avtype   not null 
		CONSTRAINT chk_avion_type 
		CHECK (avtype in 	
('A300','A310','A320','B707','B727','CONCORDE','CARAVELLE')),
       cap 	number(4)	CONSTRAINT nl_avion_cap not null,
       loc	varchar2(20)	CONSTRAINT nl_avion_loc not null,
       remarq  	long            
);

drop table vol CASCADE CONSTRAINTS ;

create table vol(
       vol#    	number(4)    	CONSTRAINT pk_vol primary key,
       pilote#	number(4)    	CONSTRAINT nl_vol_pilote# not null
		CONSTRAINT vol_fk_pilote REFERENCES PILOTE(PL#)
		ON DELETE CASCADE,
       avion#  	number(4)    	CONSTRAINT nl_vol_avion# not null,
       vd		varchar2(20),
       va		varchar2(20),       
       hd		number(4) 	CONSTRAINT nl_vol_hd not null, 
       ha		number(4) CONSTRAINT nl_vol_ha not null,  
       dat		date,
	CONSTRAINT vol_chk_ha_hd CHECK (ha>hd),
	constraint fk_vol_avion# FOREIGN KEY (avion#) 
	REFERENCES AVION(AV#)
);


REM insertion des valeurs dans les tables       

insert into  pilote values(1, 'Miranda', '16-AUG-1952','Sophia-Antipolis', '93548254', 18009.0);
insert into  pilote values(2, 'St-exupery', '16-OCT-1932', 'Lyon', '91548254', 12300.0);
insert into  pilote values(3, 'Armstrong ', '11-MAR-1930', 'Wapakoneta','96548254', 24500.0);
insert into  pilote values(4, 'Tintin', '01-AUG-1929', 'Bruxelles','93548254', 21100.0);
insert into  pilote values(5, 'Gagarine', '12-AUG-1934', 'Klouchino','93548454', 22100.0);
insert into  pilote values(6, 'Baudry', '31-AUG-1959', 'Toulouse','93548444', 21000.0);
insert into  pilote values(8, 'Bush', '28-FEB-1924', 'Milton','44556254', 22000.0);
insert into  pilote values(9, 'Ruskoi', '16-AUG-1930', 'Moscou','73548254', 22000.0);
insert into  pilote values(10, 'Math', '12-AUG-1938', 'Paris', '23548254', 15000.0);
insert into  pilote values(11, 'Yen', '19-SEP-1942', 'Munich','13548254', 29000.0);
insert into  pilote values(12, 'Icare', '17-DEC-1962', 'Ithaques','73548211', 17000.6);
insert into  pilote values(13, 'Mopolo', '04-NOV-1955', 'Nice','93958211', 17000.6);
insert into  pilote values(14, 'Chretien', '04-NOV-1945', '','73223322', 15000.6);
insert into  pilote values(15, 'Vernes', '04-NOV-1935', 'Paris', '',17000.6);
insert into  pilote values(16, 'Tournesol', '04-AUG-1929', 'Bruxelles','', 15000.6);
insert into  pilote values(17, 'Concorde', '04-AUG-1966', 'Paris', '',21000.6);
insert into  pilote values(18, 'Foudil', '04-AUG-1966', 'Paris', '',21000.6);
insert into  pilote values(19, 'Foudelle', '04-AUG-1966', 'Paris', '',21000.6);
insert into  pilote values(20, 'Zembla', '04-AUG-1966', 'Paris', '',21000.6);


REM Insertion des avions

insert into  avion values(1, 'A300', 300, 'Nice', 'En service');   
insert into  avion values(2, 'A300', 300, 'Nice', 'En service');   
insert into  avion values(3, 'A320', 320, 'Paris', 'En service');  
insert into  avion values(4, 'A300', 300, 'Paris', 'En service');  
insert into  avion values(5, 'CONCORDE', 300, 'Nice', 'En service');
insert into  avion values(6, 'B707', 400, 'Paris', 'En panne');    
insert into  avion values(7, 'CARAVELLE', 300, 'Paris', 'En service');
insert into  avion values(8, 'B727', 250, 'Toulouse', 'En service');
insert into  avion values(9, 'CONCORDE', 350, 'Toulouse', 'En service');   
insert into  avion values(10, 'A300', 400, 'Paris', 'En service');
insert into  avion values(11, 'A300', 400, 'Paris', 'En service');
insert into  avion values(12, 'A300', 400, 'Paris', 'En service');
		    

REM Insertion des vols

insert into  vol values(100, 1,1,'Nice', 'Paris', '1345', '1500','3-MAR-1989' );  
insert into  vol values(110, 3,6,'Nice', 'Toulouse', '1230', '1325','6-MAR-1989' );       
insert into  vol values(120,4,3,'Nice', 'Paris', '0745', '0900','21-JUN-1989' );    
insert into  vol values(125, 12,6,'Paris', 'Nice', '1330', '1845','10-JAN-1989' );        
insert into  vol values(130, 4,8,'Toulouse','Beauvais', '0630','0750', '27-MAR-1989' );     
insert into  vol values(111, 5,3,'Nice', 'Paris', '0800', '0920','4-DEC-89' );    
insert into  vol values(135, 8,5,'Paris', 'Toulouse', '1200','1320','22-MAR-1989' );     
insert into  vol values(140, 14,9,'Lyon', 'Nice', '0700', '0750','4-JUN-1989' );     
insert into  vol values(150, 1,1,'Paris', 'Nantes','1630', '1725','28-MAR-1989' );        
insert into  vol values(153, 2,3,'Lyon', 'Nice', '1210', '1300','6-NOV-1989' );   
insert into  vol values(156, 9,2,'Paris', 'Lyon', '0230', '0320','14-JAN-1989' );   
insert into  vol values(200, 5,3,'Nice', 'Toulouse', '2030', '2125','17-JUN-1989' );      
insert into  vol values(210, 14,7,'Nice', 'Nantes', '1430', '1525','14-OCT-1989' );        
insert into  vol values(236, 8,4,'Lyon', 'Toulouse', '2130', '2250','15-OCT-1989' );     
insert into  vol values(240, 13,10, 'Nice', 'Paris', '2300', '2355','19-NOV-1989' );       
insert into  vol values(250, 13,4,'Bordeaux', 'Paris', '2300','2355', '25-DEC-89' );   
insert into  vol values(260, 13,5,'Bordeaux', 'Paris', '2300','2355', '30-NOV-1989' );    
insert into  vol values(270, 13,9,'Paris', 'New york', '1400','2300', '3-JAN-1989' );    
insert into  vol values(280, 8,9,'Nice', 'Mulhouse', '1200','1320','21-MAR-1989' );     
insert into  vol values(290, 3,8,'Beauvais', 'Marseille', '1230','1425', '9-MAR-1989' );       
insert into  vol values(310, 19,8,'Beauvais', 'Marseille', '1230','1425', '9-MAR-1989' );       

REM * insert into  vol values(360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate );       

commit;
