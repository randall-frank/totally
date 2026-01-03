         ds    \          ; page align these

* These are the images for the Entities
* There are 20 entities, the first 16 are used
* Each Entity is $E0 bytes (7*$20), but is padded to one page
* An entity is 9 rows of 3 bytes.  There are 7 pre-shifted 
* images.  Each is 9*3 + 5 bytes = $20 bytes (5 bytes are unused padding)


EntityImgTables
* Entity image #0
* Shift #0
         hex   000000    ;                      
         hex   2a1d00    ;  * * * * ***         
         hex   550c00    ; * * * *  **          
         hex   141900    ;   * *  *  **         
         hex   102a00    ;     *   * * *        
         hex   141900    ;   * *  *  **         
         hex   550c00    ; * * * *  **          
         hex   2a1d00    ;  * * * * ***         
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   2a1d00    ;  * * * * ***         
         hex   550c00    ; * * * *  **          
         hex   141900    ;   * *  *  **         
         hex   102a00    ;     *   * * *        
         hex   141900    ;   * *  *  **         
         hex   550c00    ; * * * *  **          
         hex   2a1d00    ;  * * * * ***         
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   287500    ;    * * * * ***       
         hex   543200    ;   * * * *  **        
         hex   506400    ;     * *  *  **       
         hex   402801    ;       *   * * *      
         hex   506400    ;     * *  *  **       
         hex   543200    ;   * * * *  **        
         hex   287500    ;    * * * * ***       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   287500    ;    * * * * ***       
         hex   543200    ;   * * * *  **        
         hex   506400    ;     * *  *  **       
         hex   402801    ;       *   * * *      
         hex   506400    ;     * *  *  **       
         hex   543200    ;   * * * *  **        
         hex   287500    ;    * * * * ***       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   205503    ;      * * * * ***     
         hex   504a01    ;     * * * *  **      
         hex   401203    ;       * *  *  **     
         hex   002205    ;         *   * * *    
         hex   401203    ;       * *  *  **     
         hex   504a01    ;     * * * *  **      
         hex   205503    ;      * * * * ***     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   205503    ;      * * * * ***     
         hex   504a01    ;     * * * *  **      
         hex   401203    ;       * *  *  **     
         hex   002205    ;         *   * * *    
         hex   401203    ;       * *  *  **     
         hex   504a01    ;     * * * *  **      
         hex   205503    ;      * * * * ***     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   00550e    ;        * * * * ***   
         hex   402a06    ;       * * * *  **    
         hex   004a0a    ;         * *  * * *   
         hex   000815    ;           *   * * *  
         hex   004a0a    ;         * *  * * *   
         hex   402a06    ;       * * * *  **    
         hex   00550e    ;        * * * * ***   
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #1
* Shift #0
         hex   000000    ;                      
         hex   100900    ;     *  *  *          
         hex   100900    ;     *  *  *          
         hex   780a00    ;    **** * *          
         hex   0f7a00    ; ****    * ****       
         hex   780a00    ;    **** * *          
         hex   100900    ;     *  *  *          
         hex   100900    ;     *  *  *          
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   080900    ;    *   *  *          
         hex   100900    ;     *  *  *          
         hex   701501    ;     **** * *  *      
         hex   1c7400    ;   ***    * ***       
         hex   721500    ;  *  **** * *         
         hex   401400    ;       *  * *         
         hex   402400    ;       *  *  *        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   080900    ;    *   *  *          
         hex   100901    ;     *  *  *   *      
         hex   606b00    ;      **** * **       
         hex   306800    ;     **    * **       
         hex   682b00    ;    * **** * *        
         hex   045101    ;   *    *   * **      
         hex   001100    ;        *   *         
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   004900    ;        *  *  *       
         hex   004900    ;        *  *  *       
         hex   405700    ;       **** * *       
         hex   785007    ;    ****    * ****    
         hex   405700    ;       **** * *       
         hex   004900    ;        *  *  *       
         hex   004900    ;        *  *  *       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   404800    ;       *   *  *       
         hex   004900    ;        *  *  *       
         hex   002f09    ;        **** * *  *   
         hex   602107    ;      ***    * ***    
         hex   102f01    ;     *  **** * *      
         hex   002401    ;          *  * *      
         hex   002402    ;          *  *  *     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   404800    ;       *   *  *       
         hex   004810    ;           *  *    *  
         hex   005e0a    ;         **** * * *   
         hex   004306    ;        **    * **    
         hex   405e02    ;       * **** * *     
         hex   20080d    ;      *    *   * **   
         hex   000801    ;           *   *      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   004804    ;           *  *  *    
         hex   004804    ;           *  *  *    
         hex   003c05    ;          **** * *    
         hex   40073d    ;       ****    * **** 
         hex   003c05    ;          **** * *    
         hex   004804    ;           *  *  *    
         hex   004804    ;           *  *  *    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #2
