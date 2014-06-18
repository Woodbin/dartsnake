import 'dart:html';
import 'dart:math';

CanvasElement platno;           //Naše plátno
CanvasRenderingContext2D ctx;
const int velikost=15;          //Velikost políčka na hrací ploše
Hlava hlava = new Hlava();      //Náš snejk
Stopwatch stopky = new Stopwatch();
int rychlost = 1000;          //Počáteční rychlost pohybu

/**Hlavní metoda
 * 
 */
void main() {
  platno = querySelector("#platno");
     ctx = platno.context2D;      
     init();
}

/**
 * Inicializace
 */
void init(){
  stopky.start();
  ctx.fillStyle="white";
  ctx.beginPath();
  ctx.fillRect(0, 0, platno.width, platno.height);
  ctx.fill();
  window.onKeyDown.listen(zpracujKlavesu);      //zaveď event pro klávesu
  draw();                                       //Začni vykreslovací smyčku
}

/**
 * Zpracování klávesy
 */
void zpracujKlavesu(KeyboardEvent k){
  hlava.zmenSmer(k);  
}

/**
 * Vykreslovací metoda
 */
void draw(){
  ctx.fillStyle="white";
  ctx.beginPath();
  ctx.fillRect(0,0,platno.width,platno.height);
  ctx.fill();
  hlava.vykresliSe(ctx);
  window.requestAnimationFrame(loop);
}

/**
 * Herní smyčka
 */
void loop(num _){
  if ( stopky.elapsedMilliseconds>rychlost){    //Zpracuj pohyb jen pokud uběhl žádaný čas
    hlava.pohyb();
    stopky.reset(); //vynuluj stopky
  }
  draw();
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/**
 * Herní objekt - abstrakt ze kterého dědíme
 * Má potřebné vlastnosti - x,y,barva - a metody - Kolizní test, vykreslení, znič se
 */
abstract class HerniObjekt{
  var x;
  var y;
  String barva;
  
  
  
  void kolizniTest() {
    
  }
  
  void znicSe(){
    
  }
  
  void vykresliSe(CanvasRenderingContext2D _ctx){
    _ctx.fillStyle = barva;
    _ctx.beginPath();
    _ctx.fillRect(x, y, velikost, velikost);
    _ctx.fill();
  }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/**
 * Hlava Snejka - uchovává si směr kterým se hýbe a délku svého těla
 */
class Hlava extends HerniObjekt{
 int smer;
 int delka;
 
 /**
  * Konstruktor - vygenerujeme hada na náhodné pozici
  */
 Hlava(){
   var random = new Random();
   x= random.nextInt(39)*15;
   y= random.nextInt(39)*15;
   smer = random.nextInt(3);
   barva = "red"; 
 }
 
 /**
  * ZMěnení směru podle KeyboardEventu a kódu stisknuté klávesy
  */
 void zmenSmer(KeyboardEvent k){
   switch (k.keyCode)
   {
     case 37: smer = 3; break;
     case 38: smer = 0; break;
     case 39: smer = 1; break;
     case 40: smer = 2; break;
   }
 }
 
 /**
  * Pohybujeme se podle směru 
  */
 void pohyb(){
   switch (smer){
     case 3: x -= velikost; break;
     case 0: y -= velikost; break;
     case 1: x += velikost; break;
     case 2: y += velikost; break;
   }
 }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class Clanek extends HerniObjekt{
 int zivoty;
 
 void zije(){
   
 }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class Jidlo extends HerniObjekt{
  
}