            dsk   ../bin/TOTALLY.SYSTEM#ff2000
            typ   $06
         
PlayerX     equ   $06
PlayerY     equ   $07
PlayrDiedFlg equ   $0d
MissleY     equ   $10
MissleXByte equ   $11
MON_CH      equ   $24        ;cursor horizontal displacement
MON_CV      equ   $25        ;cursor vertical displacement
TGTLO       equ   $26
TGTHI       equ   $27
MON_COLOR   equ   $30        ;lo-res graphics color
MON_INVFLAG equ   $32        ;text mask (255=normal, 127=flash, 63=inv)
MON_PROMPT  equ   $33        ;prompt character, used by GETLN
TMPSCRHI    equ   $43
TMPSCRMID   equ   $44
TMPSCRLO    equ   $45
RndTemp     equ   $9f
MissileWtCtr equ   $ba       ; Missile wait counter. # steps from $FE status to $00 status
JOY_Y       equ   $be
JOY_X       equ   $bf
colliderflag equ   $ce
WhichEntity equ   $cf
FuelCounter equ   $e5
CurFuelLevel equ   $e6
Lives       equ   $e7
SCORELO     equ   $f0
SCOREMID    equ   $f1
SCOREHI     equ   $f2
HISCORELO   equ   $f3
HISCOREMID  equ   $f4
HISCOREHI   equ   $f5

* Interface to digit drawing functions
XTMP        equ   $f8
YTMP        equ   $f9
GLYPH       equ   $fa
TMPHI       equ   $fb

NEntityKilled equ   $ff
NEntityScored equ   $6f

* ProDOS entry point

MLI         equ   $bf00

* Soft switches

KBD         equ   $c000      ;R last key pressed + 128
KBDSTRB     equ   $c010      ;RW keyboard strobe
SPKR        equ   $c030      ;RW toggle speaker
TXTCLR      equ   $c050      ;RW display graphics
MIXCLR      equ   $c052      ;RW display full screen
TXTPAGE1    equ   $c054      ;RW display page 1
HIRES       equ   $c057      ;RW display hi-res graphics
BUTN0       equ   $c061      ;R switch input 0 / open-apple
BUTN1       equ   $c062      ;R switch input 1 / closed-apple
PADDL0      equ   $C064      ; Read paddle 0 soft switch
PADDL1      equ   $C065      ; Read paddle 1 soft switch
PTRIG       equ   $C070      ; Trigger (start) paddle measurement

* ROM routines

REBOOT      equ   $e000
PADDLE_READ equ   $fb1e      ;read paddle specified by X-reg, return in Y-reg

         org   $2000      ; start of all semi-well behaved .SYSTEM files

* This is the HGR1 screen location ($2000)
* Place the initial screen here with a jmp
* at $2000 to $4000 where the jmp is overwritten
* with zeros to make it pristine.

         put   INITIAL.SCREEN.S

         lda   TXTCLR     ; This starts just after initial screen restore ~$4000
         lda   HIRES
         lda   MIXCLR
         lda   TXTPAGE1
         jsr   RandomInit
         lda   #$00
         sta   HISCORELO
         sta   HISCOREMID
         sta   HISCOREHI
         lda   KBDSTRB
         jsr   InitPrefix ;Init the I/O system
         jsr   ReadHS     ;Read high scores/check disk
         jsr   DrawVersion
         jmp   StartTotally

DrawVersion
         lda   #0
         sta   0
         lda   #$c
         sta   XTMP
:loop    ldy   0
         lda   version,Y
         cmp   #$ff
         bne   :next
         rts
:next    sta   GLYPH
         lda   #129
         sta   YTMP
         jsr   DrawDigit
         inc   0
         inc   XTMP
         jmp   :loop

         put   VERSION.S

MAGIC    asc   "(C)1983BYR.FRANK"

PlayAGame
         lda   #$03
         sta   Lives     
         jsr   InitScoreAndLevels
         jsr   DrawLife1
         jsr   DrawLife2
         jsr   DrawLife3
PlayLevel
         jsr   InitFuel
         jsr   PlayPhase0
         lda   PlayrDiedFlg
         cmp   #$01
         beq   :PlayerDied
         jsr   PlayPhase1
         lda   PlayrDiedFlg
         cmp   #$01
         beq   :PlayerDied
         jmp   NextLevel

:PlayerDied
         dec   Lives      ;Died?
         lda   Lives
         cmp   #$01
         bne   :notone
         jsr   Die2       ;One life left
         jmp   PlayLevel

:notone  cmp   #$02
         bne   :nottwo
         jsr   Die3       ;Two lives left
         jmp   PlayLevel

:nottwo  jsr   Die1       ;No lives left
         jmp   EndOfGame

* update to the next level
* Note: there are 32 entities and 16 levels of difficulty

NextLevel
                          ; Set up the entity pointer (32 with "wrap")
         inc   CurrentLevel  
         lda   CurrentLevel
         and   #$1f       ; Entities wrap around at 32 levels
         clc
         adc   #>EntityImgTables
         sta   EntityFetch+2
                          ; Set up the "difficulty" (16 with clamp)
         lda   CurrentLevel
         cmp   #$10
         blt   :noclamp
         lda   #$0f       ; levelcap for scoring, entity counts, etc
:noclamp tax
         lda   EntityCountTable,x
         sta   NumEntities
         lda   ScoreTable,x
         sta   ScoreBump+1
         lda   EntityNTable,x
         sta   EntityCntChk+1
         jsr   DrawLvlEntity
         jmp   PlayLevel

Die1     jsr   ExplodeShip
         jmp   DrawLife1

Die2     jsr   ExplodeShip
         jmp   DrawLife2

Die3     jsr   ExplodeShip
         jmp   DrawLife3


* player (lives) ships: 255, [119, 140, 161]

LivesShipX =   255
LivesShipY =   110        ; 119
LivesDelta =   18         ; 21
LiveEntityY =  165
LiveEntityNX =  $24
LiveEntityNY =  179

DrawLife1
         lda   #LivesShipX
         sta   PlayerX
         lda   #LivesShipY
         sta   PlayerY
         jmp   DrawPlayerShip

DrawLife2
         lda   #LivesShipX
         sta   PlayerX
         lda   #LivesShipY+LivesDelta
         sta   PlayerY
         jmp   DrawPlayerShip

DrawLife3
         lda   #LivesShipX
         sta   PlayerX
         lda   #LivesShipY+LivesDelta+LivesDelta
         sta   PlayerY
         jmp   DrawPlayerShip

DrawLvlEntity
         ldy   #LiveEntityY
         lda   #LivesShipX
         jsr   DrawEntityRaw
         rts

DrawLvlCount
         sec   
         lda   EntityCntChk+1
         sbc   NEntityKilled
         ldx   #0         ; 10s digit
:loop    cmp   #10
         blt   :out
         inx
         sec
         sbc   #10
         jmp   :loop
:out     stx   GLYPH
         pha
         lda   #LiveEntityNX
         sta   XTMP
         lda   #LiveEntityNY
         sta   YTMP
         jsr   DrawDigit2
         pla
         sta   GLYPH
         lda   #LiveEntityNX+2
         sta   XTMP
         lda   #LiveEntityNY
         sta   YTMP
         jsr   DrawDigit2
         rts


* Fuel panel locations

FuelColumn = $21
FuelCtrMax = $30          ; number of game loops between single fuel decrements
FuelLvlMax = $72
FuelLvlMin = $af

InitFuel
         ldx   #$72       ; Scanline $73 to $b0 paint column $21 with $2A
         ldy   #FuelColumn
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         lda   #$7f         ; top with 1111 111  
         sta   (TGTLO),y
         inx
:next    lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         lda   #$6b          ; 1101 011  1248 124
         sta   (TGTLO),y
         jsr   DelayOneClick
         inx
         cpx   #$b0
         bne   :next
         lda   #FuelLvlMax
         sta   CurFuelLevel
         lda   #FuelCtrMax
         sta   FuelCounter
         rts

DelayOneClick
         stx   $00
:delay   dec   $00
         bne   :delay
         sta   SPKR
         rts

FuelDecrement
         dec   FuelCounter
         beq   FuelDrop
         rts

FuelDrop lda   #FuelCtrMax
         sta   FuelCounter
         ldy   #FuelColumn       ;Fuel bar column
         inc   CurFuelLevel
         ldx   CurFuelLevel
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         lda   #$63       ;Clear top of the fuel
         sta   (TGTLO),y
         cpx   #$af       ; 1100 011   1248 124
         bne   :notlast
         lda   #$01       ;Ran out of fuel
         sta   PlayrDiedFlg
:notlast rts


CurrentLevel dfb 0
MaxEntities =  16
NumEntities dfb 0         ; Could change per level??

InitEntityState
         lda   NumEntities ; Start the entities
         sta   WhichEntity
:nextentity
         jsr   RestartEntity
         jsr   Random     ; randomize the X position a bit
         and   #$1f       ; [0,31] left of the initial X position
         sta   TGTLO
         ldy   WhichEntity
         lda   EntityXTable,y
         sec
         sbc   TGTLO
         sta   EntityXTable,y
         dec   WhichEntity
         bne   :nextentity

         lda   #$00
         sta   MissleY
         sta   NEntityKilled
         sta   NEntityScored
         jsr   DrawEmptyPlayfield
         lda   #$20
         sta   PlayerX
         lda   #$50
         sta   PlayerY
         lda   #$00
         sta   $14
         jsr   DrawPlayerShip
         jsr   Beep
         rts

InitScoreAndLevels
         lda   #>EntityImgTables
         sta   EntityFetch+2
         ldx   #$00
         lda   EntityCountTable,x
         sta   NumEntities
         lda   ScoreTable,x
         sta   ScoreBump+1
         lda   EntityNTable,x
         sta   EntityCntChk+1
         stx   CurrentLevel
         stx   SCORELO    ;Reset score to 000000
         stx   SCOREMID
         stx   SCOREHI
         lda   #$00
         jsr   IncDrawScore
         jsr   DrawLvlEntity
         jsr   DrawLvlCount
         rts

Beep     ldx   #$06
         stx   $01
:loop    ldy   #$ff
         sty   $00
:click   lda   SPKR
         ldx   $00
:delay   dex
         bne   :delay
         dec   $00
         dey
         cpy   #$60
         bne   :click
         dec   $01
         bne   :loop
         rts

