$fa = 1;
$fs = 0.4;

use <auxiliares.scad>

include <BOSL/constants.scad>
use <BOSL/involute_gears.scad>
use <BOSL/beziers.scad>
use <BOSL/metric_screws.scad>

explo=0; // 0 o 2
tubo_seccionado=false; // true o false
reduccion=2; // 2, 3 o 4
con_tornillos=true;

lado=18;
mm_per_tooth = 5;
number_of_teeth_ppal=72;
clearance=0.5;
backlash=0.1;
pressure_angle=20;
e_rueda_1 = 45*.28;
e_rueda_2 = 10;
d_eje_acimutal=50;
a_eje_acimutal=70;
largo_pie=70;
dist_torn_lateral = largo_pie-13;
alto_base=.28*33;
base_pilar=.28*41;
largo_pie_pilar=75;
altura_pies_pilar = 30;
d_tor=3.6;
a_tuer=9;
h_tuer=2.4;
holgura_acimutal=0.5;
d_torni_g=6.1;
torn_lateral=5.2;
w1_pin=2.8;
w2_pin=3.5;
h_pin=5;

function radio_rueda(dientes) =
  pitch_radius(mm_per_tooth=mm_per_tooth, number_of_teeth = dientes);
  
radio_rueda_ppal = radio_rueda(number_of_teeth_ppal);
radio_rueda_secundaria = radio_rueda(number_of_teeth_ppal/reduccion);

distancia_ruedas = radio_rueda_ppal + radio_rueda_secundaria;
distancia_ruedas_max = radio_rueda_ppal + radio_rueda(number_of_teeth_ppal/2);

radio_ruedas_secundarias = [ for (red=[2,3,4]) radio_rueda(number_of_teeth_ppal/red) ];

module rueda_base() {
    difference(){     
        gear(mm_per_tooth=mm_per_tooth,
             number_of_teeth=number_of_teeth_ppal,
             thickness=e_rueda_1,
             hole_diameter=d_eje_acimutal+2,
             pressure_angle=pressure_angle,
//             clearance=clearance,
             backlash=backlash
             );    
      // muesquitas
    for(a=[0:120:359])
      rotate(a) 
        translate([d_eje_acimutal/2+5+2,0,0])
          cylinder(h=3*e_rueda_1,d=8,center=true);
      }      
}

module pie(){  
  difference(){  
    union(){
      cylinder(h=a_eje_acimutal-e_rueda_1, 
               d1=d_eje_acimutal+2*4,
               d2=d_eje_acimutal+2*12);   
      // pies      
        for(a=[0:120:359])
          rotate(a) {
            rotate([90,0,0])
              linear_extrude(10,center=true)
                polygon([[0,0],[largo_pie,0],
                        [largo_pie,altura_pies_pilar],[0,altura_pies_pilar+14]]);
            translate([largo_pie,0,0])
              cylinder(h=altura_pies_pilar,d=12+d_torni_g);
            }
       // pernitos
       for(a=[0:120:359])
         rotate(a) 
           translate([d_eje_acimutal/2+5+2,0,
                      a_eje_acimutal-e_rueda_1-.02])
             cylinder(h=12.5-3.5,d1=7.5,d2=7.9);
       // bordes de tornillos de ajuste lateral
      for(a=[0:120:359])            
        rotate(a)
          translate([dist_torn_lateral,0,altura_pies_pilar/2])
            rotate([90,30,0])      
              translate([0,0,5])      
                cylinder(h=3,d1=15,d2=10.5,$fn=6);
    }
    // hueco central
    cylinder(h=a_eje_acimutal*3, 
             d=d_eje_acimutal+holgura_acimutal,
             center=true);
    // huecos tornillos    
      for(a=[0:120:359])
          rotate(a) {
            translate([largo_pie-27,-1.5/2,-1])
              cube([45,1.5,40]);
            translate([largo_pie,0,0])
              cylinder(h=70,d=d_torni_g-.1,
                       center=true);
            }
    // tornillos de ajuste lateral
      for(a=[0:120:359])            
        rotate(a)
          translate([dist_torn_lateral,0,altura_pies_pilar/2])
            rotate([90,30,0]){
              cylinder(h=30,d=torn_lateral,
                       center=true);
              translate([0,0,5])
                cylinder(h=5,d=9.35+2*.3,$fn=6);
            }
    // 'holgura' para entre cómodo el freno lateral
      for(a=[0:120:359])            
        rotate(a)
          translate([dist_torn_lateral,0,altura_pies_pilar/2])
            rotate([-90,0,0])              
              translate([0,0,5])
                cylinder(h=6,d=14+2);            
    // "rebajas" hasta que solucione el temita de mi impresora... ;)
      cylinder(h=2*2,
               d=d_eje_acimutal+holgura_acimutal+2*.3,
               center=true);
     for(a=[0:120:359])
          rotate(a) 
            translate([largo_pie,0,0])       
              cylinder(h=2*2,d=d_torni_g+2*.3,
                       center=true);
    }       
}

