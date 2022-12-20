$fa = 1;
$fs = 0.4;

module robotbit() {
  r = 5;
  // base
  difference(){
    translate([r,r,0])
      minkowski(){
        cube([78-2*r,57-2*r,1]);
        cylinder(h=2, r=r);
      }
    // agujeros grandes
    for(x=[3,78-3], y=[5,57-5])
      translate([x,y,0])
        cylinder(h=10, d=4.8, center=true);    
  }
  // batería
  translate([0,16,0])
    cube([78,20,22.5]);  
  // microbit
  translate([12,10,0])
    cube([52,1,50]);
}
//robotbit();
module stepper_28BYJ_48 () {
  // cuerpo
  cylinder(h=19, d=28);
  // alitas  
  difference(){
    hull(){
      for(s=[-1,1])
        translate([35/2*s,0,18])
          cylinder(h=1,d=7);
    }
    for(s=[-1,1])
        translate([35/2*s,0,18])
          cylinder(h=6,d=4,center=true);
  }
  // eje
  translate([0,8,19]) {
    cylinder(h=1.5, d=9);
    cylinder(h=10,d=5);
  }
  // "enchufe"
  translate([-14.6/2,-17,0])
    cube([14.6, 17, 19]);  
}

module servo_s90g () {
  // cuerpo
  cube([22.5,11.8,22.7]);
  // alitas
  difference(){
    translate([-4.7,0,15.9])
      cube([22.5+4.7*2,11.8,2.5]);    
    translate([-2.3,5.9,15])
      cylinder(h=10,d=2);
    translate([22.5+2.3,5.9,15])
      cylinder(h=10,d=2);
  }
  // engranajes
  translate([5.9,5.9,22.7])
    cylinder(h=4,d=11.8);
  translate([5.9+8.8-2.5,5.9,22.7])
    cylinder(h=4,d=5);
  // eje
  translate([5.9,5.9,26.7])
    cylinder(h=3.2,d=4.6);
}

module garra_servo(){
  hull(){
    cylinder(h=1.5,d=7);
    for(s=[-1,1])
      translate([14*s,0,0])
        cylinder(h=1.5,d=4);
  }
  cylinder(h=4,d=7);
}
//garra_servo();

module ldr(){
  cylinder(h=2.4,d=5.1);
  for(s=[-1,1])
    translate([s*3.4/2,0,0])
      cylinder(h=34, d=0.5);  
}

module BH1750 () {
  difference(){ 
    cube([18.5,14,1]);
    for (y=[14/6:14/6:13])
      translate([18.5-1.5,y,0])
        cylinder(h=4,d=1,center=true);
    for (y=[1+1.5,14-1-1.5])
      translate([1+1.5,y,0])
        cylinder(h=4,d=3,center=true);
  }
  color("black")
    translate([7-1.8/2,7-1.5,1])
      cube([1.8,3,1]);
}
