import "phoenix_html";
import {h, render, Component} from "preact";
import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });


class App extends Component {
  render() {
    return (
      <div className="grid-container">
        <h1>Hello</h1>
      </div>
    );
  }
}

render(<App />, document.querySelector("main"));