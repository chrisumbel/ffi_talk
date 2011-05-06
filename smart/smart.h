#ifndef __SMART_H__
#define __SMART_H__

#define NR_ATTRIBUTES	30

#include <linux/types.h>

#define SMART_PASSED 0
#define SMART_FAILED -1
#define SMART_NO_DEVICE -2
#define SMART_NOT_SUPPORTED -3
#define SMART_QUERY_FAILED -4

typedef struct threshold_s {
	__u8		id;
	__u8		data;
	__u8		reserved[10];
} __attribute__ ((packed)) threshold_t;
	
typedef struct thresholds_s {
	__u16		revision;
	threshold_t	thresholds[NR_ATTRIBUTES];
	__u8		reserved[18];
	__u8		vendor[131];
	__u8		checksum;
} __attribute__ ((packed)) threshold_table_t;

typedef struct value_s {
	__u8		id;
	__u16		status;
	__u8		data;
	__u8		vendor[8];
} __attribute__ ((packed)) value_t;

typedef struct values_s {
	__u16		revision;
	value_t		values[NR_ATTRIBUTES];
	__u8		offline_status;
	__u8		vendor1;
	__u16		offline_timeout;
	__u8		vendor2;
	__u8		offline_capability;
	__u16		smart_capability;
	__u8		reserved[16];
	__u8		vendor[125];
	__u8		checksum;
} __attribute__ ((packed)) value_table_t;

typedef int smart_result_t;


int smart_open(char * device_name);
int smart_close(int fd);
int smart_get_values(int fd, value_table_t *values);
int smart_get_thresholds(int fd, threshold_table_t *thresholds);

#endif
