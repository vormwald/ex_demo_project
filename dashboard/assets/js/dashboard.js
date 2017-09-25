import moment from 'moment'

export default class Dashboard {

    constructor(el){
      if(!el){ throw new Error('Must pass in a container element') }

      this.el = el
    }

    addData(number, node) {
      this.chart.data.labels.push(moment().format("h:mm:ss SS"))

      let index = this.chart.data.datasets.findIndex((d) => { return node[0].startsWith(d.label) })
      this.chart.data.datasets[index].data.push(number)

      this.chart.update();
    }

    init(){
      let data = {
        labels: [],
        datasets: [{
          fill: false,
          label: 'jeff',
          data: [],
          color: 'blue',
          backgroundColor: [
            'blue',
          ],
          borderColor: 'blue',
          borderWidth: 2
        },
        {
          fill: false,
          label: 'mike',
          data: [],
          color: 'red',
          backgroundColor: [
            'red'
          ],
          borderColor: 'red',
          borderWidth: 2
        },
        ]
      };
      // TODO set scale from 0 - 6

      this.chart = new Chart(this.el, {
        type: 'line',
        data: data,
        // options: options
      });

      this.el.addEventListener('updateChart', (e) =>{
        this.addData(e.detail.number, e.detail.from)
      }, false)
    }
};
