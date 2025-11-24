// =======================================================================================
// Parameter definitions
// =======================================================================================
L = 1.0;               // Length of the cavity
lc = 0.01;             // Characteristic length for mesh refinement
z0 = 0.1;              // Small offset in z-direction

// =======================================================================================
// Points, Lines, Loops, Surfaces
// =======================================================================================
// Points
Point(1) = {0, 0, 0, lc};           // Center
Point(2) = {L/2, 0, 0, lc};         // Midpoint left
Point(3) = {L/2, L/2, 0, lc};       // Top-right corner
Point(4) = {0, L/2, 0, lc};         // Midpoint top

// Lines
Line(1) = {1, 2};                  // Bottom edge
Line(2) = {2, 3};                  // Right edge
Line(3) = {3, 4};                  // Top edge
Line(4) = {4, 1};                  // Left edge

// Surafce
Line Loop(1) = {1, 2, 3, 4};      // Loop around the cavity quadrant
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
Physical Surface("movingWall") = {v1[4], v2[4]};
Physical Surface("fixedWalls") = {v1[3], v2[3], v3[3], v4[3], v3[4], v4[4]};
Physical Surface("frontAndBack") = {1, q2, q3, q4, v1[0], v2[0], v3[0], v4[0]};

Physical Volume("region0") = { v1[1], v2[1], v3[1], v4[1] }; 
