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

int listener_d;
void handle_shutdown(int sig){
    if(listener_d){
        close(listener_d);
    }
    printf("Closing down. \n");
    exit(0);
}

int catch_signal(int sig, void (*handler)(int)){
    struct sigaction action;
    action.sa_handler = handler;
    sigemptyset(&action.sa_mask);
    action.sa_flags = 0;
    return sigaction(sig, &action, NULL);
}

int open_listener_socket(){
    return socket(PF_INET, SOCK_STREAM, 0);
}

int bind_to_port(int listener, int port){
    struct sockaddr_in name;
    name.sin_family = PF_INET;
    name.sin_port = (in_port_t)htons(DEFAULT_PORT);
    name.sin_addr.s_addr = htonl(INADDR_ANY);
    
    int reuse;
    if(setsockopt(listener_d, SOL_SOCKET, SO_REUSEADDR, (char *) &reuse, sizeof(int)) == -1){
        perror("Can't set reuse option to the socket");
    }
    
    int c = bind(listener_d, (struct sockaddr*) &name, sizeof(name));
    return c;
}



