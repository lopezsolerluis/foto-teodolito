$fa = 1;
$fs = 0.4;

use <auxiliares.scad>

include <BOSL/constants.scad>
use <BOSL/involute_gears.scad>
use <BOSL/beziers.scad>
use <BOSL/metric_screws.scad>

tolj=.4;
lado=18;
mm_per_tooth = 5;
number_of_teeth_1=70;
number_of_teeth_2=number_of_teeth_1 / 2;
clearance=0.5;
backlash=0.4;
e_rueda_1 = 12;
e_rueda_2 = 9;
d_eje_acimutal=50;
a_eje_acimutal=50;
largo_pie=70;

explo=0; // 0 o 2
tubo_seccionado=false; // true o false

radio_rueda_1 = pitch_radius(mm_per_tooth=mm_per_tooth, number_of_teeth = number_of_teeth_1);
radio_rueda_2 = pitch_radius(mm_per_tooth=mm_per_tooth, number_of_teeth = number_of_teeth_2);

module base() {
    difference(){     
        gear(mm_per_tooth=mm_per_tooth, number_of_teeth=number_of_teeth_1, thickness=e_rueda_1, hole_diameter=d_eje_acimutal+2, pressure_angle=20,  clearance=clearance, backlash=backlash );    
      // muesquitas
    for(a=[0:120:359])
      rotate(a) 
        translate([(d_eje_acimutal+12)/2+0,0,
                    -e_rueda_1/2-.1])
          cylinder(h=6.9,d=6.8);
      }      
}

module pie(){
  difference(){  
    union(){
      cylinder(h=a_eje_acimutal-e_rueda_1+1, 
              d1=d_eje_acimutal+2*3,
              d2=d_eje_acimutal+2*12);   
      // pies      
        for(a=[0:120:359])
          rotate(a) {
            translate([0,-5,0])
              cube([largo_pie,10,25]);
            translate([largo_pie,0,0])
              cylinder(h=25,d=20);
            }
       // muesquitas
       for(a=[0:120:359])
         rotate(a) 
           translate([(d_eje_acimutal+12)/2,0,a_eje_acimutal-e_rueda_1+1])
             cylinder(h=6,d=6);
        }      
    // hueco central
    cylinder(h=a_eje_acimutal*3, d=d_eje_acimutal, center=true);
    // huecos tornillos    
      for(a=[0:120:359])
          rotate(a) {
            translate([largo_pie-15,-1,-1])
              cube([40,2,40]);
            translate([largo_pie,0,0])
              cylinder(h=60,d=7,center=true);
            }
    }
}

module manija_pie(){
  d = 40;
  difference(){
    cylinder(h=5,d=d);
    cylinder(h=20,d=6,center=true);
    for(a=[0:30:359])
      rotate(a)
        translate([d/1.8,0,0])
          cylinder(h=30,d=9,center=true);
  }
}
  
module rueda_2(){
  difference(){
    union(){
      cylinder(d=20,h=7.5);
      gear(mm_per_tooth=mm_per_tooth, number_of_teeth=number_of_teeth_2, thickness=e_rueda_2, pressure_angle=20, clearance=clearance, backlash=backlash);
    }
   rotate(90)
    // OJO: "5" y "3" son JUSTOS
     cube([5,3,40],center=true);
  }
}

