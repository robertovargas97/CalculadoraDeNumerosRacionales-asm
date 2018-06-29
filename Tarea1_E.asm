.model small
.386
.stack 100h
.data
  ms    db      10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,'                                             ---> s para salir',10,13,'                                             ---> c para borrar',10,10,13,'                                            ------------CALC-------------$'
  lin00 db      10,13,'                                            *---------------------------*$' 
  lin01 db      10,13,'                                            |                           |$'
  lin0  db      10,13,'                                            |                           |$'
  lin1  db      10,13,'                                            *---------------------------*$'
  lin2  db      10,13,'                                            | *---* *---* *---*   +---+ |$' ;Se define la interfaz grafica
  lin3  db      10,13,'                                            | | 1 | | 2 | | 3 |   | + | |$'
  lin4  db      10,13,'                                            | *---* *---* *---*   +---+ |$'
  lin5  db      10,13,'                                            | *---* *---* *---*   +---+ |$'
  lin6  db      10,13,'                                            | | 4 | | 5 | | 6 |   | - | |$'
  lin7  db      10,13,'                                            | *---* *---* *---*   +---+ |$'
  lin8  db      10,13,'                                            | *---* *---* *---*   +---+ |$'
  lin9  db      10,13,'                                            | | 7 | | 8 | | 9 |   | C | |$'
  lin10 db      10,13,'                                            | *---* *---* *---*   +---+ |$'
  lin11 db      10,13,'                                            | +---+ +---* +---+   +---+ |$'
  lin12 db      10,13,'                                            | | * | | 0 | | / |   | S | |$'       ;Cada uno de los supuestos botones realiza algo
  lin13 db      10,13,'                                            | +---+ *---* +---+   +---+ |$'       ;Al presionar 'c' --> "limpia pantalla" y vuelve a iniciar
  lin14 db      10,13,'                                            *---------------------------*$'       ;Al presionar 's' --> Sale del programa
  lin15 db      10,13,'        $'
  lin16 db      10,13,'        $'
  lin17 db      10,13,'        $'
  lin18 db      10,13,'        $'
  msg3  db        10,13,'ERROR EN LA EXPRESION!',10,13,'(LIMITE DE 3 DIGITOS EXCEDIDO O' ,10,13,'INGRESO DE CARACTER INVALIDO)',10,13,'Presiona una tecla para continuar...$',10,13
  msg4  db        10,13,'NO ES POSIBLE DIVIR ENTRE 0',10,13,'Presiona una tecla para continuar...$',10,13
  msgMult db      10,13,'PARA OPERAR SOLO SE ADMITEN NUMEROS <= 150',10,13,'Presiona una tecla para continuar...$' ,10,13
  msgSeguir db    10,13,10,13,'SI DESEA SALIR PRESIONE S(s) ',10,13,'SINO PRESIONE CUALQUIER TECLA ' ,10,13,'PARA CALCULAR OTRA EXPRESION$',10,13
  msgExt    db    10,13,10,13,'HAS PRESIONADO S(s)',10,13,'SALISTE DEL PROGRAMA$'
  msg5  db        10,13,'ERROR NO HAS INGRESADO NINGUN NUMERO',10,13,'Presiona una tecla para continuar...$',10,13
  msg6  db        10,13,'Math ERROR',10,13,'Presiona una tecla para continuar...$',10,13
  ;Variables para numerador y denominador del primer numero
  
    vN    db  3 Dup(0)    ;vector que almacena el numerador del primer numero
    vD    db  3 Dup(0)    ;vector que almacena el denominador del primer numero
    cont  db  ?           ;indica la cantidad de digitos de numerador
    contD db  ?           ;indica la cantidad de digitos de denominador
  ;-------------------------------------------------------------------------------------------------------------
  
  ;------------Variables para numerador y denominador del segundo numero---------------------------------------
  vNumeradorDos         db  3 Dup(0)     ;vector que almacena el numerador del segundo numero
  vDenominadorDos       db  3 Dup(0)     ;vector que almacena el denominador del segundo numero
  contNumeradorDos      db  ?            ;indica la cantidad de digitos de numerador
  contDenominadorDos    db  ?            ;indica la cantidad de digitos de denominador
  ;-------------------------------------------------------------------------------------------------------------
  
  ;---------------------------Variables para operaciones numericas----------------------------------------------
  num1    dw  0  ;para guardar el numerador uno en valor numerico y asi realizar operaciones
  den1    dw  0  ;para guardar el denominador uno en valor numerico y asi realizar operaciones

  cnD     dw  0  ;para guardar el numerador 2 en valor numerico y asi realizar operaciones
  cdD     dw  0 ;para guardar el denominador 2 en valor numerico y asi realizar operaciones
  rslNUM  dw  0
  rslDEN  dw  0
  ;-------------------------------------------------------------------------------------------------------------
  ;---------------------------------Variables extra utiles----------------------------------------------------------------
   vGeneral     db  3 Dup(0) ;vector que ayudara a generalizar conversiones a valores numericos 
   contGeneral  db  ?   ;contador que ayudara a generalizar proc
   rslGeneral   dw  ?   ;variable para generalizar proc
   contGeneralD db  ?
   op           db  ?  ;variable que almacena el operador
   slr          db  ?  ;Variable bandera
   e            db  ?  ;Variable utilizada para error o borrar
   cen          db  0
   dece         db  0
   uni          db  0
   mil          db  0
   dmil         db  0
   confirm      db  0 ; Para confirmar la conversion del numerador 1
   print        dw  0
   printV       db  3 Dup(0)
  
 ;---------------------------------------------------------------------------------------------------------------- 
