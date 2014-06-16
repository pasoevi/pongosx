#include "multiplayer.h"
#include <time.h>
#include <math.h>

int say(int socket, char *s){
  int result = send(socket, s, strlen(s), 0);
  return result;
}

int read_in(int d, char *buf, int buflen) {
  bzero(buf, buflen);
  int n = read(d, buf, buflen);
  return n;
}



