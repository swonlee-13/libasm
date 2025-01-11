#include <unistd.h>
#include "libasm.h"
#include "fcntl.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    //test1: ft_strcpy
    char * test1_1 = strdup("strdst");
    char * test2_1 = strdup("strdst");
    char * test1_2 = strdup("strsrc1");
    char * test2_2 = strdup("strsrc1");

    strcpy(test1_2, test1_1);
    ft_strcpy(test2_2, test2_1);

    printf("origin: %s\n", test1_1);
    printf("ft_strcpy: %s\n", test2_1);
    printf("\n\n");

    //test1: ft_strcmp
    char * test3_1 = "lorem ipsua";
    char * test3_2 = "lorem ipsum";
    printf("original : %d\nft_strcmp : %d\n", strcmp(test3_1, test3_2), ft_strcmp(test3_1, test3_2));


    // -----test3: ft_read-----  
    int fd = open("./test", O_RDONLY);
    if (fd < 0) {
        printf("Error opening file\n");
        return 1;
    }
    char *buf = calloc(100, sizeof(char));
    if (!buf) {
        printf("Memory allocation failed\n");
        close(fd);
        return 1;
    }
    
    ssize_t read_result = ft_read(fd, buf, 100);
    printf("read result: %zd\n", read_result);
    if (read_result < 0) {
        printf("read error occurred\n");
        free(buf);
        close(fd);
        return 1;
    }

    buf[read_result] = '\0'; 
    int buf_len = ft_strlen(buf);
    printf("BUFFER1: %s, length: %lu\n", buf, strlen(buf));
    
    
    char *buf2 = malloc(sizeof(char) * (buf_len + 1));
    ft_strcpy(buf2, buf);
    printf("BUFFER2: %s\n", buf2);


    char *buf3 = ft_strdup(buf);
    printf("BUFFER3: %s\n", buf3);

    free(buf);
    free(buf3);
    free(buf2);
    close(fd);
    return 0;
}