PlayPhase0
         jsr   InitEntityState
         jsr   DrawLvlCount
UpdatePhase0Loop
         jsr   PauseCheck
         jsr   ReadDirJoy
         jsr   UpdateMissileState
         jsr   UpdateEntities
         lda   PlayrDiedFlg
         cmp   #$00
         bne   :deadplayer
         lda   NEntityKilled
EntityCntChk         
         cmp   #$20       ;32 entities -> next level (from EntityNTable)
         beq   :nextlevel
         jmp   :continue

:deadplayer
         rts

:nextlevel
         rts

:continue
         jsr   FuelDecrement
         lda   PlayrDiedFlg
         cmp   #$00
         beq   :nohit2
         rts

:nohit2  lda   NEntityKilled ;Need to figure out $FF and $6F usage
         cmp   NEntityScored
         bne   ScoreDeadEnity
         jmp   UpdatePhase0Loop

ScoreDeadEnity
         sta   NEntityScored
ScoreBump
         lda   #$00       ;Self modifying increment, changes with level
         jsr   IncDrawScore
         jmp   UpdatePhase0Loop

         put   SCANLINE_TBL.S

DrawDigit
         lda   GLYPH      ;$fa=digit, $f8=column, $f9=scanline
         asl   A
         asl   A
         asl   A
         tax
         lda   #$08       ;8 lines
         sta   TMPHI
:nextline
         ldy   YTMP
         lda   ScanlineTblLO,y
         sta   $fc
         lda   ScanlineTblHI,y
         sta   $fd
         ldy   XTMP
         lda   DigitImgTable,x
         ora   #$80       ; set high order bit (change color vs DrawDigit2)
         sta   ($fc),y
         inx
         inc   YTMP
         dec   TMPHI
         bne   :nextline
         rts

IncDrawScore
         sta   :Increment+1 ;Draw 6 digits of highscore $F0,$F1,$F2 -> 6 digits
         sed
         lda   SCORELO
         clc
:Increment
         adc   #$15
         sta   SCORELO
         lda   SCOREMID
         adc   #$00
         sta   SCOREMID
         lda   SCOREHI
         adc   #$00
         sta   SCOREHI
         cld
         clc
         nop
         nop
         nop
         nop
         lda   #$21
         sta   XTMP
         lda   #$4d
         sta   YTMP
         lda   SCORELO
         and   #$0f
         sta   GLYPH
         jsr   DrawDigit
         lda   #$21
         sta   XTMP
         lda   #$3f
         sta   YTMP
         lda   SCORELO
         lsr   A
         lsr   A
         lsr   A
         lsr   A
         sta   GLYPH
         jsr   DrawDigit
         lda   #$21
         sta   XTMP
         lda   #$31
         sta   YTMP
         lda   SCOREMID
         and   #$0f
         sta   GLYPH
         jsr   DrawDigit
         lda   #$21
         sta   XTMP
         lda   #$23
         sta   YTMP
         lda   SCOREMID
         lsr   A
         lsr   A
         lsr   A
         lsr   A
         sta   GLYPH
         jsr   DrawDigit
         lda   #$21
         sta   XTMP
         lda   #$15
         sta   YTMP
         lda   SCOREHI
         and   #$0f
         sta   GLYPH
         jsr   DrawDigit
         lda   #$21
         sta   XTMP
         lda   #$07
         sta   YTMP
         lda   SCOREHI
         lsr   A
         lsr   A
         lsr   A
         lsr   A
         sta   GLYPH
         jsr   DrawDigit
         rts

ReadDirJoy
         jsr   JoystickRead 
         lda   JOY_Y
         cmp   #$00
         beq   :ydown
         cmp   #$02
         beq   :yup
         lda   JOY_X      ;ymiddle
         cmp   #$00
         bne   :notxleft
         ldy   #$07       ;xleft,ymiddle
         jmp   KeyMatch

:notxleft
         cmp   #$02
         bne   :xmiddle
         ldy   #$03       ;xright,ymiddle
         jmp   KeyMatch

:xmiddle ldy   #$00       ;xmiddle,ymiddle
         jmp   KeyMatch

:ydown   lda   JOY_X      ;If Y is down, look at X
         cmp   #$00
         bne   :notxleft1
         ldy   #$08       ;xleft,ydown
         jmp   KeyMatch

:notxleft1
         cmp   #$02
         bne   :notxright
         ldy   #$02       ;xright,ydown
         jmp   KeyMatch

:notxright
         ldy   #$01       ;xmiddle,ydown
         jmp   KeyMatch

:yup     lda   JOY_X      ;If Y is up, look at X
         cmp   #$00
         bne   :notxleft2
         ldy   #$06       ;xleft,yup
         jmp   KeyMatch

:notxleft2
         cmp   #$02
         bne   :notxright1
         ldy   #$04       ;xright,yup
         jmp   KeyMatch

:notxright1
         ldy   #$05       ;xmiddle,yup
         jmp   KeyMatch

DrawChar lda   GLYPH      ;Draw a one byte wide img 8 lines tall
         asl   A          ;$fa=[0,25] = [A,Z], $f8=column, $f9=scanline
         asl   A
         asl   A
         tax
         lda   #$08
         sta   TMPHI      ;8 lines
:nextline
         ldy   YTMP
         lda   ScanlineTblLO,y
         sta   $fc
         lda   ScanlineTblHI,y
         sta   $fd
         ldy   XTMP
         lda   ChrImgTbl,x ;ImageBufferX
         sta   ($fc),y
         inx              ;Next byte
         inc   YTMP       ;Next scanline
         dec   TMPHI
         bne   :nextline
         rts

* Table of ASCII letters (A-Z) used for high score initials

ChrImgTbl
CharA    dfb   $14
         asc   'EEUEEE'
         dfb   $00
         dfb   $15
         dfb   $45
         dfb   $45
         dfb   $15
         dfb   $45
         dfb   $45
         dfb   $15
         dfb   $00
         dfb   $14
         dfb   $45
         dfb   $05
         dfb   $05
         dfb   $05
         dfb   $45
         dfb   $14
         dfb   $00
         dfb   $15
         dfb   $45
         dfb   $45
         dfb   $45
         dfb   $45
         dfb   $45
         dfb   $15
         dfb   $00
         dfb   $55
         dfb   $05
         dfb   $05
         dfb   $15
         dfb   $05
         dfb   $05
         dfb   $55
         dfb   $00
         dfb   $55
         dfb   $05
         dfb   $05
         dfb   $15
         dfb   $05
         dfb   $05
         dfb   $05
         dfb   $00
         dfb   $14
         dfb   $41
         dfb   $01
         dfb   $01
         dfb   $51
         dfb   $41
         dfb   $14
         dfb   $00
         dfb   $45
         dfb   $45
         dfb   $45
         dfb   $55
         dfb   $45
         dfb   $45
         dfb   $45
         dfb   $00
         dfb   $55
         ds    5,$14
         dfb   $55
         dfb   $00
         asc   'PPPPPQ'
         dfb   $14
         dfb   $00
         dfb   $45
         dfb   $15
         dfb   $05
         dfb   $05
         dfb   $05
         dfb   $15
         dfb   $45
         dfb   $00
         ds    6,$05
         dfb   $55
         dfb   $00
         asc   'AUUUAAA'
         dfb   $00
         asc   'AEEAQQA'
         dfb   $00
         dfb   $14
         asc   'EEEEE'
         dfb   $14
         dfb   $00
         dfb   $15
         dfb   $45
         dfb   $45
         dfb   $15
         dfb   $05
         dfb   $05
         dfb   $05
         dfb   $00
         dfb   $14
         asc   'AAAAQ'
         dfb   $14
         dfb   $00
         dfb   $15
         dfb   $41
         dfb   $41
         dfb   $15
         dfb   $05
         dfb   $11
         dfb   $41
         dfb   $00
         dfb   $14
         dfb   $45
         dfb   $05
         dfb   $14
         dfb   $50
         dfb   $51
         dfb   $14
         dfb   $00
         dfb   $55
         ds    6,$14
         dfb   $00
         asc   'AAAAAA'
         dfb   $14
         dfb   $00
         asc   'EEEEED'
         dfb   $10
         dfb   $00
         asc   'AAAAUUA'
         dfb   $00
         dfb   $45
         dfb   $45
         dfb   $14
         dfb   $14
         dfb   $14
         dfb   $45
         dfb   $45
         dfb   $00
         dfb   $41
         dfb   $41
         dfb   $41
         dfb   $14
         dfb   $14
         dfb   $14
         dfb   $14
         dfb   $00
CharZ    dfb   $55
         dfb   $00
         dfb   $10
         dfb   $00
         dfb   $04
         dfb   $00
         dfb   $55
         dfb   $00
         asc   'UUUUUUU'
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $7f
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $18
         dfb   $10
         dfb   $00
         dfb   $08
         dfb   $00
         dfb   $20
         dfb   $a5
         dfb   $18
         dfb   $a2
         dfb   $08
         dfb   $20
         dfb   $94
         dfb   $18
         dfb   $a9
         dfb   $ff
         dfb   $85

Draw_HiScore_Img
         lda   ImgWidthBytes ;Number of bytes
         sta   $fc
         lda   ImgLengthLine ;Number if scanlines
         sta   $fd
         ldx   #$00
:nextline
         ldy   YTMP
         lda   ScanlineTblLO,y
         sta   GLYPH
         lda   ScanlineTblHI,y
         sta   TMPHI
         lda   $fc        ;Width in bytes
         sta   $fe
         ldy   XTMP       ;Out X column start
:nextbyte
         lda   ImageBytes,x
         sta   (GLYPH),y
         inx
         iny
         dec   $fe
         bne   :nextbyte
         inc   YTMP
         dec   $fd
         bne   :nextline
         rts

ImgWidthBytes
         dfb   $11        ;Image width in bytes
ImgLengthLine
         dfb   $0b        ;Image length in lines
