import "phoenix_html"
import socket from "./socket"
import Chart from 'chart.js'
import Dashboard from "./dashboard"

let App = {
  init(){
    this.el = document.getElementById("myChart");
    this.chart = new Dashboard(this.el)
    this.chart.init()
  },
};

App.init();