module tubo() {
  let(alfa=30,e=6,h=10,d=h*tan(alfa),
      L=lado+2*(e+d),largo=100,dia_int=lado-4) {  
  difference() {
    union(){
      translate([-lado/2, -lado/2, 0])
        cube([lado,lado,largo]);  
      // lengüeta movimiento fino
      translate([-lado/2,-lado/2-h-10.5,L-d+15])
        cube([5,30,15]);
    }    
    translate([0,0,-1])
      cylinder(h=largo*2,d=dia_int);    
    // hueco planchita
    translate([-lado/2+4,-lado/2-h-11,L-d+14])
        cube([1.1,11,17]);
  }
  // bafles
  difference(){
    for(z=[15:15:largo-1])
      translate([0,0,z])
        cylinder(h=.7,d=dia_int+1,center=true);
    cylinder(h=3*largo,d=8,center=true);
  }
  // ejes  
    for(s=[0,1])  
      rotate([s*180,-90,0])  
      translate([0,lado/2,0])
        difference(){
        linear_extrude(lado,center=true)        
          polygon([[0,0],[L,0],[L-d,h], [d,h]]);
        linear_extrude(3*lado,center=true)
          polygon([[e,0], [L-e,0], [L-d-e,h+.01], [d+e,h+.01]]);
        }   
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

module pilar(servo) {
  ancho=15;
  alto2=-40;
  alto3=10;
  difference(){
    hull(){
      rotate([90,0,0])
        cylinder(h=ancho,d=lado+10,center=true);
      translate([-25,-ancho/2,alto2])
        cube([50,ancho,alto3]);
    }
    rotate([90,0,0])
      cylinder(h=30,d=lado+1,center=true);
  }
  // pie
  largo_pie=75;
  difference(){
    translate([-largo_pie/2,-ancho/2,alto2])
      cube([largo_pie,ancho,alto3]);
    for(s=[-1,1])
      translate([(largo_pie+50)/4*s,0,alto2])
        cylinder(h=3*alto3,d=5,center=true);
  }
  // soporte servo
  if (servo) {
    difference(){
      for (z=[(lado+10+3.4)/2+1,-26.2-1]){
        translate([0,(-34-13+ancho)/2,z])
          cube([5,34+13,10],center=true);
        translate([0,(-34+ancho)/2,z])
          cube([10,34,10],center=true);
      }
      for (z=[(lado+10+3.4)/2+1,-26.2-1])
        hull() {
          translate([0,-31,z])
            rotate([0,90,0])
              cylinder(h=30,d=4.5,center=true);
          translate([0,-34,z])
            rotate([0,90,0])
              cylinder(h=30,d=4.5,center=true);
        }
    }
  }
}
module abrazadera_servo(tuerca){
  difference(){
    cube([8,10,54],center=true);
    // hueco central
    translate([-4.5+.2,0,0])
      cube([8,20,34],center=true);
    // tornillo
    for (s=[-1,1])
      translate([0,0,s*(54/2-5)])
        rotate([0,90,0])
          cylinder(h=30,d=4.5,center=true);
    // tuerca
    if (tuerca) 
      for (s=[-1,1])
        translate([2.5+1,0,s*(54/2-5)])
          rotate([0,90,0])
            cylinder(h=3,d=7.1,center=true,$fn=6);    
  }
}



module acople_sensor(){
  dia_int=lado-5.5;  
  difference() {
    cylinder(h=13.2,d1=dia_int-2,d2=dia_int);
  translate([0,0,2])
    cylinder(h=30,d1=8.5,d2=9);
  for(a=[0,90])
    rotate(a)
      translate([-1.5,-10,2])
        cube([3,20,20]);
  }
}
module porta_ldr () {  
  largo=8;  
  difference(){
    union(){
      translate([-lado/2, -lado/2, 0])
        cube([lado,lado,largo]);      
      translate([0,0,largo])
        acople_sensor();      
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
  e=3;
  difference(){
    union(){
      translate([-7-e, -7-e, 0])
        cube([18.5+2*e,14+2*e,largo]);      
      translate([0,0,largo])
        acople_sensor();
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
  ancho1=32;
  ancho2=10;
  e=7;
  difference(){
    union(){
      cylinder(h=ancho1,d=lado);      
      translate([-lado/2+6,0,0])
        cube([e,46,ancho2]);                
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
    // hueco
    cylinder(h=ancho1+12,d=12+1,center=true);
    // tuerca
    translate([-2.5+2.1/2+1,lado*2.3-8.5,-ancho2])
      cube([2.1,9,ancho2*3]);
    // tornillo
    translate([-5,lado*2.3-8.5/2,ancho2/2])
      rotate([0,90,0])
        cylinder(d=4,h=12);    
    // hueco garra servo
    translate([0,0,ancho1-3])
      rotate(90)
        hull(){
        cylinder(h=6,d=7.7);
        for(s=[-1,1])
          translate([14*s,0,0])
            cylinder(h=6,d=4.7);
       }
  }
}

module base_sup(){
  alto=6;
  difference() {
    union(){
      hull(){        
        for(s=[-1,1]){
        translate([s*36,33,0])
          cylinder(h=alto,d=10);
        translate([s*36,-44,0])
          cylinder(h=alto,d=10);
        }
      }
//      hull() {
//        translate([0,radio_rueda_1+radio_rueda_2-8,0])
//          cylinder(h=alto,d=48);
//        cylinder(h=alto,d=48);
//    }
       for(y=[35/2,-35/2])      
         hull(){
          translate([-(radio_rueda_1+radio_rueda_2-4),
                     y,0])
            cylinder(d=12,h=alto);
          translate([0,y,0])
            cylinder(d=12,h=alto);
        }
      hull(){
       translate([95,30.5,0])
         cylinder(h=alto,d=15);
       translate([0,30.5,0])
         cylinder(h=alto,d=15);
      }  
      hull(){
       translate([95,-41.5,0])
         cylinder(h=alto,d=15);
       translate([0,-41.5,0])
         cylinder(h=alto,d=15);
      }  
      // eje acimutal
      translate([0,0,-a_eje_acimutal])
        cylinder(h=a_eje_acimutal,d=d_eje_acimutal-.8);
    }
    // agujeros para tornillos
    tor2=4;
    // pilares
    for(x=[31.25,-31.25])
      for(y=[27,-37.55])
        translate([x,y,0])
          cylinder(d=tor2,h=3*alto,center=true);
    // microbit
    for(x=[48,95])
      for(y=[30.5,-41.5])
        translate([x,y,0])
          cylinder(d=tor2,h=6*alto,center=true);
    // alitas del stepper
    for(y=[35/2,-35/2])      
      hull(){
        translate([-(radio_rueda_1+radio_rueda_2-8+1.5),
        y,0])
          cylinder(d=tor2,h=3*alto,center=true);
        translate([-(radio_rueda_1+radio_rueda_2-8-1.5),
        y,0])
          cylinder(d=tor2,h=3*alto,center=true);
      }
    // eje del stepper
    translate([-(radio_rueda_1+radio_rueda_2),0,0])
       cylinder(d=26,h=3*alto,center=true);
    // más del eje del stepper
//   translate([-30,radio_rueda_1+radio_rueda_2,-5])
//      cube([60,30,3*alto]);
    // agujero central
    cylinder(h=a_eje_acimutal*3,d=d_eje_acimutal-10, center=true);
  }
}


//porta_BH1750();
//translate([-7,-7,5]) BH1750();

rotate([0,-30,0]) {
translate([0,0,-20.8]){
//  color("gray") translate([0,0,-8]) porta_ldr();
  color("gray") translate([0,0,-8-0]) porta_BH1750();
  !if (tubo_seccionado) {
    difference(){
      tubo();
      translate([0,-20,-100])
        cube([40,40,300]);
      }
    } else {
      tubo();
    }
  color("lightblue") translate([lado,lado,lado-6]/2) rotate([0,-90,0]) eje(lado,1.5);
  color("lightblue") translate([-lado,-lado,lado-6]/2) rotate([0,-90,180]) eje(12,1.5);  
  }
color ("green") translate([0,-39-25*explo,0]/2) rotate([90,0,0]) eje_aux();  
translate([12+7*explo,-24.5-12.5*explo,37.0])
  metric_bolt(size=3, l=15, details=false, pitch=0,
              orient=ORIENT_X);
translate([.6,-24.5-20*explo,37.4])
  color("lightgrey") 
    difference(){
      cube([2,8.5,8.5],center=true);
      rotate([0,90,0])
        cylinder(h=5,d=3,center=true);
    }
}

color("grey",.8){
  translate([0,-1.39*27-30*explo,0])
    pilar(true);
  translate([0,27.0+15*explo,0])
    pilar(false);
}
color("blue",.8){
  translate([6.5+7*explo,-70-30*explo,-5.3])
    abrazadera_servo(false);
  translate([-6.5-7*explo,-70-30*explo,-5.3])
    rotate([0,180,0])
      abrazadera_servo(true);
}


////color("white") translate([0,0,100]) ldr();
translate([100,-78/2-5.5,-39])
  rotate([0,0,90])
    color ("cyan", .8) robotbit();
translate([11.8/2,-80-30*explo,6])
  rotate([0,90,90])
    color ("cyan", .8) servo_s90g ();
translate([0,-48.5-17*explo,0])
  rotate([0,-20,0])
    rotate([0,90,-90])
      color ("cyan", .8) garra_servo(lado);
//  color ("cyan", .5) robotbit();
  
color ("cyan", .8) 
  rotate(90)
    translate([0,
               radio_rueda_1+radio_rueda_2-8+10*explo,
               -20])
      rotate([0,180,0])
       stepper_28BYJ_48();

color("blue",0.8)
rotate(90)
  translate([0,(radio_rueda_1+radio_rueda_2+10*explo),
              -45-e_rueda_2/2-1-20*explo])
     rotate((number_of_teeth_2 % 2) == 1 ? 180/  number_of_teeth_2 : 0)
      rueda_2();


translate([0,0,-45-10*explo])
  base_sup();

color("red",0.8)
  translate([0,0,-45.1-e_rueda_1/2-20*explo])
    base();
    
color("red",0.8)
 translate([0,0,-95.2-1-35*explo])
   pie();

color("green",0.8)
  for(a=[0:120:359])
     rotate(a) 
        translate([largo_pie,0,-105-55*explo])
          manija_pie();

for(a=[0:120:359])
  rotate(a) 
    translate([largo_pie,0,-105-55*explo])
      metric_bolt(headtype="round", size=6, l=35,
                  details=false, pitch=0, phillips="#2",
                  orient=ORIENT_ZNEG);