ImageBytes
         ds    18         ;Imagae for 'HISCORE"
         dfb   $05
         dfb   $02
         dfb   $55
         dfb   $02
         dfb   $54
         dfb   $00
         dfb   $54
         dfb   $00
         dfb   $54
         dfb   $00
         dfb   $55
         dfb   $00
         dfb   $55
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $14
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $14
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $14
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $55
         dfb   $02
         dfb   $14
         dfb   $00
         dfb   $54
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $55
         dfb   $00
         dfb   $55
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $14
         dfb   $00
         dfb   $40
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $14
         dfb   $00
         dfb   $40
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $15
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $14
         dfb   $00
         dfb   $41
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $45
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $55
         dfb   $02
         dfb   $54
         dfb   $00
         dfb   $54
         dfb   $00
         dfb   $54
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $55
         dfb   $02
         dfb   $05
         ds    18
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $04
         dfb   $b1
         dfb   $28
         asc   "I ps"
         dfb   $20
         dfb   $42
         dfb   $fc
         dfb   $4c
         dfb   $81
         dfb   $13
         dfb   $00

ExplodeShip
         lda   #$70
         sta   $00
Pitch    ldy   #$10
:click0  lda   SPKR
         ldx   $00
:delay0  dex
         bne   :delay0
         dey
         bne   :click0
         inc   $00
         lda   $00
         cmp   #$c0
         bne   Pitch
         lda   #$01
         jsr   DrawExpodeImage
         ldy   #$ff
:click1  lda   SPKR
         ldx   #$d0
:delay1  dex
         bne   :delay1
         dey
         bne   :click1
         lda   #$02
         jsr   DrawExpodeImage
         ldy   #$00
:click2  lda   SPKR
         ldx   #$ff
:delay2  dex
         bne   :delay2
         dey
         bne   :click2
         lda   #$00
         jmp   DrawExpodeImage

DrawExpodeImage
         asl   A          ;Item can be 0,1,2
         asl   A          ;Multiply by 32
         asl   A
         asl   A
         asl   A
         sta   FetchExpImgByte+1 ;Image table is at $1B00 + shape*$20
         lda   PlayerX
         jsr   DivideBy7
         stx   $01
         ldx   PlayerY
         stx   $02
         ldx   #$09       ;Nine scanlines
         stx   $03
         ldx   $02
nextscanline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         stx   $02
         ldx   #$03       ;3 bytes/scanline
         stx   $04
         ldx   $02
         ldy   $01
FetchExpImgByte
         lda   ExplodeImage0      ;Self modifying lower order byte
         sta   (TGTLO),y
         iny
         inc   FetchExpImgByte+1
         dec   $04
         bne   FetchExpImgByte
         inx
         dec   $03
         bne   nextscanline
         rts

* page align the 3 explosion images

         ds    \
ExplodeImage0
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $44
         dfb   $4c
         dfb   $29
         dfb   $2a
         dfb   $55
         dfb   $2a
         dfb   $22
         dfb   $55
         dfb   $2a
         dfb   $24
         dfb   $4d
         dfb   $11
         dfb   $28
         dfb   $55
         dfb   $12
         dfb   $2a
         dfb   $55
         dfb   $12
         dfb   $44
         dfb   $54
         dfb   $12
         dfb   $00
         dfb   $00
         dfb   $00
         dfb   $a9
         dfb   $8d
         dfb   $99
         dfb   $00
         dfb   $02
ExplodeImage1
         dfb   $20
         dfb   $d7
         dfb   $19
         dfb   $18
         dfb   $60
         dfb   $a4
         dfb   $24
         dfb   $b1
         dfb   $28
         dfb   $20
         dfb   $1b
         dfb   $fd
         dfb   $a4
         dfb   $65
         dfb   $60
         dfb   $19
         dfb   $70
         dfb   $00
         dfb   $29
         dfb   $32
         dfb   $18
         dfb   $10
         dfb   $00
         dfb   $28
         dfb   $3a
         dfb   $b0
         dfb   $59
         dfb   $f8
         dfb   $07
         dfb   $fc
         dfb   $6c
         dfb   $05
ExplodeImage2
         dfb   $05
         dfb   $52
         dfb   $4c
         dfb   $fa
         dfb   $07
         dfb   $f8
         dfb   $00
         dfb   $ad
         dfb   $00
         dfb   $08
         dfb   $f0
         dfb   $02
         dfb   $85
         dfb   $61
         dfb   $4c
         dfb   $42
         dfb   $13
         dfb   $0e
         dfb   $13
         dfb   $1d
         dfb   $ad
         dfb   $00
         dfb   $c0
         dfb   $10
         dfb   $14
         dfb   $c9
         dfb   $93
         dfb   $f0
         dfb   $10
         dfb   $2c
         dfb   $10
         dfb   $c0

ReadDirKbd
         jsr   JoystickTiming ; fake timing else keyboard version is too fast
         lda   KBD
         sta   $15
         ldy   #$00
:nextkey lda   KeyStrokeTable,y
         cmp   $15
         beq   KeyMatch
         iny
         cpy   #$09
         bne   :nextkey
         jmp   nonewkey

KeyMatch sty   $14        ;Store key direction
nonewkey lda   PlayerX
         sta   $12
         lda   PlayerY
         sta   $13
         lda   $14
         asl   A
         tay
         lda   $12
         clc
         adc   DXYtable,y
         sta   $12
         iny
         lda   $13
         clc
         adc   DXYtable,y
         sta   $13
         jsr   DrawPlayerShip ;Erase old ship
         lda   $12
         sta   PlayerX
         lda   $13
         sta   PlayerY
         jsr   DrawPlayerShip ;Draw new ship
         rts

* 6 5 4       Z
* 7 0 3   <-  /  ->
* 8 1 2       A
KeyStrokeTable
         dfb   $af        ;8 possible keys: /
         dfb   $c1        ;A
         dfb   $00
         dfb   $95        ;Right Arrow
         dfb   $00
         dfb   $da        ;Z
         dfb   $00
         dfb   $88        ;Left arrow
         dfb   $00
DXYtable dfb   $00        ;/ -> 0,0
         dfb   $00
         dfb   $00        ;A -> 0,-1
         dfb   $ff
         dfb   $01
         dfb   $ff
         dfb   $01        ;> -> 1,0
         dfb   $00
         dfb   $01
         dfb   $01
         dfb   $00        ;Z -> 0,1
         dfb   $01
         dfb   $ff
         dfb   $01
         dfb   $ff        ;< -> -1,0
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $4c

ReadBtnState
         lda   MissleY    ;Could be missile check/handler
         cmp   #$00
         bne   missileinflight
GetInputBtn
         jsr   ReadJoystickBtn ;This can be either LDA $C000 or JSR ReadJoyStickbtn
         cmp   #$a0
         beq   :buttonpress
         rts

:buttonpress
         ldx   PlayerY
         inx
         inx
         inx
         inx
         stx   MissleY    ;Y+4?
         sta   KBDSTRB
         lda   PlayerX    ;X?
         jsr   DivideBy7  ;Calc X pos in bytes (X)
         inx
         inx
         inx
         stx   MissleXByte ;X byte location + 2
         jmp   movemissile

missileinflight
         lda   MissleY
         pha
         jsr   drawmissle
         pla
         sta   MissleY
         jmp   movemissile

drawmissle
         ldy   MissleY
         lda   ScanlineTblHI,y
         sta   TGTHI
         lda   ScanlineTblLO,y
         sta   TGTLO
         ldy   MissleXByte
         lda   #$ff
         nop
         jsr   XorMissle
         cmp   #$00
         bne   :notstop
         lda   #$00       ;HitTheStrip (missle was effectively erased)
         sta   MissleY
:notstop rts

movemissile
         inc   MissleXByte
         lda   MissleXByte
         cmp   #$1e
         bne   :notatrightside
         lda   #$00       ;Stop missle (Ypos -> 0)
         sta   MissleY
         rts

:notatrightside
         jmp   drawmissle

         dfb   $1f
         dfb   $bd

XorMissle
         eor   (TGTLO),y
         sta   (TGTLO),y
         sta   SPKR
         rts

HandleMissileWaitState
         dec   MissileWtCtr
         bne   :notyet
         lda   #$00
         sta   MissleY    ;Missile ready to be fired
:notyet  rts

SetMissleWaitState
         lda   #$04
         sta   MissileWtCtr
         lda   #$fe       ;Flag move to missile wait state
         sta   MissleY
         rts

         dfb   $45
         dfb   $a6
         dfb   $46
         dfb   $a4
         dfb   $47
         dfb   $28

* MissleY is the missle state
* $00 = ready to be fired
* $FF = missile stopped, start $BA counter @ 4 -> $FE
* $FE = wait for $BA counter to zero -> $00
UpdateMissileState
         lda   MissleY
         cmp   #$ff       ;Missile stopped
         beq   SetMissleWaitState
         cmp   #$fe
         beq   HandleMissileWaitState
         jmp   ReadBtnState

         dfb   $81
         dfb   $3e
         dfb   $9c

ReadJoystickBtn
         lda   BUTN0      ;Convert joytick button into space key
         and   #$80
         cmp   #$80
         beq   :retspace
         lda   #$00
         rts

:retspace
         lda   #$a0
         rts

         dfb   $ca

DrawPlayerShip
         lda   PlayerX
         jsr   DivideBy7  ;Convert Xpos into byte(X) and bits(Y)
         tya              ;Pick the image based on shift (0-6)*32 (32bytes/image?)
         asl   A
         asl   A
         asl   A
         asl   A
         asl   A
         sta   FetchPlrByte+1 ;Low byte of image byte fetch
         ldy   PlayerY
         sty   $0e        ;Y output scanline
         stx   $0c        ;X Byte start output
         ldx   #$00
         stx   PlayrDiedFlg
         lda   #$09       ;9 scanlines
         sta   $0a
:nextscanline
         jsr   DrawPlayerLine
         inc   $0e        ;Next scanline
         dec   $0a
         lda   $0a
         cmp   #$00
         bne   :nextscanline
         rts

DrawPlayerLine
         lda   #$03       ;3 bytes
         sta   $0b
         stx   $09        ;Temp score offset to image
         ldx   $0e        ;Scanline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldx   $09        ;Recall the offset
         ldy   $0c        ;X byte start
FetchPlrByte
         lda   PlayerShipImage0,x ;Note: Self modifying code to pick ship via low order byte
         sta   $08        ;Temp store byte to be drawn
         eor   (TGTLO),y
         sta   (TGTLO),y
         and   $08        ;Check for collision
         cmp   $08
         beq   :nocollide
         lda   #$01       ;Record collision
         sta   PlayrDiedFlg
