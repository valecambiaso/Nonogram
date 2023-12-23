import React from 'react';

class Square extends React.Component {

    render() {

        var pintar;
        //Si la suma de las coordenadas de el cuadrado en el tablero es 1, pintar es 1, caso contrario es 0. 
        //Con esto se define el color que debe tomar el cuadrado en el tablero.
        if(((this.props.row + this.props.col) % 2) === 1){
            pintar = "impar"
        }else{
            pintar = "par"
        }
        //Se definen los diferentes nombres de clase que pueden tomar los cuadrados.
        const className = pintar + " square";
        const classNameHashtagAnimation = className + "  hashtag add animated ";
        const classNameXAnimation = className + "  x add animated ";

        return (
            <button className={this.props.value === '#' ? classNameHashtagAnimation : (this.props.value === 'X'? classNameXAnimation : className)} onClick={this.props.onClick}>
            </button>
        );
    }
}

export default Square;