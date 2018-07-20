import React from 'react';
import { pure } from '../utils';
import {
  BoardName,
  ToolBox,
  StrategyType,
  StrategyTime,
  MapControls,
  SaveMap
} from '../molecules';
import { UserName, StrategyName, InfoBar, User } from '../atoms';
const MAX_USERS = 5;

const WorkPanel = pure(props => {
  const clients = props.clients
    .slice(0, MAX_USERS)
    .map((xs, index) => (
      <User
        {...xs}
        key={xs.uuid}
        removeUser={() => props.notify('slides', 'KickUser')(xs.uuid)}
        roomSlug={props.slug}
      />
    ));
  return (
    <div className='sidebar-scroller'>
      <div className='sidebar-wrap'>
        <BoardName />
        <div className='team'>{clients}</div>

        <StrategyName name={props.strategyName} />
        <StrategyType strategy={props.strategy} notify={props.notify} />
        <ToolBox
          tools={props.tools}
          notify={props.clientNotify}
          serverNotify={props.notify}
          currentMode={props.currentMode}
        />
        <div className='steps'>
          <InfoBar
            time={props.time}
            strategy={props.strategy}
            notify={props.notify}
            slides={props.slides}
          />
          <MapControls
            slides={props.slides}
            notify={props.notify}
            currentSlide={props.currentSlide}
          />
        </div>
        <SaveMap
          roomSlug={props.slug}
          notify={props.notify}
          name={props.strategyName}
        />
      </div>
    </div>
  );
});

export default WorkPanel;
