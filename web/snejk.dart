import 'dart:html';
import 'dart:math';
import 'dart:collection';

CanvasElement platno;           //Naše plátno
CanvasRenderingContext2D ctx;
const int velikost=15;          //Velikost políčka na hrací ploše
Hlava hlava = new Hlava();      //Náš snejk
Stopwatch stopky = new Stopwatch();
int rychlost = 1000;          //Počáteční rychlost pohybu
Queue<Clanek> ocas = new Queue<Clanek>();
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
  ctx.fillStyle="grey";
  ctx.beginPath();
  ctx.fillRect(0,0,platno.width,platno.height);
  ctx.fill();
  hlava.vykresliSe(ctx);
  ocas.forEach((clanek)=> clanek.vykresliSe(ctx));
  window.requestAnimationFrame(loop);
}

/**
 * Herní smyčka
 */
void loop(num _){
  if ( stopky.elapsedMilliseconds>rychlost){    //Zpracuj pohyb jen pokud uběhl žádaný čas
    hlava.pohyb();
    
    bool smaz = false;
    ocas.forEach((clanek){
      if(!clanek.zije()){
       smaz=true;
      }
    });
    if(smaz) ocas.removeLast();
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
  
  
  
  bool kolizniTest(HerniObjekt _obj) {
    Rectangle tento = new Rectangle(x, y, velikost, velikost);
    Rectangle tamten = new Rectangle(_obj.x, _obj.y, velikost, velikost);
    return tento.containsRectangle(tamten);
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
   delka = 3;
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
   int docasneX=x;
   int docasneY=y;
   switch (smer){
     case 3: x -= velikost; break;
     case 0: y -= velikost; break;
     case 1: x += velikost; break;
     case 2: y += velikost; break;
   }
   
   Clanek clanek = new Clanek(docasneX,docasneY,delka);
   ocas.addFirst(clanek);
 }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class Clanek extends HerniObjekt{
 int zivoty;
 
 Clanek(int _x, int _y, int _zivoty){
   barva = 'green';
   x = _x;
   y = _y;
   zivoty = _zivoty;
 }
 
 
 bool zije(){
   if ( zivoty > 1){
     zivoty -= 1;
     return true;
   }
   else return false;
 }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class Jidlo extends HerniObjekt{
  
}