.code

main proc

inicio:
  mov ax,@data
  mov ds,ax
  mov e,0
  mov print,0
  
  call calc ; Pone el dibujillo de la calculadora en pantalla 
  call colocar_posicion
  call colocar_cursor
  
  call leerNum              ;Se lee el numerador de la primera fraccion
  cmp e,1                   ;si e == 1 hay un error 
  je inicio
  cmp slr,1
  je final
  call asignarVN            ;Se asigna el numerador a un vectorGeneral para poder poder operarlo
  call convertirNumero      ;Se convierte el numerador a un valor real para operarlo
  call limpiaGeneral
  
 
  call leerDen              ;Se lee el denominador de la primera fraccion
  cmp e,1                   ;si e == 1 hay un error 
  je inicio
  cmp slr,1
  je final
  call asignarVD             ;Se asigna el denominador a un vectorGeneral para poder poder operarlo
  call convertirNumero       ;Se convierte el denominador a un valor real para operarlo
  call limpiaGeneral
 
  
  call leerNumN              ;Se lee el numerador de la segunda fraccion
  cmp e,1                    ;si e == 1 hay un error 
  je inicio
   cmp slr,1
  je final
  call asignarvNumeradorDos  ;Se asigna el numeradorDos a un vectorGeneral para poder poder operarlo
  call convertirNumero       ;Se convierte el numerador a un valo real para operarlo
  call limpiaGeneral

  
  call leerDenD               ;Se lee el denominador de la segunda fraccion 
  cmp e,1                     ;si e == 1 hay un error 
  je inicio
  cmp slr,1
  je final
  call asignarvDenominadorDos ;Se asigna el denominadorDos a un vectorGeneral para poder poder operarlo
  call convertirDen2          ;Se convierte el numerador a un valo real para operarlo  
  call limpiaGeneral
  
  call vt                     ;Verifica si los numeros se ingresaron en el rango correcto para realizar operaciones
  cmp e,1
  je showResult
  
operacion:                    ;Si no hay errores se procede a realizar la operacionn deseada

  cmp op,'*'                  ;Verifica si es una multiplicacion para realizarla
  je hacerMult
  cmp op,'/'                  ;Verifica si es una division para realizarla
  je hacerDiv
  cmp op,'+'                  ;Verifica si es una suma para realizarla
  je hacerSum
  cmp op,'-'                  ;Verifica si es una resta para realizarla
  je hacerRest
  jmp final
  
hacerMult:                    ;Se llama al proceso para multiplicar
   call multiplicar
   jmp showResult
   
hacerDiv:                     ;Se llama al proceso para dividir
   call dividir
   jmp showResult
   
hacerSum:                     ;Se llama al proceso para sumar
   call sumar
   jmp showResult
   
hacerRest:                    ;Se llama al proceso para sumar
    call restar
    jmp showResult

showResult:  

   cmp e,1
   je deNuevo 
   cmp rslDEN,0
   je deNuevo
   cmp rslNum,0
   je deNuevo
                 ;Se muestra el resultado en pantalla
   mov ah,2
   mov dl ,' '
   int 21h
   
   xor ax,ax                 ;Limpi ax
   mov ax,rslNUM             ;Mueva a ax lo que se desea imprimir
   mov print,ax              ;Mueva a print lo que se desea imprimir
   call printVal             ;Se imprime el resulato
   
   mov ah,2
   mov dl ,'/'
   int 21h
   
   xor ax,ax                 ;Limpi ax
   mov ax,rslDEN             ;Mueva a ax lo que se desea imprimir
   mov print,ax              ;Mueva a print lo que se desea imprimir
   call printVal             ;Se imprime el resulato

deNuevo:
 cmp rslNum,0
 jne verDn
 mov ah,2
 mov dl ,'0'
 int 21h


verDn:
   cmp rslDEN,0
   jne s
   call mathError

s:   
   mov ah,9             ;Carga servicio 9 para leer cadenas
   lea dx,msgSeguir     ;Se carga el para seguir
   int 21h              ;Imprimimos el mensaje 
   mov ah,8             ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
   int 21h
   cmp al,'s'
   je final
   cmp al,'S'
   je final
   jmp inicio
   
final:   
    cmp slr,0
    jne msgSalida
    jmp finish

msgSalida:
    call hasSalido

finish:                    ;FIN DEL PROGRAMA
  mov ah,4ch
  int 21h  
  
main endp

; ---------------------------------------Procs para generalizar conversion------------------------------------------------------------
   
asignarVN proc near
  mov al,vN[0]          ;Pone en AL el valor que se encuentra en VN[0]
  mov vGeneral[0],al    ;Pone en vGeneral el valor que se encuentra en AL
  mov al,vN[1]          ;Pone en AL el valor que se encuentra en VN[1]
  mov vGeneral[1],al    ;Pone en vGeneral el valor que se encuentra en AL
  mov al,vN[2]          ;Pone en AL el valor que se encuentra en VN[2]
  mov vGeneral[2],al    ;Pone en vGeneral el valor que se encuentra en AL
  RET                   ;vGeneral queda con el numero deseado para asi comvertirlo
