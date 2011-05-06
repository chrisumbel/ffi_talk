
#include <stdio.h>

unsigned short inet_checksum(unsigned char *buff, int len) {
  int i;
  unsigned long long sum = 0;
  unsigned short datum = 0;

  for(i = 0; i < len; i += 2) {
    datum = *buff++ << 8;

    if(i <= len)
      datum |= *buff++;

    sum += datum;
  }

  while (sum >> 16)
    sum = (sum & 0xffff) + (sum >> 16);

  sum = ~sum;
  return (unsigned short)sum;
}
