import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import Button from './Button';
import Reset from './Reset';
import DropdownMenu from './DropdownMenu';
import IdeaButton from './IdeaButton';
import SolverButton from './SolverButton';

class Game extends React.Component {

  pengine;

  constructor(props) {
    super(props);
    this.state = {
      grid: null,
      rowClues: null,
      colClues: null,
      selected: "#",
      waiting: false,
      rowSat: [],
      colSat: [],
      stateGame:'Keep playing!',
      cantRowsInit: 5,
      cantColsInit: 5,
      solvedGrid: null,
      inGameGrid: null,
      inGameRowSat: [],
      inGameColSat: [],
      showingSolution: false,
      showingHint: false,
      inGameStateGame: 'Keep playing!',
      loadingSolution: true
    };
    this.handleClick = this.handleClick.bind(this);
    this.handlePengineCreate = this.handlePengineCreate.bind(this);
    this.pengine = new PengineClient(this.handlePengineCreate);
  }

  //Define el estado de selected.
  setSelected() {
    if (this.state.waiting || this.state.showingSolution) {
      return;
    }

    var s;
    //Se modifican "#" por "X" y viceversa.
    if(this.state.selected === "#"){
      s = "X";
    }else{
      s = "#";
    }
    this.setState({
      selected: s
    })
  }

  //Controla si se cumplen las pistas al haberse iniciado el juego.
  controlarInicial() {
    const squaresS = JSON.stringify(this.state.grid).replaceAll('_',"_"); //Reemplazo cada aparición de '_' por "_"
    const rC = JSON.stringify(this.state.rowClues);
    const cC = JSON.stringify(this.state.colClues);
    const queryS = 'initCheck('+ squaresS +','+ rC +','+ cC +',RowsSat, ColsSat)';
    this.pengine.query(queryS,(success, response) => {
    if(success) {
      this.setState({
        colSat: response['ColsSat'],
        rowSat: response['RowsSat'],
        loadingSolution: true
      });
    }});
  }
    
  //Chequea si se ganó el juego.
  checkWin() {
    var win = 1;
    //Se recorren todas las filas viendo si se cumplen las pistas en cada una.
    for (let i = 0; i < this.state.rowSat.length && win === 1; i++) {
      if(this.state.rowSat[i] !== 1){
        win = 0;
      }
    } 
    //Se recorren todas las columnas viendo si se cumplen las pistas en cada una.
    for (let j = 0; j < this.state.colSat.length && win === 1; j++) {
      if(this.state.colSat[j] !== 1){
        win = 0;
      }
    }
    //Se modifica el estado de stateGame dependiendo si se ganó o no.
    if(win === 1){ //En caso de que win sea 1 se ganó el juego.
      this.setState({ 
        stateGame: 'You won!'
      });
    }else{
      this.setState({
        stateGame: 'Keep playing!'
      });
    }
  }

  //Muestra el tablero resuelto.
  solveNonogram(){
    if (this.state.waiting) {
      return;
    }
    
    if(!this.state.showingSolution){
    const SGrid = this.state.solvedGrid;
    const inGameGrid = this.state.grid;
    const inGameRowSat = [...this.state.rowSat];
    const inGameColSat = [...this.state.colSat];
    let rowSat1 = [...this.state.rowSat];
    let colSat1 = [...this.state.colSat];
    rowSat1.fill(1);
    colSat1.fill(1);

    this.setState({
      grid: SGrid,
      inGameGrid: inGameGrid,
      rowSat: rowSat1,
      inGameRowSat: inGameRowSat,
      colSat: colSat1,
      inGameColSat: inGameColSat,
      stateGame: 'Showing solutions',
      inGameStateGame: this.state.stateGame,
      showingSolution: true
    })
    }else{
      this.setState({
        grid: this.state.inGameGrid,
        rowSat: this.state.inGameRowSat,
        colSat: this.state.inGameColSat,
        stateGame: this.state.inGameStateGame,
        showingSolution: false
      })
    }
  }

  //Muestra una pista en el tablero.
  showClue(){
    if (this.state.waiting || this.state.showingSolution) {
      return;
    }
    this.setState({
      showingHint: true,
      stateGame: "Click on a square to see a hint!"
    })

  }