asignarVN endp
;-------------------------------------------------------------------------------------------------------------------------------------

asignarVD proc near
  mov al,vD[0]
  mov vGeneral[0],al
  mov al,vD[1]
  mov vGeneral[1],al
  mov al,vD[2]
  mov vGeneral[2],al
 RET
asignarVD endp
;-------------------------------------------------------------------------------------------------------------------------------------  
 
asignarvNumeradorDos proc near
  mov al,vNumeradorDos[0]
  mov vGeneral[0],al
  mov al,vNumeradorDos[1]
  mov vGeneral[1],al
  mov al,vNumeradorDos[2]
  mov vGeneral[2],al
 RET
asignarvNumeradorDos endp 

;-------------------------------------------------------------------------------------------------------------------------------------
asignarvDenominadorDos  proc near
  mov al,vDenominadorDos[0]
  mov vGeneral[0],al
  mov al,vDenominadorDos[1]
  mov vGeneral[1],al
  mov al,vDenominadorDos[2]
  mov vGeneral[2],al
 RET
asignarvDenominadorDos endp
;---------------------------------------------------------------------------------------------------------------------------  

;--------------------------------------------Mensajes de error-------------------------------------------------------------

muestraError proc near
 mov ah,9       ;Carga servicio 9 para leer cadenas
 lea dx,msg3    ;Se carga el mensaje de error de caracter invalido o limite excedido
 int 21h
 mov ah,8  ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
 int 21h

RET 
muestraError endp
;------------------------------------------------------------------------------------------------------------------------------
errorNoDigitos proc near
 mov ah,9       ;Carga servicio 9 para leer cadenas
 lea dx,msg5    ;Se carga el mensaje de no digitos ingresados
 int 21h
 mov ah,8  ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
 int 21h

RET 
errorNoDigitos endp

mathError proc near
 mov ah,9       ;Carga servicio 9 para leer cadenas
 lea dx,msg6    ;Se carga el mensaje de no digitos ingresados
 int 21h
 mov ah,8  ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
 int 21h

RET 
mathError endp

;---------------------------------------------------------------------------------------------------------------------------------
errorCero proc near
 mov ah,9       ;Carga servicio 9 para leer cadenas
 lea dx,msg4    ;Se carga el mensaje de no digitos ingresados
 int 21h
 mov ah,8  ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
 int 21h

RET 
errorCero endp
;---------------------------------------------------------------------------------------------------------------------------------
hasSalido proc near
 mov ah,9         ;Carga servicio 9 para leer cadenas
 lea dx,msgExt    ;Se carga el mensaje de no digitos ingresados
 int 21h

RET 
hasSalido endp
;---------------------------------------------------------------------------------------------------------------------------------

numeroMayor proc near

 mov ah,9
    lea dx,msgMult
    int 21h   ;Imprimimos el mensaje de error de expresion
    mov ah,8  ;Servicio 8 lee un caracter sin eco(no se imprime en pantalla), crea el efecto de presiona una tecla para continuar...
    int 21h
    mov e,1   ;Y hacemos a nuestra variable e a 1 para limpiar pantalla
RET

numeroMayor endp

;-------------------------------------------Lee el numerador de la fraccion 1---------------------------------------------
leerNum proc near
        mov e,0
        mov si,0     ;Contara la cantidad de veces que el usuario ingresa un caracter
        mov cont,0   ;Indica la cantidad de digitos del numerador
    
leer: 
    mov ah,1         ;Servicio uno para pedir caracter
    cmp si,4         ;Si se llego al maximo permitido
    je verifica      ;Se verifica que efectivamente hayan 3 digitos com maximo en el numerador
    int 21h          ;Sino pida caracter
        
    cmp al,'c'       ;Comparamos el caracter leido con c
    je borra         ;Si el caracter leido es igual al caracter c borramos todo y volvemos a iniciar
    
    cmp al,'s'
    je slrN
    cmp al,'S'
    je slrN
    
    cmp al,'/'       ;Si el caracter leido es igual al caracter / se verifica cuantos digitos se han ingreado
    je verifica   
    
    cmp al,30h       ;Comparamos el caracter leido con los otros caractecteres por debajo de cero en Ascii
    jl verifica    
  
    cmp al,39h       ;Comparamos el caracter leido con los otros caractecteres por encima de nueve en Ascii  
    jg verifica
    
      
    sub al,30h       ;Para guardaro con valor numerico de una vez 
    mov vN[si],al    ;Llena el vector del numerador1
    inc cont         ;Incrementa la cantidad de digitos del numerador
    inc si
    jmp leer

verifica:           ;Se verifican errores al ingresar la expresion
    cmp cont,3      ;Si se paso del limite de 3 digitos
    jg error        ;Hay error
    
    cmp si,0        ;Si no se han ingresado digitos y se puso un simbolo 
    je error        ;Hay un error
    cmp al,'/'      ;Si se puso el simbolo /
    je salir        ;Es valido por lo tanto sale a leer el numero siguiente
    cmp al,30h      ;Si luego de un numero se pone un simbolo que no sea / 
    jl error        ;Hay un error en la expresion
    cmp al,39h 
    jg error     
    jmp salir      ;Si no se ingreso nada raro se sale a leer el denominador 
 
    
