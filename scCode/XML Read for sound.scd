/*



d = DOMDocument("/Users/stratosbichakis/Documents/Extending/Bio mol/3SPX.xml");



a = d.getElementsByTagName ("PDBx:atom_site")
a[2].getAttribute("id")
a.size
a[1].hasAttribute("id")
a[1].getAttributeNode("id").getNodeValue
e = a.collect({|item, i| item.getAttributeNode("id").getNodeValue; })

b = a.detect({ |item, i| item.getAttributeNode("id").getNodeValue.asInteger == 1 });
c = b.getChildNodes
c.collect({|item, i| item.getNodeName })

e = d.getElementsByTagName ("PDBx:Cartn_x")
e[0].getText
e[0].getNodeName

*/

// Store the document in variable d

d = DOMDocument("/Users/stratosbichakis/of_0071_osx_release/apps/myApps/BIOCHEMICAL-molecule-Project/3SPX.xml");
~atomSiteCat = d.getElementsByTagName ("PDBx:atom_site");      // Access the atom_siteCategory

~xPos = d.getElementsByTagName ("PDBx:Cartn_x");
~yPos = d.getElementsByTagName ("PDBx:Cartn_y");
~zPos = d.getElementsByTagName ("PDBx:Cartn_z");
~bIso = d.getElementsByTagName ("PDBx:B_iso_or_equiv");
~typeSymbol = d.getElementsByTagName ("PDBx:type_symbol");
~seqId = d.getElementsByTagName ("PDBx:label_seq_id");
~compId = d.getElementsByTagName ("PDBx:label_comp_id");
~atomId = d.getElementsByTagName ("PDBx:label_atom_id"); 
~sheetCat = d.getElementsByTagName("PDBx:struct_sheet_range")
~sheetBeg = ~sheetCat.collect({|item, i| item.getElement 						("PDBx:beg_label_seq_id").getText.asInteger;})
~sheetEnd = ~sheetCat.collect({|item, i| item.getElement 						("PDBx:end_label_seq_id").getText.asInteger;})
~helixCat = d.getElementsByTagName("PDBx:struct_conf")
~helixBeg = ~helixCat.collect({|item, i| item.getElement 						("PDBx:beg_label_seq_id").getText.asInteger;})
~helixEnd = ~helixCat.collect({|item, i| item.getElement 						("PDBx:end_label_seq_id").getText.asInteger;})

(
(
SynthDef(\tri, {|amp = 0.1, pan =0, freq = 400|
	Out.ar(0, Pan2.ar(
						LFTri.ar(freq, 
						0, 
						EnvGen.kr(
								Env.perc(amp/100, amp, amp, 4), doneAction: 2)),pan))
}).send(s)
);


{
	~atomSiteCat.size.do{|i|
		var amp, pan, freq, atomId, dist, seqId, compId, atomSymbol, atomSiteId, secStructBeg, secStructEnd;
	
		atomSiteId = ~atomSiteCat[i].getAttribute("id").asInteger;
		atomId = ~atomId[i].getText.asString;
		compId = ~compId[i].getText.asString;
		seqId = ~seqId[i].getText.asInteger;
		atomSymbol = ~typeSymbol[i].getText.asString;
		
		/*	
		
	// Determine the beginning of a new amino acid 
		
		if( i==0 ,{seqId.postln; compId.postln; atomId.postln;},
				 {
					 
			if (seqId == ~seqId[i-1].getText.asInteger, 
					{atomId.postln;}, 
					{							
						// Determine the secondary structure


	
				if( ~sheetBeg.includes(seqId), 
							{"SheetBeginning".postln}
						);
					
				if( ~sheetEnd.includes(seqId),
							{"SheetEnd".postln;} 
						);
				
				if( ~helixBeg.includes(seqId), 
							{"HelixBeginning".postln;}
						);
					
				if( ~helixEnd.includes(seqId),
							{"HelixEnd".postln;}
						);
			
						
				seqId.postln; compId.postln; atomId.postln;}
						
			);
		};
		);
		
		*/
		
// Link atomId with a frequency
		
switch (atomId,
"N", {freq = (40+14).midicps},
"CA", {freq = (40+12).midicps},Ê Ê  
"O", {freq = (40+16).midicps},
"C", {freq =  (28+12).midicps},
"S", {freq = (40+85).midicps},
"P", {freq = (40+30).midicps},
"CL", {freq = (40+35).midicps},
"NA", {freq = (40+22).midicps},	

"CB", {freq = (52+12).midicps},
"CD", {freq = (52+12).midicps},
"CE", {freq = (52+12).midicps},
"CG", {freq = (64+12).midicps},
"CZ", {freq = (52+12).midicps},
"CZ2", {freq = (52+12).midicps},
"CZ3", {freq = (52+12).midicps},
"CD1", {freq = (52+12).midicps},
"CD2", {freq = (52+12).midicps},
"CE1", {freq = (52+12).midicps},
"CE2", {freq = (52+12).midicps},
"CE3", {freq = (52+12).midicps},
"CG1", {freq = (52+12).midicps},
"CG2", {freq = (52+12).midicps},
"CH2", {freq = (52+12).midicps},
"C2", {freq = (52+12).midicps},
"C3", {freq = (52+12).midicps},
"C4", {freq = (52+12).midicps},
"C5", {freq = (52+12).midicps},
"C6", {freq = (52+12).midicps},
"C2nil", {freq = (52+12).midicps},
"C3nil", {freq = (52+12).midicps},
"C4nil", {freq = (52+12).midicps},
"C5nil", {freq = (52+12).midicps},

"NZ", {freq = (40+14).midicps},
"N1", {freq = (40+14).midicps},
"NE", {freq = (40+14).midicps},
"NE1", {freq = (40+14).midicps},
"NE2", {freq = (40+14).midicps},
"ND1", {freq = (40+14).midicps},
"ND2", {freq = (40+14).midicps},
"NH1", {freq = (40+14).midicps},
"NH2", {freq = (40+14).midicps},

"O3", {freq = (40+16).midicps},
"OG", {freq = (40+16).midicps},
"OH", {freq = (40+16).midicps},
"OG1", {freq = (40+16).midicps},
"OG2", {freq = (40+16).midicps},
"OD1", {freq = (40+16).midicps},
"OD2", {freq = (40+16).midicps},
"OE1", {freq = (40+16).midicps},
"OE2", {freq = (40+16).midicps},
"OP1", {freq = (40+16).midicps},
"OP2", {freq = (40+16).midicps},
"OP3", {freq = (40+16).midicps},
"OP4", {freq = (40+16).midicps},

"SD", {freq = (40+85).midicps},
"SG", {freq = (40+85).midicps},

		{freq = 2000; [atomId, compId].postln});

		amp = ~bIso[i].getText.asFloat/100;
		pan = ~xPos[i].getText.asFloat-200/1000;

	
		
		Synth(\tri, [\amp, amp, \pan, pan, \freq, freq]);

		
		
		// Calculate the distance between two atoms			
		dist = (sqrt(
			pow((~xPos[i+1].getText.asFloat	- ~xPos[i].getText.asFloat),2) +
			pow((~yPos[i+1].getText.asFloat	- ~yPos[i].getText.asFloat),2) + 
			pow((~zPos[i+1].getText.asFloat	- ~zPos[i].getText.asFloat),2)));
		dist = dist/100;
	dist.wait;
		
		
	}
}.fork
)

