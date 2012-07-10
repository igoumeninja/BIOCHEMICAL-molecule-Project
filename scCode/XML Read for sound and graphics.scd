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

f = ~chemCompCat.collect({|item, i| item.getElement("PDBx:formula_weight")});
f[0].getText




*/

// Store the document in variable d
n = NetAddr("10.10.10.134", 12345);
d = DOMDocument("/Users/stratosbichakis/of_0071_osx_release/apps/myApps/BIOCHEMICAL-molecule-Project/3SPX.xml");
(
~atomSiteCat = d.getElementsByTagName ("PDBx:atom_site");      // Access the atom_siteCategory
~chemCompCat = d.getElementsByTagName ("PDBx:chem_comp");
~compWeight = ~chemCompCat.collect({|item, i| item.getElement("PDBx:formula_weight")});
~compWeightMax = ~compWeight.maxItem({|item, i| item.getText.asFloat}).getText.asFloat;
~compWeightMin = ~compWeight.minItem({|item, i| item.getText.asFloat}).getText.asFloat;

~xPos = d.getElementsByTagName ("PDBx:Cartn_x");
~yPos = d.getElementsByTagName ("PDBx:Cartn_y");
~zPos = d.getElementsByTagName ("PDBx:Cartn_z");

~bIso = d.getElementsByTagName ("PDBx:B_iso_or_equiv");
~bIsoMax = ~bIso.maxItem({|item, i| item.getText.asFloat}).getText.asFloat;
~bIsoMin = ~bIso.minItem({|item, i| item.getText.asFloat}).getText.asFloat;
~typeSymbol = d.getElementsByTagName ("PDBx:type_symbol");
~seqId = d.getElementsByTagName ("PDBx:label_seq_id");
~compId = d.getElementsByTagName ("PDBx:label_comp_id");
~atomId = d.getElementsByTagName ("PDBx:label_atom_id"); 
~sheetCat = d.getElementsByTagName("PDBx:struct_sheet_range");
~sheetBeg = ~sheetCat.collect({|item, i| item.getElement 						("PDBx:beg_label_seq_id").getText.asInteger;});
~sheetEnd = ~sheetCat.collect({|item, i| item.getElement 						("PDBx:end_label_seq_id").getText.asInteger;});
~helixCat = d.getElementsByTagName("PDBx:struct_conf");
~helixBeg = ~helixCat.collect({|item, i| item.getElement 						("PDBx:beg_label_seq_id").getText.asInteger;});
~helixEnd = ~helixCat.collect({|item, i| item.getElement 						("PDBx:end_label_seq_id").getText.asInteger;});
~readFactor = 1; ~readDur = 2;
~key = 4;
~atomSynths = Array.newClear(~atomSiteCat.size);
~sheetSynth = nil; ~helixSynth = nil;
~isSheet = 0; ~isHelix = 0;
~pan = 0;
)


(
~amplitudePoller = { 
	SendReply.kr(Impulse.kr(10), '/amp', Mix.kr(Amplitude.kr(In.ar(0, 2))));
}.play(RootNode(Server.default), addAction: \addToTail);


OSCresponder(nil, '/amp', { | time, resp, msg | 
	msg[3].postln;
	~amplitude = msg[3];
//	NetAddr("10.10.10.134", 12345).sendMsg("/amp", msg[3]);
}).add;
)


