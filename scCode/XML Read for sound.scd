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
~readFactor = 1
~key = 4;
~atomSynths = Array.newClear(~atomSiteCat.size);

(

SynthDef(\fm, {|amp = 0.1, pan =0, freq = 400, readFactor = 1|
	Out.ar(0, Pan2.ar(
						SinOsc.ar(freq+SinOsc.ar(freq*5, 0, 5000*amp), 
						0, 
						EnvGen.kr(
								Env.sine(200*amp/(10.pow(readFactor)), amp/10), doneAction: 2)),pan))
}).add;





SynthDef(\sine, {|amp = 0.1, pan = 0, freq = 42, readFactor = 1|
	Out.ar(0, Pan2.ar(
						SinOsc.ar(freq+SinOsc.ar(freq*2.3, 0, 100*amp), 
						0, 
						EnvGen.kr(
								Env.perc(0.001, 2, amp, -4), doneAction: 2)),pan)
		)
}).add;


)
(
{
	~atomSiteCat.size.do{|i|
		var amp, pan, freq, atomId, dist, seqId, compId, atomSymbol, atomSiteId, secStructBeg, secStructEnd;
	
		atomSiteId = ~atomSiteCat[i].getAttribute("id").asInteger;
		atomId = ~atomId[i].getText.asString;
		compId = ~compId[i].getText.asString;
		seqId = ~seqId[i].getText.asInteger;
		atomSymbol = ~typeSymbol[i].getText.asString;
		
		amp = ~bIso[i].getText.asFloat/100;
		pan = ~xPos[i].getText.asFloat-100/100;

	// Link atomId with a frequency
		
	switch (atomId,
			"N", {freq = (~key + 24 + 14.0067).midicps},
			"CA", {freq = (~key + 36 + 12.0107).midicps},Ê Ê  
			"O", {freq = (~key + 24 + 15.9994).midicps},
			"C", {freq =  (~key + 24 + 12.0107).midicps},
			"S", {freq = (~key + 12 + 32.065).midicps},
			"P", {freq = (~key + 24 + 30.973762).midicps},
			"CL", {freq = (~key + 36 + 35.453).midicps},
			"NA", {freq = (~key + 24 + 22.98976928).midicps},	
			
			"CB", {freq = (~key + 12 + 12.0107).midicps},
			"CD", {freq = (~key + 60 + 12.0107).midicps},
			"CE", {freq = (~key + 48 + 12.0107).midicps},
			"CG", {freq = (~key + 60 + 12.0107).midicps},
			"CZ", {freq = (~key + 24 + 12.0107).midicps},
			"CZ2", {freq = (~key + 36 + 12.0107).midicps},
			"CZ3", {freq = (~key + 48 + 12.0107).midicps},
			"CD1", {freq = (~key + 36 + 12.0107).midicps},
			"CD2", {freq = (~key + 48 + 12.0107).midicps},
			"CE1", {freq = (~key + 48 + 12.0107).midicps},
			"CE2", {freq = (~key + 48 + 12.0107).midicps},
			"CE3", {freq = (~key + 48 + 12.0107).midicps},
			"CG1", {freq = (~key + 48 + 12.0107).midicps},
			"CG2", {freq = (~key + 48 + 12.0107).midicps},
			"CH2", {freq = (~key + 48 + 12.0107).midicps},
			"C2", {freq = (~key + 48 + 12.0107).midicps},
			"C3", {freq = (~key + 48 + 12.0107).midicps},
			"C4", {freq = (~key + 48 + 12.0107).midicps},
			"C5", {freq = (~key + 48 + 12.0107).midicps},
			"C6", {freq = (~key + 48 + 12.0107).midicps},
			"C2nil", {freq = (~key + 48 + 12.0107).midicps},
			"C3nil", {freq = (~key + 48 + 12.0107).midicps},
			"C4nil", {freq = (~key + 48 + 12.0107).midicps},
			"C5nil", {freq = (~key + 48 + 12.0107).midicps},
			
			"NZ", {freq = (~key + 36 + 14.0067).midicps},
			"N1", {freq = (~key + 36 + 14.0067).midicps},
			"NE", {freq = (~key + 36 + 14.0067).midicps},
			"NE1", {freq = (~key + 36 + 14.0067).midicps},
			"NE2", {freq = (~key + 36 + 14.0067).midicps},
			"ND1", {freq = (~key + 36 + 14.0067).midicps},
			"ND2", {freq = (~key + 36 + 14.0067).midicps},
			"NH1", {freq = (~key + 36 + 14.0067).midicps},
			"NH2", {freq = (~key + 36 + 14.0067).midicps},
			
			"O3", {freq = (~key + 48 + 15.9994).midicps},
			"OG", {freq = (~key + 48 + 15.9994).midicps},
			"OH", {freq = (~key + 48 + 15.9994).midicps},
			"OG1", {freq = (~key + 36 + 15.9994).midicps},
			"OG2", {freq = (~key + 36 + 15.9994).midicps},
			"OD1", {freq = (~key + 36 + 15.9994).midicps},
			"OD2", {freq = (~key + 36 + 15.9994).midicps},
			"OE1", {freq = (~key + 36 + 15.9994).midicps},
			"OE2", {freq = (~key + 36 + 15.9994).midicps},
			"OP1", {freq = (~key + 36 + 15.9994).midicps},
			"OP2", {freq = (~key + 36 + 15.9994).midicps},
			"OP3", {freq = (~key + 36 + 15.9994).midicps},
			"OP4", {freq = (~key + 36 + 15.9994).midicps},
			
			"SD", {freq = (~key + 48 + 32.065).midicps},
			"SG", {freq = (~key + 24 + 32.065).midicps},
			
					{freq = 2000; [atomId, compId].postln});

				

		
		~atomSynths[i] = Synth(\fm, [\readFactor, ~readFactor, \amp, amp, \pan, pan, \freq, freq]);

		

		
	// Determine the beginning of a new amino acid 
		
		if( i==0 ,{seqId.postln; compId.postln; atomId.postln;},
				 {
					 
			if (seqId == ~seqId[i-1].getText.asInteger, 
					{atomId.postln;}, 
					{	Synth(\sine);
												
						// Determine the secondary structure


	
				if( ~sheetBeg.includes(seqId), 
							{"SheetBeginning".postln;
								
								
							//	~atomSynths[i].set
								
								}
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
		
	
		
		// Calculate the distance between two atoms			
		dist = (sqrt(
			pow((~xPos[i+1].getText.asFloat	- ~xPos[i].getText.asFloat),2) +
			pow((~yPos[i+1].getText.asFloat	- ~yPos[i].getText.asFloat),2) + 
			pow((~zPos[i+1].getText.asFloat	- ~zPos[i].getText.asFloat),2)));
		dist = dist/(~readFactor*10);
	dist.wait;
		
		
	}
}.fork
)



~readFactor = 1
~key = 4;

/*

To Do List

Helix - Sheet structures -----> FM parameters
Amino Acids molecular weight -----> amplitude
x,y,z ---------> panning


*/