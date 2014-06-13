/*
dfdsf
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

#include "pong.h"


//#import <Foundation/Foundation.h>

#define WINDOW_TITLE "Pong"
#define WINDOW_WIDTH 640
#define WINDOW_HEIGHT 920
#define FPS 70
#define INITIAL_SPEED 1.1
#define REQUIRED_HITS 5

#define SCORE_PER_HIT 10

int running = 1;

int main(int  argc, char** argv){

  // create window
  SDL_Window *window;
  SDL_Renderer *renderer;

  if(SDL_Init(SDL_INIT_VIDEO) >= 0){
    window = SDL_CreateWindow(NULL, 0,
			      0, WINDOW_WIDTH, WINDOW_HEIGHT,
			      SDL_WINDOW_OPENGL);
  }

  if(window != 0){
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED |
				  SDL_RENDERER_PRESENTVSYNC);
  }
  /* Create a player */
  Player player;
  player.x = WINDOW_WIDTH / 2 - PLATE_WIDTH;
  player.y = WINDOW_HEIGHT - PLATE_HEIGHT;
  player.hits = 0;
  player.score = 0;

  
  

  /* Create the enemy! */
  Player enemy;
  enemy.x = WINDOW_WIDTH / 2 - PLATE_WIDTH;
  enemy.y = 0;
  enemy.hits = 0;
  
  Ball ball;
  ball.x = WINDOW_WIDTH / 2.0 - BALL_SIZE / 2.0;
  ball.y = WINDOW_HEIGHT / 2.0 - BALL_SIZE / 2.0;
  ball.dx = -INITIAL_SPEED, ball.dy = INITIAL_SPEED;
  ball.size = BALL_SIZE;
  
  while(running){
    handleEvents(&player);
    update(&player, &enemy, &ball);
    render(renderer, &player, &enemy, &ball);
  }

  printf("Game Over\nYour Score: %d\n", player.score * SCORE_PER_HIT);
  return 0;
  clean(window, renderer);
}

void handleEvents(Player *player){
  SDL_Event event;
  if(SDL_PollEvent(&event)){
    switch(event.type){
    case SDL_QUIT:
      running = 0;
      break;   
    case SDL_KEYDOWN:
      switch(event.key.keysym.sym){
      case SDLK_ESCAPE:
	running = 0;
	break;
      case SDLK_q:
	running = 0;
	break;
      }
      break;
    }
  }

  const Uint8 *state = SDL_GetKeyboardState(NULL);
  if(state[SDL_SCANCODE_RIGHT]){
    if((player->x + PLATE_WIDTH + 2) <= WINDOW_WIDTH){
      player->x += 3;
    }
  }

  if(state[SDL_SCANCODE_LEFT]){
    if((player->x - 3) >= 0){
      player->x -= 3;
    }
  }
}

void update(Player *player, Player *enemy,  Ball *ball){
  if(ball->x < 0 || ball->x > WINDOW_WIDTH - ball->size){
    ball->dx = -ball->dx;
  }

  /* Enemy intelligence */
  think(enemy, ball->x, WINDOW_WIDTH);
  
  if(ball->y < 0 ){
    /* Check if the enemy caught the ball */
    if((ball->x >= enemy->x) && ((ball->x + ball->size) <= (enemy->x + PLATE_WIDTH))){
      ball->dy = -(ball->dy);
      (enemy->hits)++;
    }else{
      /* Enemy missed the ball! */
      player->score++;
      int delay = 90 * abs(ball->dx) + 700;
      SDL_Delay(delay);
      ball->x = WINDOW_WIDTH / 2.0 - BALL_SIZE / 2.0;
      ball->y = WINDOW_HEIGHT - 22.0 - BALL_SIZE / 2.0;

    }
  }
  
  if(ball->y > WINDOW_HEIGHT - ball->size){
    /* Check if the player caught the ball */
    if((ball->x >= player->x) && ((ball->x + ball->size) <= (player->x + PLATE_WIDTH))){
      ball->dy = -(ball->dy);
      (player->hits)++;
      /* Increase ball speed every fifth hit */
      if((player->hits % REQUIRED_HITS) == 0 ){
	speedUp(ball);
      }
    }else{
      /* Player missed the ball! */
      if(player->score > 0){
	player->score--;
      }
      int delay = 90 * abs(ball->dx) + 700;

      SDL_Delay(delay);
      ball->x = WINDOW_WIDTH / 2.0 - BALL_SIZE / 2.0;
      ball->y = WINDOW_HEIGHT / 5.0 - BALL_SIZE / 2.0;
    }
  }
  ball->x += ball->dx;
  ball->y += ball->dy;
}

void render(SDL_Renderer *renderer, Player *player, Player *enemy, Ball *ball){
  // show blue background
  SDL_SetRenderDrawColor(renderer, 0x00, 0x00, 0xFF, 0xFF);
  SDL_RenderClear(renderer);
  
  SDL_SetRenderDrawColor(renderer, 255, 255, 255, 0xFF);
  
  SDL_Rect playerRect = {player->x, player->y, PLATE_WIDTH , PLATE_HEIGHT };
  SDL_Rect enemyRect = {enemy->x, enemy->y, PLATE_WIDTH , PLATE_HEIGHT };
  SDL_Rect ballRect = {ball->x, ball->y, ball->size, ball->size};

  SDL_RenderFillRect(renderer, &playerRect);
  SDL_RenderFillRect(renderer, &enemyRect);
  SDL_RenderFillRect(renderer, &ballRect);
  
  SDL_RenderPresent(renderer);
}

void clean(SDL_Window *window, SDL_Renderer *renderer){
  SDL_DestroyWindow(window);
  SDL_DestroyRenderer(renderer);
  SDL_Quit();
}