  //Inicializa el tablero.
  handlePengineCreate() {
    //No se producen acciones al hacer click si se está esperando o mostrando la solución.
    if (this.state.waiting || this.state.showingSolution) {
      return;
    }

    const queryS = 'initSize(' + this.state.cantRowsInit +','+ this.state.cantColsInit + ', PistasFilas, PistasColumns, Grilla)';
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          stateGame: 'Keep playing!',
          grid: response['Grilla'],
          rowClues: response['PistasFilas'],
          colClues: response['PistasColumns'],
          rowSat: [],
          colSat: [],
          solvedGrid: null, 
          inGameGrid: null,
          inGameRowSat: [],
          inGameColSat: [],
          waiting: true,
          showingHint:false,
          showingSolution:false
        });
        this.controlarInicial(); //Se controla si se cumplen las pistas al comienzo.
        //Resuelve el nonograma.
        const rC = JSON.stringify(this.state.rowClues);
        const cC = JSON.stringify(this.state.colClues);
        const querySolution = 'solveNonogram('+ this.state.cantColsInit +','+ this.state.cantRowsInit +','+ rC +','+ cC +',SolvedGrid)';
        this.pengine.query(querySolution,(successSol, responseSol) => {
        if(successSol) {
          this.setState({
            solvedGrid: responseSol['SolvedGrid'],
            waiting: false,
            loadingSolution: false
          });
        }
        });
      }
    });
  }

  //Modifica el estado de cantRowsInit y cantColsInit con los valores obtenidos y se actualiza el tablero.
  selectBoard(cantRows,cantCols){
    //No se producen acciones al hacer click si se está esperando o mostrando la solución.
    if (this.state.waiting || this.state.showingSolution) {
      return;
    }

    this.setState({
      cantRowsInit: cantRows,
      cantColsInit: cantCols,
      waiting: false
    }, () => 
    this.handlePengineCreate())
  }

  handleClick(i, j) {
    //No se producen acciones al hacer click si se está esperando o mostrando la solución.
    if (this.state.waiting || this.state.showingSolution) {
      return;
    }

    const squaresS = JSON.stringify(this.state.grid).replaceAll('_',"_"); //Reemplazo cada aparición de '_' por "_"
    const rC = JSON.stringify(this.state.rowClues);
    const cC = JSON.stringify(this.state.colClues);
    let sel;
    const actualSquare = JSON.stringify(this.state.grid[i][j]);
    if(this.state.showingHint){
      if(actualSquare === '"_"'){
        sel = JSON.stringify(this.state.solvedGrid[i][j]);
      }else{
        this.setState({
          stateGame: 'Keep playing!',
          showingHint: false
        });
        return;
      }
    }else{
      sel = JSON.stringify(this.state.selected);
    }

    //Realiza una consulta a put (predicado en Prolog) con el valor de selected y en el cuadrado(i,j).
    const queryS = 'put('+sel+', ['+i+','+j+'],'+rC+','+cC+','+squaresS+', GrillaRes, FilaSat, ColSat)';
    this.setState({
      waiting: true,
      showingHint:false
    });
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        //Copia el valor de rowSat en rowS
        var rowS = [...this.state.rowSat];
        //Actualiza si satisface o no las pistas la fila i
        rowS[i] = response['FilaSat'];
        //Copia el valor de colSat en colS
        var colS = [...this.state.colSat];
        //Actualiza si satisface o no las pistas la columna j
        colS[j] = response['ColSat'];
        //Actualiza el estado de Game.
        this.setState({
          grid: response['GrillaRes'],
          rowSat: rowS,
          colSat: colS,
          waiting: false
        });
        //Chequea si se ganó el juego.
        this.checkWin();
      } else {
        this.setState({
          waiting: false
        });
      }
    });
  }

  render() {
    if (this.state.grid === null) {
      return null;
    }
    return (
      <div className="game">
        <div className="gameInfo">
          {this.state.stateGame}
        </div>
        <Board
          grid={this.state.grid}
          rowClues={this.state.rowClues}
          colClues={this.state.colClues}
          onClick={(i, j) => this.handleClick(i,j)}
          rowSat={this.state.rowSat}
          colSat={this.state.colSat} 
        />
        <div className="botones">
          <div className="button">
            <Button
              showingSolution = {this.state.showingSolution}
              loadingSolution = {this.state.loadingSolution}
              onClick={() => this.setSelected()}
              selected = {this.state.selected}
            />
          </div>
          <div className="reset">
            <Reset
              showingSolution = {this.state.showingSolution}
              loadingSolution = {this.state.loadingSolution}
              onClick={() => this.handlePengineCreate()}
            />
          </div>
          <div className="idea">
            <IdeaButton
              showingSolution = {this.state.showingSolution}
              loadingSolution = {this.state.loadingSolution}
              onClick={() => this.showClue()}
            />
          </div>
          <div className="solver">
            <SolverButton
              loadingSolution = {this.state.loadingSolution}
              onClick={() => this.solveNonogram()}
            />
          </div>
        </div>
        <div className="menu">
          <DropdownMenu
            showingSolution = {this.state.showingSolution}
            loadingSolution = {this.state.loadingSolution}
            onClick={(cantRows,cantCols) => this.selectBoard(cantRows,cantCols)}
          />
        </div>
      </div>
    );
  }
}

export default Game;