:nocollide
         inx              ;Next byte to fetch
         iny              ;Next output byte
         dec   $0b        ;pre-shifted shape has 3 bytes/scanline
         lda   $0b
         cmp   #$00
         bne   FetchPlrByte
         rts

DivideBy7_orig
         ldx   #$00       ;Divide A by 7
         tay
:loop    tya
         and   #$f8
         cmp   #$00
         bne   :incbyte
         tya
         cmp   #$07
         beq   :incbyte
         rts              ;return Y=remainder (0-7) X=int(A/7)

:incbyte inx
         dey
         dey
         dey
         dey
         dey
         dey
         dey
         jmp   :loop

* Player ship images start here  Must be page aligned
* Normally $1f00
         ds    \
         
PlayerShipImage0
         dfb   $7e
         dfb   $07
         dfb   $00
         dfb   $75
         dfb   $1f
         dfb   $00
         dfb   $75
         dfb   $07
         dfb   $00
         dfb   $5a
         dfb   $0c
         dfb   $00
         dfb   $1c
         dfb   $7d
         dfb   $00
         dfb   $5a
         dfb   $0c
         dfb   $00
         dfb   $75
         dfb   $07
         dfb   $00
         dfb   $75
         dfb   $1f
         dfb   $00
         dfb   $7e
         dfb   $07
         dfb   $00
         dfb   $00
         dfb   $07
         dfb   $00
         dfb   $10
         dfb   $01
PlayerShipImage1
         dfb   $7c
         dfb   $0f
         dfb   $00
         dfb   $6a
         dfb   $3f
         dfb   $00
         dfb   $6a
         dfb   $0f
         dfb   $00
         dfb   $34
         dfb   $19
         dfb   $00
         dfb   $38
         dfb   $7a
         dfb   $01
         dfb   $34
         dfb   $19
         dfb   $00
         dfb   $6a
         dfb   $0f
         dfb   $00
         dfb   $6a
         dfb   $3f
         dfb   $00
         dfb   $7c
         dfb   $0f
         dfb   $00
         dfb   $4c
         dfb   $91
         dfb   $1d
         dfb   $b5
         dfb   $01
PlayerShipImage2
         dfb   $78
         dfb   $1f
         dfb   $00
         dfb   $54
         dfb   $7f
         dfb   $00
         dfb   $54
         dfb   $1f
         dfb   $00
         dfb   $68
         dfb   $32
         dfb   $00
         dfb   $70
         dfb   $74
         dfb   $03
         dfb   $68
         dfb   $32
         dfb   $00
         dfb   $54
         dfb   $1f
         dfb   $00
         dfb   $54
         dfb   $7f
         dfb   $00
         dfb   $78
         dfb   $1f
         dfb   $00
         dfb   $49
         dfb   $ff
         dfb   $f0
         dfb   $bc
         dfb   $4c
PlayerShipImage3
         dfb   $70
         dfb   $3f
         dfb   $00
         dfb   $28
         dfb   $7f
         dfb   $01
         dfb   $28
         dfb   $3f
         dfb   $00
         dfb   $50
         dfb   $65
         dfb   $00
         dfb   $60
         dfb   $69
         dfb   $07
         dfb   $50
         dfb   $65
         dfb   $00
         dfb   $28
         dfb   $3f
         dfb   $00
         dfb   $28
         dfb   $7f
         dfb   $01
         dfb   $70
         dfb   $3f
         dfb   $00
         dfb   $a5
         dfb   $18
         dfb   $d0
         dfb   $02
         dfb   $c6
PlayerShipImage4
         dfb   $60
         dfb   $7f
         dfb   $00
         dfb   $50
         dfb   $7e
         dfb   $03
         dfb   $50
         dfb   $7e
         dfb   $00
         dfb   $20
         dfb   $4b
         dfb   $01
         dfb   $40
         dfb   $53
         dfb   $0f
         dfb   $20
         dfb   $4b
         dfb   $01
         dfb   $50
         dfb   $7e
         dfb   $00
         dfb   $50
         dfb   $7e
         dfb   $03
         dfb   $60
         dfb   $7f
         dfb   $00
         dfb   $e6
         dfb   $1f
         dfb   $4c
         dfb   $91
         dfb   $1d
PlayerShipImage5
         dfb   $40
         dfb   $7f
         dfb   $01
         dfb   $20
         dfb   $7d
         dfb   $07
         dfb   $20
         dfb   $7d
         dfb   $01
         dfb   $40
         dfb   $16
         dfb   $03
         dfb   $00
         dfb   $27
         dfb   $1f
         dfb   $40
         dfb   $16
         dfb   $03
         dfb   $20
         dfb   $7d
         dfb   $01
         dfb   $20
         dfb   $7d
         dfb   $07
         dfb   $40
         dfb   $7f
         dfb   $01
         dfb   $91
         dfb   $1d
         dfb   $a2
         dfb   $18
         dfb   $a5
PlayerShipImage6
         dfb   $00
         dfb   $7f
         dfb   $03
         dfb   $40
         dfb   $7a
         dfb   $0f
         dfb   $40
         dfb   $7a
         dfb   $03
         dfb   $00
         dfb   $2d
         dfb   $06
         dfb   $00
         dfb   $4e
         dfb   $3e
         dfb   $00
         dfb   $2d
         dfb   $06
         dfb   $40
         dfb   $7a
         dfb   $03
         dfb   $40
         dfb   $7a
         dfb   $0f
         dfb   $00
         dfb   $7f
         dfb   $03
         dfb   $1f
         dfb   $65
         dfb   $1e
         dfb   $aa
         dfb   $b1
         dfb   $1e
         dfb   $65
         dfb   $1f
         dfb   $85
         dfb   $1f
         dfb   $86
         dfb   $1e
         dfb   $4c
         dfb   $91
         dfb   $1d
         dfb   $00
         dfb   $00
         dfb   $4f
         dfb   $4f
         dfb   $00
         dfb   $00
         dfb   $4f
         dfb   $4f
         dfb   $00
         dfb   $00
         dfb   $4f
         dfb   $4f
         dfb   $00
         dfb   $00
         dfb   $4f
         dfb   $4f
         dfb   $00
         dfb   $00
         dfb   $4f
         dfb   $4f
         dfb   $00
         dfb   $8d

* Move the entities (up to 8 of them)

UpdateEntities
         lda   NumEntities
         sta   WhichEntity
         lda   #$00
         sta   colliderflag
:nextentity
         jsr   HandleEntity
         lda   #$00
         sta   colliderflag
         dec   WhichEntity
         bne   :nextentity
         rts

* Move one entity

HandleEntity
         ldx   WhichEntity
         lda   EntitySTable,x
         cmp   #$00        
         beq   RestartEntity   ; reuse the slot if the state is 0
         clc
         asl   A
         bcc   EntityLeftCheck
         jmp   ExplodeOrDead ; Entity high bit set

EntityLeftCheck
         lsr   A               ; ????
         lda   EntityXTable,x  ; if less than 14, remove the entity
         cmp   #EntityXMin
         bne   EntityXMovement
         jmp   DeadEntity      ; moving off-screen

* Actually move the entity

EntityXMovement
         dec   EntityXTable,x ; move to the left
         nop
         lda   RndTemp    ; TODO: Random
         and   #$20
         cmp   #$20
         beq   ChangeEntityY ; should Y change?
         jmp   DrawEntity

RestartEntity
         jsr   Random     ; Get a random number
         sta   RndTemp    ; Save it for now
         asl   A
         lsr   A
         clc
         adc   #$16       ; new random Y value
         ldx   WhichEntity
         sta   EntityYTable,x ;Pick a new Y value
         lda   #EntityXMax
         sta   EntityXTable,x ;Restart at right side of screen
         lda   #$01
         sta   EntitySTable,x ;Running alive and well
         jsr   Random
         and   #$07       ; path [0-7]
         sta   EntityPTable,x
         lda   #0
         sta   EntityITable,x
         rts

ChangeEntityY
         ldx   WhichEntity
         lda   EntityYTable,x
         sta   TempEntityY
         ldx   PlayerY
:lineupcheck
         cpx   TempEntityY
         beq   :linedup
         dex
         bne   :lineupcheck
         ldx   WhichEntity
         dec   EntityYTable,x ; Move down toward player
         jmp   DrawEntity

:linedup ldx   WhichEntity
         inc   EntityYTable,x ; Move up toward player
         jmp   DrawEntity

* simple case of the entity leaving the screen
* erase the entity and free up the slot

DeadEntity
         ldx   WhichEntity ; Erase the entitry and set status to 0.
         lda   #$00
         sta   EntitySTable,x ; make the entity reusable
         lda   EntityYTable,x
         sta   YScanline
         lda   EntityXTable,x
         jsr   DivideBy7
         stx   XByte
         lda   #$09       ; 9 scanlines
         sta   Count
:more    jsr   BlackScanLine
         inc   YScanline
         dec   Count
         bne   :more
         rts

BlackScanLine
         ldx   YScanline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldy   XByte
         lda   #$00
         sta   (TGTLO),y
         iny
         sta   (TGTLO),y
         iny
         sta   (TGTLO),y
         rts

* draw a "current" entity at a specific point
* do not use the Entity*Tables

DrawEntityRaw               ; A=Xpos, Y=Ypos
         sty   YScanline
         ldx   #$ff
         stx   WhichEntity
         jmp   @short

* Draw the current entity using the table location

DrawEntity
         ldx   WhichEntity ;Draw entity # from $CF
         lda   EntityYTable,x
         sta   YScanline
         lda   EntityXTable,x
@short   jsr   DivideBy7
         stx   XByte
         tya
         asl   A
         asl   A
         asl   A
         asl   A
         asl   A
         sta   EntityFetch+1 ;Store remainder*32 to lower byte of data fetch
         ldx   #$00
         lda   #$09       ;9 scanlines
         sta   Count
:scanline
         jsr   DrawEScanLine
         inc   YScanline
         dec   Count
         bne   :scanline
         lda   colliderflag
         cmp   #$01
         beq   :collided
         rts

:collided
         ldx   WhichEntity
         bmi   :notable
         lda   #$83       ; Entity just died, 3 explosions before we can reap the slot
         sta   EntitySTable,x
         inc   NEntityKilled
         jsr   DrawLvlCount
         lda   #$ff
         sta   MissleY    ;Stop missle
:notable rts


DrawEScanLine
         lda   #$03
         sta   TempX
         ldy   XByte
         stx   TempY
         ldx   YScanline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldx   TempY
