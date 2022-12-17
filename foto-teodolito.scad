$fa = 1;
$fs = 0.4;

use <auxiliares.scad>

include <BOSL/constants.scad>
use <BOSL/involute_gears.scad>
use <BOSL/beziers.scad>

tolj=.4;
lado=18;

module base() {
  cylinder(h=4.8,d=100);
  translate([0,0,4.8+5.1/2])
    gear(mm_per_tooth=5, number_of_teeth=60, thickness=5.1, pressure_angle=20);
}

module tubo() {
  largo=100;
  dia_int=lado-5;
  difference() {
    translate([-lado/2, -lado/2, 0])
      cube([lado,lado,largo]);    
    cylinder(h=3*largo,d=dia_int,center=true);
  }
  // bafles
  difference(){
    for(z=[15:15:largo-1])
      translate([0,0,z])
        cylinder(h=.9,d=dia_int+1,center=true);
    cylinder(h=3*largo,d=8,center=true);
  }
  // ejes
  let(alfa=30,e=6,h=10,d=h*tan(alfa),
      L=lado+2*(e+d)) {
    for(s=[0,1])  
      rotate([s*180,-90,0])  
      translate([0,lado/2,0])
        difference(){
        linear_extrude(lado,center=true)        
          polygon([[0,0],[L,0],[L-d,h], [d,h]]);
        linear_extrude(3*lado,center=true)
          polygon([[e,0], [L-e,0], [L-d-e,h+.01], [d+e,h+.01]]);
        }
   // lengüeta movimiento fino
   translate([-lado/2,-lado/2-h-10.5,L-d+15])
     cube([5,30,15]);
    }
}
module eje(d_eje,f) {
  let(alfa=30,e=6,h=10,d=h*tan(alfa),
      L=lado+2*(e+d)){
  linear_extrude(lado)
    polygon([[0,0],[L-2*e,0],[L-2*e-d,h], [d,h]]);
  translate([L/2-e,0,lado/2])
  rotate([-90,0,0])
    cylinder(h=f*lado,d=d_eje);
      }
}

module pilar() {
  ancho=15;
  difference(){
    hull(){
      rotate([90,0,0])
        cylinder(h=ancho,d=lado+10,center=true);
      translate([-25,-ancho/2,-45])
        cube([50,ancho,10]);
    }
    rotate([90,0,0])
      cylinder(h=30,d=lado+1,center=true);
  }
}

module porta_ldr () {  
  largo=8;
  dia_int=9;
  difference(){
    union(){
      translate([-lado/2, -lado/2, 0])
        cube([lado,lado,largo]);      
      cylinder(h=largo+12,d=dia_int-2*tolj);
    }
    translate([0,0,5])
      cylinder(h=3*largo,d=6.5);
    for(s=[-1,1])
      translate([s*3.4/2,0,-10])
        cylinder(h=34, d=1);  
  }
}
module porta_BH1750() { 
  largo=8;
  dia_int=9;
  e=3;
  difference(){
    union(){
      translate([-7-e, -7-e, 0])
        cube([18.5+2*e,14+2*e,largo]);      
      cylinder(h=largo+12,d=dia_int-2*tolj);
    }
    translate([0,0,5])
      cylinder(h=3*largo,d=6.5);
    translate([-7-1,-7-1,-.01])
      cube([18.5+2,14+2,6]);      
  }
  // pines para la plaquita
  for (y=[1+1.5,14-1-1.5])
      translate([-7+1.5+1,y-7,0])
        cylinder(h=7,d=2);
}

module eje_aux(){
  ancho1=30;
  ancho2=10;
  e=7;
  difference(){
    union(){
      cylinder(h=ancho1,d=lado);
      translate([-4.9,0,0]) {
        translate([-lado/2+5+5,0,0])
          cube([e,46,ancho2]);          
      }
      // elástico viejo
//      bez = [ [.1,0],[0,20],[-7.5,30],[-14,20],[-14,-16],[-10,-17],[-10,-10],[-10,10],[-7.5,22],[-5,10],[-4.9,0] ];
//        translate([1,44,0])
//          trace_bezier(bez, N=2);  
//      linear_extrude_bezier(bez, N=2, height=ancho2, splinesteps=32, convexity=5);
      // elástico      
      bez = [ [0,0],[-4,10],[-4,40],[-6,43],[-8,40],[-8,10],[-4,0],[-3,-3] ];
      translate([-5,5,0])
//        trace_bezier(bez, N=2);  
      linear_extrude_bezier(bez, N=2, height=ancho2, splinesteps=32, convexity=5);
    }    
    cylinder(h=ancho1+12,d=12+1,center=true);
    translate([-2.5+2.1/2,lado*2.3-8.5,-ancho2])
      cube([2.1,9,ancho2*3]);
    translate([-5,lado*2.3-8.5/2,ancho2/2])
      rotate([0,90,0])
        cylinder(d=4,h=12);    
  }
}

//porta_BH1750();
//translate([-7,-7,5]) BH1750();

rotate([0,-25,0]) {
translate([0,0,-20.8]){
//color("gray") translate([0,0,-8]) porta_ldr();
  color("gray") translate([0,0,-8]) porta_BH1750();
tubo();
color("lightblue") translate([lado,lado,lado-6]/2) rotate([0,-90,0]) eje(lado,1.5);
color("lightblue") translate([-lado,-lado,lado-6]/2) rotate([0,-90,180]) eje(12,1.5);  
}
color ("green") translate([0,-39,0]/2) rotate([90,0,0]) eje_aux();  
}

color("grey",.5)
for(s=[-1.39,1])
  translate([0,s*27.0,0])
    pilar();
////color("white") translate([0,0,100]) ldr();
translate([90,-78/2-5.5,-35])
  rotate([0,0,90])
    color ("cyan", .5) robotbit();
translate([6,-85,6])
  rotate([0,90,90])
    color ("cyan", .5) servo_s90g ();
//  color ("cyan", .5) robotbit();
//  color ("green", .5) 
//    translate([0,80,19])
//      rotate([0,180,0])
//        stepper_28BYJ_48();