* Shift #0
         hex   000000    ;                      
         hex   005000    ;            * *       
         hex   045400    ;   *      * * *       
         hex   041500    ;   *    * * *         
         hex   7f0500    ; ******** *           
         hex   041500    ;   *    * * *         
         hex   045400    ;   *      * * *       
         hex   005000    ;            * *       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   002001    ;             * *      
         hex   082801    ;    *      * * *      
         hex   082a00    ;    *    * * *        
         hex   7e0b00    ;  ******** *          
         hex   082a00    ;    *    * * *        
         hex   082801    ;    *      * * *      
         hex   002001    ;             * *      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   004002    ;              * *     
         hex   105002    ;     *      * * *     
         hex   105400    ;     *    * * *       
         hex   7c1700    ;   ******** *         
         hex   105400    ;     *    * * *       
         hex   105002    ;     *      * * *     
         hex   004002    ;              * *     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   000005    ;               * *    
         hex   102005    ;     *       * * *    
         hex   202901    ;      * *  * * *      
         hex   782f00    ;    ******** *        
         hex   202801    ;      *    * * *      
         hex   102005    ;     *       * * *    
         hex   000005    ;               * *    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   00000a    ;                * *   
         hex   20402a    ;      *       * * * * 
         hex   405202    ;       * *  * * *     
         hex   705f00    ;     ******** *       
         hex   505002    ;     * *    * * *     
         hex   00412a    ;        *     * * * * 
         hex   00000a    ;                * *   
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   000014    ;                 * *  
         hex   200415    ;      *   *    * * *  
         hex   402205    ;       * *   * * *    
         hex   603f01    ;      ******** *      
         hex   402205    ;       * *   * * *    
         hex   200415    ;      *   *    * * *  
         hex   000014    ;                 * *  
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   000028    ;                  * * 
         hex   00402a    ;              * * * * 
         hex   40450a    ;       ** *   * * *   
         hex   407f02    ;       ******** *     
         hex   00400a    ;              * * *   
         hex   00012a    ;        *       * * * 
         hex   000028    ;                  * * 
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #3
* Shift #0
         hex   000000    ;                      
         hex   0c0000    ;   **                 
         hex   1a4000    ;  * **        *       
         hex   7f7f00    ; **************       
         hex   307000    ;     **     ***       
         hex   207000    ;      *     ***       
         hex   404f00    ;       *****  *       
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   180000    ;    **                
         hex   340001    ;   * **        *      
         hex   7e7f01    ;  **************      
         hex   606001    ;      **     ***      
         hex   005f01    ;        ***** **      
         hex   000001    ;               *      
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   300000    ;     **               
         hex   680002    ;    * **        *     
         hex   7c7f03    ;   **************     
         hex   404103    ;       **     ***     
         hex   004103    ;        *     ***     
         hex   003e02    ;         *****  *     
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   600000    ;      **              
         hex   500104    ;     * **        *    
         hex   787f07    ;    **************    
         hex   000307    ;        **     ***    
         hex   000207    ;         *     ***    
         hex   000205    ;         *     * *    
         hex   007c00    ;          *****       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   400100    ;       **             
         hex   200308    ;      * **        *   
         hex   707f0f    ;     **************   
         hex   00060e    ;         **     ***   
         hex   00040e    ;          *     ***   
         hex   00040a    ;          *     * *   
         hex   007801    ;           *****      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   000300    ;        **            
         hex   400610    ;       * **        *  
         hex   607f1f    ;      **************  
         hex   000c1c    ;          **     ***  
         hex   00081c    ;           *     ***  
         hex   000814    ;           *     * *  
         hex   007003    ;            *****     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   000600    ;         **           
         hex   000d20    ;        * **        * 
         hex   407f3f    ;       ************** 
         hex   001838    ;           **     *** 
         hex   001038    ;            *     *** 
         hex   006027    ;             *****  * 
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #4
* Shift #0
         hex   000000    ;                      
         hex   002000    ;             *        
         hex   707f00    ;     **********       
         hex   382800    ;    ***    * *        
         hex   382800    ;    ***    * *        
         hex   382800    ;    ***    * *        
         hex   707f00    ;     **********       
         hex   002000    ;             *        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   004000    ;              *       
         hex   607f01    ;      **********      
         hex   785100    ;    *****   * *       
         hex   785100    ;    *****   * *       
         hex   785100    ;    *****   * *       
         hex   607f01    ;      **********      
         hex   004000    ;              *       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   000001    ;               *      
         hex   407f03    ;       **********     
         hex   782701    ;    *******  * *      
         hex   782701    ;    *******  * *      
         hex   782701    ;    *******  * *      
         hex   407f03    ;       **********     
         hex   000001    ;               *      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   000002    ;                *     
         hex   007f07    ;        **********    
         hex   785f02    ;    ********* * *     
         hex   785f02    ;    ********* * *     
         hex   785f02    ;    ********* * *     
         hex   007f07    ;        **********    
         hex   000002    ;                *     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   000004    ;                 *    
         hex   007e0f    ;         **********   
         hex   601f05    ;      *******  * *    
         hex   601f05    ;      *******  * *    
         hex   601f05    ;      *******  * *    
         hex   007e0f    ;         **********   
         hex   000004    ;                 *    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   000008    ;                  *   
         hex   007c1f    ;          **********  
         hex   001f0a    ;        *****   * *   
         hex   001f0a    ;        *****   * *   
         hex   001f0a    ;        *****   * *   
         hex   007c1f    ;          **********  
         hex   000008    ;                  *   
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   000010    ;                   *  
         hex   00783f    ;           ********** 
         hex   001c14    ;          ***    * *  
         hex   001c14    ;          ***    * *  
         hex   001c14    ;          ***    * *  
         hex   00783f    ;           ********** 
         hex   000010    ;                   *  
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #5
* Shift #0
         hex   000000    ;                      
         hex   700700    ;     ******           
         hex   0e3800    ;  ***      ***        
         hex   214200    ; *    *  *    *       
         hex   094800    ; *  *      *  *       
         hex   714700    ; *   ******   *       
         hex   0e3800    ;  ***      ***        
         hex   700700    ;     ******           
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   600f00    ;      ******          
         hex   1c7000    ;   ***      ***       
         hex   020801    ;  *        *   *      
         hex   220c01    ;  *   *   **   *      
         hex   020301    ;  *     **     *      
         hex   1c7000    ;   ***      ***       
         hex   600f00    ;      ******          
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   401f00    ;       ******         
         hex   386001    ;    ***      ***      
         hex   041902    ;   *    *  **   *     
         hex   042002    ;   *         *  *     
         hex   041902    ;   *    *  **   *     
         hex   386001    ;    ***      ***      
         hex   401f00    ;       ******         
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   003f00    ;        ******        
         hex   704003    ;     ***      ***     
         hex   080c04    ;    *     **     *    
         hex   083104    ;    *   *   **   *    
         hex   082404    ;    *     *  *   *    
         hex   704003    ;     ***      ***     
         hex   003f00    ;        ******        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   007e00    ;         ******       
         hex   600107    ;      ***      ***    
         hex   107e08    ;     *   ******   *   
         hex   100109    ;     *  *      *  *   
         hex   102408    ;     *    *  *    *   
         hex   600107    ;      ***      ***    
         hex   007e00    ;         ******       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   007c01    ;          ******      
         hex   40030e    ;       ***      ***   
         hex   206010    ;      *      **    *  
         hex   201012    ;      *     *   *  *  
         hex   204810    ;      *    *  *    *  
         hex   40030e    ;       ***      ***   
         hex   007c01    ;          ******      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   007803    ;           ******     
         hex   00071c    ;        ***      ***  
         hex   402021    ;       *     * *    * 
         hex   400820    ;       *   *        * 
         hex   407020    ;       *    ***     * 
         hex   00071c    ;        ***      ***  
         hex   007803    ;           ******     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #6
