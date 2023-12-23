:- module(proylcc,
	[  
		put/8,
        initCheck/5
	]).
:-use_module(library(clpfd)).
:-use_module(library(lists)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%
% XsY es el resultado de reemplazar la ocurrencia de X en la posición XIndex de Xs por Y.
replace(X, 0, Y, [X|Xs], [Y|Xs]). %Caso base: Si el índice es 0 y el primer elemento de la lista es X,
                                  % entonces devuelve la lista con el primer elemento cambiado por Y.
replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):- %Caso recursivo: Si el índice no es 0, decrementamos el índice
    XIndex > 0,                            %en 1 y sigue recoriendo la lista sin su primer elemento. Devuelve la 
    XIndexS is XIndex - 1,                 %lista Xi|XsY donde Xi es el primer elemento de la lista original y
    replace(X, XIndexS, Y, Xs, XsY).       %XsY la lista con el elemento reemplazado.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% todosBlancos(+Lista)
%
% Chequea si todos los elementos en la lista son X o _.

todosBlancos([]). %Caso base: devuelve true si la lista es vacía, false caso contrario.
todosBlancos(["_"|Xs]):- todosBlancos(Xs). %Caso recursivo: devuelve true si se encuentra un "_" en la lista 
                                           %y lo que sigue de la lista lo cumple, y false caso contrario.
todosBlancos(["X"|Xs]):- todosBlancos(Xs). %Caso recursivo: devuelve true si se encuentra una "X" en la lista
                                           %y lo que sigue de la lista lo cumple, y false caso contrario.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% contarHashtag(+Lista,-CantHashtag,-LineaSinHashtag)
%
% Dada una lista, cuenta la cantidad de Hashtag hasta llegar al final de la lista o la primera aparición de una X o _.

contarHashtag([],0,[]). %Caso base: Si la lista es vacía, entonces se devuelve la lista vacía y la cantidad de "#" es 0.
contarHashtag(["X"|Xs],0,Xs). %Caso base: Si se encuentra una "X" en la lista, entonces la cantidad de "#" es 0 y 
                              %se devuelve lo que sigue de la lista.
contarHashtag(["_"|Xs],0,Xs). %Caso base: Si se encuentra un "_" en la lista, entonces la cantidad de "#" es 0 y 
                              %se devuelve lo que sigue de la lista.
contarHashtag(["#"|Xs],C,Zs):- %Caso recursivo: Si se encuentra un "#" en la lista, entonces la cantidad de "#" será
    contarHashtag(Xs,C1,Zs),   %la cantidad de "#" encontrados en lo que sigue de la lista más 1, y se devuelve una nueva
    C is C1+1.                 %lista.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% chequearLinea(+Lista, +Pista, -LineaSat)
%
% Dada una línea y una lista de pistas, devuelve 1 si la línea satisface las pistas y 0 en caso contrario.


chequearLinea([],[_Y|_Ys],0). %Caso base: Si la lista de la línea es vacía pero la de pistas no, entonces no satisface las pistas.
chequearLinea(Linea,[],1):- %Caso base: Si la lista de la línea no es vacía, pero la de pistas si entonces satisface si todos los 
    todosBlancos(Linea).    % elementos de la línea son "X" o "_".
chequearLinea(["X"|Xs],[],0):- %Caso base: Si se encuentra una "X" en la lista de la línea, la lista de pistas es vacía pero
    not(todosBlancos(Xs)).     % no se verifica que lo que sigue en la línea sean "X" o "_", entonces no satisface las pistas.
chequearLinea(["_"|Xs],[],0):- %Caso base: Si se encuentra un "_" en la lista de la línea, la lista de pistas es vacía pero
    not(todosBlancos(Xs)).     % no se verifica que lo que sigue en la línea sean "X" o "_", entonces no satisface las pistas.
chequearLinea(["#"|_Xs],[],0). %Caso base: Si encuentro un "#" en la lista de la línea pero la lista de pistas es vacía, entonces 
                               % no satisface las pistas.
chequearLinea(["#"|Xs],[N|_Ns],0):- %Caso base: Si se encuentra un "#" en la lista de la línea y la lista de pistas no es vacía,
    contarHashtag(["#"|Xs],CantHashtag,_LineaSinHashtag), %pero la cantidad de "#" es distinta de lo indicado en la lista de pistas,
    CantHashtag \= N.                                     %entonces la línea no satisface las pistas.
