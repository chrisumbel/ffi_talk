#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <linux/hdreg.h>
#include <linux/types.h>

#include "smart.h"

static int smart_exec_command(int fd, __u8 *args, void *values, size_t len) {
  if (ioctl(fd, HDIO_DRIVE_CMD, args)) {
    fprintf(stderr, "S.M.A.R.T. command failed\n");
    return -1;
  } else
    memcpy(values, args + 4, len);

  return 0;
}

int smart_open(char *device_path) {
  __u8 args[4] = {WIN_SMART, 0x00, SMART_ENABLE, 0x00};  
  int fd;

  if((fd = open (device_path, O_RDWR)) > 0) {
    if(smart_exec_command(fd, (__u8*)&args, NULL, 0) != 0) {
      fprintf(stderr, "unable to open S.M.A.R.T. device\n");
      return -2;
    }
  }

  return fd;
}

int smart_close(int fd) {
  return close(fd);
}

int smart_get_values(int fd, value_table_t *values) {
  __u8 args[4 + sizeof(value_table_t)] = {
    WIN_SMART, 0x00, SMART_READ_VALUES, 0x01, };
  return smart_exec_command(fd, (__u8*)&args, values, sizeof(value_table_t));
}

int smart_get_thresholds(int fd, threshold_table_t *thresholds) {
  __u8 args[4 + sizeof(threshold_table_t)] = {
    WIN_SMART, 0x00, SMART_READ_THRESHOLDS, 0x01, };
  return smart_exec_command(fd, (__u8*)&args, thresholds, sizeof(threshold_table_t));
}
