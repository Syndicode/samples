import React from 'react';
import { authorizedRequest, redirect } from '../../app/services';
import { AccountSidebar } from '../shapes';

export default class AccountScreen extends React.Component {
  _onClick = e => this._handleClick(e);

  _handleClick(e) {
    authorizedRequest('/api/rooms', 'POST')
      .then(response => response.json())
      .then(body => {
        if (body.id) {
          redirect('/rooms/' + body.id);
        } else {
          window.localStorage.removeItem('currentUser');
          redirect('/login');
        }
      });
  }

  render() {
    return (
      <div className="wrapper account bg-gradient">
        <div className="page__container">
          <div className="page__title">Strategy board</div>
          <div className="page__form">
            <button className="btn account__add-room" onClick={this._onClick}>
              ADD NEW BOARD
            </button>
          </div>
        </div>
        <AccountSidebar />
      </div>
    );
  }
}