borra:
    mov e,1        ;Cambiamos a nuestra variable e a 1 para limpiar pantalla
    jmp salir
    
            
error:
    cmp si,0       ;Si hay un simbolo despues de un numero 
    jne  menError  ;Se brinca para mostrar el msj
    
noDigitos:
    call errorNoDigitos   
    mov e,1
    jmp salir
    
slrN:
    mov slr,1
    jmp salir
    
menError:
    call muestraError
    mov e,1   ;Y hacemos a nuestra variable e a 1 para limpiar pantalla   
   
salir: 
    xor bx,bx             ;limpia bx
    mov bl,cont           ;Mueve a bl el valor de contador
    mov contGeneral,bl    ;Hace a contGeneral igual a cont
    mov confirm,1         ;Esto es para saber en la conversion que se debe convertir el numerador
              
 RET
leerNum endp
;---------------------------------------------------------------------------------------------------------------------------------

;-----------------------------------------Lee el denominador de la fraccion 1----------------------------------------------------- 
leerDen proc near

     mov e,0 
     mov si,0
     mov contD,0    ;Indica la cantidad de digitos del denomidor 1
     
leerd: 
    mov ah,1
    cmp si,4
    je vrfD
    int 21h
        
    cmp al,'c'       ;Comparamos el caracter leido con c
    je borrad        ;Si el caracter leido es igual al caracter c borramos todo y volvemos a iniciar
    
    cmp al,'s'
    je slrD
    cmp al,'S'
    je slrD
   
    cmp al,'+'       ;Comparamos el caracter leido con +
    je guardaOp      ;Si es igual hay se pasa a guardar
  
    cmp al,'-'       
    je guardaOp

    cmp al,'*'
    je guardaOp

    cmp al,'/'
    je guardaOp
    
    cmp al,30h       ;Comparamos el caracter leido con los otros caractecteres por debajo de cero en Ascii
    jl errord     
  
    cmp al,39h       ;Comparamos el caracter leido con los otros caractecteres por encima de nueve en Ascii  
    jg errord
    
    cmp si,1          ;Si ya se ingreso algo
    jl comparaCeroD1  ;Sino entonces se brinca a comparar con cero por la division entre 0
    jmp seguirD1      ;Si no es 0 siga ingresando numeros
    
comparaCeroD1:        ; Se verifica que el caracter no sea 0
      cmp al,30h
      je errord       ;Si es asi hay error
      
seguirD1:     
    sub al,30h        ;Para guardaro con valor numerico de una vez 
    mov vD[si],al
    inc contD         ;Incrementa la cantidad de digitos del denominador1
    inc si
    jmp leerd

vrfD:
    cmp contD,3       ;Si hay mas de 3 digitos
    jg errord         ;Se pasa del limite


guardaOp:
    cmp si,0         ;indica si ya se ingreso algo o no
    je errord        ;si no se ha ingresado ningun numero brinca a error
    mov op,al
    jmp salird

borrad:
    mov e,1          ;Cambiamos a nuestra variable e a 1 para limpiar pantalla
    jmp salird
            
errord:
    cmp al,30h        ;Si se ingresa un cero
    je zeroDivisionD1 ;Si se divide por 0 entonces
    jmp msj
   
zeroDivisionD1: 
    call errorCero      ;Carga msj de error de division
    mov e,1   ;Y hacemos a nuestra variable e a 1 para limpiar pantalla  
    jmp salir
    
slrD:
  mov slr,1
  jmp salird
     
msj:
    call muestraError
    mov e,1   ;Y hacemos a nuestra variable e a 1 para limpiar pantalla    
   
salird: 
    xor bx,bx
    mov bl,contD
    mov contGeneral,bl    ;Hace a contGeneral igual a cont
    mov confirm,2

 RET
leerDen endp
;------------------------------------------------------------------------------------------------------------------------------------


;---------------------------------------------------Lee el numerador de la fraccion 2-------------------------------------------------  
leerNumN proc near
        mov e,0 
        mov si,0
        mov contNumeradorDos,0
    
leerN: 
    mov ah,1
    cmp si,4
    je verificaN
    int 21h
        
    cmp al,'c'       ;Comparamos el caracter leido con 'c'
    je borraN         ;Si el caracter leido es igual al caracter 'c' borramos todo y volvemos a iniciar
    
    cmp al,'s'
    je slrNN
    cmp al,'S'
    je slrNN
    
    cmp al,'/'
    je verificaN
    
    cmp al,30h       ;Comparamos el caracter leido con los otros caractecteres por debajo de cero en Ascii
    jl errorN     
  
    cmp al,39h       ;Comparamos el caracter leido con los otros caractecteres por encima de nueve en Ascii  
    jg errorN
        
    sub al,30h ; Para guardaro con valor numerico de una vez 
    mov  vNumeradorDos[si],al
    inc  contNumeradorDos
    inc  si
    jmp leerN
    
verificaN:

    cmp contNumeradorDos,3      ;Si se paso del limite de 3 digitos
    jg errorN                    ;Hay error
    
    cmp si,0
    je errorN
    jmp salirN
 
borraN:
    mov e,1   ;Cambiamos a nuestra variable e a 1 para limpiar pantalla
    jmp salirN
    
slrNN:
    mov slr,1
    jmp salirN
            
