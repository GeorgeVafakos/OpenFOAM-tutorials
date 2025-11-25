# OpenFOAM-tutorials
OpenFOAM tutorials for educational purposes using `OpenFOAM v2406`. The following cases are included:

## airfoil 

- Steady-state, incompressible, 2D flow pas a NACA 0015 airfoil
- C-grid is created using a python script, obtained by [curiosityFluids](https://curiosityfluids.com/)
- The airfoil shape is downloaded from the [airfoiltools](http://airfoiltools.com/) online database.
- Turbulence model: RANS Spalart-Allmaras one equation model.
- Solver: simpleFoam
- Angles of Attack: 0-15 dgr

![Airfoil at 15 dgr AoA](airfoil/AoA15.png)