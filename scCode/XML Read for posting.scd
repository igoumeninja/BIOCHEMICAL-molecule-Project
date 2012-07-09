// Store the document in variable d
d = DOMDocument("/Users/stratosbichakis/Documents/Extending/Bio mol/3SPX.xml");

// Access the atom_siteCategory
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

/*
2600 atoms
*/
d = DOMDocument("/Users/stratosbichakis/of_0071_osx_release/apps/myApps/BIOCHEMICAL-molecule-Project/3SPX.xml");
~atomSiteCat = d.getElementsByTagName ("PDBx:atom_site");
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
{
	~atomSiteCat.size.do{|i|
		var amp, pan, freq, atomId, dist, seqId, compId, atomSymbol, atomSiteId, secStructBeg, secStructEnd;
	
		atomSiteId = ~atomSiteCat[i].getAttribute("id").asInteger;
		atomId = ~atomId[i].getText.asString;
		compId = ~compId[i].getText.asString;
		seqId = ~seqId[i].getText.asInteger;
		atomSymbol = ~typeSymbol[i].getText.asString;
			
		
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
		
	// Link atomSymbol with a frequency
		
		switch (atomId,
Ê Ê Ê Ê				"N", {freq = 800},
				Ê Ê "C", {freq = 200},
					"O", {freq = 600},
					"S", {freq = 85},
					"P", {freq = 60},
					"CL", {freq = 100},
					"NA", {freq = 4000},
Ê Ê Ê Ê 					{freq = 2000});

		amp = ~bIso[i].getText.asFloat/100;
		pan = ~xPos[i].getText.asFloat-200/1000;

	
		
		
		
		
		// Calculate the distance between two atoms			
		dist = (sqrt(
			pow((~xPos[i+1].getText.asFloat	- ~xPos[i].getText.asFloat),2) +
			pow((~yPos[i+1].getText.asFloat	- ~yPos[i].getText.asFloat),2) + 
			pow((~zPos[i+1].getText.asFloat	- ~zPos[i].getText.asFloat),2)));
		dist = dist/1000;
//		dist.wait;
		
		
	}
}.fork
)

