#lang slideshow

; Nombre: Fernando Alfonso Arana Salas
; Matricula: A01272933
; Problemario Funcional (parte 2)

; 1. Inserta un número n en una lista
(define (insert n lst)

  ; Lista vacía para left half
  (define lhalf (list))

  ; Loop 
  (define (ins n lst lst2)
    (if (or (empty? lst) (< n (first lst))) ; Caso base
        (append (reverse lst2) (append (list n) lst))
        (ins n (rest lst) (append (list (first lst)) lst2)))) ; Caso recursivo

  ; Call
  (ins n lst lhalf))


; 2. Ordena una lista de manera ascendente
(define (insertion-sort lst)

  ; Abrimos una lista vacia
  (define lst1 (list))

  ; Insertamos en orden -> Loop
  (define (loop _lst _lst2)
    (if (empty? _lst) ; Caso base
        _lst2
        (loop (rest _lst) (insert (first _lst) _lst2)))) ; Caso recursivo

  ; Call
  (loop lst lst1))


; 3. Devuelve una lista que resulta de rotar n elementos. Si n > 0 rota izquierda. Si n < 0 rota derecha
(define (rotate-left n lst)
  
  (define list_aux (list)) ; Nueva lista vacía

  ; Para casos donde n es mayor a la longitud de la lista, buscamos su residuo
  (define (nn n)
    (if (> n 0)
        (if (> n (length lst))
            (remainder n (length lst))
            n)
        (if (> (* n -1) (length lst))
            (* (remainder (* n -1) (length lst)) -1)
            n)))

  ; Dado el número n, empieza a acomodar los elementos desde la n-esima posición
  (define (nuevoInicioP n lst lst2)
    (if (= (length lst) 0)
        empty
        (if (= n 0)
            (append lst (reverse lst2))
            (nuevoInicioP (- n 1) (rest lst) (append (list (first lst)) lst2)))))

  (define (nuevoInicioN n lst lst2)
    (if (= (length lst) 0)
        empty
        (if (= n 0)
            (append lst2 (reverse lst))
            (nuevoInicioN (+ n 1) (rest lst) (append (list (first lst)) lst2)))))

  ; Call
  (if (empty? lst)
      empty
      (if (= n 0)
          lst
          (if (> n 0)
              (nuevoInicioP (nn n) lst list_aux)
              (nuevoInicioN (nn n) (reverse lst) list_aux)))))
  
  

; 4. Devuelve una lista con los números primos de un número
(define (prime-factors n)

  (define nprimo 2) ; Variable para registrar el n primo

  ; Función recursiva
  (define (encuentra_primos n n2)
    (if (<= n 1)
        empty
        (if (= n nprimo) ; Caso base
            n
            ; Si el residuo es 0
            (if (= (remainder n n2) 0)
                (cons n2 (encuentra_primos (quotient n n2) n2)) ; Caso recursivo
                (encuentra_primos n (+ 1 n2))))))

  ; Call
  (encuentra_primos n nprimo))


; 5. Devuelve el máximo común divisor de dos número enteros a y b
(define (gcd a b)
  
  (define (min a b) ; Función para calcular el min entre dos números
    (if (< a b)
        a
        (if (= a b)
            =
            b)))

  (define nmin (min a b))
  
  (define (encuentra_gcd a b n) ; Función recursiva auxiliar
    (if (and (= (remainder a n) 0) (= (remainder b n) 0)) ; Caso base
        n
        (encuentra_gcd a b (- n 1)))) ; Caso recursivo

  ; Call
  (if (or (< a 0) (< b 0)) ; Checamos errores
      "Error"
      (encuentra_gcd a b nmin)))

  
; 6. Devuelve una lista invertida (también invierte si existen listas anidadas)
(define (deep-reverse lst)
  (if (empty? lst) ; Caso base
      empty
      (if (list? (first lst))
          (append (deep-reverse (rest lst)) (list (deep-reverse (first lst)))) ; Caso Recursivo
          (append (deep-reverse (rest lst)) (list (first lst)))))) ;             Caso recursivo


; 7. Devuelve una lista con todas las formas posibles que se puede insertar x en lst
(define (insert-everywhere x lst)

  (define pos (range (+ 1 (length lst)))) ; Posiciones a insertar
  
  (define (ins x n lst lst2) ; Función auxiliar
    (if (or (empty? lst) (< n (first lst))) ; Caso base
        (append (reverse lst2) (append (list x) lst))
        (ins x n (rest lst) (append (list (first lst)) lst2)))) ; Caso recursivo

  (define (ins_eve_aux x lst_pos lst)
    (define lhalf (list))
    (if (empty? lst_pos)
        empty
        (append (list (ins x (first lst_pos) lst lhalf)) (ins_eve_aux x (rest lst_pos) lst)))) 

  ; Call
  (ins_eve_aux x pos lst))

  
