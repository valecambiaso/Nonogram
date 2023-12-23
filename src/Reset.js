import React from 'react';

class Reset extends React.Component {

    render() {
        var fondo;
        //Si se esta cargando o mostrando la solución, entonces se muestra como botón deshabilitado,
        //caso contrario, se muestra como botón habilitado.
        if(this.props.loadingSolution||this.props.showingSolution) {
            fondo = " disabledfondo ";
        }else{
            fondo = " fondo ";
        }
        return( 
            //Devuelve el botón.
            <button className={"reset"+fondo+"redo add"} onClick={this.props.onClick}>
            </button>
        );
    }

}

export default Reset;