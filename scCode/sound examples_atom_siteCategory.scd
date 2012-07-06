// Store the document in variable d
d = DOMDocument("/Users/stratosbichakis/Documents/Extending/Bio mol/3SPX.xml");

// Access the atom_siteCategory
a = d.getElementsByTagName ("PDBx:atom_site")
a[2].getAttribute("id")
a.size
b = a[1].getAttributeNode("id")
b.getNodeValue


e = d.getElementsByTagName ("PDBx:Cartn_x")
e[0].getText
e[..].getText
e[0].getNodeName

/*
2600 atoms
*/
d = DOMDocument("/Users/ari/Dropbox/orgshared/sites/org/extending/projects/Stratos-Bichakis/media/3SPX.xml");
~xPos = d.getElementsByTagName ("PDBx:Cartn_x")
~yPos = d.getElementsByTagName ("PDBx:Cartn_y")
~zPos = d.getElementsByTagName ("PDBx:Cartn_z")
~bIso = d.getElementsByTagName ("PDBx:B_iso_or_equiv")
~type_symbol = d.getElementsByTagName ("PDBx:type_symbol");
n = NetAddr("127.0.0.1", 12345);
n.sendMsg("atomID", x[1].getText.asFloat, y[1].getText.asFloat, z[2].getText.asFloat )
//:-	

{
	2600.do{|i|
		n.sendMsg(
			"atomID", 
			i.asInt, 
			~xPos[i].getText.asFloat,
			~yPos[i].getText.asFloat,
			~zPos[i].getText.asFloat,
			~bIso[i].getText.asFloat,
			~type_symbol[i].getText.asString.postln
			);			
		//i.postln;
		0.05.wait;
	}
}.fork
//:-

(
SynthDef(\noise, {|amp = 0.1, pan =0, freq = 400|
	Out.ar(0, Pan2.ar(SinOsc.ar(freq, 0, amp*EnvGen.kr(Env.perc(amp/100, amp/10, 1, -4), doneAction: 2)),pan))
}).send(s)
)

a = Synth(\noise)
a.set(\amp, 0.5)
a.set(\amp, ~bIso[1].getText.asFloat/100)

(
{
	
	2600.do{|i|
		var amp, pan, freq, atomId;
		atomId = ~type_symbol[i].getText.asString.postln;
		switch (atomId,
Ê Ê Ê Ê "N", {freq = 1000},
Ê Ê Ê Ê "C", {freq = 200},
		"O", {freq = 700},
		"S", {freq = 80},
		"P", {freq = 60},
		"CL", {freq = 100},
		"NA", {freq = 4000},
Ê Ê Ê Ê {freq = 4000});
		amp = ~bIso[i].getText.asFloat/100;
		pan = ~xPos[i].getText.asFloat-200/1000;
		Synth(\noise, [\amp, amp, \pan, pan, \freq, freq]);
					
		//i.postln;
		0.1.wait;
	}
}.fork
)


