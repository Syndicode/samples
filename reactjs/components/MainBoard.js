import React from 'react';
import Board from './Board';

const preventDefault = event => event.preventDefault();

export default class MainBoard extends React.Component {
  shouldComponentUpdate(nextProps, _) {
    return !this.props.state.equals(nextProps.state);
  }

  _onDrop = e => {
    this.props.onDrop(this.board, e);
  };

  render() {
    const modes = this.props.state.get('modes');
    const strategy = this.props.state.get('strategy');
    const time = this.props.state.get('time');
    const strategyNote = strategy === 'zero' ? '' : strategy;
    const timeNote = time || '00:00';

    return (
      <main
        className="board-wr"
        onDrop={this._onDrop}
        onDragOver={preventDefault}
      >
        <div className="board">
          <Board
            ref={el => (this.board = el)}
            state={this.props.state}
            modes={modes}
            notify={this.props.notify}
            setCursor={this.props.setCursor}
            onMouseUp={this.props.onMouseUp}
            onMouseDown={this.props.onMouseDown}
            onMouseOut={this.props.onMouseOut}
            onMouseMove={this.props.onMouseMove}
            onMouseWheel={this.props.onMouseWheel}
            finishAnimation={this.props.finishAnimation}
            onClick={this.props.onClick}
          />
          <div className="board__pattern">{strategyNote}</div>
          <div className="board__time">{timeNote}</div>
          <span className="board__watermark">STRATEGY BOARD</span>
        </div>
      </main>
    );
  }
}