errorN:
    call muestraError
    mov e,1;Y hacemos a nuestra variable e a 1 para limpiar pantalla   
   
salirN: 

    xor bx,bx
    mov bl,contNumeradorDos
    mov contGeneral,bl    ;Hace a contGeneral igual a cont
    mov confirm,5
               
 RET
leerNumN endp
;-------------------------------------------------------------------------------------------------------------------------

;-------------------------------------Lee el denominador de la fraccion 2-------------------------------------------------  
leerDenD proc near
     mov e,0 
     mov si,0
     mov contDenominadorDos,0 ;indica la cantidad de digitos del denominador2
     
leerdD: 
    mov ah,1      ;Servicio para pedir entrada 
    cmp si,4      ;Si se alcanzo el maximo digitos en el denominador
    je errordD    
    int 21h       ;Interrupcion para ingresar caracter
   
    
    cmp al,'c'       ;Comparamos el caracter leido con c
    je borradD       ;Si el caracter leido es igual al caracter c borramos todo y volvemos a iniciar
    
    cmp al,'s'
    je slrDD
    cmp al,'S'
    je slrDD
    
    cmp al,'='       ;Comparamos el caracter leido con =
    je DverificarFin ;Si es as? termino la expresion
    
    cmp al,30h       ;Comparamos el caracter leido con los otros caractecteres por debajo de cero en Ascii
    jl errordD      
  
    cmp al,39h       ;Comparamos el caracter leido con los otros caractecteres por encima del nueve en Ascii  
    jg errordD
    
    cmp si,1         ;Si si es 1
    jl comparaCero   ;Si es mas peque?o se verifica que no sea 0
    jmp seguir       ; Si es distinto se siguen ingresando caracteres
    
comparaCero:
    cmp al,30h     ;Si el primer caracter es 0 
    je errordD     ;hay error
    
 seguir:       
    sub al,30h                      ; Para guardaro con valor numerico de una vez 
    mov vDenominadorDos[si],al      ;Se guarda el caracter en el vector del denominador
    inc contDenominadorDos          ;Aumenta la cantidad de digitos en el denominador
    inc contGeneralD                ;Aumenta la cantidad del contador General del este denominador
    inc si
    jmp leerdD
    
DverificarFin:
    cmp si,0   ;Se compara para ver si se ingreso algo anteriormente
    je errordD ;Si no se he ingresado nada hay un error
    jmp salirD ;Sino se sale para calcular el resultado de la expresion
    

borradD:
    mov e,1       ;Cambiamos a nuestra variable e a 1 para limpiar pantalla
    jmp salirdD   ;Salimos del proc
            
slrDD:
    mov slr,1
    jmp salirD

errordD:
    cmp al,30h
    je zeroDivision ;Si es un cero y no se habia ingresado nada
    jmp msj2        ;Si no es cero va mostrar el mensaje de error por otro motivo
   
zeroDivision: 
   call errorCero
   mov e,1   ;Y hacemos a nuestra variable e a 1 para limpiar pantalla 
   jmp salirdD   ;Salimos del proc   
    
 msj2: 
    call muestraError
    mov e,1   ;Y hacemos a nuestra variable e a 1 para limpiar pantalla   
   
salirdD: 
    mov confirm,4
            
 RET
leerDenD endp
;***********************************************************************************************************************************


;**********************************************CONVERTIR A NUMEROS DE VERDAD***************************************************************

convertirNumero proc near
    push ax 
    push bx
    

    ;contGeneral es la cantidad de digitos que posee el numero
    cmp contGeneral,1
    je unidades             ;Si tiene un digito va a convertir unidades
    cmp contGeneralD,1 
    je unidades
    
    cmp contGeneral,2
    je decenas              ;Si tiene dos digitos va a convertir decenas
    cmp contGeneralD,2
    je decenas
    
    cmp contGeneral,3
    je centenas              ;Si tiene tres digitos va a convertir centenas
    cmp contGeneralD,3
    je centenas
    
unidades:
    xor ax,ax                ;pone en 0 ax
    mov al, vGeneral[0]      ;guarda en al el caracter que tiene vN[0]
    mov rslGeneral,ax        ;se guarda en num1 el valor numerico del numerador 
    jmp slrCNU               ;sale y en ax queda el valor del numerador
    
decenas :
    xor ax,ax      ;pone en 0 ax
    xor bx,bx      ;pone en 0 bx
    mov bl,10      ;Para convertir a decenas
    
    mov al, vGeneral [0]    ;guarda en al el caracter que tiene vN[0] que representa las decenas
    mul bl                  ;en ax queda el resultado de la mutiplicacion para tener decenas
    
    mov bl, vGeneral [1]    ;guarda en bl el caracter que tiene vN[1] que representa unidades
    add al,bl               ;suma las unidades y las centenas dejando el numero que representa el vector VN
    mov rslGeneral,ax       ;se guarda en num1 el valor numerico del numerador 
    jmp slrCNU              ;sale y en ax queda el valor del numerador
   