byteloop lda   (TGTLO),y
         and   #$80       
         cmp   #$80       ; Hit by missile???
         bne   EntityFetch
         lda   #$01
         sta   colliderflag     ; If high bit set, store 1 at $CE
EntityFetch
         lda   EntityImgTables,x    ;Fetch entity: HI=from level?  LO=from shift*32
         sta   (TGTLO),y
         inx
         iny
         dec   TempX
         bne   byteloop
         rts

ExplodeOrDead
         lsr   A
         cmp   #$00
         bne   DrawExplosion
         jmp   DeadEntity ; slot can be reused

DrawExplosion
         ldx   WhichEntity
         dec   EntitySTable,x
         lda   EntitySTable,x
         asl   A
         asl   A
         asl   A
         asl   A
         asl   A
         jsr   SetupExpFetch
         lda   EntityYTable,x
         sta   YScanline
         lda   EntityXTable,x
         jsr   DivideBy7
         stx   XByte
         ldx   #$00
         lda   #$09
         sta   Count
:nextscaline
         jsr   DrawExpScanline
         inc   YScanline
         dec   Count
         bne   :nextscaline
         rts

DrawExpScanline
         lda   #$03
         sta   TempX
         ldy   XByte
         stx   TempY
         ldx   YScanline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldx   TempY
EntityExpFetch
         lda   EntityExpTable,x
         sta   (TGTLO),y
         inx
         iny
         dec   TempX
         bne   EntityExpFetch
         rts

SetupExpFetch
         sta   EntityExpFetch+1
         lda   #$15
         sta   Timer0
:click   sta   SPKR
         lda   #$20
         sta   Timer1
:delay   dec   Timer1
         bne   :delay
         dec   Timer0
         bne   :click
         rts

Timer0   dfb   $00
Timer1   dfb   $00
Count    dfb   $00
TempX    dfb   $00
TempY    dfb   $18
XByte    dfb   $09
YScanline
         dfb   $76
         
TempEntityY
         ds    MaxEntities

EntityXMin =  14
EntityXMax =  189

EntityXTable              ; X location of the entities
         ds    MaxEntities
EntityYTable              ; Y location of the entities
         ds    MaxEntities
EntityPTable              ; The path number of the entites
         ds    MaxEntities
EntityITable              ; The index into the entity path table
         ds    MaxEntities

* EntitySTable: $00=Unused, $01=Alive and running
* $83=Dead explosion 3, $82=Dead explosion 2,
* $81=Dead explosion 1, $80=Transition to Unused

EntitySTable              ; State of the entities
         ds    MaxEntities

* explosion is 3 images of 3*9+5=$20, so $20*3 = $60 bytes
* images are 3 bytes wide and 9 scanlines.  
* No pre-shifting here and it must be page aligned as the
* increment code makes offset assumptions

            ds \
EntityExpTable  
            dfb   $20
            dfb   $09
            dfb   $7e
            dfb   $20
            dfb   $13
            dfb   $7e
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $20
            dfb   $00
            dfb   $39
            dfb   $00
            dfb   $46
            dfb   $19
            dfb   $00
            dfb   $36
            dfb   $48
            dfb   $50
            dfb   $77
            dfb   $20
            dfb   $00
            dfb   $39
            dfb   $00
            dfb   $47
            dfb   $19
            dfb   $00
            dfb   $37
            dfb   $48
            dfb   $50
            dfb   $77
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $6a
            dfb   $4c
            dfb   $00
            dfb   $36
            dfb   $44
            dfb   $45
            dfb   $0d
            dfb   $00
            dfb   $0d
            dfb   $0d
            dfb   $0d
            dfb   $56
            dfb   $3d
            dfb   $00
            dfb   $45
            dfb   $59
            dfb   $45
            dfb   $54
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $19
            dfb   $00
            dfb   $2a
            dfb   $4a
            dfb   $1d
            dfb   $00
            dfb   $09
            dfb   $11
            dfb   $40
            dfb   $48
            dfb   $3d
            dfb   $33
            dfb   $08
            dfb   $4a

DrawEmptyPlayfield
         sta   TempX
         jsr   ClearPlayfield
         lda   TempX
         jsr   DrawRightBars
         jsr   DrawRLBars
         ldx   #$bf
         ldy   #$b8
         jsr   DrawHorizBar
         ldx   #$07
         ldy   #$00
         jmp   DrawHorizBar

ClearPlayfield
         ldx   #$1d       ;Clear 29 columns at 182 back up to 0
         stx   Count
:nextcolumn
         ldx   #$bf
:nextline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldy   Count
         lda   #$00
         sta   (TGTLO),y
         dex
         bne   :nextline
         dec   Count
         bne   :nextcolumn
         rts

DrawRightBars
         cmp   #$01       ;What phase are we in?
         bne   :skipphase ;If A!=1 do nothing (if Phase 1, then draw bars)
         ldx   #$bf
:nextline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldy   #$18       ;White bars at columns $18 and $19
         lda   #$ff
         sta   (TGTLO),y
         iny
         sta   (TGTLO),y
         dex
         bne   :nextline
:skipphase
         rts

DrawLeftBar
         ldx   #$bf
:nextline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         lda   #$7f
         ldy   #$00
         sta   (TGTLO),y
         dex
         bne   :nextline
         rts

DrawHorizBar
         stx   YStart+1
         sty   YEnd+1
YStart   ldx   #$07       ;Self modifiying code
nextline lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldy   #$1d       ;Columns $1d to $01
:nextbyte
         lda   #$7f
         sta   (TGTLO),y
         dey
         bne   :nextbyte
         dex
YEnd     cpx   #$00       ;Self modifying code
         bne   nextline
         rts

DrawRLBars
         jsr   DrawLeftBar
         ldx   #$bf
:nextline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         lda   #$7f
         ldy   #$1d       ;Rightmost bar at column $1D
         sta   (TGTLO),y
         dex
         bne   :nextline
         lda   TempX      ;What phase are we in?
         cmp   #$01
         bne   :skipphase
         ldx   #$bf
:nextline1
         lda   ScanlineTblHI,x ;Draw column at $19 if in phase 1
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldy   #$19
         lda   #$ff
         sta   (TGTLO),y
         iny
         sta   (TGTLO),y
         dex
         bne   :nextline1
:skipphase
         rts

DrawPhase1Boss
         inc   $0300      ;Scanlines 184 to 8?
         lda   $0300
         cmp   #$b8
         bne   :wrap
         lda   #$08
:wrap    sta   $0300
         ldx   #$00
         sta   $01
         lda   #$10
         sta   $02        ;X=0, $01 <- $300, $02 <- 16
:nextline
         jsr   OneLine
         inc   $01
         lda   $01
         cmp   #$b8       ;Cmp vs bottom
         bne   :notloop
         lda   #$08       ;loop back around to 8
:notloop sta   $01
         dec   $02
         bne   :nextline
         rts

OneLine  stx   $03        ;Stash X
         ldx   $01
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldx   $03
         ldy   #$1b       ;Column $1b ? Scrolling bar?
         lda   (TGTLO),y
         and   #$80
         cmp   #$80
         bne   :cleared1
         lda   #$01
         sta   $0301      ;$0301 -> flagged hit by missle?
:cleared1
         lda   Phase1BossImg,x ;strip buffer??? $4790
         sta   (TGTLO),y
         iny
         inx
         lda   (TGTLO),y
         and   #$80
         cmp   #$80
         bne   :cleared2
         lda   #$01
         sta   $0301
:cleared2
         lda   Phase1BossImg,x
         sta   (TGTLO),y
         inx
         rts

* A little bit different, 2 bytes wide, 16 scanlines  (32bytes)
* (black at top and bottom for scrolling)

Phase1BossImg
         hex   0000402a2015500a
         hex   284528626833101f
         hex   101f683328622845
         hex   500a2015402a0000

ShiftDownward
         ldy   #$1a
         ldx   #$08
         jsr   GenYAddr
         lda   (TGTLO),y
         pha
:loop    inx
         jsr   GenYAddr
         lda   (TGTLO),y
         pha
         dex
         jsr   GenYAddr
         pla
         sta   (TGTLO),y
         inx
         cpx   #$b7
         bne   :loop
         jsr   GenYAddr
         pla
         sta   (TGTLO),y
         rts

GenYAddr lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         rts

ScrollWallMissile
         lda   MissleXByte
         cmp   #$1a       ;Hit wall?
         bne   :nope
         lda   MissleY
         cmp   #$00
         beq   :nope
         jmp   :moveit

:nope    rts

:moveit  ldx   MissleY
         jsr   GenYAddr
         ldy   #$1a
         lda   #$ff       ;Draw in the wall
         eor   (TGTLO),y
         sta   (TGTLO),y
         dex
         jsr   GenYAddr
         lda   #$00       ;Erase from row above
         sta   (TGTLO),y
         rts

DiskUpdate
         jsr   SaveHS
         jsr   ReadHS
         jmp   HighScoreCheck

EndOfGame
         lda   #$0b
         sta   XTMP
         lda   #$30
         sta   YTMP
         jsr   DrawGameOverImage
         jmp   DiskUpdate

DrawGameOverImage
         lda   GameOverImgWidth
         sta   $fc
         lda   GameOverImgHeight
         sta   $fd
         ldx   #$00
:nextline
         ldy   YTMP
         lda   ScanlineTblLO,y
         sta   GLYPH
         lda   ScanlineTblHI,y
         sta   TMPHI
         lda   $fc
         sta   $fe
         ldy   XTMP
:nextbyte
         lda   GameOverImg,x
         sta   (GLYPH),y
         inx
         iny
         dec   $fe
         bne   :nextbyte
         inc   YTMP
         dec   $fd
         bne   :nextline
         jmp   WaitKeyOrBtn

WaitKeyOrBtn
         sta   KBDSTRB
:loop    lda   KBD
         bmi   :done
         lda   BUTN0
         bmi   :done
         jmp   :loop
:done    sta   KBDSTRB
:loop2   lda   BUTN0      ; wait for button to be released
         bmi   :loop2
         rts

GameOverImgWidth
         dfb   $09
GameOverImgHeight
         dfb   $19