* Shift #0
         hex   000000    ;                      
         hex   412a00    ; *     * * * *        
         hex   410000    ; *     *              
         hex   410000    ; *     *              
         hex   552a00    ; * * * * * * *        
         hex   402000    ;       *     *        
         hex   402000    ;       *     *        
         hex   552000    ; * * * *     *        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   025500    ;  *     * * * *       
         hex   020100    ;  *     *             
         hex   020100    ;  *     *             
         hex   2a5500    ;  * * * * * * *       
         hex   004100    ;        *     *       
         hex   004100    ;        *     *       
         hex   2a4100    ;  * * * *     *       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   540201    ;   * * * *     *      
         hex   102001    ;     *       * *      
         hex   400801    ;       *   *   *      
         hex   040201    ;   *     *     *      
         hex   440800    ;   *   *   *          
         hex   142000    ;   * *       *        
         hex   042a01    ;   *     * * * *      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   280502    ;    * * * *     *     
         hex   204002    ;      *       * *     
         hex   001102    ;        *   *   *     
         hex   080402    ;    *     *     *     
         hex   081100    ;    *   *   *         
         hex   284000    ;    * *       *       
         hex   085402    ;    *     * * * *     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   500a04    ;     * * * *     *    
         hex   400005    ;       *       * *    
         hex   002204    ;         *   *   *    
         hex   100804    ;     *     *     *    
         hex   102200    ;     *   *   *        
         hex   500001    ;     * *       *      
         hex   102805    ;     *     * * * *    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   201508    ;      * * * *     *   
         hex   00010a    ;        *       * *   
         hex   004408    ;          *   *   *   
         hex   201008    ;      *     *     *   
         hex   204400    ;      *   *   *       
         hex   200102    ;      * *       *     
         hex   20500a    ;      *     * * * *   
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   402015    ;       *     * * * *  
         hex   402000    ;       *     *        
         hex   402000    ;       *     *        
         hex   402a15    ;       * * * * * * *  
         hex   002010    ;             *     *  
         hex   002010    ;             *     *  
         hex   402a10    ;       * * * *     *  
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #7
* Shift #0
         hex   000000    ;                      
         hex   7f7f00    ; **************       
         hex   554400    ; * * * *  *   *       
         hex   555400    ; * * * *  * * *       
         hex   554400    ; * * * *  *   *       
         hex   555400    ; * * * *  * * *       
         hex   554400    ; * * * *  *   *       
         hex   7f7f00    ; **************       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   7e7f01    ;  **************      
         hex   120901    ;  *  *  *  *   *      
         hex   4a2c01    ;  * *  *  ** * *      
         hex   260a01    ;  **  *  * *   *      
         hex   122901    ;  *  *  *  * * *      
         hex   4a0c01    ;  * *  *  **   *      
         hex   7e7f01    ;  **************      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   7c7f03    ;   **************     
         hex   141902    ;   * *  *  **   *     
         hex   4c5402    ;   **  *  * * * *     
         hex   241202    ;   *  *  *  *   *     
         hex   145902    ;   * *  *  ** * *     
         hex   4c1402    ;   **  *  * *   *     
         hex   7c7f03    ;   **************     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   787f07    ;    **************    
         hex   082004    ;    *        *   *    
         hex   783f05    ;    ********** * *    
         hex   082004    ;    *        *   *    
         hex   783f05    ;    ********** * *    
         hex   082004    ;    *        *   *    
         hex   787f07    ;    **************    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   707f0f    ;     **************   
         hex   305208    ;     **  *  * *   *   
         hex   50640a    ;     * *  *  ** * *   
         hex   104908    ;     *  *  *  *   *   
         hex   30520a    ;     **  *  * * * *   
         hex   506408    ;     * *  *  **   *   
         hex   707f0f    ;     **************   
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   607f1f    ;      **************  
         hex   201211    ;      *  *  *  *   *  
         hex   602415    ;      **  *  * * * *  
         hex   204911    ;      * *  *  **   *  
         hex   201215    ;      *  *  *  * * *  
         hex   602411    ;      **  *  * *   *  
         hex   607f1f    ;      **************  
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   407f3f    ;       ************** 
         hex   402a22    ;       * * * *  *   * 
         hex   402a2a    ;       * * * *  * * * 
         hex   402a22    ;       * * * *  *   * 
         hex   402a2a    ;       * * * *  * * * 
         hex   402a22    ;       * * * *  *   * 
         hex   407f3f    ;       ************** 
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #8
* Shift #0
         hex   000000    ;                      
         hex   600700    ;      *****           
         hex   704f00    ;     *******  *       
         hex   3f2c00    ; ******   ** *        
         hex   301c00    ;     **   ***         
         hex   3f2c00    ; ******   ** *        
         hex   704f00    ;     *******  *       
         hex   600700    ;      *****           
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   400f00    ;       *****          
         hex   6c1f01    ;   ** *******  *      
         hex   725800    ;  *  ***   ** *       
         hex   603800    ;      **   ***        
         hex   725800    ;  *  ***   ** *       
         hex   6c1f01    ;   ** *******  *      
         hex   400f00    ;       *****          
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   081f00    ;    *   *****         
         hex   542002    ;   * * *     *  *     
         hex   602e01    ;      ** *** * *      
         hex   406a00    ;       * * * **       
         hex   602e01    ;      ** *** * *      
         hex   542002    ;   * * *     *  *     
         hex   081f00    ;    *   *****         
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   103e00    ;     *   *****        
         hex   284104    ;    * * *     *  *    
         hex   405d02    ;       ** *** * *     
         hex   005501    ;        * * * **      
         hex   405d02    ;       ** *** * *     
         hex   284104    ;    * * *     *  *    
         hex   103e00    ;     *   *****        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   007c00    ;          *****       
         hex   600209    ;      ** *     *  *   
         hex   100305    ;     *  **     * *    
         hex   001203    ;         *  *  **     
         hex   100305    ;     *  **     * *    
         hex   600209    ;      ** *     *  *   
         hex   007c00    ;          *****       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   007801    ;           *****      
         hex   000412    ;          *     *  *  
         hex   60070a    ;      *****     * *   
         hex   002406    ;          *  *  **    
         hex   60070a    ;      *****     * *   
         hex   000412    ;          *     *  *  
         hex   007801    ;           *****      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   007003    ;            *****     
         hex   000824    ;           *     *  * 
         hex   400f14    ;       *****     * *  
         hex   00480c    ;           *  *  **   
         hex   400f14    ;       *****     * *  
         hex   000824    ;           *     *  * 
         hex   007003    ;            *****     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #9
