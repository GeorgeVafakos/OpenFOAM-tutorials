// =======================================================================================
// Parameter definitions
// =======================================================================================
L = 1.0;               // Length of the cavity
lc = 0.01;             // Characteristic length for mesh refinement
R = L/4;               // Radius of the rotating inner wall
z0 = 0.1;              // Small offset in z-direction

// =======================================================================================
// Points, Lines, Loops, Surfaces
// =======================================================================================
// Points
Point(1) = {0, 0, 0, lc};
Point(2) = {R, 0, 0, lc};
Point(3) = {L/2, 0, 0, lc};
Point(4) = {L/2, L/2, 0, lc};
Point(5) = {0, L/2, 0, lc};
Point(6) = {0, R, 0, lc};

// Lines
Circle(1) = {6, 1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};

// Surafce
Line Loop(1) = {1, 2, 3, 4, 5};      // Loop around the cavity quadrant
Plane Surface(1) = {1};            // Surface of the cavity quadrant    

// =======================================================================================
// Create rest of the cavity
// =======================================================================================
q2[] = Symmetry{1, 0, 0, 0} { Duplicata{ Surface{1}; } };      // Left-top
q4[] = Symmetry{0, 1, 0, 0} { Duplicata{ Surface{1}; } };      // Right-bottom
q3[] = Symmetry{0, 1, 0, 0} { Duplicata{ Surface{ q2[0] }; } }; // Left-bottom

Coherence; // Merge duplicated entities

// Create volume by extrusion
v1[] = Extrude {0, 0, z0} {Surface{1}; Layers{1}; Recombine;};
v2[] = Extrude {0, 0, z0} {Surface{q2[0]}; Layers{1}; Recombine;};
v3[] = Extrude {0, 0, z0} {Surface{q3[0]}; Layers{1}; Recombine;};
v4[] = Extrude {0, 0, z0} {Surface{q4[0]}; Layers{1}; Recombine;};

// Decide unstructured meshing algorithm
Mesh.Algorithm = 5; //5 for Delaunay, 6 for Frontal-Delaunay

// =======================================================================================
// Physical Groups
// =======================================================================================
Physical Surface("movingWall") = {v1[5], v2[5]};
Physical Surface("fixedWalls") = {v1[4], v2[4], v3[4], v4[4], v3[5], v4[5]};
Physical Surface("rotatingWall") = {v1[2], v2[2], v3[2], v4[2]};
Physical Surface("frontAndBack") = {1, q2, q3, q4, v1[0], v2[0], v3[0], v4[0]};

Physical Volume("region0") = {v1[1], v2[1], v3[1], v4[1]}; 
