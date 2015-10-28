stance(prone).
stance(kneeling).
stance(standing).
stance(swimming).

speed(0).
speed(1).
speed(2).
speed(3).
speed(4).

surrounding(none).
surrounding(forest).
surrounding(town).

multiplier(prone,X) :- X = -1.
multiplier(kneeling,X) :- X = 1.8.
multiplier(standing,X) :- X = 1.
multiplier(0,X) :- X = 1.
multiplier(1,X) :- X = 1.
multiplier(2,X) :- X = 0.77.
multiplier(3,X) :- X = 0.55.
multiplier(4,X) :- X = 0.33.
multiplier(none,X) :- X = 1.
multiplier(forest,X) :- X = 2.
multiplier(town,X) :- X = 2.

min(A,B) :- (A >= 480 , B = 480) ; (A < 480 , B = A).

validcomb([A,B,C]) :- stance(A) , speed(B) , surrounding(C).
combmult([A,B,C],D,X) :- multiplier(A,M1) , multiplier(B,M2) , multiplier(C,M3) , X is D*M1*M2*M3.

combval([A,B,C],X) :- validcomb([A,B,C]) , ((B = 0 , combmult([A,B,C],300,M) , min(M,X)) ; (not(B = 0) , combmult([A,B,C],30,M) , min(M,X))).