* Shift #0
         hex   000000    ;                      
         hex   700700    ;     ******           
         hex   7e3f00    ;  ************        
         hex   7f7f00    ; **************       
         hex   7f7f00    ; **************       
         hex   7f7f00    ; **************       
         hex   7e3f00    ;  ************        
         hex   700700    ;     ******           
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   000300    ;        **            
         hex   400700    ;       ****           
         hex   400700    ;       ****           
         hex   600f00    ;      ******          
         hex   400700    ;       ****           
         hex   400700    ;       ****           
         hex   000300    ;        **            
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   000600    ;         **           
         hex   000f00    ;        ****          
         hex   000f00    ;        ****          
         hex   401f00    ;       ******         
         hex   000f00    ;        ****          
         hex   000f00    ;        ****          
         hex   000600    ;         **           
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   000000    ;                      
         hex   000c00    ;          **          
         hex   707f03    ;     ************     
         hex   787f07    ;    **************    
         hex   707f03    ;     ************     
         hex   000c00    ;          **          
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   000000    ;                      
         hex   001800    ;           **         
         hex   607f07    ;      ************    
         hex   707f0f    ;     **************   
         hex   607f07    ;      ************    
         hex   001800    ;           **         
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   007c01    ;          ******      
         hex   407f0f    ;       ************   
         hex   607f1f    ;      **************  
         hex   607f1f    ;      **************  
         hex   607f1f    ;      **************  
         hex   407f0f    ;       ************   
         hex   007c01    ;          ******      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   007803    ;           ******     
         hex   007f1f    ;        ************  
         hex   407f3f    ;       ************** 
         hex   407f3f    ;       ************** 
         hex   407f3f    ;       ************** 
         hex   007f1f    ;        ************  
         hex   007803    ;           ******     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #10
