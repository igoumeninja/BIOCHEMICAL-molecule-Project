/*
2600 atoms
*/
(
d = DOMDocument("C:/Users/Schizoid/Desktop/extending/of_v0071_vs2010_release/apps/myApps/BIOCHEMICAL-molecule-Project/3SPX.xml");
~xPos = d.getElementsByTagName ("PDBx:Cartn_x");
~yPos = d.getElementsByTagName ("PDBx:Cartn_y");
~zPos = d.getElementsByTagName ("PDBx:Cartn_z");
~bIso = d.getElementsByTagName ("PDBx:B_iso_or_equiv");
~seqId = d.getElementsByTagName ("PDBx:auth_seq_id");
~compId = d.getElementsByTagName ("PDBx:label_comp_id"); 
~typeSymbol = d.getElementsByTagName ("PDBx:type_symbol");
~readFactor = 1;
)
n = NetAddr("127.0.0.1", 12345);

//:-	
(
{ var dist;
	2400.do{|i|
		n.sendMsg(
			"atomID", 
			i.asInt, 
			~xPos[i].getText.asFloat,
			~yPos[i].getText.asFloat,
			~zPos[i].getText.asFloat,
			~bIso[i].getText.asFloat,
			~typeSymbol[i].getText.asString.postln,
			~seqId[i].getText.asInteger,
			~compId[i].getText.asString
			);			
		//i.postln;
		dist = (sqrt(
			pow((~xPos[i+1].getText.asFloat	- ~xPos[i].getText.asFloat),2) +
			pow((~yPos[i+1].getText.asFloat	- ~yPos[i].getText.asFloat),2) + 
			pow((~zPos[i+1].getText.asFloat	- ~zPos[i].getText.asFloat),2)));
		dist = dist/(~readFactor*10);
		dist.wait;
		//0.005.wait;
	}
}.fork
)
//:-