module manija_pie(){
  d = 50;
  difference(){
    cylinder(h=10,d=d);
    cylinder(h=30,d=d_torni_g-.1,center=true);
    cylinder(h=2*2,d=d_torni_g+2*.3,center=true);
    // muescas
    cube([1.5,11,30],center=true);
    cube([11,1.5,30],center=true);
    // contorno
    for(a=[0:30:359])
      rotate(a)
        translate([d/1.8,0,0])
          cylinder(h=30,d=10.5,center=true);
  }
}

module base_pie(){
  difference(){
    cylinder(h=7,d=40);
    cylinder(h=20,d=8,center=true);
    cylinder(h=2*(7-8*.28),d=14,center=true);
    rotate_extrude()
      translate([14,0,0])
        square([w2_pin,2*(h_pin+1)],center=true);    
  }
}

module base_pie_2(){
  base = 8;
  difference(){
    cylinder(h=base*.28,d=40-2*.2); // 2.24
    translate([0,0,base*.28])
      cylinder(h=2*5*.28,d=18.3,center=true);
  }
  translate([0,0,base*.28])
    rotate_extrude()
      translate([14,0,0])
        polygon([[-w1_pin/2,0],[w1_pin/2,0],
                 [w2_pin/2,h_pin],[-w2_pin/2,h_pin]]);
}

module freno_lateral(){  
    difference(){      
      union(){
        cylinder(h=6,r=7);
        translate([0,0,6])            
          cylinder(h=10,d=20);
      }
      cylinder(h=60,d=torn_lateral,center=true);
      cylinder(h=2*4.5,d=10.9,$fn=6,center=true);
      for(a=[0:30:359])
        rotate(a)
          translate([11,0,0])
            cylinder(h=60,d=4);      
    }
}
  