centenas:
    xor ax,ax      ;pone en 0 ax
    xor bx,bx      ;pone en 0 bx
    mov bl,100     ;Para convertir a centenas
    
    mov al, vGeneral [0]    ;guarda en al el caracter que tiene vN[0] que representa las centenas
    mul bl                  ;en ax queda el resultado de la mutiplicacion para tener centenas
    
    mov rslGeneral,ax       ;se respalda el resulatado de las centenas
    
    xor bx,bx               ;limpia bx
    xor ax,ax               ;limpia ax
    
    mov bx,10              ;para convertir a decenas
    mov al, vGeneral [1]   ;guarda en al el caracter que tiene vN[1] que representa decenas
    mul bx                 ;en ax queda el resultado de la mutiplicacion para tener decenas
    
    add rslGeneral,ax      ;suma centenas + decenas y queda en dx
    
    xor bx,bx               ;limpia bx
    mov bl, vGeneral [2]    ;guarda en bl el caracter que tiene vN[2] que representa unidades
    add rslGeneral,bx       ;suma las unidades al resultado anterior dejando el numero que representa el vector VN
   
    
slrCNU:
    xor ax,ax              ;Limpia ax  
    mov ax,rslGeneral      ;Mueve a ax el numero convertifo anteriormente
    
    cmp confirm,1          ;Si confirme es 1 entonces se convirtio el numerador 1
    je numerador1
    
    cmp confirm,2          ;Si confirme es 2 entonces se convirtio el denominador 1
    je denominador1
    
    cmp confirm,5          ;Si confirme es 5 entonces se convirtio el numerador 2
    je convNum
    
    cmp confirm,4          ;Si confirme es 4 entonces se convirtio el denominador 2
    je convden
     
;Se nueve el resultado de la conversion al termino correspondiente    
numerador1:
    mov num1,ax
    jmp exit
    
denominador1: 
    mov den1,ax
    jmp exit 
        
convNum:
    mov cnD,ax
    jmp exit
    
convden: 
    mov cdD,ax
    jmp exit 
      
exit:
    pop ax
    pop bx
 
 RET
convertirNumero endp

;-------------------------------------------------------------------------------------------------------------------------------------------

;----------------------------------Elimina contaminacion de bit en vGeneral para poder usarlo varias veces----------------------------------
limpiaGeneral proc near
    mov vGeneral[0] ,0
    mov vGeneral[1] ,0
    mov vGeneral[2] ,0
    
 RET
limpiaGeneral  endp
;-----------------------------------------------------------------------------------------------------------------------------------------

;-------------------------------------Convierte el Den2 se hace separado porque presentaba problemas con el orginal-----------------------
convertirDen2 proc near
    push ax 
    push bx
    push cx
    

;cont es la cantidad de digitos del vector
    cmp contDenominadorDos,1
    je Dunidades
    
    cmp contDenominadorDos,2
    je Ddecenas
    
    cmp contDenominadorDos,3
    je Dcentenas
    
Dunidades:
    xor bx,bx    ;pone en 0 ax
    mov bl, vGeneral[0]  ;guarda en al el caracter que tiene vN[0]
    mov cdD,bx   ;se guarda en num1 el valor numerico del numerador 
   
    jmp DslrCNU    ;sale y en ax queda el valor del numerador
    
Ddecenas :
    xor ax,ax      ;pone en 0 ax
    xor dx,dx      ;pone en 0 cx
    mov dl,10      ;Para convertir a decenas
    
    mov al, vGeneral [0]   ;guarda en al el caracter que tiene vN[0] que representa las decenas
    mul dl         ;en ax queda el resultado de la mutiplicacion para tener decenas

    
    mov dl, vGeneral [1]   ;guarda en bl el caracter que tiene vN[1] que representa unidades
    add ax,dx      ;suma las unidades y las centenas dejando el numero que representa el vector VN
    mov cdD,ax    ;se guarda en num1 el valor numerico del numerador 
    jmp slrCNU     ;sale y en ax queda el valor del numerador       ;sale y en ax queda el valor del numerador
   

Dcentenas:
    xor ax,ax      ;pone en 0 ax
    xor cx,cx      ;pone en 0 bx
    mov cl,100     ;Para convertir a centenas
    
    mov al, vGeneral [0]   ;guarda en al el caracter que tiene vN[0] que representa las centenas
    mul cl         ;en ax queda el resultado de la mutiplicacion para tener centenas
    
    mov cdD,ax      ; se respalda el resulatado de las centenas
    
    xor cx,cx      ;limpia bx
    xor ax,ax      ;limpia ax
    
    mov cx,10              ;para convertir a decenas
    mov al, vGeneral [1]   ;guarda en al el caracter que tiene vN[1] que representa decenas
    mul cx                 ;en ax queda el resultado de la mutiplicacion para tener decenas
    
    add cdD,ax      ;suma centenas + decenas y queda en dx
    
    xor cx,cx      ;limpia bx
    mov cl, vGeneral [2]   ;guarda en bl el caracter que tiene vN[2] que representa unidades
    add cdD,cx      ;suma las unidades al resultado anterior dejando el numero que representa el vector VN
   

DslrCNU:
    pop ax
    pop bx
    pop cx
 
 RET
convertirDen2 endp
 
;-----------------------------------------------------------------------------------------------------------------

; -----------------------------------------PROCS PARA OPERACIONES-------------------------------------------------