* Shift #0
         hex   000000    ;                      
         hex   000700    ;        ***           
         hex   001a00    ;         * **         
         hex   002200    ;         *   *        
         hex   2a4500    ;  * * * * *   *       
         hex   002200    ;         *   *        
         hex   001a00    ;         * **         
         hex   000700    ;        ***           
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   400e00    ;       * ***          
         hex   003400    ;          * **        
         hex   004400    ;          *   *       
         hex   500a01    ;     * * * *   *      
         hex   004400    ;          *   *       
         hex   003400    ;          * **        
         hex   400e00    ;       * ***          
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   201d00    ;      * * ***         
         hex   006800    ;           * **       
         hex   000801    ;           *   *      
         hex   001502    ;        * * *   *     
         hex   000801    ;           *   *      
         hex   006800    ;           * **       
         hex   201d00    ;      * * ***         
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   503a00    ;     * * * ***        
         hex   005001    ;            * **      
         hex   001002    ;            *   *     
         hex   002804    ;           * *   *    
         hex   001002    ;            *   *     
         hex   005001    ;            * **      
         hex   503a00    ;     * * * ***        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   007500    ;        * * ***       
         hex   002003    ;             * **     
         hex   002004    ;             *   *    
         hex   005408    ;          * * *   *   
         hex   002004    ;             *   *    
         hex   002003    ;             * **     
         hex   007500    ;        * * ***       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   006801    ;           * ***      
         hex   004006    ;              * **    
         hex   004008    ;              *   *   
         hex   002a11    ;         * * * *   *  
         hex   004008    ;              *   *   
         hex   004006    ;              * **    
         hex   006801    ;           * ***      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   004003    ;              ***     
         hex   00000d    ;               * **   
         hex   000011    ;               *   *  
         hex   005522    ;        * * * * *   * 
         hex   000011    ;               *   *  
         hex   00000d    ;               * **   
         hex   004003    ;              ***     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #11
