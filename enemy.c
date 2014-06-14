/*

  Copyright (C) 2014 Sergi Pasoev.

  This pragram is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or (at
  your option) any later version.

  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

  spasoev at gmail.com

*/
#include "player.h"
#include <stdio.h>

void think(Player *enemy, int ballX, int winWidth){
  if(ballX > (enemy->x + (PLATE_WIDTH / 2))){
    if((enemy->x + PLATE_WIDTH + 2) <= winWidth){
      enemy->x += 3;
    }
  }else{
    if(enemy->x > 0){
      enemy->x -= 3;
    }
  }
}

void player2(Player *enemy, char *move){

    float newX;
    
    sscanf(move, "%f", &newX);

    //printf("data: %s \n", move);

    enemy->x = newX;
}

