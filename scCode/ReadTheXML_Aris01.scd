/*
2600 atoms
*/
(
d = DOMDocument("/Users/ari/Tools/openFrameworks/repository/of_0071_osx_release/apps/myApps/molecule/data/3SPX.xml");
~xPos = d.getElementsByTagName ("PDBx:Cartn_x");
~yPos = d.getElementsByTagName ("PDBx:Cartn_y");
~zPos = d.getElementsByTagName ("PDBx:Cartn_z");
~bIso = d.getElementsByTagName ("PDBx:B_iso_or_equiv");
~seqId = d.getElementsByTagName ("PDBx:auth_seq_id");
~compId = d.getElementsByTagName ("PDBx:label_comp_id"); 
~typeSymbol = d.getElementsByTagName ("PDBx:type_symbol");
)
n = NetAddr("127.0.0.1", 12345);
n.sendMsg("atomID", x[1].getText.asFloat, y[1].getText.asFloat, z[2].getText.asFloat )
//:-	
(
{
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
		0.005.wait;
	}
}.fork
)
//:-