chequearLinea(["X"|Xs],[N|Ns],LineaSat):- %Caso recursivo: Si se encuentra una "X" en la lista de la línea y la lista de pistas
    chequearLinea(Xs,[N|Ns],LineaSat).    %no es vacía, entonces se sigue chequeando en lo que sigue de la línea.
chequearLinea(["_"|Xs],[N|Ns],LineaSat):- %Caso recursivo: Si se encuentra un "_" en la lista de la línea y la lista de pistas
    chequearLinea(Xs,[N|Ns],LineaSat).    %no es vacía, entonces se sigue buscando en lo que sigue de la línea. 
chequearLinea(["#"|Xs],[N|Ns],LineaSat):- %Caso recursivo: Si se encuentra un "#" en la lista de la línea, la lista de pistas no
    contarHashtag(["#"|Xs],CantHashtag,LineaSinHashtag), %es vacía y la cantidad de "#" es igual a lo indicado en la pista, 
    CantHashtag is N,                                    %entonces se sigue chequeando en lo que sigue de la línea luego de saltear
    chequearLinea(LineaSinHashtag,Ns,LineaSat).          %un "_" o "X" con las pistas siguientes.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% armarColN(+ColN,+NewGrilla,-ListaColN)
%
% Recupera la lista de elementos en cierta columna de la nueva grilla.

armarColN(_,[],[]). %Caso base: Si la grilla es vacía, entonces se devuelve la lista vacía.
armarColN(ColN, [Fila|NewGrilla], [Elem|ListaColN]):- %Caso recursivo: devuelve la lista con el elemento en
    nth0(ColN,Fila,Elem),                             %la posición ColN de la fila de la grilla seguido de
    armarColN(ColN,NewGrilla,ListaColN).              %la lista nueva.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% put(+Contenido, +Pos, +PistasFilas, +PistasColumnas, +Grilla, -GrillaRes, -FilaSat, -ColSat).
%

put(Contenido, [RowN, ColN], PistasFilas, PistasColumnas, Grilla, NewGrilla, FilaSat, ColSat):-
	% NewGrilla es el resultado de reemplazar la fila Row en la posición RowN de Grilla
	% (RowN-ésima fila de Grilla), por una fila nueva NewRow.

	replace(Row, RowN, NewRow, Grilla, NewGrilla),

	% NewRow es el resultado de reemplazar la celda Cell en la posición ColN de Row por _,
	% siempre y cuando Cell coincida con Contenido (Cell se instancia en la llamada al replace/5).
	% En caso contrario (;)
	% NewRow es el resultado de reemplazar lo que se que haya (_Cell) en la posición ColN de Row por Contenido.

	(replace(Cell, ColN, "_", Row, NewRow),
	Cell == Contenido
		;
	replace(_Cell, ColN, Contenido, Row, NewRow)),

	nth0(RowN, NewGrilla, ListaRowN), %recupera la lista correspondiente a RowN de la nueva grilla.
	armarColN(ColN, NewGrilla, ListaColN), %recupera la lista correspondiente a ColN de la nueva grilla.

    nth0(RowN,PistasFilas,PistasRowN), %recupera la lista de pistas de la fila N.
	nth0(ColN,PistasColumnas,PistasColN), %recupera la lista de pistas de la columna N.

	chequearLinea(ListaRowN, PistasRowN,FilaSat), %chequeamos que la fila cumpla con las pistas.
	chequearLinea(ListaColN, PistasColN,ColSat). %chequeamos que la columna cumpla con las pistas.


