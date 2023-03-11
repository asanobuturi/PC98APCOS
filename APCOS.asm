[BITS 16]
[CPU 286]
	
 	JMP     SHORT entry
    DB      0x90
    DB      "HELLOAPC"      ; ブートセクタの名前
    DW      512             ; 1セクタの大きさ
    DB      1               ; クラスタの大きさ
    DW      1               ; FATがどこから始まるか
    DB      2               ; FATの個数
    DW      224             ; ルートディレクトリ領域の大きさ
    DW      2880            ; このドライブの大きさ
    DB      0xf0            ; メディアのタイプ
    DW      9               ; FAT領域の長さ
    DW      18              ; 1トラックにいくつのセクタがあるか
    DW      2               ; ヘッドの数
    DD      0               ; パーティションを使ってないのでここは必ず0
    DD      0               ; 総セクタ数<0x10000より0
    DB      0x00            ; フロッピーディスクでは0x00
    DB      0               ; WindowsNT予約領域
    DB      0x29            ; 下の3つの設定が存在することを示す。
    DD      0xffffffff      ; ボリュームシリアル番号
    DB      "APC        "   ; ディスクの名前（11バイト）
    DB      "FAT12   "      ; フォーマットの名前（8バイト）		


;/////////////////////////////
; プログラム本体
;/////////////////////////////
section .text
		
print:
		PUSH 	BP
		MOV 	BP,SP
		MOV		AX,[BP+4]
		MOV		ES,AX
		MOV		SI,[BP+6]
		MOV		BX,0
;文字列を1文字ずつテキストVRAMにセットするループ
putloop:
		MOV		AL,[CS:SI]	
		CMP		AL,0
		JE		end
		MOV		[ES:BX],AL	
		INC		SI			
		ADD		BX,2		
		JMP		putloop
end:
		MOV		SP,BP
		POP		BP
		ret

entry:
		MOV		AX,0		
		MOV		DS,AX
		MOV		ES,AX
		MOV		SS,AX
		
;-------------------------------------------------
;文字列表示
line1:
		PUSH	msg
		PUSH	0xa000
		call	print
		ADD		SP,8

line2:
		PUSH	msg2
		PUSH	0xa00a
		call 	print
		ADD		SP,8

		
;-------------------------------------------------	
;-------------------------------------------------
;終了
fin:
		HLT				
		JMP		fin		
TIMES 0xF0-$+$$ DB 0	
;-------------------------------------------------
;データセクション
section .data
msg:
		DB "THANK YOU FOR COMING TO APC"
		DB 0x0
msg2:
		DB "-Asano Physics Club 2022-"
		DB 0x0
;-------------------------------------------------
TIMES 0x310-$+$$ DB 0
