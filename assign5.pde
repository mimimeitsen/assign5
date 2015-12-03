PImage start2;
PImage start1;
PImage treasure; 
PImage fighter;
PImage enemy;
PImage end2;
PImage end1;
PImage bullet;
PImage bg1;
PImage bg2; 
PImage hp;
float bgMoving;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState;

final int C = 0;
final int B = 1;
final int A = 2;
int enemyState;

int hpX;

//enemy
PImage [] enemyPosition = new PImage [5];
float enemyC [][] = new float [5][2];       
float enemyB [][] = new float [5][2];
float enemyA [][] = new float [8][2];  
float spacingX;
float spacingY;

//flame
int flameNum;
int flameCurrent;
PImage [] hit = new PImage [5];
float hitPosition [][] = new float [5][2]; 

float treasureX;
float treasureY;
float fighterX;
float fighterY;
float enemyY;
float [] bulletX = new float [5];
float [] bulletY = new float [5];

float fighterSpeed;
float enemySpeed;
int bulletSpeed;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//bullet number
int bulletNum = 0;
boolean [] bulletNumLimit = new boolean[5];

//score
PFont f;
int b;


void setup () {    
  size (640,480) ;
  frameRate(60);
    
  for ( int i = 0; i < 5; i++ ){
    hit[i] = loadImage ("img/flame" + (i+1) + ".png" );
  }
  
  start2 = loadImage ("img/start2.png");
  start1 = loadImage ("img/start1.png");  
  bg1 = loadImage ("img/bg1.png");
  bg2 = loadImage ("img/bg2.png");
  hp = loadImage ("img/hp.png");
  treasure = loadImage ("img/treasure.png");
  fighter = loadImage ("img/fighter.png");
  enemy = loadImage ("img/enemy.png");  
  end2 = loadImage ("img/end2.png");
  end1 = loadImage ("img/end1.png");
  bullet = loadImage ("img/shoot.png");
  
  gameState = GAME_START;
  enemyState = C;
  hpX = 40; 
  treasureX = floor( random(50, width - 40) );
  treasureY = floor( random(50, height - 60) );
  fighterX = width - 65 ;
  fighterY = height / 2 ; 

  //speed
  fighterSpeed = 5;
  enemySpeed = 4;
  bulletSpeed = 3;
  
  //flame
  flameNum = 0;
  flameCurrent = 0;
  for ( int i = 0; i < hitPosition.length; i ++){
    hitPosition[i][0] = 2000;
    hitPosition[i][1] = 2000;
  }

  //no bullet
  for (int i =0; i < bulletNumLimit.length ; i ++){
    bulletNumLimit[i] = false;
  }

  //enemy line
  spacingX = 0;  
  spacingY = -60; 
  enemyY = floor(random(80, 400));    
  for (int i = 0; i < 5; i++){
   enemyPosition [i] = loadImage ("img/enemy.png");  
   enemyC [i][0] = spacingX;
   enemyC [i][1] = enemyY; 
   spacingX -= 80;
  }
  
  //score
  f=createFont("Calibri", 30);
  b=0;
}


