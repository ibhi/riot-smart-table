<smart-table>
  <table>
    <thead>
      <tr>
        <th each={ header, i in headers } onclick="{ colSort }" class = "{ asc: parent.sortState[i].asc }">{ header }</th>
      </tr>
    </thead>
    <tbody>
      <tr each={row in data }>
        <td each={ key, value in row }> { value }</td>
      </tr>
    </tbody>
  </table>

  <script>
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


    textSort(data, order, colHeaderName) {
      return function compare(curr, next) {
        if(order.asc) {
          //asc: true
          return ((curr[colHeaderName] < next[colHeaderName] ) ? -1 : (curr[colHeaderName] > next[colHeaderName] ) ? 1: 0);
        } else {
          //dsc
          return ((curr[colHeaderName] > next[colHeaderName] ) ? -1 : (curr[colHeaderName] < next[colHeaderName] ) ? 1: 0);
        }
      }

    }

    _sort(data, type, order, colIndex) {

      var colHeaderName = this.headers[colIndex];
      var compare;

      if(type === 'text') {
        compare = this.textSort(data, order, colHeaderName);
      }
      data.sort(compare);
    }


    colSort(e) {
      console.log(e);
      var index = e.target.cellIndex;
      var order = this.sortState[index];
      order.asc = !order.asc;
      //reset other columns sort status to false
      this.sortState.forEach(function(col, i) {
        if(index !== i) {
          col.asc = false;
        }
      })
      console.log(this.sortState);
      this._sort(this.data, 'text', order, index );
    }

    // setTimeout(function() {
    //   self._sort(self.data, 'text', 'asc', 0);
    //   self.update();
    //   console.log('Timeout');
    // }, 3000);

  </script>
</smart-table>