; 8. Devuelve una lista de listas que agrupan los elementos iguales consecutivos
(define (pack lst)
  (define lista_aux (list))
  
  (define lista_final (list))
  
  (define (pack_aux lst lst1 lst2)
    (if (empty? lst)
        (reverse lst2)
        (if (= (length lst) 1)
            (if (empty? lst1)
                (pack_aux (rest lst) (list) (append (list (list (first lst))) lst2))
                (if (equal? (first lst) (first lst1))
                    (pack_aux (rest lst) (list) (append (list (append (list (first lst)) lst1)) lst2))
                    (pack_aux (rest lst) (list) (append (list (first lst)) lst2))))
            (if (equal? (first lst) (first (rest lst)))
                (pack_aux (rest lst) (append (list (first lst)) lst1) lst2)
                (if (empty? lst1)
                    (pack_aux (rest lst) (list) (append (list (list (first lst))) lst2))
                    (pack_aux (rest lst) (list) (append (list (append (list (first lst)) lst1)) lst2)))))))
  
  (pack_aux lst lista_aux lista_final))
                       

; 9. Devuelve una lista en la que todos los elementos consecutivos repetidos se comprimen
(define (compress lst)
  (if (empty? lst)
      empty
      (if (= (length lst) 1)
          lst
          (if (equal? (first lst) (first (rest lst)))
              (compress (rest lst))
              (append (list (first lst)) (compress (rest lst)))))))


; 10. Devuelve sub-listas que cuentan el número de veces que aparece un elemento 
(define (encode lst)

  ; Variable contador
  (define num 0)

  (define (sub-cont lst num)
    (if (empty? lst)
        empty
        (if (= (length lst) 1)
            (list (append (list (+ 1 num)) lst))
            (if (equal? (first lst) (first (rest lst)))
                (sub-cont (rest lst) (+ 1 num))
                (append (list (append (list (+ 1 num)) (list (first lst)))) (sub-cont (rest lst) 0))))))
   ; Call
  (sub-cont lst num))

  
; 11. Funciona de la misma manera que 10. pero en el caso de que no existen repeticiones, no genera sub-lista
(define (encode-modified lst)

  ; Variable contador
  (define num 0)

  (define (sub-cont lst num)
    (if (empty? lst)
        empty
        (if (= (length lst) 1)
            (if (<= num 1)
                lst
                (list (append (list (+ 1 num)) lst)))
            (if (equal? (first lst) (first (rest lst)))
                (sub-cont (rest lst) (+ 1 num))
                (if (= num 0)
                    (append (list (first lst)) (sub-cont (rest lst) 0))
                    (append (list (append (list (+ 1 num)) (list (first lst)))) (sub-cont (rest lst) 0)))))))

  ; Call
  (sub-cont lst num))

            
; 12. Decodifica una lista con la estructura del problema 11.
(define (decode lst)

  ; Repite un número n veces
  (define (repite n x)
    (if (>= n 1)
        (append (list x) (repite (- n 1) x))
        empty))
  
  (define (sub-decode lst)
    (if (empty? lst)
        empty
        (if (list? (first lst))
            (append (flatten (repite (first (first lst)) (rest (first lst)))) (sub-decode (rest lst)))
            (append (list (first lst)) (sub-decode (rest lst))))))

  ; Call
  (sub-decode lst))
          
  
; 13. Devuelve una función con el comportamiento de la función que recibe como argumento, pero con sus entradas intercambiadas
(define (args-swap f x y)
  (f y x))


; 14. Devuelve verdadero si hay un elemento en la lista que satisfaga la función f
(define (there-exists-one? f lst)
  (if (empty? lst) ; Caso base
      #f
      (if (f (first lst))
          #t
          (there-exists-one? f (rest lst))))) ; Caso recursivo


; 15. Devuelve el índice del elemento buscado
(define (linear-search lst x f)
  (if (empty? lst) ; Caso base
      #f
      (if (f x (first lst))
          0
          (+ 1 (linear-search (rest lst) x f)))))


; 16. Devuelve la derivada de f
(define (deriv f h)
  (lambda (x)
    (/ (- (f(+ x h)) (f x)) h)))


; Aplicabilidad de la función 16.
(define f (lambda (x) (* x x x)))
(define df (deriv f 0.001))
(define ddf (deriv df 0.001))
(define dddf (deriv ddf 0.001))


; 17. Devuelve el cálculo para la función f usando el método de Newton
(define (newton f n)

  ; Guardamos la primera derivada de f
  (define df (deriv f 0.0001))

  ; Función aux recursiva
  (define (newton_aux f n)
    (if (= n 0)
        0
        (if (= n 1)
            (- 0 (/ (f 0) (df 0)))
            (- (newton_aux f (- n 1)) (/ (f (newton_aux f (- n 1))) (df (newton_aux f (- n 1))))))))

  ; Call
  (newton_aux f n))

  
; 18. Calcula la integral utilizando la Regla de Simpson
(define (integral a b n f)

  ; Definimos h
  (define h (/ (- b a) n))

  ; Copiamos n
  (define ncopia n)

  (define (suma a b n f)
    (if (= n 0) ; Si es la primer suma / Caso base
        (f (+ a (* n h)))
        (if (= n ncopia) ; Si es la última suma / Recursivo
            (+ (f (+ a (* n h))) (suma a b (- n 1) f))
            (if (= (remainder n 2) 0) ; Si n es un número impar multiplicamos por 4, eoc. multiplicamos por 2 / Caso recursivo
                (+ (* (f (+ a (* n h))) 2) (suma a b (- n 1) f))
                (+ (* (f (+ a (* n h))) 4) (suma a b (- n 1) f))))))

  ; Call
  (* (/ h 3) (suma a b n f)))