;MULTIPLICACION----------------------------------------------------------------------------------------------------
multiplicar proc near
    push ax
    push bx
    push cx
    
    mov ax,num1
    mul cnD             ;se multiplican ambos numeradores y el resultado queda en DX:AX
    mov rslNUM,ax       ;Se toma el resultado y se guarda
    
    xor ax,ax           ;Limpio AX
    mov ax,den1         ;Mueva a Ax el denominador 1
    mul cdD             ;se multiplican ambos denominadores y el resultado queda en DX:AX
    mov rslDEN,ax       ;Se guarda el resulato
    
    pop ax
    pop bx
    pop cx
    
 RET
multiplicar endp
;------------------------------------------------------------------------------------------------------------------

;DIVISION----------------------------------------------------------------------------------------------------
dividir proc near
    push ax
    push bx
    push cx
 
    mov ax,num1                  ;Se guarda el numerador 1
    mul cdD                      ;se multiplic el numerador 1 por el denominador 2 y el resultado queda en DX:AX
    mov rslNUM,ax                ;Se guarda el resultado
    
    xor ax,ax                    ;Limpio Ax
    mov ax,cnD                   ;Muevo a ax el numerador 2
    mul den1                     ;se multiplica el numerador 2 con el denominador 1 y el resultado queda en DX:AX
    mov rslDEN,ax                ;Se almacena el resultado
    
    pop ax
    pop bx
    pop cx
  RET
dividir endp   

;------------------------------------------------------------------------------------------------------------------------------------

;SUMA--------------------------------------------------------------------------------------------------------------------------------
sumar proc near
    push ax
    push bx
   
    xor bx,bx  ;Limpio bx
    xor ax,ax  ;Limpio ax
    
    mov ax,num1
    mul cdD             ;se multiplica numerador 1 por denominador 2 (en cruz)  y el resultado queda en DX:AX
    mov rslNUM,ax       ;Guardo el resultado de la multiplicacion
    
    xor ax,ax           ;limpio ax
    
    mov ax,den1        ;muevo a ax el denomindor 1  
    mul cnD            ;se multiplica numerador 2 por denominador 1 (en cruz)  y el resultado queda en DX:AX
    add rslNUM,ax      ;Se agrega al resultado el obtenido en la multilpicacion anterior y queda el numerador final 
   
    
    xor ax,ax          ;limpio ax
    
    mov ax,den1
    mul cdD            ;se multiplican ambos denominadores y el resultado queda en DX:AX
    
    mov rslDEN,ax      ;Se guarda el resultado del denominador final
    
    pop ax
    pop bx
  RET
sumar endp 

;----------------------------------------------------------------------------------------------------------------------------------

;RESTA--------------------------------------------------------------------------------------------------------------------------------
restar proc near
    push ax
    push bx
    
    xor bx,bx ;Limpio bx
    xor ax,ax ;Limpio ax
    
    mov ax,num1
    mul cdD          ;se multiplica numerador 1 por denominador 2 (en cruz)  y el resultado queda en DX:AX
    mov rslNUM,ax    ;Guardo el resultado de la multiplicacion
   
    xor ax,ax        ;limpio ax
    
    mov ax,den1      ;muevo a ax el denomindor 1 
    mul cnD          ;se multiplica numerador 2 por denominador 1 (en cruz)  y el resultado queda en DX:AX
    sub rslNUM,ax    ;Se resta al resultado el obtenido en la multilpicacion anterior y queda el numerador final 
    
    
    xor ax,ax         ;limpio ax
    
    mov ax,den1
    mul cdD            ;se multiplican ambos denominadores y el resultado queda en DX:AX
    
    mov rslDEN,ax      ;Se guarda el resultado del denominador final
    
    pop ax
    pop bx
  RET
restar endp 
;--------------------------------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------------------------------
vt proc near
   cmp den1,150
   jg errorOp
   cmp num1,150
   jg errorOp
   cmp cnD,150
   jg errorOp
   cmp cdD,150
   jg errorOp
   jmp salirVt
    
errorOp: 
       call numeroMayor   
 
salirVt:
   
RET
   
 vt endp 
;---------------------------------------------------------------------------------------------------------------- 
;----------------------------------------------Para imprimir-----------------------------------------------------
 printVal proc near
 ;imprime el valor numerico de la variable que print
  
  xor ax,ax ;limpio ax
  xor bx,bx ;limpio bx
  xor dx,dx ;limpio dx
  
  ;proceso para descomponer el numero y poder imprimirlo
  mov ax,print
  mov bx,10
  div bx       ;En AL queda el resultado y en AH el resto
  mov uni,dl
  
  xor bx,bx
  mov bx,ax     ;respaldo el resultado
  xor ax,ax
  mov ax,bx     ;nuevamente se coloca el resultado para divir
  
  mov bl,10
  div bl        ;En AL queda el resultado y en AH el resto
  mov dece,ah
  
  xor bx,bx
  mov bl,al     ;respal el resultado
  xor ax,ax
  mov ax,bx     ;nuevamente se coloca el resultado para divir
  
  mov bl,10
  div bl        ;En AL queda el resultado y en AH el resto
  mov cen,ah
  
  xor bx,bx
  mov bl,al     ;respal el resultado
  xor ax,ax
  mov ax,bx     ;nuevamente se coloca el resultado para divir
  
  mov bl,10
  div bl        ;En AL queda el resultado y en AH el resto
  mov mil,ah
  
  xor bx,bx
  mov bl,al     ;respal el resultado
  xor ax,ax
  mov ax,bx     ;nuevamente se coloca el resultado para divir
  
  mov bl,10
  div bl        ;En AL queda el resultado y en AH el resto
  mov dmil,ah
 
  ;Se limpian ax y dx
  xor ax,ax
  xor dx,dx
  
  cmp dmil,0 
  je mls     ;Si las decenas de miles son 0 no se imprimen y sigue con los miles
  
  mov ah,2
  mov dl,dmil
  add dl,30h
  int 21h       ;Se imprime decenas de miles
  
  