* Shift #0
         hex   000000    ;                      
         hex   055000    ; * *        * *       
         hex   655300    ; * *  ****  * *       
         hex   522500    ;  *  * ** *  *        
         hex   4e3900    ;  ***  **  ***        
         hex   100400    ;     *    *           
         hex   600300    ;      ****            
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   0a2001    ;  * *        * *      
         hex   4a2701    ;  * *  ****  * *      
         hex   244b00    ;   *  * ** *  *       
         hex   1c7300    ;   ***  **  ***       
         hex   200800    ;      *    *          
         hex   400700    ;       ****           
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   144002    ;   * *        * *     
         hex   144002    ;   * *        * *     
         hex   481f01    ;    *  ******  *      
         hex   386601    ;    ***  **  ***      
         hex   401600    ;       * ** *         
         hex   000f00    ;        ****          
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   280005    ;    * *        * *    
         hex   280005    ;    * *        * *    
         hex   103f02    ;     *  ******  *     
         hex   704c03    ;     ***  **  ***     
         hex   003f00    ;        ******        
         hex   000000    ;                      
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   000000    ;                      
         hex   000000    ;                      
         hex   000000    ;                      
         hex   607f07    ;      ************    
         hex   207e04    ;      *  ******  *    
         hex   50180a    ;     * *   **   * *   
         hex   50000a    ;     * *        * *   
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   000000    ;                      
         hex   000000    ;                      
         hex   007c01    ;          ******      
         hex   40330e    ;       ***  **  ***   
         hex   407c09    ;       *  ******  *   
         hex   200114    ;      * *        * *  
         hex   200114    ;      * *        * *  
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   000000    ;                      
         hex   007001    ;            ****      
         hex   006802    ;           * ** *     
         hex   00671c    ;        ***  **  ***  
         hex   000912    ;        *  *    *  *  
         hex   407229    ;       * *  ****  * * 
         hex   400228    ;       * *        * * 
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #12
* Shift #0
         hex   000000    ;                      
         hex   7e3f00    ;  ************        
         hex   414100    ; *     **     *       
         hex   414100    ; *     **     *       
         hex   5d5d00    ; * *** ** *** *       
         hex   5d5d00    ; * *** ** *** *       
         hex   414100    ; *     **     *       
         hex   7e3f00    ;  ************        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   7c7f00    ;   ************       
         hex   027f01    ;  *     ********      
         hex   020301    ;  *     **     *      
         hex   023b01    ;  *     ** *** *      
         hex   3a3b01    ;  * *** ** *** *      
         hex   3a0301    ;  * *** **     *      
         hex   7c7f00    ;   ************       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   787f01    ;    ************      
         hex   047e03    ;   *     ********     
         hex   047e03    ;   *     ********     
         hex   747602    ;   * *** ** *** *     
         hex   747602    ;   * *** ** *** *     
         hex   040602    ;   *     **     *     
         hex   787f01    ;    ************      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   707f03    ;     ************     
         hex   087c07    ;    *     ********    
         hex   687d07    ;    * *** ********    
         hex   687d07    ;    * *** ********    
         hex   086c05    ;    *     ** *** *    
         hex   080c04    ;    *     **     *    
         hex   707f03    ;     ************     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   607f07    ;      ************    
         hex   507b0f    ;     * *** ********   
         hex   507b0f    ;     * *** ********   
         hex   10780f    ;     *     ********   
         hex   10780f    ;     *     ********   
         hex   101808    ;     *     **     *   
         hex   607f07    ;      ************    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   407f0f    ;       ************   
         hex   20701f    ;      *     ********  
         hex   20771f    ;      * *** ********  
         hex   20771f    ;      * *** ********  
         hex   20701f    ;      *     ********  
         hex   20701f    ;      *     ********  
         hex   407f0f    ;       ************   
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   007f1f    ;        ************  
         hex   406020    ;       *     **     * 
         hex   406020    ;       *     **     * 
         hex   406e2e    ;       * *** ** *** * 
         hex   406e2e    ;       * *** ** *** * 
         hex   406020    ;       *     **     * 
         hex   007f1f    ;        ************  
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #13
* Shift #0
         hex   000000    ;                      
         hex   680700    ;    * *****           
         hex   000400    ;          *           
         hex   7e0f00    ;  **********          
         hex   2b3500    ; ** * * * * **        
         hex   7e2f00    ;  ********** *        
         hex   000400    ;          *           
         hex   680700    ;    * *****           
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   500f00    ;     * *****          
         hex   000800    ;           *          
         hex   7c1f00    ;   **********         
         hex   566a00    ;  ** * * * * **       
         hex   7c5f00    ;   ********** *       
         hex   000800    ;           *          
         hex   500f00    ;     * *****          
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   201f00    ;      * *****         
         hex   001000    ;            *         
         hex   781f01    ;    *********  *      
         hex   2c7500    ;   ** * * * ***       
         hex   785f00    ;    ********* *       
         hex   001000    ;            *         
         hex   201f00    ;      * *****         
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   403e00    ;       * *****        
         hex   002000    ;             *        
         hex   703f04    ;     *********   *    
         hex   586a01    ;    ** * * * ***      
         hex   707f02    ;     ********** *     
         hex   002000    ;             *        
         hex   403e00    ;       * *****        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   007d00    ;        * *****       
         hex   004000    ;              *       
         hex   607f08    ;      *********   *   
         hex   305503    ;     ** * * * ***     
         hex   607f05    ;      ********** *    
         hex   004000    ;              *       
         hex   007d00    ;        * *****       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   007a01    ;         * *****      
         hex   000001    ;               *      
         hex   407f07    ;       ***********    
         hex   602a1f    ;      ** * * * *****  
         hex   407f0b    ;       ********** *   
         hex   000001    ;               *      
         hex   007a01    ;         * *****      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   007403    ;          * *****     
         hex   000002    ;                *     
         hex   007f0f    ;        ***********   
         hex   40553e    ;       ** * * * ***** 
         hex   007f17    ;        ********** *  
         hex   000002    ;                *     
         hex   007403    ;          * *****     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #14
