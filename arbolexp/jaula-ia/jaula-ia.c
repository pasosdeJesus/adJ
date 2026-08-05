#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <pwd.h>

int main() {

  // 1. Definir la ruta de la jaula
  const char *jail_path = "/var/www";
  const char *user_name = "vtamara"; // O el usuario que prefieras

  // 2. Unveil: Permitir acceso SOLO a la jaula
  if (unveil(jail_path, "rwcx") == -1) {
    perror("unveil");
    exit(1);
  }

  // 3. Chroot: Cambiar la raíz
  if (chroot(jail_path) == -1) {
    perror("chroot");
    exit(1);
  }

  // 4. Bloquear nuevas llamadas a unveil
  if (unveil(NULL, NULL) == -1) {
    perror("unveil lock");
    exit(1);
  }

  // 5. Bajar privilegios (CRÍTICO)
  // Al dejar de ser root, el 99% de las técnicas de escape fallan
  struct passwd *pw = getpwnam(user_name);
  if (pw == NULL) {
    fprintf(stderr, "Usuario %s no encontrado\n", user_name);
    exit(1);
  }
  if (setgid(pw->pw_gid) != 0 || setuid(pw->pw_uid) != 0) {
    perror("setuid/setgid");
    exit(1);
  }


  // 6. Pledge: El "Contrato de Desarrollo"
  // Estas promesas me permiten:
  // - stdio: Escribir en consola
  // - rpath/wpath/cpath: Leer/Escribir/Crear archivos (desarrollo)
  // - fattr: Cambiar permisos (necesario para git y compiladores)
  // - proc/exec: Lanzar procesos (necesario para make, cc, npm, tests)
  // - flock: Bloquear archivos (necesario para bases de datos y git)
  // - unix: Sockets locales
  // - inet/dns: Si necesitas que descargue paquetes (opcional)
  // NOTA: NO incluimos "chroot", lo que impide mi exploit anterior.
  if (pledge("stdio rpath wpath cpath fattr flock proc exec unix inet dns", NULL) == -1) {
    perror("pledge");
    exit(1);
  }

  if (chdir("/home/vtamara") == -1) {
    perror("chdir");
    exit(1);
  }

  printf("Jaula de desarrollo activa para el usuario %s.\n", user_name);
  setenv("HOME", "/home/vtamara", 1);
  setenv("ENV", "/home/vtamara/.zprofile", 1);
  setenv("DISPLAY", "127.0.0.1:1", 1);
  execl("/usr/local/bin/zsh", "-zsh", (char *)NULL);
}
