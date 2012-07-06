/*
2600 atoms
*/
d = DOMDocument("C:/Users/Schizoid/Desktop/extending/of_v0071_vs2010_release/apps/myApps/BIOCHEMICAL-molecule-Project/3SPX.xml");
~xPos = d.getElementsByTagName ("PDBx:Cartn_x");
~yPos = d.getElementsByTagName ("PDBx:Cartn_y");
~zPos = d.getElementsByTagName ("PDBx:Cartn_z");
~bIso = d.getElementsByTagName ("PDBx:B_iso_or_equiv");
~seqId = d.getElementsByTagName ("PDBx:auth_seq_id");
~compId = d.getElementsByTagName ("PDBx:label_comp_id"); 
~type_symbol = d.getElementsByTagName ("PDBx:type_symbol");
n = NetAddr("127.0.0.1", 12345);
n.sendMsg("atomID", x[1].getText.asFloat, y[1].getText.asFloat, z[2].getText.asFloat )
//:-	
(
{
	2600.do{|i|
		n.sendMsg(
			"atomID", 
			i.asInt, 
			~xPos[i].getText.asFloat,
			~yPos[i].getText.asFloat,
			~zPos[i].getText.asFloat,
			~bIso[i].getText.asFloat,
			~type_symbol[i].getText.asString.postln,
			~seQId[i].getText.asInt,
			~compId[i].getText.asString
			);			
		//i.postln;
		0.05.wait;
	}
}.fork
)
//:-
