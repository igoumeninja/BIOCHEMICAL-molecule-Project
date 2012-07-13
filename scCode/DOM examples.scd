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


