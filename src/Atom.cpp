#include "Atom.h"

Atom::Atom(int i, ofVec3f pos, float disp, string ty, int gr, string a)
{
	id = i;
	position = pos;
	initPosition = pos;
	displacement = disp;
	type = ty;
	group = gr;
	acid = a;
	transparency = 255/(displacement+1);
	vbo = initVbo(pos, displacement);
	if (type == "N") {
		color = ofColor(255, 0, 0, transparency);
	} else if (type == "C") {
		color = ofColor(125, 125, 125, transparency);
	} else if (type == "O") {
		color = ofColor(0,0,255, transparency);		
	} else if (type == "S") {
		color = ofColor(255,255,0, transparency);		
	} else if (type == "P") {
		color = ofColor(84,147,18, transparency);		
	} else if (type == "CL") {
		color = ofColor(255,128,128, transparency);
	} else if (type == "NA") {
		color = ofColor(255,255,0, transparency);	
	} else {
		color = ofColor(0,0,0, 255);
	}
}

Atom::Atom()
{
}

ofVbo Atom::initVbo(ofVec3f center, float radius){
	ofVbo temp;
	const ofIndexType Faces[] = {
    2, 1, 0,
    3, 2, 0,
    4, 3, 0,
    5, 4, 0,
    1, 5, 0,
    11, 6,  7,
    11, 7,  8,
    11, 8,  9,
    11, 9,  10,
    11, 10, 6,
    1, 2, 6,
    2, 3, 7,
    3, 4, 8,
    4, 5, 9,
    5, 1, 10,
    2,  7, 6,
    3,  8, 7,
    4,  9, 8,
    5, 10, 9,
    1, 6, 10 };
const float Verts[] = {
    0.000f,  0.000f,  1.000f,
    0.894f,  0.000f,  0.447f,
    0.276f,  0.851f,  0.447f,
    -0.724f,  0.526f,  0.447f,
    -0.724f, -0.526f,  0.447f,
    0.276f, -0.851f,  0.447f,
    0.724f,  0.526f, -0.447f,
    -0.276f,  0.851f, -0.447f,
    -0.894f,  0.000f, -0.447f,
    -0.276f, -0.851f, -0.447f,
    0.724f, -0.526f, -0.447f,
    0.000f,  0.000f, -1.000f };
ofVec3f v[12];
ofVec3f n[12];
ofFloatColor c[12];
 int i, j = 0;
    for ( i = 0; i < 12; i++ )
    {
 
        c[i].r = ofRandom(1.0);
        c[i].g = ofRandom(1.0);
        c[i].b = ofRandom(1.0);
 
        v[i][0] = (Verts[j] * radius) + center.x;
        j++;
        v[i][1] = (Verts[j] * radius) + center.y;
        j++;
        v[i][2] = (Verts[j] * radius) + center.z;
        j++;
 
    }

	temp.setVertexData( &v[0], 12, GL_DYNAMIC_DRAW );
   // temp.setColorData( &c[0], 12, GL_DYNAMIC_DRAW );
    temp.setIndexData( &Faces[0], 60, GL_DYNAMIC_DRAW );

	return temp;
}

void Atom::draw() {
	vbo.drawElements( GL_TRIANGLES, 60);
}