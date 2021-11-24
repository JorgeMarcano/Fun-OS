os: boot.bin os.bin
	cat boot.bin os.bin > OS.img

boot.bin:
	../../fasm.x64 ../src/boot.asm
	mv ../src/boot.bin ./

os.bin:
	../../fasm.x64 ../src/os.asm
	mv ../src/os.bin ./

clean:
	rm *.bin
	rm *.img