module rueda_secundaria(){  
  difference(){
    union(){
     cylinder(d=17,h=11.7);
     gear(mm_per_tooth=mm_per_tooth, 
          number_of_teeth = number_of_teeth_ppal /reduccion,
          thickness=e_rueda_2,
          pressure_angle=pressure_angle,
//          clearance=clearance, 
          backlash=backlash
      );
    }   
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
  alto3=base_pilar;
  difference(){
    hull(){
      rotate([90,0,0])
        cylinder(h=ancho,d=lado+10,center=true);
      translate([-25,-ancho/2,alto2])
        cube([50,ancho,alto3]);
    }
    rotate([90,0,0])
      cylinder(h=30,d=lado+.5,center=true);
  }
  // pie  
  difference(){
    translate([-largo_pie_pilar/2,-ancho/2,alto2])
      cube([largo_pie_pilar,ancho,alto3]);
    for(s=[-1,1])
      translate([(largo_pie_pilar+50)/4*s,0,alto2])
        cylinder(h=3*alto3,d=3.7,center=true);
  }
  // soporte servo
  if (servo) {
    difference(){
      for (z=[(lado+10+3.4)/2+1,-26.2-1]){
        translate([0,(-34-11+ancho)/2,z])
          cube([5,34+11,10],center=true);
        translate([0,(-34+ancho)/2,z])
          cube([10,34,10],center=true);
      }
      for (z=[(lado+10+3.4)/2+1,-26.2-1])        
          translate([0,-32.5,z])
            rotate([0,90,0])
              cylinder(h=30,d=3.7,center=true);
    }
  }
}
module abrazadera_servo(tuerca){
  difference(){
    cube([8,10,54],center=true);
    // hueco central
    translate([-4.5+.2,0,0])
      cube([7.4,20,34],center=true);
    // tornillos    
    for(s=[-1,1])
      translate([0,0,s*(54/2-5)])
        rotate([0,90,0])
          cylinder(h=20,d=4,center=true);    
    // tuerca
    if (tuerca) 
      for (s=[-1,1])
        translate([2.5+1,0,s*(54/2-5)])
          cube([5,8,8],center=true);
  }
}

module pasador_cables(){
  let(d=4, l=6, h=10){
    difference(){
      hull()
        for (s=[1,-1])
          translate([s*l/2,0,0])
            cylinder(h=h,d=d+4);  
    hull()
      for (s=[1,-1])
        translate([s*l/2,0,0])
          cylinder(h=h*3,d=d,center=true);
    translate([l,0,0])
      cube([l,h,h*3],center=true);
    translate([3.5-0.5,d,0])
      cube([9,h,h*3],center=true);  
    }
    translate([-1.5,d-1,0])
      cylinder(d=2,h=h);
  }
}

module acople_sensor(){
  dia_int=lado-4; 
  difference() {
    cylinder(h=13.2,d1=dia_int-.8,d2=dia_int);
    translate([0,0,2])
      cylinder(h=30,d=dia_int-4);
    for(a=[45,90+45])
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
        cylinder(h=34, d=1.5);  
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
    translate([-7.6,-14.7/2,-.01])
      cube([19.1,14.7,6.7]);      
  }
  // pines para la plaquita
  for (y=[1+1.5,14-1-1.5])
      translate([-7+1.5+1,y-7,0])
        cylinder(h=7,d=2.7);
}

module eje_aux(){
  ancho1=32;
  ancho2=10;
  e=7;
  difference(){
    union(){
      cylinder(h=ancho1,d=lado);
      hull(){
        translate([-lado/2+6-.8,0,0])
          cube([e,46,ancho2]);                
        difference(){
          cylinder(h=ancho2,d=lado);
          translate([-lado,-lado,-1]) 
            cube([lado,2*lado,2*ancho2]);
        }
      }
      // elástico      
      bez = [ [0,0],[-4,10],[-4,40],[-6,43],[-8,40],[-8,10],[-4,0],[-3,-3] ];
      translate([-5,5,0])
//        trace_bezier(bez, N=2);  
      linear_extrude_bezier(bez, N=2, height=ancho2, splinesteps=32, convexity=5);
    }    
    // hueco
    cylinder(h=ancho1+12,d=12+.5,center=true);
    // tuerca
    translate([-.7-.65,lado*2.3-8.5,-ancho2])
      cube([2.1,9,ancho2*3]);
    // tornillo
    translate([-5,lado*2.3-8.5/2+.25,ancho2/2])
      rotate([0,90,0])
        cylinder(d=3.7,h=12);    
    // hueco garra servo
    translate([0,0,ancho1-3]) {
     cylinder(h=6,d=6.9);
      rotate(90)
        hull(){
        cylinder(h=6,d=(6.9+4.7)/2);
        for(s=[-1,1])
          translate([9*s,0,0])
            cylinder(h=6,d=4.6);
       }
     }
  }
}

module bisel(radio,alto) {
  difference(){
    cube([radio,radio,alto]);
    translate([radio,radio,0])
      cylinder(r=radio,h=3*alto,center=true);
  }
}

module base_sup(){  
  r_bisel=8;
  difference() {
    union(){
      hull(){        
        for(s=[-1,1]){
        translate([s*36,33,0])
          cylinder(h=alto_base,d=10);
        translate([s*36,-44,0])
          cylinder(h=alto_base,d=10);
        }
      }
       for(y=[35/2,-35/2])      
         hull(){
          translate([-distancia_ruedas_max+3,
                     y,0])
            cylinder(d=14,h=alto_base);
          translate([0,y,0])
            cylinder(d=14,h=alto_base);
        }
      hull(){
       translate([97,30.5,0])
         cylinder(h=alto_base,d=15);
       translate([0,30.5,0])
         cylinder(h=alto_base,d=15);
      }  
      hull(){
       translate([97,-41.5,0])
         cylinder(h=alto_base,d=15);
       translate([0,-41.5,0])
         cylinder(h=alto_base,d=15);
      }  
      // eje acimutal
      translate([0,0,-a_eje_acimutal])
        cylinder(h=a_eje_acimutal,d=d_eje_acimutal);
      // biseles
      translate([-41,24.5,0])
        rotate(90)
          bisel(r_bisel,alto_base);
      translate([-41,-10.5,0])
        rotate(90)
          bisel(r_bisel,alto_base);
      translate([-41,10.5,0])
        rotate(180)
          bisel(r_bisel,alto_base);
      translate([-41,-24.5,0])
        rotate(180)
          bisel(r_bisel,alto_base);
      translate([41,23,0])
        rotate(270)
          bisel(r_bisel,alto_base);
      translate([41,-34,0])
        rotate(0)
          bisel(r_bisel,alto_base);
    }
    // agujeros para tornillos    
    // pilares
    prof_tuer=4.2; // 15*0.28
    let (holgura=1.5)
    for(x=[31.25,-31.25])
      for(y=[26.65,-36.65]) {
        hull(){
          for(s=[-1,1])
            translate([x,
                       y + (y>0 ? s*holgura : 0),
                       0])
              cylinder(d=d_tor,h=3*alto_base,center=true);
        }
        translate([x,y,0])
          cube([a_tuer,
                a_tuer + (y>0 ? holgura*2 : 0) ,
                prof_tuer*2],center=true);
      }
    // microbit
    for(x=[48,95])
      for(y=[30.5,-41.5]){
        translate([x,y,0])
          cylinder(d=d_tor,h=6*alto_base,center=true);
        translate([x,y,0])
          cube([a_tuer,a_tuer,prof_tuer*2],center=true);
      }
    // alitas del stepper
    for(y=[35/2,-35/2]) 
      for (x=radio_ruedas_secundarias){
        hull(){
          translate([-(radio_rueda_ppal+x-8+1.5),
          y,0])
            cylinder(d=d_tor,h=3*alto_base,center=true);
          translate([-(radio_rueda_ppal+x-8-1.5),
          y,0])
            cylinder(d=d_tor,h=3*alto_base,center=true);      
        }
        hull(){
          translate([-(radio_rueda_ppal+x-8+1.5),
          y,0])
          cube([a_tuer,8.5,prof_tuer*2],center=true);           
          translate([-(radio_rueda_ppal+x-8-1.5),
          y,0])
            cube([a_tuer,8.5,prof_tuer*2],center=true);
        } 
      }
    // agujero central
    cylinder(h=a_eje_acimutal*3,
             d=d_eje_acimutal-2*7, center=true);
  }
}

module pasador_interno_acimutal(){
  alfa=60;
  difference(){
    cylinder(h=10,d=35.7-.2);
    cylinder(h=30,d=4.76-.35,center=true);      
    translate([0,0,7])
      cylinder(h=10,d=10.9,$fn=6);
    // hueco cables (?)
    for(a=[0,alfa])
      rotate(a)
        translate([11,0,0])
          cylinder(h=30,d=5,center=true);
    rotate_extrude(angle=alfa)
      translate([11,0,0])
        square([5,30],center=true);
    // "rebaja"    
    cylinder(h=2*1.8,d=4.76-.35+2*.3,center=true);
  }
}

module reten_eje_acimutal(){
  difference(){
    cylinder(h=6,d2=d_eje_acimutal+2*5,
                 d1=d_eje_acimutal+2*4);
    cylinder(h=20,d=5.2,center=true);
    for(s=[-1,1])
      translate([s*18,0,0])
        cylinder(h=20,d=11,center=true);        
    // "rebaja"
    translate([0,0,6])
      cylinder(h=2*2,d=5.2+2*.3,center=true);
  }
}

rotate([0,-30,0]) {
translate([0,0,-20.8]){
  color("#111111") 
    translate([0,0,-8]) porta_ldr();
  color("#111111") 
    translate([0,0,-8-0]) porta_BH1750();
  color("#222222")
  if (tubo_seccionado) {
    difference(){
      tubo();
      translate([0,-20,-100])
        cube([40,40,300]);
      }
    } else {
      tubo();
    }
  color("pink") translate([lado,lado,lado-6]/2) rotate([0,-90,0]) eje(lado,1.5);
  color("pink") translate([-lado,-lado,lado-6]/2) rotate([0,-90,180]) eje(12,1.5);  
  }
color ("mediumslateblue") translate([0,-38.1-25*explo,0]/2) rotate([90,0,0]) eje_aux();  
if(con_tornillos)
  translate([15.3+7*explo,-24.5-12.5*explo,37.4])
      metric_bolt(headtype="round",
                  size=3,l=19.05, 
                  details=false, pitch=0,
                  phillips="#2",
                  orient=ORIENT_X);
translate([.35-.65,-24.5-20*explo,37.4])
  color("lightgrey") 
    difference(){
      cube([1.8,8.5,8.5],center=true);
      rotate([0,90,0])
        cylinder(h=5,d=3,center=true);
    }
}

color("deepskyblue",.9){
  translate([0,-36.65-30*explo,0])
    pilar(true);
  translate([0,26.6+15*explo,0])
    pilar(false);
  translate([-16,26.6+11.5+25*explo,-37])
    rotate([0,90,0])
      pasador_cables();
  translate([6,26.6+11.5+25*explo,-37])
    rotate([0,90,0])
      pasador_cables();
  translate([-6,-(36.64+11.5+50*explo),-37])    
     rotate([0,90,180])
       pasador_cables();
  translate([16,-(36.64+11.5+50*explo),-37])    
     rotate([0,90,180])
       pasador_cables();
}
color("blue",.8){
  translate([6.5+7*explo,-69.15-30*explo,-5.3])
    abrazadera_servo(false);
  translate([-6.5-7*explo,-69.15-30*explo,-5.3])
    rotate([0,180,0])
      abrazadera_servo(true);
}

translate([100,-78/2-5.5,-36])
  rotate([0,0,90])
    robotbit();
translate([11.8/2,-79.9-30*explo,6])
  rotate([0,90,90])
    servo_s90g ();
translate([0,-48.1-17*explo,0])
  rotate([0,-20,0])
    rotate([0,90,-90])
      garra_servo(lado);  
rotate(90)
  translate([0,
             distancia_ruedas-8+10*explo,
             -21])
    rotate([0,180,0])
       stepper_28BYJ_48();

color("peru",0.9)
rotate(90)
  translate([0,
            distancia_ruedas +10*explo,
            -40-1.5-alto_base-e_rueda_2/2-20*explo])
     rotate(180/(number_of_teeth_ppal/reduccion))
       rueda_secundaria();

translate([0,0,-40-alto_base-.1-10*explo])
  color("darkorange") base_sup();
translate([0,0,
          -40-alto_base-a_eje_acimutal+5-45*explo])
    color("darkorange") pasador_interno_acimutal();

color("teal",0.9)
  translate([0,0,-40-alto_base-.15-e_rueda_1/2-20*explo])
     rueda_base();

color("teal",0.9)
  translate([0,0,-(53+alto_base+a_eje_acimutal-e_rueda_1-.2+0)-35*explo])
     pie();
color("red",0.9)
  translate([0,0,-(53+alto_base+a_eje_acimutal-e_rueda_1-.2+0)-35*explo])
    for(a=[0,120,240])
      rotate(a)
        translate([dist_torn_lateral,5.1+8*explo,altura_pies_pilar/2])
          rotate([-90,0,0])
            freno_lateral();
color("green",0.8)
  for(a=[0:120:359])
     rotate(a) 
        translate([largo_pie,0,
             -40-alto_base-e_rueda_1-a_eje_acimutal-1
             -42*explo])
          manija_pie();
color("sienna",0.9)
  for(a=[0:120:359])
     rotate(a) 
        translate([largo_pie,0,
             -40-alto_base-e_rueda_1-a_eje_acimutal-9-2
             -48*explo]){
          base_pie();
          translate([0,0,-8*.28-10*explo])
               base_pie_2();
          }

color("teal",0.9)
  translate([0,0,-(53+alto_base+a_eje_acimutal-e_rueda_1-.2+7)-50*explo])
     reten_eje_acimutal();
          
//translate([0,20,0])
if (con_tornillos) {
  for(a=[0:120:359]) // pie
    rotate(a) 
      translate([largo_pie,0,
         -40-alto_base-e_rueda_1-a_eje_acimutal-1-4
         -55*explo])
        metric_bolt(headtype="round", 
                    size=6.35, l=50.8,//44.45,  
                    details=false, 
                    pitch=0, phillips="#2",
                    orient=ORIENT_ZNEG);
  for(a=[0:120:359]) // arandelas
    rotate(a) 
      translate([largo_pie,0,
         -40-alto_base-e_rueda_1-a_eje_acimutal-1-11
         -54.5*explo])
      color("silver")
        difference(){
          cylinder(h=1,d=18);
          cylinder(h=5,d=8,center=true);
        }
  translate([0,0,-(53+alto_base+a_eje_acimutal-e_rueda_1-.2+7)-55*explo])
        metric_bolt(headtype="round", 
                    size=5.1, l=20,
                    details=false, 
                    pitch=0, phillips="#2",
                    orient=ORIENT_ZNEG);  
  for(a=[0,120,240])
    rotate(a)
      translate([dist_torn_lateral,-5-18*explo,
          -(53+alto_base+a_eje_acimutal-e_rueda_1-.2)+altura_pies_pilar/2-35*explo])
        rotate([0,30,0])
        metric_bolt(headtype="hex", 
                    size=5.1, l=22.25,  
                    details=false, 
                    pitch=0, phillips="#2",
                    orient=ORIENT_YNEG);
  for(x=[31.25,-31.25]) {      
    translate([x,
              -36.65-30*explo,
              -40+base_pilar+explo*10])  
        metric_bolt(headtype="round", 
                    size=3, l=20.3,  
                    details=false, 
                    pitch=0, phillips="#2",
                    orient=ORIENT_Z);
    translate([x,
               26.65+15*explo,
              -40+base_pilar+explo*10])  
        metric_bolt(headtype="round", 
                    size=3, l=20.3,  
                    details=false, 
                    pitch=0, phillips="#2",
                    orient=ORIENT_Z);
  }
  for(x=[48,95])
      for(y=[30.5,-41.5])    
    translate([x,y,-40+7.1+explo*10])  
        metric_bolt(headtype="round", 
                    size=3, l=15.87,  
                    details=false, 
                    pitch=0, phillips="#2",
                    orient=ORIENT_Z);
  for(s=[-1,1])
    translate([-distancia_ruedas+8-explo*10,
               35/2*s,
              -40-8.2+alto_base+explo*8])  
          metric_bolt(headtype="round", 
                      size=3, l=9.5,  
                      details=false, 
                      pitch=0, phillips="#2",
                      orient=ORIENT_Z);
  for(z=[16.5,-27.5])
    translate([10.5+explo*25,
               -70-30*explo,
              z])  
          metric_bolt(headtype="round", 
                      size=3, l=22.2,  
                      details=false, 
                      pitch=0, phillips="#2",
                      orient=ORIENT_X);
}