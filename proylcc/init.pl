
:- module(init, [ initSize/5 ]).

init(
[[3], [1,2], [4], [5], [5]],    % PistasFilas

[[2], [5], [1,3], [5], [4]],     % PistasColumnas

[["X", _ , _ , _ , _ ],
 ["X", _ ,"X", _ , _ ],
 ["X", _ , _ , _ , _ ],        
 ["#","#","#", _ , _ ],
 [ _ , _ ,"#","#","#"]]
).

init(
    [[5], [3,1], [3,2], [1,2], [1,1,1], [1,4]],      % PistasFilas
    [[4], [3], [3,2], [2,1], [1,1], [1,2,1], [4]],     % PistasColumnas

    [[ _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _],      % Grilla
     [ _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _]]
). 

init(
    [[3,3], [10], [3,2,3], [2,2], [1,1], [1,1,1,1], [2,2], [3,1], [3,2,1], [4,1]],    % PistasFilas

    [[4,3], [10], [3,4], [1,1,1], [2,1], [2,1], [1,1,1], [3,3], [7], [4]],     % PistasColumnas

    [[ _ , "#" , _ , _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _ , "#" , "#" , _],
     [ _ , _ , _ , _ , _ , _ , _ , _ , _ , _],        % Grilla
     [ _ , _ , _ , _ , _ , _ , _ , _ , _ , _],
     [ "X" , _ , _ , _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _ , _ , _ , _],
     [ _ , _ , _ , _ , _ , _ , _ , _ , "X" , _]]
).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%longitud(+Lista,-Longitud).
%
%Devuelve la longitud de una lista de elementos.

longitud([],0).
longitud([_|Xs],N):-
    longitud(Xs,N1),
    N is N1 + 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%initSize(+Size,-RowClues,-ColClues,-Grid).
%
%Inicializa un tablero según la cantidad de columnas y la cantidad de filas.

initSize(SizeR,SizeC,RowClues,ColClues,Grid):-
    init(RowClues,ColClues,Grid),
    longitud(RowClues,SizeRow),
    longitud(ColClues,SizeCol),
    SizeR = SizeRow,
    SizeC = SizeCol.