void draw() {  
  switch (gameState) {
    case GAME_START:
      image (start1, 0, 0);     
      if ( mouseX > 200 && mouseX < 460 
        && mouseY > 370 && mouseY < 420){
            image(start2, 0, 0);
            if(mousePressed){
              gameState = GAME_RUN;
            }
      }
    break;  
    
    
    case GAME_RUN:
      //bg
      image (bg2, bgMoving, 0);
      image (bg1, bgMoving-640, 0);
      image (bg2, bgMoving-1280, 0); 
      
      bgMoving += 2;
      bgMoving %= 1280;
      
      //treasure
      image (treasure, treasureX, treasureY);    
      
      //fighter
      image(fighter, fighterX, fighterY);
      
      if (upPressed && fighterY > 0) {
        fighterY -= fighterSpeed ;
      }
      if (downPressed && fighterY < 480 - 50) {
        fighterY += fighterSpeed ;
      }
      if (leftPressed && fighterX > 0) {
        fighterX -= fighterSpeed ;
      }
      if (rightPressed && fighterX < 640 - 50) {
        fighterX += fighterSpeed ;
      }  
      
      //score
      textFont(f,30);
      textAlign(CENTER);
      fill(255);
      text("Score"+b,75,465) ;
        
      //flame
      image(hit[flameCurrent], hitPosition[flameCurrent][0], hitPosition[flameCurrent][1]);      
      flameNum ++;
      if ( flameNum % 6 == 0){
        flameCurrent ++;
      } 
      if ( flameCurrent > 4){
        flameCurrent = 0;
      }
      //flame buring
      if(flameNum > 31){
        for (int i = 0; i < 5; i ++){
          hitPosition[i][0] = 1000;
          hitPosition[i][1] = 1000;
        }
      }   
      
     //bullet
      for (int i = 0; i < 5; i ++){
        if (bulletNumLimit[i] == true){
          image (bullet, bulletX[i], bulletY[i]);
          bulletX[i] -= bulletSpeed;
        }
        if (bulletX[i] < - bullet.width){
          bulletNumLimit[i] = false;
        }
      }
    
      //enemy
      switch (enemyState) { 
        case C :               
          for ( int i = 0; i < 5; i++ ){
            image(enemyPosition[i], enemyC [i][0], enemyC [i][1]);
            //bullet hit
            for (int j = 0; j < 5; j++ )
            {
              if(isHit(enemyC [i][0],enemyC [i][1],enemy.width, enemy.height,bulletX[j],bulletY[j],bullet.width,bullet.height)==true)
                 {
                   if(bulletNumLimit[j] == true){
                      for (int k = 0;  k < 5; k++ )
                      {
                        hitPosition [k][0] = enemyC [i][0];
                        hitPosition [k][1] = enemyC [i][1];
                      }
                      scoreChange(20);
                      enemyC [i][1] = -1000;
                      enemyY = floor(random(30,240));
                      bulletNumLimit[j] = false;
                      flameNum = 0;     
                   }
                 }
            }  
            //fighter get hit
            if(isHit(enemyC [i][0],enemyC [i][1],enemy.width, enemy.height,fighterX,fighterY,fighter.width,fighter.height)==true){
              for (int j = 0;  j < 5; j++){
                hitPosition [j][0] = enemyC [i][0];
                hitPosition [j][1] = enemyC [i][1];
              }
              hpX -= 40;          
              enemyC [i][1] = -1000;
              enemyY = floor( random(30,240) );
              flameNum = 0; 
            }else if(hpX <= 0){
              gameState = GAME_OVER;
              hpX = 40;
              fighterX = (640 - 65);
              fighterY = 480 / 2 ;
            } else {
              enemyC [i][0] += enemySpeed;
              enemyC [i][0] %= 1280;
            }      
          }
          
          //go to B
          if (enemyC [enemyC.length-1][0] > 640+100 ) {        
            enemyY = floor(random(30,240));            
            spacingX = 0;  
            for (int i = 0; i < 5; i++){
              enemyB [i][0] = spacingX;
              enemyB[i][1] = enemyY - spacingX / 2;
              spacingX -= 80;                 
            }
            enemyState = B;
          }
        break ; 
        
        case B :
          for (int i = 0; i < 5; i++ ){
            image(enemyPosition[i], enemyB [i][0] , enemyB [i][1]);
            //bullet hit
            for(int j = 0; j < 5; j++)
            {
              if (isHit(enemyB [i][0],enemyB [i][1],enemy.width, enemy.height,bulletX[j],bulletY[j],bullet.width,bullet.height)==true)
                   {
                     if(bulletNumLimit[j] == true)
                     {
                      for(int k = 0;  k < 5; k++ )
                      {
                        hitPosition [k][0] = enemyB [i][0];
                        hitPosition [k][1] = enemyB [i][1];
                      }      
                        scoreChange(20);
                        enemyB [i][1] = -1000;
                        enemyY = floor(random(30,240));
                        bulletNumLimit[j] = false;
                        flameNum = 0;
                    }
                   }
                    
             }   
            //fighter get hit
            if ( isHit(enemyB [i][0],enemyB [i][1],enemy.width, enemy.height,fighterX,fighterY,fighter.width,fighter.height)==true){
              for (int j = 0;  j < 5; j++ ){
                 hitPosition [j][0] = enemyB [i][0];
                 hitPosition [j][1] = enemyB [i][1];
               }
              enemyB [i][1] = -1000;
              enemyY = floor(random(200,280));
              flameNum = 0; 
              hpX -= 40;
            }else if(hpX<= 0){
              gameState = GAME_OVER;
              hpX = 40;
              fighterX = (640 - 65);
              fighterY = 480 / 2 ;
            } else {
              enemyB [i][0] += enemySpeed;
              enemyB [i][0] %= 1280;
            }         
          }
          
          //go to A
          if (enemyB [4][0] > 640 + 100){
            enemyY = floor( random(200,280) );
            enemyState = A;            
            spacingX = 0;  
            spacingY = -60; 
            for ( int i = 0; i < 8; i ++ ) {
              if ( i < 3 ) {
                enemyA [i][0] = spacingX;
                enemyA [i][1] = enemyY - spacingX;
                spacingX -= 60;
              } else if ( i == 3 ){
                enemyA [i][0] = spacingX;
                enemyA [i][1] = enemyY - spacingY;
                spacingX -= 60;
                spacingY += 60;
              } else if ( i > 3 && i <= 5 ){
                  enemyA [i][0] = spacingX;
                  enemyA [i][1] = enemyY + spacingY;
                  spacingX += 60;
                  spacingY -= 60;
              } else {
                  enemyA [i][0] = spacingX;
                  enemyA [i][1] = enemyY + spacingY;
                  spacingX += 60;
                  spacingY += 60;
              }            
            }     
          }
        break ;        
        
        case A :  
          for( int i = 0; i < 8; i++ ){
            image(enemy, enemyA [i][0], enemyA [i][1]);     
            //bullet hit     
            for( int j = 0; j < 5; j++ ){
              if ( isHit(enemyA [i][0],enemyA [i][1],enemy.width, enemy.height,bulletX[j],bulletY[j],bullet.width,bullet.height)==true){
                if(bulletNumLimit[j] == true){
                  for (int s = 0;  s < 5; s++){
                    hitPosition [s][0] = enemyA [i][0];
                    hitPosition [s][1] = enemyA [i][1];
                  }
                  scoreChange(20);
                  enemyA [i][1] = -1000;
                  enemyY = floor( random(30,240));
                  bulletNumLimit[j] = false;
                  flameNum = 0; 
                }
              }
            }       
            //fighter get hit
            if ( isHit(enemyA [i][0],enemyA [i][1],enemy.width, enemy.height,fighterX,fighterY,fighter.width,fighter.height)==true){ 
              for ( int j = 0;  j < 5; j++ ){
                hitPosition [j][0] = enemyA [i][0];
                hitPosition [j][1] = enemyA [i][1];
              }
              hpX -= 40;
              enemyA [i][1] = -1000;
              enemyY = floor(random(50,420));
              flameNum = 0; 
            } else if ( hpX <= 0 ) {
              gameState = GAME_OVER;
              hpX = 40;
              fighterX = 575 ;
              fighterY = 480/2 ;
            } else {
              enemyA [i][0] += enemySpeed;
              enemyA [i][0] %= 1920;
            }     
          }
          
          //go to C
          if(enemyA [4][0] > 640 + 300 ){
            enemyY = floor(random(80,400));
            spacingX = 0;       
            for (int i = 0; i < 5; i++ ){
              enemyC [i][1] = enemyY; 
              enemyC [i][0] = spacingX;
              spacingX -= 80;
            } 
            enemyState = C;            
          }  
        break ;
      }

     //hp
      fill (#FF0000);
      rect (35, 15, hpX, 30);
      image(hp, 28, 15);   
      //get treasure
      if(fighterX >= treasureX - fighter.width && fighterX <= treasureX + treasure.width
         && fighterY >= treasureY - fighter.height && fighterY <= treasureY + treasure.height){    
              hpX += 20;
              treasureX = floor(random(50,600));         
              treasureY = floor(random(50,420));
      }
      if(hpX >= 200){
        hpX = 200;
      }
    break ;  
    
    
    case GAME_OVER :
      image(end1, 0, 0);     
      if ( mouseX > 200 && mouseX < 470 
        && mouseY > 300 && mouseY < 350){
            image(end2, 0, 0);
            if(mousePressed){
              treasureX = floor( random(50,600) );
              treasureY = floor( random(50,420) );      
              enemyState = 0;      
              spacingX = 0; 
              b=0;
              for (int i = 0; i < 5; i++ ){
                hitPosition [i][0] = 1000;
                hitPosition [i][1] = 1000;
                bulletNumLimit[i] = false;
                enemyC [i][0] = spacingX;
                enemyC [i][1] = enemyY; 
                spacingX -= 80;
                
              }
              gameState = GAME_RUN;
            }
      }
    break ;
  }  
}


void keyPressed (){
  if (key == CODED) {
    switch ( keyCode ) {
      case UP :
        upPressed = true ;
        break ;
      case DOWN :
        downPressed = true ;
        break ;
      case LEFT :
        leftPressed = true ;
        break ;
      case RIGHT :
        rightPressed = true ;
        break ;
    }
  }
}
  
  
void keyReleased () {
  if (key == CODED) {
    switch ( keyCode ) {
      case UP : 
        upPressed = false ;
        break ;
      case DOWN :
        downPressed = false ;
        break ;
      case LEFT :
        leftPressed = false ;
        break ;
      case RIGHT :
        rightPressed = false ;
        break ;
    }  
  }  
  //shoot bullet
  if ( keyCode == ' '){
    if (gameState == GAME_RUN){
      if (bulletNumLimit[bulletNum] == false){
        bulletNumLimit[bulletNum] = true;
        bulletX[bulletNum] = fighterX - 10;
        bulletY[bulletNum] = fighterY + fighter.height/2;
        bulletNum ++;
      }   
      if ( bulletNum > 4 ) {
        bulletNum = 0;
      }
    }
  }
}

void scoreChange(int Value){
   b+=Value;    
}

boolean isHit(float ax,float ay,int aw, int ah,float bx,float by,int bw,int bh){
  if(bx>=ax-bw&& bx<=ax+aw&& by>=ay-bh&& by<=ay+ah){
    return true;
  }else{return false;}
}
      
