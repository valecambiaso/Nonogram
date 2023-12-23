import React from 'react';

class Button extends React.Component {

    render() {
        var s;
        //Si el seleccionado es un '#', el boton muestra una 'X', que es lo que se puede seleccionar luego. 
        //Caso contrario, está seleccionada la 'X' y muestra el '#'.
        if(this.props.selected === '#'){
            s = " xButton add";
        }else{
            s = " hashtagButton add";
        }
        var fondo;
        //Si se esta cargando o mostrando la solución, entonces se muestra como botón deshabilitado,
        //caso contrario, se muestra como botón habilitado.
        if(this.props.loadingSolution||this.props.showingSolution) {
            fondo = " disabledfondo ";
        }else{
            fondo = " fondo ";
        }
        return (
            <button className={"button"+fondo+" "+s} onClick={this.props.onClick}>
            </button>
        );
    } 

}

export default Button;