mls:            ;Verifica si es necesario imprimrir los miles en caso de ser 0
    cmp mil,0 
    jne ipmls   ;Si los miles no son cero brinca a imprimir el valor
    cmp dmil,0
    je cnt      ;Si las decenas de miles son cero y los miles tambien vamos a las centenas
    
ipmls:
    mov ah,2
    mov dl,mil
    add dl,30h
    int 21h    ;Se imprime miles
    
cnt:           ;Verifica si es necesario imprimrir las centenas en caso de ser 0
    cmp cen,0
    jne ipcnt  ;Si no son 0 las imprime 
    cmp mil,0  ;Si las centenas son 0 y los miles tambien
    je vdm     ;Va verificar si las decenas de miles son 0
    jmp ipcnt  ;Va a imprimir las centenas
    
vdm:           
   cmp dmil,0  
   je dcn      ;Si las centenas son 0 y los miles y las decenas de miles tambien brinca a las decens
    
ipcnt:
    mov ah,2
    mov dl,cen
    add dl,30h
    int 21h   ;Se imprime centenas

dcn:          ;Verifica si es necesario imprimrir las decenas en caso de ser 0
    cmp dece,0
    jne ipdcn ;Sino son 0 va a imprimir las decenas
    cmp cen,0 
    je vml    ;Si las decenas son 0 y las centenas tambien va a verifica si los miles tambien son 0
    jmp ipdcn ;Si los decenas son 0 pero las centenas no entonces va a imprimir las decenas
   
vml:
    cmp mil,0
    je vdml   ;Si las centenas las decenas y los miles son cero verifica a las decenas de miles
    jmp ipdcn ;Si los decenas y las centenas son 0 pero los miles no entonces va a imprimir las decenas
 
vdml:
    cmp dmil,0
    je und    ;Si las centenas las decenas los miles y las decenas de miles son cero va a las unidades
   
ipdcn:  
   mov ah,2
   mov dl,dece
   add dl,30h 
   int 21h    ;Se imprime decenas
   
und:  
  mov ah,2
  mov dl,uni
  add dl,30h
  int 21h   ;Se imprimen unidades
 
 RET
printVal endp
;---------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------
printVec proc near
 ;Imprime los 3 diditos del vector que se desee veer
  xor ax,ax    ;Limpio ax
  xor dx,dx    ;Limpio dx
  
  mov ah,2           ;Servicio 2 para mostar caracter     
  mov dl,printV [0]  ;Se mueve a dl el caracter del vector en la primera posicion que representa centenas
  add dl,30h         ;Agrega 30 para mostrar el caracer deseado debido a que estan en valor numerico real
  int 21h            ;Se muestra en pantalla
  
  mov ah,2
  mov dl,printV [1] ;Se mueve a dl el caracter del vector en la primera posicion que representa decenas
  add dl,30h
  int 21h
  
  mov ah,2
  mov dl,printV [2] ;Se mueve a dl el caracter del vector en la primera posicion que representa unidades
  add dl,30h
  int 21h

  RET
printVec endp

;----------------------------------------------------------------------------------------------------------------------------------

colocar_cursor proc
    mov ah,2
    mov bh,0
    int 10h
    RET

colocar_cursor endp
;---------------------------------------------------------------------------------------------------------------------------------
colocar_posicion proc
    mov dl,46
    mov dh,5
    RET

colocar_posicion endp

;-----------------------------------------------Dibujillo de calculadora-----------------------------------------------------------
   calc proc near
        mov ah,9                ;Servicio 9 para imprimir una cadena
        lea dx,ms               ;Seleccionamos la cadena ms
        int 21h                 ;la imprimimos
        lea dx,lin00            ;la imprimimos
        int 21h                 ;la imprimimos
        lea dx,lin01            ;la imprimimos
        int 21h                 ;la imprimimos
        lea dx,lin0             ;la imprimimos                 
        int 21h                 ;la imprimimos
        lea dx,lin1             ;seleccionamos la cadena lin1
        int 21h                 ;la imprimimos
        lea dx,lin2             ;y asi para las demas lineas
        int 21h
        lea dx,lin3
        int 21h
        lea dx,lin4
        int 21h
        lea dx,lin5
        int 21h
        lea dx,lin6
        int 21h
        lea dx,lin7
        int 21h
        lea dx,lin8
        int 21h
        lea dx,lin9
        int 21h
        lea dx,lin10
        int 21h
        lea dx,lin11
        int 21h
        lea dx,lin12
        int 21h
        lea dx,lin13
        int 21h
        lea dx,lin14
        int 21h
        lea dx,lin15
        int 21h
        lea dx,lin16
        int 21h
         lea dx,lin17
        int 21h
         lea dx,lin18
        int 21h
     RET
     calc endp
;/***************************************
 end main
   