GameOverImg               ; Image payload of $e1 bytes
         ds    10
         dfb   $54
         dfb   $00
         dfb   $10
         dfb   $00
         dfb   $01
         dfb   $02
         dfb   $55
         dfb   $02
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $44
         dfb   $00
         dfb   $45
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $11
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $11
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $01
         dfb   $02
         dfb   $55
         dfb   $00
         dfb   $00
         dfb   $45
         dfb   $02
         dfb   $55
         dfb   $02
         dfb   $01
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $01
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $01
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $54
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $01
         dfb   $02
         dfb   $55
         dfb   $02
         ds    37
         dfb   $54
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $55
         dfb   $02
         dfb   $55
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $55
         dfb   $00
         dfb   $55
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $02
         dfb   $05
         dfb   $00
         dfb   $15
         dfb   $00
         dfb   $00
         dfb   $05
         dfb   $02
         dfb   $44
         dfb   $00
         dfb   $05
         dfb   $00
         dfb   $45
         dfb   $00
         dfb   $00
         dfb   $54
         dfb   $00
         dfb   $10
         dfb   $00
         dfb   $55
         dfb   $02
         dfb   $05
         dfb   $02
         ds    9
         dfb   $02

HighScoreCheck
         lda   SCOREHI
         nop
         nop
         nop
         nop
         tay
         cpy   HISCOREHI
         beq   :testmid
         jmp   :checklo

:looplo  dey
:checklo cpy   HISCOREHI
         beq   NewHiScore
         cpy   #$00
         bne   :looplo
         jmp   DisplayHighScore

:testmid ldy   SCOREMID
         cpy   HISCOREMID
         beq   :testlow
         jmp   :checkmid

:loopmid dey
:checkmid
         cpy   HISCOREMID
         beq   NewHiScore
         cpy   #$00
         bne   :loopmid
:tie     jmp   DisplayHighScore

:testlow ldy   SCORELO
         cpy   HISCORELO
         beq   :tie
         jmp   :checklo1

:looplo1 dey
:checklo1
         cpy   HISCORELO
         beq   NewHiScore
         cpy   #$00
         bne   :looplo1
         jmp   DisplayHighScore

NewHiScore
         lda   SCOREHI
         sta   HISCOREHI
         lda   SCOREMID
         sta   HISCOREMID
         lda   SCORELO
         sta   HISCORELO
         lda   #$25
         sta   XTMP
         lda   #$4d
         sta   YTMP
         lda   HISCORELO
         and   #$0f
         sta   GLYPH
         jsr   DrawDigit
         lda   #$25
         sta   XTMP
         lda   #$3f
         sta   YTMP
         lda   HISCORELO
         lsr   A
         lsr   A
         lsr   A
         lsr   A
         sta   GLYPH
         jsr   DrawDigit
         lda   #$25
         sta   XTMP
         lda   #$31
         sta   YTMP
         lda   HISCOREMID
         and   #$0f
         sta   GLYPH
         jsr   DrawDigit
         lda   #$25
         sta   XTMP
         lda   #$23
         sta   YTMP
         lda   HISCOREMID
         lsr   A
         lsr   A
         lsr   A
         lsr   A
         sta   GLYPH
         jsr   DrawDigit
         lda   #$25
         sta   XTMP
         lda   #$15
         sta   YTMP
         lda   HISCOREHI
         and   #$0f
         sta   GLYPH
         jsr   DrawDigit
         lda   #$25
         sta   XTMP
         lda   #$07
         sta   YTMP
         lda   HISCOREHI
         lsr   A
         lsr   A
         lsr   A
         lsr   A
         sta   GLYPH
         jsr   DrawDigit
         jmp   DisplayHighScore

DisplayHighScore
         jsr   HighScoreUpdate
         sta   KBDSTRB

StartTotally
         lda   BUTN0
         bmi   :dojoy
         lda   KBD
         cmp   #$ca       ;'J'?
         bne   :notjoystick
:dojoy   jsr   INITJOY
         jmp   PlayAGame

:notjoystick
         cmp   #$cb       ;'K'?
         bne   StartTotally
         jsr   INITKBD
         jmp   PlayAGame

HighScoreUpdate
         jsr   DisplayHighList
         lda   #$00
         jsr   DrawEmptyPlayfield
         jsr   DrawGameTitle
         lda   KBDSTRB
         jmp   SaveHS     ;Save highscore sector

INITJOY  lda   #>ReadDirJoy
         sta   UpdatePhase0Loop+2
         sta   Phase1Input+2
         lda   #<ReadDirJoy
         sta   UpdatePhase0Loop+1
         sta   Phase1Input+1
         lda   #$20       ;JSR $1Df0 at $1D66
         sta   GetInputBtn
         lda   #<ReadJoystickBtn
         sta   GetInputBtn+1
         lda   #>ReadJoystickBtn
         sta   GetInputBtn+2
         rts

INITKBD  lda   #>ReadDirKbd
         sta   UpdatePhase0Loop+2
         sta   Phase1Input+2
         lda   #<ReadDirKbd
         sta   UpdatePhase0Loop+1
         sta   Phase1Input+1
         lda   #$ad       ;LDA $C000 at $1D66
         sta   GetInputBtn
         lda   #$00
         sta   GetInputBtn+1
         lda   #$c0
         sta   GetInputBtn+2
         rts

ESCPatchToHandleEntity
         lda   KBD
         cmp   #$9b
         beq   ESCPatchToHandleEntity
         jmp   HandleEntity

PauseCheck         
         lda   KBD
         cmp   #$9b
         beq   PauseCheck
         rts

TickCount8
         dfb   $08

PlayPhase1
         jsr   Phase1Setup
PlayLoop jsr   DrawPhase1Boss
         jsr   ReadBtnState
Phase1Input
         jsr   ReadDirJoy ;Self modifying entry for kbd vs joy
         jsr   ShiftDownward
         jsr   PauseCheck
         lda   $0301
         cmp   #$01
         beq   :winner    ;Phase done????
         jsr   ScrollWallMissile
         jsr   MoveStars
         jmp   :continue

:winner  jmp   :addscore

:continue
         dec   TickCount8
         bne   :notyet
         lda   #$08
         sta   TickCount8
                          ; jsr   MovePoints    ; Every 8 passes? RJF
:notyet  jsr   FuelDecrement
         lda   PlayrDiedFlg  ; Check to see if we died...
         cmp   #$01
         bne   :stillrunning
         rts

:stillrunning
         jmp   PlayLoop

:addscore
         jsr   FuelDrop
         lda   CurFuelLevel
         and   #1
         beq   :skip
         lda   #$01       ; 1 at a time for every 2 points of fuel
         jsr   IncDrawScore
:skip    lda   SPKR
         ldy   #$ff
:delay   dey
         bne   :delay
         ldy   #$ff
:noise   dey
         jsr   Noise
         bne   :noise
         lda   PlayrDiedFlg
         beq   :addscore
         lda   #0           ; make sure to clean the flag
         sta   PlayrDiedFlg
         rts

Noise    lda   SPKR
         ldy   #$ff
:delay   dey
         bne   :delay
         ldy   #$ff
:delay1  dey
         bne   :delay1
         ldy   #$ff
:delay2  dey
         bne   :delay2
         ldx   #$20
:click   lda   SPKR
         ldy   #$ff
:delay3  dey
         bne   :delay3
         dex
         bne   :click
         rts

DrawGameTitle
         lda   #$04       ; Xpos in columns
         sta   $00
         lda   #$50       ; Ypos in rows
         sta   $01
         lda   #>TitleImageMassdraw
         sta   GetTitleByte+2
         lda   #<TitleImageMassdraw
         sta   GetTitleByte+1
         ldy   $00        ;Xpos
         ldx   $01        ;Ypos
         jsr   GetTitleByte
         sta   $05        ;Width in bytes
         tya
         clc
         adc   $05
         sta   LastXColumnCheck+1
         jsr   GetTitleByte ;Height in rows?
         sta   $05
         txa
         clc
         adc   $05
         sta   LastYRowCheck+1
@next    lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         jsr   DrawTitleScanline
         inx
LastYRowCheck
         cpx   #$b3
         bne   @next
         jsr   DrawVersion
         rts

GetTitleByte
         lda   $5700      ;Self modifying code address
         pha
         lda   GetTitleByte+1
         clc
         adc   #$01
         sta   GetTitleByte+1
         lda   GetTitleByte+2
         adc   #$00
         sta   GetTitleByte+2
         pla
         rts

DrawTitleScanline
         sty   $05
nextbyte jsr   GetTitleByte
         nop
         nop
         sta   (TGTLO),y
         iny
LastXColumnCheck
         cpy   #$19
         bne   nextbyte
         ldy   $05
         rts

* Inline the title image bytes

         put   TITLE_IMAGE.S

* Stars...  There can be N stars in phase1.  These just bounce 
* off the walls.  They are specified as:
*      X,Y,cntX,cntY,incX,incY,bcntX,bcntY
* X,Y : location of the point
* cnt{X,Y} : number of update passes before location is updated
* inc{X,Y} : amount to add (+-) when cnt{X,Y} expires
* bcnt{X,Y} : amount to reset cnt{X,Y} to after expiration
*

StarCount dfb  0          ; number of stars
StarMinCount dfb 0        ; base speed number

* 256 bytes of state
StarLocX  ds   32
StarLocY  ds   32
StarCntX  ds   32
StarCntY  ds   32
StarIncX  ds   32
StarIncY  ds   32
StarBcntX ds   32
StarBcntY ds   32

StarCntTable            ; number of stars/level (clamped)
         dfb   18
         dfb   18
         dfb   20
         dfb   20
         dfb   22
         dfb   22
         dfb   24
         dfb   24
         dfb   26
         dfb   26
         dfb   28
         dfb   28
         dfb   30
         dfb   30
         dfb   32
         dfb   32

StarSpdTable            ; base number of cycles/level
         dfb   4
         dfb   4
         dfb   4
         dfb   4
         dfb   3
         dfb   3
         dfb   3
         dfb   3
         dfb   2
         dfb   2
         dfb   2
         dfb   2
         dfb   1
         dfb   1
         dfb   1
         dfb   1

InitStars
         lda   CurrentLevel
         cmp   #$10
         blt   :noclamp
         lda   #$0f       ; levelcap
:noclamp tax
         lda   StarCntTable,x
         sta   StarCount
         lda   StarSpdTable,x
         sta   StarMinCount
         ldx   #0
