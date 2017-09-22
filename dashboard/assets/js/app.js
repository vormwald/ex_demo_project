// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

import Chart from 'chart.js';
export var App = {
  run: function(){
    Greet.greet()
  }
}
var ctx = document.getElementById("myChart");
var data = {
  labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
  datasets: [{
    fill: false,
    label: 'jeff',
    data: [12, 19, 3, 5, 2, 3],
    color: 'blue',
    backgroundColor: [
      'yellow',
    ],
    borderColor: 'blue',
    borderWidth: 2
  },
    {fill: false,
    label: 'mike',
    data: [12, 19, 3, 5, 2, 3].reverse(),
    color: 'red',
    backgroundColor: [
      'black'
    ],
    borderColor: 'red',
    borderWidth: 2
  },
  ]
};
var myLineChart = new Chart(ctx, {
    type: 'line',
    data: data,
    // options: options
});