* Shift #0
         hex   000000    ;                      
         hex   7f0000    ; *******              
         hex   410000    ; *     *              
         hex   410000    ; *     *              
         hex   490800    ; *  *  *   *          
         hex   410000    ; *     *              
         hex   410000    ; *     *              
         hex   7f0000    ; *******              
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   000000    ;                      
         hex   7e0000    ;  ******              
         hex   423800    ;  *    *   ***        
         hex   523800    ;  *  * *   ***        
         hex   423800    ;  *    *   ***        
         hex   7e0000    ;  ******              
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   000000    ;                      
         hex   007801    ;           *****      
         hex   700801    ;     ***   *   *      
         hex   702801    ;     ***   * * *      
         hex   700801    ;     ***   *   *      
         hex   007801    ;           *****      
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   007807    ;           *******    
         hex   000804    ;           *     *    
         hex   000804    ;           *     *    
         hex   404804    ;       *   *  *  *    
         hex   000804    ;           *     *    
         hex   000804    ;           *     *    
         hex   007807    ;           *******    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   000000    ;                      
         hex   006007    ;             *****    
         hex   402304    ;       ***   *   *    
         hex   402305    ;       ***   * * *    
         hex   402304    ;       ***   *   *    
         hex   006007    ;             *****    
         hex   000000    ;                      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   000000    ;                      
         hex   400f00    ;       *****         
         hex   400807    ;       *   *   ***    
         hex   400a07    ;       * * *   ***    
         hex   400807    ;       *   *   ***    
         hex   400f00    ;       *****          
         hex   000000    ;                      
         hex   000000    ;                     
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   403f00    ;       *******        
         hex   402000    ;       *     *        
         hex   402000    ;       *     *        
         hex   402404    ;       *  *  *   *    
         hex   402000    ;       *     *        
         hex   402000    ;       *     *        
         hex   403f00    ;       *******        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #15
