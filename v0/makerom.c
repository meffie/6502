
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define ROM_SIZE 0x8000  /* Size of ROM in bytes. */

char code[] = {
    0xa9, 0xff,        /* lda #$ff */
    0x8d, 0x02, 0x60,  /* sta $6002 */
    0xa9, 0x55,        /* lda #$55 */
    0x8d, 0x00, 0x60,  /* sta $6000 */
    0xa9, 0xaa,        /* lda #$aa */
    0x8d, 0x00, 0x60,  /* sta $6000 */
    0x4c, 0x05, 0x80   /* jmp $8005 */
};

int main(int argc, char *argv[])
{
    char *filename = "rom.bin";
    FILE *fp;
    char *rom;
    size_t bytes;
    int rc;

    /* Create image. */
    rom = malloc(ROM_SIZE);
    if (!rom) {
        fprintf(stderr, "memory");
        return 1;
    }
    memset(rom, 0xea, ROM_SIZE);  /* Pad image with NOP op codes. */
    memcpy(rom, code, sizeof(code));
    rom[0x7ffc] = 0x00; /* Reset vector, low. */
    rom[0x7ffd] = 0x80; /* Reset vector, high. */

    /* Write image to file. */
    fp = fopen(filename, "wb");
    if (!fp) {
        fprintf(stderr, "Failed to open file %s: errno=%d\n", filename, errno);
        rc = 1;
        goto done;
    }
    printf("Writing '%s'.\n", filename);
    bytes = fwrite(rom, sizeof(char), ROM_SIZE, fp);
    if (bytes != ROM_SIZE) {
        fprintf(stderr, "Failed to write image to '%s'.\n", filename);
        rc = 1;
        goto done;
    }
    rc = fclose(fp);

done:
    free(rom);
    return rc;
}