(

SynthDef(\atom, {|amp = 0.1, pan =0, freq = 400, index = 5, modamp = 2.5, readFactor = 1, readDur = 1, sheet = 0, helix = 0 |
	var op1, op2, op2_amp_env, op2_amp_lfo, op1_amp_env;
	
	op2_amp_env =  -300*sheet;
	op2_amp_lfo = SinOsc.kr(1, 0, 200*helix);
	op2 = SinOsc.ar((freq*index), 0, modamp*(amp*2000)+op2_amp_lfo+op2_amp_env);
	op1_amp_env = EnvGen.kr(Env.sine(readDur*100*amp/(10.pow(readFactor)), amp/10), doneAction: 2);
	op1 = SinOsc.ar(freq+op2, 0, op1_amp_env);
	Out.ar(0, Pan2.ar(op1, pan));
												
}).add;





SynthDef(\aminoAcid, {|amp = 0.2, pan = 0, freq = 42, readFactor = 1|
	Out.ar(0, Pan2.ar(
						SinOsc.ar(freq+SinOsc.ar(freq*2.3, 0, 100*amp), 
						0, 
						EnvGen.kr(
								Env.perc(0.001, 2, amp, -4), doneAction: 2)),pan)
		)
}).add;

SynthDef(\sheet, {|amp = 0.03, pan = 0|
	Out.ar(0, Pan2.ar(
						Resonz.ar(WhiteNoise.ar(amp*EnvGen.kr(Env([0, 1], [2], 0))), XLine.kr(3000, 600, 15), Line.kr(0.1, 0.01, 10 ) ),pan)
							)
		
}).add;
//a = Synth(\sheet)
//a.free

SynthDef(\helix, {|amp = 0.03, pan = 0|
	Out.ar(0, Pan2.ar(
						Resonz.ar(WhiteNoise.ar(amp*EnvGen.kr(Env([0, 1 ], [0.5], 0))), SinOsc.kr(0.88, 0, 300, 2600), 0.1), pan)
							)
		
}).add;
//h = Synth(\helix)
//h.free
)


)
(
{
	~atomSiteCat.size.do{|i|
		var amp, freq, index, atomId, dist, seqId, compId, atomSymbol, atomSiteId, secStructBeg, secStructEnd, aminoWeight, aminoAmp;
	/*
	n.sendMsg(
			"atomID", 
			i.asInt, 
			~xPos[i].getText.asFloat,
			~yPos[i].getText.asFloat,
			~zPos[i].getText.asFloat,
			~bIso[i].getText.asFloat,
			~typeSymbol[i].getText.asString.postln,
			~seqId[i].getText.asInteger,
			~compId[i].getText.asString,
			~isSheet.asInt,
			~isHelix.asInt,
			~key
			);			

	
	*/
		atomSiteId = ~atomSiteCat[i].getAttribute("id").asInteger;
		atomId = ~atomId[i].getText.asString;
		compId = ~compId[i].getText.asString;
		seqId = ~seqId[i].getText.asInteger;
		atomSymbol = ~typeSymbol[i].getText.asString;
		

		
//Sound Synthesis
		amp = ~bIso[i].getText.asFloat/100;

	// Link atomId with a frequency
		
	switch (atomId,
			"N", {freq = (~key + 24 + 14.0067).midicps},
			"CA", {freq = (~key + 36 + 12.0107).midicps},Ê Ê  
			"O", {freq = (~key + 36 + 15.9994).midicps},
			"C", {freq =  (~key + 24 + 12.0107).midicps},
			"S", {freq = (~key + 12 + 32.065).midicps},
			"P", {freq = (~key + 24 + 30.973762).midicps},
			"CL", {freq = (~key + 36 + 35.453).midicps},
			"NA", {freq = (~key + 24 + 22.98976928).midicps},	
			
			"CB", {freq = (~key + 12 + 12.0107).midicps},
			"CD", {freq = (~key + 24 + 12.0107).midicps},
			"CE", {freq = (~key + 60 + 12.0107).midicps},
			"CG", {freq = (~key + 48 + 12.0107).midicps},
			"CZ", {freq = (~key + 12 + 12.0107).midicps},
			"CZ2", {freq = (~key + 60 + 12.0107).midicps},
			"CZ3", {freq = (~key + 36 + 12.0107).midicps},
			"CD1", {freq = (~key + 48 + 12.0107).midicps},
			"CD2", {freq = (~key + 36 + 12.0107).midicps},
			"CE1", {freq = (~key + 36 + 12.0107).midicps},
			"CE2", {freq = (~key + 48 + 12.0107).midicps},
			"CE3", {freq = (~key + 36 + 12.0107).midicps},
			"CG1", {freq = (~key + 48 + 12.0107).midicps},
			"CG2", {freq = (~key + 60 + 12.0107).midicps},
			"CH2", {freq = (~key + 12 + 12.0107).midicps},
			"C2", {freq = (~key + 12 + 12.0107).midicps},
			"C3", {freq = (~key + 12 + 12.0107).midicps},
			"C4", {freq = (~key + 36 + 12.0107).midicps},
			"C5", {freq = (~key + 60 + 12.0107).midicps},
			"C6", {freq = (~key + 60 + 12.0107).midicps},
			"C2nil", {freq = (~key + 12 + 12.0107).midicps},
			"C3nil", {freq = (~key + 36 + 12.0107).midicps},
			"C4nil", {freq = (~key + 48 + 12.0107).midicps},
			"C5nil", {freq = (~key + 60 + 12.0107).midicps},
			
			"NZ", {freq = (~key + 48 + 14.0067).midicps},
			"N1", {freq = (~key + 24 + 14.0067).midicps},
			"NE", {freq = (~key + 24 + 14.0067).midicps},
			"NE1", {freq = (~key + 36 + 14.0067).midicps},
			"NE2", {freq = (~key + 48 + 14.0067).midicps},
			"ND1", {freq = (~key + 60 + 14.0067).midicps},
			"ND2", {freq = (~key + 60 + 14.0067).midicps},
			"NH1", {freq = (~key + 36 + 14.0067).midicps},
			"NH2", {freq = (~key + 48 + 14.0067).midicps},
			
			"O3", {freq = (~key + 24 + 15.9994).midicps},
			"OG", {freq = (~key + 12 + 15.9994).midicps},
			"OH", {freq = (~key + 24 + 15.9994).midicps},
			"OG1", {freq = (~key + 48 + 15.9994).midicps},
			"OG2", {freq = (~key + 24 + 15.9994).midicps},
			"OD1", {freq = (~key + 60 + 15.9994).midicps},
			"OD2", {freq = (~key + 48 + 15.9994).midicps},
			"OE1", {freq = (~key + 36 + 15.9994).midicps},
			"OE2", {freq = (~key + 12 + 15.9994).midicps},
			"OP1", {freq = (~key + 36 + 15.9994).midicps},
			"OP2", {freq = (~key + 36 + 15.9994).midicps},
			"OP3", {freq = (~key + 36 + 15.9994).midicps},
			"OP4", {freq = (~key + 36 + 15.9994).midicps},
			
			"SD", {freq = (~key + 60 + 32.065).midicps},
			"SG", {freq = (~key + 24 + 32.065).midicps},
			
					{freq = (~key + 24 + 15.9994).midicps; [atomId, compId].postln});

				

		

		

		
	// Determine the beginning of a new amino acid 
		
		if( i==0 ,{seqId.postln; compId.postln; atomId.postln;},
				 {
					 
			if (seqId == ~seqId[i-1].getText.asInteger, 
					{atomId.postln;}, 
					{	
					// Look for the Amino Acid weight

aminoWeight = ~compWeight[~chemCompCat.detectIndex(
				{| item, i | 
				item.getAttributeNode("id").getNodeValue == compId})].getText.asFloat;

aminoAmp = 0.4*aminoWeight/~compWeightMax;
 		
Synth(\aminoAcid, [\amp, aminoAmp]);
												
						// Determine the secondary structure


	
				if( ~sheetBeg.includes(seqId), 
							{"SheetBeginning".postln;
							~sheetSynth = Synth(\sheet);
							~isSheet = 1; 
							n.sendMsg("isSheet", ~isSheet);
							}
						);
					
				if( ~sheetEnd.includes(seqId),
							{"SheetEnd".postln;
							
							~sheetSynth.free;
							~isSheet = 0;
							n.sendMsg("isSheet", ~isSheet);

								} 
						);
				
				if( ~helixBeg.includes(seqId), 
							{"HelixBeginning".postln;
							
							~helixSynth = Synth(\helix);
							~isHelix = 1;	
							n.sendMsg("isHelix", ~isHelix);
								}
						);
					
				if( ~helixEnd.includes(seqId),
							{"HelixEnd".postln;
							
							~helixSynth.free;
							~isHelix = 0;
							n.sendMsg("isHelix", ~isHelix);

								}
						);
			
						
				seqId.postln; compId.postln; atomId.postln;}
						
			);
		};
		);
		
			~atomSynths[i] = Synth(\atom, [\readFactor, ~readFactor, \readDur, ~readDur, \amp, amp, \pan, ~pan, \freq, freq, \sheet, ~isSheet, \helix, ~isHelix]);

		
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

~readDur = 2;
~readFactor = 1;
(
~key = 9; 
n.sendMsg("key", ~key);
)