/*-------------------------------Correcciones Proyecto 1----------------------------------*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% initCheckLine(+Grid,+Clues,-SatClues).
%
% Chequea las filas de una grilla y arma un lista con 1 o 0 dependiendo de si la fila
% satisface las pistas o no.

initCheckLine([],[],[]). %Caso base: Si la grilla y la lista de pistas son vacías, entonces se devuelve la lista vacía.
initCheckLine([Line|RestLines],[Clue|RestClues],[SatClue|RestSatClue]):- %Caso recursivo: Si la grilla y la lista de 
    chequearLinea(Line,Clue,SatClue),              %pistas no son vacías, entonces se chequea si la línea de la grilla
    initCheckLine(RestLines,RestClues,RestSatClue).%cumple o no las pistas para esa línea y se ubica el resultado de  
                                                   %chequearLinea en lista que se devuelve.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% initCheck(+Grid,+RowClues,+ColClues,-RowSat,-ColSat)
%
% Dada una grilla y las pistas de las filas y columnas, chequea si la grilla las satisface
% y devuelve dos listas con 1's y/o 0's dependiendo de si cada fila/columna satisface o no las pistas
% respectivamente.

initCheck(Grid,RowClues,ColClues,RowSat,ColSat):- 
    initCheckLine(Grid,RowClues,RowSat),          %Se chequean si se cumplen las pistas de las filas en la grilla
    transpose(Grid,TsGrid),                       %Se obtiene la traspuesta de la grilla
    initCheckLine(TsGrid,ColClues,ColSat).        %Se chequean si se cumplen las pistas de las columnas en la grilla traspuesta

/*---------------------------------Proyecto 2----------------------------------*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% makeGrid(+RowLength,+ColLength,-Grid).
%
% Dadas la longitud de la fila y de la columna, arma una grilla vacía.

makeGrid(_RowLength,0,[]). 
makeGrid(RowLength,ColLength,Grid):- 
    length(R,RowLength),              
    append([R],RestGrid,Grid),       
    ColLengthAux is ColLength-1,
    makeGrid(RowLength,ColLengthAux,RestGrid).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% findLines(+ActualLine,+LineLength,+LineClues,-ListSolutions)
%
% Dadas la longitud de las líneas y las pistas correspondientes a cada una de esas líneas, se arma
% una lista con todas las posibles soluciones que pueden haber en cada línea respetando
% las pistas.

findLines(_NumLine,_Length,[],[]). 
findLines(NumLine,Length,[ClueLine|Clues],Solution):-  
    findall(L, (length(L,Length),chequearLinea(L,ClueLine,1), not(member("_",L))), R),
    append([NumLine],R,NAndR),
    append([NAndR],SolvedLine,Solution),
    NumLineAux is NumLine + 1,
    findLines(NumLineAux,Length,Clues,SolvedLine).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replaceLine(+Grid,+ActualLine,+Line,-NewGrid)
%
% Reemplaza la línea en la posición ActualLine de la grilla Grid por la línea Line
% y retorna la nueva grilla NewGrid.

replaceLine([_Row0|Rows],0,[R],[R|Rows]).
replaceLine([Row0|Rows],Index,[R],[Row0|NewGrid]):-
    Index > 0,
    NewIndex is Index - 1,
    replaceLine(Rows,NewIndex,[R],NewGrid).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% placeSingleSol(+LineSolutions,+Grid,-NewGrid)
%
% Ubica en la grilla Grid todas las líneas que tienen una única pista, y por ende las únicas soluciones posibles
% para esas celdas, y la retorna en NewGrid.

placeSingleSol([],Grid,Grid).
placeSingleSol([[_LineN|LineNSolutions]|RestSolutions],Grid,SGrid):-
    length(LineNSolutions,LSolutions),
    LSolutions =\= 1,
    placeSingleSol(RestSolutions,Grid,SGrid).
placeSingleSol([[LineN|LineNSolutions]|RestSolutions],Grid,SGrid):-
    length(LineNSolutions,LSolutions),
    LSolutions == 1,
    replaceLine(Grid,LineN,LineNSolutions,GridWithN),
    placeSingleSol(RestSolutions,GridWithN,SGrid).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% intersectSolutions(+Solutions,+LineLength,+Grid,-SGrid)
%
% Entre todas las posibles soluciones de una determinada línea, busca las casillas que coinciden
% en todas las soluciones y las ubica en la grilla.

intersectSolutions([],_LineLength,G,G).
intersectSolutions([[LineN|LineSolutions]|RestSolutions],LineLength,Grid,SSGrid):-
    length(CommonE,LineLength),
    intersectSolutionsAux(LineSolutions,0,CommonE,CommonEE),
    nth0(LineN,Grid,LineNGrid),
    combineLine(LineNGrid,CommonEE,NuevaLinea),
    replaceLine(Grid,LineN,[NuevaLinea],SGrid),
    intersectSolutions(RestSolutions,LineLength,SGrid,SSGrid).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% intersectSolutionsAux(+LineSolutions,+Count,+EmptyLine,-CommonLine)
%
% Dadas todas las posibles soluciones de una línea, intersecta las posiciones y arma 
% una nueva línea con todas las posiciones en común.

intersectSolutionsAux([Solution|_Solutions],Count,EmptyLine,EmptyLine):-
    length(Solution,LSolution),
    Count >= LSolution.
intersectSolutionsAux([Solution|Solutions],Count,EmptyLine,CommonLine):-
    nth0(Count,Solution,Symbol),
    compareSymbolOnSolutions(Symbol,Solutions,Count),
    replace(_,Count,Symbol,EmptyLine,ReplacedLine),
    CountAux is Count + 1,
    intersectSolutionsAux([Solution|Solutions],CountAux,ReplacedLine,CommonLine).
intersectSolutionsAux([Solution|Solutions],Count,EmptyLine,CommonLine):-
    CountAux is Count + 1,
    intersectSolutionsAux([Solution|Solutions],CountAux,EmptyLine,CommonLine).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% compareSymbolOnSolutions(+Symbol,+Solutions,+Count)
%
% Compara el símbolo Symbol con todos los símbolos en la posición Count de las listas
% de Solutions y devuelve true en caso de que todos los símbolos sean iguales y false
% en caso contrario.

compareSymbolOnSolutions(_Symbol,[],_Count).
compareSymbolOnSolutions(Symbol,[Solution|Solutions],Count):-
    nth0(Count,Solution,SymbolAux),
    Symbol == SymbolAux,
    compareSymbolOnSolutions(Symbol,Solutions,Count).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% combineLine(+Line1,+Line2,-Line12)
%
% Combina Line1 y Line2 en Line12 de forma tal que quedan sólo los elementos que
% se repiten en ambas, y se completa con variables libres.

combineLine([],[],[]).
combineLine([Elem1|ElemsRow1],[Elem2|ElemsRow2],CombinedLine):-
    Elem1 == Elem2,
    combineLine(ElemsRow1,ElemsRow2,Line),
    append([Elem2],Line,CombinedLine).
combineLine([Elem1|ElemsRow1],[Elem2|ElemsRow2],CombinedLine):-
    var(Elem1),
    combineLine(ElemsRow1,ElemsRow2,Line),
    append([Elem2],Line,CombinedLine).
combineLine([Elem1|ElemsRow1],[Elem2|ElemsRow2],CombinedLine):-
    var(Elem2),
    combineLine(ElemsRow1,ElemsRow2,Line),
    append([Elem1],Line,CombinedLine).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% refineSolutions(+LineSolutions,+Grid,-RefinedLineSolutions)
%
% Dada la lista de soluciones para las línea se devuelve la lista con las 
% soluciones que coinciden con lo que se tiene en Grid.

refineSolutions([],_Grid,[]).
refineSolutions([[LineN|LineSolutions]|RestSolutions],Grid,RefinedLineSolutions):-
    nth0(LineN,Grid,LineNGrid),
    comparee(LineNGrid,LineSolutions,RefinedLine),
    append([LineN],RefinedLine,RefinedLineN),
    append([RefinedLineN],RefinationTotal,RefinedLineSolutions),
    refineSolutions(RestSolutions,Grid,RefinationTotal).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% comparee(+Line,+Solutions,-RefinedLine)
%
% Dada Line y Solutions que son las soluciones para esa línea se devuelve una lista
% con las soluciones en las que coincide lo que tenía la linea.

comparee(_List,[],[]).
comparee(List,[S|Solutions],Refined):-
    compareList(List,S),
    append([S],RefinedList,Refined),
    comparee(List,Solutions,RefinedList).
comparee(List,[_S|Solutions],Refined):-
    comparee(List,Solutions,Refined).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% compareList(+Line,+Solution)
%
% Devuelve true si los elementos que no son variables independientes de Line 
% coinciden con los de Solution, y false en caso contrario.

compareList([],[]).
compareList([L|List],[_S|Solution]):-
    var(L),
    compareList(List,Solution).
compareList([L|List],[S|Solution]):-
    L == S,
    compareList(List,Solution).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% calcLength(+LineSolutions, -LineLength)
%
% Calcula la cantidad de soluciones posibles que hay para las líneas.

calcLength([],0).
calcLength([[_LineN|LineNSol]|RLineSol], LineLength):-
    length(LineNSol, LineNLength),
    calcLength(RLineSol, RLength),
    LineLength is LineNLength + RLength.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% combine(+LineSolutions,-SolvedGrid)
%
% Dadas todas las posibles soluciones de todas las líneas de una grilla, las ordena
% y arma una posible grilla con las soluciones.

combine([],[]).
combine([[_LineN|LineSolutions]|RestSolutions],[X|SolvedGrid]):-
    member(X,LineSolutions),
    combine(RestSolutions,SolvedGrid).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% check(+SolvedGrid, +LineClues, +ActualLine, +LineLength).
%
% Chequea que las líneas de SolvedGrid cumplan con las pistas de LineClues.

check(_SolvedGrid, _LineClues, ActualLine, LineLength):-
    ActualLine == LineLength.
check(SolvedGrid, LineClues, ActualLine, LineLength):-
    nth0(ActualLine, SolvedGrid, LineN), 
    nth0(ActualLine, LineClues, LineCluesN),
    chequearLinea(LineN, LineCluesN, LineSat),
    LineSat == 1,
    ActualLineAux is ActualLine+1,
    check(SolvedGrid, LineClues, ActualLineAux, LineLength).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% makeCombinations(+RowSolutions,+ColSolutions,+RowClues,+RowLength,+ColClues,+ColLength,-SolvedGrid)
%
% Compara las longitudes de RowSolutions y ColSolutions, combina las soluciones del
% que tenga la menor longitud con SolvedGrid y verifica que se chequeen las pistas
% indicadas.

makeCombinations(RRowSolutions,RColSolutions,RowClues,RowLength,_ColClues,_ColLength,TSolvedGrid):-
    calcLength(RRowSolutions, LengthRRowSol), 
    calcLength(RColSolutions, LengthRColSol),
    LengthRRowSol >= LengthRColSol,
    combine(RColSolutions, SolvedGrid),
    transpose(SolvedGrid,TSolvedGrid),
    check(TSolvedGrid, RowClues, 0, RowLength).
makeCombinations(RRowSolutions,_RColSolutions,_RowClues,_RowLength,ColClues,ColLength,SolvedGrid):-
    combine(RRowSolutions, SolvedGrid),
    transpose(SolvedGrid,TsSolvedGrid),
    check(TsSolvedGrid, ColClues, 0, ColLength).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% solveNonogram(+RowLength,+ColLength,+RowClues,+ColClues,-SolvedGrid)
%
% Dadas las pistas de las filas y las columnas, junto con la longitud de las filas y columnas,
% resuelve el nonograma.

solveNonogram(RowLength,ColLength,RowClues,ColClues,SolvedGrid):-
    %Armamos una grilla vacía.
    makeGrid(RowLength,ColLength,Grid),
    
    %Buscamos las posibles soluciones de cada fila/columna.
    findLines(0,RowLength,RowClues,RowSolutions),
    findLines(0,ColLength,ColClues,ColSolutions),
    
    %Ubicamos en la grilla las que tienen una única solución, ya que es la única posibilidad.
    placeSingleSol(RowSolutions,Grid,RGrid),
    transpose(RGrid,TsRGrid),
    placeSingleSol(ColSolutions,TsRGrid,CGrid),
    transpose(CGrid,GridSingleSol),
    
    %Intersectamos las posibles soluciones y guardamos en la grilla las celdas que siempre coinciden.
    intersectSolutions(RowSolutions,RowLength,GridSingleSol,RGridSingleSol),
    transpose(RGridSingleSol,TsGridSingleSol),
    intersectSolutions(ColSolutions,ColLength,TsGridSingleSol,CGridSingleSol),
    transpose(CGridSingleSol,GridIntersected),
        
    %Refinamos las soluciones, descartando las que ya no son posibles.
    refineSolutions(RowSolutions,GridIntersected,RefinedRowSolutions),
    refineSolutions(ColSolutions,CGridSingleSol,RefinedColSolutions),
    
    %Realizamos todas las combinaciones posibles y chequeamos cuál es la correcta.
    makeCombinations(RefinedRowSolutions,RefinedColSolutions,RowClues,RowLength,ColClues,ColLength,SolvedGrid).
