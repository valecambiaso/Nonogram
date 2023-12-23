import React from 'react';
import Square from './Square';
import Clue from './Clue';

class Board extends React.Component {
    render() {
        const numOfRows = this.props.grid.length;
        const numOfCols = this.props.grid[0].length;

        const rowClues = this.props.rowClues;
        const colClues = this.props.colClues;
        
        var biggestRowClue = 0, rowClueCant = 0;
        var biggestColClue = 0, colClueCant = 0;

        //Busca la lista de pistas de la fila con la mayor cantidad de pistas.
        for (let i = 0; i < numOfRows; i++) {
            rowClueCant = rowClues[i].length;
            if (rowClueCant > biggestRowClue) {
                biggestRowClue = rowClueCant;
            }
        }

        //Busca la lista de pistas de la columna con la mayor cantidad de pistas.
        for (let j = 0; j < numOfCols; j++) {
            colClueCant = colClues[j].length;
            if (colClueCant > biggestColClue) {
                biggestColClue = colClueCant;
            }
        }

        //Se arma el tamaño que deben tener los cuadrados de las pistas de las filas en base a la lista de pistas de mayor tamaño.
        let biggestRow = biggestRowClue * 15;

        return (
            <div className="vertical">
                <div
                    className="colClues"
                    style={{
                        
                        gridTemplateRows: '${biggestColClue}px',
                        gridTemplateColumns: biggestRow+'px repeat(' + numOfCols + ', 40px)'
                        /*
                           biggestRow  40px 40px 40px 40px 40px 40px 40px   (gridTemplateColumns)
                          ____________ ____ ____ ____ ____ ____ ____ ____
                         |            |    |    |    |    |    |    |    |  biggestColClue
                         |            |    |    |    |    |    |    |    |  (gridTemplateRows)
                          ------------ ---- ---- ---- ---- ---- ---- ---- 
                         */
                    }}
                >
                    <div>{/* top-left corner square */}</div>
                    {colClues.map((clue, i) =>
                        <Clue clue={clue} key={i} sat={this.props.colSat[i]}/>
                    )}
                </div>
                <div className="horizontal">
                    <div
                        className="rowClues"
                        style={{
                            gridTemplateRows: 'repeat(' + numOfRows + ', 40px)',
                            gridTemplateColumns: biggestRow+'px'
                            /* IDEM column clues above */
                        }}
                    >
                        {rowClues.map((clue, i) =>
                            <Clue clue={clue} key={i} sat={this.props.rowSat[i]}/>
                        )}
                    </div>
                    <div className="board"
                        style={{
                            gridTemplateRows: 'repeat(' + numOfRows + ', 40px)',
                            gridTemplateColumns: 'repeat(' + numOfCols + ', 40px)'
                        }}>
                        {this.props.grid.map((row, i) =>
                            row.map((cell, j) =>
                                <Square
                                    value={cell}
                                    onClick={() => this.props.onClick(i, j)}
                                    key={i + j}
                                    row={i}
                                    col={j}
                                />
                            )
                        )}
                    </div>
                </div>
            </div>
        );
    }
}

export default Board;