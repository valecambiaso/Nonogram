import React from 'react';

class SolverButton extends React.Component {

    render() {
        var fondo;
        //Si se esta cargando la solución, entonces se muestra como botón deshabilitado,
        //caso contrario, se muestra como botón habilitado.
        if(this.props.loadingSolution) {
            fondo = " disabledfondo ";
        }else{
            fondo = " fondo ";
        }
        return (
            <button className = {"button"+fondo+"solver add"} onClick={this.props.onClick}>
            </button>
        );
    } 

}

export default SolverButton;