:nextst  ; start with +- directions
         jsr   Random     ; create a field of stars
         ldy   #1         ; start with +- directions
         and   #1
         beq   :skip0
         ldy   #$ff
:skip0   tya
         sta   StarIncX,x
         jsr   Random     ; create a field of stars
         ldy   #1
         and   #1
         beq   :skip1
         ldy   #$ff
:skip1   tya
         sta   StarIncY,x
         ; speeds/deltas
         jsr   Random
         and   #$03       
         clc
         adc   StarMinCount
         sta   StarCntX,x
         sta   StarBcntX,x
         jsr   Random
         and   #$03    
         clc
         adc   StarMinCount
         sta   StarCntY,x
         sta   StarBcntY,x
         ; Locations - grab an X and Y and loop if invalid
:again   jsr   Random
         sta   StarLocX,x
         jsr   Random
         sta   StarLocY,x
         jsr   StarValid   
         bcs   :again                         
         inx
         cpx   StarCount
         blt   :nextst
         jsr   DrawStars
         lda   #15
         sta   PlayerX
         lda   #80
         sta   PlayerY
         jsr   DrawPlayerShip
         rts

StarValid   ; Check if Valid
         lda   StarLocX,x
         cmp   #167-4
         bge   :invalid
                          ; cmp   #7         
         cmp   #50        ; carve out space for ship to start?
         blt   :invalid
         lda   StarLocY,x
         cmp   #183-2
         bge   :invalid
         cmp   #8
         blt   :invalid
         clc
         rts
:invalid sec         
         rts         

MoveStars
         ldx   #0
:nextst  lda   StarLocX,x  ; record the point position
         sta   XTMP
         lda   StarLocY,x
         sta   YTMP        
         ; move a star    
         dec   StarCntX,x  
         bne   :xok
         lda   StarBcntX,x
         sta   StarCntX,x
         ; apply incX
         lda   XTMP
         adc   StarIncX,x
         cmp   #7
         blt   :bounceRL
         cmp   #166
         bge   :bounceRL
         sta   StarLocX,x
         jmp   :xok
:bounceRL
         lda   StarIncX,x
         eor   #$fe
         sta   StarIncX,x
         lda   XTMP
         adc   StarIncX,x
         sta   StarLocX,x  
:xok     dec   StarCntY,x
         bne   :yok
         lda   StarBcntY,x
         sta   StarCntY,x
         ; apply incY
         lda   YTMP
         adc   StarIncY,x
         cmp   #8
         blt   :bounceTB
         cmp   #184
         bge   :bounceTB
         sta   StarLocY,x
         jmp   :yok
:bounceTB
         lda   StarIncY,x
         eor   #$fe
         sta   StarIncY,x
         lda   YTMP
         adc   StarIncY,x
         sta   StarLocY,x         
:yok     ; Replot based on motion or lack thereof
         lda   StarLocX,x   
         cmp   XTMP
         bne   :replot
         lda   StarLocY,x
         cmp   YTMP
         beq   :noplot
:replot  jsr   DrawStar     ; Erase from old location
         lda   StarLocX,x
         sta   XTMP
         lda   StarLocY,x
         sta   YTMP
         jsr   DrawStar     ; Draw at new location
:noplot  inx
         cpx   StarCount
         bge   :donest
         jmp   :nextst
:donest  rts

DrawStars
         ldx   #0
:nextst  lda   StarLocX,x
         sta   XTMP
         lda   StarLocY,x
         sta   YTMP
         jsr   DrawStar
         inx
         cpx   StarCount
         blt   :nextst
         rts

DrawStar                  ; XTMP,YTMP
         lda   #2
         sta   GLYPH
         txa              ; preserve X reg
         pha
:starln  ldx   YTMP       ; First scanline
         lda   ScanlineTblHI,x
         sta   TGTHI
         lda   ScanlineTblLO,x
         sta   TGTLO
         ldx   XTMP
         lda   Div7Quotient,x  ; draw left column
         tay
         lda   Div7Remainder,x ; offset into preshifted images
         tax             
         lda   StarLeftByte,x  ; two preshifted bytes
         eor   (TGTLO),y
         sta   (TGTLO),y
         iny
         lda   StarRightByte,x
         eor   (TGTLO),y
         sta   (TGTLO),y
         inc   YTMP
         dec   GLYPH
         bne   :starln
         pla
         tax
         rts

* Star pixel image (4 pixels, repeat for 2 scanlines)
* 1248 124    1248
* 1010 000    0000 - 05 00 
* 0101 000    0000 - 0a 00
* 0010 100    0000 - 14 00
* 0001 010    0000 - 28 00
* 0000 101    0000 - 50 00
* 0000 010    1000 - 20 01
* 0000 001    0100 - 40 02

StarLeftByte
         hex   050a1428502040
StarRightByte
         hex   00000000000102

Phase1Setup
         lda   #$01
         jsr   DrawEmptyPlayfield
         lda   #$00
         sta   $14
         jsr   InitStars
         lda   #$60       ;Init $300 to $60, $301 to $00
         sta   $0300
         lda   #$00
         sta   $0301
         sta   MissleY    ;Reset missile
         lda   #$10
         sta   TickCount8
         jsr   Beep
         rts
         
SwapScoreHiLo
         lda   SCORELO
         pha
         lda   SCOREHI
         sta   SCORELO
         pla
         sta   SCOREHI
         lda   #$00
         jmp   DrawEmptyPlayfield

         dfb   $00

DisplayHighList
         lda   #$00
         jsr   SwapScoreHiLo
         lda   #$08
         sta   XTMP
         lda   #$10
         sta   YTMP
         jsr   Draw_HiScore_Img
         lda   #$ff             ; Setup pointers to the high score I/O buffer
         sta   $ed
         lda   #>IOBUFFER       ; $XXff - end of the score buffer
         sta   TGTHI
         lda   #$a0
         sta   TGTLO
NextScore
         ldy   #$03
         lda   (TGTLO),y
         sta   TMPSCRHI
         iny
         lda   (TGTLO),y
         sta   TMPSCRMID
         iny
         lda   (TGTLO),y
         sta   TMPSCRLO
         ldy   SCORELO    ;Remember the score has been "swapped"
         cpy   TMPSCRHI
         beq   :cmpmid
         jmp   :ne0

:loop0   dey
         cpy   TMPSCRHI
         beq   :L656B
:ne0     cpy   #$00
         bne   :loop0
         jmp   NewHigh

:cmpmid  ldy   SCOREMID
         cpy   TMPSCRMID
         beq   :cmplo
         jmp   :ne1

:loop1   dey
         cpy   TMPSCRMID
         beq   :L656B
:ne1     cpy   #$00
         bne   :loop1
         jmp   NewHigh

:cmplo   ldy   SCOREHI
         cpy   TMPSCRLO
         beq   NewHigh
         jmp   :ne2

:loop2   dey
         cpy   TMPSCRLO
         beq   :L656B
:ne2     cpy   #$00
         bne   :loop2
         jmp   NewHigh

:L656B   lda   TGTLO
         pha
         ldy   #$05
:L6570   lda   (TGTLO),y
         pha
         dey
         cpy   #$ff
         bne   :L6570
         lda   TGTLO
         clc
         adc   #$10
         sta   TGTLO
         ldy   #$00
:L6581   pla
         sta   (TGTLO),y
         iny
         cpy   #$06
         bne   :L6581
         pla
         sta   TGTLO
         ldy   #$00
:L658E   lda   $00ed,y
         sta   (TGTLO),y
         iny
         cpy   #$06
         bne   :L658E
         lda   TGTLO
         clc
         adc   #$f0
         sta   TGTLO
         cmp   #$00
         beq   :L65A6
         jmp   NextScore

:L65A6   nop
NewHigh  nop
         ldx   #$00
         ldy   #$0a
:L65AC   tya
         asl   A
         asl   A
         asl   A
         asl   A
         sta   TGTLO
         lda   (TGTLO,x)
         cmp   #$ff
         bne   :L65BC
         jmp   L665A

:L65BC   dey
         bne   :L65AC
L65BF    lda   #$10
         sta   TGTLO
         ldy   #$01
         sty   MON_COLOR
:next    lda   MON_COLOR
         asl   A
         asl   A
         asl   A
         asl   A
         clc
         adc   #$10
         sta   $31
         jsr   DrawHiscoreLine
         lda   TGTLO
         clc
         adc   #$10
         sta   TGTLO
         cmp   #$b0
         beq   :waitkeyandret
         inc   MON_COLOR
         jmp   :next

:waitkeyandret
         jmp   WaitKeyOrBtn

DrawHiscoreLine
         lda   #$0f
         sta   MON_INVFLAG
         ldy   #$03
         lda   (TGTLO),y
         jsr   Draw2Digits
         ldy   #$04
         lda   (TGTLO),y
         jsr   Draw2Digits
         ldy   #$05
         lda   (TGTLO),y
         jsr   Draw2Digits
         lda   #$07
         sta   MON_INVFLAG
         ldy   #$00
         sty   MON_PROMPT
:nextchar
         lda   (TGTLO),y
         sta   GLYPH
         lda   $31
         sta   YTMP
         lda   MON_INVFLAG
         sta   XTMP
         jsr   DrawChar
         inc   MON_INVFLAG
         inc   MON_INVFLAG
         inc   MON_PROMPT
         ldy   MON_PROMPT
         cpy   #$03
         beq   :done
         jmp   :nextchar

:done    rts

Draw2Digits
         pha
         lsr   A
         lsr   A
         lsr   A
         lsr   A
         sta   GLYPH
         lda   $31
         sta   YTMP
         lda   MON_INVFLAG
         sta   XTMP
         jsr   DrawDigit2
         inc   MON_INVFLAG
         inc   MON_INVFLAG
         pla
         and   #$0f
         sta   GLYPH
         lda   $31
         sta   YTMP
         lda   MON_INVFLAG
         sta   XTMP
         inc   MON_INVFLAG
         inc   MON_INVFLAG
         jsr   DrawDigit2
         rts

L665A    lda   TGTLO
         sta   MON_INVFLAG
         jsr   EnterNewInitials
         lda   MON_INVFLAG
         sta   TGTLO
         lda   $ed
         ldy   #$00
         sta   (TGTLO),y
         lda   $ee
         iny
         sta   (TGTLO),y
         lda   $ef
         iny
         sta   (TGTLO),y
         jmp   L65BF
         
         ds    \

