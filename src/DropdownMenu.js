import React from 'react';

class DropdownMenu extends React.Component {

  constructor() {
    super();
    this.state = { //El menu tiene un estado que indica si deben mostrarse o no las opciones.
      showMenu: false,
    };
    this.showMenu = this.showMenu.bind(this);
    this.closeMenu = this.closeMenu.bind(this);
  }

  //Indica al estado del menu que debe mostrarse.
  showMenu() {
    this.setState({ showMenu: true });
  }

  //Indica al estado del menu que no debe mostrarse.
  closeMenu() {
    this.setState({ showMenu: false });
  }

  render() {
    var fondo;
    //Si se esta cargando o mostrando la solución, entonces se muestra el botón y sus opciones como deshabilitados,
    //caso contrario, se muestran como botones habilitados.
    if(this.props.loadingSolution||this.props.showingSolution) {
        fondo = "disabledbuttonSelect ";
    }else{
        fondo = "buttonSelect ";
    }
    return (
      <div>
        <button className= {fondo+"flecha add"} onClick={this.showMenu}>
          Select board
        </button>

        {
          this.state.showMenu //En caso de que se deba mostrar el menu.
            //Se muestran 3 botones, cada uno con una posible dimensión para el tablero
            //Luego de hacer click en alguno de ellos, se cierra el menu.
            ? (
              <div
                className="menu"
              > 
                <button className={fondo} onClick={()=>{
                  this.props.onClick(5,5);
                  this.closeMenu()
                }}> 5x5 </button>
                <button className={fondo} onClick={()=>{
                  this.props.onClick(6,7);
                  this.closeMenu()
                }}> 6x7 </button>
                <button className={fondo} onClick={()=>{
                  this.props.onClick(10,10);
                  this.closeMenu()
                }}> 10x10 </button>
              </div>
            )
            : (
              null
            )
        }
      </div>
    );
  }
}

export default DropdownMenu;