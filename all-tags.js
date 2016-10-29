riot.tag2('my-tag', '<h3>Tag layout</h3> <inner-tag></inner-tag>', '', '', function(opts) {
});
riot.tag2('smart-table', '<table> <thead> <tr> <th each="{header, i in headers}" onclick="{colSort}" class="{asc: parent.sortState[i].asc}">{header}</th> </tr> </thead> <tbody> <tr each="{row in data}"> <td each="{key, value in row}"> {value}</td> </tr> </tbody> </table>', '', '', function(opts) {
    var self = this;
    this.data = opts.data;
    console.log(this.data);
    this.headers = Object.keys(this.data[0]);

    this.options = {
      columnDefs: [{
        target: 0,
        sortable: true,
        type: 'text'
      }]
    };

    this.sortState = [];

    this.headers.forEach(function() {
      this.sortState.push({asc: false});
    }, this);

    this.textSort = function(data, order, colHeaderName) {
      return function compare(curr, next) {
        if(order.asc) {

          return ((curr[colHeaderName] < next[colHeaderName] ) ? -1 : (curr[colHeaderName] > next[colHeaderName] ) ? 1: 0);
        } else {

          return ((curr[colHeaderName] > next[colHeaderName] ) ? -1 : (curr[colHeaderName] < next[colHeaderName] ) ? 1: 0);
        }
      }

    }.bind(this)

    this._sort = function(data, type, order, colIndex) {

      var colHeaderName = this.headers[colIndex];
      var compare;

      if(type === 'text') {
        compare = this.textSort(data, order, colHeaderName);
      }
      data.sort(compare);
    }.bind(this)

    this.colSort = function(e) {
      console.log(e);
      var index = e.target.cellIndex;
      var order = this.sortState[index];
      order.asc = !order.asc;

      this.sortState.forEach(function(col, i) {
        if(index !== i) {
          col.asc = false;
        }
      })
      console.log(this.sortState);
      this._sort(this.data, 'text', order, index );
    }.bind(this)

});