IOBUFFER asc   "(C)1983BYR.FRANK" ;256 bytes (one sector)
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $1b
         dfb   $1b
         dfb   $1b
         ds    5
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00
         dfb   $ff
         dfb   $ff
         dfb   $00
         dfb   $00

DrawDigit2
         lda   GLYPH
         asl   A
         asl   A
         asl   A
         tax
         lda   #$08
         sta   TMPHI
:loop    ldy   YTMP
         lda   ScanlineTblLO,y
         sta   $fc
         lda   ScanlineTblHI,y
         sta   $fd
         ldy   XTMP
         lda   DigitImgTable,x
         sta   ($fc),y
         inx
         inc   YTMP
         dec   TMPHI
         bne   :loop
         rts

* Images of the digits from 0 to 9. 8 bytes/digit
* 80 bytes

DigitImgTable
         hex   1441410041411400 ; 0
         hex   0040400040400000 ; 1
         hex   1440401401011400 ; 2
         hex   1440401440401400 ; 3
         hex   0041411440400000 ; 4
         hex   1401011440401400 ; 5
         hex   0001011441411400 ; 6
         hex   1440400040400000 ; 7
         hex   1441411441411400 ; 8
         hex   1441411440400000 ; 9
         hex   0000000000000800 ; '.'

EnterNewInitials
         lda   #$0f
         sta   MON_CH
         jsr   InputOneInitialChar
         lda   #$11
         sta   MON_CH
         jsr   InputOneInitialChar
         lda   #$13
         sta   MON_CH
         jsr   InputOneInitialChar
         rts

InputOneInitialChar
         lda   MON_CH
         sta   XTMP
         lda   #$40
         sta   YTMP
         lda   #$1c
         sta   GLYPH
         jsr   DrawChar
         jsr   GetOneInitial
         sta   GLYPH
         lda   MON_CH
         sta   XTMP
         lda   #$40
         sta   YTMP
         jsr   DrawChar
         rts

GetOneKey
         sta   KBDSTRB
:wait    lda   KBD
         tay
         rol   A
         bcc   :wait
         tya
         cmp   #$a0
         bne   :haveachar
         lda   #$1a
         rts

:haveachar
         ldx   #$00
         ldy   #$c1
         sta   MON_CV
:loop    cpy   MON_CV
         beq   :done
         cpy   #$da
         beq   GetOneKey
         inx
         iny
         jmp   :loop

:done    txa
         rts

GetOneInitial
         jsr   GetOneKey
         pha
         lda   MON_CH     ;Store based on column...
         cmp   #$0f
         beq   :leftchar
         cmp   #$11
         beq   :midchar
         pla
         sta   $ef
         rts

:leftchar
         pla
         sta   $ed
         rts

:midchar pla
         sta   $ee
         rts

DivideBy7
         tax
         lda   Div7Remainder,x
         tay
         lda   Div7Quotient,x
         tax
         rts

         put   DIV_SEVEN.S
         
* New random number generator
* Seed with some initial value

RandomInit 
         lda $4e          ; seed the random number generator
         sta r1           ; based on delay between keypresses
         sta r3
         lda $4f
         sta r2
         sta r4
         ldx #$20         ; generate a few random numbers
:loop    jsr Random         ; to kick things off
         dex
         bne :loop
         rts

r1       dfb 0
r2       dfb 0
r3       dfb 0
r4       dfb 0

* return a random byte 

Random   
         ror r4           ; bit 25 to carry
         lda r3           ; shift left 8 bits
         sta r4
         lda r2
         sta r3
         lda r1
         sta r2
         lda r4           ; get original bits 17-24
         ror              ; now bits 18-25 in acc
         rol r1           ; r1 holds bits 1-7
         eor r1           ; seven bits at once
         ror r4           ; shift right by one bit
         ror r3
         ror r2
         ror
         sta r1
         rts

* Read both joystick axes at the same time (and takes 
* a deterministic amount of time).  The effective range
* changes with 0=low, ~51=centered, ~114=high

JoyLowThresh = 25
JoyHighThresh = 90


JoystickTiming            ; fake a joystick read for use w/keyboard
        ldy #$00    ; initialize loop counter to 0 (y acts as the result here)
        sty TGTLO   ; clear result storage for X
        sty TGTHI   ; clear result storage for Y
        lda PTRIG   ; trigger the paddle timing cycle (starts the measurement)

:loop
        lda PADDL0  ; check the status of paddle 0
        bmi :set0   ; if high bit is set (cap discharged), branch to set value
        nop         ; (padding for consistent timing)
        bpl :nop0   ; branch always (takes consistent time)

:set0
        sty TGTLO   ; store the current loop count as the paddle 0 value
:nop0
        ; (padding nops or other instructions to ensure equal cycle count between reads)
        lda PADDL1  ; check the status of paddle 1
        bmi :set1   ; if high bit set, branch to set value
        nop         ; (padding)
        bpl :nop1   ; branch always

:set1
        sty TGTHI   ; store current loop count as the paddle 1 value
:nop1
        ; (padding)
        iny         ; increment loop counter
        cpy #$7f    ; check if the loop count has reached the threshold
        bne :loop   ; if not, continue polling
        rts


JoystickRead
        ldy #$00    ; initialize loop counter to 0 (y acts as the result here)
        sty JOY_X   ; clear result storage for X
        sty JOY_Y   ; clear result storage for Y
        lda PTRIG   ; trigger the paddle timing cycle (starts the measurement)

:loop
        lda PADDL0  ; check the status of paddle 0
        bmi :set0   ; if high bit is set (cap discharged), branch to set value
        nop         ; (padding for consistent timing)
        bpl :nop0   ; branch always (takes consistent time)

:set0
        sty JOY_X   ; store the current loop count as the paddle 0 value
:nop0
        ; (padding nops or other instructions to ensure equal cycle count between reads)
        lda PADDL1  ; check the status of paddle 1
        bmi :set1   ; if high bit set, branch to set value
        nop         ; (padding)
        bpl :nop1   ; branch always

:set1
        sty JOY_Y   ; store current loop count as the paddle 1 value
:nop1
        ; (padding)
        iny         ; increment loop counter
        cpy #$7f    ; check if the loop count has reached the threshold
        bne :loop   ; if not, continue polling
                          ; Map to 0,1,2 for X and Y
        lda JOY_X
        cmp #JoyLowThresh
        bge :tryagain0
        lda #0
        jmp :ycheck
:tryagain0    
        cmp #JoyHighThresh
        bge :ishi0
        lda #1
        jmp :ycheck
:ishi0  lda #2
:ycheck sta JOY_X
        lda JOY_Y
        cmp #JoyLowThresh
        bge :tryagain1
        lda #0
        jmp :done
:tryagain1    
        cmp #JoyHighThresh
        bge :ishi1
        lda #1
        jmp :done
:ishi1  lda #2
:done   sta JOY_Y
        rts   

InitPrefix
         jsr    MLI
         dfb    $2b
         da     PrefixParams
         bcs    :error
         dfb    $2c
         da     PrefixParams
:error   rts

ReadHS   jsr    MLI   ; open to read, failure is ok
         dfb    $c8
         da     OpenPraams
         bcs    :error
         lda    RefNum
         sta    RefNumR
         sta    RefNumC
         jsr    MLI   ; read 256 bytes
         dfb    $ca
         da     ReadParams
         jsr    MLI   ; close
         dfb    $cc
         da     CloseParams
         ldy   #$0f
:next    lda   IOBUFFER,y
         cmp   MAGIC,y
         beq   :error
         dey
         bne   :next
:error   rts

SaveHS   jsr    MLI   ; open to write on failure, try create
         dfb    $c8
         da     OpenPraams
         bcc    :ok
         jsr    MLI   ; create the file
         dfb    $c0
         da     CreatePraams
         jsr    MLI   ; open to write, failure is ok skip
         dfb    $c8
         da     OpenPraams
         bcs    :error
:ok      lda    RefNum
         sta    RefNumW
         sta    RefNumC
         jsr    MLI   ; write 256 bytes
         dfb    $cb
         da     WriteParams
         jsr    MLI   ; close
         dfb    $cc
         da     CloseParams
:error   rts

Filename dfb   $0c
         asc   'TOTALLY.HIGH   '

PrefixParams
         dfb   1
         dw    PDOS_io_buffer

OpenPraams
         dfb   3
         dw    Filename
         dw    PDOS_io_buffer
RefNum   dfb   0

CreatePraams
         dfb   7
         dw    Filename
         dfb   $c3
         dfb   $06
         dfb   0,0
         dfb   1
         dfb   0,0
         dfb   0,0

ReadParams
         dfb   4
RefNumR  dfb   0
         dw    IOBUFFER   ;IO buffer
         dw    $0100
         dw    $0000

WriteParams
         dfb   4
RefNumW  dfb   0
         dw    IOBUFFER   ;IO buffer
         dw    $0100
         dw    $0000

CloseParams
         dfb   1
RefNumC  dfb   0

         ds    \
PDOS_io_buffer            ; ProDOS I/O buffer: 1K, page aligned
         ds    1024

* per-level tables for various things

EntityCountTable         ; Note: clamped  to level 16
         dfb   7          ; number of active entites per level [1,N] (MaxEntities max)
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7
         dfb   7

EntityNTable              ; Note: clamped  to level 16
         dfb   10        ;number of entites to kill to complete the level
         dfb   12
         dfb   14
         dfb   16
         dfb   18
         dfb   20
         dfb   22
         dfb   24
         dfb   26
         dfb   28
         dfb   30
         dfb   32
         dfb   34
         dfb   36
         dfb   38
         dfb   40        ; end of num entites table

ScoreTable                ;Note: clamp to level 16
         dfb   $01        ;score amount per entity at each level. 16 levels
         dfb   $01
         dfb   $01
         dfb   $02
         dfb   $02
         dfb   $02
         dfb   $03
         dfb   $03
         dfb   $03
         dfb   $04
         dfb   $04
         dfb   $04
         dfb   $05
         dfb   $05
         dfb   $05
         dfb   $05        ; end of score table

* Entity images start here
         ds    \          ; page align these
EntityImgTables
         put   ENTITY_IMAGES.S      ; 16 levels
         put   SEU_ENTITY_IMAGES.S  ; 16 more levels


* Entity path tables start here (8 of them, page aligned)
         put   ENTITY_PATHS.S