* Shift #0
         hex   000000    ;                      
         hex   7f3f00    ; *************        
         hex   4f2400    ; ****  *  *  *        
         hex   4f2400    ; ****  *  *  *        
         hex   7f3f00    ; *************        
         hex   4f2400    ; ****  *  *  *        
         hex   4f2400    ; ****  *  *  *        
         hex   7f3f00    ; *************        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   7e7f00    ;  *************       
         hex   1e4900    ;  ****  *  *  *       
         hex   1e4900    ;  ****  *  *  *       
         hex   7e7f00    ;  *************       
         hex   1e4900    ;  ****  *  *  *       
         hex   1e4900    ;  ****  *  *  *       
         hex   7e7f00    ;  *************       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   7c7f01    ;   *************      
         hex   641301    ;   *  ****  *  *      
         hex   641301    ;   *  ****  *  *      
         hex   7c7f01    ;   *************      
         hex   641301    ;   *  ****  *  *      
         hex   641301    ;   *  ****  *  *      
         hex   7c7f01    ;   *************      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   787f03    ;    *************     
         hex   482702    ;    *  ****  *  *     
         hex   482702    ;    *  ****  *  *     
         hex   787f03    ;    *************     
         hex   482702    ;    *  ****  *  *     
         hex   482702    ;    *  ****  *  *     
         hex   787f03    ;    *************     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   707f07    ;     *************    
         hex   107904    ;     *  *  ****  *    
         hex   107904    ;     *  *  ****  *    
         hex   707f07    ;     *************    
         hex   107904    ;     *  *  ****  *    
         hex   107904    ;     *  *  ****  *    
         hex   707f07    ;     *************    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   607f0f    ;      *************   
         hex   207209    ;      *  *  ****  *   
         hex   207209    ;      *  *  ****  *   
         hex   607f0f    ;      *************   
         hex   207209    ;      *  *  ****  *   
         hex   207209    ;      *  *  ****  *   
         hex   607f0f    ;      *************   
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   407f1f    ;       *************  
         hex   40241e    ;       *  *  *  ****  
         hex   40241e    ;       *  *  *  ****  
         hex   407f1f    ;       *************  
         hex   40241e    ;       *  *  *  ****  
         hex   40241e    ;       *  *  *  ****  
         hex   407f1f    ;       *************  
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary

* Entity image #16
* Shift #0
         hex   000000    ;                      
         hex   100900    ;     *  *  *          
         hex   100900    ;     *  *  *          
         hex   780a00    ;    **** * *          
         hex   0f7a00    ; ****    * ****       
         hex   780a00    ;    **** * *          
         hex   100900    ;     *  *  *          
         hex   100900    ;     *  *  *          
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #1
         hex   000000    ;                      
         hex   080900    ;    *   *  *          
         hex   100900    ;     *  *  *          
         hex   701501    ;     **** * *  *      
         hex   1c7400    ;   ***    * ***       
         hex   721500    ;  *  **** * *         
         hex   401400    ;       *  * *         
         hex   402400    ;       *  *  *        
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #2
         hex   000000    ;                      
         hex   080900    ;    *   *  *          
         hex   100901    ;     *  *  *   *      
         hex   606b00    ;      **** * **       
         hex   306800    ;     **    * **       
         hex   682b00    ;    * **** * *        
         hex   045101    ;   *    *   * **      
         hex   001100    ;        *   *         
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #3
         hex   000000    ;                      
         hex   004900    ;        *  *  *       
         hex   004900    ;        *  *  *       
         hex   405700    ;       **** * *       
         hex   785007    ;    ****    * ****    
         hex   405700    ;       **** * *       
         hex   004900    ;        *  *  *       
         hex   004900    ;        *  *  *       
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #4
         hex   000000    ;                      
         hex   404800    ;       *   *  *       
         hex   004900    ;        *  *  *       
         hex   002f09    ;        **** * *  *   
         hex   602107    ;      ***    * ***    
         hex   102f01    ;     *  **** * *      
         hex   002401    ;          *  * *      
         hex   002402    ;          *  *  *     
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #5
         hex   000000    ;                      
         hex   404800    ;       *   *  *       
         hex   004810    ;           *  *    *  
         hex   005e0a    ;         **** * * *   
         hex   004306    ;        **    * **    
         hex   405e02    ;       * **** * *     
         hex   20080d    ;      *    *   * **   
         hex   000801    ;           *   *      
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
* Shift #6
         hex   000000    ;                      
         hex   004804    ;           *  *  *    
         hex   004804    ;           *  *  *    
         hex   003c05    ;          **** * *    
         hex   40073d    ;       ****    * **** 
         hex   003c05    ;          **** * *    
         hex   004804    ;           *  *  *    
         hex   004804    ;           *  *  *    
         hex   000000    ;                      
         ds    5 ; pad to 32 bytes
         ds    32 ; pad to page boundary
