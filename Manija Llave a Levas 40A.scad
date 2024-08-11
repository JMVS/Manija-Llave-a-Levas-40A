$fn=64;

manijaLargo=70;
manijaAncho=17;
manijaAlto=30;
manijaEspesor=2.20;
tapaDiametro=40;
tapaAlto=7;
soporteEjeLado=13;
soporteEjeAgujeroLado=7;
soporteEjeAlto=19;
soporteEjeAgujeroPasanteDiamemtro=3;
SoporteEstrias=6;
fresadoTornilloDiametro=6.75;
fresadoTornilloAlto=3.35;
desplazamientoCentro=27;

manijaCompleta();

module manijaCompleta() {
    difference() {
        manijaHueca();
        translate([desplazamientoCentro-tapaDiametro/2,0,0]) tapaInterior();
        translate([desplazamientoCentro/2-soporteEjeLado/2,0,0]) cyl(h=manijaAlto+.1, d=soporteEjeAgujeroPasanteDiamemtro, align=V_TOP);
    }
    translate([desplazamientoCentro-tapaDiametro/2,0,0]) tapaHueca();

    translate([desplazamientoCentro/2-soporteEjeLado/2,0,0]) soporteEje();
    
    // Cruz de refuerzo interior
    translate([-desplazamientoCentro/2,0,manijaAlto]) {
        zrot(40) cuboid([manijaAncho*1.25,.65,manijaAlto/1.35],align=V_BOTTOM);
        zrot(-40) cuboid([manijaAncho*1.25,.65,manijaAlto/1.35],align=V_BOTTOM);
        
    }
}

module manijaHueca() {
    difference() {
        cuboid([manijaLargo, manijaAncho, manijaAlto], fillet=manijaAncho/2, edges=EDGES_Z_ALL, align=V_TOP);

        manijaInterior();
        
        translate([desplazamientoCentro/2-soporteEjeLado/2,0,manijaAlto-fresadoTornilloAlto]) fresadoTornillo();
    }
}

module manijaInterior() {
    translate([0,0,-.1]) cuboid([manijaLargo-manijaEspesor*2, manijaAncho-manijaEspesor*2, manijaAlto-manijaEspesor+.1], fillet=manijaAncho/2-manijaEspesor, edges=EDGES_Z_ALL, align=V_TOP);
}


module tapaHueca() {
    difference() {
        cyl(h=tapaAlto, d=tapaDiametro, align=V_TOP);

        tapaInterior();
        
        manijaInterior();
    }
}

module tapaInterior() {
    translate([0,0,-.1]) cyl(h=tapaAlto-manijaEspesor, d=tapaDiametro-manijaEspesor*2+.1, align=V_TOP);
}

module soporteEje() {
    soporteEjeBase();
    translate([0,0,soporteEjeAlto/2]) guiaTornillo();
}

module guiaTornillo() {
    difference() {
        // Guias de encastre en el agujero del eje cuadrado
        tube(h=soporteEjeAlto/2, id=soporteEjeAgujeroPasanteDiamemtro, od2=soporteEjeAgujeroPasanteDiamemtro+1, od1=soporteEjeAgujeroPasanteDiamemtro+.25);
        translate([0,0,-.1]) cuboid([1.5,soporteEjeAgujeroPasanteDiamemtro+2,(soporteEjeAlto/2)+.1], align=V_TOP);
    }
}

module soporteEjeBase() {
    difference() {
        // Prisma rectangular base
        cuboid([soporteEjeLado,soporteEjeLado,manijaAlto], align=V_TOP);
        // Estrias para encastre del eje cuadrado en varias posiciones
        for(i = [1 : SoporteEstrias]) {
            rotate(i * 360/SoporteEstrias) {
            translate([0,0,-.1]) cuboid([soporteEjeAgujeroLado,soporteEjeAgujeroLado,soporteEjeAlto+.1], align=V_TOP);
            }
        }
        // Agujero pasante para tornillo
        cyl(h=manijaAlto+.1, d=soporteEjeAgujeroPasanteDiamemtro, align=V_TOP);
        // Agujero mayor para alojar cabeza del tornillo
        translate([0,0,manijaAlto-fresadoTornilloAlto]) fresadoTornillo();
    }
}

module fresadoTornillo() {
    cyl(h=fresadoTornilloAlto, d=fresadoTornilloDiametro, align=V_TOP);
}
