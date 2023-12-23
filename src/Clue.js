import React from 'react';

class Clue extends React.Component {

    render() {
        const clue = this.props.clue;
        const sat = this.props.sat;
        return (
            //Modifica la gráfica de las pistas dependiendo si se satisfacen o no.
            <div className={sat===1?"satClue animated":"clue animated"} >
                {clue.map((num, i) =>
                    <div key={i}>
                        {num}
                    </div>
                )}
            </div>
        );
    }

}

export default Clue;